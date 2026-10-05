include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <BOSL2/screws.scad>
include <htd-pulley.scad>

$fn = $preview ? 16 : 64;

// HTD5M idler: 20T, 10 mm belt, 8 mm bearing pocket, M3 screw shaft.
idler_bearing_od = 8;
idler_bearing_id = 3;
idler_bearing_h  = 4;
idler_shaft_d    = 3;
idler_shaft_h    = 18;

module idler_bearing() {
    diff("bore") {
        cyl(d=idler_bearing_od, h=idler_bearing_h, anchor=BOTTOM);
        tag("bore")
            cyl(d=idler_bearing_id, h=idler_bearing_h + 0.2, anchor=BOTTOM);
    }
}

module idler_shaft() {
    cyl(d=idler_shaft_d, h=idler_shaft_h, anchor=CENTER);
}

module idler_assembly() {
    htd_pulley(
        type            = "5M",
        teeth           = 20,
        belt_width      = 10,
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
        idler_bearing();
    up(21.5)
        idler_shaft();
}

idler_assembly();
