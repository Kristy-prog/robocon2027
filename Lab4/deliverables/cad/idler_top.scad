include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <htd-pulley.scad>

$fn = 64;

n5065_motor_diameter = 50.4;
carriage_dim = [20, 40, 10];
// mount_wall_thickness = 6;
mount_tube_od = 25;
mount_tube_clearance = 0.4;


belt_width = 10;
idler_bearing_od = 8;
idler_bearing_id = 3;
idler_bearing_h  = 4;

lift_tube_od = 10;
lift_tube_clearance = 0.4;
rail_screw_diameter = 3;
heatinsert_diameter = 3.8;
heatinsert_legth = 4;

pulley_teeth = 34;
pulley_pitch = 5.0;

plate_length = 70;
plate_thickness = 4;
plate_height = 60;

pulley_thickness = 1.5*2 + belt_width + 1.5;
plate_spacing = pulley_thickness + 6;

base_length = 40;
base_width = plate_spacing + 2*plate_thickness + 10;
base_thickness = 5;

// ===== 齒輪 =====
module idler_pulley() {
    xrot(90)
        htd_pulley(
            type            = "5M",
            teeth           = pulley_teeth,
            belt_width      = belt_width,
            bore_d          = 4.2,
            d_flat          = 4.2,
            hub_d           = 0,
            hub_h           = 0,
            flange_thickness = 1.5,
            flange_overhang  = 1.5,
            set_screw_d     = 0,
            anchor          = CENTER
        );
}



module front_support() {
    diff("remove") {
        cuboid(
            [30, plate_thickness, plate_length],
            anchor = CENTER);

            tag("remove")
            move([0, 0, 35])                    
            cuboid(
                [30 + 2, plate_thickness + 2, 30],   
                anchor = CENTER,
                rounding = 5,
                edges = [TOP + LEFT, TOP + RIGHT]    
            );

        tag("remove")
            xrot(90)
            cyl(d=4.2, h=plate_thickness + 2, anchor=CENTER);
    }
}


module back_support() {
    diff("remove") {
        cuboid([30, plate_thickness, plate_length], anchor=CENTER);

        tag("remove")
            move([0, 0, 35])    
            cuboid([30 + 2, plate_thickness + 2, 30], anchor=CENTER);


        tag("remove")
            xrot(90)
            cyl(d=4.2, h=plate_thickness + 2, anchor=CENTER);
    }
}


module base_plate() {
    cuboid([n5065_motor_diameter-20, plate_spacing + 2 * plate_thickness, 5], anchor=BOTTOM);
}


module rail_block() {
    diff("remove") {
        move([lift_tube_od/2, 0, 0])   
        half_of(LEFT)
        rect_tube(l=40, size=6+carriage_dim[0]+1.5, isize=lift_tube_od + mount_tube_clearance) {
            tag("remove")
            attach(LEFT, BOT, inside=true)
            ycopies(20, n=2)
            screw_hole(str("M", rail_screw_diameter), l=lift_tube_od) {
                attach(BOT, BOT, inside=true)
                cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer2=-0.6);
            }
        }
    }
}

module idler_top_assembly() {

    base_plate();

    
    move([0, -(plate_spacing/2 + plate_thickness/2), plate_length/2])
        front_support();

  
    move([0, plate_spacing/2 + plate_thickness/2, plate_length/2])
        back_support();

   move([0, 0, -40/2 - 20])   
    rail_block();

    
    move([0, 0, plate_length/2])
        idler_pulley();


   
}
// idler_top_assembly();