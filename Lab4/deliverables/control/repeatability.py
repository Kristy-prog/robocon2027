import odrive
from odrive.enums import *
import time
import statistics

AXIS_SPEC = {
    "belt_travel_mm_per_turn": 170.0,
    "direction_sign": 1,
}

def mm_to_turns(mm):
    return mm / AXIS_SPEC["belt_travel_mm_per_turn"]

odrv0 = odrive.find_any()

odrv0.axis0.controller.config.control_mode = CONTROL_MODE_POSITION_CONTROL
odrv0.axis0.requested_state = AXIS_STATE_CLOSED_LOOP_CONTROL

TARGET_MM = 10.0
TURNS = mm_to_turns(TARGET_MM) * AXIS_SPEC["direction_sign"]
RUNS = 5

results = []
for i in range(RUNS):
    odrv0.axis0.controller.input_pos = 0
    time.sleep(1)
    odrv0.axis0.controller.input_pos = TURNS
    time.sleep(1)
    pos = odrv0.axis0.encoder.pos_estimate
    mm = pos * AXIS_SPEC["belt_travel_mm_per_turn"]
    dev = abs(mm - TARGET_MM)
    results.append((i, TURNS, pos, mm, dev))
    print(f"Run {i+1}: cmd={TURNS:.4f} turns, meas={pos:.4f} turns, {mm:.2f} mm, dev={dev:.2f} mm")

devs = [r[4] for r in results]
print(f"\nMax deviation: {max(devs):.2f} mm")
print(f"Mean deviation: {statistics.mean(devs):.2f} mm")