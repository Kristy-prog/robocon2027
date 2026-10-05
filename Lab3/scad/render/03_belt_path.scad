include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-pulley.scad>

$fn = 64;

idler_bearing_od = 8;
idler_bearing_id = 3;
idler_bearing_h  = 4;
idler_shaft_d    = 3;
idler_shaft_h    = 18;

drive_r = 15.92;
idler_r = drive_r;
center_gap = 80;
belt_width = 10;

module idler_assembly() {
    htd_pulley(
        type            = "5M",
        teeth           = 20,
        belt_width      = belt_width,
        bore_d          = idler_bearing_od,
        d_flat          = idler_bearing_od,
        hub_d           = 18,
        hub_h           = 7,
        flange_thickness = 1.5,
        flange_overhang  = 1.5,
        set_screw_d     = 0,
        anchor          = BOTTOM
    );
    up(21.5)
        cyl(d=idler_bearing_od, h=idler_bearing_h, anchor=BOTTOM);
    up(21.5)
        cyl(d=idler_shaft_d, h=idler_shaft_h, anchor=CENTER);
}

module belt_path() {
    // Two straight spans connect equal-radius pulleys.
    down(belt_width / 2)
        cuboid([center_gap + drive_r * 2, belt_width, 1.2], anchor=CENTER);
    move([center_gap, 0, 0])
        down(belt_width / 2)
            cuboid([center_gap + idler_r * 2, belt_width, 1.2], anchor=CENTER);

    // Half-wrap bands around each pulley make the belt path visible from above.
    down(belt_width / 2)
        cyl(r1=drive_r + 0.8, r2=drive_r - 0.8, h=1.2, anchor=BOTTOM, spin=-90, clip_angle=90);
    move([center_gap, 0, 0])
        down(belt_width / 2)
            cyl(r1=idler_r + 0.8, r2=idler_r - 0.8, h=1.2, anchor=BOTTOM, spin=90, clip_angle=90);
}

color("steelblue", 0.85)
    belt_path();

htd_pulley(
    type            = "5M",
    teeth           = 20,
    belt_width      = belt_width,
    bore_d          = 8,
    d_flat          = 8,
    hub_d           = 20,
    hub_h           = 7,
    flange_thickness = 1.5,
    flange_overhang  = 1.5,
    set_screw_d     = 3.2,
    anchor          = BOTTOM
);

move([center_gap, 0, 0])
    idler_assembly();
