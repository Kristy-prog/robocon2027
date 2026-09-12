include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 128;

// Sanity geometry: a small rounded plate with two distinct screw sizes.
diff()
cuboid([40, 26, 14], rounding=2, anchor=BOTTOM+BACK) {
    // Front-face M4 through-hole (visible from the default camera).
    attach(FRONT, CENTER, overlap=0.01)
        tag("remove")
        screw_hole("M4", length=16, anchor=CENTER);

    // Top-face M3 hole (also visible) so the picture shows two
    // distinct screw sizes work.
    attach(TOP) tag("remove")
        screw_hole("M3", length=18, anchor=TOP);
}
