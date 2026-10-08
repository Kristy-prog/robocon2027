import odrive
from odrive.enums import *
import time

AXIS_SPEC = {
    "belt_travel_mm_per_turn": 170.0,
    "travel_limit_turns": 0.94,
    "direction_sign": 1,
}

def mm_to_turns(mm):
    return mm / AXIS_SPEC["belt_travel_mm_per_turn"]

print("Connecting to ODrive...")
odrv0 = odrive.find_any()

# ---- Position control mode ----
odrv0.axis0.controller.config.control_mode = CONTROL_MODE_POSITION_CONTROL
odrv0.axis0.requested_state = AXIS_STATE_CLOSED_LOOP_CONTROL

# ---- Move to +10 mm ----
target_mm = 10.0
target_turns = mm_to_turns(target_mm) * AXIS_SPEC["direction_sign"]

print(f"Commanding {target_mm} mm = {target_turns:.4f} turns")
odrv0.axis0.controller.input_pos = target_turns

time.sleep(2)
pos = odrv0.axis0.encoder.pos_estimate
print(f"Reached: {pos:.4f} turns = {pos * 170:.2f} mm")

# ---- Return to 0 ----
print("Returning to 0...")
odrv0.axis0.controller.input_pos = 0
time.sleep(2)
print(f"At: {odrv0.axis0.encoder.pos_estimate:.4f} turns")