include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-pulley.scad>

$fn = 64;

htd_pulley(
    type="5M", teeth=20, belt_width=10,
    bore_d=8, d_flat=8,
    hub_d=20, hub_h=7,
    flange_thickness=1.5, flange_overhang=1.5,
    set_screw_d=3.2, anchor=BOTTOM
);

htd_pulley()