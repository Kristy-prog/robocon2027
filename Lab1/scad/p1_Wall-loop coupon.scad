include <BOSL2/std.scad>

$fn = $preview ? 8 : 128;

// Wall-loop coupon: FIVE SEPARATE objects, one per wall-loop count.
// The printer cannot vary wall loops inside a single object, so each
// segment is its own slicer object and gets its own perimeter count in
// Bambu Studio (object list -> per-object settings).
// Each segment: 80 x 20 x 4 mm, engraved with its label.
seg_w  = 80;
seg_d  = 20;
seg_h  = 4;
labels = ["1W", "2W", "3W", "4W", "5W"];
pitch  = seg_d + 10;   // gap between separate objects

// Slicer plan (applied per object in Bambu Studio):
//   1W -> 1 perimeter, no infill
//   2W -> 2 perimeters, no infill
//   3W -> 3 perimeters, no infill
//   4W -> 4 perimeters, 15% cubic
//   5W -> 5 perimeters, 15% cubic    (the standard under test)

for (i = [0:4]) {
    move([0, i * pitch, 0])
    diff()
    cuboid([seg_w, seg_d, seg_h], rounding=1, anchor=BOTTOM) {
        attach(TOP) tag("remove")
            linear_extrude(height=1)
                text(labels[i], size=8, halign="center", valign="center",
                     font="Liberation Sans:style=Bold");
    }
}
