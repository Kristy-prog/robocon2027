include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <htd-pulley.scad>

$fn = 64;

mount_plate_thick = 8;
belt_tension = 5;


module drive_pulley() {
    htd_pulley(
        type            = "5M",
        teeth           = 20,
        belt_width      = 10,
        bore_d          = 8,
        d_flat          = 8,
        hub_d           = 20,
        hub_h           = 7,
        flange_thickness = 1.5,
        flange_overhang  = 1.5,
        set_screw_d     = 3.2,
        anchor          = BOTTOM
    );
}

module idler_tensioner() {
    diff("remove") {
        cuboid([30, 25, 10], rounding=2, anchor=BOTTOM);
        tag("remove")
            move([0, 0, 5])
                screw_hole("M4", l=10, head="socket", anchor=BOTTOM);
        tag("remove")
            move([0, 0, 1.5])
                cyl(d=7, h=3, anchor=BOTTOM);
    }
}

module carriage() {
    diff("remove") {
        cuboid([21, 21, 12], rounding=1, anchor=BOTTOM);
        tag("remove")
            cuboid([15, 8, 13], anchor=CENTER);
        tag("remove")
            move([0, 0, 2])
                cyl(d=4, h=4, anchor=BOTTOM);
    }
}

// Mount plate and drive pulley.
cuboid([48, 42, mount_plate_thick], anchor=BOTTOM);
move([0, 0, mount_plate_thick])
    drive_pulley();

// Idler and adjustable tensioner.
move([26, 0, mount_plate_thick])
    idler_tensioner();

// Carriage block above the plate.
move([0, 25, mount_plate_thick + 13])
    carriage();


