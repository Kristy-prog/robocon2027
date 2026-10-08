# Implementation Plan: Folded Closed-Loop HTD Belt Generator

## 1. Goal and scope

Add `print_layout = "folded_loop"` to generate a seamless, closed TPU belt in a compact print arrangement. Solve and validate the reference path before placing teeth or generating the backing.

The primary acceptance case is:

| Property | Target |
| --- | --- |
| Profile | `HTD_5mm` (HTD-5M) |
| Tooth count | 254 |
| Nominal pitch / target reference-path length | 5 mm / 1270 mm |
| Belt width in Z | 9 mm |
| Backing thickness | 1.73 mm |
| Complete geometry footprint | At most 170 × 170 mm |
| Minimum reference-path bend radius | 15 mm |
| Minimum clearance between nonlocal belt sections | 2 mm |
| Intended printer / slicer | Bambu Lab A1 mini / Bambu Studio |

**254 teeth supersedes the earlier 255-tooth setting following the pulley-distance correction.** The earlier application description used two 22-tooth pulleys and a 580 mm center distance; the generator acceptance input is the corrected 254-tooth count, not a new pulley-distance calculation.

This document specifies future generator work. It does not claim that the target packing has been demonstrated. Existing straight, circular-loop variants, and open spiral layouts must retain their behavior. The first folded-loop version supports only HTD-5M, but accepts arbitrary positive integer tooth counts rather than hard-coding 254. Supporting other profiles is deferred.

## 2. Reference path and physical interpretation

The reference path is the **tooth-root baseline**, consistent with the existing generator: the tooth polygon's local origin lies on the path, its positive Y side protrudes toward the belt interior, and the backing extends toward negative local Y. It is not the backing centerline or an established material neutral axis.

Orient the simple closed path counterclockwise. For unit tangent `t = [tx, ty]`, use the left normal `n = [-ty, tx]`. Map tooth local X to `t`, local Y to `n`, and place the backing between `P` and `P - backing_thickness * n`. Apply this convention through both bend directions and the closing join.

A target length of `N * tooth_pitch` and tooth stations at `i * tooth_pitch` establish CAD arc-length spacing on this baseline within numerical tolerances. They do not prove operating pitch after a printed belt is unfolded, stretched, or loaded. Physical pulley-fit validation is required before declaring the belt suitable for the application. The 15 mm minimum radius is a configurable design constraint, not a validated TPU material limit.

## 3. Public API and compatibility

Append new optional parameters to `belting()` so existing positional arguments remain compatible. Dispatch the new layout to `folded_loop_belt()` after resolving profile defaults and tooth count.

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_5mm",
    tooth_count = 254,
    belting_width = 9,
    backing_thickness = 1.73,
    max_size = [170, 170],
    min_bend_radius = 15,
    min_track_gap = 2,
    length_tolerance = 0.01,
    geometry_tolerance = 0.02
);
```

| New parameter | Default | Meaning |
| --- | --- | --- |
| `max_size` | `undef` | Resolve to `[max_diameter, max_diameter]` when omitted; otherwise use this explicit XY rectangle for folded-loop bounds. |
| `min_bend_radius` | `15` | Minimum radius of curvature of the analytic reference path, in mm. |
| `min_track_gap` | `2` | Minimum physical air gap between nonlocal belt sections, in mm. |
| `length_tolerance` | `0.01` | Total reference-length and closing-station acceptance budget, in mm. |
| `geometry_tolerance` | `0.02` | Maximum boundary approximation deviation, in mm; it is not permission to exceed footprint or clearance constraints. |

Do not introduce `layout_quality` or a fixed subdivision count per tooth. These explicit tolerances control accuracy. Existing `$fa`/`$fs` settings may refine a mesh but must not relax the new tolerances.

For folded-loop mode, explicit `max_size` takes precedence over `max_diameter`; bypass diameter-based validation and diameter/backing deductions for this branch when a valid explicit rectangle is supplied. Keep existing layouts' validation and parameter behavior unchanged.

Require finite positive dimensions, radius, width, backing thickness, and tolerances; require a finite nonnegative gap. Require a positive integer `tooth_count` when supplied. Preserve the existing count-over-length precedence; if count is omitted, require a positive finite `belt_length` and resolve `ceil(belt_length / tooth_pitch)`. Reject unsupported folded-loop profiles explicitly. Reject dimensions or thicknesses that prevent valid backing offsets or tooth attachment during geometry validation.

## 4. Analytic path representation and accuracy

Represent the path as an ordered list of oriented analytic segments: straight lines, circular arcs, and Archimedean spiral intervals. Each segment supplies position, unit tangent, curvature, length, and inverse arc-length evaluation. Keep cumulative segment lengths for station lookup. Sampled polylines are derived render/validation artifacts, not the authoritative length or curvature model.

For the spiral, with angles expressed in radians mathematically:

\[
r(\theta) = r_i + b\theta
\]

\[
L_{spiral} = \int_{\theta_0}^{\theta_1}\sqrt{r(\theta)^2+b^2}\,d\theta
\]

Use analytic length evaluation for lines and arcs, and an analytic antiderivative or bounded numerical evaluation for spirals. Convert explicitly at OpenSCAD trigonometric boundaries, where angles are in degrees. Curvature validation must evaluate the analytic spiral curvature, not assume that polar radius equals bend radius:

\[
\kappa(\theta)=\frac{r^2+2b^2}{(r^2+b^2)^{3/2}}
\]

Use these error budgets for default `length_tolerance = 0.01 mm`, scaling proportionally if overridden:

| Operation | Maximum error / residual |
| --- | --- |
| Total path-length evaluation error | 0.001 mm |
| Length solver residual | 0.005 mm |
| Each inverse arc-length station evaluation | 0.001 mm |
| Final accepted total-length error | 0.01 mm, including evaluation uncertainty |
| Closing station interval error | 0.01 mm, including length and station uncertainty |

Check every ordinary station interval with the combined uncertainty of its endpoints; do not describe floating-point results as mathematically exact. Endpoint joins must coincide within 0.001 mm and tangent directions within 0.001 degrees. Do not conceal a positional discontinuity with an unmeasured closing line; any added segment belongs in the length and curvature model. Curvature magnitude may jump at tangent-continuous joins, but each side must satisfy the radius constraint.

## 5. Candidate packing and joint connector solver

Use an interleaved double Archimedean spiral as the initial candidate family, subject to the feasibility gate in Milestone A. One arm runs outward and the other inward; inner and outer connectors complete one simple closed path.

An initial radial construction is:

\[
b=s/\pi,\qquad r_A(\theta)=r_i+b\theta,\qquad r_B(\theta)=r_A(\theta)+s
\]

Here `s` is radial arm separation, not a guaranteed minimum Euclidean or geometry clearance. Start exploration around 8–10 mm separation, but validate actual geometry. A semicircle between tracks 10 mm apart has radius 5 mm and therefore fails the target 15 mm constraint.

Generate pose-matching connector candidates from circular-arc/line families `LSL`, `RSR`, `LSR`, `RSL`, `RLR`, and `LRL`. Reserve center and outer space when constructing spiral candidates. Each endpoint pose must use the actual traversal direction, including the reversed spiral arm.

Evaluate **pairs** of inner and outer connectors. Reject candidates with invalid endpoint tangency, excessive curvature, self-intersections, connector-to-connector collisions, connector-to-arm collisions, insufficient nonlocal envelope clearance, or footprint overflow. Do not greedily select the shortest connector at either end in isolation.

Search within a finite, deterministic candidate set of inner radii, radial spacings, spiral extents, and connector branches. Record the explored ranges and search limits in diagnostics. For each fixed connector branch, seek a continuous feasible interval bracketing the target length. Use bounded root refinement only within that interval; use monotonic binary search only where monotonicity is established. A branch switch, infeasible sample, or discontinuity requires splitting or discarding the interval, not continuing the same binary search. Cap root refinement at 64 iterations per bracket and report nonconvergence.

Select among fully validated target-length candidates by smallest footprint area, then greatest minimum clearance, then deterministic enumeration order. Validate the selected result again at final tolerances. If the target case cannot pass the feasibility gate, report the explored limits and revise the candidate family before proceeding to production geometry; do not silently relax constraints or substitute an open spiral.

The corrected length equation is:

\[
L_{target}=N p=L_A+L_{outer}+L_B+L_{inner}
\]

For this acceptance case, `N = 254`, `p = 5 mm`, and `L_target = 1270 mm`.

## 6. Tooth stations and backing geometry

Place exactly `N` teeth at reference distances:

\[
s_i=i p,\qquad i=0,\ldots,N-1
\]

For the target case these are 0, 5, …, 1265 mm. Measure intervals along the reference path, not as straight-line distances between tooth origins. The closing interval is `path_length - 1265 mm` and must equal 5 mm within the total closing error budget. Do not duplicate the tooth at the path endpoint or rescale tooth pitch to hide a failed length solve.

Reuse the existing `HTD_5mm` polygon unchanged. Pass `tooth_profile` and `belt_width` explicitly to `belt_tooth()`. Preserve its root overlap with the backing and verify attachment at every tooth, especially through reversed curvature and connector joins.

Build the backing from the baseline and its outward normal offset. Tessellate both boundaries adaptively so the maximum deviation from their analytic curves is at most `geometry_tolerance`. Include every analytic segment boundary and the closed seam. Share boundary vertices between neighboring cells or use a closed ribbon construction that avoids cracks and degenerate faces. Extrude to `belt_width` and union with the teeth.

One segment per tooth is not sufficient by default: a 5 mm arc at 15 mm radius has approximately 0.21 mm chord deviation. Tessellation must account for offset-boundary curvature as well as baseline curvature. Changing render subdivision must not move tooth stations or change the authoritative reference length.

## 7. Envelope, topology, and fit validation

Introduce folded-loop envelope metadata derived from the existing HTD-5M polygon: tangential extent, maximum positive protrusion, and negative root depth, together with resolved backing thickness. Preserve the existing profile/default API; the new metadata can be a separate lookup.

The approximate HTD-5M protrusion is 2.198511 mm and the default backing is 1.73 mm. Their sum, approximately 3.93 mm, is not a universal track-spacing formula. Facing teeth, facing backs, finite tooth width, and bends produce different clearance requirements.

Before final geometry, conservatively bound the full tooth and backing sweep, including tooth tangential extent and all orientations. Expand bounds by numerical and tessellation uncertainty. A conservative envelope may reject a feasible packing; it must not accept one by underestimating occupied space. Use adaptive subdivision where a coarse bound is inconclusive.

Validate:

- A simple, closed, consistently oriented reference path with tangent-continuous joins and valid offset boundaries.
- Minimum analytic bend radius of at least the requested value, including both sides of joins.
- Full geometry within the XY rectangle after centering; path bounds alone are insufficient.
- Minimum gap between nonlocal belt sections, including both connectors and every arm. Exclude only intended local continuity/root attachment from collision checks; an adjacency exemption must not hide a fold touching another section.
- All teeth attached by positive-volume root/backing overlap; no detached teeth, degenerate triangles, or unintended nonlocal contacts.
- Final STL watertightness, manifoldness, one connected solid, and the intended single-loop topology (one through-hole; genus one for its closed surface). Connectivity alone does not rule out bridges or fused tracks.

Use conservative distance lower bounds that account for both surfaces' approximation errors. Validate the exported mesh as well as the analytic design; a successful render alone is insufficient.

## 8. Internal flow and helper contracts

The following is algorithmic pseudocode, not executable OpenSCAD. All helper behavior below is future implementation work.

```text
folded_loop_belt(profile, tooth_count, tooth_pitch, belt_width,
                 backing_thickness, max_size, min_bend_radius,
                 min_track_gap, length_tolerance, geometry_tolerance):
    validate_folded_inputs(all arguments)
    target_length = tooth_count * tooth_pitch
    envelope = profile_envelope(profile, backing_thickness)
    constraints = {max_size, min_bend_radius, min_track_gap,
                   length_tolerance, geometry_tolerance, envelope}
    solution = solve_folded_loop_path(target_length, constraints)
    require solution.success; otherwise report reason and search limits
    path = solution.path
    require validate_path_and_envelope(path, target_length, constraints)

    poses = [pose_at_distance(path, i * tooth_pitch)
             for i in 0 .. tooth_count - 1]
    require validate_station_intervals(path, poses, tooth_pitch,
                                       length_tolerance)
    backing = make_backing(path, backing_thickness, belt_width,
                           geometry_tolerance)
    teeth = [place_existing_tooth(profile, belt_width, pose)
             for pose in poses]
    require validate_attachment_and_nonlocal_clearance(backing, teeth,
                                                       constraints)
    return union(backing, teeth)
```

`pose_at_distance(path, s)` returns `[x, y, tangent_angle_degrees]`, using bounded inverse arc-length evaluation and the counterclockwise convention. Its station records must retain reference distances and evaluation uncertainty for interval validation. The actual tooth placement uses the existing module with complete arguments:

```scad
translate([pose[0], pose[1], 0])
    rotate([0, 0, pose[2]])
        belt_tooth(tooth_profile = tooth_profile, belt_width = belt_width);
```

`solve_folded_loop_path()` returns either a validated candidate plus diagnostics or an explicit failure record. Path validation and geometry validation must gate production output; echoing a warning and proceeding is not sufficient. Exported-mesh topology checks belong in the external verification workflow rather than being implied by SCAD assertions.

## 9. Diagnostics and failure behavior

Report requested and resolved tooth count, nominal pitch, target and calculated reference length, numerical error bounds, closing interval, complete footprint, minimum bend radius, conservative minimum clearance, and connector/search information. Separate path validation, geometry validation, exported-mesh validation, and physical-fit status.

Do not print invented successful measurements. Until evaluated, report measurements as `not evaluated` and physical fit as `not tested`.

Invalid input should fail explicitly before geometry generation. For exhausted packing searches use:

```text
No valid layout found within the configured candidate family and search limits.
Requested: 254T HTD-5M, 1270 mm reference length, 170 × 170 mm footprint,
15 mm minimum reference-path bend radius, 2 mm minimum geometry clearance.
```

This is an example diagnostic format, not a measured result or proof of mathematical impossibility. Include the actual failure category, bounds, branch/iteration counts, and rejected-constraint summary. Never output a partial belt as a successful closed-loop result.

## 10. Milestones and acceptance tests

### A. Reference path and conservative envelope feasibility

Generate a diagnostic path and envelope before full teeth or solids. Demonstrate the target 1270 mm closed reference path within 0.01 mm total error, tangent-continuous joins, radius at least 15 mm, no self-intersections, full conservative envelope at most 170 × 170 mm, and nonlocal clearance at least 2 mm. Include connector-to-connector checks. A 1 mm diagnostic line alone does not establish belt clearance.

This is a feasibility gate. Record measured diagnostics and the reproducible candidate parameters. If it fails, revisit packing before subsequent milestones; do not claim the double spiral fits.

### B. Tooth-station verification

Generate exactly 254 markers at 5 mm reference arc-length intervals. Verify every interval, including the final-to-first interval, within the allocated uncertainty. Check segment-boundary stations, orientation through reversed bends, and no duplicate endpoint marker. Repeat with finer numerical evaluation to confirm the reported error bounds.

### C. Physical geometry and export

Replace markers with existing HTD-5M teeth, generate the adaptive backing, and render/export STL. Verify positive-volume tooth attachment, requested width, footprint, nonlocal clearance, watertight manifoldness, one connected solid, and single-loop topology without bridges. Repeat with a tighter geometry tolerance and confirm station invariance and stable fit/clearance conclusions.

### D. Slicer and physical fit

Open the exported STL in Bambu Studio on the intended A1 mini plate. Confirm placement, footprint, layer continuity, and separated tracks; account for slicer additions such as brim separately from the model footprint. Print the prototype and check unfolding, engagement with the intended pulleys, usable length, and operation under the application's intended conditions. Record material and print settings alongside observations. CAD acceptance alone does not satisfy physical-fit acceptance.

### E. Regression and failure scenarios

- Corrected primary case: 254 teeth, 1270 mm target reference length, and all constraints above.
- Other positive integer counts, including 255; fit is not assumed, and failure must be explicit when no candidate is found.
- Count-over-length precedence, length-only rounding, explicit rectangle precedence, and omitted-rectangle fallback to `max_diameter`.
- Unsupported profiles; zero, negative, fractional, undefined, or nonfinite inputs where invalid; malformed rectangles; and unsafe offsets or detached teeth.
- Deliberately too-small rectangles and excessive radius/gap constraints: no invalid or partial production output.
- Connector branch transitions, infeasible intervals, missing brackets, and bounded-search nonconvergence.
- Near-clearance and near-footprint cases, closing seam, tooth placement at joins, and potential connector/track bridges.
- Existing straight, circular-loop variants, and open spiral examples retain their pre-change behavior; importing with `use` does not render the library example.

## 11. Development order

1. Define the appended API, analytic segment operations, reference convention, and tolerance accounting.
2. Implement candidate spirals, paired connectors, bounded branch search, and conservative envelope validation.
3. Pass Milestone A for the corrected acceptance case before committing to the packing family.
4. Implement and verify arc-length stations (Milestone B).
5. Generate backing and existing teeth; complete geometry/export checks (Milestone C).
6. Complete slicer inspection, physical-fit validation, and regressions (Milestones D–E).

The feature is complete only when the recorded CAD and export checks pass and physical-fit status is explicitly reported. A failure to validate physical fit must remain visible rather than being replaced with a claim of exact operating pitch.
