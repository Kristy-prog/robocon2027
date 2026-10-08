# Complete Implementation Plan: Generic Folded-Loop Timing Belt Generator

> Implemented: see [README.md](README.md) for the current API, exact defaults, and commands. This document records the original design; the implementation choices below supersede its tentative alternatives.
>
> - All 14 existing toothed profiles share preserved polygon data in `profiles.scad`. Pitch, envelope, root depth, width, and backing resolve before the numerical solver.
> - New public arguments are appended after the existing arguments; `printer` is **not** inserted before `max_diameter`.
> - Automatic gap is 2 mm; automatic radius is `max(3*pitch, 3*(envelope+gap))`. These are packing defaults, not material qualifications.
> - The tighter vertex-derived envelope can change the chosen packing. Reference spacing is accepted within numerical tolerances, not claimed as exact operating pitch.
> - `fast`, `normal`, and `high` have explicit bounded search budgets documented in the README. Spacing scales with radius, envelope, and gap. There is no `exhaustive` setting.
> - Short belts use a circular analytic path if it already fits all constraints; longer belts use the same pipeline with spiral/arc segments. No open belt is substituted.
> - `belt.scad` provides Customizer groups and `belt.json` provides complete named configurations. Only the Customizer maps width/backing/radius 0 and gap -1 to automatic values; the library uses `undef`.
> - Twelve Bambu model-size presets include H-series models. Dual-nozzle H2 presets use the common nozzle rectangle. Presets are dimension data, not slicer placement certification.
> - Verification is limited to generator, CSG, and STL checks. **Bambu Studio and physical testing are left to the user.**


## 1. Objective

Extend the existing timing-belt generator so that `folded_loop` becomes a reusable layout for multiple belt profiles and printer sizes, while providing two ways to use it:

1. **Beginner mode**
   - User edits only a small set of obvious belt/printer parameters.
   - Common belt profiles are already available.
   - Common Bambu Lab plate sizes are available as presets.
   - Solver details remain automatic.

2. **Advanced mode**
   - User can directly control packing geometry, bend radius, clearance, tolerances, search behavior, and custom printer dimensions.

Both modes must ultimately call the **same folded-loop solver**.

There should not be separate beginner and advanced geometry implementations.

---

# 2. Current State

The current implementation already has a good separation:

```text
timing_belt_generator.scad
        │
        └── folded_loop.scad
```

`belting()` dispatches `folded_loop` into the new solver, while legacy layouts remain separate.

The existing profile table already stores:

```text
profile name
pitch
default backing thickness
default belt width
```

for profiles such as GT2, HTD, T-series, XL, etc.

However, the current folded-loop implementation is still specifically tied to HTD-5M:

```scad
assert(
    tooth_profile == "HTD_5mm",
    "folded_loop supports only HTD_5mm"
);
```

and it contains hard-coded 5 mm pitch calculations and HTD-5M tooth-envelope dimensions.

The first priority is therefore to remove those profile-specific assumptions.

---

# 3. Target Architecture

The final architecture should be:

```text
                       belting()
                           │
                           ▼
                  normalize user input
                           │
             ┌─────────────┴─────────────┐
             │                           │
       Beginner presets            Advanced values
             │                           │
             └─────────────┬─────────────┘
                           ▼
                 resolve belt profile
                           │
              ┌────────────┼────────────┐
              │            │            │
            pitch       backing       width
              │                         │
              └────────────┬────────────┘
                           │
                    tooth envelope
                           │
                           ▼
                resolve printer area
                           │
                    resolve defaults
                           │
                           ▼
                  folded-loop solver
                           │
              ┌────────────┼─────────────┐
              │            │             │
          path solve   validation   tooth stationing
              │            │             │
              └────────────┴─────────────┘
                           ▼
                     render belt
```

The folded-loop solver should know nothing about:

```text
HTD-5M
Bambu A1 mini
254 teeth
170 × 170
```

Those should only be inputs.

---

# 4. Phase 1 — Create a Profile-Resolution Layer

This should be the first implementation change.

## 4.1 Resolve the profile once inside `belting()`

Currently the legacy code resolves:

```scad
belt_defaults =
    tooth_profile_defaults[
        search([tooth_profile], tooth_profile_defaults)[0]
    ];

tooth_pitch = belt_defaults[1];

belt_width =
    belting_width == undef
        ? belt_defaults[3]
        : belting_width;

back_thickness =
    backing_thickness == undef
        ? belt_defaults[2]
        : backing_thickness;
```

The folded-loop branch should use exactly the same profile-resolution system instead of defining its own defaults.

Create a common resolver before layout dispatch:

```scad
profile_name =
    normalize_profile(tooth_profile);

profile =
    get_profile(profile_name);

tooth_pitch =
    profile[PROFILE_PITCH];

belt_width =
    is_undef(belting_width)
        ? profile[PROFILE_DEFAULT_WIDTH]
        : belting_width;

back_thickness =
    is_undef(backing_thickness)
        ? profile[PROFILE_DEFAULT_BACKING]
        : backing_thickness;
```

Then all layouts receive the same resolved parameters.

---

# 5. Replace Every Pitch-Specific `5` in `folded_loop`

The folded-loop solver currently assumes:

```text
pitch = 5 mm
```

in several places.

Examples include:

```scad
ceil(belt_length / 5)
```

```scad
L = count * 5;
```

```scad
fl_pose(
    path,
    cum,
    i * 5,
    ...
);
```

The target should instead be:

```scad
ceil(belt_length / tooth_pitch)
```

```scad
L = count * tooth_pitch;
```

```scad
fl_pose(
    path,
    cum,
    i * tooth_pitch,
    ...
);
```

and:

```scad
closing_interval == tooth_pitch
```

rather than:

```scad
closing_interval == 5
```

This immediately makes the mathematical solver independent of HTD-5M pitch.

---

# 6. Change the Folded-Loop Function Signature

Current conceptual API:

```text
folded_loop_belt(
    tooth_profile,
    tooth_count,
    belt_length,
    ...
)
```

Recommended internal API:

```scad
module folded_loop_belt(
    tooth_count,
    belt_length,

    tooth_pitch,
    tooth_envelope,

    belt_width,
    backing_thickness,

    max_size,

    min_bend_radius,
    min_track_gap,

    length_tolerance,
    geometry_tolerance,

    allow_rotate = true,
    solver_quality = "normal",
    printer = undef
)
```

The path solver no longer needs to understand:

```text
"HTD_5mm"
"GT2_2mm"
"T5"
```

It only needs numerical properties.

The actual tooth module remains a child of the layout:

```scad
folded_loop_belt(...)
    belt_tooth(profile_name, belt_width);
```

The existing `belt_tooth()` dispatcher already knows how to generate many different profiles.

---

# 7. Add Tooth-Envelope Information

This is the second major profile dependency.

The current solver contains:

```scad
env =
    max(
        norm([1.89036, 2.198511]),
        backing_thickness
    );
```

Those numbers come specifically from the current HTD-5M polygon.

That must become profile-specific.

## Recommended long-term solution

Make the tooth polygon itself data rather than hiding it entirely inside a module.

Conceptually:

```scad
function tooth_points(profile) =
    profile == "HTD_5mm" ? [
        ...
    ] :
    profile == "GT2_2mm" ? [
        ...
    ] :
    ...
;
```

Then:

```scad
module HTD_5mm(width)
{
    linear_extrude(width)
        polygon(tooth_points("HTD_5mm"));
}
```

The envelope can then be calculated from the exact same geometry:

```scad
function tooth_radius(points) =
    max([
        for (p = points)
            norm(p)
    ]);
```

Therefore:

```scad
tooth_envelope =
    max(
        tooth_radius(
            tooth_points(profile_name)
        ),
        backing_thickness
    );
```

This is preferable to manually maintaining:

```text
profile polygon
+
separate profile envelope
```

because they could eventually disagree.

## MVP alternative

If moving every polygon is too large a refactor initially, extend the profile table:

```scad
[
    "HTD_5mm",
    5,
    1.73,
    9,
    HTD5_TOOTH_ENVELOPE
]
```

and migrate the polygon data later.

---

# 8. Expanded Profile Metadata

Eventually the profile system should conceptually contain:

```text
name
pitch
default backing thickness
default width
tooth envelope
```

For example:

```scad
[
    "HTD_5mm",
    5,
    1.73,
    9,
    2.90
]
```

The exact envelope should be computed from the tooth geometry rather than copied from this example.

This gives the folded-loop solver everything it needs without knowing the belt type.

---

# 9. Remove the HTD-5M Restriction

Only after:

- pitch is parameterized;
- tooth envelope is parameterized;
- profile defaults are resolved centrally;

remove:

```scad
assert(
    tooth_profile == "HTD_5mm",
    ...
);
```

Then the same solver can attempt:

```scad
tooth_profile = "GT2_2mm";
```

```scad
tooth_profile = "GT2_5mm";
```

```scad
tooth_profile = "HTD_3mm";
```

```scad
tooth_profile = "HTD_5mm";
```

```scad
tooth_profile = "HTD_8mm";
```

```scad
tooth_profile = "T5";
```

etc.

The original generator already defines these profiles and their pitches/default dimensions.

---

# 10. Phase 2 — Preserve the Existing Folded-Loop Solver

The difficult closed-loop geometry does **not** need to be rewritten.

The current implementation already provides:

```text
analytic line segments
analytic circular arcs
analytic Archimedean spirals
Dubins-style connector candidates
length evaluation
root solving
path stationing
geometry-error-controlled tessellation
clearance checks
footprint validation
```

Keep this system.

The refactor should change its inputs, not replace its mathematics.

---

# 11. Keep Exact Arc-Length Tooth Placement

For any profile:

\[
L=Np
\]

where:

- \(N\) = tooth count
- \(p\) = tooth pitch

For HTD-5M:

\[
254\times5=1270
\]

For HTD-8M:

\[
N\times8
\]

For GT2:

\[
N\times2
\]

etc.

Tooth positions must always be:

\[
s_i=i p
\]

for:

\[
i=0,\ldots,N-1
\]

The closing interval must equal one profile pitch within the numerical error budget; this does not establish physical operating pitch.

---

# 12. Phase 3 — Improve Rectangular Bed Handling

The current footprint validator independently checks:

```text
width <= max_size[0]
height <= max_size[1]
```

Add automatic 90° rotation.

For each candidate:

```scad
normal_fit =
    candidate_width <= bed_width &&
    candidate_height <= bed_height;

rotated_fit =
    candidate_height <= bed_width &&
    candidate_width <= bed_height;
```

If:

```text
normal_fit = false
rotated_fit = true
```

store:

```text
rotation = 90°
```

with the candidate.

Then rotate the final geometry before centering/exporting.

Add:

```scad
allow_rotate = true
```

as an advanced parameter.

Default:

```scad
allow_rotate = true;
```

---

# 13. Phase 4 — Build the Beginner Preset Layer

After the solver is profile-generic, add the beginner interface.

The beginner interface should be a thin parameter-resolution layer.

It must **not contain geometry logic**.

---

# 14. Beginner Usage Pattern

Provide a clearly marked block near the top of `belt.scad` or the README:

```scad
// ========================================
// BEGINNER SETTINGS
// Change only these values
// ========================================

print_layout = "folded_loop";

tooth_profile = "HTD_5mm";
tooth_count = 254;

belting_width = 9;
backing_thickness = 1.73;

printer = "Bambu_A1_mini";

// Optional:
// Leave undef to use recommended defaults.
min_bend_radius = undef;
min_track_gap = undef;


// ========================================
// GENERATE BELT
// Normally do not change below this line
// ========================================

belting(
    print_layout = print_layout,
    tooth_profile = tooth_profile,
    tooth_count = tooth_count,

    belting_width = belting_width,
    backing_thickness = backing_thickness,

    printer = printer,

    min_bend_radius = min_bend_radius,
    min_track_gap = min_track_gap
);
```

This gives beginners one obvious configuration area.

---

# 15. Even Simpler Beginner Version

Because width and backing already have profile defaults, the minimal usage can eventually become:

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    printer = "Bambu_A1_mini"
);
```

The generator automatically resolves:

```text
pitch
default width
default backing
tooth envelope
printer area
default bend radius
default track gap
solver tolerances
```

This should be presented as the easiest example.

---

# 16. Intermediate/Newbie Explicit Version

For users who want to see the important dimensions explicitly, retain an example close to the current one:

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    belting_width = 9,
    backing_thickness = 1.73,

    max_size = [170,170],

    min_bend_radius = 15,
    min_track_gap = 2
);
```

This is valuable because it remains readable without exposing solver internals.

The current example already follows approximately this structure.

---

# 17. Advanced Usage Pattern

Advanced users should use the same `belting()` function:

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    belting_width = 9,
    backing_thickness = 1.73,

    max_size = [170,170],

    min_bend_radius = 18,
    min_track_gap = 3,

    length_tolerance = 0.005,
    geometry_tolerance = 0.01,

    allow_rotate = true,
    solver_quality = "high"
);
```

Future solver controls can also live here without affecting beginner usage.

---

# 18. Parameter Precedence

Define one clear precedence rule.

## Belt dimensions

```text
Explicit user parameter
        ↓
Profile default
        ↓
Error if neither exists
```

For example:

```scad
resolved_width =
    !is_undef(belting_width)
        ? belting_width
        : profile_default_width;
```

## Printer dimensions

Recommended precedence:

```text
explicit max_size
        ↓
printer preset
        ↓
[max_diameter, max_diameter]
```

Conceptually:

```scad
resolved_size =
    !is_undef(max_size)
        ? max_size
        : !is_undef(printer)
            ? printer_size(printer)
            : [max_diameter, max_diameter];
```

Therefore:

```scad
printer = "Bambu_A1_mini";
max_size = [165,175];
```

means:

```text
use [165,175]
```

The explicit value wins.

---

# 19. Automatic/Advanced Parameter Rule

Use one consistent convention:

```text
undef = automatic
explicit number = user override
```

For example:

```scad
min_bend_radius = undef;
```

means:

```text
select profile default
```

while:

```scad
min_bend_radius = 20;
```

means:

```text
use exactly 20 mm
```

Apply the same approach to:

```text
min_track_gap
solver quality
future packing controls
```

---

# 20. Phase 5 — Add Printer Presets

Introduce a separate preset file if useful:

```text
presets.scad
```

or:

```text
printer_presets.scad
```

The folded-loop solver itself must not contain printer names.

Architecture:

```text
"Bambu_A1_mini"
        ↓
printer_preset()
        ↓
[170,170]
        ↓
folded-loop solver
```

---

# 21. Bambu Preset Philosophy

Store a **recommended usable model area**, not blindly the complete advertised machine travel.

For example:

```scad
function printer_size(name) =
    name == "Bambu_A1_mini" ? [170,170] :
    name == "Bambu_A1"      ? [246,246] :
    name == "Bambu_P1P"     ? [246,246] :
    name == "Bambu_P1S"     ? [246,246] :
    name == "Bambu_P2S"     ? [246,246] :
    name == "Bambu_X1"      ? [246,246] :
    name == "Bambu_X1C"     ? [246,246] :
    undef;
```

The intent is roughly:

```text
nominal plate       folded-loop preset

180 × 180      →    170 × 170
256 × 256      →    246 × 246
```

This gives approximately a 5 mm margin on every side.

Keep both values documented:

```text
Machine nominal area
Generator recommended area
```

so users understand that the preset intentionally contains a margin.

---

# 22. Do Not Hard-Code Bambu Logic Into the Solver

Never do:

```scad
if (printer == "Bambu_A1_mini")
    special_A1_algorithm();
```

Instead:

```scad
printer = "Bambu_A1_mini"
```

resolves into:

```scad
max_size = [170,170];
```

After that, the solver has no knowledge of the printer name.

That means future presets can easily include:

```text
Prusa
Creality
Voron
Anycubic
custom printer
```

without changing `folded_loop.scad`.

---

# 23. Phase 6 — Add Beginner Belt Aliases

Retain all canonical existing profile names.

Examples:

```text
GT2_2mm
GT2_3mm
GT2_5mm
HTD_3mm
HTD_5mm
HTD_8mm
```

But optionally accept beginner-friendly aliases:

```text
GT2
2GT

HTD3M
HTD-3M

HTD5M
HTD-5M

HTD8M
HTD-8M
```

Example:

```scad
function normalize_profile(name) =
    name == "GT2"     ? "GT2_2mm" :
    name == "2GT"     ? "GT2_2mm" :

    name == "HTD3M"   ? "HTD_3mm" :
    name == "HTD-3M"  ? "HTD_3mm" :

    name == "HTD5M"   ? "HTD_5mm" :
    name == "HTD-5M"  ? "HTD_5mm" :

    name == "HTD8M"   ? "HTD_8mm" :
    name == "HTD-8M"  ? "HTD_8mm" :

    name;
```

Internally, only canonical names are used.

This preserves backwards compatibility.

---

# 24. Phase 7 — Common Belt Presets

The project already contains many profiles.

The beginner documentation should highlight a smaller subset.

Recommended initial quick-select group:

```text
GT2_2mm
GT2_3mm
GT2_5mm

HTD_3mm
HTD_5mm
HTD_8mm

T2.5
T5
```

Keep all existing profiles available to advanced users.

Do not create separate geometry implementations for these profiles.

---

# 25. Optional Belt Presets

Later, common combinations could be represented with helper presets:

```scad
belt_preset = "HTD5_9mm";
```

which resolves to approximately:

```text
profile = HTD_5mm
width = 9
default backing = profile default
```

However, this should be considered optional.

The simpler:

```scad
tooth_profile = "HTD_5mm";
belting_width = 9;
```

is already understandable.

Avoid excessive preset abstraction.

---

# 26. Phase 8 — Automatic Bend-Radius Defaults

For beginner mode:

```scad
min_bend_radius = undef;
```

should resolve to a profile-specific conservative default.

Example architecture:

```scad
function default_bend_radius(profile) =
    ...
;
```

Important:

These values should initially be described as:

> **Generator packing defaults**

not as manufacturer-approved material minimum bend radii.

The existing README already correctly states that the current 15 mm radius is a design input rather than a material qualification.

Physical testing remains necessary.

---

# 27. Automatic Track-Gap Defaults

Similarly:

```scad
min_track_gap = undef;
```

should resolve to a safe packing default.

For example:

```scad
resolved_gap =
    is_undef(min_track_gap)
        ? default_track_gap(profile)
        : min_track_gap;
```

The solver already checks clearance using a conservative envelope rather than merely testing path-center intersections.

That behavior should remain.

---

# 28. Phase 9 — Advanced Solver Controls

Do not expose all current internal search constants to beginners.

Current search behavior includes:

```text
3 inner-radius candidates
3 spacing candidates
8 inner connector branches
8 outer connector branches
16 extent intervals
up to 64 root iterations
```

Initially expose only:

```scad
solver_quality = "normal";
```

Possible presets:

```text
fast
normal
high
exhaustive
```

For example:

```text
fast
→ fewer candidate radii/spacings/brackets

normal
→ current search

high
→ broader spacing/radius/phase search

exhaustive
→ significantly broader candidate family
```

Keep individual search-array controls internal unless there is a clear need for them.

---

# 29. Expand the Search Phase Later

The current solver fixes several candidate families, including a fixed relative spiral phase. A failed search therefore means:

> No valid solution was found inside the searched candidate family.

It does not prove that no geometric solution exists.

The README already makes this distinction.

Future `solver_quality = "high"` can search:

```text
more inner radii
more track spacings
multiple phase offsets
more extent brackets
optional overall rotations
```

without changing the public geometry API.

---

# 30. Final Public API

Recommended eventual `belting()` signature:

```scad
module belting(

    // Standard belt settings
    print_layout = undef,
    tooth_profile = undef,
    tooth_count = undef,
    belt_length = undef,

    belting_width = undef,
    backing_thickness = undef,

    // Explicit geometry
    max_diameter = maximum_diameter,
    max_size = undef,

    // Folded-loop controls
    min_bend_radius = undef,
    min_track_gap = undef,

    // Numerical controls
    length_tolerance = 0.01,
    geometry_tolerance = 0.02,

    // New arguments appended after the previous API
    printer = undef,
    allow_rotate = true,
    solver_quality = "normal"
)
```

Legacy layouts can simply ignore parameters that do not apply to them.

---

# 31. Beginner Example

The README should lead with something like:

```scad
use <timing_belt_generator.scad>

belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    printer = "Bambu_A1_mini"
);
```

This is the lowest-friction experience.

---

# 32. Beginner Customization Example

Then show:

```scad
belting(
    print_layout = "folded_loop",

    // Belt type
    tooth_profile = "HTD_5mm",

    // Belt length
    tooth_count = 254,

    // Optional belt dimensions
    belting_width = 9,
    backing_thickness = 1.73,

    // Printer preset
    printer = "Bambu_A1_mini"
);
```

---

# 33. Beginner Custom Printer Example

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    max_size = [200,180]
);
```

No printer preset is required.

---

# 34. Advanced Example

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    belting_width = 9,
    backing_thickness = 1.73,

    max_size = [170,170],

    min_bend_radius = 18,
    min_track_gap = 3,

    length_tolerance = 0.005,
    geometry_tolerance = 0.01,

    allow_rotate = true,
    solver_quality = "high"
);
```

This should call exactly the same solver as beginner mode.

---

# 35. Configuration Resolution Pipeline

Internally, build one resolved configuration:

```text
USER INPUT
   │
   ▼
normalize profile aliases
   │
   ▼
lookup profile metadata
   │
   ├── pitch
   ├── default backing
   ├── default width
   └── tooth envelope
   │
   ▼
resolve tooth count / belt length
   │
   ▼
resolve printer preset / max_size
   │
   ▼
resolve automatic bend radius
   │
   ▼
resolve automatic gap
   │
   ▼
resolve solver quality
   │
   ▼
VALIDATE CONFIGURATION
   │
   ▼
folded_loop_belt(...)
```

Do not let parameter resolution occur independently in multiple layout functions.

---

# 36. Tooth Count / Belt-Length Resolution

Use generic pitch:

```scad
resolved_count =
    !is_undef(tooth_count)
        ? tooth_count
        : ceil(
            belt_length /
            tooth_pitch
        );
```

Then:

```scad
target_length =
    resolved_count *
    tooth_pitch;
```

Explicit `tooth_count` continues to take precedence over `belt_length`, matching the existing API.

---

# 37. Validation Output

Improve status output so both beginner and advanced users can understand what was resolved.

Example:

```text
Folded-loop configuration

Profile:
  HTD_5mm

Pitch:
  5.000 mm

Requested teeth:
  254

Nominal reference length:
  1270.000 mm

Belt width:
  9.000 mm
  source: profile default

Backing:
  1.730 mm
  source: profile default

Printer:
  Bambu_A1_mini

Usable area:
  170 × 170 mm
  source: printer preset

Minimum bend radius:
  15 mm
  source: automatic profile default

Track clearance:
  2 mm
  source: automatic profile default

Solver:
  normal
```

Then after solving:

```text
PATH VALID

Reference length:
  1270.002 mm

Footprint:
  164.2 × 136.0 mm

Rotation:
  0°

Minimum radius:
  15.0 mm

Certified clearance:
  2.06 mm
```

This also makes beginner presets transparent rather than mysterious.

---

# 38. Validation Errors Should Include Suggestions

Instead of only:

```text
No valid layout found
```

beginner-facing errors can explain which constraint was limiting.

For example:

```text
No folded-loop layout found.

Requested:
  HTD-5M
  254 teeth
  1270 mm
  Bambu A1 mini preset: 170 × 170 mm

Constraints:
  minimum radius: 20 mm
  minimum gap: 5 mm

Try:
  - reducing minimum bend radius;
  - reducing track gap;
  - selecting a larger printer;
  - using solver_quality = "high".
```

Do not silently weaken any constraint.

---

# 39. Testing Strategy

The current project already documents tests covering count/length precedence, rectangle behavior, 255 teeth, topology and other folded-loop checks.

Expand them in stages.

## Profile-resolution tests

Test:

```text
GT2_2mm
GT2_3mm
GT2_5mm
HTD_3mm
HTD_5mm
HTD_8mm
T2.5
T5
```

Verify:

```text
correct pitch
correct default width
correct default backing
correct envelope
correct target length
```

---

# 40. Pitch Regression Tests

Example:

```text
GT2 100T
→ 200 mm reference length

HTD3M 100T
→ 300 mm

HTD5M 100T
→ 500 mm

HTD8M 100T
→ 800 mm

T5 100T
→ 500 mm
```

This specifically detects future reintroduction of hard-coded 5 mm assumptions.

---

# 41. Beginner/Advanced Equivalence Test

This is especially important.

Beginner:

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_5mm",
    tooth_count = 254,
    printer = "Bambu_A1_mini"
);
```

should resolve to the same effective values as:

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    belting_width = 9,
    backing_thickness = 1.73,

    max_size = [170,170],

    min_bend_radius = DEFAULT_HTD5_RADIUS,
    min_track_gap = DEFAULT_HTD5_GAP,

    allow_rotate = true,
    solver_quality = "normal"
);
```

Given identical resolved parameters, both calls must generate equivalent geometry.

This proves that beginner mode is merely a preset layer.

---

# 42. Printer-Preset Tests

Verify that:

```text
printer preset
→ correct usable dimensions
```

and:

```text
explicit max_size
→ overrides printer preset
```

For example:

```scad
printer = "Bambu_A1_mini";
max_size = [160,165];
```

must use:

```text
160 × 165
```

not:

```text
170 × 170
```

---

# 43. Rotation Tests

Verify:

```text
candidate = 164 × 136
bed = 180 × 140
→ valid at 0°

bed = 140 × 180
→ valid at 90°
```

This closes the current rectangular-bed limitation.

---

# 44. Backward Compatibility

The refactor must preserve existing calls such as:

```scad
belting(
    "loop",
    "XL",
    tooth_count = 35,
    belting_width = 6.35
);
```

The existing generator's example uses this style.

Likewise:

```text
straight
loop
loop_inner
loop_outer
loop_match
loop_offset
spiral
```

must continue to behave as before.

The new profile resolver should preferably become shared infrastructure without changing their output.

---

# 45. File Organization

Recommended structure after refactoring:

```text
timing-belt-generator/
│
├── timing_belt_generator.scad
│
│   public belting() API
│   layout dispatch
│
├── profiles.scad
│
│   profile names
│   aliases
│   pitch
│   default dimensions
│   tooth polygons / envelope
│
├── folded_loop.scad
│
│   generic compact closed-path solver
│
├── printer_presets.scad
│
│   Bambu and future printer presets
│
├── examples/
│   │
│   ├── beginner_a1mini_htd5.scad
│   ├── beginner_custom_size.scad
│   └── advanced_folded_loop.scad
│
└── tests/
```

The exact file split is optional, but the responsibility boundaries are useful.

---

# 46. Documentation Structure

Recommended README order:

```text
1. What this generator does

2. Quick Start
   └── beginner folded-loop example

3. Choose Your Belt
   ├── GT2
   ├── HTD
   └── other common types

4. Choose Your Printer
   ├── Bambu A1 mini
   ├── Bambu A1
   ├── Bambu P-series
   ├── Bambu X-series
   └── custom size

5. Belt Length
   ├── tooth_count
   └── belt_length

6. Intermediate Configuration
   ├── width
   └── backing

7. Advanced Folded-Loop Settings
   ├── bend radius
   ├── track gap
   ├── tolerances
   ├── rotation
   └── solver quality

8. Supported Belt Profiles

9. Validation / Physical Printing Notes

10. Mathematical / Developer Details
```

A beginner should be able to stop after sections 2–4.

---

# 47. Recommended Development Sequence

Implement in this exact order:

```text
Phase 1
Centralize profile resolution
        ↓

Phase 2
Replace every literal 5 in folded_loop
with tooth_pitch
        ↓

Phase 3
Parameterize tooth envelope
        ↓

Phase 4
Remove HTD_5mm-only assertion
        ↓

Phase 5
Regression-test multiple belt profiles
        ↓

Phase 6
Add 90° rectangular-bed rotation
        ↓

Phase 7
Add automatic/default bend radius
and track gap
        ↓

Phase 8
Add printer preset resolver
        ↓

Phase 9
Add Bambu presets
        ↓

Phase 10
Add beginner profile aliases
        ↓

Phase 11
Add beginner README/examples
        ↓

Phase 12
Add solver_quality
        ↓

Phase 13
Expand search family if needed
```

The profile work deliberately comes before the beginner preset system.

---

# 48. Definition of Done — Generic Core

The folded-loop core is considered generic when all of these work without special-case code:

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "GT2_2mm",
    tooth_count = ...
);
```

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_3mm",
    tooth_count = ...
);
```

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_5mm",
    tooth_count = ...
);
```

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_8mm",
    tooth_count = ...
);
```

with:

```text
correct pitch
correct target length
correct profile defaults
correct collision envelope
correct tooth stationing
correct closing pitch
```

---

# 49. Definition of Done — Beginner Layer

Beginner mode is complete when this is enough:

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_5mm",
    tooth_count = 254,
    printer = "Bambu_A1_mini"
);
```

and the program automatically resolves all other required values.

The user should not need to understand:

```text
Dubins paths
spiral extent
inner radius search
track-spacing candidates
root solving
geometry tolerance
connector families
```

to generate a belt.

---

# 50. Definition of Done — Advanced Layer

Advanced users must still be able to explicitly control:

```text
profile
tooth count / length
belt width
backing thickness
custom print area
minimum radius
minimum track gap
length tolerance
geometry tolerance
rotation
solver quality
```

without using any printer preset.

For example:

```scad
belting(
    print_layout = "folded_loop",

    tooth_profile = "HTD_5mm",
    tooth_count = 254,

    belting_width = 9,
    backing_thickness = 1.73,

    max_size = [170,170],

    min_bend_radius = 15,
    min_track_gap = 2,

    length_tolerance = 0.01,
    geometry_tolerance = 0.02,

    allow_rotate = true,
    solver_quality = "high"
);
```

---

# 51. Core Design Rule

The project should maintain this separation:

```text
PRESETS ANSWER:
"What parameters should I use?"

PROFILE RESOLUTION ANSWERS:
"What are the physical properties of this belt?"

SOLVER ANSWERS:
"Can this numerical belt fit in this numerical area?"

RENDERER ANSWERS:
"How do I create the actual belt solid?"
```

The solver should never answer:

```text
"What is an A1 mini?"
```

or:

```text
"What is HTD-5M?"
```

It should receive only resolved numerical inputs.

---

# 52. Final Architecture

The finished system should look like:

```text
                    USER
                     │
          ┌──────────┴──────────┐
          │                     │
      BEGINNER              ADVANCED
          │                     │
 printer/profile          explicit values
    presets                    │
          │                     │
          └──────────┬──────────┘
                     ▼
             INPUT NORMALIZATION
                     │
                     ▼
             PROFILE RESOLUTION
                     │
       ┌─────────────┼──────────────┐
       │             │              │
     pitch         defaults      envelope
       │             │              │
       └─────────────┴──────────────┘
                     │
                     ▼
             PRINTER RESOLUTION
                     │
                     ▼
            PARAMETER OVERRIDES
                     │
                     ▼
               VALIDATION
                     │
                     ▼
          GENERIC FOLDED-LOOP SOLVER
                     │
       ┌─────────────┼──────────────┐
       │             │              │
    path solve    clearance      bounds
       │             │              │
       └─────────────┴──────────────┘
                     │
                     ▼
           EXACT PITCH STATIONING
                     │
                     ▼
                 RENDERING
                     │
                     ▼
              PRINTABLE BELT
```

The key principle is:

> **Beginner mode and advanced mode are two ways of supplying parameters to one generic folded-loop generator. They are not two different generators.**

And the first refactor should be:

> **Move belt-profile knowledge out of `folded_loop.scad`: resolve pitch, default dimensions, and tooth envelope before calling the solver.**

Once that is done, printer presets and beginner ergonomics can be added safely without turning the 254T HTD-5M/A1-mini example into a permanent special case.
