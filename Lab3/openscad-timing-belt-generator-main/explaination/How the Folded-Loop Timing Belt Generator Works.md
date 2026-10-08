# How the Folded-Loop Timing Belt Generator Works

This document explains, in beginner-friendly terms, how the `folded_loop` algorithm takes a long closed timing belt and arranges it into a compact shape that can fit on a smaller 3D-printer bed.

The example used throughout is:

```scad
belting(
    print_layout = "folded_loop",
    tooth_profile = "HTD_5mm",
    tooth_count = 254,
    belting_width = 9,
    backing_thickness = 1.73,
    max_size = [170, 170],
    min_bend_radius = 15,
    min_track_gap = 2
);
```

This corresponds to:

- HTD-5M belt
- 5 mm tooth pitch
- 254 teeth
- 1270 mm reference length
- 9 mm belt width
- 1.73 mm backing thickness
- approximately 170 × 170 mm printable area
- minimum 15 mm bend radius
- minimum 2 mm gap between unrelated belt sections

The current implementation is generic: pitch is resolved from the selected belt profile, short belts can use a circle, and longer belts use the compact double-spiral solver.

---

## Overall Diagram

!:chatgpt-content-reference{index="2"}

The most important idea is:

> The belt is not stacked on top of itself and it is not sharply folded like paper.

Instead, the belt remains completely flat on the build plate and is **coiled into a smooth closed path**.

---

# 1. First Ignore the Teeth

The easiest way to understand the algorithm is to temporarily imagine the timing belt as a very long flexible string.

For the HTD-5M example:

```text
tooth count = 254
pitch       = 5 mm
```

The total required reference length is therefore:

\[
L=N\times p
\]

where:

- \(L\) = belt reference length
- \(N\) = number of teeth
- \(p\) = tooth pitch

Therefore:

\[
L=254\times5
\]

\[
\boxed{L=1270\text{ mm}}
\]

The program's first geometric problem is therefore:

> How can one continuous, closed, 1270 mm long path fit inside approximately 170 × 170 mm without crossing itself or bending too sharply?

The current implementation calculates the target length generically as:

```scad
L = count * tooth_pitch;
```

so the same algorithm can work with other pitches as well.

---

# 2. What Does “Folded” Actually Mean?

The word `folded_loop` can be slightly misleading.

The belt is **not folded vertically**.

It does not do this:

```text
belt
───────
belt
───────
belt
───────
```

with multiple layers stacked in Z.

Everything stays in one flat XY plane.

A better mental model is:

> Imagine placing a long garden hose on the floor and winding it neatly into a spiral.

The important difference is that a timing belt must still be a **closed loop**.

Therefore the algorithm uses **two interleaved spiral arms** rather than one ordinary open spiral.

---

# 3. Before Folding, Try a Simple Circle

A closed belt naturally wants to form a circle.

The algorithm therefore first asks:

> Can this belt fit as an ordinary circular loop?

For a circle:

\[
C=2\pi R
\]

Therefore:

\[
R=\frac{L}{2\pi}
\]

For the 1270 mm belt:

\[
R=\frac{1270}{2\pi}
\]

\[
R\approx202.1\text{ mm}
\]

So the circle diameter would be:

\[
D\approx404.3\text{ mm}
\]

That is much larger than the target 170 × 170 mm area.

So the circular layout does not fit.

The program therefore moves to the folded double-spiral layout.

For shorter belts, however, the circle is used directly if it already satisfies the available area, bend-radius, and clearance constraints. The current solver explicitly checks a circular candidate before running the more expensive spiral search.

---

# 4. What Is a Spiral?

The solver uses an **Archimedean spiral**.

The name sounds complicated, but the basic idea is simple:

> Every time you rotate around the center, move outward by a constant amount.

Its equation is:

\[
r=r_i+b\theta
\]

where:

- \(r\) = current distance from the center
- \(r_i\) = starting distance from the center
- \(\theta\) = how far around the center we have rotated
- \(b\) = how quickly the spiral moves outward

You can think of it like this:

| Rotation | Radius |
|---|---:|
| 0° | 30 mm |
| 90° | 34 mm |
| 180° | 38 mm |
| 270° | 42 mm |
| 360° | 46 mm |

Those numbers are only an illustration.

The key idea is that the radius increases smoothly as the path turns around the center.

The actual code represents spiral segments analytically rather than as arbitrary hand-drawn curves.

---

# 5. Why One Spiral Is Not Enough

A normal spiral has two loose ends.

That would produce something similar to the generator's older `spiral` print layout, which is an **open belt**.

A closed timing belt cannot have loose ends.

So `folded_loop` creates:

1. Spiral A
2. Spiral B
3. an outer connector
4. an inner connector

The final path is:

```text
Spiral A
    ↓
Outer connector
    ↓
Spiral B
    ↓
Inner connector
    ↓
Back to Spiral A
```

This produces one continuous closed loop.

The implementation literally builds the candidate path from two spiral segments plus two connector paths.

---

# 6. The Two Spirals Are Interleaved

Imagine Spiral A making several turns.

Instead of placing Spiral B far away, Spiral B travels through the spaces between Spiral A's turns.

Conceptually:

```text
Spiral A turn
      ↓
----------------

      spacing

----------------
      ↑
Spiral B turn

      spacing

----------------
      ↑
next Spiral A turn
```

This lets a lot of belt length fit into a small area.

Both spirals remain side by side.

They do **not** overlap and do not stack vertically.

---

# 7. How Spiral Spacing Works

The algorithm has a variable called approximately:

```text
spacing
```

This controls how far apart neighboring spiral paths are.

The spiral uses:

\[
b=\frac{s}{\pi}
\]

where \(s\) is the spacing.

After one complete revolution:

\[
\theta=2\pi
\]

the radius changes by:

\[
\Delta r=b(2\pi)
\]

Substituting:

\[
b=\frac{s}{\pi}
\]

gives:

\[
\Delta r=
\frac{s}{\pi}(2\pi)
\]

so:

\[
\boxed{\Delta r=2s}
\]

Why is that useful?

Because there are two spiral arms.

This gives roughly:

```text
Spiral A
   |
   | spacing
   |
Spiral B
   |
   | spacing
   |
next Spiral A turn
```

So the two spiral arms can neatly interleave.

The implementation derives the spiral coefficient from the requested spacing using this relationship.

---

# 8. The Spiral Ends Need Smooth Connections

The spiral ends do not automatically point toward each other in the correct way.

Simply joining them using a sharp corner would produce something like:

```text
───────┐
       │
       │
```

That would have essentially zero bend radius.

For a printed TPU belt this is undesirable.

Instead the generator creates smooth connecting curves.

For example:

```text
──────────╮
          │
          ╰────────
```

The important requirement is:

\[
R\ge R_{\min}
\]

For the example:

\[
R_{\min}=15\text{ mm}
\]

So the solver must never create a bend tighter than the requested 15 mm radius.

---

# 9. The Connector Algorithm Can Be Understood Like Driving a Car

The connector algorithm uses the same general type of problem as finding a path for a car with a minimum turning radius.

Imagine a car starting at one point:

```text
position A
direction →
```

and needing to reach another point:

```text
position B
direction ↑
```

The car cannot instantly turn 90°.

It needs some combination of:

- left turn
- right turn
- straight section

The code uses these basic symbols:

```text
L = left turn
R = right turn
S = straight
```

Possible connector types include:

```text
LSL
LSR
RSL
RSR
LRL
RLR
```

For example:

```text
LSR
```

means:

1. turn left
2. travel straight
3. turn right

The implementation tests all six Dubins-style connector families, including alternate circle-intersection branches for the three-turn cases.

---

# 10. There Are Two Connectors

The double spiral needs two joins.

One is on the outside:

```text
end of Spiral A
        ↓
outer connector
        ↓
start of Spiral B
```

The other is on the inside:

```text
end of Spiral B
        ↓
inner connector
        ↓
start of Spiral A
```

Once both connections exist, there are no loose ends.

The result is one continuous loop.

---

# 11. The Program Does Not Know the Correct Spiral Length Initially

Suppose the required belt length is:

\[
1270\text{ mm}
\]

The program may try a spiral layout and calculate:

```text
1100 mm
```

That is too short.

Another candidate might produce:

```text
1400 mm
```

That is too long.

The solver therefore changes how far the spiral winds around.

This spiral amount is called approximately its **extent**.

More extent means:

```text
more turns
→ more path length
```

Less extent means:

```text
fewer turns
→ less path length
```

---

# 12. How the Length Solver Finds 1270 mm

The program calculates an error:

\[
\text{error}
=
L_{\text{candidate}}
-
L_{\text{target}}
\]

For example:

```text
candidate = 1200 mm
target    = 1270 mm

error = -70 mm
```

Negative means too short.

Another candidate:

```text
candidate = 1350 mm
target    = 1270 mm

error = +80 mm
```

Positive means too long.

Now the program knows the correct answer lies somewhere between those two values.

It repeatedly narrows the search.

Example:

```text
1200      1350
   \      /
    try 1275
```

1275 is slightly too long.

Now search:

```text
1200      1275
```

Try halfway again.

Continue until the remaining error is smaller than the requested length tolerance.

The current root-refinement solver uses up to 64 iterations for a candidate branch.

---

# 13. It Tries Many Different Spiral Shapes

The program does not assume that one specific spiral arrangement will work.

It searches different combinations of:

- inner starting radius
- track spacing
- spiral phase
- spiral extent
- inner connector type
- outer connector type

Different solver-quality levels search different numbers of possibilities.

The current README describes:

| Quality | Inner radii | Spacings | Relative phases | Extent intervals |
|---|---:|---:|---:|---:|
| fast | 1 | 1 | 1 | 8 |
| normal | 3 | up to 3 | 1 | 16 |
| high | 5 | up to 5 | 3 | 32 |

All connector combinations still have to pass the same geometry validation.

So the process resembles:

```text
Candidate #1
→ does not fit

Candidate #2
→ connector impossible

Candidate #3
→ belt sections too close together

Candidate #4
→ valid

Candidate #5
→ valid but larger

Choose the better valid result
```

---

# 14. The Belt Has Real Thickness

Up to this point we have talked about a mathematical line.

A mathematical line has zero thickness.

A real timing belt does not.

The belt has:

- teeth
- backing thickness
- tooth width in the XY profile

Therefore the program cannot merely ask:

> Do the reference lines cross?

Two reference lines might not cross but their actual timing-belt geometry could still collide.

---

# 15. The Tooth Envelope

The solver calculates an invisible safety region around the actual tooth profile.

Imagine:

```text
Safety envelope
┌─────────────────────────┐
│      /\    /\    /\     │
│_____/  \__/  \__/  \____│
│████████ backing ████████│
└─────────────────────────┘
```

The current generic implementation calculates this envelope from the actual preserved tooth polygon rather than using the old HTD-5M-only approximation.

This means changing:

```scad
tooth_profile = "GT2_2mm";
```

or:

```scad
tooth_profile = "HTD_8mm";
```

changes the collision envelope appropriately.

---

# 16. Minimum Track Gap

The parameter:

```scad
min_track_gap = 2;
```

means approximately:

> After accounting for the real belt geometry, unrelated portions of the folded belt should still have at least 2 mm of free space between them.

Conceptually:

```text
belt section

██████████

   2 mm
   gap

██████████

belt section
```

The implementation samples separated portions of the path and performs conservative clearance checks using the belt envelope plus geometric-error allowance.

---

# 17. Bend Radius Validation

The parameter:

```scad
min_bend_radius = 15;
```

does not simply affect the two end connectors.

The solver checks curvature of the entire path.

Every spiral section and circular connector must satisfy:

\[
R\ge15\text{ mm}
\]

for this example.

If some part of the candidate bends tighter than that, the entire candidate is rejected.

---

# 18. Smooth-Junction Validation

Where one path segment meets another, two things must match.

## Position must match

The end of segment A must be the same point as the beginning of segment B.

Conceptually:

```text
segment A ─────●───── segment B
               ↑
           same point
```

## Direction must match

Bad:

```text
────────●
         \
          \
```

There is a kink.

Good:

```text
────────●────╮
             ╰────
```

The path changes curvature, but its direction remains continuous.

The implementation checks both endpoint position and tangent direction at each path join.

---

# 19. Printer-Bed Validation

The algorithm calculates the complete belt's XY envelope.

It then checks:

```text
belt width in X <= printer width

and

belt height in Y <= printer depth
```

For the A1 mini preset, the generator currently uses:

```text
170 × 170 mm
```

rather than the full nominal 180 × 180 mm area, intentionally leaving a 5 mm inset on each side.

If rotation is allowed, the algorithm can also test the candidate rotated by 90°.

---

# 20. At This Stage We Have a Valid Reference Path

Only after all of the following pass:

- exact required length
- closed topology
- minimum bend radius
- smooth joins
- no invalid self-collision
- required track clearance
- printer-area limit

does the algorithm consider the path valid.

At this point we still only have the belt's reference line.

We have not placed the teeth yet.

---

# 21. Now the Teeth Are Positioned

For HTD-5M:

\[
p=5\text{ mm}
\]

The algorithm walks around the final valid path and places teeth at:

\[
s_i=i\,p
\]

For 254 teeth:

| Tooth | Distance around path |
|---:|---:|
| 0 | 0 mm |
| 1 | 5 mm |
| 2 | 10 mm |
| 3 | 15 mm |
| ... | ... |
| 253 | 1265 mm |

The remaining distance from tooth 253 back to tooth 0 is:

\[
1270-1265
\]

\[
=5\text{ mm}
\]

So the closing tooth pitch is also correct.

The current implementation explicitly calculates each tooth location using:

```scad
i * tooth_pitch
```

and separately validates the closing interval.

---

# 22. Teeth Are Positioned by Distance, Not Angle

This is very important.

The program does **not** say:

```text
put one tooth every X degrees
```

because the path radius constantly changes.

Instead it says:

```text
walk 5 mm along the actual path
place a tooth

walk another 5 mm
place another tooth

walk another 5 mm
place another tooth
```

That means tooth pitch remains correct even while the belt is curving.

---

# 23. How Does Each Tooth Know Which Direction to Face?

At every point on the path, the program calculates the path's local direction.

This direction is called the **tangent**.

Imagine travelling along a road.

On a straight section:

```text
→ → → → →
```

On a curve:

```text
→
 ↘
   ↓
  ↙
←
```

At every tooth location, the generator knows:

```text
X position
Y position
tangent angle
```

The tooth is rotated so its orientation follows the belt.

The code's pose calculation returns the point together with the tangent angle, which is later used to rotate the individual tooth geometry.

---

# 24. Build the Belt Backing

The reference path represents the tooth-root baseline.

The belt also needs a backing behind this line.

For example:

```text
      tooth
        /\
_______/  \_______
------------------  tooth-root reference path
██████████████████  backing
```

The algorithm calculates the direction perpendicular to the local path.

This perpendicular direction is called the **normal**.

It then offsets the reference path by:

```text
backing_thickness
```

to create another boundary.

So there are effectively two curves:

```text
reference boundary
===================

backing boundary
===================
```

The area between them becomes the backing strip.

The current renderer creates the inner and outer path polygons from these offsets.

---

# 25. Add the Actual Tooth Polygon

After the backing shape exists, the existing tooth profile is placed at every exact station.

For example:

```scad
tooth_profile = "HTD_5mm";
```

uses the existing HTD-5M polygon.

If:

```scad
tooth_profile = "GT2";
```

is selected, the GT2 polygon is used instead.

The generic generator preserves each original tooth polygon and resolves the appropriate pitch and default dimensions from the selected profile.

The folded-loop algorithm does not stretch one tooth shape into another.

---

# 26. Union Everything in 2D

The generator now has:

```text
backing strip
+
tooth #0
+
tooth #1
+
...
+
tooth #253
```

These shapes are unioned together in 2D.

The implementation deliberately performs this union before 3D extrusion to reduce the possibility of tiny coplanar slivers in the final STL.

---

# 27. Extrude the Belt to Its Width

Until this point, everything has essentially been a 2D top view.

For example:

```scad
belting_width = 9;
```

means:

> Take the complete 2D belt shape and extrude it 9 mm in Z.

So:

```text
2D belt profile
      ↓
linear extrusion
      ↓
9 mm wide 3D belt
```

The result is one printable 3D timing-belt loop.

---

# 28. The Complete Algorithm in Simple Steps

For the example HTD-5M belt:

```text
254 teeth
```

with:

```text
5 mm pitch
```

the generator performs these steps:

### Step 1 — Calculate belt length

\[
254\times5=1270\text{ mm}
\]

### Step 2 — Try a circular loop

Required diameter:

\[
1270/\pi\approx404\text{ mm}
\]

Too large for 170 × 170 mm.

### Step 3 — Create Spiral A

Create an Archimedean spiral.

### Step 4 — Create Spiral B

Create another interleaved spiral beside Spiral A.

### Step 5 — Join the outside ends

Use a smooth minimum-radius connector.

### Step 6 — Join the inside ends

Use another smooth minimum-radius connector.

Now there is one closed path.

### Step 7 — Adjust spiral extent

Change how many turns the spirals make until:

\[
L_{\text{path}}\approx1270\text{ mm}
\]

within the requested tolerance.

### Step 8 — Validate bend radius

Require:

\[
R\ge15\text{ mm}
\]

for the example.

### Step 9 — Validate clearance

Require the real belt geometries to remain separated by the requested gap.

### Step 10 — Validate printer fit

Require the belt envelope to fit inside:

```text
170 × 170 mm
```

for the A1 mini preset.

### Step 11 — Place teeth

Walk along the path and place a tooth every:

\[
5\text{ mm}
\]

### Step 12 — Verify closing pitch

Check that the final tooth back to the first tooth is also exactly one pitch.

### Step 13 — Create backing

Offset the reference path by the backing thickness.

### Step 14 — Add tooth geometry

Place and rotate each actual tooth polygon.

### Step 15 — Union and extrude

Create one 2D belt polygon and extrude it to the requested belt width.

---

# 29. The Three Main Equations to Understand

Most of `folded_loop.scad` contains implementation mathematics that users do not need to understand.

For practical understanding, only three formulas are essential.

## Belt length

\[
\boxed{L=Np}
\]

Meaning:

> Belt length equals tooth count multiplied by tooth pitch.

For the example:

\[
254\times5=1270\text{ mm}
\]

---

## Spiral growth

\[
\boxed{r=r_i+b\theta}
\]

Meaning:

> As we rotate farther around the center, gradually move farther outward.

This creates the spiral.

---

## Tooth stations

\[
\boxed{s_i=i\,p}
\]

Meaning:

> Walk around the final belt path and place one tooth every exact pitch distance.

For HTD-5M:

```text
0 mm
5 mm
10 mm
15 mm
20 mm
...
```

---

# 30. What the More Complicated Math Is Doing

The complicated-looking equations in `folded_loop.scad` mainly solve four practical questions.

### “How long is this spiral?”

The solver needs the exact arc length of the spiral.

### “Where am I after travelling X mm?”

Needed to place every tooth at exact pitch spacing.

### “How can these two spiral ends connect smoothly?”

Solved using minimum-radius Dubins-style connector candidates.

### “Does this belt actually fit without touching itself?”

Solved using footprint and clearance tests.

You do not need to manually calculate these values when using the generator.

---

# 31. What `solver_quality` Changes

The solver may fail to find a valid layout even if some mathematical layout exists, because it searches a bounded set of possible shapes.

The current modes are:

```text
fast
normal
high
```

A higher setting searches more:

- starting radii
- track spacings
- spiral phase offsets
- spiral extents

but does **not** weaken:

- bend-radius requirements
- track-gap requirements
- numerical accuracy
- printer limits

The README explicitly notes that a failed search does not prove the requested belt is mathematically impossible.

---

# 32. Automatic Bend Radius

For beginner usage, the generator can automatically choose a packing radius.

The current rule is:

\[
R_\text{auto}
=
\max(
3p,\;
3(E+G)
)
\]

where:

- \(p\) = tooth pitch
- \(E\) = belt envelope
- \(G\) = requested gap

The purpose is to avoid choosing a very tight radius when either the tooth geometry or the spacing requirement is relatively large.

This is a **packing default**, not a manufacturer-approved minimum material bend radius.

---

# 33. Important Physical Limitation

The algorithm can prove that the CAD model has:

- correct mathematical reference length
- correct tooth station spacing
- correct closing pitch
- no modeled self-intersection
- requested minimum modeled radius
- requested clearance
- correct printer footprint

But it cannot prove that a real printed TPU belt will behave exactly like a commercial reinforced timing belt.

The model's reference path is the **tooth-root baseline**.

It is not experimentally calibrated as the material's neutral axis.

When the belt is removed from the plate and straightened or installed around pulleys, TPU deformation can affect:

- effective pitch
- residual curvature
- tooth geometry
- tension
- pulley fit

The project's README therefore explicitly states that physical TPU printing and pulley-fit validation are still necessary.

---

# 34. Simplest Mental Model

If all of the mathematics is still confusing, think of the algorithm this way:

1. Imagine the timing belt as a long piece of string.
2. Calculate exactly how long that string must be.
3. Try to make it a circle.
4. If the circle is too large, wind it into two interleaved spirals.
5. Join the spiral ends using smooth curves.
6. Adjust the spiral until the string has exactly the required length.
7. Check that the string does not cross itself.
8. Give the string the actual thickness of the belt.
9. Check again that neighboring belt sections do not touch.
10. Walk along the string at exact tooth-pitch distances.
11. Put one correctly rotated tooth at every position.
12. Add the backing.
13. Extrude the whole shape to the requested belt width.

So the core principle is:

> **Solve the closed path first. Add the timing-belt teeth afterward.**

That separation is what allows the same folded-loop algorithm to work with different timing-belt profiles, pitches, lengths, widths, printer sizes, bend radii, and clearances.
