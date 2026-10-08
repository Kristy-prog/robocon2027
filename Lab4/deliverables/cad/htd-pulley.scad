include <BOSL2/std.scad>

/*
 * 3D HTD Pulley Component (Supports 3M and 5M profiles)
 * Extends BOSL2 using attachable() and nested diff() logic.
 */
module htd_pulley(
    type = "3M",             // Belt type: "3M" or "5M"
    teeth = 20,              // Number of teeth
    belt_width = 10,         // Width of the timing belt
    bore_d = 5,              // Shaft diameter
    d_flat = 4.5,            // Shaft flat distance; set equal to bore_d for a round shaft
    hub_d = 18,              // Outer diameter of the mounting hub
    hub_h = 7,               // Height of the mounting hub
    flange_thickness = 1,    // Thickness of the top and bottom retaining walls
    flange_overhang = 1.5,   // How far the flanges extend past the teeth
    set_screw_d = 3.2,       // Hole for the set screw
    anchor = CENTER,         // BOSL2 anchor point
    spin = 0,                // BOSL2 spin rotation
    orient = UP              // BOSL2 orientation
) {
    assert(type == "3M" || type == "5M", "Pulley type must be '3M' or '5M'");

    pitch = (type == "5M") ? 5.0 : 3.0;
    pld = (type == "5M") ? 0.5715 : 0.381;
    tooth_depth = (type == "5M") ? 2.06 : 1.22;
    groove_radius = (type == "5M") ? 1.49 : 1.05;

    pitch_radius = (teeth * pitch) / (2 * PI);
    outer_radius = pitch_radius - pld;
    groove_offset = outer_radius - tooth_depth + groove_radius;

    flange_radius = outer_radius + flange_overhang;
    pulley_h = belt_width + 1.5;
    total_h = flange_thickness * 2 + pulley_h + hub_h;
    fn_val = max(36, teeth * 4);

    attachable(anchor, spin, orient, r=flange_radius, l=total_h) {
        down(total_h / 2)
        diff("htd_pulley") {
            union() {
                cyl(r=flange_radius, h=flange_thickness, anchor=BOTTOM, $fn=fn_val);

                up(flange_thickness)
                diff("grooves") {
                    cyl(r=outer_radius, h=pulley_h, anchor=BOTTOM, $fn=fn_val);

                    tag("grooves")
                    zrot_copies(n=teeth)
                    right(groove_offset)
                    down(0.01)
                    cyl(r=groove_radius, h=pulley_h + 0.02, anchor=BOTTOM, $fn=16);
                }

                up(flange_thickness + pulley_h)
                cyl(r=flange_radius, h=flange_thickness, anchor=BOTTOM, $fn=fn_val);

                if (hub_h > 0) {
                    up(flange_thickness * 2 + pulley_h)
                    cyl(d=hub_d, h=hub_h, anchor=BOTTOM, $fn=fn_val);
                }
            }

            tag("htd_pulley") {
                diff("flat") {
                    down(0.1)
                    cyl(d=bore_d, h=total_h + 0.2, anchor=BOTTOM);

                    if (d_flat < bore_d) {
                        tag("flat")
                        back(d_flat - bore_d/2)
                        down(0.1)
                        cuboid([bore_d + 2, bore_d, total_h + 0.2], anchor=FRONT);
                    }
                }

                if (hub_h > 0 && set_screw_d > 0) {
                    up(flange_thickness * 2 + pulley_h + hub_h/2)
                    back(hub_d/2)
                    xrot(90)
                    cyl(d=set_screw_d, h=hub_d/2 + 2, anchor=BOTTOM);
                }
            }
        }

        children();
    }
}
