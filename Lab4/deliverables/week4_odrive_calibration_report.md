# Week 4 ODrive Calibration Report

**Name:** Kristy
**Date:** __________
**Board:** ODrive v3.6 (clone, firmware 0.5.1)
**Motor:** N5065 BLDC
**Encoder:** AMT103

---

## 1. Safety Gate (Step 2.0)

- [ ] E-Stop present and verified: press → lift holds, release → normal
- Signed off by: __________ (demonstrator name + initial)

---

## 2. Mounted Pulley Verification

| Item | Expected | Measured |
|------|----------|----------|
| Pulley tooth count | 34T | ______ |
| Pitch | 5 mm (HTD5M) | 5 mm |
| Pitch radius | ≈ 27.07 mm | ______ mm |
| Belt travel per motor rev | 170 mm | ______ mm |

---

## 3. Encoder Configuration (Step 2.2)

| Item | Value |
|------|-------|
| Encoder mode | Quadrature |
| A/B pins | GPIO3 / GPIO4 |
| Z pin | GPIO5 |
| PPR | ______ |
| CPR | ______ |

---

## 4. Motor Calibration (Step 2.3)

| Item | Value |
|------|-------|
| Resistance (R) | ______ Ω |
| Inductance (L) | ______ mH |
| Recovered pole pairs | ______ |
| Encoder offset | ______ |

Notes:
- Calibration run with belt decoupled: ______
- Belt re-coupled and re-tensioned after: ______

---

## 5. Direction Check (Step 2.4)

| Item | Value |
|------|-------|
| Direction sign | ______ |
| Usable travel range | ______ turns |
| Notes | |

---

## 6. Position PID & Limits (Step 2.5)

| Parameter | Value |
|-----------|-------|
| pos_gain | ______ |
| vel_gain | ______ |
| vel_integrator_gain | ______ |
| vel_limit | ______ turn/s |
| vel_ramp_rate | ______ turn/s² |
| current_limit | ______ A |

---

## 7. Travel Limit

| Item | Value |
|------|-------|
| Rail length | 200 mm |
| Carriage body | 40 mm |
| Free travel | 160 mm |
| Belt travel per turn | 170 mm |
| Max turns | 0.94 turn |
| Command range | ______ |

---

## 8. mm → Turns Conversion

| Item | Value |
|------|-------|
| 1 turn | 170 mm |
| +10 mm | ______ turns |
| +85 mm (sanity check) | 0.5 turns |
| Full travel | 0.94 turns |

---

## 9. Repeatability (Step 2.8)

**Commanded target: +10 mm = ______ turns**

| Run | Commanded (turns) | Measured (turns) | Measured (mm) | Deviation (mm) |
|-----|-------------------|------------------|---------------|----------------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |

| Statistic | Value |
|-----------|-------|
| Max deviation | ______ mm |
| Mean deviation | ______ mm |

---

## 10. NVM Save & Reboot (Steps 2.6–2.7)

- [ ] `save_configuration()` acknowledged
- [ ] Power-cycle reboot
- [ ] Pole pairs after reboot = 7
- [ ] Encoder mode after reboot = quadrature
- [ ] CPR after reboot = 8192
- [ ] PID/limits after reboot match
- [ ] Zero-index search observed on reboot (expected)

---

## 11. Notes

- Calibration run with belt decoupled (Step 2.3)
- Belt re-coupled and re-tensioned after calibration
- Zero-index search observed on reboot (expected)
- Drift direction: ______
- Belt stretch comparison from Week 3: ______

---

## 12. Signed Off

| Item | Signature |
|------|-----------|
| Safety gate | __________ |
| Demonstrator | __________ |
| Date | __________ |