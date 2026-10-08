/*
Parametric belting generator, including straights, loops, and spirals, by Jeff Hertzberg
Derived from:
http://www.thingiverse.com/thing:19758 by The DoomMeister
http://www.thingiverse.com/thing:16627 by Droftarts
https://www.youmagine.com/designs/parametric-timing-belt-generator

LICENSE: Creative Commoons - Attribution-ShareAlike 3.0 Unported

belting
 Use: Generates belting in several standard tooth profiles.
 Arguements:
    print_layout (required) - how the belt will be arranged on the print surface. 
        Current valid values: 
            straight, (straight belt segment)
            loop, (closed loop with teeth on inner side of loop)
            loop_inner, (same as loop)
            loop_outer, (closed loop with teeth on outer side of loop)
            loop_match, (closed loop with teeth mirrored on both sides of loop)
            loop_offset, (closed loop with teeth on both sides of loop, offset by half a tooth)
            spiral. (belt spiraling inward from maximum_diameter with teeth on the inner side)
            folded_loop. (closed belt with automatic circular or spiral/arc packing)
            
    tooth_profile (required) - shape of tooth. Only use profiles where the tooth form module is defined.
        Current valid values: 
            MXL, 
            T2.5, 
            T5, 
            T10, 
            GT2_2mm, 
            GT2_3mm, 
            GT2_5mm, 
            AT5, 
            HTD_3mm, 
            HTD_5mm, 
            HTD_8mm, 
            40DP, 
            XL, 
            L
            
    tooth_count (alternate) - total belt length measured in number of teeth. If specified, then belt_length is ignored.
    belt_length (alternate) - total belt length in mm, increased to next multiple of tooth pitch if necessary.
    
    belting_width (optional) - Override default width for the belt in mm.
    
    backing_thickness (optional) - Override default mm of belt backing behind tooth profile.
    
    max_diameter (optional) - Maximum diameter for loops and spirals. Default is 200mm.

    folded_loop options (ignored by legacy layouts): explicit max_size wins
    over printer preset, then [max_diameter,max_diameter]. Radius and gap use
    automatic packing defaults when undef. length_tolerance=0.01;
    geometry_tolerance=0.02; allow_rotate=true; solver_quality="normal".
    New options are appended to preserve positional calls. Dimensions are mm.
    The reference path is the tooth-root baseline, not a calibrated neutral axis.
*/


use <folded_loop.scad>
use <profiles.scad>
use <printer_presets.scad>

$fa = 2; // Try increasing this number if rendering of curves is unusably slow.

// Set maximum_diameter to the shorter of your x or y axis.
// It is used to limit length of straights and diameter of loops and spirals.
maximum_diameter = 200;	

// Tooth profile default values chosen from belts offered in catalog pages at http://sdp-si.com
// Tooth profile defaults are ordered: tooth_profile, tooth_pitch, back_thickness, belt_width
tooth_profile_defaults = belt_profiles();

//Examples
// Rendering speeds are a function of the number and complexity of teeth, and the print layout, and they increase exponentially.

// belting("spiral", "GT2_2mm", belt_length = 100);
// belting("loop_match","T5", tooth_count = 40 );
// belting("loop","MXL", tooth_count = 298 );
// belting("straight","T10", belt_length = 150, belting_width = 25 );


// By Default this will Render as a 3d object.  If you'd like export it as a DXF you can uncomment out thef following line
//projection() // UnComment this line to render as 2d for exporting as DXF
belting("loop", "XL", tooth_count = 35, belting_width = 6.35);
// ^---Edit this line to set parameters

module belting(

	print_layout = undef, 
	tooth_profile = undef, 
	tooth_count = undef, 
	belt_length = undef, 
	belting_width = undef, 
	backing_thickness = undef, 
	max_diameter = maximum_diameter,
    max_size = undef,
    min_bend_radius = undef,
    min_track_gap = undef,
    length_tolerance = 0.01,
    geometry_tolerance = 0.02,
    printer = undef,
    allow_rotate = true,
    solver_quality = "normal")
{

    // Resolve profile dimensions once; preserve the existing positional API.
    profile = get_profile(tooth_profile);
    profile_name = profile[0];
    tooth_pitch = profile[1];
    belt_width = assert(print_layout!="folded_loop" || is_undef(belting_width) || fl_positive(belting_width),
        "belting_width must be finite and positive, or undef")
        is_undef(belting_width) ? profile[3] : belting_width;
    back_thickness = assert(print_layout!="folded_loop" || is_undef(backing_thickness) || fl_positive(backing_thickness),
        "backing_thickness must be finite and positive, or undef")
        is_undef(backing_thickness) ? profile[2] : backing_thickness;
    if (print_layout == "folded_loop") {
        assert(profile_name != "belt", "folded_loop requires a toothed belt profile");
        size = resolved_printer_size(max_size, printer, max_diameter);
        gap = assert(is_undef(min_track_gap) || (fl_finite(min_track_gap)&&min_track_gap>=0),
            "min_track_gap must be finite and nonnegative, or undef")
            is_undef(min_track_gap) ? 2 : min_track_gap;
        envelope = max(tooth_radius(profile_name),back_thickness);
        radius = is_undef(min_bend_radius) ? packing_radius(tooth_pitch,envelope,gap) : min_bend_radius;
        quality = is_undef(solver_quality) ? "normal" : solver_quality;
        echo(str("Configuration: profile=",profile_name,"; pitch=",tooth_pitch,
            "; width=",belt_width,is_undef(belting_width)?" (profile default)":" (explicit)",
            "; backing=",back_thickness,is_undef(backing_thickness)?" (profile default)":" (explicit)",
            "; area=",size,!is_undef(max_size)?" (explicit)":!is_undef(printer)?str(" (",printer," preset)"):" (max_diameter)",
            "; radius=",radius,is_undef(min_bend_radius)?" (automatic packing default)":" (explicit)",
            "; gap=",gap,"; search=",quality));
        folded_loop_belt(tooth_pitch,tooth_radius(profile_name),tooth_root_depth(profile_name),
            tooth_count,belt_length,belt_width,back_thickness,size,
            radius,gap,length_tolerance,geometry_tolerance,allow_rotate,quality)
            belt_tooth(profile_name,belt_width);
    } else {
    belt_defaults = profile;
	tooth_cnt = tooth_count == undef ? ceil(belt_length/tooth_pitch) : tooth_count;

	if ( belt_defaults == undef ) {
		echo(str("ERROR: Empty or invalid tooth_profile in belting module: ", tooth_profile));
	}
	else if( tooth_cnt == undef || tooth_cnt <= 0 ) {
		echo(str("ERROR: Invalid belt_length and/or tooth_count in belting module."));
	}
	else if( belt_width == undef || belt_width <= 0 ) {
		echo(str("ERROR: Invalid belt_width in belting module: ", belt_width));
	}
	else if( back_thickness == undef || back_thickness <= 0 ) {
		echo(str("ERROR: Invalid back_thickness in belting module: ", back_thickness));
	}
	else if( max_diameter == undef || max_diameter <= 0 ) {
		echo(str("ERROR: Invalid max_diameter in belting module: ", max_diameter));
	}

	// Inputs validated (except for layout).
	else {

		echo(str("Generating a ", print_layout, " of ", tooth_profile, " belt with ", tooth_cnt, " teeth, ", 
			tooth_cnt*tooth_pitch, "mm long, ", belt_width, "mm wide and ", back_thickness, "mm thick." ));
	
		if( print_layout == "straight") {	// Straight belt
			straight_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter)
				belt_tooth(profile_name, belt_width);
            
		} else if( print_layout == "loop" ||
            print_layout == "loop_inner" ||
            print_layout == "loop_outer" ||
            print_layout == "loop_match" ||
            print_layout == "loop_offset" 
        ) {	// Closed loop

			loop_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter-(back_thickness*2), print_layout)
				belt_tooth(profile_name, belt_width);
            
		} else if( print_layout == "spiral") {	// Spiral belt (to fit more belt on the bed than with straight)
			spiral_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter-(back_thickness*2))
				belt_tooth(profile_name, belt_width);
		} else {
			echo("ERROR: Invalid print_layout. Valid layouts: straight, loop, loop_inner, loop_outer, loop_match, loop_offset, spiral, folded_loop.");
		}
	}
                   
}

}

module straight_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter)
{
	if( tooth_pitch * tooth_cnt > max_diameter ) {
		echo(str("WARNING: Straight belt is ", tooth_pitch * tooth_cnt, 
			"mm long. If not be printable on your printer, try spiral." ));
	}

	union() {
		translate([-tooth_pitch/2,-back_thickness,0])cube([tooth_pitch*tooth_cnt,back_thickness,belt_width]);
		for( i = [0:tooth_cnt-1]) {
			translate([tooth_pitch*i,0,0]) children(0);
		}
	}
}

module loop_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter, print_layout)
{
	radius = tooth_cnt * tooth_pitch / PI / 2;
	
	if( (radius + back_thickness) * 2 > max_diameter ) {
		echo(str("WARNING: Loop belt diameter is ", (radius + back_thickness) * 2, "mm. May not be printable." ));
	}

    if(print_layout == "loop" || print_layout == "loop_inner") {
        union() {
            render(convexity = 2) difference() {
                cylinder (h = belt_width, r=radius+back_thickness);
                cylinder (h = belt_width, r=radius);
            }
            for( i = [0:tooth_cnt-1]) {
                rotate(i/tooth_cnt*360)translate([0,-radius,0]) children(0);
            }
        }
    }

    if(print_layout == "loop_outer") {
        union() {
            render(convexity = 2) difference() {
                cylinder (h = belt_width, r=radius);
                cylinder (h = belt_width, r=radius-back_thickness);
            }
            for( i = [0:tooth_cnt-1]) {
                rotate(i/tooth_cnt*360)translate([0,-radius,0]) rotate([0,0,180]) children(0);
            }
        }
    }

    if(print_layout == "loop_match") {
        union() {
            render(convexity = 2) difference() {
                cylinder (h = belt_width, r=radius+back_thickness);
                cylinder (h = belt_width, r=radius);
            }
            for( i = [0:tooth_cnt-1]) {
                rotate(i/tooth_cnt*360)translate([0,-radius,0]) children(0);
                rotate(i/tooth_cnt*360)translate([0,-radius-back_thickness,0]) rotate([0,0,180]) children(0);
            }
        }
    }

    if(print_layout == "loop_offset") {
        union() {
            render(convexity = 2) difference() {
                cylinder (h = belt_width, r=radius+back_thickness);
                cylinder (h = belt_width, r=radius);
            }
            for( i = [0:tooth_cnt-1]) {
                rotate(i/tooth_cnt*360) translate([0,-radius,0]) children(0);
                rotate((i+0.5)/tooth_cnt*360) translate([0,-radius-back_thickness,0]) rotate([0,0,180]) children(0);
            }
        }
    }
}

module spiral_belt(tooth_cnt, tooth_pitch, back_thickness, belt_width, max_diameter, rot_angle = 0)
{
	max_radius = max_diameter/2;
	radius = sqrt(pow(max_radius,2) - (tooth_cnt * tooth_pitch * 2)); 
	next_radius = sqrt(pow(max_radius,2)-((tooth_cnt - 1) * tooth_pitch * 2));
	rad_diff = next_radius - radius;
	angle = atan(tooth_pitch/radius);

	if(tooth_cnt > 0)
	{
		union() {
			spiral_belt((tooth_cnt-1), tooth_pitch, back_thickness, belt_width, max_diameter, angle+rot_angle) children(0);
			rotate(rot_angle) translate([0,-radius,0]) {
				translate([0,-rad_diff/2,0]) rotate(-atan(rad_diff/tooth_pitch)) children(0);
				translate([-tooth_pitch/2,0,0]) rotate(-atan(rad_diff/tooth_pitch)) linear_extrude(belt_width)
					polygon([[-rad_diff,0],[-(rad_diff*back_thickness/2),-back_thickness],[tooth_pitch+(rad_diff*back_thickness/2),-back_thickness],[tooth_pitch,0]]);
			}
		}
	}
}

module belt_tooth(tooth_profile = undef, belt_width = undef)
{
	if( tooth_profile == "T2.5" ) {T2_5(width = belt_width);}
	else if( tooth_profile == "T5" ) {T5(width = belt_width);}
	else if( tooth_profile == "T10" ) {T10(width = belt_width);}
	else if( tooth_profile == "MXL" ) {MXL(width = belt_width);}
	else if( tooth_profile == "GT2_2mm" ) {GT2_2mm(width = belt_width);}
	else if( tooth_profile == "GT2_3mm" ) {GT2_3mm(width = belt_width);}
	else if( tooth_profile == "GT2_5mm" ) {GT2_5mm(width = belt_width);}
	else if( tooth_profile == "AT5" ) {AT5(width = belt_width);}
	else if( tooth_profile == "HTD_3mm" ) {HTD_3mm(width = belt_width);}
	else if( tooth_profile == "HTD_5mm" ) {HTD_5mm(width = belt_width);}
	else if( tooth_profile == "HTD_8mm" ) {HTD_8mm(width = belt_width);}
	else if( tooth_profile == "40DP" ) {DP40(width = belt_width);}
	else if( tooth_profile == "XL" ) {XL(width = belt_width);}
	else if( tooth_profile == "L" ) {L(width = belt_width);}
	else if( tooth_profile == "belt" ) {}
	else echo("INTERNAL ERROR: Missing tooth_profile module detected by belt_tooth module.");
}

// Tooth forms taken from http://www.thingiverse.com/thing:16627
// Much credit to Droftarts for deriving the tooth profile polygons.

module T2_5(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("T2.5"));
}

module T5(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("T5"));
}

module T10(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("T10"));
}

module MXL(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("MXL"));
}

module GT2_2mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("GT2_2mm"));
}

module GT2_3mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("GT2_3mm"));
}

module GT2_5mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("GT2_5mm"));
}



module AT5(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("AT5"));
}

module HTD_3mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("HTD_3mm"));
}

module HTD_5mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("HTD_5mm"));
}

module HTD_8mm(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("HTD_8mm"));
}

module DP40(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("40DP"));
}

module XL(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("XL"));
}

module L(width = 2)
{
	linear_extrude(height=width) polygon(tooth_points("L"));
}
