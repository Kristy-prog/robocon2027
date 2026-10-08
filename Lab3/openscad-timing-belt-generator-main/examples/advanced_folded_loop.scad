use <../scad-parametric-timing-belt-generator/timing_belt_generator.scad>
// A rectangular area can require a 90 degree rotation.
belting("folded_loop", "HTD_5mm", tooth_count=254,
    belting_width=9, backing_thickness=1.73,
    max_size=[140,170], min_bend_radius=15, min_track_gap=2,
    length_tolerance=.005, geometry_tolerance=.01,
    allow_rotate=true, solver_quality="normal");
// Use solver_quality="high" for a broader, slower search if normal fails.
