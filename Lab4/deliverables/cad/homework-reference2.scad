include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <n5065-mounts.scad>
include <htd-pulley.scad>
include <htd-linear-clamp.scad>

$fn = $preview ? 8 : 128;

part = "base";   // choose "base"、"clamp"、"tensioner"、"idler"、"all" to prints stl

carriage_dim = [20, 40, 10];
carriage_screw_hole_interval = [16, 15];

amt102_amt103_width = 22.6;

heatinsert_diameter = 3.8;
heatinsert_legth = 4;

lift_tube_clearance = 0.4;
lift_tube_od = 10;
lift_tube_length = 200;
rail_screw_diameter = 3;

mount_tube_clearance = 0.4;
mount_tube_od = 25;

mount_couple_screw_diameter = 3;
mount_gap = 2.4;
mount_wall_thickness = mount_couple_screw_diameter * 2;
mount_length = n5065_motor_length();

belt_length_required = 2*243 + 34*5;
belt_teeth = belt_length_required / 5;
echo("belt_length_required: ", belt_length_required);
echo("belt_teeth: ", belt_teeth);



// ===== 模組定義 =====
echo("n5065_motor_length() = ", n5065_motor_length());
echo("mount_length = ", mount_length);

echo("clamp 有 2 個 M3 孔");
echo("孔距 = ", carriage_screw_hole_interval);

module idler_bearing() {
    diff("bore") {
        cyl(d=8, h=4, anchor=BOTTOM);
        tag("bore")
            cyl(d=3, h=4.2, anchor=BOTTOM);
    }
}

module idler_shaft() {
    cyl(d=3, h=18, anchor=CENTER);
}

module idler_assembly() {
    htd_pulley(
        type            = "5M",
        teeth           = 34,
        belt_width      = 10,
        bore_d          = 8,
        d_flat          = 8,
        hub_d           = 18,
        hub_h           = 7,
        flange_thickness = 1.5,
        flange_overhang  = 1.5,
        set_screw_d     = 0,
        anchor          = BOTTOM
    );
    up(21.5) idler_bearing();
    up(21.5) idler_shaft();
}

module idler_tensioner() {
    difference() {
        cuboid([30, 25, 10], rounding=2, anchor=BOTTOM);
        move([0, 0, 5])
            screw_hole("M4", l=10, head="socket", anchor=BOTTOM);
        move([0, 0, 1.5])
            cyl(d=7, h=3, anchor=BOTTOM);
    }
}

// overriden Ø20 4M3
module n5065_rear_screws(l=6) {
    attachable(r=[n5065_motor_diameter()/2,n5065_motor_diameter()/2], l=l, anchor=CENTER) {
        union() {
            for (rot=[0:3]) rot(rot*90) fwd(10) {
                screw_hole("M3", head="flat", l=l);
            }
        }
        children();
    }
}

module base_main() {
    tag("base_main") diff() cuboid([n5065_motor_diameter(), mount_length, mount_wall_thickness*2 + mount_tube_od], anchor=FWD+BOT, rounding=2, edges=[TOP+FWD, TOP+LEFT, TOP+RIGHT, BOT+BACK]) {
        tag("remove") attach(FWD, FWD, inside=true) {
            cuboid([mount_tube_od + mount_tube_clearance, mount_length*2, mount_tube_od + mount_tube_clearance]);
            cuboid([n5065_motor_diameter(), mount_length*2, mount_gap]);
        }
        tag("remove")
            grid_copies((n5065_motor_diameter() - mount_tube_od + mount_tube_clearance)/2 + mount_tube_od)
                screw_hole(str("M", mount_couple_screw_diameter), l=mount_wall_thickness*2 + mount_tube_od) {
                    attach(BOT, BOT, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer1=-0.6);
                }
    }
}

module base_rail() {
    tag("base_rail") diff() cuboid([n5065_motor_diameter(), 6+6+carriage_dim[0]+1.5, (mount_wall_thickness*2 + mount_tube_od)/2], rounding=2, edges=[TOP+LEFT, TOP+RIGHT]) {
        right(lift_tube_od/2) attach(TOP, BOT) half_of(LEFT) rect_tube(l=40, size=6+carriage_dim[0]+1.5, isize=lift_tube_od+mount_tube_clearance) {
            tag("remove") attach(LEFT, TOP, inside=true) ycopies(20, n=2) #screw_hole(str("M", rail_screw_diameter), l=lift_tube_od) {
                attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer2=-0.6);
            }
        }
    }
}

module base_front() {
    tag("base_front") diff() cuboid([n5065_motor_diameter(), 6, 4], anchor=FWD+BOT) {
        // N5065 front
        yflip() attach(BOT, RIGHT) n5065_front_mount(circle=false) {
            attach(TOP, BOT) zrot(25) arc_copies(d=amt102_amt103_width+6, n=2, sa=0, ea=360) cuboid(6, rounding=1, edges="Z") {
                tag("remove") attach(TOP, TOP, inside=true) screw_hole("M3", l=12) {
                    attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer2=-0.6);
                }
            }
            // down(n5065_motor_length())
            //     attach(BOT, TOP) htd_pulley(type="5M", teeth=34, belt_width=10,bore_d=0, hub_h=0, flange_thickness=5) {
            //         // tag("remove") attach(TOP, BOT, inside=true) n5065_rear_bore();
            //         tag("remove") attach(BOT, TOP, inside=true) n5065_rear_screws(l=10+5*2+1.5);
            //     }
        }
    }
}



hide("") {

    // N5065
    if (part == "base" || part == "all") {
        tag("base") diff() cuboid([n5065_motor_diameter(), mount_length, mount_wall_thickness*2 + mount_tube_od], anchor=FWD+BOT, rounding=2, edges=[TOP+FWD, TOP+LEFT, TOP+RIGHT, BOT+BACK]) {

            tag("remove") attach(FWD, FWD, inside=true) {
                cuboid([mount_tube_od + mount_tube_clearance, mount_length*2, mount_tube_od + mount_tube_clearance]);
                cuboid([n5065_motor_diameter(), mount_length*2, mount_gap]);
            }
            tag("remove")
                grid_copies((n5065_motor_diameter() - mount_tube_od + mount_tube_clearance)/2 + mount_tube_od)
                    screw_hole(str("M", mount_couple_screw_diameter), l=mount_wall_thickness*2 + mount_tube_od) {
                        attach(BOT, BOT, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer1=-0.6);
                    }

            align(BACK, TOP) cuboid([n5065_motor_diameter(), 6+6+carriage_dim[0]+1.5, (mount_wall_thickness*2 + mount_tube_od)/2], rounding=2, edges=[TOP+LEFT, TOP+RIGHT]) {
                right(lift_tube_od/2) attach(TOP, BOT) half_of(LEFT) rect_tube(l=40, size=6+carriage_dim[0]+1.5, isize=lift_tube_od+mount_tube_clearance) {
                    tag("remove") attach(LEFT, TOP, inside=true) ycopies(20, n=2) #screw_hole(str("M", rail_screw_diameter), l=lift_tube_od) {
                        attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer2=-0.6);
                    }
                }
            }

            align(BOT, FWD) cuboid([n5065_motor_diameter(), 6, 4]) {
                yflip() attach(BOT, RIGHT) n5065_front_mount(circle=false) {
                    attach(TOP, BOT) zrot(25) arc_copies(d=amt102_amt103_width+6, n=2, sa=0, ea=360) cuboid(6, rounding=1, edges="Z") {
                        tag("remove") attach(TOP, TOP, inside=true) screw_hole("M3", l=12) {
                            attach(TOP, TOP, inside=true) cyl(d=heatinsert_diameter, h=heatinsert_legth, chamfer2=-0.6);
                        }
                    }

// add bore_d=0
                    // down(n5065_motor_length())
                    //     attach(BOT, TOP) htd_pulley(type="5M", teeth=34, belt_width=10, hub_h=0,bore_d=0, flange_thickness=5) {
                    //         tag("remove") attach(TOP, BOT, inside=true) n5065_rear_bore();
                    //         tag("remove") attach(BOT, TOP, inside=true) n5065_rear_screws(l=10+5*2+1.5);
                    //     }
                }
            }
        }
    }

        // ===== HTD 皮帶夾具 =====
//     if (part == "clamp" || part == "all") {
//     tag("clamp") diff() htd_linear_clamp(type="5M", teeth=8, belt_width=10, thickness=10, flange_thickness=10) {
//    // 上方孔（l=50，穿透兩層）
//     tag("remove") grid_copies(spacing=carriage_screw_hole_interval, n=[2,2])
//         screw_hole(str("M", rail_screw_diameter), l=50);

//     // 下方凸耳
//     attach(BOTTOM, TOP, overlap=-10)
//     cuboid([40, 30, 6]);
// }
// }

    // HTD 
    if (part == "clamp" || part == "all") {
        // HTD 齒
        translate([-50, 0, 0])
            tag("clamp") diff() htd_linear_clamp(type="5M", teeth=8, belt_width=10, thickness=10, flange_thickness=10) {
                tag("remove") grid_copies(spacing=carriage_screw_hole_interval, n=[2,2])
                    screw_hole(str("M", rail_screw_diameter), l=50);
            }

        // 凸耳（右邊）
        translate([50, 0, 0])
            difference() {
                cuboid([40, 30, 6]);
                translate([-8, -7.5, 0]) cylinder(d=3, h=20, center=true);
                translate([ 8, -7.5, 0]) cylinder(d=3, h=20, center=true);
                translate([-8,  7.5, 0]) cylinder(d=3, h=20, center=true);
                translate([ 8,  7.5, 0]) cylinder(d=3, h=20, center=true);
            }
    }


   
    if (part == "tensioner" || part == "all") {
    move([0, 0, 0])  
        idler_tensioner();
}

   
    if (part == "idler" || part == "all") {
        move([0, lift_tube_length, 10])
            idler_assembly();
    }
}

if (part == "pulley" || part == "all") {
    diff("remove")
        htd_pulley(type="5M", teeth=34, belt_width=10, bore_d=0, hub_h=0, flange_thickness=5) {
            tag("remove") attach(BOT, TOP, inside=true) n5065_rear_screws(l=50);
        }
}


if (part == "base_main") base_main();
if (part == "base_rail") base_rail();
if (part == "base_front") base_front();