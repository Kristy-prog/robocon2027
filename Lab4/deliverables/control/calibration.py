import odrive
from odrive.enums import *

AXIS_SPEC = {
    "motor": "N5065",
    "pole_pairs": 7,
    "encoder_cpr": 8192,
    "encoder_mode": "quadrature",
    "pulley_teeth": 34,
    "pulley_pitch_mm": 5.0,
    "belt_travel_mm_per_turn": 170.0,
    "travel_limit_turns": 0.94,
    "pos_gain": 20.0,
    "vel_gain": 1/6,
    "vel_integrator_gain": 2/6,
    "vel_limit": 2.0,
    "current_limit": 10.0,
    "direction_sign": 1,
}

print("Connecting to ODrive...")
odrv0 = odrive.find_any()
print(f"Connected. Firmware: {odrv0.get_firmware_version()}")

# ---- Encoder config ----
print("Configuring encoder...")
odrv0.axis0.encoder.config.mode = ENCODER_MODE_INCREMENTAL
odrv0.axis0.encoder.config.cpr = AXIS_SPEC["encoder_cpr"]

# ---- Motor config ----
odrv0.axis0.motor.config.pole_pairs = AXIS_SPEC["pole_pairs"]
odrv0.axis0.motor.config.current_lim = AXIS_SPEC["current_limit"]

# ---- Controller config ----
odrv0.axis0.controller.config.pos_gain = AXIS_SPEC["pos_gain"]
odrv0.axis0.controller.config.vel_gain = AXIS_SPEC["vel_gain"]
odrv0.axis0.controller.config.vel_integrator_gain = AXIS_SPEC["vel_integrator_gain"]
odrv0.axis0.controller.config.vel_limit = AXIS_SPEC["vel_limit"]

# ---- Full calibration sequence ----
print("Running full calibration sequence...")
print("WAIT for motor to beep and finish before continuing.")
odrv0.axis0.requested_state = AXIS_STATE_FULL_CALIBRATION_SEQUENCE

# ---- Save ----
odrv0.save_configuration()
print("Calibration complete and saved.")