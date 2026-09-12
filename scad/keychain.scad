include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = $preview ? 8 : 128;

student_name = "Kristy";   
key_width    = 50;
key_height   = 20;
key_thick    = 4;
hole_spacing = 35;   
hole_dia     = 6;  

diff()
cuboid([key_width, key_height, key_thick], rounding=2, anchor=BOTTOM) {
    attach(TOP,overlap=2)
     right(hole_spacing / 2) tag("remove")
        cyl(d=hole_dia, h=key_thick + 1, anchor=CENTER);
    attach(TOP)
        linear_extrude(height=1.5)
            text(student_name, size=7, halign="center", valign="center",
                 font="Liberation Sans:style=Bold");
}
