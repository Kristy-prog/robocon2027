include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-pulley.scad>
include <../htd-linear-clamp.scad>

$fn = 64;


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

carriage();

up(12)
htd_linear_clamp(
    type="5M", teeth=6, belt_width=10,
    thickness=4, flange_thickness=1.5,
    flange_height=2, anchor=BOTTOM
);


