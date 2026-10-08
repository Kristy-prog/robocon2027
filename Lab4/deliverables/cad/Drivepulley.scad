include <BOSL2/std.scad>
include <BOSL2/gears.scad>
include <BOSL2/screws.scad>
include <htd-pulley.scad>

$fn = $preview ? 16 : 64;

// HTD5M drive pulley: 20 teeth, 5 mm pitch, 10 mm belt width, on N5065 shaft.
// The N5065 shaft is ≈ 8 mm round; bore_d = d_flat for a round shaft.
htd_pulley(
    type            = "5M",
    teeth           = 20,
    belt_width      = 10,         // 10 mm HTD5M belt
    bore_d          = 8,          // N5065 shaft diameter
    d_flat          = 8,          // round shaft (no flat)
    hub_d           = 20,
    hub_h           = 7,          // hub thickness (engages keyway)
    flange_thickness = 1.5,
    flange_overhang  = 1.5,
    set_screw_d     = 3.2,
    anchor          = BOTTOM
);
