include <BOSL2/std.scad>
include <../htd-linear-clamp.scad>

$fn = 64;

htd_linear_clamp(
    type="5M", teeth=6, belt_width=10,
    thickness=4, flange_thickness=1.5,
    flange_height=2, anchor=BOTTOM
);