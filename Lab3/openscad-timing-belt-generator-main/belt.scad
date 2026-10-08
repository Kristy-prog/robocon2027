// Compact closed timing belt. Select a saved preset or use the Customizer.
use <scad-parametric-timing-belt-generator/timing_belt_generator.scad>

/* [Belt] */
// Canonical profile names; pitch comes from the selected profile.
tooth_profile = "HTD_5mm"; // [GT2_2mm,GT2_3mm,GT2_5mm,HTD_3mm,HTD_5mm,HTD_8mm,T2.5,T5,T10,AT5,MXL,40DP,XL,L]
length_mode = "teeth"; // [teeth,length]
tooth_count = 138;
belt_length = 1270;
// Zero means use the profile default; direct library calls use undef.
belting_width = 10;
backing_thickness = 0;

/* [Printer] */
printer = "Bambu_A1_mini"; // [Bambu_A1_mini,Bambu_A1,Bambu_P1P,Bambu_P1S,Bambu_P2S,Bambu_X1,Bambu_X1C,Bambu_X1E,Bambu_H2S,Bambu_H2D,Bambu_H2D_Pro,Bambu_H2C,Custom]
use_custom_size = false;
custom_width = 170;
custom_depth = 170;

/* [Advanced] */
// Zero uses the automatic packing radius (not a material qualification).
min_bend_radius = 0;
// Negative one selects the automatic 2 mm gap; zero is an explicit zero gap.
min_track_gap = -1;
allow_rotate = true;
solver_quality = "normal"; // [fast,normal,high]
length_tolerance = 0.01;
geometry_tolerance = 0.02;

/* [Hidden] */
$fa = 2;
assert(length_mode=="teeth"||length_mode=="length","Unknown length mode");
assert(belting_width>=0&&backing_thickness>=0&&min_bend_radius>=0&&min_track_gap>=-1,"Invalid automatic/override value");
belting(
    print_layout = "folded_loop",
    tooth_profile = tooth_profile,
    tooth_count = length_mode=="teeth"?tooth_count:undef,
    belt_length = length_mode=="length"?belt_length:undef,
    belting_width = belting_width==0?undef:belting_width,
    backing_thickness = backing_thickness==0?undef:backing_thickness,
    printer = printer=="Custom"?undef:printer,
    max_size = use_custom_size||printer=="Custom"?[custom_width,custom_depth]:undef,
    min_bend_radius = min_bend_radius==0?undef:min_bend_radius,
    min_track_gap = min_track_gap==-1?undef:min_track_gap,
    allow_rotate = allow_rotate,
    solver_quality = solver_quality,
    length_tolerance = length_tolerance,
    geometry_tolerance = geometry_tolerance
);
