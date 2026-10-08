# Generic compact timing belts

Open **`belt.scad`** in OpenSCAD and use its **Customizer**. Choose a belt profile, tooth count (or length), and printer. Press **F6** to render, then export STL. Saved parameter sets are in `belt.json`.

```scad
use <scad-parametric-timing-belt-generator/timing_belt_generator.scad>
belting("folded_loop", "GT2", tooth_count=100, printer="Bambu_A1_mini");
```

Beginner settings and advanced arguments call the same solver. A short belt uses a circular closed path if it already fits the requested area and constraints. Longer belts use a validated double spiral. Both use the same analytic stationing and renderer. The older `spiral` layout remains an **open** belt.

## Attribution and license

This project is a modified adaptation of [**scad-parametric-timing-belt-generator**](https://github.com/cmlarsen/scad-parametric-timing-belt-generator) by Caleb Larsen (`cmlarsen`). The upstream source identifies the parametric belting generator as work by Jeff Hertzberg and credits earlier designs by [The DoomMeister](https://www.thingiverse.com/thing:19758) and [Droftarts](https://www.thingiverse.com/thing:16627). Their existing notices are preserved in the source code.

This adaptation retains the upstream legacy belt layouts and timing-belt profile geometry, and modifies and extends the project with a compact closed folded-loop solver, generic profile handling, printer presets, geometry validation, tests, examples, and related tooling. Development assistance for these modifications was provided by OpenAI's GPT-6. No endorsement by the upstream authors or contributors is implied.

The original work and this adaptation are distributed under the [Creative Commons Attribution-ShareAlike 3.0 Unported license](https://creativecommons.org/licenses/by-sa/3.0/). See [LICENSE.md](LICENSE.md) for the complete license terms.

## Belt profiles

All existing tooth polygons and profile dimensions are preserved. Pitch is resolved from the selected profile; changing a profile never scales an unrelated tooth shape.

| Profile | Pitch (mm) | Default width (mm) | Default backing (mm) |
| --- | ---: | ---: | ---: |
| MXL | 2.032 | 6.35 | 0.74 |
| T2.5 | 2.5 | 6 | 0.6 |
| T5 | 5 | 10 | 1 |
| T10 | 10 | 16 | 2 |
| GT2_2mm | 2 | 6 | 0.76 |
| GT2_3mm | 3 | 9 | 1.27 |
| GT2_5mm | 5 | 15 | 1.88 |
| AT5 | 5 | 10 | 1 |
| HTD_3mm | 3 | 9 | 1.19 |
| HTD_5mm | 5 | 9 | 1.73 |
| HTD_8mm | 8 | 30 | 2.64 |
| 40DP | 2.073 | 4.7625 | 0.74 |
| XL | 5.08 | 7.94 | 1.03 |
| L | 9.525 | 19.05 | 1.66 |

Aliases: `GT2` and `2GT` select `GT2_2mm`; `3GT` and `5GT` select the corresponding pitches. `HTD3M`/`HTD-3M`, `HTD5M`/`HTD-5M`, and `HTD8M`/`HTD-8M` select their canonical HTD profiles. Names are case-sensitive. The legacy smooth `belt` profile remains available in legacy layouts, but is not a folded timing-belt profile.

## Printer presets

These are **model-size limits**, with a 5 mm inset on each side. They do not certify slicer placement, exclusion zones, brim, purge regions, or filament compatibility. Bambu Studio and physical testing are left to the user.

| Preset | Nominal XY (mm) | Generator area (mm) |
| --- | --- | --- |
| Bambu_A1_mini | 180 × 180 | 170 × 170 |
| Bambu_A1 | 256 × 256 | 246 × 246 |
| Bambu_P1P, Bambu_P1S, Bambu_P2S | 256 × 256 | 246 × 246 |
| Bambu_X1, Bambu_X1C, Bambu_X1E | 256 × 256 | 246 × 246 |
| Bambu_H2S | 340 × 320 | 330 × 310 |
| Bambu_H2D, Bambu_H2D_Pro | 350 × 320 | 290 × 310 |
| Bambu_H2C | 330 × 320 | 290 × 310 |

H2 dual-tool presets deliberately use the **300 × 320 mm rectangle shared by both nozzle areas**, then apply the inset; they do not use the combined travel area. Data comes from the locally installed Bambu Studio **02.04.00.70** profile snapshot, including inherited `printable_area` and `extruder_printable_area`. It is not a live printer capability lookup.

For a custom area, set `printer="Custom"` in the Customizer, or pass `max_size=[width,depth]` to the library. Explicit `max_size` overrides the printer area and receives no additional inset. Without either, `[max_diameter,max_diameter]` is used (default 200 × 200). Explicit unknown printer names are rejected even if their dimensions would be overridden.

## Automatic values and overrides

The Customizer uses numeric sentinels because numeric controls do not conveniently represent `undef`:

- Width, backing, and radius: **0 = automatic**.
- Track gap: **-1 = automatic**; **0 is an explicit zero gap**.
- `length_mode` chooses which length field is used.

Direct `belting()` calls use **`undef` for automatic values**. Explicit dimensions must be positive. Count must be a positive integer and takes precedence over `belt_length`; otherwise length is rounded up to a whole profile pitch.

The default gap is 2 mm. The automatic bend radius is `max(3 * pitch, 3 * (envelope + gap))`, where the envelope encloses the actual tooth polygon and resolved backing. This leaves connector room when the air gap is large relative to a small tooth. Explicit radius/gap overrides are honored without silent relaxation.

These are packing defaults, not manufacturer-approved material minimum radii. The reference path is the **tooth-root baseline**. Its target length is `count * pitch`; it is not a calibrated material neutral axis or proof of operating pitch after printing and unfolding.

## Advanced configuration

```scad
belting("folded_loop", "HTD_5mm", tooth_count=254,
    belting_width=9, backing_thickness=1.73,
    max_size=[140,170], min_bend_radius=15, min_track_gap=2,
    length_tolerance=.005, geometry_tolerance=.01,
    allow_rotate=true, solver_quality="normal");
```

All existing positional arguments keep their positions. New `printer`, `allow_rotate`, and `solver_quality` arguments are appended. Legacy layouts ignore folded-loop-only options.

Rotation tries 0° and, when needed and allowed, 90°. It never scales geometry. Numerical tolerances control reference-length accuracy and boundary approximation; changing search quality does not loosen them.

| Search quality | Inner radii | Spacings | Relative phases | Extent intervals | Connector pairs |
| --- | ---: | ---: | ---: | ---: | ---: |
| fast | 1 | 1 | 1 | 8 | 64 |
| normal | 3 | up to 3 | 1 | 16 | 64 |
| high | 5 | up to 5 | 3 | 32 | 64 |

Each root refinement has a 64-iteration limit. Normal search uses radii `[2.1, 7/3, 2.5] * minimum_radius` and envelope/gap-aware spacing candidates; high adds radii and phases. High can take substantially longer. Every successful candidate must still pass reference-path, curvature, clearance, and footprint checks. Search does not prove that a failed request is mathematically impossible, and not every valid belt size fits this bounded family. Try a broader search or a larger area; adjust physical constraints only deliberately.

The tooth envelope now comes directly from the preserved polygon vertices. This is tighter than the previous HTD-5M bounding-rectangle estimate and can change packing selection without changing teeth.

## Saved configurations and examples

`belt.json` contains complete named parameter sets for HTD5/A1 mini, GT2/A1 mini, HTD8/H2S, and XL/custom-area examples. Select them in the Customizer, or use the command line:

```sh
openscad -p belt.json -P 'GT2 100T - A1 mini' -o gt2.stl belt.scad
```

See `examples/` for beginner and advanced direct-library calls. The default `belt.scad` remains the corrected **254T HTD-5M, 9 mm width, A1 mini area** example.

## Verification

Test-only dependencies are listed in `tests/requirements.txt`. Runtime geometry needs only OpenSCAD.

```sh
python tests/test_generator.py
BELT_FULL_TESTS=1 python tests/test_generator.py
openscad -o /tmp/belt.csg -o belt.stl belt.scad
python tests/verify_folded_belt.py /tmp/belt.csg belt.stl
```

The independent verifier accepts `--count`, `--width`, `--backing`, `--radius`, `--gap`, `--size WIDTH DEPTH`, and `--geometry-tolerance` for other configurations. Tests cover all 14 preserved tooth polygons, all-profile STL exports, aliases, presets, saved JSON, precedence, positional compatibility, analytic stationing, clearance, root attachment, and watertight single-loop topology. Failed searches emit no partial belt.

On the development Mac the installed ARM Qt build fails its NEON check; the Intel invocation works:

```sh
export OPENSCAD='arch -x86_64 /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD'
```

Use the same prefix for direct OpenSCAD commands on that machine. STL validation is independent of the slicer. **Bambu Studio testing and physical pulley-fit testing are left to the user.**
