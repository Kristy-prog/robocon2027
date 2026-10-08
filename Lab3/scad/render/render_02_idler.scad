include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-pulley.scad>

$fn = 64;

idler_bearing_od = 8;
idler_bearing_id = 3;
idler_bearing_h  = 4;
idler_shaft_d    = 3;
idler_shaft_h    = 18;

htd_pulley(
    type="5M", teeth=20, belt_width=10,
    bore_d=idler_bearing_od, d_flat=idler_bearing_od,
    hub_d=18, hub_h=7,
    flange_thickness=1.5, flange_overhang=1.5,
    set_screw_d=0, anchor=BOTTOM
);

up(21.5) cyl(d=idler_bearing_od, h=idler_bearing_h, anchor=BOTTOM);
up(21.5) cyl(d=idler_shaft_d, h=idler_shaft_h, anchor=CENTER);