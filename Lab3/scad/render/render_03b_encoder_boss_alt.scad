include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 64;

encoder_type = "AMT103";
if (encoder_type == "AMT103") {
    cuboid([31, 37, 3], anchor=CENTER);
    zrot(45)
    grid_copies(n=2, size=[16, 0])
    move([0, 9, 0])
    screw_hole("M1.6", l=8, anchor=BOTTOM);
}