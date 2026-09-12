; HEADER_BLOCK_START
; BambuStudio 02.06.00.51
; model printing time: 5m 39s; total estimated time: 11m 4s
; total layer number: 28
; total filament length [mm] : 935.86
; total filament volume [cm^3] : 2251.01
; total filament weight [g] : 2.84
; filament_density: 1.26
; filament_diameter: 1.75
; max_z_height: 5.60
; filament: 1
; HEADER_BLOCK_END

; CONFIG_BLOCK_START
; accel_to_decel_enable = 0
; accel_to_decel_factor = 50%
; activate_air_filtration = 0
; additional_cooling_fan_speed = 75
; additional_fan_full_speed_layer = 0
; apply_scarf_seam_on_circles = 1
; auxiliary_fan = 1
; avoid_crossing_wall_includes_support = 0
; bed_custom_model = 
; bed_custom_texture = 
; bed_exclude_area = 
; bed_temperature_formula = by_first_filament
; before_layer_change_gcode = 
; best_object_pos = 0.5,0.5
; bottom_color_penetration_layers = 3
; bottom_shell_layers = 3
; bottom_shell_thickness = 0
; bottom_surface_density = 100%
; bottom_surface_pattern = monotonic
; bridge_angle = 0
; bridge_flow = 1
; bridge_no_support = 0
; bridge_speed = 50
; brim_object_gap = 0.1
; brim_type = auto_brim
; brim_width = 5
; chamber_temperatures = 0
; change_filament_gcode = ;===== machine: H2S filament_change =====\n;===== date: 2026/01/28 =====\n\nM993 A2 B2 C2 ; nozzle cam detection allow status save.\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K0 ;disable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620 S[next_extruder]A\nM1002 gcode_claim_action : 4\nM204 S9000\n\nG1 Z{max_layer_z + 3.0} F1200\n\nM400\nM106 P1 S0\nM106 P2 S0\n\n{if toolchange_count == 2}\n; get travel path for change filament\n;M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0\n;M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1\n;M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2\n{endif}\n\nM620.10 A0 F{flush_volumetric_speeds[current_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[current_extruder]} T{flush_temperatures[current_extruder]} P[old_filament_temp] S1\nM620.10 A1 F{flush_volumetric_speeds[next_extruder]/2.4053*60*0.8} L[flush_length] H{nozzle_diameter[next_extruder]} T{flush_temperatures[next_extruder]} P[new_filament_temp] S1\n\n{if long_retraction_when_cut}\nM620.11 P1 I[current_extruder] E-{retraction_distance_when_cut} F{max((flush_volumetric_speeds[current_extruder]/2.4053*60), 200)}\n{else}\nM620.11 P0 I[current_extruder] E0\n{endif}\n\n\n{if filament_type[current_extruder] == "TPU" || filament_type[next_extruder] == "TPU"}\nM620.11 H2 C331\n{else}\nM620.11 H0\n{endif}\n\nM620.15 C{new_filament_temp - filament_cooling_before_tower[next_extruder]}\n\nT[next_extruder]\n\n\n; VFLUSH_START\n\n{if flush_length>41.5}\n;VG1 E41.5 F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n;VG1 E{flush_length-41.5} F{new_filament_e_feedrate}\n{else}\n;VG1 E{flush_length} F{min(old_filament_e_feedrate,new_filament_e_feedrate)}\n{endif}\n\nSYNC T{ceil(flush_length / 125) * 5}\n\n; VFLUSH_END\n\nM1002 set_filament_type:{filament_type[next_extruder]}\n\nM400\nM83\n{if next_extruder < 255}\n\nM620.10 R{retract_length_toolchange[filament_map[next_extruder]-1]}\nM628 S0\n;VM109 S[new_filament_temp]\n\nM629\nM400\n\n;prime_tower_interface\n{if is_prime_tower_interface && filament_tower_interface_purge_volume !=0}\nG150.1\nM620.13 W0 L{filament_tower_interface_purge_volume} T{filament_tower_interface_print_temp} R0.0\n{endif}\n;prime_tower_interface\n\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{retract_length_toolchange[filament_map[next_extruder]-1]}\n\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\n{else}\nG1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000\n{endif}\nM621 S[next_extruder]A\n\nM622.1 S0 ;for prev version, default skip\nM1002 judge_flag powerloss_resume_flag\nM622 J1\nM983.3 F{filament_max_volumetric_speed[next_extruder]/2.4} A0.4 R{retract_length_toolchange[filament_map[next_extruder]-1]}\nM400\n{if wipe_avoid_perimeter}\nG1 Y320 F30000\nG1 X{wipe_avoid_pos_x} F30000\n{endif}\nG1 Y295 F30000\nG1 Y265 F18000\nG1 Z{max_layer_z + 3.0} F3000\n{if layer_z <= (initial_layer_print_height + 0.001)}\nM204 S[initial_layer_acceleration]\n{else}\nM204 S[default_acceleration]\n{endif}\nM1002 set_flag powerloss_resume_flag=0\nM623\n\nM993 A3 B3 C3 ; nozzle cam detection allow status restore.\n\n{if (filament_type[next_extruder] == "PLA") ||  (filament_type[next_extruder] == "PETG")\n ||  (filament_type[next_extruder] == "PLA-CF")  ||  (filament_type[next_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 ; disable E air printing detect\n{endif}\n\nM620.6 I[next_extruder] W1 ;enable ams air printing detect\nM1002 gcode_claim_action : 0\n
; circle_compensation_manual_offset = 0
; circle_compensation_speed = 200
; close_additional_fan_first_x_layers = 1
; close_fan_the_first_x_layers = 1
; complete_print_exhaust_fan_speed = 70
; cool_plate_temp = 35
; cool_plate_temp_initial_layer = 35
; cooling_filter_enabled = 0
; cooling_perimeter_transition_distance = 10
; cooling_slowdown_logic = uniform_cooling
; counter_coef_1 = 0
; counter_coef_2 = 0.0025
; counter_coef_3 = 0.014
; counter_limit_max = 0.076
; counter_limit_min = 0.014
; curr_bed_type = Textured PEI Plate
; default_acceleration = 10000
; default_filament_colour = ""
; default_filament_profile = "Bambu PLA Basic @BBL H2S"
; default_jerk = 0
; default_nozzle_volume_type = Standard
; default_print_profile = 0.20mm Standard @BBL H2S
; deretraction_speed = 30
; detect_floating_vertical_shell = 1
; detect_narrow_internal_solid_infill = 1
; detect_overhang_wall = 1
; detect_thin_wall = 0
; diameter_limit = 50
; draft_shield = disabled
; during_print_exhaust_fan_speed = 70
; elefant_foot_compensation = 0.15
; embedding_wall_into_infill = 0
; enable_arc_fitting = 1
; enable_circle_compensation = 0
; enable_filament_dynamic_map = 0
; enable_height_slowdown = 0
; enable_long_retraction_when_cut = 2
; enable_mixed_color_sublayer = 0
; enable_overhang_bridge_fan = 1
; enable_overhang_speed = 1
; enable_pre_heating = 0
; enable_pressure_advance = 0
; enable_prime_tower = 0
; enable_support = 0
; enable_support_ironing = 0
; enable_tower_interface_features = 0
; enable_wrapping_detection = 0
; enforce_support_layers = 0
; eng_plate_temp = 55
; eng_plate_temp_initial_layer = 55
; ensure_vertical_shell_thickness = enabled
; exclude_object = 1
; extruder_ams_count = 1#0|4#0;1#0|4#0
; extruder_clearance_dist_to_rod = 56
; extruder_clearance_height_to_lid = 187
; extruder_clearance_height_to_rod = 33
; extruder_clearance_max_radius = 81
; extruder_colour = #018001
; extruder_max_nozzle_count = 1
; extruder_nozzle_stats = Standard#1
; extruder_offset = 0x0
; extruder_printable_area = 
; extruder_type = Direct Drive
; extruder_variant_list = "Direct Drive Standard,Direct Drive High Flow"
; fan_cooling_layer_time = 100
; fan_direction = left
; fan_max_speed = 100
; fan_min_speed = 80
; filament_adaptive_volumetric_speed = 0
; filament_adhesiveness_category = 100
; filament_bridge_speed = 25
; filament_change_length = 4
; filament_change_length_nc = 10
; filament_colour = #00AE42
; filament_colour_type = 1
; filament_cooling_before_tower = 10
; filament_cost = 24.99
; filament_density = 1.26
; filament_dev_ams_drying_ams_limitations = 1;0
; filament_dev_ams_drying_heat_distortion_temperature = 45
; filament_dev_ams_drying_temperature = 45,45,45,45
; filament_dev_ams_drying_time = 12,12,12,12
; filament_dev_chamber_drying_bed_temperature = 70
; filament_dev_chamber_drying_time = 12
; filament_dev_drying_cooling_temperature = 45
; filament_dev_drying_softening_temperature = 50
; filament_diameter = 1.75
; filament_enable_overhang_speed = 1
; filament_end_gcode = "; filament end gcode \n"
; filament_extruder_compatibility = 0
; filament_extruder_variant = "Direct Drive Standard"
; filament_flow_ratio = 0.98
; filament_flush_temp = 0
; filament_flush_volumetric_speed = 0
; filament_ids = GFA00
; filament_is_mixed = 0
; filament_is_support = 0
; filament_map = 1
; filament_map_2 = 0
; filament_map_mode = Auto For Flush
; filament_max_volumetric_speed = 25
; filament_metal_stickiness = None
; filament_minimal_purge_on_wipe_tower = 15
; filament_mixed_components = ""
; filament_mixed_gradient = 0
; filament_mixed_gradient_range = ""
; filament_mixed_sublayer_ratios = ""
; filament_multi_colour = #00AE42
; filament_notes = 
; filament_nozzle_map = 0
; filament_overhang_1_4_speed = 0
; filament_overhang_2_4_speed = 50
; filament_overhang_3_4_speed = 30
; filament_overhang_4_4_speed = 10
; filament_overhang_totally_speed = 10
; filament_pre_cooling_temperature = 0
; filament_pre_cooling_temperature_nc = 0
; filament_prime_volume = 30
; filament_prime_volume_nc = 60
; filament_printable = 3
; filament_ramming_travel_time = 0
; filament_ramming_travel_time_nc = 0
; filament_ramming_volumetric_speed = -1
; filament_ramming_volumetric_speed_nc = -1
; filament_retract_length_nc = 14
; filament_retraction_length = 0.4
; filament_scarf_gap = 0%
; filament_scarf_height = 10%
; filament_scarf_length = 10
; filament_scarf_seam_type = none
; filament_self_index = 1
; filament_settings_id = "Bambu PLA Basic @BBL H2S"
; filament_shrink = 100%
; filament_soluble = 0
; filament_start_gcode = "; filament start gcode\n"
; filament_tower_interface_pre_extrusion_dist = 10
; filament_tower_interface_pre_extrusion_length = 0
; filament_tower_interface_print_temp = -1
; filament_tower_interface_purge_volume = 20
; filament_tower_ironing_area = 4
; filament_type = PLA
; filament_velocity_adaptation_factor = 1
; filament_vendor = "Bambu Lab"
; filament_volume_map = 0
; filament_wipe = 1
; filament_wipe_distance = 1
; filament_z_hop_types = Spiral Lift
; filename_format = {input_filename_base}_{filament_type[0]}_{print_time}.gcode
; fill_multiline = 1
; filter_out_gap_fill = 0
; first_layer_print_sequence = 0
; first_x_layer_fan_speed = 0
; first_x_layer_part_fan_speed = 0
; flush_into_infill = 0
; flush_into_objects = 0
; flush_into_support = 1
; flush_multiplier = 1
; flush_volumes_matrix = 0
; flush_volumes_vector = 140,140
; full_fan_speed_layer = 0
; fuzzy_skin = none
; fuzzy_skin_first_layer = 0
; fuzzy_skin_mode = displacement
; fuzzy_skin_noise_type = classic
; fuzzy_skin_octaves = 4
; fuzzy_skin_persistence = 0.5
; fuzzy_skin_point_distance = 0.3
; fuzzy_skin_scale = 1
; fuzzy_skin_thickness = 0.2
; gap_infill_speed = 250
; gcode_add_line_number = 0
; gcode_flavor = marlin
; grab_length = 0
; group_algo_with_time = 0
; has_filament_switcher = 0
; has_scarf_joint_seam = 0
; head_wrap_detect_zone = 
; hole_coef_1 = 0
; hole_coef_2 = -0.0028
; hole_coef_3 = 0.12
; hole_limit_max = 0.12
; hole_limit_min = 0.05
; host_type = octoprint
; hot_plate_temp = 55
; hot_plate_temp_initial_layer = 55
; hotend_cooling_rate = 2
; hotend_heating_rate = 2
; impact_strength_z = 13.8
; independent_support_layer_height = 1
; infill_combination = 0
; infill_direction = 45
; infill_instead_top_bottom_surfaces = 0
; infill_jerk = 9
; infill_lock_depth = 1
; infill_rotate_step = 0
; infill_shift_step = 0.4
; infill_wall_overlap = 15%
; initial_layer_acceleration = 500
; initial_layer_flow_ratio = 1
; initial_layer_infill_speed = 105
; initial_layer_jerk = 9
; initial_layer_line_width = 0.5
; initial_layer_print_height = 0.2
; initial_layer_speed = 50
; initial_layer_travel_acceleration = 6000
; inner_wall_acceleration = 0
; inner_wall_jerk = 9
; inner_wall_line_width = 0.45
; inner_wall_speed = 300
; interface_shells = 0
; interlocking_beam = 0
; interlocking_beam_layer_count = 2
; interlocking_beam_width = 0.8
; interlocking_boundary_avoidance = 2
; interlocking_depth = 2
; interlocking_orientation = 22.5
; internal_bridge_support_thickness = 0.8
; internal_solid_infill_line_width = 0.42
; internal_solid_infill_pattern = zig-zag
; internal_solid_infill_speed = 250
; ironing_direction = 45
; ironing_fan_speed = -1
; ironing_flow = 15%
; ironing_inset = 0.21
; ironing_pattern = zig-zag
; ironing_spacing = 0.15
; ironing_speed = 30
; ironing_type = no ironing
; is_infill_first = 0
; layer_change_gcode = ;============= H2S 20250611 =============\n; layer num/total_layer_count: {layer_num+1}/[total_layer_count]\n; update layer progress\nM73 L{layer_num+1}\nM991 S0 P{layer_num} ;notify layer change
; layer_height = 0.2
; line_width = 0.42
; locked_skeleton_infill_pattern = zigzag
; locked_skin_infill_pattern = crosszag
; long_retractions_when_cut = 0
; long_retractions_when_ec = 0
; machine_end_gcode = ;========== H2S end ==========\n;===== date: 2026/03/13 =====\n\nG392 S0 ;turn off nozzle clog detect\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400 ; wait for buffer to clear\nG92 E0 ; zero the extruder\nM211 Z1\n\nG90\nG1 Z{max_layer_z + 0.4} F900 ; lower z a little\nM1002 judge_flag timelapse_record_flag\nM622 J1\n    G150.3\n    M400 ; wait all motion done\n    M991 S0 P-1 ;end smooth timelapse at safe pos\n    M400 S5 ;wait for last picture to be taken\nM623  ;end of "timelapse_record_flag"\n\nG90\nG1 Z{max_layer_z + 10} F900 ; lower z a little\n\nM141 S0 ; turn off chamber heating\nM140 S0 ; turn off bed\nM106 S0 ; turn off fan\nM106 P2 S0 ; turn off remote part cooling fan\nM106 P3 S0 ; turn off chamber cooling fan\n\n; pull back filament to AMS\nM620 S65535\nT65535\nG150.2\nM621 S65535\n\nG150.3\n\nM104 S0; turn off hotend\n\nM400 ; wait all motion done\nM17 S\nM17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom\n{if (100.0 - max_layer_z/2) > 0}\n    {if (max_layer_z + 100.0 - max_layer_z/2) < 340}\n        G1 Z{max_layer_z + 100.0 - max_layer_z/2} F600\n        G1 Z{max_layer_z + 98.0 - max_layer_z/2}\n    {else}\n        G1 Z340 F600\n        G1 Z340\n    {endif}\n{else}\n    {if (max_layer_z + 4.0) < 340}\n        G1 Z{max_layer_z + 4.0} F600\n        G1 Z{max_layer_z + 2.0}\n    {else}\n        G1 Z340 F600\n        G1 Z340\n    {endif}\n{endif}\nM400 P100\nM17 R ; restore z current\n\nM220 S100  ; Reset feedrate magnitude\nM201.2 K1.0 ; Reset acc magnitude\nM73.2   R1.0 ;Reset left time magnitude\n\nM1015.4 S0 K0 ;disable air printing detect\n\n;=====printer finish air purification=========\nM622.1 S0\nM1002 judge_flag print_finish_air_filt_flag\n\nM622 J1\nM1002 gcode_claim_action : 66\nM145 P1\nM106 P6 S255\nM400 S180\nM106 P6 S0\nM623\n\nM622 J2\nM1002 gcode_claim_action : 66\nM145 P0\nM106 P3 S127\nM400 S180\nM106 P3 S0\nM623\n;=====printer finish air purification=========\n\n;=====printer finish  sound=========\nM17\nM400 S1\nM1006 S1\nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 \nM1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 \nM1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 \nM1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 \nM1006 W\n;=====printer finish  sound=========\nM400\nM18\n\n
; machine_hotend_change_time = 0
; machine_load_filament_time = 29
; machine_max_acceleration_e = 5000,5000
; machine_max_acceleration_extruding = 20000,20000
; machine_max_acceleration_retracting = 5000,5000
; machine_max_acceleration_travel = 9000,9000
; machine_max_acceleration_x = 20000,20000
; machine_max_acceleration_y = 20000,20000
; machine_max_acceleration_z = 500,500
; machine_max_jerk_e = 2.5,2.5
; machine_max_jerk_x = 9,9
; machine_max_jerk_y = 9,9
; machine_max_jerk_z = 3,3
; machine_max_speed_e = 30,30
; machine_max_speed_x = 1000,1000
; machine_max_speed_y = 1000,1000
; machine_max_speed_z = 30,30
; machine_min_extruding_rate = 0
; machine_min_travel_rate = 0
; machine_pause_gcode = M400 U1
; machine_prepare_compensation_time = 260
; machine_start_gcode = ;===== machine: H2S =========================\n;===== date: 2026/04/21 =====================\n\n\nM993 A0 B0 C0 ; nozzle cam detection not allowed.\n\nM400\n;M73 P99\n\n;=====printer start sound ===================\nM17\nM400 S1\nM1006 S1\nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B9 L99 C61 D9 M99 E61 F9 N99 \nM1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 \nM1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 \nM1006 A61 B18 L99 C61 D18 M99 E61 F18 N99 \nM1006 W\n;=====printer start sound ===================\n\n;===== reset machine status =================\nM204 S10000\nM630 S0 P0\n\nG90\nM17 D ; reset motor current to default\nM960 S5 P1 ; turn on logo lamp\nG90\nM1002 set_gcode_claim_speed_level 5 ;Reset speed level\nM220 S100 ;Reset Feedrate\nM221 S100 ;Reset Flowrate\nM73.2   R1.0 ;Reset left time magnitude\nG29.1 Z{+0.0} ; clear z-trim value first\nM983.1 M1 \nM901 D4\nM481 S0 ; turn off cutter pos comp\nG28.140 D0; reset pre-extrude z pos\n;===== reset machine status =================\n\nM620 M ;enable remap\n\n;===== avoid end stop =================\nG91\nG380 S2 Z32 F1200\nG380 S2 Z-12 F1200\nG90\n;===== avoid end stop =================\n\n;==== set airduct mode ==== \n\n{if (overall_chamber_temperature >= 40)}\n\n    M145 P1 ; set airduct mode to heating mode for heating\n    M106 P2 S0 ; turn off auxiliary fan\n    M106 P3 S0 ; turn off chamber fan\n\n{else}\n    M145 P0 ; set airduct mode to cooling mode for cooling\n    M106 P2 S178 ; turn on auxiliary fan for cooling\n    M106 P3 S127 ; turn on chamber fan for cooling\n    M140 S0 ; stop heatbed from heating\n\n    M1002 gcode_claim_action : 29\n    M191 S0 ; wait for chamber temp\n    M106 P2 S0 ; turn off auxiliary fan\n    {if (min_vitrification_temperature <= 50)}\n        {if (nozzle_diameter == 0.2)}\n            M142 P1 R30 S35 T40 U0.3 V0.5 W0.8 O40 ; set PLA/TPU ND0.2 chamber autocooling\n        {else}\n            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling\n        {endif}\n    {else}\n        {if (!is_all_bbl_filament)}\n            M142 P1 R35 S40 T45 U0.3 V0.5 W0.8 O45 L1 ; set third-party PETG chamber autocooling\n        {else}\n            {if (nozzle_diameter == 0.2)}\n                M142 P1 R35 S45 T50 U0.3 V0.5 W0.8 O50 L1 ; set PETG ND0.2 chamber autocooling\n            {else}\n                M142 P1 R35 S50 T55 U0.3 V0.5 W0.8 O55 L1 ; set PETG ND0.4 chamber autocooling\n            {endif}\n        {endif}\n    {endif}\n{if(cooling_filter_enabled)}\nM145.2 P0 F0\n{else}\nM145.2 P0 F1\n{endif}\n{endif}\n;==== set airduct mode ==== \n\n;===== start to heat heatbed & hotend==========\n\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n\n    M104 S140\n    M140 S[bed_temperature_initial_layer_single]\n\n    ;===== set chamber temperature ==========\n    {if (overall_chamber_temperature >= 40)}\n        M145 P1 ; set airduct mode to heating mode\n        M141 S[overall_chamber_temperature] ; Let Chamber begin to heat\n    {endif}\n    ;===== set chamber temperature ==========\n\n;===== start to heat heatbead & hotend==========\n\n;====== cog noise reduction=================\nM982.2 S1 ; turn on cog noise reduction\n\n;===== first homing start =====\nM1002 gcode_claim_action : 13\n\nG28 X T300\n\nG150.3 F18000\nT1000 O0 ;Preventing 3D Print Misalignment After Laser Operations\n\nG150.1 F18000 ; wipe mouth to avoid filament stick to heatbed\nG150.3 F18000\nM400 P200\nM972 S24 P0 T2000\nM1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection\n{if curr_bed_type=="Textured PEI Plate"}\nM972 S26 P0 C0\n{else}\nM972 S36 P0 C0 X1\n{endif}\nM972 S35 P0 C0\nM972 S41 P0 T5000; trash can anti-collision\n\nM1009 Q1 L1\nG91\nG380 S2 Z30 F1200 ; lower heatbed to move toolhead\nG90\nG1 X170 Y160 F30000\nG28 Z P0 T250\nM1009 Q1 L0\n\n;===== first homing end =====\n\nM400\n;M73 P99\n\n;===== detection start =====\nM104 S0 T0 ; stop hotend heating before detection\nM562 P1 E0 B1\nM18 E\nM400 P200\nM1028 S1\n\nM1002 judge_flag build_plate_detect_flag\nM622 S1\n    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type\n    M972 S19 P0 C0 ; heatbed detection\n    \n    M972 S31 P0 T5000; Toolhead camera detection\n    \n    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection\n    M972 S34 P0 T5000; Plate offset detection\nM623\n\nM1028 S0\nM562 P1 E1 B1\nM17 D\n\n{if max_print_z >= 145}\nM1002 gcode_claim_action : 75 ;  Detect obstacles at the botton of the heated bed\nG150.3\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; rise temp in advance\nG3811 Z{max_print_z}  ; Detect obstacles at the bottom of the heated bed\n{endif}\n\n;===== detection end =====\n\nM400\n;M73 P99\n\n;===== prepare print temperature and material ==========\nM400\nM211 X0 Y0 Z0 ;turn off soft endstop\nM975 S1 ; turn on input shaping\n\nG29.2 S0 ; avoid invalid abl data\n\nM620.10 A0 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\nM620.10 A1 F{flush_volumetric_speeds[initial_no_support_extruder]/2.4053*60*0.8} H{nozzle_diameter[initial_no_support_extruder]} T{flush_temperatures[initial_no_support_extruder]} P{nozzle_temperature_initial_layer[initial_no_support_extruder]} S1\n\nM620.11 P0 I[initial_no_support_extruder] E0\n\nM620 S[initial_no_support_extruder]A   ; switch material if AMS exist\nM1002 gcode_claim_action : 4\nM1002 set_filament_type:UNKNOWN\nM400\nT[initial_no_support_extruder]\nM400\nM628 S0\nM629\nM400\nM1002 set_filament_type:{filament_type[initial_no_support_extruder]}\nM621 S[initial_no_support_extruder]A\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\nM400\nM106 P1 S0\n\nG29.2 S1\n;===== prepare print temperature and material ==========\n\nM400\n;M73 P99\n\n;===== auto extrude cali start =========================\nM975 S1\nM1002 judge_flag extrude_cali_flag\n\nM622 J0\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\nM623\n\nM622 J1\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\nM622 J2\n    M1002 set_filament_type:{filament_type[initial_no_support_extruder]}\n    M1002 gcode_claim_action : 8\n\n    M109 S{nozzle_temperature[initial_no_support_extruder]}\n\n    G90\n    M83\n    M983.3 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4} A0.4 ; cali dynamic extrusion compensation\n\n    M400\n    M106 P1 S255\n    M400 S5\n    M106 P1 S0\n    G150.3\nM623\n\n;===== auto extrude cali end =========================\n\n{if filament_type[initial_no_support_extruder] == "TPU"}\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n    G150.2\n    G150.1\n{else}\n    M106 P1 S0\n    M400 S2\n    M109 S{nozzle_temperature[initial_no_support_extruder]} ; wait tmpr to extrude\n    M83\n    {if(nozzle_diameter == 0.8)}\n        G1 E60 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {else}\n        G1 E45 F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60}\n    {endif}\n    G1 E-3 F1800\n    M400 P500\n    G150.2\n    G150.1\n{endif}\n\nG91\nG1 Y-16 F12000 ; move away from the trash bin\nG90\n\nM400\n;M73 P99\n\n;===== wipe right nozzle start =====\n\nM1002 gcode_claim_action : 14\n    G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    {if (overall_chamber_temperature >= 40)}\n        G150 T{nozzle_temperature_initial_layer[initial_no_support_extruder] - 80}\n    {endif}\nM106 S255 ; turn on fan to cool the nozzle\n\n;===== wipe left nozzle end =====\n\nM400\n;M73 P99\n\n{if (overall_chamber_temperature >= 40)}\n    M1002 gcode_claim_action : 49\n    M191 S[overall_chamber_temperature] ; wait for chamber temp\n{endif}\n\nM400\n;M73 P99\n\n;===== bed leveling ==================================\n\nM1002 judge_flag g29_before_print_flag\n\nM190 S[bed_temperature_initial_layer_single]; ensure bed temp\nM109 S140\nM106 S0 ; turn off fan , too noisy\n\nG91\nG1 Z5 F1200\nG90\nG1 X275 Y300 F30000\n\nM622 J1\n    M1002 gcode_claim_action : 1\n    G29.20 A3\n    G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    M400\nM623\n    \nM622 J2\n    M1002 gcode_claim_action : 1\n    {if has_tpu_in_first_layer}\n        G29.20 A3\n        G29 A1 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    {else}\n        G29.20 A4\n        G29 A2 O X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}\n    {endif}\n    M400\nM623\n\nM622 J0\n    G28\nM623\n\n;===== bed leveling end ================================\n\nG390.1 Z; cali nozzle wrapped detection pos\n\nG90\nG1 Z5 F1200\nG1 X270 Y-0.5 F60000\nG28.140 S0 ; cali pre-extrude z pos\n\nM141 S[overall_chamber_temperature]\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n\n;===== mech mode sweep start =====\n    M1002 gcode_claim_action : 3\n\n    G90\n    G1 Z5 F1200\n    G1 X187 Y160 F20000\n    T1000\n    M400 P200\n\n    M970.3 Q1 A5 K0 O1\n    M974 Q1 S2 P0\n\n    M970.3 Q0 A5 K0 O1\n    M974 Q0 S2 P0\n\n    M970.2 Q2 K0 W38 Z0.01\n    M974 Q2 S2 P0\n\n    M975 S1\n;===== mech mode sweep end =====\n\nM400\n;M73 P99\n\nG150.3 ; move to garbage can to wait for temp\nM1026\nG29.9\n\nM1002 gcode_claim_action : 0\nM400\n;M73 P99\n\n;===== wait temperature reaching the reference value =======\n\nM104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; rise to print tmpr\n\nM140 S[bed_temperature_initial_layer_single] \nM190 S[bed_temperature_initial_layer_single] \n\n    ;========turn off light and fans =============\n    M960 S1 P0 ; turn off laser\n    M960 S2 P0 ; turn off laser\n    M106 S0 ; turn off fan\n    M106 P2 S0 ; turn off big fan\n\n    ;============set motor current==================\n    M400 S1\n\n;===== wait temperature reaching the reference value =======\n\nM400\n;M73 P99\n\n;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==\n    {if curr_bed_type=="Textured PEI Plate"}\n        G29.1 Z{-0.01} ; for Textured PEI Plate\n    {endif}\n    \nG150.1\n\nM975 S1 ; turn on mech mode supression\nM983.4 S1 ; turn on deformation compensation \nG29.2 S1 ; turn on pos comp\nG29.7 S1\n\nG90\nG1 Z5 F1200\nG1 Y295 F30000\nG1 Y265 F18000\n\n;===== nozzle load line ===============================\n    G29.2 S1 ; ensure z comp turn on\n    G90\n    M83\n    G1 Z5 F1200\n    G1 X270 Y-0.5 F60000\n    G28.14 R0\n    G29.2 S0\n    G91\n    G1 Z0.8 F1200\n    G90\n    G1 X250 F60000\n    M400 P50\n    M500 D1\n    M400 S3\n    M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}\n    M83\n    G1 E5 F{filament_max_volumetric_speed[initial_no_support_extruder]/2/2.4053*60}\n    G1 X290 E20 F{filament_max_volumetric_speed[initial_no_support_extruder]/2/2.4053*60}\n    G91\n    G3 Z0.4 I1.217 J0 P1 F60000\n    G90\n    M83\n    G29.2 S1 ; ensure z comp turn on\n;===== noozle load line end ===========================\n\nM400\n;M73 P99\n\nM993 A1 B1 C1 ; nozzle cam detection allowed.\n\n\n{if (filament_type[initial_no_support_extruder] == "PLA") ||  (filament_type[initial_no_support_extruder] == "PETG")\n ||  (filament_type[initial_no_support_extruder] == "PLA-CF")  ||  (filament_type[initial_no_support_extruder] == "PETG-CF")}\nM1015.4 S1 K1 H[nozzle_diameter] ;enable E air printing detect\n{else}\nM1015.4 S0 K0 H[nozzle_diameter] ;disable E air printing detect\n{endif}\n\nM620.6 I[initial_no_support_extruder] W1 ;enable ams air printing detect\n\nM211 Z1\nG29.99\n\n{if (filament_type[initial_no_support_extruder] == "TPU")}\nM1015.3 S1;enable tpu clog detect\n{else}\nM1015.3 S0;disable tpu clog detect\n{endif}\n
; machine_switch_extruder_time = 0
; machine_unload_filament_time = 28
; master_extruder_id = 1
; max_bridge_length = 0
; max_layer_height = 0.28
; max_travel_detour_distance = 0
; min_bead_width = 85%
; min_feature_size = 25%
; min_layer_height = 0.08
; minimum_sparse_infill_area = 15
; mmu_segmented_region_interlocking_depth = 0
; mmu_segmented_region_max_width = 0
; monotonic_travel_into_wall = 45%
; no_slow_down_for_cooling_on_outwalls = 0
; nozzle_diameter = 0.4
; nozzle_flush_dataset = 1
; nozzle_height = 4
; nozzle_temperature = 220
; nozzle_temperature_initial_layer = 220
; nozzle_temperature_range_high = 240
; nozzle_temperature_range_low = 190
; nozzle_type = hardened_steel
; nozzle_volume = 145
; nozzle_volume_type = Standard
; only_one_wall_first_layer = 0
; ooze_prevention = 0
; other_layers_print_sequence = 0
; other_layers_print_sequence_nums = 0
; outer_wall_acceleration = 5000
; outer_wall_jerk = 9
; outer_wall_line_width = 0.42
; outer_wall_speed = 200
; overhang_1_4_speed = 0
; overhang_2_4_speed = 50
; overhang_3_4_speed = 30
; overhang_4_4_speed = 10
; overhang_fan_speed = 100
; overhang_fan_threshold = 50%
; overhang_threshold_participating_cooling = 95%
; overhang_totally_speed = 10
; override_filament_scarf_seam_setting = 0
; override_process_overhang_speed = 0
; physical_extruder_map = 0
; post_process = 
; pre_start_fan_time = 2
; precise_outer_wall = 0
; precise_z_height = 0
; pressure_advance = 0.02
; prime_tower_brim_width = 3
; prime_tower_enable_framework = 0
; prime_tower_extra_rib_length = 0
; prime_tower_fillet_wall = 1
; prime_tower_flat_ironing = 1
; prime_tower_infill_gap = 150%
; prime_tower_lift_height = -1
; prime_tower_lift_speed = 90
; prime_tower_max_speed = 90
; prime_tower_rib_wall = 1
; prime_tower_rib_width = 8
; prime_tower_skip_points = 1
; prime_tower_width = 60
; prime_volume_mode = Default
; print_compatible_printers = "Bambu Lab H2S 0.4 nozzle"
; print_extruder_id = 1
; print_extruder_variant = "Direct Drive Standard"
; print_flow_ratio = 1
; print_in_clockwise = 0
; print_sequence = by layer
; print_settings_id = 0.20mm Standard @BBL H2S
; printable_area = 0x0,340x0,340x320,0x320
; printable_height = 340
; printer_extruder_id = 1
; printer_extruder_variant = "Direct Drive Standard"
; printer_model = Bambu Lab H2S
; printer_notes = 
; printer_settings_id = Bambu Lab H2S 0.4 nozzle
; printer_structure = corexy
; printer_technology = FFF
; printer_variant = 0.4
; printhost_authorization_type = key
; printhost_ssl_ignore_revoke = 0
; printing_by_object_gcode = 
; process_notes = 
; raft_contact_distance = 0.1
; raft_expansion = 1.5
; raft_first_layer_density = 90%
; raft_first_layer_expansion = -1
; raft_layers = 0
; reduce_crossing_wall = 0
; reduce_fan_stop_start_freq = 1
; reduce_infill_retraction_mode = Auto
; required_nozzle_HRC = 3
; resolution = 0.012
; retract_before_wipe = 0%
; retract_length_toolchange = 2
; retract_lift_above = 0
; retract_lift_below = 339
; retract_restart_extra = 0
; retract_restart_extra_toolchange = 0
; retract_when_changing_layer = 1
; retraction_distances_when_cut = 18
; retraction_distances_when_ec = 0
; retraction_length = 0.8
; retraction_minimum_travel = 1
; retraction_speed = 30
; role_base_wipe_speed = 1
; scan_first_layer = 0
; scarf_angle_threshold = 155
; seam_gap = 15%
; seam_placement_away_from_overhangs = 0
; seam_position = aligned
; seam_slope_conditional = 1
; seam_slope_entire_loop = 0
; seam_slope_gap = 0
; seam_slope_inner_walls = 1
; seam_slope_min_length = 10
; seam_slope_start_height = 10%
; seam_slope_steps = 10
; seam_slope_type = none
; silent_mode = 0
; single_extruder_multi_material = 1
; skeleton_infill_density = 15%
; skeleton_infill_line_width = 0.45
; skin_infill_density = 15%
; skin_infill_depth = 2
; skin_infill_line_width = 0.45
; skirt_distance = 2
; skirt_height = 1
; skirt_loops = 0
; slice_closing_radius = 0.049
; slicing_mode = regular
; slow_down_for_layer_cooling = 1
; slow_down_layer_time = 4
; slow_down_min_speed = 20
; slowdown_end_acc = 100000
; slowdown_end_height = 400
; slowdown_end_speed = 1000
; slowdown_start_acc = 100000
; slowdown_start_height = 0
; slowdown_start_speed = 1000
; small_perimeter_speed = 50%
; small_perimeter_threshold = 0
; smooth_coefficient = 4
; smooth_speed_discontinuity_area = 1
; solid_infill_filament = 0
; sparse_infill_acceleration = 100%
; sparse_infill_anchor = 400%
; sparse_infill_anchor_max = 20
; sparse_infill_density = 15%
; sparse_infill_filament = 0
; sparse_infill_lattice_angle_1 = -45
; sparse_infill_lattice_angle_2 = 45
; sparse_infill_line_width = 0.45
; sparse_infill_pattern = grid
; sparse_infill_speed = 350
; spiral_mode = 0
; spiral_mode_max_xy_smoothing = 200%
; spiral_mode_smooth = 0
; standby_temperature_delta = -5
; start_end_points = 30x-3,54x245
; supertack_plate_temp = 40
; supertack_plate_temp_initial_layer = 40
; support_air_filtration = 0
; support_angle = 0
; support_base_pattern = default
; support_base_pattern_spacing = 2.5
; support_bottom_interface_spacing = 0.5
; support_bottom_z_distance = 0.2
; support_chamber_temp_control = 1
; support_cooling_filter = 1
; support_critical_regions_only = 0
; support_expansion = 0
; support_filament = 0
; support_interface_bottom_layers = 2
; support_interface_filament = 0
; support_interface_loop_pattern = 0
; support_interface_not_for_body = 1
; support_interface_pattern = auto
; support_interface_spacing = 0.5
; support_interface_speed = 80
; support_interface_top_layers = 2
; support_ironing_direction = 0
; support_ironing_flow = 10%
; support_ironing_inset = 0
; support_ironing_pattern = zig-zag
; support_ironing_spacing = 0.15
; support_ironing_speed = 30
; support_line_width = 0.42
; support_object_first_layer_gap = 0.2
; support_object_skip_flush = 1
; support_object_xy_distance = 0.35
; support_on_build_plate_only = 0
; support_remove_small_overhang = 1
; support_speed = 150
; support_style = default
; support_threshold_angle = 30
; support_top_z_distance = 0.2
; support_type = tree(auto)
; symmetric_infill_y_axis = 0
; temperature_vitrification = 45
; template_custom_gcode = 
; textured_plate_temp = 55
; textured_plate_temp_initial_layer = 55
; thick_bridges = 0
; thumbnail_size = 50x50
; time_lapse_gcode = ;========Date 20250925========\n; SKIPPABLE_START\n; SKIPTYPE: timelapse\nM622.1 S1 ; for prev firmware, default turned on\n\nM1002 judge_flag timelapse_record_flag\nM622 J1\n\n{if timelapse_type == 0} ; timelapse without wipe tower\n    M971 S11 C10 O0\n    M1004 S5 P1  ; external shutter\n{elsif timelapse_type == 1} ; timelapse with wipe tower\n\n    G150.3 ; move to garbage can\n    M400\n\n    M1004 S5 P1  ; external shutter\n    M400 P300\n\n    M971 S11 C10 O0\n    M400 P350\n\n    G90\n    G1 Z{max_layer_z + 3.0} F1200\n    G1 Y295 F30000\n    G1 Y265 F18000\n{endif}\nM623\n\n; SKIPPABLE_END\n
; timelapse_type = 0
; top_area_threshold = 200%
; top_color_penetration_layers = 5
; top_one_wall_type = all top
; top_shell_layers = 5
; top_shell_thickness = 1
; top_solid_infill_flow_ratio = 1
; top_surface_acceleration = 2000
; top_surface_density = 100%
; top_surface_jerk = 9
; top_surface_line_width = 0.42
; top_surface_pattern = monotonicline
; top_surface_speed = 200
; top_z_overrides_xy_distance = 0
; travel_acceleration = 10000
; travel_jerk = 9
; travel_short_distance_acceleration = 250
; travel_speed = 1000
; travel_speed_z = 0
; tree_support_branch_angle = 45
; tree_support_branch_diameter = 2
; tree_support_branch_diameter_angle = 5
; tree_support_branch_distance = 5
; tree_support_wall_count = -1
; upward_compatible_machine = 
; use_firmware_retraction = 0
; use_relative_e_distances = 1
; vertical_shell_speed = 80%
; volumetric_speed_coefficients = "0 0 0 0 0 0"
; wall_distribution_count = 1
; wall_filament = 0
; wall_generator = classic
; wall_loops = 2
; wall_sequence = inner wall/outer wall
; wall_transition_angle = 10
; wall_transition_filter_deviation = 25%
; wall_transition_length = 100%
; wipe = 1
; wipe_distance = 2
; wipe_speed = 80%
; wipe_tower_no_sparse_layers = 0
; wipe_tower_rotation_angle = 0
; wipe_tower_x = 165
; wipe_tower_y = 250
; wrapping_detection_gcode = ;======== H2S 20250105 clumping ========\n{if !spiral_mode}\n    M622.1 S0 ; for previous firmware, default turn off\n    M1002 set_flag g39_forced_detection_flag=1\n    M1002 judge_flag g39_forced_detection_flag\n    M622 J1\n        {if layer_num == 3 || layer_num == 10 || layer_num == 19}\n            M993 A2 B2 C2 ; nozzle cam detection allow status save.\n            M993 A0 B0 C0 ; nozzle cam detection not allowed.\n\n            M400 P100\n\n            G390\n\n            G90\n            G1 Y295 F30000\n            G1 Y265 F15000\n            \n            M993 A3 B3 C3 ; nozzle cam detection allow status restore.\n        {endif}\n    M623\n{endif}
; wrapping_detection_layers = 20
; wrapping_exclude_area = 172.3x302,232.5x302,232.5x322,172.3x322
; xy_contour_compensation = 0
; xy_hole_compensation = 0
; z_direction_outwall_speed_continuous = 0
; z_hop = 0.4
; z_hop_types = Auto Lift
; CONFIG_BLOCK_END

; EXECUTABLE_BLOCK_START
M73 P0 R11
M201 X20000 Y20000 Z500 E5000
M203 X1000 Y1000 Z30 E30
M204 P20000 R5000 T20000
M205 X9.00 Y9.00 Z3.00 E2.50
M106 S0
M106 P2 S0
; FEATURE: Custom
;===== machine: H2S =========================
;===== date: 2026/04/21 =====================


M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400
;M73 P99

;=====printer start sound ===================
M17
M400 S1
M1006 S1
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 
M1006 A61 B9 L99 C61 D9 M99 E61 F9 N99 
M1006 A53 B9 L99 C53 D9 M99 E53 F9 N99 
M1006 A56 B9 L99 C56 D9 M99 E56 F9 N99 
M1006 A61 B18 L99 C61 D18 M99 E61 F18 N99 
M1006 W
;=====printer start sound ===================

;===== reset machine status =================
M204 S10000
M630 S0 P0

G90
M17 D ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M1002 set_gcode_claim_speed_level 5 ;Reset speed level
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
G29.1 Z0 ; clear z-trim value first
M983.1 M1 
M901 D4
M481 S0 ; turn off cutter pos comp
G28.140 D0; reset pre-extrude z pos
;===== reset machine status =================

M620 M ;enable remap

;===== avoid end stop =================
G91
G380 S2 Z32 F1200
G380 S2 Z-12 F1200
G90
;===== avoid end stop =================

;==== set airduct mode ==== 


    M145 P0 ; set airduct mode to cooling mode for cooling
    M106 P2 S178 ; turn on auxiliary fan for cooling
    M106 P3 S127 ; turn on chamber fan for cooling
    M140 S0 ; stop heatbed from heating

    M1002 gcode_claim_action : 29
    M191 S0 ; wait for chamber temp
    M106 P2 S0 ; turn off auxiliary fan
    
        
            M142 P1 R30 S40 T45 U0.3 V0.5 W0.8 O45; set PLA/TPU ND0.4 chamber autocooling
        
    

M145.2 P0 F1


;==== set airduct mode ==== 

;===== start to heat heatbed & hotend==========

    M1002 set_filament_type:PLA

    M104 S140
    M140 S55

    ;===== set chamber temperature ==========
    
    ;===== set chamber temperature ==========

;===== start to heat heatbead & hotend==========

;====== cog noise reduction=================
M982.2 S1 ; turn on cog noise reduction

;===== first homing start =====
M1002 gcode_claim_action : 13

G28 X T300

G150.3 F18000
T1000 O0 ;Preventing 3D Print Misalignment After Laser Operations

G150.1 F18000 ; wipe mouth to avoid filament stick to heatbed
G150.3 F18000
M400 P200
M972 S24 P0 T2000
M1002 gcode_claim_action : 74 ; Heatbed surface foreign object detection

M972 S26 P0 C0

M972 S35 P0 C0
M972 S41 P0 T5000; trash can anti-collision

M1009 Q1 L1
G91
G380 S2 Z30 F1200 ; lower heatbed to move toolhead
G90
G1 X170 Y160 F30000
G28 Z P0 T250
M1009 Q1 L0

;===== first homing end =====

M400
;M73 P99

;===== detection start =====
M104 S0 T0 ; stop hotend heating before detection
M562 P1 E0 B1
M18 E
M400 P200
M1028 S1

M1002 judge_flag build_plate_detect_flag
M622 S1
    ;M1002 gcode_claim_action : 11 ; Indentifying build plate type
    M972 S19 P0 C0 ; heatbed detection
    
    M972 S31 P0 T5000; Toolhead camera detection
    
    ;M1002 gcode_claim_action : 73 ; Build plate alignment detection
    M972 S34 P0 T5000; Plate offset detection
M623

M1028 S0
M562 P1 E1 B1
M17 D



;===== detection end =====

M400
;M73 P99

;===== prepare print temperature and material ==========
M400
M211 X0 Y0 Z0 ;turn off soft endstop
M975 S1 ; turn on input shaping

G29.2 S0 ; avoid invalid abl data

M620.10 A0 F498.898 H0.4 T240 P220 S1
M620.10 A1 F498.898 H0.4 T240 P220 S1

M620.11 P0 I0 E0

M620 S0A   ; switch material if AMS exist
M1002 gcode_claim_action : 4
M1002 set_filament_type:UNKNOWN
M400
T0
M400
M628 S0
M629
M400
M1002 set_filament_type:PLA
M621 S0A

M104 S220
M400
M106 P1 S0

G29.2 S1
;===== prepare print temperature and material ==========

M400
;M73 P99

;===== auto extrude cali start =========================
M975 S1
M1002 judge_flag extrude_cali_flag

M622 J0
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation
M623

M622 J1
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

M622 J2
    M1002 set_filament_type:PLA
    M1002 gcode_claim_action : 8

    M109 S220

    G90
    M83
    M983.3 F10.4167 A0.4 ; cali dynamic extrusion compensation

    M400
    M106 P1 S255
    M400 S5
    M106 P1 S0
    G150.3
M623

;===== auto extrude cali end =========================


    M106 P1 S0
    M400 S2
    M109 S220 ; wait tmpr to extrude
    M83
    
        G1 E45 F623.623
    
    G1 E-3 F1800
    M400 P500
    G150.2
    G150.1


G91
M73 P4 R10
G1 Y-16 F12000 ; move away from the trash bin
G90

M400
;M73 P99

;===== wipe right nozzle start =====

M1002 gcode_claim_action : 14
    G150 T220
    
M106 S255 ; turn on fan to cool the nozzle

;===== wipe left nozzle end =====

M400
;M73 P99



M400
;M73 P99

;===== bed leveling ==================================

M1002 judge_flag g29_before_print_flag

M190 S55; ensure bed temp
M109 S140
M106 S0 ; turn off fan , too noisy

G91
M73 P7 R10
G1 Z5 F1200
G90
G1 X275 Y300 F30000

M622 J1
    M1002 gcode_claim_action : 1
    G29.20 A3
    G29 A1 O X145 Y150 I50 J20
    M400
M623
    
M622 J2
    M1002 gcode_claim_action : 1
    
        G29.20 A4
        G29 A2 O X145 Y150 I50 J20
    
    M400
M623

M622 J0
    G28
M623

;===== bed leveling end ================================

G390.1 Z; cali nozzle wrapped detection pos

G90
M73 P46 R5
G1 Z5 F1200
G1 X270 Y-0.5 F60000
G28.140 S0 ; cali pre-extrude z pos

M141 S0
M104 S220

;===== mech mode sweep start =====
    M1002 gcode_claim_action : 3

    G90
    G1 Z5 F1200
    G1 X187 Y160 F20000
    T1000
    M400 P200

    M970.3 Q1 A5 K0 O1
    M974 Q1 S2 P0

    M970.3 Q0 A5 K0 O1
    M974 Q0 S2 P0

    M970.2 Q2 K0 W38 Z0.01
    M974 Q2 S2 P0

    M975 S1
;===== mech mode sweep end =====

M400
;M73 P99

G150.3 ; move to garbage can to wait for temp
M1026
G29.9

M1002 gcode_claim_action : 0
M400
;M73 P99

;===== wait temperature reaching the reference value =======

M104 S220 ; rise to print tmpr

M140 S55 
M190 S55 

    ;========turn off light and fans =============
    M960 S1 P0 ; turn off laser
    M960 S2 P0 ; turn off laser
    M106 S0 ; turn off fan
    M106 P2 S0 ; turn off big fan

    ;============set motor current==================
    M400 S1

;===== wait temperature reaching the reference value =======

M400
;M73 P99

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
    
        G29.1 Z-0.01 ; for Textured PEI Plate
    
    
G150.1

M975 S1 ; turn on mech mode supression
M983.4 S1 ; turn on deformation compensation 
G29.2 S1 ; turn on pos comp
G29.7 S1

G90
G1 Z5 F1200
G1 Y295 F30000
G1 Y265 F18000

;===== nozzle load line ===============================
    G29.2 S1 ; ensure z comp turn on
    G90
    M83
    G1 Z5 F1200
    G1 X270 Y-0.5 F60000
    G28.14 R0
    G29.2 S0
    G91
    G1 Z0.8 F1200
    G90
M73 P47 R5
    G1 X250 F60000
    M400 P50
    M500 D1
    M400 S3
    M109 S220
    M83
    G1 E5 F311.811
    G1 X290 E20 F311.811
    G91
    G3 Z0.4 I1.217 J0 P1 F60000
    G90
    M83
    G29.2 S1 ; ensure z comp turn on
;===== noozle load line end ===========================

M400
;M73 P99

M993 A1 B1 C1 ; nozzle cam detection allowed.



M1015.4 S1 K1 H0.4 ;enable E air printing detect


M620.6 I0 W1 ;enable ams air printing detect

M211 Z1
G29.99


M1015.3 S0;disable tpu clog detect

; MACHINE_START_GCODE_END
; filament start gcode
;VT0 H-1
G90
G21
M83 ; use relative distances for extrusion
M981 S1 P20000 ;open spaghetti detector
; CHANGE_LAYER
; Z_HEIGHT: 0.2
; LAYER_HEIGHT: 0.2
G1 E-.4 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 1/28
; update layer progress
M73 L1
M991 S0 P0 ;notify layer change
M106 S0
M106 P2 S0
M204 S6000
G1 Z.4 F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
M73 P48 R5
G1 X186.629 Y163.755
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.5
G1 F3000
M204 S500
G1 X186.563 Y163.741 E.00251
G3 X187.311 Y156.147 I.935 J-3.742 E.40913
G1 X187.496 Y156.143 E.0069
G3 X186.934 Y163.815 I.002 J3.857 E.47244
G1 X186.688 Y163.766 E.00935
M204 S6000
G1 X186.718 Y163.307 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
M73 P49 R5
G1 X186.674 Y163.298 E.00167
G3 X187.333 Y156.604 I.824 J-3.298 E.36065
G1 X187.496 Y156.6 E.00607
G3 X187.001 Y163.363 I.002 J3.4 E.41643
G1 X186.777 Y163.319 E.00852
; WIPE_START
G1 X186.674 Y163.298 E-.03988
G1 X186.355 Y163.201 E-.12681
G1 X186.046 Y163.074 E-.12684
G1 X185.845 Y162.966 E-.08648
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I-.694 J1 P1  F60000
G1 X192.766 Y167.766 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F3000
M204 S500
G1 X147.234 Y167.766 E1.69586
G1 X147.234 Y152.234 E.57847
G1 X192.766 Y152.234 E1.69586
G1 X192.766 Y167.706 E.57624
M204 S6000
G1 X193.223 Y167.983 F60000
; FEATURE: Outer wall
G1 F3000
M204 S500
G3 X192.983 Y168.223 I-.228 J.011 E.01419
G1 X147.017 Y168.223 E1.71209
G3 X146.777 Y167.983 I-.011 J-.228 E.01419
G1 X146.777 Y152.017 E.5947
G3 X147.017 Y151.777 I.228 J-.011 E.01419
G1 X193.037 Y151.781 E1.71409
G3 X193.223 Y152.017 I-.046 J.227 E.01213
G1 X193.223 Y167.923 E.59247
; WIPE_START
G1 X193.211 Y168.07 E-.05577
G1 X193.157 Y168.157 E-.03872
G1 X193.076 Y168.208 E-.03649
G1 X192.983 Y168.223 E-.03571
G1 X192.422 Y168.223 E-.21331
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.217 J.013 P1  F60000
G1 X192.583 Y153.346 Z.6
G1 Z.2
G1 E.4 F1800
; FEATURE: Bottom surface
; LINE_WIDTH: 0.50232
G1 F6300
M204 S500
M73 P50 R5
G1 X191.859 Y152.623 E.03829
G1 X191.21 Y152.623 E.02432
G1 X192.377 Y153.79 E.06179
G1 X192.377 Y154.44 E.02432
G1 X190.56 Y152.623 E.09619
G1 X189.91 Y152.623 E.02432
G1 X192.377 Y155.09 E.13059
G1 X192.377 Y155.739 E.02432
G1 X189.261 Y152.623 E.16498
G1 X188.611 Y152.623 E.02432
G1 X192.377 Y156.389 E.19938
G1 X192.377 Y157.039 E.02432
G1 X187.961 Y152.623 E.23377
G1 X187.312 Y152.623 E.02432
G1 X192.377 Y157.688 E.26817
G1 X192.377 Y158.338 E.02432
G1 X186.662 Y152.623 E.30256
G1 X186.012 Y152.623 E.02432
G1 X192.377 Y158.988 E.33696
G1 X192.377 Y159.637 E.02432
G1 X191.58 Y158.841 E.04217
G3 X191.726 Y159.636 I-4.201 J1.179 E.0303
G1 X192.377 Y160.287 E.03447
G1 X192.377 Y160.937 E.02432
G1 X191.733 Y160.293 E.0341
G3 X191.653 Y160.862 I-2.929 J-.122 E.02157
G1 X192.377 Y161.586 E.03834
G1 X192.377 Y162.236 E.02432
G1 X191.515 Y161.374 E.04563
G3 X191.327 Y161.836 I-7.426 J-2.747 E.01867
G1 X192.377 Y162.886 E.05556
G1 X192.377 Y163.536 E.02432
G1 X191.095 Y162.254 E.06787
G3 X190.825 Y162.634 I-2.065 J-1.181 E.01747
G1 X192.377 Y164.185 E.08215
G1 X192.377 Y164.835 E.02432
G1 X190.52 Y162.978 E.09831
G3 X190.18 Y163.287 I-1.741 J-1.573 E.01725
G1 X192.377 Y165.485 E.11633
G1 X192.377 Y166.134 E.02432
G1 X189.804 Y163.561 E.13622
G3 X189.391 Y163.798 I-1.411 J-1.981 E.01785
G1 X192.377 Y166.784 E.15807
G1 X192.377 Y167.377 E.0222
G1 X192.32 Y167.377 E.00212
G1 X188.938 Y163.995 E.17905
G3 X188.432 Y164.139 I-2.264 J-6.998 E.01969
G1 X191.671 Y167.377 E.17144
G1 X191.021 Y167.377 E.02432
G1 X187.869 Y164.225 E.16685
G3 X187.229 Y164.235 I-.394 J-4.868 E.02398
G1 X190.371 Y167.377 E.16634
G1 X189.722 Y167.377 E.02432
G1 X186.153 Y163.808 E.18892
; WIPE_START
G1 X186.86 Y164.516 E-.38
; WIPE_END
G1 E-.02 F1800
M204 S6000
G17
G3 Z.6 I1.179 J.303 P1  F60000
G1 X188.988 Y156.248 Z.6
G1 Z.2
G1 E.4 F1800
G1 F6300
M204 S500
G1 X185.363 Y152.623 E.19193
G1 X184.713 Y152.623 E.02432
G1 X187.864 Y155.774 E.16683
G2 X187.207 Y155.767 I-.378 J4.639 E.02461
G1 X184.063 Y152.623 E.16646
G1 X183.414 Y152.623 E.02432
G1 X186.638 Y155.847 E.1707
G2 X186.126 Y155.985 I.443 J2.67 E.01988
G1 X182.764 Y152.623 E.17798
G1 X182.114 Y152.623 E.02432
G1 X185.664 Y156.173 E.18792
G2 X185.246 Y156.405 I.973 J2.238 E.01791
G1 X181.464 Y152.623 E.20022
G1 X180.815 Y152.623 E.02432
G1 X184.866 Y156.675 E.2145
G2 X184.522 Y156.98 I1.379 J1.903 E.01726
G1 X180.165 Y152.623 E.23067
G1 X179.515 Y152.623 E.02432
M73 P51 R5
G1 X184.213 Y157.32 E.24868
G2 X183.939 Y157.696 I1.771 J1.579 E.01744
G1 X178.866 Y152.623 E.26857
G1 X178.216 Y152.623 E.02432
G1 X183.702 Y158.109 E.29043
G2 X183.505 Y158.562 I2.202 J1.226 E.01852
G1 X177.566 Y152.623 E.31441
G1 X176.917 Y152.623 E.02432
G1 X183.361 Y159.068 E.34119
G2 X183.275 Y159.631 I2.812 J.72 E.02136
G1 X176.267 Y152.623 E.371
G1 X175.617 Y152.623 E.02432
G1 X183.265 Y160.271 E.40488
G2 X183.383 Y161.038 I5.951 J-.522 E.0291
G1 X174.968 Y152.623 E.44553
G1 X174.318 Y152.623 E.02432
G1 X189.072 Y167.377 E.7811
G1 X188.422 Y167.377 E.02432
G1 X173.668 Y152.623 E.7811
G1 X173.018 Y152.623 E.02432
G1 X187.773 Y167.377 E.7811
G1 X187.123 Y167.377 E.02432
G1 X172.369 Y152.623 E.7811
G1 X171.719 Y152.623 E.02432
G1 X186.473 Y167.377 E.7811
G1 X185.823 Y167.377 E.02432
G1 X171.069 Y152.623 E.7811
G1 X170.42 Y152.623 E.02432
G1 X185.174 Y167.377 E.7811
G1 X184.524 Y167.377 E.02432
G1 X169.77 Y152.623 E.7811
G1 X169.12 Y152.623 E.02432
G1 X183.874 Y167.377 E.7811
G1 X183.225 Y167.377 E.02432
G1 X168.471 Y152.623 E.7811
G1 X167.821 Y152.623 E.02432
G1 X182.575 Y167.377 E.7811
G1 X181.925 Y167.377 E.02432
M73 P52 R5
G1 X167.171 Y152.623 E.7811
G1 X166.522 Y152.623 E.02432
G1 X181.276 Y167.377 E.7811
G1 X180.626 Y167.377 E.02432
G1 X165.872 Y152.623 E.7811
G1 X165.222 Y152.623 E.02432
G1 X179.976 Y167.377 E.7811
G1 X179.327 Y167.377 E.02432
G1 X164.573 Y152.623 E.7811
G1 X163.923 Y152.623 E.02432
G1 X178.677 Y167.377 E.7811
G1 X178.027 Y167.377 E.02432
G1 X163.273 Y152.623 E.7811
G1 X162.623 Y152.623 E.02432
G1 X177.377 Y167.377 E.7811
G1 X176.728 Y167.377 E.02432
G1 X161.974 Y152.623 E.7811
G1 X161.324 Y152.623 E.02432
G1 X176.078 Y167.377 E.7811
G1 X175.428 Y167.377 E.02432
G1 X160.674 Y152.623 E.7811
G1 X160.025 Y152.623 E.02432
G1 X174.779 Y167.377 E.7811
G1 X174.129 Y167.377 E.02432
G1 X159.375 Y152.623 E.7811
G1 X158.725 Y152.623 E.02432
G1 X173.479 Y167.377 E.7811
G1 X172.83 Y167.377 E.02432
G1 X158.076 Y152.623 E.7811
G1 X157.426 Y152.623 E.02432
G1 X172.18 Y167.377 E.7811
G1 X171.53 Y167.377 E.02432
M73 P53 R5
G1 X156.776 Y152.623 E.7811
G1 X156.127 Y152.623 E.02432
G1 X170.881 Y167.377 E.7811
G1 X170.231 Y167.377 E.02432
G1 X155.477 Y152.623 E.7811
G1 X154.827 Y152.623 E.02432
G1 X169.581 Y167.377 E.7811
G1 X168.932 Y167.377 E.02432
G1 X154.177 Y152.623 E.7811
G1 X153.528 Y152.623 E.02432
G1 X168.282 Y167.377 E.7811
G1 X167.632 Y167.377 E.02432
G1 X152.878 Y152.623 E.7811
G1 X152.228 Y152.623 E.02432
G1 X166.982 Y167.377 E.7811
G1 X166.333 Y167.377 E.02432
G1 X151.579 Y152.623 E.7811
G1 X150.929 Y152.623 E.02432
G1 X165.683 Y167.377 E.7811
G1 X165.033 Y167.377 E.02432
G1 X150.279 Y152.623 E.7811
G1 X149.63 Y152.623 E.02432
G1 X164.384 Y167.377 E.7811
G1 X163.734 Y167.377 E.02432
G1 X148.98 Y152.623 E.7811
G1 X148.33 Y152.623 E.02432
G1 X163.084 Y167.377 E.7811
G1 X162.435 Y167.377 E.02432
G1 X147.681 Y152.623 E.7811
G1 X147.623 Y152.623 E.00216
G1 X147.623 Y153.215 E.02217
G1 X161.785 Y167.377 E.74975
M73 P54 R5
G1 X161.135 Y167.377 E.02432
G1 X147.623 Y153.865 E.71536
G1 X147.623 Y154.514 E.02432
G1 X160.486 Y167.377 E.68096
G1 X159.836 Y167.377 E.02432
G1 X147.623 Y155.164 E.64657
G1 X147.623 Y155.814 E.02432
G1 X159.186 Y167.377 E.61217
G1 X158.536 Y167.377 E.02432
G1 X147.623 Y156.464 E.57778
G1 X147.623 Y157.113 E.02432
G1 X157.887 Y167.377 E.54338
G1 X157.237 Y167.377 E.02432
G1 X147.623 Y157.763 E.50898
G1 X147.623 Y158.413 E.02432
G1 X156.587 Y167.377 E.47459
G1 X155.938 Y167.377 E.02432
G1 X147.623 Y159.062 E.44019
G1 X147.623 Y159.712 E.02432
G1 X155.288 Y167.377 E.4058
G1 X154.638 Y167.377 E.02432
G1 X147.623 Y160.362 E.3714
G1 X147.623 Y161.011 E.02432
G1 X153.989 Y167.377 E.33701
G1 X153.339 Y167.377 E.02432
G1 X147.623 Y161.661 E.30261
G1 X147.623 Y162.311 E.02432
G1 X152.689 Y167.377 E.26822
G1 X152.04 Y167.377 E.02432
G1 X147.623 Y162.96 E.23382
G1 X147.623 Y163.61 E.02432
G1 X151.39 Y167.377 E.19942
G1 X150.74 Y167.377 E.02432
G1 X147.623 Y164.26 E.16503
G1 X147.623 Y164.91 E.02432
G1 X150.091 Y167.377 E.13063
G1 X149.441 Y167.377 E.02432
G1 X147.623 Y165.559 E.09624
G1 X147.623 Y166.209 E.02432
M73 P54 R4
G1 X148.791 Y167.377 E.06184
G1 X148.141 Y167.377 E.02432
G1 X147.417 Y166.653 E.03834
M106 S255
; CHANGE_LAYER
; Z_HEIGHT: 0.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F6300
G1 X148.124 Y167.36 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 2/28
; update layer progress
M73 L2
M991 S0 P1 ;notify layer change
M106 S255
M106 P2 S191
; open powerlost recovery
M1003 S1
M204 S10000
G17
G3 Z.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.686 Y163.506
M73 P55 R4
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.625 Y163.495 E.00207
G3 X187.323 Y156.402 I.869 J-3.495 E.34054
G1 X187.488 Y156.398 E.00547
G3 X186.971 Y163.563 I.006 J3.602 E.39293
G1 X186.745 Y163.518 E.00767
M204 S250
G1 X186.762 Y163.122 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.72 Y163.114 E.00132
G3 X187.342 Y156.794 I.774 J-3.115 E.28111
G1 X187.489 Y156.79 E.0045
G3 X187.029 Y163.175 I.006 J3.209 E.32435
G1 X186.821 Y163.134 E.00651
; WIPE_START
M204 S10000
G1 X186.72 Y163.114 E-.03918
G1 X186.419 Y163.022 E-.11976
G1 X186.128 Y162.902 E-.11969
G1 X185.892 Y162.776 E-.10138
; WIPE_END
G1 E-.02 F1800
G17
G3 Z.8 I-1.203 J.183 P1  F60000
G1 X186.756 Y168.451 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X147.618 Y168.451 E1.29827
G3 X146.942 Y168.446 I-.3 J-5.538 E.02243
G3 X146.549 Y167.982 I.066 J-.454 E.02206
G1 X146.549 Y152.618 E.50962
G3 X146.554 Y151.942 I5.538 J-.3 E.02244
G3 X147.018 Y151.549 I.463 J.076 E.02195
G1 X192.387 Y151.549 E1.50495
G3 X193.033 Y151.552 I.3 J7.18 E.02144
G3 X193.245 Y151.623 I-.07 J.558 E.00748
G1 X193.276 Y151.646 E.00129
G3 X193.451 Y152.018 I-.308 J.371 E.0141
G1 X193.451 Y167.382 E.50962
G3 X193.446 Y168.058 I-5.538 J.3 E.02244
G3 X192.982 Y168.451 I-.463 J-.076 E.02195
G1 X186.816 Y168.451 E.20453
M204 S250
G1 X186.756 Y168.843 F60000
; FEATURE: Overhang wall
G1 F600
M204 S5000
G1 X147.006 Y168.843 E1.31856
G3 X146.157 Y167.993 I0 J-.849 E.04424
G1 X146.157 Y152.007 E.53032
G3 X147.006 Y151.157 I.849 J0 E.04424
G1 X193.072 Y151.161 E1.52807
G3 X193.843 Y152.007 I-.086 J.853 E.04156
M73 P56 R4
G1 X193.843 Y167.993 E.53032
G3 X192.994 Y168.843 I-.849 J0 E.04424
G1 X186.816 Y168.843 E.20492
M106 S244.8
; WIPE_START
M204 S10000
G1 X185.816 Y168.843 E-.38
; WIPE_END
M73 P57 R4
G1 E-.02 F1800
G17
G3 Z.8 I.096 J1.213 P1  F60000
G1 X192.867 Y168.287 Z.8
G1 Z.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42273
G1 F15000
G1 X193.094 Y168.059 E.00997
G2 X193.117 Y167.957 I-.142 J-.085 E.00331
G1 X193.117 Y167.499 E.01416
G1 X192.499 Y168.117 E.02705
G1 X191.962 Y168.117 E.01662
G1 X193.117 Y166.962 E.05056
G1 X193.117 Y166.425 E.01662
G1 X191.425 Y168.117 E.07407
G1 X190.888 Y168.117 E.01662
G1 X193.117 Y165.888 E.09758
G1 X193.117 Y165.351 E.01662
G1 X190.351 Y168.117 E.12109
G1 X189.814 Y168.117 E.01662
G1 X193.117 Y164.814 E.1446
G1 X193.117 Y164.277 E.01662
G1 X189.276 Y168.117 E.16811
G1 X188.739 Y168.117 E.01662
G1 X193.117 Y163.739 E.19162
G1 X193.117 Y163.202 E.01662
G1 X188.202 Y168.117 E.21513
G1 X187.665 Y168.117 E.01662
G1 X193.117 Y162.665 E.23864
G1 X193.117 Y162.128 E.01662
G1 X187.128 Y168.117 E.26215
G1 X186.591 Y168.117 E.01662
G1 X193.117 Y161.591 E.28566
G1 X193.117 Y161.054 E.01662
G1 X186.054 Y168.117 E.30917
G1 X185.517 Y168.117 E.01662
G1 X193.117 Y160.517 E.33268
G1 X193.117 Y159.979 E.01662
G1 X184.979 Y168.117 E.35619
G1 X184.442 Y168.117 E.01662
G1 X188.873 Y163.686 E.19395
G3 X188.142 Y163.88 I-1.551 J-4.363 E.02345
G1 X183.905 Y168.117 E.18544
G1 X183.368 Y168.117 E.01662
G1 X187.554 Y163.931 E.18322
G3 X187.043 Y163.905 I-.124 J-2.605 E.01587
G1 X182.831 Y168.117 E.18436
G1 X182.294 Y168.117 E.01662
G1 X186.585 Y163.826 E.18782
G3 X186.17 Y163.704 I2.894 J-10.608 E.01339
G1 X181.757 Y168.117 E.19316
G1 X181.22 Y168.117 E.01662
G1 X185.792 Y163.545 E.20014
G3 X185.445 Y163.355 I.792 J-1.861 E.01227
G1 X180.682 Y168.117 E.20845
G1 X180.145 Y168.117 E.01662
G1 X185.126 Y163.137 E.21799
G3 X184.833 Y162.892 I1.097 J-1.611 E.01182
G1 X179.608 Y168.117 E.22869
G1 X179.071 Y168.117 E.01662
G1 X184.566 Y162.622 E.24053
G3 X184.326 Y162.325 I1.381 J-1.366 E.01184
G1 X178.534 Y168.117 E.25351
G1 X177.997 Y168.117 E.01662
G1 X184.112 Y162.002 E.26768
G3 X183.928 Y161.649 I1.699 J-1.113 E.01234
G1 X177.46 Y168.117 E.28312
G1 X176.922 Y168.117 E.01662
G1 X183.775 Y161.264 E.29995
G3 X183.66 Y160.843 I2.08 J-.799 E.01354
G1 X176.385 Y168.117 E.31839
G1 X175.848 Y168.117 E.01662
G1 X183.587 Y160.378 E.33873
G3 X183.569 Y159.86 I2.625 J-.352 E.01609
G1 X175.311 Y168.117 E.36144
G1 X174.774 Y168.117 E.01662
G1 X183.641 Y159.25 E.38811
G3 X183.875 Y158.479 I3.868 J.753 E.02498
G1 X174.237 Y168.117 E.42185
G1 X173.7 Y168.117 E.01662
G1 X189.932 Y151.885 E.7105
G1 X189.395 Y151.885 E.01662
G1 X173.163 Y168.117 E.7105
G1 X172.625 Y168.117 E.01662
G1 X188.858 Y151.885 E.7105
G1 X188.321 Y151.885 E.01662
G1 X172.088 Y168.117 E.7105
G1 X171.551 Y168.117 E.01662
G1 X187.784 Y151.885 E.7105
G1 X187.247 Y151.885 E.01662
G1 X171.014 Y168.117 E.7105
G1 X170.477 Y168.117 E.01662
G1 X186.71 Y151.884 E.7105
G1 X186.173 Y151.884 E.01662
G1 X169.94 Y168.117 E.7105
G1 X169.403 Y168.117 E.01662
G1 X185.635 Y151.884 E.7105
G1 X185.098 Y151.884 E.01662
G1 X168.865 Y168.117 E.71051
G1 X168.328 Y168.117 E.01662
G1 X184.561 Y151.884 E.71051
G1 X184.024 Y151.884 E.01662
G1 X167.791 Y168.117 E.71051
G1 X167.254 Y168.117 E.01662
G1 X183.487 Y151.884 E.71051
G1 X182.95 Y151.884 E.01662
G1 X166.717 Y168.117 E.71051
G1 X166.18 Y168.117 E.01662
G1 X182.413 Y151.884 E.71051
G1 X181.876 Y151.884 E.01662
G1 X165.643 Y168.117 E.71051
G1 X165.106 Y168.117 E.01662
G1 X181.339 Y151.884 E.71051
G1 X180.801 Y151.884 E.01662
G1 X164.568 Y168.117 E.71051
G1 X164.031 Y168.117 E.01662
G1 X180.264 Y151.884 E.71051
G1 X179.727 Y151.884 E.01662
G1 X163.494 Y168.117 E.71052
G1 X162.957 Y168.117 E.01662
G1 X179.19 Y151.884 E.71052
G1 X178.653 Y151.884 E.01662
G1 X162.42 Y168.117 E.71052
G1 X161.883 Y168.117 E.01662
G1 X178.116 Y151.884 E.71052
G1 X177.579 Y151.884 E.01662
G1 X161.346 Y168.117 E.71052
G1 X160.808 Y168.117 E.01662
G1 X177.042 Y151.884 E.71052
G1 X176.505 Y151.884 E.01662
G1 X160.271 Y168.117 E.71052
G1 X159.734 Y168.117 E.01662
M73 P58 R4
G1 X175.968 Y151.884 E.71052
G1 X175.43 Y151.884 E.01662
G1 X159.197 Y168.117 E.71052
G1 X158.66 Y168.117 E.01662
G1 X174.893 Y151.884 E.71053
G1 X174.356 Y151.884 E.01662
G1 X158.123 Y168.117 E.71053
G1 X157.586 Y168.117 E.01662
G1 X173.819 Y151.884 E.71053
G1 X173.282 Y151.884 E.01662
G1 X157.049 Y168.117 E.71053
G1 X156.511 Y168.117 E.01662
G1 X172.745 Y151.884 E.71053
G1 X172.208 Y151.884 E.01662
G1 X155.974 Y168.117 E.71053
G1 X155.437 Y168.117 E.01662
G1 X171.671 Y151.884 E.71053
G1 X171.134 Y151.884 E.01662
G1 X154.9 Y168.117 E.71053
G1 X154.363 Y168.117 E.01662
G1 X170.596 Y151.884 E.71053
G1 X170.059 Y151.884 E.01662
G1 X153.826 Y168.117 E.71053
G1 X153.289 Y168.117 E.01662
G1 X169.522 Y151.884 E.71054
G1 X168.985 Y151.884 E.01662
G1 X152.751 Y168.117 E.71054
G1 X152.214 Y168.117 E.01662
G1 X168.448 Y151.884 E.71054
G1 X167.911 Y151.884 E.01662
G1 X151.677 Y168.117 E.71054
G1 X151.14 Y168.117 E.01662
G1 X167.374 Y151.884 E.71054
G1 X166.837 Y151.884 E.01662
G1 X150.603 Y168.117 E.71054
G1 X150.066 Y168.117 E.01662
G1 X166.3 Y151.884 E.71054
G1 X165.762 Y151.884 E.01662
G1 X149.529 Y168.117 E.71054
G1 X148.992 Y168.117 E.01662
G1 X165.225 Y151.884 E.71054
G1 X164.688 Y151.883 E.01662
G1 X148.454 Y168.117 E.71055
G1 X147.917 Y168.117 E.01662
G1 X164.151 Y151.883 E.71055
G1 X163.614 Y151.883 E.01662
G1 X147.38 Y168.117 E.71055
G3 X146.96 Y168.105 I-.169 J-1.412 E.01306
G3 X146.904 Y168.056 I.086 J-.155 E.0023
G1 X163.077 Y151.883 E.70788
G1 X162.54 Y151.883 E.01662
G1 X146.883 Y167.54 E.6853
G1 X146.883 Y167.003 E.01662
G1 X162.003 Y151.883 E.66179
G1 X161.466 Y151.883 E.01662
G1 X146.883 Y166.466 E.63828
G1 X146.883 Y165.929 E.01662
G1 X160.928 Y151.883 E.61478
G1 X160.391 Y151.883 E.01662
G1 X146.883 Y165.392 E.59127
G1 X146.883 Y164.855 E.01662
G1 X159.854 Y151.883 E.56776
G1 X159.317 Y151.883 E.01662
G1 X146.883 Y164.318 E.54425
G1 X146.883 Y163.781 E.01662
G1 X158.78 Y151.883 E.52074
G1 X158.243 Y151.883 E.01662
G1 X146.883 Y163.243 E.49723
G1 X146.883 Y162.706 E.01662
G1 X157.706 Y151.883 E.47372
G1 X157.169 Y151.883 E.01662
G1 X146.883 Y162.169 E.45021
G1 X146.883 Y161.632 E.01662
G1 X156.632 Y151.883 E.4267
G1 X156.095 Y151.883 E.01662
G1 X146.883 Y161.095 E.4032
G1 X146.883 Y160.558 E.01662
G1 X155.557 Y151.883 E.37969
G1 X155.02 Y151.883 E.01662
G1 X146.883 Y160.021 E.35618
G1 X146.883 Y159.483 E.01662
G1 X154.483 Y151.883 E.33267
G1 X153.946 Y151.883 E.01662
G1 X146.883 Y158.946 E.30916
G1 X146.883 Y158.409 E.01662
G1 X153.409 Y151.883 E.28565
G1 X152.872 Y151.883 E.01662
G1 X146.883 Y157.872 E.26214
G1 X146.883 Y157.335 E.01662
G1 X152.335 Y151.883 E.23863
G1 X151.798 Y151.883 E.01662
G1 X146.883 Y156.798 E.21512
G1 X146.883 Y156.261 E.01662
G1 X151.261 Y151.883 E.19161
G1 X150.723 Y151.883 E.01662
G1 X146.883 Y155.724 E.16811
G1 X146.883 Y155.186 E.01662
G1 X150.186 Y151.883 E.1446
G1 X149.649 Y151.883 E.01662
G1 X146.883 Y154.649 E.12109
G1 X146.883 Y154.112 E.01662
G1 X149.112 Y151.883 E.09758
G1 X148.575 Y151.883 E.01662
G1 X146.883 Y153.575 E.07407
G1 X146.883 Y153.038 E.01662
G1 X148.038 Y151.883 E.05056
G1 X147.501 Y151.883 E.01662
G1 X146.883 Y152.501 E.02705
G1 X146.883 Y152.043 E.01416
G3 X146.905 Y151.941 I.164 J-.017 E.0033
G1 X147.133 Y151.713 E.00997
G1 X185.608 Y156.746 F60000
G1 F15000
G1 X190.469 Y151.885 E.21279
G1 X191.007 Y151.885 E.01662
G1 X186.75 Y156.141 E.1863
G3 X187.36 Y156.069 I.836 J4.451 E.019
G1 X191.544 Y151.885 E.18314
G1 X192.081 Y151.885 E.01662
G1 X187.878 Y156.087 E.18394
G3 X188.343 Y156.16 I-.135 J2.395 E.01458
G1 X192.618 Y151.885 E.1871
G1 X192.988 Y151.885 E.01147
G3 X193.093 Y151.947 I-.004 J.125 E.00393
G1 X188.764 Y156.275 E.18945
G3 X189.149 Y156.428 I-.582 J2.029 E.01283
G1 X193.117 Y152.46 E.17369
G1 X193.117 Y152.997 E.01662
G1 X189.502 Y156.612 E.15826
G3 X189.825 Y156.826 I-.919 J1.747 E.01202
G1 X193.117 Y153.534 E.14409
G1 X193.117 Y154.071 E.01662
G1 X190.122 Y157.066 E.1311
G3 X190.392 Y157.333 I-1.215 J1.502 E.01177
G1 X193.117 Y154.608 E.11926
G1 X193.117 Y155.145 E.01662
G1 X190.637 Y157.626 E.10856
G3 X190.855 Y157.945 I-1.512 J1.266 E.01198
G1 X193.117 Y155.682 E.09903
G1 X193.117 Y156.22 E.01662
G1 X191.045 Y158.292 E.09072
G3 X191.204 Y158.67 I-1.846 J1.002 E.01271
G1 X193.117 Y156.757 E.08374
G1 X193.117 Y157.294 E.01662
M73 P59 R4
G1 X191.326 Y159.085 E.0784
G3 X191.405 Y159.543 I-2.286 J.63 E.01441
G1 X193.117 Y157.831 E.07494
G1 X193.117 Y158.368 E.01662
G1 X191.431 Y160.054 E.0738
G3 X191.38 Y160.642 I-4.472 J-.09 E.01827
G1 X193.117 Y158.905 E.07602
G1 X193.117 Y159.442 E.01662
G1 X190.853 Y161.707 E.09912
M106 S255
; CHANGE_LAYER
; Z_HEIGHT: 0.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X191.56 Y161 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 3/28
; update layer progress
M73 L3
M991 S0 P2 ;notify layer change
M106 S255
G17
G3 Z.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.694 Y163.508
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.625 Y163.496 E.00233
G3 X187.323 Y156.402 I.865 J-3.496 E.34085
G1 X187.48 Y156.398 E.00519
G3 X186.971 Y163.564 I.01 J3.602 E.3929
G1 X186.753 Y163.52 E.0074
M204 S250
G1 X186.77 Y163.124 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.72 Y163.115 E.00157
G3 X187.342 Y156.794 I.77 J-3.116 E.28137
G1 X187.481 Y156.79 E.00426
G3 X187.029 Y163.176 I.009 J3.209 E.32432
G1 X186.829 Y163.136 E.00627
; WIPE_START
M204 S10000
G1 X186.72 Y163.115 E-.04221
G1 X186.419 Y163.022 E-.11982
G1 X186.128 Y162.902 E-.11966
G1 X185.899 Y162.78 E-.09832
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1 I-.673 J1.014 P1  F60000
G1 X193.717 Y167.968 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X193.717 Y168.06 E.00304
G3 X192.987 Y168.72 I-.726 J-.069 E.03585
G1 X147.013 Y168.72 E1.52502
G3 X146.28 Y167.987 I-.003 J-.73 E.03826
G1 X146.283 Y151.94 E.5323
G3 X147.013 Y151.28 I.726 J.069 E.03585
G1 X193.046 Y151.282 E1.527
G1 X193.06 Y151.283 E.00045
G3 X193.72 Y152.013 I-.069 J.726 E.03585
G1 X193.717 Y167.908 E.52727
M204 S250
G1 X194.108 Y167.968 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F1320
M204 S5000
G1 X194.108 Y168.096 E.00395
G3 X192.995 Y169.112 I-1.121 J-.111 E.05071
G1 X147.605 Y169.112 E1.39472
G3 X146.806 Y169.095 I-.306 J-4.285 E.02459
G3 X145.888 Y167.995 I.197 J-1.098 E.04779
G1 X145.89 Y152.543 E.47479
G3 X145.892 Y151.904 I6.203 J-.299 E.01967
G3 X147.005 Y150.888 I1.121 J.111 E.05071
G1 X193.057 Y150.89 E1.41504
G3 X194.112 Y152.005 I-.058 J1.112 E.05205
G1 X194.11 Y167.457 E.47479
G1 X194.108 Y167.908 E.01387
M106 S247.35
; WIPE_START
M204 S10000
M73 P60 R4
G1 X194.108 Y168.096 E-.07164
G1 X194.073 Y168.292 E-.07561
G1 X194.001 Y168.484 E-.07783
G1 X193.892 Y168.664 E-.07999
G1 X193.76 Y168.81 E-.07493
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1 I.71 J-.988 P1  F60000
G1 X184.339 Y162.039 Z1
G1 Z.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42092
G1 F15000
G1 X173.914 Y151.615 E.4541
G1 X174.449 Y151.615 E.01647
G1 X183.655 Y160.821 E.40105
G3 X183.57 Y160.201 I3.102 J-.744 E.01931
G1 X174.983 Y151.615 E.37403
G1 X175.518 Y151.615 E.01647
G1 X183.582 Y159.678 E.35126
G3 X183.649 Y159.211 I2.407 J.108 E.01457
G1 X176.052 Y151.615 E.3309
G1 X176.587 Y151.615 E.01647
G1 X183.76 Y158.787 E.31245
G3 X183.907 Y158.401 I2.039 J.557 E.01278
G1 X177.122 Y151.615 E.2956
G1 X177.656 Y151.615 E.01647
G1 X184.087 Y158.046 E.28014
G3 X184.296 Y157.72 I1.76 J.897 E.01194
G1 X178.191 Y151.615 E.26593
G1 X178.725 Y151.615 E.01647
G1 X184.531 Y157.421 E.25291
G3 X184.793 Y157.148 I1.516 J1.191 E.01166
G1 X179.26 Y151.615 E.24102
G1 X179.795 Y151.615 E.01647
G1 X185.08 Y156.9 E.23024
G3 X185.394 Y156.679 I1.279 J1.482 E.01184
G1 X180.329 Y151.615 E.22062
G1 X180.864 Y151.615 E.01647
G1 X185.735 Y156.486 E.21219
G3 X186.106 Y156.322 I1.016 J1.802 E.01251
G1 X181.398 Y151.615 E.20506
G1 X181.933 Y151.615 E.01647
G1 X186.51 Y156.192 E.19939
G3 X186.956 Y156.103 I1.725 J7.496 E.014
G1 X182.468 Y151.615 E.19552
G1 X183.002 Y151.615 E.01647
G1 X187.456 Y156.069 E.19401
G3 X188.023 Y156.101 I.118 J2.891 E.01753
G1 X183.537 Y151.615 E.19543
G1 X184.071 Y151.615 E.01647
G1 X189.011 Y156.554 E.21516
G1 X193.556 Y152.547 F60000
G1 F15000
G1 X192.625 Y151.615 E.04057
G1 X192.09 Y151.615 E.01647
G1 X193.387 Y152.912 E.05647
G1 X193.387 Y153.446 E.01646
G1 X191.556 Y151.615 E.07975
G1 X191.021 Y151.615 E.01647
G1 X193.387 Y153.981 E.10304
G1 X193.386 Y154.515 E.01646
G1 X190.487 Y151.615 E.12632
G1 X189.952 Y151.615 E.01647
G1 X193.386 Y155.05 E.14961
G1 X193.386 Y155.584 E.01646
G1 X189.417 Y151.615 E.17289
G1 X188.883 Y151.615 E.01647
G1 X193.386 Y156.119 E.19617
G1 X193.386 Y156.653 E.01646
G1 X188.348 Y151.615 E.21946
G1 X187.814 Y151.615 E.01647
G1 X193.386 Y157.188 E.24274
G1 X193.386 Y157.722 E.01646
G1 X187.279 Y151.615 E.26603
G1 X186.744 Y151.615 E.01647
G1 X193.386 Y158.257 E.28931
G1 X193.386 Y158.791 E.01646
G1 X186.21 Y151.615 E.3126
G1 X185.675 Y151.615 E.01647
G1 X193.386 Y159.326 E.33588
G1 X193.386 Y159.86 E.01646
G1 X185.141 Y151.615 E.35916
G1 X184.606 Y151.615 E.01647
G1 X193.386 Y160.395 E.38245
G1 X193.386 Y160.929 E.01646
G1 X191.239 Y158.782 E.09352
G3 X191.399 Y159.477 I-4.304 J1.357 E.02198
G1 X193.385 Y161.464 E.08655
G1 X193.385 Y161.998 E.01646
G1 X191.431 Y160.044 E.08513
G3 X191.397 Y160.544 I-2.554 J.075 E.01546
G1 X193.385 Y162.533 E.08663
G1 X193.385 Y163.067 E.01646
G1 X191.308 Y160.99 E.0905
G3 X191.178 Y161.394 I-2.118 J-.459 E.01311
G1 X193.385 Y163.602 E.09616
G1 X193.385 Y164.136 E.01646
G1 X191.014 Y161.765 E.10329
G3 X190.821 Y162.106 I-1.827 J-.81 E.0121
G1 X193.385 Y164.671 E.11171
G1 X193.385 Y165.205 E.01646
G1 X190.6 Y162.42 E.12133
G3 X190.352 Y162.707 I-1.58 J-1.11 E.01169
G1 X193.385 Y165.74 E.1321
G1 X193.385 Y166.274 E.01646
G1 X190.079 Y162.969 E.14399
G3 X189.78 Y163.204 I-1.344 J-1.398 E.01174
G1 X193.385 Y166.809 E.15701
G1 X193.385 Y167.343 E.01646
G1 X189.454 Y163.413 E.17121
G3 X189.099 Y163.593 I-1.09 J-1.714 E.01227
G1 X193.385 Y167.878 E.18666
G3 X193.254 Y168.282 I-.486 J.067 E.01353
G1 X188.713 Y163.74 E.19784
G3 X188.289 Y163.851 I-.776 J-2.097 E.01351
G1 X192.825 Y168.387 E.19757
G1 X192.29 Y168.387 E.01647
G1 X187.822 Y163.919 E.19464
G3 X187.299 Y163.93 I-.398 J-6.023 E.01611
G1 X191.755 Y168.387 E.19413
G1 X191.221 Y168.387 E.01647
G1 X186.679 Y163.845 E.19785
G3 X185.886 Y163.587 I.872 J-4.023 E.02573
G1 X190.686 Y168.387 E.2091
G1 X190.152 Y168.387 E.01647
G1 X173.379 Y151.614 E.73062
G1 X172.845 Y151.614 E.01647
G1 X189.617 Y168.387 E.73062
G1 X189.083 Y168.387 E.01647
G1 X172.31 Y151.614 E.73062
G1 X171.776 Y151.614 E.01647
G1 X188.548 Y168.387 E.73062
G1 X188.013 Y168.387 E.01647
G1 X171.241 Y151.614 E.73062
G1 X170.706 Y151.614 E.01647
G1 X187.479 Y168.387 E.73062
G1 X186.944 Y168.387 E.01647
G1 X170.172 Y151.614 E.73062
G1 X169.637 Y151.614 E.01647
G1 X186.41 Y168.387 E.73063
G1 X185.875 Y168.387 E.01647
G1 X169.103 Y151.614 E.73063
G1 X168.568 Y151.614 E.01647
G1 X185.341 Y168.387 E.73063
G1 X184.806 Y168.387 E.01647
G1 X168.033 Y151.614 E.73063
G1 X167.499 Y151.614 E.01647
G1 X184.271 Y168.387 E.73063
G1 X183.737 Y168.387 E.01647
G1 X166.964 Y151.614 E.73063
G1 X166.43 Y151.614 E.01647
G1 X183.202 Y168.387 E.73063
G1 X182.668 Y168.387 E.01647
G1 X165.895 Y151.614 E.73063
G1 X165.36 Y151.614 E.01647
G1 X182.133 Y168.387 E.73064
G1 X181.599 Y168.387 E.01647
G1 X164.826 Y151.614 E.73064
G1 X164.291 Y151.614 E.01647
M73 P61 R4
G1 X181.064 Y168.387 E.73064
G1 X180.529 Y168.387 E.01647
G1 X163.757 Y151.614 E.73064
G1 X163.222 Y151.614 E.01647
G1 X179.995 Y168.387 E.73064
G1 X179.46 Y168.387 E.01647
G1 X162.687 Y151.614 E.73064
G1 X162.153 Y151.614 E.01647
G1 X178.926 Y168.387 E.73064
G1 X178.391 Y168.387 E.01647
G1 X161.618 Y151.614 E.73064
G1 X161.084 Y151.614 E.01647
G1 X177.857 Y168.387 E.73064
G1 X177.322 Y168.387 E.01647
G1 X160.549 Y151.614 E.73065
G1 X160.014 Y151.614 E.01647
G1 X176.787 Y168.387 E.73065
G1 X176.253 Y168.387 E.01647
G1 X159.48 Y151.614 E.73065
G1 X158.945 Y151.614 E.01647
G1 X175.718 Y168.387 E.73065
G1 X175.184 Y168.387 E.01647
G1 X158.411 Y151.614 E.73065
G1 X157.876 Y151.614 E.01647
G1 X174.649 Y168.387 E.73065
G1 X174.115 Y168.387 E.01647
G1 X157.341 Y151.614 E.73065
G1 X156.807 Y151.614 E.01647
G1 X173.58 Y168.387 E.73065
G1 X173.045 Y168.387 E.01647
G1 X156.272 Y151.614 E.73065
G1 X155.738 Y151.614 E.01647
G1 X172.511 Y168.387 E.73066
G1 X171.976 Y168.387 E.01647
G1 X155.203 Y151.614 E.73066
G1 X154.668 Y151.614 E.01647
G1 X171.442 Y168.387 E.73066
G1 X170.907 Y168.387 E.01647
G1 X154.134 Y151.614 E.73066
G1 X153.599 Y151.614 E.01647
G1 X170.373 Y168.387 E.73066
G1 X169.838 Y168.387 E.01647
G1 X153.065 Y151.613 E.73066
G1 X152.53 Y151.613 E.01647
G1 X169.303 Y168.387 E.73066
G1 X168.769 Y168.387 E.01647
G1 X151.995 Y151.613 E.73066
G1 X151.461 Y151.613 E.01647
G1 X168.234 Y168.387 E.73067
G1 X167.7 Y168.387 E.01647
G1 X150.926 Y151.613 E.73067
G1 X150.392 Y151.613 E.01647
G1 X167.165 Y168.387 E.73067
G1 X166.631 Y168.387 E.01647
G1 X149.857 Y151.613 E.73067
G1 X149.322 Y151.613 E.01647
G1 X166.096 Y168.387 E.73067
G1 X165.561 Y168.387 E.01647
G1 X148.788 Y151.613 E.73067
G1 X148.253 Y151.613 E.01647
G1 X165.027 Y168.387 E.73067
G1 X164.492 Y168.387 E.01647
G1 X147.719 Y151.613 E.73067
G1 X147.184 Y151.613 E.01647
G1 X163.958 Y168.387 E.73067
G1 X163.423 Y168.387 E.01647
G1 X146.75 Y151.714 E.7263
G2 X146.615 Y152.114 I.342 J.338 E.01346
G1 X162.889 Y168.387 E.70887
G1 X162.354 Y168.387 E.01647
G1 X146.615 Y152.648 E.68559
G1 X146.615 Y153.183 E.01646
G1 X161.819 Y168.387 E.6623
G1 X161.285 Y168.387 E.01647
G1 X146.615 Y153.717 E.63902
G1 X146.615 Y154.252 E.01646
G1 X160.75 Y168.387 E.61574
G1 X160.216 Y168.387 E.01647
G1 X146.615 Y154.786 E.59246
G1 X146.615 Y155.321 E.01646
G1 X159.681 Y168.387 E.56917
G1 X159.147 Y168.387 E.01647
G1 X146.615 Y155.855 E.54589
G1 X146.615 Y156.39 E.01646
G1 X158.612 Y168.387 E.52261
G1 X158.077 Y168.387 E.01647
G1 X146.615 Y156.924 E.49932
G1 X146.615 Y157.459 E.01646
G1 X157.543 Y168.387 E.47604
G1 X157.008 Y168.387 E.01647
G1 X146.615 Y157.993 E.45276
G1 X146.615 Y158.528 E.01646
G1 X156.474 Y168.387 E.42947
G1 X155.939 Y168.387 E.01647
G1 X146.614 Y159.062 E.40619
G1 X146.614 Y159.597 E.01646
G1 X155.405 Y168.387 E.38291
G1 X154.87 Y168.387 E.01647
G1 X146.614 Y160.131 E.35962
G1 X146.614 Y160.666 E.01646
G1 X154.335 Y168.387 E.33634
G1 X153.801 Y168.387 E.01647
G1 X146.614 Y161.2 E.31306
G1 X146.614 Y161.735 E.01646
G1 X153.266 Y168.387 E.28977
G1 X152.732 Y168.387 E.01647
G1 X146.614 Y162.269 E.26649
G1 X146.614 Y162.804 E.01646
G1 X152.197 Y168.387 E.24321
G1 X151.663 Y168.387 E.01647
G1 X146.614 Y163.338 E.21992
G1 X146.614 Y163.873 E.01646
M73 P62 R4
G1 X151.128 Y168.387 E.19664
G1 X150.593 Y168.387 E.01647
G1 X146.614 Y164.407 E.17336
G1 X146.614 Y164.942 E.01646
G1 X150.059 Y168.387 E.15008
G1 X149.524 Y168.387 E.01647
G1 X146.614 Y165.476 E.12679
G1 X146.613 Y166.011 E.01646
G1 X148.99 Y168.387 E.10351
G1 X148.455 Y168.387 E.01647
G1 X146.613 Y166.545 E.08023
G1 X146.613 Y167.08 E.01646
G1 X147.921 Y168.387 E.05694
G1 X147.386 Y168.387 E.01647
G1 X146.613 Y167.614 E.03366
G2 X146.636 Y168.124 I1.665 J.179 E.01577
G1 X146.694 Y168.23 E.00372
G1 X147.021 Y168.556 E.01422
; CHANGE_LAYER
; Z_HEIGHT: 0.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X146.694 Y168.23 E-.17541
G1 X146.636 Y168.124 E-.04589
G1 X146.613 Y167.972 E-.05814
G1 X146.613 Y167.708 E-.10056
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 4/28
; update layer progress
M73 L4
M991 S0 P3 ;notify layer change
M106 S252.45
G17
G3 Z1 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.686 Y163.505
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.456 Y163.443 E.00793
G3 X187.323 Y156.402 I1.045 J-3.445 E.33413
G3 X187.675 Y156.402 I.177 J4.204 E.01166
G3 X186.798 Y163.529 I-.174 J3.596 E.39284
G1 X186.745 Y163.518 E.0018
M204 S250
G1 X186.782 Y163.125 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.569 Y163.068 E.00675
G3 X187.342 Y156.794 I.931 J-3.07 E.27582
G3 X187.657 Y156.794 I.158 J3.764 E.00966
G3 X186.875 Y163.145 I-.157 J3.204 E.32422
G1 X186.84 Y163.137 E.00107
; WIPE_START
M204 S10000
G1 X186.569 Y163.068 E-.1063
G1 X186.272 Y162.966 E-.11961
G1 X185.909 Y162.783 E-.15409
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.2 I-.662 J1.021 P1  F60000
G1 X193.917 Y167.972 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X193.917 Y167.99 E.0006
G3 X192.99 Y168.917 I-.919 J.007 E.0484
G1 X147.01 Y168.917 E1.52525
G3 X146.083 Y167.99 I.001 J-.928 E.04828
G1 X146.083 Y152.01 E.5301
G3 X147.01 Y151.083 I.919 J-.007 E.0484
G1 X193.063 Y151.085 E1.52767
G3 X193.917 Y152.01 I-.075 J.926 E.04587
G1 X193.917 Y167.912 E.52751
M204 S250
G1 X194.309 Y167.972 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2160
M204 S5000
G1 X194.309 Y167.996 E.00075
G1 F2280
G3 X192.996 Y169.309 I-1.312 J.001 E.06338
G1 X147.604 Y169.309 E1.39479
G3 X146.7 Y169.274 I-.3 J-3.923 E.02786
G3 X145.691 Y167.996 I.307 J-1.279 E.05393
G1 X145.691 Y167.396 E.01844
G1 F2160
G1 X145.691 Y152.004 E.47298
G1 F2280
G3 X147.004 Y150.691 I1.312 J-.001 E.06338
G1 X147.604 Y150.691 E.01844
G1 F2160
G1 X192.996 Y150.691 E1.39479
G1 F2280
G1 X193.097 Y150.694 E.00309
G3 X194.309 Y152.004 I-.113 J1.32 E.06016
G1 X194.309 Y152.604 E.01844
G1 F2160
G1 X194.309 Y167.912 E.47038
; WIPE_START
M204 S10000
G1 X194.309 Y167.996 E-.03203
G1 X194.294 Y168.199 E-.07742
G1 X194.212 Y168.494 E-.11619
G1 X194.116 Y168.683 E-.08043
G1 X193.997 Y168.837 E-.07393
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.2 I.324 J-1.173 P1  F60000
G1 X191.052 Y168.023 Z1.2
G1 Z.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G1 X192.681 Y168.023 E.05401
G1 X193.023 Y167.671 E.01628
G1 X189.001 Y163.649 E.18867
; WIPE_START
G1 X189.708 Y164.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.2 I1.216 J.051 P1  F60000
G1 X190.016 Y156.96 Z1.2
G1 Z.8
G1 E.4 F1800
G1 F18423.913
G3 X193.023 Y160.005 I-272.298 J271.913 E.14197
G1 X190.669 Y162.359 E.11042
G3 X189.859 Y163.169 I-3.501 J-2.691 E.03814
G1 X185.005 Y168.023 E.2277
G1 X185.699 Y168.023 E.02303
G1 X169.654 Y151.978 E.7527
G1 X170.346 Y151.978 E.02296
G1 X154.301 Y168.023 E.7527
G1 X154.995 Y168.023 E.02303
G1 X146.977 Y160.005 E.37615
G1 X154.995 Y151.977 E.37636
G1 X154.301 Y151.977 E.023
G1 X170.347 Y168.023 E.75274
G1 X169.653 Y168.023 E.02303
G1 X185.697 Y151.979 E.75267
G1 X185.007 Y151.979 E.02291
G1 X189.859 Y156.831 E.22761
G2 X189.541 Y156.618 I-1.252 J1.524 E.01269
G1 X189.001 Y156.351 F60000
M73 P63 R4
G1 F18423.913
G1 X193.023 Y152.329 E.18867
G1 X192.683 Y151.979 E.01619
G1 X191.055 Y151.979 E.05401
G1 X148.948 Y168.023 F60000
G1 F18423.913
G1 X147.319 Y168.023 E.05401
G1 X146.977 Y167.671 E.01628
G1 X162.67 Y151.978 E.73621
G1 X161.978 Y151.978 E.02298
G1 X178.023 Y168.023 E.75272
G1 X177.329 Y168.023 E.02303
G1 X183.851 Y161.501 E.30595
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X177.33 Y151.978 E.30588
G1 X178.022 Y151.978 E.02293
G1 X161.977 Y168.023 E.75269
G1 X162.671 Y168.023 E.02303
G1 X146.977 Y152.329 E.73624
G1 X147.319 Y151.977 E.01628
G1 X148.948 Y151.977 E.05401
G1 X147.043 Y168.47 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.529947
G1 F15000
G1 X192.968 Y168.47 E1.82259
G1 X193.286 Y168.363 E.0133
G1 X193.452 Y168.093 E.01257
G1 X193.469 Y167.959 E.00536
G1 X193.47 Y152.042 E.63169
G1 X193.374 Y151.744 E.01242
G1 X193.243 Y151.613 E.00738
G1 X192.992 Y151.532 E.01044
G1 X147.042 Y151.53 E1.8236
G1 X146.802 Y151.589 E.0098
G1 X146.653 Y151.7 E.0074
G1 X146.549 Y151.907 E.00918
G1 X146.53 Y152.043 E.00546
G1 X146.53 Y167.968 E.632
G1 X146.631 Y168.274 E.01278
G1 X146.855 Y168.441 E.01109
G1 X146.984 Y168.461 E.0052
; CHANGE_LAYER
; Z_HEIGHT: 1
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X146.855 Y168.441 E-.04974
G1 X146.631 Y168.274 E-.10614
G1 X146.53 Y167.968 E-.1224
G1 X146.53 Y167.7 E-.10171
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 5/28
; update layer progress
M73 L5
M991 S0 P4 ;notify layer change
G17
G3 Z1.2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.695 Y163.507
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.456 Y163.443 E.00822
G3 X187.323 Y156.402 I1.045 J-3.445 E.33413
G3 X187.674 Y156.402 I.178 J4.382 E.01164
G3 X186.798 Y163.529 I-.174 J3.596 E.39286
G1 X186.754 Y163.52 E.0015
M204 S250
G1 X186.79 Y163.127 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.569 Y163.068 E.00703
G3 X187.342 Y156.794 I.931 J-3.07 E.27583
G3 X187.657 Y156.794 I.158 J3.927 E.00966
G3 X186.875 Y163.145 I-.156 J3.204 E.32423
G1 X186.849 Y163.139 E.0008
; WIPE_START
M204 S10000
G1 X186.569 Y163.068 E-.10965
G1 X186.272 Y162.966 E-.11966
G1 X185.987 Y162.831 E-.11978
G1 X185.917 Y162.789 E-.03091
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.4 I-.653 J1.027 P1  F60000
G1 X194.068 Y167.976 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X194.068 Y167.988 E.00042
G3 X192.988 Y169.068 I-1.076 J.004 E.0563
G1 X147.012 Y169.068 E1.52514
G3 X145.932 Y167.988 I-.009 J-1.071 E.05637
G1 X145.932 Y152.012 E.52998
G3 X147.012 Y150.932 I1.076 J-.004 E.0563
G1 X193.002 Y150.933 E1.52559
G3 X194.067 Y151.997 I-.01 J1.075 E.05534
G1 X194.068 Y167.916 E.52804
M204 S250
G1 X194.46 Y167.976 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F2880
M204 S5000
G1 X194.461 Y167.996 E.00063
G3 X194.429 Y168.301 I-4.183 J-.291 E.00944
G3 X194.035 Y169.029 I-1.532 J-.358 E.02572
G1 F2760
G1 X193.955 Y169.104 E.00338
G1 F2880
G3 X193.4 Y169.404 I-1.051 J-1.282 E.01948
G1 F2760
G1 X193.301 Y169.429 E.00315
G1 F2880
G3 X192.396 Y169.46 I-.593 J-4.044 E.02789
G1 X147.604 Y169.46 E1.37633
G3 X146.7 Y169.429 I-.309 J-4.188 E.02786
G3 X145.596 Y168.4 I.321 J-1.451 E.04861
G1 F2760
G1 X145.571 Y168.301 E.00315
G1 F2880
G3 X145.54 Y167.396 I4.047 J-.593 E.02788
G1 X145.54 Y152.604 E.45451
G3 X145.571 Y151.699 I4.183 J-.309 E.02789
G3 X145.965 Y150.971 I1.532 J.358 E.02572
G1 F2760
G1 X146.045 Y150.896 E.00338
G1 F2880
G3 X146.6 Y150.596 I1.051 J1.282 E.01948
G1 F2760
G1 X146.699 Y150.571 E.00315
G1 F2880
G3 X147.604 Y150.54 I.593 J4.045 E.02789
G1 X193.015 Y150.541 E1.39535
G3 X194.395 Y151.573 I-.018 J1.463 E.05665
G1 F2760
G1 X194.428 Y151.698 E.00396
G1 F2880
G3 X194.459 Y151.985 I-1.622 J.32 E.00887
G1 X194.46 Y167.396 E.47355
G1 X194.46 Y167.916 E.01597
; WIPE_START
M204 S10000
G1 X194.461 Y167.996 E-.03056
G1 X194.429 Y168.301 E-.11669
G1 X194.371 Y168.499 E-.07817
G1 X194.286 Y168.69 E-.07969
G1 X194.18 Y168.857 E-.0749
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.4 I.199 J-1.201 P1  F60000
G1 X190.783 Y168.293 Z1.4
G1 Z1
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G1 X192.411 Y168.293 E.05401
G1 X193.29 Y167.413 E.04124
G1 X193.29 Y167.938 E.01741
G1 X189.001 Y163.649 E.2012
; WIPE_START
G1 X189.708 Y164.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.4 I1.212 J-.107 P1  F60000
G1 X189.001 Y156.351 Z1.4
G1 Z1
G1 E.4 F1800
G1 F18423.913
G1 X193.293 Y152.059 E.20131
G1 X193.292 Y152.589 E.01756
G1 X192.414 Y151.71 E.04123
G1 X190.785 Y151.71 E.05401
G1 X156.893 Y168.293 F60000
M73 P63 R3
G1 F18423.913
G1 X155.265 Y168.293 E.05401
G1 X146.709 Y159.736 E.40138
G1 X146.709 Y160.264 E.01748
G1 X155.264 Y151.708 E.40137
G1 X154.032 Y151.708 E.04088
G1 X170.617 Y168.293 E.77802
M73 P64 R3
G1 X169.383 Y168.293 E.04091
G1 X185.967 Y151.709 E.77795
G1 X184.737 Y151.709 E.04078
G1 X189.859 Y156.831 E.24025
G3 X193.291 Y160.263 I-57.364 J60.797 E.16106
G1 X193.291 Y159.736 E.01748
G1 X190.669 Y162.359 E.12301
G3 X189.859 Y163.169 I-3.503 J-2.692 E.03815
G1 X184.735 Y168.293 E.24034
G1 X185.968 Y168.293 E.04091
G1 X169.385 Y151.709 E.77799
G1 X170.615 Y151.709 E.04083
G1 X154.032 Y168.293 E.77799
G1 X147.589 Y168.293 E.21372
G1 X146.708 Y167.411 E.04134
G1 X146.707 Y167.941 E.01756
G1 X162.94 Y151.708 E.76149
G1 X161.708 Y151.708 E.04086
G1 X178.293 Y168.293 E.77801
G1 X177.059 Y168.293 E.04091
G1 X183.851 Y161.501 E.31859
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X177.061 Y151.709 E.31852
G1 X178.291 Y151.709 E.04081
G1 X161.707 Y168.293 E.77797
G1 X162.941 Y168.293 E.04091
G1 X146.71 Y152.062 E.76142
G1 X146.71 Y152.587 E.01741
G1 X147.589 Y151.707 E.04124
G1 X149.217 Y151.708 E.05401
G1 X147.033 Y168.68 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.41169
G1 F15000
G1 X192.969 Y168.68 E1.38036
G1 X193.281 Y168.602 E.00968
G1 X193.543 Y168.401 E.00993
G1 X193.677 Y168.015 E.0123
G1 X193.68 Y152.027 E.48041
G1 X193.572 Y151.649 E.01181
G1 X193.351 Y151.43 E.00936
G1 X192.972 Y151.322 E.01184
G1 X147.031 Y151.32 E1.38052
G1 X146.719 Y151.398 E.00968
G1 X146.456 Y151.6 E.00997
G1 X146.324 Y151.985 E.01225
G1 X146.321 Y152.038 E.00158
G1 X146.32 Y167.969 E.47872
G1 X146.396 Y168.279 E.00961
G1 X146.6 Y168.544 E.01005
G1 X146.861 Y168.658 E.00854
G1 X146.974 Y168.672 E.00343
; CHANGE_LAYER
; Z_HEIGHT: 1.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X146.861 Y168.658 E-.04334
G1 X146.6 Y168.544 E-.10801
G1 X146.396 Y168.279 E-.12708
G1 X146.332 Y168.019 E-.10158
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 6/28
; update layer progress
M73 L6
M991 S0 P5 ;notify layer change
G17
G3 Z1.4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.704 Y163.51
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15077
G1 X186.456 Y163.443 E.00853
G3 X187.323 Y156.402 I1.045 J-3.445 E.33411
G3 X187.674 Y156.402 I.178 J4.561 E.01162
G3 X186.798 Y163.529 I-.173 J3.596 E.3929
G1 X186.763 Y163.522 E.0012
M204 S250
G1 X186.8 Y163.128 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.42 Y163.019 E.01216
G3 X187.342 Y156.794 I1.08 J-3.021 E.27098
G3 X187.656 Y156.794 I.158 J4.085 E.00965
G3 X186.875 Y163.145 I-.156 J3.204 E.32424
G1 X186.859 Y163.141 E.0005
; WIPE_START
M204 S10000
G1 X186.42 Y163.019 E-.17313
G1 X186.127 Y162.902 E-.11966
G1 X185.925 Y162.794 E-.08721
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.6 I-.647 J1.03 P1  F60000
G1 X194.183 Y167.982 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F15077
G1 X194.183 Y167.991 E.00027
G3 X192.991 Y169.183 I-1.185 J.008 E.06227
G1 X147.009 Y169.183 E1.52528
G3 X145.817 Y167.991 I-.008 J-1.185 E.06227
G1 X145.817 Y152.009 E.53012
G3 X147.009 Y150.817 I1.185 J-.008 E.06227
G1 X193.048 Y150.819 E1.52718
G3 X194.181 Y151.952 I-.047 J1.18 E.05845
G1 X194.183 Y167.922 E.52976
M204 S250
G1 X194.573 Y167.984 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F6600
M204 S5000
G1 X194.566 Y168.099 E.00356
G3 X194.525 Y168.395 I-3.946 J-.402 E.00918
G3 X193.777 Y169.367 I-1.539 J-.41 E.03868
G1 X193.592 Y169.46 E.00637
G1 F6441.604
G1 X193.297 Y169.547 E.00944
G1 F5700
G1 X193.192 Y169.564 E.00328
G1 F6600
G1 X192.792 Y169.57 E.01229
G1 X192.397 Y169.575 E.01214
G1 X147.603 Y169.575 E1.37637
G3 X146.703 Y169.547 I-.312 J-4.448 E.02772
G3 X145.619 Y168.758 I.299 J-1.55 E.04255
G1 X145.505 Y168.494 E.00884
G1 F6187.86
G1 X145.453 Y168.297 E.00628
G1 F5700
G1 X145.436 Y168.192 E.00327
G1 F6600
G1 X145.43 Y167.792 E.01229
G1 X145.425 Y167.397 E.01214
G1 X145.425 Y152.603 E.45455
G3 X145.475 Y151.605 I3.959 J-.3 E.0308
G3 X146.223 Y150.633 I1.539 J.41 E.03868
G1 X146.408 Y150.54 E.00637
G1 F6441.604
G1 X146.703 Y150.453 E.00944
G1 F5700
G1 X146.808 Y150.436 E.00328
G1 F6600
G1 X147.208 Y150.43 E.01229
G1 X147.603 Y150.425 E.01214
G1 X192.663 Y150.427 E1.38455
G1 X193.063 Y150.427 E.01229
G1 F6028.023
G1 X193.201 Y150.437 E.00425
G1 F5700
G1 X193.298 Y150.453 E.00303
G1 F6324.172
G1 X193.548 Y150.524 E.00799
G1 F6600
G1 X193.78 Y150.632 E.00784
G3 X194.369 Y151.22 I-.783 J1.371 E.0259
G1 X194.459 Y151.408 E.00639
G1 F6441.586
G1 X194.547 Y151.702 E.00944
G1 F5700
G1 X194.563 Y151.799 E.00303
G1 F6600
G1 X194.569 Y152.199 E.01229
G1 X194.574 Y152.537 E.01039
G1 X194.575 Y167.397 E.45659
G1 X194.573 Y167.924 E.01619
; WIPE_START
M204 S10000
G1 X194.566 Y168.099 E-.06683
G1 X194.525 Y168.395 E-.11346
G1 X194.38 Y168.759 E-.14898
G1 X194.308 Y168.872 E-.05074
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.6 I.854 J-.867 P1  F60000
G1 X189.001 Y163.649 Z1.6
G1 Z1.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F15077
G1 X193.465 Y168.113 E.2094
G1 X193.487 Y167.217 E.02975
G1 X192.214 Y168.489 E.05971
G1 X190.586 Y168.489 E.05401
; WIPE_START
G1 F18423.913
G1 X191.586 Y168.489 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.6 I1.215 J-.071 P1  F60000
G1 X190.588 Y151.513 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F15077
G1 X192.217 Y151.513 E.05401
G1 X193.489 Y152.786 E.05971
G2 X193.47 Y151.882 I-3.121 J-.385 E.03009
G1 X189.001 Y156.351 E.20964
; WIPE_START
G1 F18423.913
G1 X189.708 Y155.643 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.6 I-.611 J-1.053 P1  F60000
G1 X167.558 Y168.489 Z1.6
G1 Z1.2
G1 E.4 F1800
G1 F15077
G1 X169.186 Y168.489 E.05401
G1 X186.164 Y151.512 E.79643
G1 X184.54 Y151.512 E.05385
G1 X189.859 Y156.831 E.2495
G3 X193.488 Y160.46 I-61.238 J64.867 E.17029
G1 X193.488 Y159.54 E.03054
G1 X190.669 Y162.359 E.13224
G3 X189.859 Y163.169 I-3.501 J-2.69 E.03814
G1 X184.538 Y168.489 E.24959
G1 X186.165 Y168.489 E.05397
G1 X169.188 Y151.512 E.79647
G1 X170.812 Y151.512 E.0539
G1 X153.835 Y168.489 E.79646
G1 X155.462 Y168.489 E.05397
G1 X146.511 Y159.538 E.41992
G1 X146.511 Y160.462 E.03063
G1 X155.461 Y151.511 E.4199
G1 X153.835 Y151.511 E.05395
G1 X170.814 Y168.489 E.7965
G1 X172.442 Y168.489 E.05401
M73 P65 R3
G1 X149.414 Y168.489 F60000
G1 F15077
G1 X147.786 Y168.489 E.05401
G1 X146.511 Y167.214 E.05982
G2 X146.53 Y168.118 I3.095 J.385 E.03009
G1 X163.137 Y151.511 E.77906
G1 X161.511 Y151.511 E.05392
G1 X178.49 Y168.489 E.79649
G1 X176.862 Y168.489 E.05397
G1 X183.851 Y161.501 E.32783
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X176.864 Y151.512 E.32776
G1 X178.488 Y151.512 E.05387
G1 X161.511 Y168.489 E.79645
G1 X163.138 Y168.489 E.05397
G1 X146.534 Y151.886 E.7789
G2 X146.511 Y152.786 I2.959 J.528 E.02997
G1 X147.786 Y151.511 E.05982
G1 X149.414 Y151.511 E.05401
G1 X147.033 Y168.836 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
G1 F15000
G1 X192.968 Y168.836 E1.27267
G1 X193.353 Y168.749 E.01094
G1 X193.676 Y168.484 E.01159
G2 X193.834 Y168.035 I-.715 J-.503 E.01336
G1 X193.835 Y152.017 E.44378
G1 X193.758 Y151.656 E.01023
G1 X193.566 Y151.393 E.00902
G1 X193.246 Y151.212 E.01018
G1 X193.016 Y151.166 E.00649
G1 X147.032 Y151.164 E1.27403
G1 X146.652 Y151.247 E.01079
G1 X146.334 Y151.504 E.01131
G1 X146.202 Y151.775 E.00836
G1 X146.165 Y152.033 E.0072
G1 X146.164 Y167.975 E.44169
G1 X146.247 Y168.336 E.01027
G2 X146.973 Y168.828 I.767 J-.349 E.02556
; CHANGE_LAYER
; Z_HEIGHT: 1.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X146.779 Y168.801 E-.07469
G1 X146.565 Y168.708 E-.08844
G1 X146.379 Y168.541 E-.095
G1 X146.247 Y168.336 E-.09265
G1 X146.23 Y168.261 E-.02921
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 7/28
; update layer progress
M73 L7
M991 S0 P6 ;notify layer change
G17
G3 Z1.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.714 Y163.512
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10453
G1 X186.456 Y163.443 E.00886
G3 X187.323 Y156.402 I1.045 J-3.445 E.33411
G3 X187.673 Y156.402 I.178 J4.733 E.01161
G3 X186.798 Y163.529 I-.172 J3.596 E.39292
G1 X186.772 Y163.524 E.00087
M204 S250
G1 X186.809 Y163.132 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10453
M204 S5000
G1 X186.569 Y163.068 E.00762
G3 X187.342 Y156.794 I.931 J-3.07 E.27581
G3 X187.656 Y156.794 I.158 J4.236 E.00965
G3 X186.875 Y163.145 I-.156 J3.204 E.32425
G1 X186.868 Y163.143 E.00021
; WIPE_START
G1 F12000
M204 S10000
G1 X186.569 Y163.068 E-.11695
G1 X186.272 Y162.966 E-.1196
G1 X185.934 Y162.796 E-.14345
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.8 I-.643 J1.033 P1  F60000
G1 X194.271 Y167.985 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10453
G1 X194.271 Y167.992 E.00022
G3 X192.992 Y169.271 I-1.273 J.006 E.06674
G1 X147.008 Y169.271 E1.52536
G3 X145.729 Y167.992 I-.001 J-1.278 E.06668
G1 X145.729 Y152.008 E.53019
G3 X147.008 Y150.729 I1.273 J-.006 E.06674
G1 X193.069 Y150.732 E1.52791
G3 X194.268 Y151.931 I-.076 J1.276 E.06153
G1 X194.271 Y167.925 E.53055
M204 S250
G1 X194.661 Y167.986 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10453
M204 S5000
G1 X194.655 Y168.097 E.00341
G3 X194.616 Y168.39 I-4.194 J-.4 E.00906
G3 X192.997 Y169.663 I-1.62 J-.394 E.06823
G1 X147.603 Y169.663 E1.39483
G3 X146.61 Y169.616 I-.3 J-4.209 E.03061
G3 X145.337 Y167.997 I.401 J-1.626 E.06818
G1 X145.337 Y152.603 E.47301
G3 X145.384 Y151.61 I4.208 J-.3 E.03061
G3 X147.003 Y150.337 I1.62 J.394 E.06823
G1 X193.085 Y150.339 E1.41597
G3 X194.661 Y151.915 I-.095 J1.671 E.07491
G1 X194.663 Y167.397 E.47573
G1 X194.661 Y167.926 E.01627
; WIPE_START
G1 F11100
M204 S10000
G1 X194.655 Y168.097 E-.06501
G1 X194.616 Y168.39 E-.112
G1 X194.519 Y168.675 E-.11452
G1 X194.407 Y168.879 E-.08847
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.8 I-.013 J-1.217 P1  F60000
G1 X190.153 Y168.923 Z1.8
G1 Z1.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10453
G1 X191.781 Y168.923 E.05401
G1 X193.92 Y166.783 E.10035
G3 X193.905 Y168.172 I-5.389 J.635 E.04618
G3 X193.802 Y168.45 I-.889 J-.17 E.00989
G1 X189.001 Y163.649 E.22522
; WIPE_START
G1 F18423.913
G1 X189.708 Y164.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z1.8 I1.212 J-.107 P1  F60000
G1 X189.001 Y156.351 Z1.8
G1 Z1.4
G1 E.4 F1800
G1 F10453
G1 X193.8 Y151.552 E.22511
G3 X193.92 Y151.956 I-.892 J.486 E.01408
G1 X193.92 Y153.216 E.04181
G1 X191.784 Y151.08 E.10024
G1 X190.155 Y151.08 E.05401
G1 X157.523 Y168.923 F60000
G1 F10453
G1 X155.895 Y168.923 E.05401
G1 X146.079 Y159.106 E.4605
G1 X146.078 Y160.894 E.05929
G1 X155.894 Y151.078 E.46049
G1 X153.402 Y151.078 E.08268
G1 X171.247 Y168.923 E.83714
G1 X168.753 Y168.923 E.08271
G1 X186.597 Y151.079 E.83706
G1 X184.107 Y151.079 E.08258
G1 X189.859 Y156.831 E.26981
G3 X190.669 Y157.641 I-2.69 J3.5 E.03814
G1 X193.92 Y160.892 E.15252
G1 X193.92 Y159.108 E.05921
G1 X190.669 Y162.359 E.15251
G3 X189.859 Y163.169 I-3.501 J-2.69 E.03814
G1 X184.105 Y168.923 E.2699
G1 X186.599 Y168.923 E.08271
G1 X168.754 Y151.078 E.83711
G1 X171.245 Y151.079 E.08263
G1 X153.401 Y168.923 E.8371
G1 X148.219 Y168.923 E.17192
G1 X146.078 Y166.781 E.10045
G2 X146.093 Y168.16 I7.933 J.599 E.04579
G2 X146.198 Y168.45 I.896 J-.158 E.01029
G1 X163.57 Y151.078 E.81497
G1 X161.078 Y151.078 E.08266
G1 X178.923 Y168.923 E.83713
G1 X176.429 Y168.923 E.08271
M73 P66 R3
G1 X183.851 Y161.501 E.34815
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X176.431 Y151.079 E.34808
G1 X178.921 Y151.079 E.0826
G1 X161.077 Y168.923 E.83708
G1 X163.571 Y168.923 E.08271
G1 X146.198 Y151.55 E.815
G2 X146.08 Y151.947 I.945 J.497 E.01383
G1 X146.079 Y153.217 E.04212
G1 X148.219 Y151.077 E.10036
G1 X149.847 Y151.077 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X148.847 Y151.077 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 8/28
; update layer progress
M73 L8
M991 S0 P7 ;notify layer change
G17
G3 Z1.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.723 Y163.514
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F10690
G1 X186.456 Y163.443 E.00919
G3 X187.331 Y156.402 I1.044 J-3.445 E.33441
G1 X187.669 Y156.402 E.01124
G3 X186.798 Y163.529 I-.169 J3.596 E.393
G1 X186.782 Y163.526 E.00054
M204 S250
G1 X186.818 Y163.135 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10690
M204 S5000
G1 X186.569 Y163.068 E.00792
G3 X187.345 Y156.794 I.931 J-3.07 E.27592
G1 X187.655 Y156.794 E.00952
G3 X186.877 Y163.145 I-.155 J3.204 E.32418
; WIPE_START
G1 F12000
M204 S10000
G1 X186.569 Y163.068 E-.12066
G1 X186.272 Y162.966 E-.11968
G1 X185.987 Y162.831 E-.11971
G1 X185.942 Y162.804 E-.01995
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2 I-.64 J1.035 P1  F60000
G1 X194.334 Y167.988 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10690
G1 X194.334 Y167.992 E.00013
G3 X192.992 Y169.334 I-1.341 J.001 E.06994
G1 X147.012 Y169.334 E1.52523
G3 X145.666 Y167.992 I-.009 J-1.338 E.07014
G1 X145.666 Y152.008 E.53022
G3 X147.008 Y150.666 I1.341 J-.001 E.06994
G1 X193.069 Y150.668 E1.52793
G3 X194.334 Y152.008 I-.085 J1.348 E.06728
G1 X194.334 Y167.928 E.52811
M204 S250
G1 X194.724 Y167.99 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10690
M204 S5000
G1 X194.724 Y168.095 E.00324
G3 X193.567 Y169.63 I-1.739 J-.108 E.06253
G3 X193.19 Y169.716 I-.681 J-2.116 E.01191
G1 X193.095 Y169.724 E.00291
G3 X192.397 Y169.726 I-.398 J-13.574 E.02146
G1 X147.004 Y169.726 E1.39479
G3 X146.339 Y169.594 I.003 J-1.756 E.02096
G3 X146.166 Y169.51 I.648 J-1.567 E.00592
G3 X145.37 Y168.567 I.869 J-1.54 E.03874
G3 X145.284 Y168.19 I2.117 J-.681 E.01191
G1 X145.276 Y168.095 E.0029
G3 X145.274 Y167.397 I13.574 J-.398 E.02146
G1 X145.274 Y152.603 E.45458
G3 X145.276 Y151.905 I13.577 J-.3 E.02146
G3 X146.433 Y150.37 I1.739 J.108 E.06253
G3 X146.81 Y150.284 I.681 J2.116 E.01191
G1 X146.905 Y150.276 E.00291
G3 X147.603 Y150.274 I.398 J13.574 E.02146
G1 X192.397 Y150.274 E1.3764
G3 X193.09 Y150.276 I.3 J13.719 E.0213
G1 X193.197 Y150.285 E.0033
G3 X193.38 Y150.317 I-.193 J1.679 E.00571
G3 X193.702 Y150.424 I-.426 J1.808 E.01044
G3 X194.576 Y151.298 I-.713 J1.587 E.03883
G3 X194.683 Y151.62 I-1.696 J.746 E.01044
G3 X194.715 Y151.803 I-1.657 J.378 E.0057
G3 X194.726 Y152.603 I-6.173 J.488 E.02461
G1 X194.726 Y167.397 E.45459
G1 X194.724 Y167.93 E.01637
; WIPE_START
G1 F12000
M204 S10000
G1 X194.724 Y168.095 E-.06293
G1 X194.699 Y168.302 E-.07919
G1 X194.63 Y168.567 E-.10393
G1 X194.53 Y168.796 E-.09498
G1 X194.477 Y168.884 E-.03897
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2 I.841 J-.88 P1  F60000
G1 X189.001 Y163.649 Z2
G1 Z1.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10690
G1 X193.847 Y168.495 E.22734
G2 X193.984 Y168.053 I-1.452 J-.69 E.0154
G1 X193.984 Y166.72 E.04423
G1 X191.718 Y168.986 E.1063
G1 X190.09 Y168.986 E.05401
; WIPE_START
G1 F18423.913
G1 X191.09 Y168.986 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2 I1.215 J-.067 P1  F60000
G1 X190.092 Y151.016 Z2
G1 Z1.6
G1 E.4 F1800
G1 F10690
G1 X191.72 Y151.016 E.05401
G1 X193.986 Y153.282 E.1063
G2 X193.959 Y151.782 I-6.821 J-.628 E.04986
G2 X193.846 Y151.506 I-.791 J.164 E.00994
G1 X189.001 Y156.351 E.22726
; WIPE_START
G1 F18423.913
G1 X189.708 Y155.643 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2 I-.618 J-1.049 P1  F60000
G1 X167.062 Y168.986 Z2
G1 Z1.6
G1 E.4 F1800
G1 F10690
G1 X168.69 Y168.986 E.05401
G1 X186.66 Y151.016 E.84301
G1 X184.044 Y151.016 E.0868
G1 X189.859 Y156.831 E.27279
G3 X190.669 Y157.641 I-2.689 J3.5 E.03814
G1 X193.985 Y160.957 E.15553
G1 X193.985 Y159.043 E.06349
G1 X190.669 Y162.359 E.15554
G3 X189.859 Y163.169 I-3.5 J-2.689 E.03814
G1 X184.042 Y168.986 E.27287
G1 X186.662 Y168.986 E.0869
G1 X168.691 Y151.015 E.84305
G1 X171.309 Y151.015 E.08684
G1 X153.338 Y168.986 E.84304
G1 X155.958 Y168.986 E.0869
G1 X146.015 Y159.043 E.46643
G1 X146.015 Y160.957 E.06349
G1 X155.958 Y151.015 E.46643
G1 X153.338 Y151.014 E.08688
G1 X171.31 Y168.986 E.84308
G1 X172.938 Y168.986 E.05401
G1 X149.91 Y168.986 F60000
G1 F10690
G1 X148.282 Y168.986 E.05401
G1 X146.014 Y166.718 E.10638
G2 X146.069 Y168.318 I4.984 J.63 E.05334
G1 X146.153 Y168.496 E.00649
G1 X163.633 Y151.015 E.82005
G1 X161.015 Y151.015 E.08686
G1 X178.986 Y168.986 E.84306
G1 X176.366 Y168.986 E.0869
G1 X183.851 Y161.501 E.35111
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X176.367 Y151.015 E.35106
G1 X178.985 Y151.015 E.08682
G1 X161.014 Y168.986 E.84303
G1 X163.634 Y168.986 E.0869
G1 X146.153 Y151.505 E.82009
G2 X146.016 Y151.947 I1.455 J.691 E.0154
G1 X146.016 Y153.28 E.04423
G1 X148.282 Y151.014 E.1063
M73 P67 R3
G1 X149.91 Y151.014 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 1.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X148.91 Y151.014 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 9/28
; update layer progress
M73 L9
M991 S0 P8 ;notify layer change
G17
G3 Z2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.733 Y163.517
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
G1 F10605
G1 X186.456 Y163.443 E.00953
G3 X187.331 Y156.402 I1.044 J-3.445 E.33441
G1 X187.669 Y156.402 E.01124
G3 X186.798 Y163.529 I-.169 J3.596 E.393
G1 X186.792 Y163.528 E.0002
M204 S250
G1 X186.828 Y163.137 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10605
M204 S5000
G1 X186.569 Y163.068 E.00824
G3 X187.345 Y156.794 I.931 J-3.07 E.27591
G1 X187.655 Y156.794 E.00952
G3 X186.887 Y163.147 I-.155 J3.204 E.32387
; WIPE_START
G1 F12000
M204 S10000
G1 X186.569 Y163.068 E-.1246
G1 X186.272 Y162.966 E-.11961
G1 X185.987 Y162.831 E-.11978
G1 X185.951 Y162.809 E-.01602
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.2 I-.639 J1.036 P1  F60000
G1 X194.374 Y168.001 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10605
G1 X194.344 Y168.286 E.00951
G3 X192.993 Y169.375 I-1.35 J-.292 E.06225
G1 X147.01 Y169.375 E1.52533
G3 X145.625 Y167.992 I-.003 J-1.382 E.07214
G1 X145.625 Y152.008 E.53025
G3 X147.008 Y150.625 I1.381 J-.002 E.07207
G1 X193.071 Y150.627 E1.52801
G3 X194.375 Y152.007 I-.079 J1.381 E.06944
G1 X194.375 Y167.941 E.52855
M204 S250
G1 X194.765 Y167.995 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10605
M204 S5000
G1 X194.765 Y168.094 E.00305
G3 X194.754 Y168.213 I-1.171 J-.048 E.00369
G1 X194.741 Y168.302 E.00274
G1 X194.735 Y168.333 E.00099
G1 X194.725 Y168.379 E.00145
G1 X194.716 Y168.417 E.00119
G1 X194.703 Y168.471 E.00171
G3 X194.62 Y168.701 I-1.552 J-.425 E.00752
G3 X194.501 Y168.929 I-3.81 J-1.836 E.00792
G1 X194.422 Y169.047 E.00436
G1 X194.409 Y169.065 E.00068
G1 X194.342 Y169.147 E.00325
G1 X194.329 Y169.162 E.0006
G1 X194.27 Y169.225 E.00264
G3 X194.205 Y169.29 I-.43 J-.365 E.00284
G1 X194.137 Y169.351 E.00279
G1 X194.121 Y169.365 E.00068
G1 X194.077 Y169.4 E.00172
G1 X194.042 Y169.426 E.00134
G1 X194.012 Y169.447 E.00113
G3 X193.945 Y169.491 I-.33 J-.433 E.00245
G1 X193.872 Y169.535 E.00263
G3 X193.793 Y169.577 I-.31 J-.479 E.00274
G1 X193.74 Y169.603 E.00183
G1 X193.696 Y169.623 E.00148
G1 X193.658 Y169.639 E.00126
G1 X193.603 Y169.66 E.0018
G1 X193.568 Y169.673 E.00117
G1 X193.51 Y169.691 E.00187
G1 X193.475 Y169.701 E.00113
G1 X193.417 Y169.716 E.00183
G1 X193.379 Y169.725 E.00119
G1 X193.33 Y169.735 E.00156
G1 X193.303 Y169.74 E.00083
G1 X193.231 Y169.751 E.00225
G1 X193.187 Y169.757 E.00136
G1 X193.143 Y169.761 E.00136
G1 X193.094 Y169.765 E.00149
G1 X193.092 Y169.765 E.00006
G3 X192.397 Y169.767 I-.395 J-13.946 E.02136
G1 X147.603 Y169.767 E1.37639
G3 X146.88 Y169.762 I-.306 J-7.882 E.02223
G1 X146.779 Y169.751 E.00311
G1 X146.713 Y169.743 E.00207
G3 X146.47 Y169.684 I.266 J-1.625 E.0077
G3 X146.334 Y169.636 I.773 J-2.374 E.00443
G1 X146.2 Y169.574 E.00452
G1 X146.166 Y169.557 E.00118
G1 X146.135 Y169.54 E.00109
G3 X146.027 Y169.473 I.46 J-.866 E.00392
G1 X145.999 Y169.455 E.00101
G1 X145.978 Y169.44 E.00078
G1 X145.876 Y169.362 E.00396
G1 X145.848 Y169.338 E.00111
G1 X145.809 Y169.304 E.00163
G1 X145.699 Y169.194 E.00475
G1 X145.608 Y169.087 E.00433
G1 X145.597 Y169.073 E.00055
G1 X145.546 Y169.001 E.00272
G3 X145.488 Y168.913 I.641 J-.482 E.00324
G1 X145.484 Y168.906 E.00025
G1 X145.445 Y168.835 E.00248
G1 X145.402 Y168.752 E.00287
G1 X145.399 Y168.745 E.00026
G1 X145.359 Y168.652 E.00309
G1 X145.34 Y168.604 E.00159
G1 X145.327 Y168.567 E.00119
G1 X145.309 Y168.511 E.00182
G1 X145.298 Y168.475 E.00117
G1 X145.284 Y168.417 E.00183
G1 X145.275 Y168.379 E.00118
G1 X145.265 Y168.331 E.00151
G1 X145.26 Y168.303 E.00089
G1 X145.249 Y168.229 E.00228
G1 X145.243 Y168.187 E.00132
G1 X145.239 Y168.142 E.00138
G1 X145.235 Y168.094 E.00147
G1 X145.235 Y168.093 E.00006
G3 X145.233 Y167.397 I13.903 J-.395 E.02136
G1 X145.233 Y152.603 E.4546
G3 X145.235 Y151.906 I13.827 J-.298 E.02141
G3 X145.246 Y151.787 I1.171 J.048 E.00369
G1 X145.259 Y151.698 E.00274
G1 X145.265 Y151.667 E.00099
G1 X145.275 Y151.621 E.00145
G1 X145.284 Y151.583 E.00119
G1 X145.297 Y151.529 E.00171
G3 X145.38 Y151.299 I1.552 J.425 E.00752
G3 X145.499 Y151.071 I3.8 J1.831 E.00792
G1 X145.578 Y150.953 E.00437
G1 X145.592 Y150.935 E.00068
G1 X145.658 Y150.853 E.00325
G1 X145.671 Y150.838 E.0006
G1 X145.73 Y150.775 E.00264
G3 X145.795 Y150.71 I.43 J.365 E.00284
G1 X145.863 Y150.649 E.00279
G1 X145.879 Y150.635 E.00068
G1 X145.923 Y150.6 E.00172
G1 X145.958 Y150.574 E.00134
G1 X145.988 Y150.553 E.00113
G3 X146.055 Y150.509 I.33 J.433 E.00245
G1 X146.129 Y150.465 E.00263
G3 X146.207 Y150.423 I.31 J.479 E.00274
G1 X146.26 Y150.397 E.00183
G1 X146.304 Y150.377 E.00148
G1 X146.342 Y150.361 E.00126
G1 X146.397 Y150.34 E.0018
G1 X146.432 Y150.327 E.00117
G1 X146.49 Y150.309 E.00187
G1 X146.525 Y150.299 E.00113
G1 X146.583 Y150.284 E.00183
G1 X146.621 Y150.275 E.00119
G1 X146.67 Y150.265 E.00156
G1 X146.697 Y150.26 E.00083
G1 X146.769 Y150.249 E.00225
G1 X146.813 Y150.243 E.00136
G1 X146.857 Y150.239 E.00136
G1 X146.906 Y150.235 E.00149
G1 X146.908 Y150.235 E.00006
G3 X147.603 Y150.233 I.395 J13.946 E.02136
G1 X192.397 Y150.233 E1.37642
G3 X193.091 Y150.235 I.3 J13.888 E.02133
G1 X193.195 Y150.244 E.0032
G1 X193.238 Y150.25 E.00135
G1 X193.283 Y150.256 E.00137
G3 X193.537 Y150.318 I-.279 J1.704 E.00806
G1 X193.568 Y150.327 E.00097
G1 X193.591 Y150.336 E.00076
G3 X193.844 Y150.449 I-1.509 J3.715 E.00854
G1 X193.967 Y150.523 E.0044
G1 X193.999 Y150.544 E.00117
G1 X194.035 Y150.569 E.00135
G3 X194.146 Y150.657 I-1.04 J1.428 E.00434
G1 X194.199 Y150.704 E.00218
G1 X194.247 Y150.75 E.00205
G1 X194.271 Y150.774 E.00104
G3 X194.366 Y150.881 I-1.311 J1.263 E.00439
G1 X194.44 Y150.978 E.00375
G1 X194.455 Y150.999 E.00079
G1 X194.472 Y151.026 E.001
G3 X194.54 Y151.135 I-.801 J.569 E.00393
G1 X194.551 Y151.156 E.00073
G3 X194.664 Y151.409 I-2.431 J1.239 E.00852
G1 X194.673 Y151.433 E.00077
G1 X194.682 Y151.462 E.00095
G3 X194.744 Y151.717 I-1.642 J.534 E.00808
G1 X194.75 Y151.76 E.00133
G1 X194.756 Y151.805 E.00139
G1 X194.758 Y151.816 E.00033
G3 X194.767 Y152.603 I-6.65 J.476 E.0242
G1 X194.767 Y167.397 E.4546
G1 X194.765 Y167.935 E.01651
; WIPE_START
G1 F12000
M204 S10000
G1 X194.765 Y168.094 E-.06054
G1 X194.754 Y168.213 E-.04558
G1 X194.741 Y168.302 E-.03384
G1 X194.735 Y168.333 E-.01222
G1 X194.725 Y168.379 E-.01791
G1 X194.716 Y168.417 E-.01467
G1 X194.703 Y168.471 E-.02113
G1 X194.62 Y168.701 E-.09286
G1 X194.522 Y168.891 E-.08125
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.2 I-.037 J-1.216 P1  F60000
G1 X190.049 Y169.027 Z2.2
G1 Z1.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10605
G1 X191.677 Y169.027 E.05401
G1 X194.025 Y166.679 E.11016
G1 X194.025 Y168.048 E.04543
G3 X193.876 Y168.524 I-1.301 J-.145 E.01665
G1 X189.001 Y163.649 E.2287
; WIPE_START
G1 F18423.913
G1 X189.708 Y164.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.2 I1.212 J-.107 P1  F60000
G1 X189.001 Y156.351 Z2.2
G1 Z1.8
G1 E.4 F1800
G1 F10605
G1 X193.877 Y151.475 E.22874
G3 X194.027 Y152.021 I-1.724 J.766 E.01885
G1 X194.027 Y153.323 E.04319
G1 X191.679 Y150.975 E.11015
G1 X190.051 Y150.975 E.05401
G1 X157.627 Y169.027 F60000
G1 F10605
G1 X155.999 Y169.027 E.05401
G1 X145.974 Y159.002 E.47029
G1 X145.974 Y160.998 E.06621
G1 X155.999 Y150.973 E.47028
G1 X153.297 Y150.973 E.0896
G1 X171.351 Y169.027 E.84693
G1 X168.649 Y169.027 E.08963
G1 X186.701 Y150.975 E.84686
G1 X184.003 Y150.975 E.08952
G1 X189.859 Y156.831 E.27472
G3 X190.669 Y157.641 I-2.69 J3.501 E.03813
G1 X194.026 Y160.998 E.15746
G1 X194.026 Y159.002 E.06621
G1 X190.669 Y162.359 E.15748
G3 X189.859 Y163.169 I-3.501 J-2.69 E.03813
G1 X184.001 Y169.027 E.27479
G1 X186.703 Y169.027 E.08963
G1 X168.65 Y150.974 E.8469
G1 X171.35 Y150.974 E.08956
G1 X153.297 Y169.027 E.84689
G1 X148.323 Y169.027 E.165
G1 X145.973 Y166.677 E.11023
G2 X145.988 Y168.163 I9.131 J.652 E.04935
G2 X146.121 Y168.527 I1.394 J-.303 E.01289
G1 X163.674 Y150.974 E.82346
G1 X160.974 Y150.974 E.08958
G1 X179.027 Y169.027 E.84691
G1 X176.325 Y169.027 E.08963
G1 X183.851 Y161.501 E.35304
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X176.326 Y150.974 E.35298
G1 X179.026 Y150.974 E.08954
G1 X160.973 Y169.027 E.84688
G1 X163.675 Y169.027 E.08963
G1 X146.124 Y151.476 E.82337
G2 X145.975 Y151.952 I1.153 J.621 E.01665
G1 X145.975 Y153.321 E.04543
G1 X148.323 Y150.973 E.11016
G1 X149.951 Y150.973 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X148.951 Y150.973 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 10/28
; update layer progress
M73 L10
M991 S0 P9 ;notify layer change
G17
G3 Z2.2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.76 Y163.521
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F10674
G1 X186.625 Y163.493 E.00458
G3 X187.152 Y156.414 I.875 J-3.494 E.33447
G3 X187.672 Y156.402 I.357 J3.955 E.01727
G3 X186.972 Y163.562 I-.172 J3.598 E.38722
G1 X186.819 Y163.533 E.00514
M204 S250
G1 X186.837 Y163.137 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10674
M204 S5000
G1 X186.72 Y163.113 E.00366
G3 X187.187 Y156.805 I.78 J-3.113 E.27599
G3 X187.656 Y156.794 I.322 J3.569 E.01442
G3 X187.029 Y163.174 I-.156 J3.206 E.31956
G1 X186.896 Y163.148 E.00418
; WIPE_START
G1 F12000
M204 S10000
G1 X186.72 Y163.113 E-.06803
G1 X186.419 Y163.022 E-.1197
G1 X186.127 Y162.902 E-.11975
G1 X185.959 Y162.812 E-.07253
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.4 I-.637 J1.037 P1  F60000
G1 X194.393 Y167.997 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10674
G1 X194.393 Y168.077 E.00266
G3 X192.992 Y169.395 I-1.405 J-.089 E.07025
G1 X147.009 Y169.395 E1.52535
G3 X145.605 Y167.992 I-.003 J-1.401 E.07318
G1 X145.607 Y151.923 E.53304
G3 X147.008 Y150.605 I1.405 J.089 E.07025
M73 P68 R3
G1 X193.077 Y150.607 E1.52819
G3 X194.393 Y151.93 I-.083 J1.399 E.06775
G1 X194.393 Y167.937 E.53096
M204 S250
G1 X194.785 Y167.997 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10674
M204 S5000
G1 X194.785 Y168.092 E.00292
G3 X192.997 Y169.787 I-1.799 J-.107 E.08337
G1 X147.003 Y169.787 E1.41326
G3 X145.213 Y167.997 I.003 J-1.794 E.08638
G1 X145.215 Y151.908 E.49436
G3 X147.003 Y150.213 I1.799 J.107 E.08337
G1 X193.092 Y150.215 E1.41618
G3 X194.785 Y151.911 I-.1 J1.793 E.08062
G1 X194.785 Y167.937 E.49243
; WIPE_START
G1 F12000
M204 S10000
G1 X194.785 Y168.092 E-.0589
G1 X194.731 Y168.446 E-.13632
G1 X194.677 Y168.617 E-.06803
G1 X194.565 Y168.863 E-.10273
G1 X194.544 Y168.893 E-.01402
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.4 I.836 J-.884 P1  F60000
G1 X189.005 Y163.653 Z2.4
G1 Z2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10674
G1 X193.892 Y168.54 E.22929
G2 X194.045 Y168.055 I-1.471 J-.728 E.01695
G1 X194.045 Y166.659 E.04629
G1 X191.657 Y169.047 E.11203
G1 X190.028 Y169.047 E.05401
; WIPE_START
G1 F18423.913
G1 X191.028 Y169.047 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.4 I1.215 J-.067 P1  F60000
G1 X190.031 Y150.955 Z2.4
G1 Z2
G1 E.4 F1800
G1 F10674
G1 X191.659 Y150.955 E.05401
G1 X194.045 Y153.341 E.11191
G1 X194.045 Y151.956 E.04593
G2 X193.892 Y151.46 I-1.19 J.095 E.01736
G1 X189.005 Y156.347 E.22926
G1 X149.972 Y150.953 F60000
G1 F10674
G1 X148.343 Y150.953 E.05401
G1 X145.955 Y153.341 E.11203
G1 X145.955 Y151.945 E.0463
G3 X146.108 Y151.46 I1.623 J.243 E.01696
G1 X163.695 Y169.047 E.82506
G1 X160.953 Y169.047 E.09097
G1 X179.045 Y150.955 E.84876
G1 X176.306 Y150.954 E.09086
G1 X183.847 Y158.495 E.35376
G2 X183.847 Y161.505 I3.916 J1.505 E.1021
G1 X176.305 Y169.047 E.35383
G1 X179.047 Y169.047 E.09097
G1 X160.954 Y150.954 E.8488
G1 X163.694 Y150.954 E.09091
G1 X146.108 Y168.54 E.82501
G3 X145.953 Y167.979 I1.543 J-.729 E.01939
G1 X145.953 Y166.657 E.04387
G1 X148.343 Y169.047 E.11213
G1 X153.277 Y169.047 E.16366
G1 X171.37 Y150.954 E.84878
G1 X168.63 Y150.954 E.09089
G1 X186.723 Y169.047 E.84879
G1 X183.981 Y169.047 E.09097
G1 X189.88 Y163.148 E.27674
G2 X190.648 Y162.38 I-4.122 J-4.89 E.03607
G1 X194.045 Y158.983 E.15935
G1 X194.045 Y161.017 E.06746
G1 X190.648 Y157.62 E.15935
G2 X189.88 Y156.852 I-4.889 J4.121 E.03607
G1 X183.983 Y150.955 E.27665
G1 X186.721 Y150.955 E.09083
G1 X168.629 Y169.047 E.84874
G1 X171.371 Y169.047 E.09097
G1 X153.277 Y150.953 E.84882
G1 X156.019 Y150.953 E.09094
G1 X145.954 Y161.018 E.47216
G1 X145.954 Y158.982 E.06754
G1 X156.019 Y169.047 E.47217
G1 X157.648 Y169.047 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X156.648 Y169.047 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 11/28
; update layer progress
M73 L11
M991 S0 P10 ;notify layer change
G17
G3 Z2.4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.771 Y163.523
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F10604
G1 X186.625 Y163.493 E.00493
G3 X187.151 Y156.415 I.875 J-3.494 E.33444
G3 X187.672 Y156.402 I.358 J3.964 E.01728
G3 X186.972 Y163.562 I-.172 J3.598 E.38725
G1 X186.83 Y163.535 E.0048
M204 S250
G1 X186.847 Y163.139 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10604
M204 S5000
G1 X186.72 Y163.113 E.00398
G3 X187.187 Y156.805 I.78 J-3.113 E.27599
G3 X187.656 Y156.794 I.322 J3.572 E.01442
G3 X187.029 Y163.174 I-.156 J3.206 E.31957
G1 X186.906 Y163.151 E.00385
; WIPE_START
G1 F12000
M204 S10000
G1 X186.72 Y163.113 E-.07201
G1 X186.419 Y163.022 E-.1197
G1 X186.127 Y162.902 E-.11975
G1 X185.968 Y162.817 E-.06854
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.6 I-.638 J1.036 P1  F60000
G1 X194.394 Y168.009 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F10604
G1 X194.367 Y168.277 E.00893
G3 X192.992 Y169.395 I-1.373 J-.283 E.06364
G1 X147.008 Y169.395 E1.5254
G3 X145.605 Y167.992 I-.002 J-1.401 E.07313
G1 X145.607 Y151.923 E.53304
G3 X147.008 Y150.605 I1.396 J.079 E.07038
G1 X193.032 Y150.606 E1.52673
G3 X194.393 Y151.931 I-.034 J1.396 E.06928
G1 X194.395 Y167.949 E.53135
M204 S250
G1 X194.782 Y168.048 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F10604
M204 S5000
G1 X194.75 Y168.355 E.0095
G3 X192.997 Y169.788 I-1.758 J-.363 E.07527
G1 X147.003 Y169.788 E1.41329
G3 X145.212 Y167.997 I.004 J-1.794 E.08635
G1 X145.215 Y151.908 E.49437
G3 X147.003 Y150.212 I1.788 J.094 E.08351
M73 P69 R3
G1 X193.044 Y150.214 E1.41472
G3 X194.785 Y151.911 I-.046 J1.789 E.08214
G1 X194.788 Y167.988 E.49401
; WIPE_START
G1 F12000
M204 S10000
G1 X194.75 Y168.355 E-.14021
G1 X194.642 Y168.705 E-.13931
G1 X194.519 Y168.94 E-.10048
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.6 I-.029 J-1.217 P1  F60000
G1 X190.028 Y169.047 Z2.6
G1 Z2.2
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F10604
G1 X191.657 Y169.047 E.05401
G1 X194.045 Y166.658 E.11206
G3 X194.025 Y168.207 I-6.317 J.692 E.0515
G3 X193.892 Y168.54 I-1.145 J-.263 E.01195
G1 X189.005 Y163.653 E.22929
; WIPE_START
G1 F18423.913
G1 X189.712 Y164.36 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.6 I1.212 J-.107 P1  F60000
G1 X189.005 Y156.347 Z2.6
G1 Z2.2
G1 E.4 F1800
G1 F10604
G1 X193.892 Y151.46 E.22926
G3 X194.045 Y151.957 I-1.037 J.591 E.01737
G1 X194.045 Y153.341 E.04592
G1 X191.658 Y150.954 E.11198
G1 X190.029 Y150.954 E.05401
G1 X157.648 Y169.047 F60000
G1 F10604
G1 X156.019 Y169.047 E.05401
G1 X145.954 Y158.982 E.47218
G1 X145.954 Y161.018 E.06754
G1 X156.019 Y150.953 E.47218
G1 X153.277 Y150.953 E.09096
G1 X171.371 Y169.047 E.84884
G1 X168.629 Y169.047 E.09097
G1 X186.722 Y150.954 E.8488
G1 X183.982 Y150.954 E.09091
G1 X189.88 Y156.852 E.2767
G3 X190.648 Y157.62 I-4.12 J4.888 E.03607
G1 X194.045 Y161.017 E.15937
G1 X194.045 Y158.983 E.06748
G1 X190.648 Y162.38 E.15937
G3 X189.88 Y163.148 I-4.889 J-4.121 E.03607
G1 X183.981 Y169.047 E.27674
G1 X186.723 Y169.047 E.09097
G1 X168.629 Y150.953 E.84882
G1 X171.371 Y150.953 E.09093
G1 X153.277 Y169.047 E.84882
G1 X148.343 Y169.047 E.16365
G1 X145.953 Y166.657 E.11214
G2 X145.965 Y168.152 I10.117 J.663 E.04963
G2 X146.108 Y168.54 I1.097 J-.182 E.01381
G1 X163.695 Y150.953 E.82504
G1 X160.953 Y150.953 E.09095
G1 X179.047 Y169.047 E.84883
G1 X176.305 Y169.047 E.09097
G1 X183.847 Y161.505 E.35384
G3 X183.847 Y158.495 I3.917 J-1.505 E.1021
G1 X176.305 Y150.954 E.3538
G1 X179.046 Y150.954 E.09092
G1 X160.953 Y169.047 E.84881
G1 X163.695 Y169.047 E.09097
G1 X146.108 Y151.46 E.82507
G2 X145.955 Y151.946 I1.439 J.718 E.01699
G1 X145.955 Y153.341 E.04627
G1 X148.343 Y150.953 E.11204
G1 X149.972 Y150.953 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X148.972 Y150.953 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 12/28
; update layer progress
M73 L12
M991 S0 P11 ;notify layer change
G17
G3 Z2.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.781 Y163.525
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
G1 F18000
G1 X186.626 Y163.492 E.00528
G3 X187.39 Y156.4 I.882 J-3.492 E.34184
G3 X187.853 Y156.415 I.109 J3.865 E.01537
G3 X186.972 Y163.561 I-.345 J3.585 E.38169
G1 X186.84 Y163.536 E.00445
M204 S250
G1 X186.857 Y163.141 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.721 Y163.111 E.0043
G3 X187.407 Y156.792 I.787 J-3.111 E.28228
G3 X187.815 Y156.805 I.093 J3.44 E.01255
G3 X187.029 Y163.173 I-.307 J3.195 E.31509
G1 X186.916 Y163.152 E.00353
; WIPE_START
M204 S10000
G1 X186.721 Y163.111 E-.07597
G1 X186.419 Y163.022 E-.11969
G1 X186.127 Y162.902 E-.11972
G1 X185.977 Y162.822 E-.06462
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.8 I-.64 J1.035 P1  F60000
G1 X194.373 Y168.011 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X194.344 Y168.286 E.00918
G3 X192.992 Y169.375 I-1.351 J-.293 E.06226
G1 X147.008 Y169.375 E1.5254
G3 X145.625 Y167.992 I.007 J-1.39 E.07195
G1 X145.625 Y152.008 E.53025
G3 X147.008 Y150.625 I1.382 J-.001 E.07207
G1 X193.07 Y150.627 E1.52798
G3 X194.375 Y152.008 I-.078 J1.381 E.06948
G1 X194.375 Y167.951 E.52886
M204 S250
G1 X194.762 Y168.052 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X194.727 Y168.368 E.00978
G3 X192.997 Y169.767 I-1.734 J-.375 E.0739
G1 X147.003 Y169.767 E1.41329
G3 X145.233 Y167.997 I.015 J-1.785 E.08525
G1 X145.233 Y152.003 E.49147
G3 X147.003 Y150.233 I1.774 J.004 E.08538
G1 X193.091 Y150.235 E1.41615
G3 X194.767 Y152.003 I-.1 J1.774 E.0825
G1 X194.767 Y167.992 E.49131
; WIPE_START
M204 S10000
G1 X194.727 Y168.368 E-.14374
G1 X194.61 Y168.727 E-.14349
G1 X194.486 Y168.937 E-.09277
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.8 I.845 J-.876 P1  F60000
G1 X189.001 Y163.649 Z2.8
G1 Z2.4
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G1 X193.587 Y168.236 E.21514
G2 X193.638 Y168.028 I-.332 J-.19 E.00719
G1 X193.638 Y167.066 E.03191
G1 X192.063 Y168.641 E.0739
G1 X190.434 Y168.641 E.05401
; WIPE_START
G1 X191.434 Y168.641 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z2.8 I1.215 J-.07 P1  F60000
G1 X190.435 Y151.36 Z2.8
G1 Z2.4
G1 E.4 F1800
G1 F18423.913
G1 X192.063 Y151.36 E.05401
G1 X193.641 Y152.937 E.074
G2 X193.591 Y151.761 I-3.7 J-.433 E.03922
G1 X189.001 Y156.351 E.21532
G1 X193.91 Y151.589 F60000
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F3000;_EXTRUDE_SET_SPEED
G1 X194.008 Y152.03 E.01251
G1 X194.006 Y168.041 E.44358
G3 X193.366 Y168.934 I-1.026 J-.059 E.03213
G1 X192.969 Y169.008 E.01117
G1 X147.028 Y169.008 E1.27283
M73 P70 R3
G1 X146.577 Y168.906 E.01281
G1 X146.318 Y168.73 E.00867
G1 X146.07 Y168.374 E.01201
G1 X145.992 Y167.969 E.01143
G1 X145.993 Y152.032 E.44156
G3 X146.11 Y151.547 I1.073 J.004 E.01395
G1 X146.366 Y151.227 E.01135
G1 X146.634 Y151.066 E.00867
G1 X147.031 Y150.992 E.01117
G1 X192.988 Y150.993 E1.27327
G1 X193.369 Y151.071 E.01078
G1 X193.677 Y151.268 E.01012
G1 X193.875 Y151.541 E.00935
; Slow Down End
G1 X149.566 Y151.359 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G1 X147.937 Y151.359 E.05401
G1 X146.359 Y152.937 E.07404
G3 X146.412 Y151.764 I2.799 J-.462 E.03925
G1 X163.289 Y168.641 E.79175
G1 X161.359 Y168.641 E.06403
G1 X178.641 Y151.359 E.81071
G1 X176.711 Y151.359 E.064
G1 X183.851 Y158.499 E.33492
G2 X183.851 Y161.501 I3.649 J1.501 E.10218
G1 X176.711 Y168.641 E.33494
G1 X178.641 Y168.641 E.06403
G1 X161.359 Y151.359 E.81073
G1 X163.289 Y151.359 E.06401
G1 X146.413 Y168.236 E.7917
G3 X146.359 Y167.063 I2.649 J-.709 E.03925
G1 X147.937 Y168.641 E.07404
G1 X153.683 Y168.641 E.1906
G1 X170.965 Y151.359 E.81072
G1 X169.035 Y151.359 E.064
G1 X186.317 Y168.641 E.81072
G1 X184.387 Y168.641 E.06403
G1 X189.859 Y163.169 E.25669
G2 X193.64 Y159.388 I-64.249 J-68.03 E.1774
G1 X193.639 Y160.611 E.04057
G1 X190.669 Y157.641 E.13933
G2 X189.858 Y156.831 I-3.501 J2.69 E.03814
G1 X184.387 Y151.36 E.25666
G1 X186.316 Y151.36 E.06399
G1 X169.035 Y168.641 E.81071
G1 X170.965 Y168.641 E.06403
G1 X153.683 Y151.359 E.81073
G1 X155.613 Y151.359 E.06402
G1 X146.359 Y160.613 E.43413
G1 X146.359 Y159.387 E.04068
G1 X155.613 Y168.641 E.43413
G1 X157.241 Y168.641 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X156.241 Y168.641 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 13/28
; update layer progress
M73 L13
M991 S0 P12 ;notify layer change
G17
G3 Z2.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.792 Y163.528
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
G1 F11995
G1 X186.626 Y163.492 E.00566
G3 X187.383 Y156.401 I.882 J-3.492 E.34162
G3 X187.853 Y156.415 I.116 J3.876 E.01563
G3 X186.972 Y163.561 I-.346 J3.585 E.38166
G1 X186.851 Y163.539 E.00406
M204 S250
G1 X186.868 Y163.147 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F11995
M204 S5000
G1 X186.569 Y163.068 E.0095
G3 X187.399 Y156.792 I.942 J-3.068 E.277
G3 X187.658 Y156.794 I.115 J2.64 E.00794
G3 X186.927 Y163.156 I-.146 J3.206 E.32337
; WIPE_START
G1 F12000
M204 S10000
G1 X186.569 Y163.068 E-.14002
G1 X186.271 Y162.966 E-.11968
G1 X185.987 Y162.831 E-.11964
G1 X185.985 Y162.83 E-.00066
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3 I-.642 J1.034 P1  F60000
G1 X194.333 Y168.01 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11995
G1 X194.312 Y168.236 E.00753
G3 X192.992 Y169.334 I-1.319 J-.243 E.06181
G1 X147.011 Y169.334 E1.52527
G3 X145.666 Y167.992 I-.008 J-1.338 E.07011
G1 X145.666 Y152.008 E.53024
G3 X147.008 Y150.666 I1.342 J-.001 E.06994
G1 X193.07 Y150.668 E1.52796
G3 X194.334 Y152.008 I-.086 J1.348 E.06727
G1 X194.334 Y167.95 E.52883
M204 S250
G1 X194.722 Y168.045 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F11995
M204 S5000
G1 X194.698 Y168.303 E.00798
G3 X192.997 Y169.726 I-1.706 J-.31 E.07395
G1 X147.004 Y169.726 E1.41324
G3 X145.274 Y167.997 I-.001 J-1.73 E.08349
G1 X145.274 Y152.003 E.49146
G3 X147.003 Y150.274 I1.734 J.004 E.08341
G1 X193.091 Y150.276 E1.41617
G3 X194.726 Y152.003 I-.111 J1.743 E.08038
G1 X194.726 Y167.985 E.49108
; WIPE_START
G1 F12000
M204 S10000
G1 X194.698 Y168.303 E-.12143
M73 P71 R3
G1 X194.596 Y168.657 E-.13993
G1 X194.459 Y168.922 E-.1135
G1 X194.45 Y168.933 E-.00514
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3 I.138 J-1.209 P1  F60000
G1 X190.585 Y168.49 Z3
G1 Z2.6
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F11995
G1 X192.213 Y168.49 E.05401
G1 X193.488 Y167.216 E.05979
G1 X193.466 Y168.114 E.0298
G1 X189.001 Y163.649 E.20944
; WIPE_START
G1 F18423.913
G1 X189.708 Y164.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3 I1.212 J-.107 P1  F60000
G1 X189.001 Y156.351 Z3
G1 Z2.6
G1 E.4 F1800
G1 F11995
G1 X193.471 Y151.881 E.20967
G3 X193.49 Y152.786 I-3.122 J.52 E.03014
G1 X192.216 Y151.512 E.05979
G1 X190.587 Y151.512 E.05401
G1 X193.912 Y152.031 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.480109
G1 F11995
G1 X193.82 Y151.617 E.01512
G1 X193.605 Y151.33 E.01276
G1 X193.261 Y151.138 E.01403
G1 X193.029 Y151.09 E.00844
G1 X147.035 Y151.088 E1.63857
G1 X146.669 Y151.158 E.01325
G1 X146.409 Y151.321 E.01093
G1 X146.158 Y151.666 E.01521
G1 X146.09 Y151.967 E.01098
G1 X146.088 Y167.965 E.56997
G1 X146.159 Y168.33 E.01323
G2 X147.036 Y168.912 I.875 J-.366 E.03975
G1 X192.965 Y168.912 E1.63626
G1 X193.331 Y168.842 E.01326
G1 X193.591 Y168.679 E.01093
G1 X193.826 Y168.368 E.0139
G1 X193.91 Y168.035 E.01224
G1 X193.912 Y152.091 E.568
G1 X157.091 Y168.49 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F11995
G1 X155.462 Y168.49 E.05401
G1 X146.511 Y159.539 E.41994
G1 X146.511 Y160.461 E.0306
G1 X155.462 Y151.51 E.41992
G1 X153.834 Y151.51 E.05401
G1 X170.814 Y168.49 E.79658
G1 X169.186 Y168.49 E.05403
G1 X186.164 Y151.512 E.79651
G1 X184.539 Y151.511 E.05391
G1 X189.859 Y156.831 E.24953
G3 X193.489 Y160.461 I-61.29 J64.92 E.17034
G1 X193.489 Y159.539 E.0306
G1 X190.669 Y162.359 E.13228
G3 X189.859 Y163.169 I-3.502 J-2.691 E.03814
G1 X184.538 Y168.49 E.24963
G1 X186.166 Y168.49 E.05403
G1 X169.187 Y151.511 E.79655
G1 X170.813 Y151.511 E.05396
G1 X153.834 Y168.49 E.79655
G1 X147.787 Y168.49 E.20059
G1 X146.51 Y167.214 E.0599
G2 X146.534 Y168.114 I2.908 J.372 E.03
G1 X163.138 Y151.51 E.77891
G1 X161.51 Y151.51 E.05398
G1 X178.49 Y168.49 E.79657
G1 X176.862 Y168.49 E.05403
G1 X183.851 Y161.501 E.32787
G3 X183.851 Y158.499 I3.649 J-1.501 E.10218
G1 X176.863 Y151.511 E.3278
G1 X178.489 Y151.511 E.05393
G1 X161.51 Y168.49 E.79653
G1 X163.138 Y168.49 E.05403
G1 X146.534 Y151.886 E.77894
G1 X146.512 Y152.784 E.0298
G1 X147.787 Y151.51 E.05979
G1 X149.415 Y151.51 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 2.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X148.415 Y151.51 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 14/28
; update layer progress
M73 L14
M991 S0 P13 ;notify layer change
G17
G3 Z3 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.821 Y163.536
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
G1 F11816
G1 X186.798 Y163.53 E.00079
G3 X187.375 Y156.401 I.713 J-3.53 E.34702
G3 X187.677 Y156.402 I.138 J3.087 E.01001
G3 X187.147 Y163.583 I-.166 J3.598 E.38194
G1 X186.88 Y163.545 E.00894
M204 S250
G1 X186.878 Y163.149 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F11816
M204 S5000
G1 X186.874 Y163.146 E.00015
G3 X187.392 Y156.793 I.636 J-3.146 E.28652
G3 X187.658 Y156.794 I.121 J2.719 E.00817
G3 X187.185 Y163.193 I-.147 J3.206 E.31529
G1 X186.938 Y163.158 E.00769
; WIPE_START
G1 F12000
M204 S10000
G1 X186.874 Y163.146 E-.02448
G1 X186.568 Y163.072 E-.11967
G1 X186.272 Y162.966 E-.11966
G1 X185.995 Y162.835 E-.11619
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.2 I-.645 J1.032 P1  F60000
G1 X194.27 Y168.008 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F11816
G1 X194.248 Y168.242 E.00782
G3 X192.992 Y169.271 I-1.25 J-.245 E.0584
G1 X147.008 Y169.271 E1.52536
G3 X145.729 Y167.992 I-.006 J-1.274 E.06676
G1 X145.729 Y152.008 E.5302
G3 X147.008 Y150.729 I1.273 J-.006 E.06676
G1 X193.07 Y150.731 E1.52795
G3 X194.269 Y151.93 I-.077 J1.276 E.06148
G1 X194.271 Y167.948 E.53134
M204 S250
G1 X194.659 Y168.045 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F11816
M204 S5000
G1 X194.633 Y168.315 E.00832
G3 X192.997 Y169.663 I-1.635 J-.317 E.07062
G1 X147.003 Y169.663 E1.41327
G3 X145.337 Y167.997 I-.001 J-1.666 E.08044
G1 X145.337 Y152.003 E.49145
G3 X147.003 Y150.337 I1.666 J-.001 E.08044
G1 X193.086 Y150.339 E1.41601
G3 X194.661 Y151.913 I-.096 J1.671 E.07485
G1 X194.663 Y167.985 E.49384
; WIPE_START
G1 F12000
M204 S10000
G1 X194.633 Y168.315 E-.12572
G1 X194.559 Y168.58 E-.10457
G1 X194.382 Y168.926 E-.14765
G1 X194.378 Y168.93 E-.00206
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.2 I.853 J-.868 P1  F60000
G1 X189.001 Y163.649 Z3.2
G1 Z2.8
G1 E.4 F1800
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F11816
G1 X193.292 Y167.94 E.20126
G1 X193.292 Y167.412 E.0175
G1 X192.41 Y168.294 E.04135
G1 X190.782 Y168.294 E.05401
; WIPE_START
G1 F18423.913
G1 X191.782 Y168.294 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.2 I1.215 J-.073 P1  F60000
G1 X190.784 Y151.708 Z3.2
G1 Z2.8
G1 E.4 F1800
G1 F11816
G1 X192.412 Y151.708 E.05401
G1 X193.294 Y152.59 E.04135
G1 X193.294 Y152.058 E.01763
G1 X189.001 Y156.351 E.20136
G1 X193.78 Y151.979 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.61332
G1 F11816
G1 X193.655 Y151.592 E.01892
G1 X193.446 Y151.37 E.01415
M73 P72 R3
G1 X193.097 Y151.233 E.01741
G1 X193.021 Y151.22 E.0036
G1 X147.03 Y151.217 E2.1377
G1 X146.686 Y151.295 E.01636
G1 X146.376 Y151.536 E.01826
G1 X146.227 Y151.93 E.01958
G1 X146.22 Y151.989 E.00275
G1 X146.218 Y167.958 E.74223
G1 X146.291 Y168.311 E.01675
G1 X146.542 Y168.627 E.01877
G1 X146.846 Y168.758 E.01537
G1 X147.035 Y168.782 E.00886
G1 X192.97 Y168.782 E2.1351
G1 X193.269 Y168.723 E.01415
G1 X193.588 Y168.499 E.0181
G2 X193.78 Y168.011 I-.741 J-.575 E.02473
G1 X193.781 Y152.039 E.74239
G1 X149.218 Y151.706 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F11816
G1 X147.59 Y151.706 E.05401
G1 X146.708 Y152.588 E.04135
G1 X146.708 Y152.06 E.0175
G1 X162.942 Y168.294 E.76154
G1 X161.706 Y168.294 E.04098
G1 X178.292 Y151.708 E.77808
G1 X177.06 Y151.708 E.04089
G1 X183.851 Y158.499 E.31858
G2 X183.851 Y161.501 I3.649 J1.501 E.10218
G1 X177.058 Y168.294 E.31864
G1 X178.294 Y168.294 E.04098
G1 X161.707 Y151.707 E.77812
G1 X162.941 Y151.707 E.04094
G1 X146.706 Y167.942 E.7616
G1 X146.706 Y167.41 E.01763
G1 X147.59 Y168.294 E.04145
G1 X154.03 Y168.294 E.21364
G1 X170.617 Y151.707 E.7781
G1 X169.383 Y151.707 E.04091
G1 X185.97 Y168.294 E.7781
G1 X184.734 Y168.294 E.04098
G1 X189.859 Y163.169 E.2404
G2 X193.293 Y159.735 I-57.348 J-60.782 E.16112
G1 X193.293 Y160.265 E.01757
G1 X190.669 Y157.642 E.12306
G2 X189.858 Y156.831 I-3.503 J2.692 E.03815
G1 X184.736 Y151.708 E.24031
G1 X185.968 Y151.708 E.04086
G1 X169.382 Y168.294 E.77806
G1 X170.618 Y168.294 E.04098
G1 X154.031 Y151.707 E.77813
G1 X155.265 Y151.707 E.04096
G1 X146.707 Y160.265 E.40148
G1 X146.707 Y159.735 E.01757
G1 X155.266 Y168.294 E.40149
G1 X156.894 Y168.294 E.05401
; CHANGE_LAYER
; Z_HEIGHT: 3
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X155.894 Y168.294 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 15/28
; update layer progress
M73 L15
M991 S0 P14 ;notify layer change
G17
G3 Z3.2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.831 Y163.538
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
G1 F18000
G1 X186.798 Y163.531 E.00112
G3 X187.367 Y156.401 I.712 J-3.531 E.34685
G3 X187.677 Y156.402 I.144 J3.162 E.01027
G3 X187.147 Y163.583 I-.167 J3.598 E.38187
G1 X186.89 Y163.546 E.00861
M204 S250
G1 X186.888 Y163.15 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.875 Y163.143 E.00047
G3 X187.384 Y156.793 I.634 J-3.145 E.28622
G3 X187.658 Y156.794 I.126 J2.792 E.00841
G3 X187.186 Y163.19 I-.149 J3.204 E.31505
G1 X186.948 Y163.158 E.00738
; WIPE_START
M204 S10000
G1 X186.875 Y163.143 E-.02823
G1 X186.568 Y163.072 E-.11963
G1 X186.272 Y162.966 E-.11968
G1 X186.004 Y162.839 E-.11246
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.4 I-.65 J1.029 P1  F60000
G1 X194.183 Y168.004 Z3.4
G1 Z3
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X194.163 Y168.223 E.00729
G3 X192.991 Y169.184 I-1.164 J-.224 E.05455
G1 X147.009 Y169.184 E1.52528
G3 X145.816 Y167.991 I-.008 J-1.185 E.06229
G1 X145.816 Y152.009 E.53013
G3 X147.009 Y150.816 I1.185 J-.008 E.06229
G1 X193.049 Y150.818 E1.52723
G3 X194.182 Y151.951 I-.054 J1.186 E.0583
G1 X194.184 Y167.944 E.53052
M204 S250
G1 X194.572 Y168.04 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X194.547 Y168.298 E.00797
G3 X192.997 Y169.576 I-1.549 J-.299 E.06695
G1 X147.003 Y169.576 E1.41324
G3 X145.424 Y167.997 I-.002 J-1.577 E.07626
G1 X145.424 Y152.003 E.49143
G3 X147.003 Y150.424 I1.577 J-.002 E.07625
G1 X193.064 Y150.426 E1.41533
G3 X194.574 Y151.936 I-.072 J1.581 E.07199
G1 X194.576 Y167.98 E.493
; WIPE_START
M204 S10000
G1 X194.547 Y168.298 E-.12129
G1 X194.476 Y168.549 E-.09933
G1 X194.315 Y168.869 E-.13591
G1 X194.276 Y168.916 E-.02347
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.4 I1.163 J-.359 P1  F60000
G1 X191.46 Y159.806 Z3.4
G1 Z3
G1 E.4 F1800
; Slow Down Start
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.38292
G1 F3000;_EXTRUDE_SET_SPEED
G3 X191.419 Y160.597 I-13.817 J-.329 E.02196
G1 X191.227 Y161.35 E.02153
G1 X190.892 Y162.051 E.02153
G1 X190.426 Y162.674 E.02153
G1 X189.849 Y163.193 E.02153
G1 X189.181 Y163.59 E.02153
G1 X188.448 Y163.849 E.02152
G1 X187.679 Y163.96 E.02154
G1 X186.903 Y163.919 E.02152
G1 X186.15 Y163.727 E.02153
G1 X185.449 Y163.392 E.02153
G1 X184.826 Y162.927 E.02154
G1 X184.307 Y162.349 E.02153
G1 X183.91 Y161.681 E.02153
G1 X183.651 Y160.948 E.02152
G1 X183.54 Y160.179 E.02153
G1 X183.581 Y159.403 E.02152
G1 X183.773 Y158.65 E.02153
G1 X184.108 Y157.949 E.02153
G1 X184.573 Y157.326 E.02153
G1 X185.151 Y156.807 E.02153
G1 X185.819 Y156.41 E.02153
G1 X186.553 Y156.151 E.02155
G1 X187.367 Y156.039 E.02276
G1 X188.097 Y156.081 E.02026
G1 X188.85 Y156.273 E.02153
G1 X189.551 Y156.608 E.02153
G1 X190.174 Y157.073 E.02153
G1 X190.693 Y157.651 E.02153
G1 X191.09 Y158.319 E.02153
G1 X191.349 Y159.052 E.02152
G1 X191.452 Y159.746 E.01945
; Slow Down End
G1 X190.758 Y157.155 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G3 X191.578 Y158.55 I-3.453 J2.968 E.05398
G1 X193.024 Y160.003 E.06801
G1 X191.578 Y161.45 E.06786
G3 X190.758 Y162.845 I-4.272 J-1.572 E.05398
; WIPE_START
G1 X191.213 Y162.225 E-.29217
G1 X191.311 Y162.016 E-.08783
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.4 I1.217 J-.031 P1  F60000
G1 X191.053 Y151.978 Z3.4
G1 Z3
G1 E.4 F1800
G1 F18423.913
G1 X192.682 Y151.978 E.05401
G1 X193.024 Y152.327 E.01625
G1 X189.29 Y156.062 E.17519
G2 X188.95 Y155.922 I-.88 J1.656 E.01222
G1 X185.005 Y151.977 E.18505
G1 X185.699 Y151.977 E.023
G1 X169.651 Y168.024 E.7528
G1 X170.349 Y168.024 E.02312
G1 X154.3 Y151.976 E.75287
G1 X154.996 Y151.976 E.0231
G1 X146.976 Y159.997 E.37627
G1 X154.997 Y168.024 E.37645
G1 X154.3 Y168.024 E.02312
G1 X170.347 Y151.977 E.75284
G1 X169.653 Y151.977 E.02305
G1 X185.7 Y168.024 E.75284
G1 X185.003 Y168.024 E.02312
M73 P72 R2
G1 X188.95 Y164.078 E.18513
M73 P73 R2
G2 X189.29 Y163.938 I-.535 J-1.783 E.01222
G1 X193.024 Y167.673 E.17519
G1 X192.679 Y168.024 E.01635
G1 X191.051 Y168.024 E.05401
G1 X193.79 Y152.009 F60000
; FEATURE: Floating vertical shell
; LINE_WIDTH: 0.419083
G1 F12000
G1 X193.689 Y151.641 E.01171
G1 X193.521 Y151.417 E.0086
G1 X193.295 Y151.28 E.0081
G1 X192.991 Y151.21 E.00957
G1 X147.054 Y151.208 E1.40808
G1 X146.668 Y151.292 E.0121
G1 X146.421 Y151.476 E.00945
G1 X146.257 Y151.748 E.00975
G1 X146.21 Y152.04 E.00905
G1 X146.208 Y167.973 E.48839
G1 X146.297 Y168.324 E.01112
G1 X146.436 Y168.531 E.00764
G1 X146.707 Y168.725 E.01019
G1 X147.041 Y168.792 E.01046
G1 X192.964 Y168.792 E1.40764
G1 X193.353 Y168.698 E.01227
G1 X193.579 Y168.524 E.00875
G1 X193.746 Y168.242 E.01004
G1 X193.79 Y167.96 E.00874
G1 X193.79 Y152.069 E.4871
G1 X193.415 Y152.028 F60000
; Slow Down Start
; LINE_WIDTH: 0.419249
G1 F3000;_EXTRUDE_SET_SPEED
G1 X193.415 Y167.96 E.48857
G1 X193.37 Y168.165 E.00643
G1 X193.225 Y168.341 E.00699
G1 X192.946 Y168.415 E.00886
G1 X147.041 Y168.416 E1.40772
G1 X146.79 Y168.343 E.00801
G1 X146.649 Y168.197 E.00624
G1 X146.585 Y167.964 E.0074
G1 X146.585 Y152.04 E.48835
G3 X146.734 Y151.69 I.482 J-.001 E.012
G1 X147.054 Y151.584 E.01032
G1 X192.991 Y151.586 E1.4087
G1 X193.256 Y151.685 E.00868
G3 X193.397 Y151.971 I-.378 J.365 E.00993
; Slow Down End
G1 X148.949 Y151.976 F60000
; FEATURE: Sparse infill
; LINE_WIDTH: 0.45
G1 F18423.913
G1 X147.321 Y151.976 E.05401
G1 X146.976 Y152.327 E.01635
G1 X162.673 Y168.024 E.73638
G1 X161.976 Y168.024 E.02312
G1 X178.023 Y151.977 E.75282
G1 X177.329 Y151.977 E.02302
G1 X183.562 Y158.21 E.2924
G2 X183.562 Y161.79 I3.966 J1.79 E.12239
G1 X177.327 Y168.024 E.29247
G1 X178.024 Y168.024 E.02312
G1 X161.976 Y151.976 E.75286
G1 X162.672 Y151.976 E.02307
G1 X146.976 Y167.673 E.73635
G1 X147.321 Y168.024 E.01635
G1 X148.949 Y168.024 E.05401
M106 S255
; CHANGE_LAYER
; Z_HEIGHT: 3.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F18423.913
G1 X147.949 Y168.024 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 16/28
; update layer progress
M73 L16
M991 S0 P15 ;notify layer change
M106 S255
G17
G3 Z3.4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.84 Y163.539
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
G1 F18000
G1 X186.798 Y163.527 E.00144
G3 X187.359 Y156.401 I.71 J-3.529 E.34651
G3 X187.677 Y156.402 I.15 J3.247 E.01054
G3 X187.147 Y163.58 I-.169 J3.596 E.38155
G1 X186.9 Y163.547 E.00829
M204 S250
G1 X186.898 Y163.152 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.875 Y163.143 E.00075
G3 X187.377 Y156.793 I.633 J-3.145 E.28607
G3 X187.658 Y156.794 I.132 J2.87 E.00864
G3 X187.186 Y163.19 I-.15 J3.204 E.31497
G1 X186.957 Y163.16 E.00709
; WIPE_START
M204 S10000
G1 X186.875 Y163.143 E-.03189
G1 X186.568 Y163.072 E-.11962
G1 X186.271 Y162.966 E-.11976
G1 X186.013 Y162.843 E-.10873
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.6 I-.656 J1.025 P1  F60000
G1 X194.068 Y167.994 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X194.044 Y168.22 E.00753
G3 X192.989 Y169.069 I-1.052 J-.228 E.0486
G1 X147.011 Y169.069 E1.52515
G3 X145.931 Y167.989 I-.009 J-1.071 E.0564
G1 X145.931 Y152.011 E.52999
G3 X147.011 Y150.931 I1.076 J-.004 E.05633
G1 X193.004 Y150.932 E1.52566
G3 X194.069 Y152.011 I-.011 J1.076 E.0558
G1 X194.069 Y167.934 E.52819
M204 S250
G1 X194.457 Y168.033 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X194.428 Y168.301 E.00827
G3 X192.996 Y169.461 I-1.437 J-.31 E.06118
G1 X147.004 Y169.461 E1.41321
G3 X145.539 Y167.996 I-.001 J-1.463 E.07071
G1 X145.539 Y152.004 E.49139
G3 X147.004 Y150.539 I1.47 J.006 E.07062
G1 X193.017 Y150.54 E1.41385
G3 X194.461 Y152.004 I-.027 J1.47 E.06996
G1 X194.461 Y167.973 E.4907
; WIPE_START
M204 S10000
G1 X194.428 Y168.301 E-.12499
G1 X194.333 Y168.596 E-.11783
G1 X194.173 Y168.871 E-.12079
G1 X194.144 Y168.903 E-.01639
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.6 I1.213 J-.095 P1  F60000
G1 X192.753 Y151.122 Z3.6
G1 Z3.2
G1 E.4 F1800
; FEATURE: Bridge
; LINE_WIDTH: 0.40225
; LAYER_HEIGHT: 0.4
G1 F3000
M73 P74 R2
G1 X193.678 Y152.047 E.06777
G1 X193.678 Y152.687 E.03312
G1 X192.316 Y151.324 E.09977
G1 X191.676 Y151.324 E.03312
G1 X193.678 Y153.326 E.14661
G1 X193.678 Y153.966 E.03312
G1 X191.036 Y151.324 E.19344
G1 X190.397 Y151.324 E.03312
G1 X193.678 Y154.605 E.24028
G1 X193.678 Y155.245 E.03312
G1 X189.757 Y151.324 E.28712
G1 X189.118 Y151.324 E.03312
G1 X193.678 Y155.884 E.33395
G1 X193.678 Y156.524 E.03312
G1 X188.478 Y151.324 E.38079
G1 X187.838 Y151.324 E.03312
G1 X193.678 Y157.164 E.42762
G1 X193.678 Y157.803 E.03312
G1 X187.199 Y151.324 E.47446
G1 X186.559 Y151.324 E.03312
G1 X193.678 Y158.443 E.52129
G1 X193.678 Y159.082 E.03312
G1 X185.92 Y151.324 E.56813
G1 X185.28 Y151.324 E.03312
G1 X193.678 Y159.722 E.61496
G1 X193.678 Y160.362 E.03312
G1 X184.64 Y151.324 E.6618
G1 X184.001 Y151.324 E.03312
G1 X189.007 Y156.33 E.36655
G3 X191.17 Y158.493 I-1.486 J3.65 E.16273
G1 X193.678 Y161.001 E.18363
G1 X193.678 Y161.641 E.03312
G1 X191.423 Y159.386 E.16512
G3 X191.468 Y160.07 I-4.832 J.658 E.03552
G1 X193.678 Y162.28 E.16187
G1 X193.678 Y162.92 E.03312
G1 X191.415 Y160.656 E.16574
G3 X191.291 Y161.172 I-2.677 J-.372 E.0275
G1 X193.678 Y163.559 E.17483
G1 X193.678 Y164.199 E.03312
G1 X191.116 Y161.637 E.18759
G3 X190.897 Y162.057 I-6.439 J-3.093 E.02455
G1 X193.678 Y164.839 E.20365
G1 X193.678 Y165.478 E.03312
G1 X190.635 Y162.435 E.22286
G3 X190.336 Y162.775 I-2.233 J-1.657 E.02349
G1 X193.678 Y166.118 E.24475
G1 X193.678 Y166.757 E.03312
G1 X190.001 Y163.08 E.26926
G3 X189.63 Y163.349 I-1.827 J-2.135 E.02374
G1 X193.678 Y167.397 E.29643
G3 X193.675 Y168.022 I-4.192 J.29 E.03239
G1 X189.221 Y163.579 E.32574
G3 X188.765 Y163.763 I-2.571 J-5.734 E.02546
G1 X193.475 Y168.473 E.34494
G3 X193.035 Y168.673 I-.476 J-.464 E.0256
G1 X188.257 Y163.895 E.34988
G3 X187.691 Y163.968 I-1.028 J-5.748 E.02959
G1 X192.401 Y168.678 E.34493
G1 X191.762 Y168.678 E.03312
G1 X187.023 Y163.94 E.34696
G3 X186.545 Y163.856 I1.115 J-7.804 E.02516
G1 X186.194 Y163.75 E.01899
G1 X191.122 Y168.678 E.36087
G1 X190.482 Y168.678 E.03312
G1 X173.127 Y151.323 E1.27082
G1 X172.488 Y151.323 E.03312
G1 X189.843 Y168.678 E1.27083
G1 X189.203 Y168.678 E.03312
G1 X171.848 Y151.323 E1.27083
G1 X171.209 Y151.323 E.03312
G1 X188.564 Y168.678 E1.27083
G1 X187.924 Y168.678 E.03312
G1 X170.569 Y151.323 E1.27083
G1 X169.929 Y151.323 E.03312
G1 X187.285 Y168.678 E1.27083
G1 X186.645 Y168.678 E.03312
M73 P75 R2
G1 X169.29 Y151.323 E1.27084
G1 X168.65 Y151.323 E.03312
G1 X186.005 Y168.678 E1.27084
G1 X185.366 Y168.678 E.03312
G1 X168.01 Y151.323 E1.27084
G1 X167.371 Y151.323 E.03312
G1 X184.726 Y168.678 E1.27084
G1 X184.087 Y168.678 E.03312
G1 X166.731 Y151.323 E1.27085
G1 X166.092 Y151.323 E.03312
G1 X183.447 Y168.678 E1.27085
G1 X182.808 Y168.678 E.03312
G1 X165.452 Y151.323 E1.27085
G1 X164.812 Y151.323 E.03312
G1 X182.168 Y168.678 E1.27085
G1 X181.528 Y168.678 E.03312
G1 X164.173 Y151.323 E1.27086
G1 X163.533 Y151.323 E.03312
G1 X180.889 Y168.678 E1.27086
G1 X180.249 Y168.678 E.03312
G1 X162.894 Y151.323 E1.27086
G1 X162.254 Y151.323 E.03312
G1 X179.61 Y168.678 E1.27086
G1 X178.97 Y168.678 E.03312
G1 X161.614 Y151.323 E1.27086
G1 X160.975 Y151.322 E.03312
M73 P76 R2
G1 X178.331 Y168.678 E1.27087
G1 X177.691 Y168.678 E.03312
G1 X160.335 Y151.322 E1.27087
G1 X159.696 Y151.322 E.03312
G1 X177.051 Y168.678 E1.27087
G1 X176.412 Y168.678 E.03312
G1 X159.056 Y151.322 E1.27087
G1 X158.416 Y151.322 E.03312
G1 X175.772 Y168.678 E1.27088
G1 X175.133 Y168.678 E.03312
G1 X157.777 Y151.322 E1.27088
G1 X157.137 Y151.322 E.03312
G1 X174.493 Y168.678 E1.27088
G1 X173.853 Y168.678 E.03312
G1 X156.498 Y151.322 E1.27088
G1 X155.858 Y151.322 E.03312
G1 X173.214 Y168.678 E1.27089
G1 X172.574 Y168.678 E.03312
G1 X155.218 Y151.322 E1.27089
G1 X154.579 Y151.322 E.03312
G1 X171.935 Y168.678 E1.27089
G1 X171.295 Y168.678 E.03312
G1 X153.939 Y151.322 E1.27089
G1 X153.299 Y151.322 E.03312
G1 X170.656 Y168.678 E1.27089
G1 X170.016 Y168.678 E.03312
M73 P77 R2
G1 X152.66 Y151.322 E1.2709
G1 X152.02 Y151.322 E.03312
G1 X169.376 Y168.678 E1.2709
G1 X168.737 Y168.678 E.03312
G1 X151.381 Y151.322 E1.2709
G1 X150.741 Y151.322 E.03312
G1 X168.097 Y168.678 E1.2709
G1 X167.458 Y168.678 E.03312
G1 X150.101 Y151.322 E1.27091
G1 X149.462 Y151.322 E.03312
G1 X166.818 Y168.678 E1.27091
G1 X166.179 Y168.678 E.03312
G1 X148.822 Y151.322 E1.27091
G1 X148.183 Y151.322 E.03312
G1 X165.539 Y168.678 E1.27091
G1 X164.899 Y168.678 E.03312
G1 X147.543 Y151.322 E1.27092
G1 X147.023 Y151.322 E.02692
G2 X146.916 Y151.334 I.032 J.733 E.00559
G1 X164.26 Y168.678 E1.26999
G1 X163.62 Y168.678 E.03312
G1 X146.496 Y151.554 E1.25389
G2 X146.322 Y152.02 I.66 J.513 E.02612
G1 X162.981 Y168.678 E1.21982
G1 X162.341 Y168.678 E.03312
G1 X146.322 Y152.659 E1.173
G1 X146.322 Y153.299 E.03312
M73 P78 R2
G1 X161.701 Y168.678 E1.12617
G1 X161.062 Y168.678 E.03312
G1 X146.322 Y153.938 E1.07934
G1 X146.322 Y154.578 E.03312
G1 X160.422 Y168.678 E1.03251
G1 X159.783 Y168.678 E.03312
G1 X146.322 Y155.217 E.98567
G1 X146.322 Y155.857 E.03312
G1 X159.143 Y168.678 E.93884
G1 X158.504 Y168.678 E.03312
G1 X146.322 Y156.496 E.89201
G1 X146.322 Y157.136 E.03312
G1 X157.864 Y168.678 E.84518
G1 X157.224 Y168.678 E.03312
G1 X146.322 Y157.776 E.79834
G1 X146.322 Y158.415 E.03312
G1 X156.585 Y168.678 E.75151
G1 X155.945 Y168.678 E.03312
G1 X146.322 Y159.055 E.70468
G1 X146.322 Y159.694 E.03312
G1 X155.306 Y168.678 E.65784
G1 X154.666 Y168.678 E.03312
G1 X146.322 Y160.334 E.61101
G1 X146.322 Y160.973 E.03312
G1 X154.027 Y168.678 E.56418
G1 X153.387 Y168.678 E.03312
G1 X146.322 Y161.613 E.51734
G1 X146.322 Y162.253 E.03312
G1 X152.747 Y168.678 E.47051
G1 X152.108 Y168.678 E.03312
G1 X146.322 Y162.892 E.42368
G1 X146.322 Y163.532 E.03312
G1 X151.468 Y168.678 E.37685
G1 X150.829 Y168.678 E.03312
G1 X146.322 Y164.171 E.33001
G1 X146.322 Y164.811 E.03312
G1 X150.189 Y168.678 E.28318
G1 X149.549 Y168.678 E.03312
G1 X146.322 Y165.451 E.23635
G1 X146.322 Y166.09 E.03312
G1 X148.91 Y168.678 E.18952
G1 X148.27 Y168.678 E.03312
G1 X146.322 Y166.73 E.14268
G1 X146.322 Y167.369 E.03312
G1 X147.631 Y168.678 E.09585
G1 X146.991 Y168.678 E.03312
M73 P79 R2
G1 X146.119 Y167.806 E.06384
M106 S237.15
M106 S255
G1 X146.446 Y168.559 F60000
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.38292
; LAYER_HEIGHT: 0.2
G1 F15000
G1 X146.587 Y168.68 E.00514
G1 X193.562 Y151.419 F60000
G1 F15000
G1 X193.499 Y151.456 E.00204
G1 X193.547 Y151.484 E.00155
G1 X183.159 Y151.121 F60000
; FEATURE: Bridge
; LINE_WIDTH: 0.40225
; LAYER_HEIGHT: 0.4
G1 F3000
G1 X188.114 Y156.077 E.36288
G2 X187.495 Y156.032 I-.67 J4.94 E.03216
G1 X187.43 Y156.032 E.0034
G1 X182.722 Y151.324 E.34475
G1 X182.082 Y151.324 E.03312
G1 X186.844 Y156.085 E.34867
G2 X186.527 Y156.149 I6.539 J33.286 E.0167
G1 X186.328 Y156.209 E.01079
G1 X181.442 Y151.323 E.35776
G1 X180.803 Y151.323 E.03312
G1 X185.863 Y156.384 E.37053
G2 X185.443 Y156.603 I3.093 J6.44 E.02455
G1 X180.163 Y151.323 E.38659
G1 X179.523 Y151.323 E.03312
G1 X185.065 Y156.865 E.40581
G2 X184.725 Y157.164 I1.844 J2.446 E.02349
G1 X178.884 Y151.323 E.42769
G1 X178.244 Y151.323 E.03312
G1 X184.42 Y157.499 E.45221
G2 X184.151 Y157.87 I1.749 J1.548 E.02375
G1 X177.605 Y151.323 E.47938
G1 X176.965 Y151.323 E.03312
G1 X183.921 Y158.279 E.50935
G2 X183.737 Y158.735 I5.751 J2.578 E.02546
G1 X176.325 Y151.323 E.54275
G1 X175.686 Y151.323 E.03312
G1 X183.605 Y159.243 E.5799
G2 X183.532 Y159.809 I5.752 J1.028 E.02959
G1 X175.046 Y151.323 E.6214
G1 X174.407 Y151.323 E.03312
G1 X183.56 Y160.477 E.67026
G2 X183.75 Y161.306 I4.309 J-.55 E.04413
G1 X173.564 Y151.121 E.74584
M106 S237.15
; CHANGE_LAYER
; Z_HEIGHT: 3.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F3000
G1 X174.272 Y151.828 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 17/28
; update layer progress
M73 L17
M991 S0 P16 ;notify layer change
M106 S249.9
G17
G3 Z3.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.849 Y163.541
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.798 Y163.528 E.00175
G3 X187.351 Y156.401 I.708 J-3.53 E.34635
G3 X187.677 Y156.402 I.156 J3.322 E.0108
G3 X187.147 Y163.58 I-.17 J3.596 E.38146
G1 X186.909 Y163.549 E.00798
M204 S250
G1 X186.907 Y163.153 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.875 Y163.143 E.00103
G3 X187.369 Y156.793 I.631 J-3.145 E.28593
G3 X187.658 Y156.794 I.138 J2.944 E.00887
G3 X187.186 Y163.19 I-.151 J3.204 E.31489
G1 X186.966 Y163.161 E.0068
; WIPE_START
M204 S10000
G1 X186.875 Y163.143 E-.03537
G1 X186.568 Y163.072 E-.11966
G1 X186.271 Y162.966 E-.11973
G1 X186.021 Y162.847 E-.10524
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.8 I-.664 J1.02 P1  F60000
G1 X193.918 Y167.993 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X193.907 Y168.138 E.00482
G3 X192.99 Y168.918 I-.91 J-.141 E.04352
G1 X147.01 Y168.918 E1.52526
G3 X146.082 Y167.99 I.001 J-.928 E.04833
G1 X146.082 Y152.01 E.53009
G3 X147.01 Y151.082 I.92 J-.007 E.04845
G1 X193.062 Y151.084 E1.52764
G3 X193.918 Y152.01 I-.074 J.927 E.04596
G1 X193.918 Y167.933 E.52821
M204 S250
G1 X194.308 Y168.022 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X194.294 Y168.199 E.00547
G3 X192.996 Y169.31 I-1.297 J-.202 E.05715
G1 X147.004 Y169.31 E1.41323
G3 X145.69 Y167.996 I.009 J-1.323 E.06328
G1 X145.69 Y152.004 E.49141
G3 X147.004 Y150.69 I1.312 J-.001 E.06342
G1 X193.096 Y150.693 E1.41629
G3 X194.31 Y152.004 I-.112 J1.321 E.06022
G1 X194.31 Y167.962 E.49036
; WIPE_START
M204 S10000
G1 X194.294 Y168.199 E-.0904
G1 X194.213 Y168.494 E-.11615
G1 X194.117 Y168.683 E-.08045
G1 X193.968 Y168.876 E-.093
; WIPE_END
G1 E-.02 F1800
G17
G3 Z3.8 I.04 J-1.216 P1  F60000
G1 X190.258 Y168.754 Z3.8
G1 Z3.4
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42103
G1 F15000
G1 X172.921 Y151.417 E.75546
G1 X172.386 Y151.417 E.01648
G1 X189.554 Y168.585 E.74807
G1 X189.019 Y168.585 E.01648
G1 X171.851 Y151.417 E.74807
G1 X171.316 Y151.417 E.01648
G1 X188.484 Y168.585 E.74807
G1 X187.95 Y168.585 E.01648
G1 X170.782 Y151.417 E.74808
G1 X170.247 Y151.416 E.01648
G1 X187.415 Y168.585 E.74808
G1 X186.88 Y168.585 E.01648
G1 X169.712 Y151.416 E.74808
G1 X169.177 Y151.416 E.01648
G1 X186.346 Y168.585 E.74808
G1 X185.811 Y168.585 E.01648
M73 P80 R2
G1 X168.643 Y151.416 E.74808
G1 X168.108 Y151.416 E.01648
G1 X185.276 Y168.585 E.74808
G1 X184.741 Y168.585 E.01648
G1 X167.573 Y151.416 E.74808
G1 X167.038 Y151.416 E.01648
G1 X184.207 Y168.585 E.74808
G1 X183.672 Y168.585 E.01648
G1 X166.504 Y151.416 E.74809
G1 X165.969 Y151.416 E.01648
G1 X183.137 Y168.585 E.74809
G1 X182.602 Y168.585 E.01648
G1 X165.434 Y151.416 E.74809
G1 X164.899 Y151.416 E.01648
G1 X182.068 Y168.585 E.74809
G1 X181.533 Y168.585 E.01648
G1 X164.365 Y151.416 E.74809
G1 X163.83 Y151.416 E.01648
G1 X180.998 Y168.585 E.74809
G1 X180.464 Y168.585 E.01648
G1 X163.295 Y151.416 E.74809
G1 X162.76 Y151.416 E.01648
G1 X179.929 Y168.585 E.74809
G1 X179.394 Y168.585 E.01648
G1 X162.226 Y151.416 E.74809
G1 X161.691 Y151.416 E.01648
G1 X178.859 Y168.585 E.7481
G1 X178.325 Y168.585 E.01648
G1 X161.156 Y151.416 E.7481
G1 X160.621 Y151.416 E.01648
G1 X177.79 Y168.585 E.7481
G1 X177.255 Y168.585 E.01648
G1 X160.087 Y151.416 E.7481
G1 X159.552 Y151.416 E.01648
G1 X176.72 Y168.585 E.7481
G1 X176.186 Y168.585 E.01648
G1 X159.017 Y151.416 E.7481
G1 X158.482 Y151.416 E.01648
G1 X175.651 Y168.585 E.7481
G1 X175.116 Y168.585 E.01648
G1 X157.948 Y151.416 E.7481
G1 X157.413 Y151.416 E.01648
G1 X174.582 Y168.585 E.7481
G1 X174.047 Y168.585 E.01648
G1 X156.878 Y151.416 E.74811
G1 X156.343 Y151.416 E.01648
G1 X173.512 Y168.585 E.74811
G1 X172.977 Y168.585 E.01648
G1 X155.809 Y151.416 E.74811
G1 X155.274 Y151.416 E.01648
G1 X172.443 Y168.585 E.74811
G1 X171.908 Y168.585 E.01648
G1 X154.739 Y151.416 E.74811
G1 X154.204 Y151.416 E.01648
G1 X171.373 Y168.585 E.74811
G1 X170.838 Y168.585 E.01648
G1 X153.67 Y151.416 E.74811
G1 X153.135 Y151.416 E.01648
G1 X170.304 Y168.585 E.74811
G1 X169.769 Y168.585 E.01648
G1 X152.6 Y151.416 E.74811
G1 X152.065 Y151.416 E.01648
G1 X169.234 Y168.585 E.74812
G1 X168.7 Y168.585 E.01648
G1 X151.53 Y151.416 E.74812
G1 X150.996 Y151.416 E.01648
G1 X168.165 Y168.585 E.74812
G1 X167.63 Y168.585 E.01648
G1 X150.461 Y151.416 E.74812
G1 X149.926 Y151.416 E.01648
G1 X167.095 Y168.585 E.74812
G1 X166.561 Y168.585 E.01648
G1 X149.391 Y151.415 E.74812
G1 X148.857 Y151.415 E.01648
G1 X166.026 Y168.585 E.74812
G1 X165.491 Y168.585 E.01648
G1 X148.322 Y151.415 E.74812
G1 X147.787 Y151.415 E.01648
G1 X164.956 Y168.585 E.74812
G1 X164.422 Y168.585 E.01648
G1 X147.252 Y151.415 E.74813
G2 X146.774 Y151.472 I-.102 J1.182 E.01493
G1 X163.887 Y168.585 E.74565
G1 X163.352 Y168.585 E.01648
G1 X146.493 Y151.725 E.73462
G2 X146.418 Y152.185 I.801 J.367 E.01452
G1 X162.818 Y168.585 E.7146
G1 X162.283 Y168.585 E.01648
G1 X146.418 Y152.72 E.6913
G1 X146.418 Y153.254 E.01647
G1 X161.748 Y168.585 E.668
G1 X161.213 Y168.585 E.01648
G1 X146.418 Y153.789 E.64471
G1 X146.417 Y154.323 E.01647
G1 X160.679 Y168.585 E.62141
G1 X160.144 Y168.585 E.01648
G1 X146.417 Y154.858 E.59811
G1 X146.417 Y155.393 E.01647
G1 X159.609 Y168.585 E.57482
G1 X159.074 Y168.585 E.01648
M73 P81 R2
G1 X146.417 Y155.927 E.55152
G1 X146.417 Y156.462 E.01647
G1 X158.54 Y168.585 E.52822
G1 X158.005 Y168.585 E.01648
G1 X146.417 Y156.997 E.50493
G1 X146.417 Y157.531 E.01647
G1 X157.47 Y168.585 E.48163
G1 X156.936 Y168.585 E.01648
G1 X146.417 Y158.066 E.45833
G1 X146.417 Y158.601 E.01647
G1 X156.401 Y168.585 E.43504
G1 X155.866 Y168.585 E.01648
G1 X146.417 Y159.135 E.41174
G1 X146.417 Y159.67 E.01647
G1 X155.331 Y168.585 E.38845
G1 X154.797 Y168.585 E.01648
G1 X146.417 Y160.205 E.36515
G1 X146.416 Y160.739 E.01647
G1 X154.262 Y168.585 E.34185
G1 X153.727 Y168.585 E.01648
G1 X146.416 Y161.274 E.31856
G1 X146.416 Y161.809 E.01647
G1 X153.192 Y168.585 E.29526
G1 X152.658 Y168.585 E.01648
G1 X146.416 Y162.343 E.27196
G1 X146.416 Y162.878 E.01647
G1 X152.123 Y168.585 E.24867
G1 X151.588 Y168.585 E.01648
G1 X146.416 Y163.412 E.22537
G1 X146.416 Y163.947 E.01647
G1 X151.054 Y168.585 E.20207
G1 X150.519 Y168.585 E.01648
G1 X146.416 Y164.482 E.17878
G1 X146.416 Y165.016 E.01647
G1 X149.984 Y168.585 E.15548
G1 X149.449 Y168.585 E.01648
G1 X146.416 Y165.551 E.13218
G1 X146.416 Y166.086 E.01647
G1 X148.915 Y168.585 E.10889
G1 X148.38 Y168.585 E.01648
G1 X146.416 Y166.62 E.08559
G1 X146.415 Y167.155 E.01647
G1 X147.845 Y168.585 E.06229
G1 X147.31 Y168.585 E.01648
G1 X146.415 Y167.69 E.039
G2 X146.449 Y168.181 I1.596 J.138 E.01523
G1 X146.532 Y168.341 E.00555
G1 X146.932 Y168.741 E.01742
G1 X183.981 Y151.247 F60000
G1 F15000
G1 X189.17 Y156.437 E.22611
G2 X188.362 Y156.163 I-1.805 J4.004 E.02633
G1 X183.616 Y151.417 E.2068
G1 X183.081 Y151.417 E.01648
G1 X187.737 Y156.073 E.20288
G2 X187.209 Y156.08 I-.206 J4.524 E.01628
G1 X182.546 Y151.417 E.20318
G1 X182.012 Y151.417 E.01648
G1 X186.738 Y156.143 E.20594
G2 X186.312 Y156.252 I.34 J2.217 E.01356
G1 X181.477 Y151.417 E.21069
G1 X180.942 Y151.417 E.01648
G1 X185.923 Y156.398 E.21704
G2 X185.566 Y156.576 I.725 J1.9 E.0123
G1 X180.407 Y151.417 E.2248
G1 X179.872 Y151.417 E.01648
G1 X185.239 Y156.783 E.23382
G2 X184.938 Y157.017 I1.037 J1.642 E.01176
G1 X179.338 Y151.417 E.24402
G1 X178.803 Y151.417 E.01648
G1 X184.663 Y157.277 E.25535
G2 X184.414 Y157.563 I1.328 J1.408 E.0117
G1 X178.268 Y151.417 E.26781
G1 X177.733 Y151.417 E.01648
G1 X184.192 Y157.875 E.28141
G2 X183.997 Y158.215 I1.626 J1.16 E.01209
G1 X177.199 Y151.417 E.29621
G1 X176.664 Y151.417 E.01648
G1 X183.831 Y158.584 E.31231
G2 X183.699 Y158.987 I1.979 J.872 E.01308
G1 X176.129 Y151.417 E.32986
G1 X175.594 Y151.417 E.01648
G1 X183.606 Y159.428 E.3491
G2 X183.569 Y159.926 I2.506 J.438 E.01539
G1 X175.06 Y151.417 E.37077
G1 X174.525 Y151.417 E.01648
G1 X183.598 Y160.49 E.39535
G2 X183.748 Y161.175 I4.148 J-.551 E.02163
G1 X173.99 Y151.417 E.4252
G1 X173.455 Y151.417 E.01648
G1 X190.623 Y168.585 E.74807
G1 X191.158 Y168.585 E.01648
G1 X186.325 Y163.752 E.21059
G2 X187.01 Y163.902 I1.237 J-4.001 E.02163
G1 X191.693 Y168.585 E.20404
G1 X192.228 Y168.585 E.01648
G1 X187.574 Y163.931 E.20277
G2 X188.072 Y163.894 I.059 J-2.544 E.01539
G1 X192.762 Y168.585 E.20439
G2 X193.181 Y168.551 I.101 J-1.363 E.01299
G1 X193.235 Y168.523 E.00189
G1 X188.513 Y163.801 E.20576
G2 X188.916 Y163.669 I-.469 J-2.111 E.01308
G1 X193.512 Y168.265 E.20029
G2 X193.582 Y167.8 I-.839 J-.364 E.01465
G1 X189.285 Y163.503 E.18723
G2 X189.625 Y163.308 I-.821 J-1.822 E.01209
G1 X193.582 Y167.266 E.17244
G1 X193.582 Y166.731 E.01647
G1 X189.937 Y163.086 E.15884
G2 X190.223 Y162.837 I-1.121 J-1.577 E.0117
G1 X193.582 Y166.196 E.14639
G1 X193.582 Y165.662 E.01647
G1 X190.483 Y162.562 E.13506
G2 X190.717 Y162.261 I-1.406 J-1.336 E.01176
G1 X193.583 Y165.127 E.12487
G1 X193.583 Y164.592 E.01647
G1 X190.924 Y161.934 E.11585
G2 X191.102 Y161.577 I-1.721 J-1.081 E.0123
G1 X193.583 Y164.058 E.1081
G1 X193.583 Y163.523 E.01647
G1 X191.248 Y161.188 E.10175
G2 X191.357 Y160.762 I-2.106 J-.765 E.01356
G1 X193.583 Y162.988 E.09701
G1 X193.583 Y162.454 E.01647
G1 X191.421 Y160.292 E.09419
G2 X191.427 Y159.763 I-5.11 J-.317 E.01632
G1 X193.583 Y161.919 E.09395
G1 X193.583 Y161.385 E.01647
G1 X191.337 Y159.138 E.09788
G2 X191.063 Y158.33 I-4.279 J.997 E.02633
G1 X193.583 Y160.85 E.1098
G1 X193.583 Y160.315 E.01647
G1 X184.685 Y151.417 E.38772
G1 X185.22 Y151.417 E.01648
G1 X193.583 Y159.781 E.36442
G1 X193.584 Y159.246 E.01647
G1 X185.755 Y151.417 E.34113
G1 X186.29 Y151.417 E.01648
G1 X193.584 Y158.711 E.31783
G1 X193.584 Y158.177 E.01647
G1 X186.824 Y151.417 E.29453
G1 X187.359 Y151.417 E.01648
G1 X193.584 Y157.642 E.27123
G1 X193.584 Y157.107 E.01647
G1 X187.894 Y151.417 E.24794
G1 X188.429 Y151.417 E.01648
G1 X193.584 Y156.573 E.22464
G1 X193.584 Y156.038 E.01647
G1 X188.963 Y151.417 E.20134
G1 X189.498 Y151.417 E.01648
G1 X193.584 Y155.503 E.17804
G1 X193.584 Y154.969 E.01647
G1 X190.033 Y151.417 E.15475
G1 X190.568 Y151.417 E.01648
G1 X193.584 Y154.434 E.13145
G1 X193.584 Y153.9 E.01647
G1 X191.102 Y151.418 E.10815
G1 X191.637 Y151.418 E.01648
G1 X193.584 Y153.365 E.08485
G1 X193.585 Y152.83 E.01647
G1 X192.172 Y151.418 E.06156
G1 X192.707 Y151.418 E.01648
G1 X193.754 Y152.465 E.04565
; CHANGE_LAYER
; Z_HEIGHT: 3.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X193.047 Y151.758 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 18/28
; update layer progress
M73 L18
M991 S0 P17 ;notify layer change
G17
G3 Z3.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.858 Y163.542
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.798 Y163.53 E.00203
G3 X187.344 Y156.402 I.712 J-3.531 E.34604
G1 X187.5 Y156.398 E.00519
G3 X187.147 Y163.583 I.01 J3.602 E.38772
G1 X186.917 Y163.55 E.0077
M204 S250
G1 X186.915 Y163.155 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.874 Y163.145 E.00129
G3 X187.362 Y156.793 I.635 J-3.146 E.28564
G1 X187.5 Y156.79 E.00426
G3 X187.185 Y163.192 I.009 J3.209 E.32007
G1 X186.975 Y163.163 E.00654
; WIPE_START
M204 S10000
G1 X186.874 Y163.145 E-.03869
G1 X186.568 Y163.072 E-.11963
G1 X186.271 Y162.966 E-.11979
G1 X186.029 Y162.851 E-.1019
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4 I-.68 J1.01 P1  F60000
G1 X193.718 Y168.028 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X193.718 Y168.06 E.00109
G3 X192.987 Y168.721 I-.727 J-.069 E.0359
G1 X147.013 Y168.721 E1.52502
G3 X146.279 Y167.987 I-.003 J-.731 E.03832
G1 X146.282 Y151.94 E.53231
G3 X147.013 Y151.279 I.727 J.069 E.0359
G1 X193.043 Y151.281 E1.52688
G1 X193.06 Y151.282 E.00059
G3 X193.721 Y152.013 I-.07 J.727 E.03589
G1 X193.718 Y167.968 E.52923
M204 S250
M73 P82 R1
G1 X194.111 Y168.028 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X194.111 Y168.053 E.00076
G3 X192.995 Y169.113 I-1.113 J-.054 E.05223
G1 X147.005 Y169.113 E1.41316
G3 X145.887 Y167.995 I.009 J-1.127 E.05385
G1 X145.889 Y151.947 E.4931
G3 X147.005 Y150.887 I1.113 J.054 E.05223
G1 X193.053 Y150.889 E1.41493
G3 X194.113 Y152.005 I-.054 J1.113 E.05222
G1 X194.111 Y167.968 E.4905
; WIPE_START
M204 S10000
G1 X194.111 Y168.053 E-.03221
G1 X194.074 Y168.292 E-.0922
G1 X194.002 Y168.484 E-.07786
G1 X193.893 Y168.664 E-.07994
G1 X193.747 Y168.826 E-.08283
G1 X193.715 Y168.849 E-.01496
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4 I.448 J-1.132 P1  F60000
G1 X192.98 Y168.558 Z4
G1 Z3.6
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42089
G1 F15000
G1 X193.307 Y168.23 E.01426
G2 X193.386 Y168.008 I-.332 J-.243 E.00737
G1 X193.386 Y167.617 E.01205
G1 X192.615 Y168.388 E.03359
G1 X192.08 Y168.388 E.01646
G1 X193.386 Y167.082 E.05688
G1 X193.386 Y166.548 E.01647
G1 X191.546 Y168.388 E.08016
G1 X191.011 Y168.388 E.01646
G1 X193.386 Y166.013 E.10345
G1 X193.386 Y165.478 E.01647
G1 X190.477 Y168.388 E.12673
G1 X189.942 Y168.388 E.01646
G1 X193.386 Y164.944 E.15002
G1 X193.386 Y164.409 E.01647
G1 X189.408 Y168.388 E.17331
G1 X188.873 Y168.388 E.01646
G1 X193.386 Y163.875 E.19659
G1 X193.386 Y163.34 E.01647
G1 X188.338 Y168.388 E.21988
G1 X187.804 Y168.388 E.01646
G1 X193.387 Y162.805 E.24316
G1 X193.387 Y162.271 E.01647
G1 X187.269 Y168.388 E.26645
G1 X186.735 Y168.388 E.01646
G1 X193.387 Y161.736 E.28974
G1 X193.387 Y161.202 E.01647
G1 X186.2 Y168.388 E.31302
G1 X185.666 Y168.388 E.01646
G1 X193.387 Y160.667 E.33631
G1 X193.387 Y160.132 E.01647
G1 X185.131 Y168.388 E.35959
G1 X184.597 Y168.388 E.01646
G1 X193.387 Y159.598 E.38288
G1 X193.387 Y159.063 E.01647
G1 X191.241 Y161.209 E.09346
G2 X191.399 Y160.516 I-4.22 J-1.327 E.0219
G1 X193.387 Y158.529 E.08658
G1 X193.387 Y157.994 E.01647
G1 X191.431 Y159.95 E.0852
G2 X191.396 Y159.451 I-2.551 J-.072 E.01545
G1 X193.387 Y157.459 E.08673
G1 X193.387 Y156.925 E.01647
G1 X191.306 Y159.006 E.09064
G2 X191.176 Y158.602 I-2.116 J.461 E.0131
G1 X193.387 Y156.39 E.09633
G1 X193.387 Y155.856 E.01647
G1 X191.012 Y158.231 E.10347
G2 X190.818 Y157.89 I-1.827 J.813 E.01209
G1 X193.388 Y155.321 E.11191
G1 X193.388 Y154.786 E.01647
G1 X190.597 Y157.577 E.12155
G2 X190.349 Y157.29 I-1.582 J1.114 E.01169
G1 X193.388 Y154.252 E.13234
G1 X193.388 Y153.717 E.01647
G1 X190.076 Y157.029 E.14424
G2 X189.777 Y156.793 I-1.344 J1.401 E.01174
G1 X193.388 Y153.183 E.15728
G1 X193.388 Y152.648 E.01647
G1 X189.451 Y156.585 E.17149
G2 X189.096 Y156.406 I-1.088 J1.714 E.01227
G1 X193.388 Y152.113 E.18697
G2 X193.255 Y151.712 I-.488 J-.061 E.01346
G1 X188.708 Y156.258 E.19803
G2 X188.284 Y156.148 I-.774 J2.098 E.01351
G1 X192.818 Y151.614 E.19748
G1 X192.284 Y151.614 E.01646
G1 X187.817 Y156.081 E.19457
G2 X187.291 Y156.072 I-.346 J4.754 E.01619
G1 X191.749 Y151.614 E.19416
G1 X191.215 Y151.614 E.01646
G1 X186.672 Y156.156 E.19786
G2 X185.877 Y156.417 I.888 J4.051 E.02582
G1 X190.68 Y151.614 E.20922
G1 X190.146 Y151.614 E.01646
G1 X173.372 Y168.388 E.73063
G1 X173.906 Y168.388 E.01646
G1 X183.917 Y158.377 E.43606
G2 X183.656 Y159.172 I3.794 J1.684 E.02582
G1 X174.441 Y168.388 E.40142
G1 X174.975 Y168.388 E.01646
G1 X183.57 Y159.793 E.37438
G2 X183.581 Y160.317 I5.797 J.142 E.01614
G1 X175.51 Y168.388 E.35156
G1 X176.044 Y168.388 E.01646
G1 X183.648 Y160.784 E.33119
G2 X183.758 Y161.208 I2.207 J-.35 E.01351
G1 X176.579 Y168.388 E.31273
G1 X177.113 Y168.388 E.01646
G1 X183.906 Y161.596 E.29586
G2 X184.085 Y161.951 I1.893 J-.733 E.01227
G1 X177.648 Y168.388 E.28039
G1 X178.182 Y168.388 E.01646
G1 X184.293 Y162.277 E.26618
G2 X184.529 Y162.576 I1.634 J-1.043 E.01174
G1 X178.717 Y168.388 E.25315
G1 X179.251 Y168.388 E.01646
G1 X184.79 Y162.849 E.24124
G2 X185.077 Y163.097 I1.399 J-1.332 E.01169
G1 X179.786 Y168.388 E.23046
G1 X180.321 Y168.388 E.01646
G1 X185.39 Y163.318 E.22082
G2 X185.731 Y163.512 I1.154 J-1.634 E.01209
G1 X180.855 Y168.388 E.21239
G1 X181.39 Y168.388 E.01646
G1 X186.102 Y163.676 E.20525
G2 X186.506 Y163.806 I.865 J-1.985 E.0131
G1 X181.924 Y168.388 E.19956
G1 X182.459 Y168.388 E.01646
G1 X186.951 Y163.896 E.19566
G2 X187.45 Y163.931 I.428 J-2.519 E.01545
G1 X182.993 Y168.388 E.19413
G1 X183.528 Y168.388 E.01646
G1 X188.016 Y163.899 E.19551
G2 X188.709 Y163.741 I-.635 J-4.379 E.0219
G1 X183.893 Y168.558 E.20979
G1 X172.667 Y168.558 F60000
G1 F15000
G1 X189.611 Y151.614 E.73802
G1 X189.077 Y151.614 E.01646
G1 X172.303 Y168.388 E.73063
G1 X171.768 Y168.388 E.01646
G1 X188.542 Y151.614 E.73063
G1 X188.008 Y151.614 E.01646
G1 X171.234 Y168.388 E.73064
G1 X170.699 Y168.388 E.01646
G1 X187.473 Y151.614 E.73064
G1 X186.939 Y151.614 E.01646
G1 X170.164 Y168.388 E.73064
G1 X169.63 Y168.388 E.01646
G1 X186.404 Y151.614 E.73064
G1 X185.87 Y151.614 E.01646
G1 X169.095 Y168.388 E.73064
G1 X168.561 Y168.388 E.01646
G1 X185.335 Y151.614 E.73064
G1 X184.801 Y151.614 E.01646
G1 X168.026 Y168.388 E.73064
G1 X167.492 Y168.388 E.01646
G1 X184.266 Y151.614 E.73064
G1 X183.732 Y151.614 E.01646
G1 X166.957 Y168.388 E.73064
G1 X166.423 Y168.388 E.01646
G1 X183.197 Y151.614 E.73064
G1 X182.663 Y151.614 E.01646
G1 X165.888 Y168.388 E.73065
G1 X165.354 Y168.388 E.01646
G1 X182.128 Y151.614 E.73065
G1 X181.594 Y151.614 E.01646
M73 P83 R1
G1 X164.819 Y168.388 E.73065
G1 X164.285 Y168.388 E.01646
G1 X181.059 Y151.614 E.73065
G1 X180.524 Y151.614 E.01646
G1 X163.75 Y168.388 E.73065
G1 X163.216 Y168.388 E.01646
G1 X179.99 Y151.614 E.73065
G1 X179.455 Y151.614 E.01646
G1 X162.681 Y168.388 E.73065
G1 X162.146 Y168.388 E.01646
G1 X178.921 Y151.613 E.73065
G1 X178.386 Y151.613 E.01646
G1 X161.612 Y168.388 E.73065
G1 X161.077 Y168.388 E.01646
G1 X177.852 Y151.613 E.73066
G1 X177.317 Y151.613 E.01646
G1 X160.543 Y168.388 E.73066
G1 X160.008 Y168.388 E.01646
G1 X176.783 Y151.613 E.73066
G1 X176.248 Y151.613 E.01646
G1 X159.474 Y168.388 E.73066
G1 X158.939 Y168.388 E.01646
G1 X175.714 Y151.613 E.73066
G1 X175.179 Y151.613 E.01646
G1 X158.405 Y168.388 E.73066
G1 X157.87 Y168.388 E.01646
G1 X174.645 Y151.613 E.73066
G1 X174.11 Y151.613 E.01646
G1 X157.336 Y168.388 E.73066
G1 X156.801 Y168.388 E.01646
G1 X173.576 Y151.613 E.73066
G1 X173.041 Y151.613 E.01646
G1 X156.267 Y168.388 E.73067
G1 X155.732 Y168.388 E.01646
G1 X172.507 Y151.613 E.73067
G1 X171.972 Y151.613 E.01646
G1 X155.198 Y168.388 E.73067
G1 X154.663 Y168.388 E.01646
G1 X171.438 Y151.613 E.73067
G1 X170.903 Y151.613 E.01646
G1 X154.129 Y168.388 E.73067
G1 X153.594 Y168.388 E.01646
G1 X170.369 Y151.613 E.73067
G1 X169.834 Y151.613 E.01646
G1 X153.059 Y168.388 E.73067
G1 X152.525 Y168.388 E.01646
G1 X169.3 Y151.613 E.73067
G1 X168.765 Y151.613 E.01646
G1 X151.99 Y168.388 E.73067
G1 X151.456 Y168.388 E.01646
G1 X168.231 Y151.613 E.73068
G1 X167.696 Y151.613 E.01646
G1 X150.921 Y168.388 E.73068
G1 X150.387 Y168.388 E.01646
G1 X167.162 Y151.613 E.73068
G1 X166.627 Y151.613 E.01646
G1 X149.852 Y168.388 E.73068
G1 X149.318 Y168.388 E.01646
G1 X166.093 Y151.613 E.73068
G1 X165.558 Y151.613 E.01646
G1 X148.783 Y168.388 E.73068
G1 X148.249 Y168.388 E.01646
G1 X165.024 Y151.613 E.73068
G1 X164.489 Y151.613 E.01646
G1 X147.714 Y168.388 E.73068
G1 X147.18 Y168.388 E.01646
G1 X163.955 Y151.613 E.73068
G1 X163.42 Y151.613 E.01646
G1 X146.748 Y168.285 E.72619
G3 X146.612 Y167.887 I.302 J-.326 E.01351
G1 X162.886 Y151.613 E.70884
G1 X162.351 Y151.613 E.01646
G1 X146.612 Y167.352 E.68556
G1 X146.612 Y166.817 E.01647
G1 X161.817 Y151.613 E.66227
G1 X161.282 Y151.613 E.01646
G1 X146.612 Y166.283 E.63899
G1 X146.612 Y165.748 E.01647
G1 X160.748 Y151.613 E.6157
G1 X160.213 Y151.613 E.01646
G1 X146.612 Y165.214 E.59242
G1 X146.612 Y164.679 E.01647
G1 X159.679 Y151.613 E.56913
G1 X159.144 Y151.613 E.01646
G1 X146.613 Y164.144 E.54585
G1 X146.613 Y163.61 E.01647
G1 X158.61 Y151.613 E.52257
G1 X158.075 Y151.613 E.01646
G1 X146.613 Y163.075 E.49928
G1 X146.613 Y162.541 E.01647
G1 X157.541 Y151.613 E.476
G1 X157.006 Y151.612 E.01646
G1 X146.613 Y162.006 E.45271
G1 X146.613 Y161.471 E.01647
G1 X156.472 Y151.612 E.42943
G1 X155.937 Y151.612 E.01646
G1 X146.613 Y160.937 E.40614
G1 X146.613 Y160.402 E.01647
G1 X155.403 Y151.612 E.38286
G1 X154.868 Y151.612 E.01646
G1 X146.613 Y159.867 E.35957
G1 X146.613 Y159.333 E.01647
G1 X154.334 Y151.612 E.33629
G1 X153.799 Y151.612 E.01646
G1 X146.613 Y158.798 E.313
G1 X146.613 Y158.264 E.01647
G1 X153.265 Y151.612 E.28972
G1 X152.73 Y151.612 E.01646
G1 X146.613 Y157.729 E.26643
G1 X146.613 Y157.194 E.01647
G1 X152.196 Y151.612 E.24315
M73 P84 R1
G1 X151.661 Y151.612 E.01646
G1 X146.614 Y156.66 E.21986
G1 X146.614 Y156.125 E.01647
G1 X151.127 Y151.612 E.19658
G1 X150.592 Y151.612 E.01646
G1 X146.614 Y155.591 E.17329
G1 X146.614 Y155.056 E.01647
G1 X150.058 Y151.612 E.15001
G1 X149.523 Y151.612 E.01646
G1 X146.614 Y154.521 E.12672
G1 X146.614 Y153.987 E.01647
G1 X148.989 Y151.612 E.10344
G1 X148.454 Y151.612 E.01646
G1 X146.614 Y153.452 E.08015
G1 X146.614 Y152.918 E.01647
G1 X147.92 Y151.612 E.05687
G1 X147.385 Y151.612 E.01646
G1 X146.614 Y152.383 E.03358
G1 X146.614 Y151.992 E.01204
G3 X146.693 Y151.769 I.411 J.021 E.00738
G1 X147.02 Y151.442 E.01424
; CHANGE_LAYER
; Z_HEIGHT: 3.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X146.693 Y151.769 E-.17575
G1 X146.64 Y151.867 E-.04214
G1 X146.614 Y151.992 E-.04863
G1 X146.614 Y152.291 E-.11348
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 19/28
; update layer progress
M73 L19
M991 S0 P18 ;notify layer change
G17
G3 Z4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.848 Y163.539
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G1 X186.625 Y163.492 E.00755
G3 X187.335 Y156.402 I.881 J-3.492 E.34017
G1 X187.5 Y156.398 E.00546
G3 X186.972 Y163.561 I.006 J3.602 E.39331
G1 X186.907 Y163.549 E.00219
M204 S250
G1 X186.924 Y163.154 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.721 Y163.111 E.0064
G3 X187.354 Y156.794 I.785 J-3.112 E.28079
G1 X187.5 Y156.79 E.00449
G3 X187.029 Y163.173 I.006 J3.209 E.32468
G1 X186.983 Y163.165 E.00143
; WIPE_START
M204 S10000
G1 X186.721 Y163.111 E-.10194
G1 X186.419 Y163.022 E-.11966
G1 X186.127 Y162.902 E-.11974
G1 X186.038 Y162.854 E-.03866
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.2 I-.692 J1.001 P1  F60000
G1 X193.452 Y167.983 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F18000
G3 X192.983 Y168.452 I-.459 J.01 E.02461
G1 X147.017 Y168.452 E1.52476
G3 X146.548 Y167.983 I-.011 J-.459 E.02461
G1 X146.548 Y152.017 E.52961
G3 X147.017 Y151.548 I.459 J-.01 E.02461
G1 X193.037 Y151.55 E1.52656
G3 X193.452 Y152.017 I-.046 J.459 E.02277
G1 X193.452 Y167.923 E.52762
M204 S250
G1 X193.844 Y167.994 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G3 X192.994 Y168.844 I-.851 J0 E.04103
G1 X147.006 Y168.844 E1.41308
G3 X146.156 Y167.994 I0 J-.851 E.04103
G1 X146.156 Y152.006 E.49126
G3 X147.006 Y151.156 I.851 J0 E.04103
G1 X193.077 Y151.159 E1.41564
G3 X193.844 Y152.006 I-.092 J.854 E.03839
G1 X193.844 Y167.934 E.48942
; WIPE_START
M204 S10000
G1 X193.799 Y168.272 E-.12951
G1 X193.714 Y168.45 E-.07499
G1 X193.582 Y168.61 E-.0789
G1 X193.45 Y168.714 E-.06391
G1 X193.372 Y168.751 E-.03269
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.2 I.147 J-1.208 P1  F60000
G1 X189.572 Y168.289 Z4.2
G1 Z3.8
G1 E.4 F1800
; FEATURE: Internal solid infill
; LINE_WIDTH: 0.42278
G1 F15000
G1 X173.166 Y151.882 E.71818
G1 X172.629 Y151.882 E.01663
G1 X188.865 Y168.119 E.71076
G1 X188.328 Y168.119 E.01663
G1 X172.091 Y151.882 E.71076
G1 X171.554 Y151.882 E.01663
G1 X187.791 Y168.119 E.71076
G1 X187.254 Y168.119 E.01663
G1 X171.017 Y151.882 E.71076
G1 X170.48 Y151.882 E.01663
G1 X186.716 Y168.119 E.71076
G1 X186.179 Y168.119 E.01663
G1 X169.943 Y151.882 E.71076
G1 X169.405 Y151.882 E.01663
G1 X185.642 Y168.119 E.71076
G1 X185.105 Y168.119 E.01663
G1 X168.868 Y151.882 E.71076
G1 X168.331 Y151.882 E.01663
G1 X184.568 Y168.119 E.71077
G1 X184.03 Y168.119 E.01663
G1 X167.794 Y151.882 E.71077
G1 X167.256 Y151.882 E.01663
G1 X183.493 Y168.119 E.71077
G1 X182.956 Y168.119 E.01663
G1 X166.719 Y151.882 E.71077
G1 X166.182 Y151.882 E.01663
G1 X182.419 Y168.119 E.71077
G1 X181.882 Y168.119 E.01663
G1 X165.645 Y151.882 E.71077
G1 X165.107 Y151.882 E.01663
G1 X181.344 Y168.119 E.71077
G1 X180.807 Y168.119 E.01663
G1 X164.57 Y151.882 E.71077
G1 X164.033 Y151.882 E.01663
G1 X180.27 Y168.119 E.71077
G1 X179.733 Y168.119 E.01663
G1 X163.496 Y151.882 E.71078
G1 X162.959 Y151.882 E.01663
G1 X179.195 Y168.119 E.71078
G1 X178.658 Y168.119 E.01663
G1 X162.421 Y151.882 E.71078
G1 X161.884 Y151.882 E.01663
G1 X178.121 Y168.119 E.71078
G1 X177.584 Y168.119 E.01663
G1 X161.347 Y151.882 E.71078
G1 X160.81 Y151.882 E.01663
G1 X177.047 Y168.119 E.71078
G1 X176.509 Y168.119 E.01663
G1 X160.272 Y151.882 E.71078
G1 X159.735 Y151.882 E.01663
G1 X175.972 Y168.119 E.71078
G1 X175.435 Y168.119 E.01663
G1 X159.198 Y151.882 E.71078
G1 X158.661 Y151.882 E.01663
G1 X174.898 Y168.119 E.71079
G1 X174.361 Y168.119 E.01663
G1 X158.123 Y151.882 E.71079
G1 X157.586 Y151.882 E.01663
G1 X173.823 Y168.119 E.71079
G1 X173.286 Y168.119 E.01663
G1 X157.049 Y151.882 E.71079
G1 X156.512 Y151.882 E.01663
M73 P85 R1
G1 X172.749 Y168.119 E.71079
G1 X172.212 Y168.119 E.01663
G1 X155.975 Y151.882 E.71079
G1 X155.437 Y151.882 E.01663
G1 X171.675 Y168.119 E.71079
G1 X171.137 Y168.119 E.01663
G1 X154.9 Y151.882 E.71079
G1 X154.363 Y151.881 E.01663
G1 X170.6 Y168.119 E.7108
G1 X170.063 Y168.119 E.01663
G1 X153.826 Y151.881 E.7108
G1 X153.288 Y151.881 E.01663
G1 X169.526 Y168.119 E.7108
G1 X168.989 Y168.119 E.01663
G1 X152.751 Y151.881 E.7108
G1 X152.214 Y151.881 E.01663
G1 X168.451 Y168.119 E.7108
G1 X167.914 Y168.119 E.01663
G1 X151.677 Y151.881 E.7108
G1 X151.139 Y151.881 E.01663
G1 X167.377 Y168.119 E.7108
G1 X166.84 Y168.119 E.01663
G1 X150.602 Y151.881 E.7108
G1 X150.065 Y151.881 E.01663
G1 X166.303 Y168.119 E.7108
G1 X165.765 Y168.119 E.01663
G1 X149.528 Y151.881 E.71081
G1 X148.991 Y151.881 E.01663
G1 X165.228 Y168.119 E.71081
G1 X164.691 Y168.119 E.01663
G1 X148.453 Y151.881 E.71081
G1 X147.916 Y151.881 E.01663
G1 X164.154 Y168.119 E.71081
G1 X163.617 Y168.119 E.01663
G1 X147.379 Y151.881 E.71081
G2 X146.96 Y151.893 I-.169 J1.408 E.01302
G2 X146.903 Y151.943 I.074 J.143 E.00235
G1 X163.079 Y168.119 E.70812
G1 X162.542 Y168.119 E.01663
G1 X146.881 Y152.458 E.68557
G1 X146.881 Y152.995 E.01663
G1 X162.005 Y168.119 E.66205
G1 X161.468 Y168.119 E.01663
G1 X146.881 Y153.532 E.63853
G1 X146.881 Y154.069 E.01663
G1 X160.931 Y168.119 E.61502
G1 X160.393 Y168.119 E.01663
G1 X146.881 Y154.607 E.5915
G1 X146.881 Y155.144 E.01663
G1 X159.856 Y168.119 E.56799
G1 X159.319 Y168.119 E.01663
G1 X146.881 Y155.681 E.54447
G1 X146.881 Y156.218 E.01663
G1 X158.782 Y168.119 E.52095
G1 X158.245 Y168.119 E.01663
G1 X146.881 Y156.755 E.49744
G1 X146.881 Y157.293 E.01663
G1 X157.707 Y168.119 E.47392
G1 X157.17 Y168.119 E.01663
G1 X146.881 Y157.83 E.45041
G1 X146.881 Y158.367 E.01663
G1 X156.633 Y168.119 E.42689
G1 X156.096 Y168.119 E.01663
G1 X146.881 Y158.904 E.40337
G1 X146.881 Y159.441 E.01663
G1 X155.559 Y168.119 E.37986
G1 X155.021 Y168.119 E.01663
G1 X146.881 Y159.979 E.35634
G1 X146.881 Y160.516 E.01663
G1 X154.484 Y168.119 E.33282
G1 X153.947 Y168.119 E.01663
G1 X146.881 Y161.053 E.30931
G1 X146.881 Y161.59 E.01663
G1 X153.41 Y168.119 E.28579
G1 X152.873 Y168.119 E.01663
G1 X146.881 Y162.127 E.26228
G1 X146.881 Y162.665 E.01663
G1 X152.335 Y168.119 E.23876
G1 X151.798 Y168.119 E.01663
G1 X146.881 Y163.202 E.21524
G1 X146.881 Y163.739 E.01663
G1 X151.261 Y168.119 E.19173
G1 X150.724 Y168.119 E.01663
G1 X146.881 Y164.276 E.16821
G1 X146.881 Y164.813 E.01663
G1 X150.187 Y168.119 E.14469
G1 X149.649 Y168.119 E.01663
G1 X146.881 Y165.351 E.12118
G1 X146.881 Y165.888 E.01663
G1 X149.112 Y168.119 E.09766
G1 X148.575 Y168.119 E.01663
G1 X146.881 Y166.425 E.07415
G1 X146.881 Y166.962 E.01663
G1 X148.038 Y168.119 E.05063
G1 X147.501 Y168.119 E.01663
G1 X146.881 Y167.499 E.02711
G1 X146.881 Y167.958 E.01419
G2 X146.904 Y168.06 I.163 J.016 E.00329
G1 X147.133 Y168.289 E.01001
; WIPE_START
G1 X146.904 Y168.06 E-.12289
G1 X146.881 Y167.958 E-.03968
G1 X146.881 Y167.499 E-.17425
G1 X146.961 Y167.58 E-.04318
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.2 I.178 J1.204 P1  F60000
G1 X193.289 Y160.724 Z4.2
G1 Z3.8
G1 E.4 F1800
G1 F15000
G1 X191.183 Y158.618 E.09219
G3 X191.379 Y159.352 I-4.244 J1.531 E.02355
G1 X193.119 Y161.091 E.07615
G1 X193.119 Y161.629 E.01663
G1 X191.431 Y159.941 E.07388
G3 X191.406 Y160.452 I-2.611 J.126 E.01588
G1 X193.119 Y162.166 E.075
G1 X193.119 Y162.703 E.01663
G1 X191.327 Y160.911 E.07844
G3 X191.206 Y161.326 I-2.168 J-.408 E.01341
G1 X193.119 Y163.24 E.08377
G1 X193.119 Y163.777 E.01663
G1 X191.046 Y161.705 E.09073
G3 X190.857 Y162.052 I-1.855 J-.786 E.01228
G1 X193.119 Y164.315 E.09903
G1 X193.119 Y164.852 E.01663
G1 X190.639 Y162.372 E.10856
G3 X190.395 Y162.665 I-1.613 J-1.097 E.01183
G1 X193.119 Y165.389 E.11925
G1 X193.119 Y165.926 E.01663
G1 X190.124 Y162.932 E.13108
G3 X189.828 Y163.172 I-1.371 J-1.385 E.01184
G1 X193.119 Y166.463 E.14406
G1 X193.119 Y167.001 E.01663
G1 X189.504 Y163.386 E.15822
G3 X189.152 Y163.571 I-1.116 J-1.702 E.01234
G1 X193.119 Y167.538 E.17365
G1 X193.119 Y167.958 E.01301
G3 X193.098 Y168.055 I-.154 J.018 E.00311
G1 X188.767 Y163.724 E.18959
G3 X188.346 Y163.84 I-.8 J-2.077 E.01354
G1 X192.626 Y168.119 E.18732
G1 X192.088 Y168.119 E.01663
G1 X187.882 Y163.913 E.18413
G3 X187.363 Y163.931 I-.354 J-2.622 E.01609
G1 X191.551 Y168.119 E.18332
G1 X191.014 Y168.119 E.01663
G1 X186.755 Y163.86 E.18643
G3 X185.986 Y163.628 I.748 J-3.867 E.02492
G1 X190.477 Y168.119 E.1966
G1 X189.94 Y168.119 E.01663
G1 X173.703 Y151.882 E.71075
G1 X174.24 Y151.882 E.01663
G1 X183.872 Y161.514 E.42163
G3 X183.64 Y160.745 I3.637 J-1.517 E.02492
G1 X174.778 Y151.883 E.38795
G1 X175.315 Y151.883 E.01663
G1 X183.569 Y160.137 E.36132
G3 X183.587 Y159.618 I2.642 J-.165 E.01609
G1 X175.852 Y151.883 E.33862
G1 X176.389 Y151.883 E.01663
M73 P86 R1
G1 X183.66 Y159.154 E.31829
G3 X183.776 Y158.733 I2.196 J.38 E.01354
G1 X176.927 Y151.883 E.29986
G1 X177.464 Y151.883 E.01663
G1 X183.929 Y158.348 E.28303
G3 X184.114 Y157.996 I1.884 J.763 E.01234
G1 X178.001 Y151.883 E.26759
G1 X178.538 Y151.883 E.01663
G1 X184.328 Y157.672 E.25343
G3 X184.568 Y157.376 I1.629 J1.077 E.01184
G1 X179.075 Y151.883 E.24045
G1 X179.613 Y151.883 E.01663
G1 X184.835 Y157.105 E.22862
G3 X185.128 Y156.861 I1.387 J1.366 E.01183
G1 X180.15 Y151.883 E.21792
G1 X180.687 Y151.883 E.01663
G1 X185.448 Y156.643 E.20839
G3 X185.795 Y156.454 I1.138 J1.672 E.01228
G1 X181.224 Y151.883 E.20009
G1 X181.762 Y151.883 E.01663
G1 X186.173 Y156.295 E.19312
G3 X186.589 Y156.173 I3.362 J10.734 E.01341
G1 X182.299 Y151.883 E.1878
G1 X182.836 Y151.883 E.01663
G1 X187.048 Y156.095 E.18437
G3 X187.559 Y156.069 I.389 J2.627 E.01587
G1 X183.373 Y151.883 E.18323
G1 X183.91 Y151.883 E.01663
G1 X188.148 Y156.121 E.18551
G3 X188.882 Y156.317 I-.797 J4.442 E.02355
G1 X184.448 Y151.883 E.19412
G1 X184.985 Y151.883 E.01663
G1 X193.119 Y160.017 E.35606
G1 X193.119 Y159.48 E.01663
G1 X185.522 Y151.883 E.33255
G1 X186.059 Y151.883 E.01663
G1 X193.119 Y158.943 E.30903
G1 X193.119 Y158.405 E.01663
G1 X186.597 Y151.883 E.28551
G1 X187.134 Y151.883 E.01663
G1 X193.119 Y157.868 E.262
G1 X193.119 Y157.331 E.01663
G1 X187.671 Y151.883 E.23848
G1 X188.208 Y151.883 E.01663
G1 X193.119 Y156.794 E.21496
G1 X193.119 Y156.257 E.01663
G1 X188.746 Y151.883 E.19144
G1 X189.283 Y151.883 E.01663
G1 X193.119 Y155.719 E.16793
G1 X193.119 Y155.182 E.01663
G1 X189.82 Y151.883 E.14441
G1 X190.357 Y151.883 E.01663
G1 X193.119 Y154.645 E.12089
G1 X193.119 Y154.108 E.01663
G1 X190.894 Y151.883 E.09737
G1 X191.432 Y151.883 E.01663
G1 X193.119 Y153.57 E.07386
G1 X193.119 Y153.033 E.01663
G1 X191.969 Y151.883 E.05034
G1 X192.506 Y151.883 E.01663
G1 X193.289 Y152.666 E.03425
; CHANGE_LAYER
; Z_HEIGHT: 4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X192.581 Y151.959 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 20/28
; update layer progress
M73 L20
M991 S0 P19 ;notify layer change
G17
G3 Z4.2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X186.932 Y163.156
G1 Z4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F12000
M204 S5000
G1 X186.72 Y163.112 E.00663
G3 X187.346 Y156.794 I.781 J-3.113 E.2808
G1 X187.5 Y156.79 E.00472
G3 X187.029 Y163.174 I.002 J3.21 E.32445
G1 X186.991 Y163.167 E.00121
; WIPE_START
M204 S10000
G1 X186.72 Y163.112 E-.10473
G1 X186.419 Y163.022 E-.1197
G1 X186.127 Y162.902 E-.1197
G1 X186.044 Y162.857 E-.03587
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I-.696 J.999 P1  F60000
G1 X193.416 Y167.991 Z4.4
G1 Z4
G1 E.4 F1800
G1 F12000
M204 S5000
G3 X192.991 Y168.416 I-.418 J.007 E.02058
G1 X147.009 Y168.416 E1.41291
G3 X146.584 Y167.991 I-.007 J-.418 E.02058
G1 X146.584 Y152.009 E.49109
G3 X147.009 Y151.584 I.418 J-.007 E.02058
G1 X193.054 Y151.589 E1.41483
G3 X193.416 Y152.009 I-.053 J.412 E.01864
G1 X193.416 Y167.931 E.48925
; WIPE_START
M204 S10000
G1 X193.39 Y168.143 E-.08119
G1 X193.303 Y168.284 E-.06284
G1 X193.143 Y168.39 E-.07279
G1 X192.991 Y168.416 E-.05862
G1 X192.716 Y168.416 E-.10456
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I.755 J-.954 P1  F60000
G1 X192.454 Y168.208 Z4.4
G1 Z4
G1 E.4 F1800
; FEATURE: Top surface
G1 F12000
M204 S2000
G1 X193.208 Y167.454 E.03277
G1 X193.342 Y167.32
G1 X193.342 Y166.787
G1 X193.208 Y166.921
G1 X191.921 Y168.208 E.05595
G1 X191.787 Y168.342
G1 X191.254 Y168.342
G1 X191.388 Y168.208
G1 X193.208 Y166.387 E.07912
G1 X193.342 Y166.254
G1 X193.342 Y165.721
G1 X193.208 Y165.854
G1 X190.854 Y168.208 E.10229
G1 X190.721 Y168.342
G1 X190.187 Y168.342
G1 X190.321 Y168.208
G1 X193.208 Y165.321 E.12546
G1 X193.342 Y165.187
G1 X193.342 Y164.654
G1 X193.208 Y164.788
G1 X189.788 Y168.208 E.14864
G1 X189.654 Y168.342
G1 X189.121 Y168.342
G1 X189.254 Y168.208
G1 X193.208 Y164.254 E.17181
G1 X193.342 Y164.121
G1 X193.342 Y163.588
G1 X193.208 Y163.721
G1 X188.721 Y168.208 E.19498
G1 X188.588 Y168.342
G1 X188.054 Y168.342
G1 X188.188 Y168.208
G1 X193.208 Y163.188 E.21816
G1 X193.342 Y163.054
G1 X193.342 Y162.521
G1 X193.208 Y162.655
G1 X187.655 Y168.208 E.24133
G1 X187.521 Y168.342
G1 X186.988 Y168.342
G1 X187.121 Y168.208
G1 X193.208 Y162.121 E.2645
G1 X193.342 Y161.988
G1 X193.342 Y161.455
G1 X193.208 Y161.588
G1 X186.588 Y168.208 E.28767
G1 X186.455 Y168.342
G1 X185.921 Y168.342
G1 X186.055 Y168.208
G1 X193.208 Y161.055 E.31085
G1 X193.342 Y160.921
G1 X193.342 Y160.388
G1 X193.208 Y160.522
G1 X185.522 Y168.208 E.33402
G1 X185.388 Y168.342
G1 X184.855 Y168.342
G1 X184.988 Y168.208
G1 X193.208 Y159.988 E.35719
G1 X193.342 Y159.855
G1 X193.342 Y159.322
G1 X193.208 Y159.455
G1 X184.455 Y168.208 E.38036
G1 X184.322 Y168.342
G1 X183.788 Y168.342
G1 X183.922 Y168.208
G1 X189.123 Y163.007 E.22601
G1 X189.257 Y162.874
G1 X188.401 Y163.196
G1 X188.268 Y163.329
G1 X183.389 Y168.208 E.21202
G1 X183.255 Y168.342
G1 X182.722 Y168.342
G1 X182.855 Y168.208
G1 X187.65 Y163.414 E.20834
G1 X187.783 Y163.28
G1 X187.267 Y163.263
G1 X187.133 Y163.397
G1 X182.322 Y168.208 E.20907
G1 X182.188 Y168.342
G1 X181.655 Y168.342
G1 X181.789 Y168.208
G1 X186.68 Y163.317 E.21253
G1 X186.813 Y163.184
G1 X186.408 Y163.056
G1 X186.275 Y163.189
G1 X181.256 Y168.208 E.2181
G1 X181.122 Y168.342
G1 X180.589 Y168.342
G1 X180.722 Y168.208
G1 X185.907 Y163.023 E.22531
G1 X186.041 Y162.89
G1 X185.708 Y162.689
G1 X185.575 Y162.823
G1 X180.189 Y168.208 E.23403
G1 X180.055 Y168.342
G1 X179.522 Y168.342
G1 X179.656 Y168.208
G1 X185.273 Y162.591 E.2441
G1 X185.407 Y162.457
G1 X185.135 Y162.196
G1 X185.001 Y162.33
G1 X179.123 Y168.208 E.25544
G1 X178.989 Y168.342
G1 X178.456 Y168.342
G1 X178.589 Y168.208
G1 X184.758 Y162.04 E.26806
G1 X184.892 Y161.906
G1 X184.68 Y161.584
G1 X184.547 Y161.718
G1 X178.056 Y168.208 E.28204
G1 X177.922 Y168.342
G1 X177.389 Y168.342
G1 X177.523 Y168.208
G1 X184.367 Y161.364 E.29743
G1 X184.501 Y161.23
G1 X184.358 Y160.84
G1 X184.224 Y160.973
M73 P87 R1
G1 X176.99 Y168.208 E.31439
G1 X176.856 Y168.342
G1 X176.323 Y168.342
G1 X176.456 Y168.208
G1 X184.126 Y160.539 E.33328
G1 X184.26 Y160.405
G1 X184.217 Y159.914
G1 X184.084 Y160.048
G1 X175.923 Y168.208 E.35462
G1 X175.789 Y168.342
G1 X175.256 Y168.342
G1 X175.39 Y168.208
G1 X184.124 Y159.474 E.37953
G1 X184.257 Y159.341
G1 X184.457 Y158.607
G1 X184.324 Y158.741
G1 X174.857 Y168.208 E.4114
; WIPE_START
M204 S10000
G1 X175.564 Y167.501 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I.532 J1.094 P1  F60000
G1 X193.208 Y158.922 Z4.4
G1 Z4
G1 E.4 F1800
G1 F12000
M204 S2000
G1 X190.507 Y161.623 E.11737
G1 X190.374 Y161.757
G1 X190.696 Y160.901
G1 X190.829 Y160.768
G1 X193.208 Y158.389 E.10338
G1 X193.342 Y158.255
G1 X193.342 Y157.722
G1 X193.208 Y157.855
G1 X190.914 Y160.15 E.0997
G1 X190.78 Y160.283
G1 X190.764 Y159.767
G1 X190.897 Y159.633
G1 X193.208 Y157.322 E.10043
G1 X193.342 Y157.188
G1 X193.342 Y156.655
G1 X193.208 Y156.789
G1 X190.817 Y159.18 E.1039
G1 X190.684 Y159.313
G1 X190.556 Y158.908
G1 X190.689 Y158.775
G1 X193.208 Y156.256 E.10946
G1 X193.342 Y156.122
G1 X193.342 Y155.589
G1 X193.208 Y155.722
G1 X190.523 Y158.407 E.11668
G1 X190.39 Y158.541
G1 X190.189 Y158.208
G1 X190.323 Y158.075
G1 X193.208 Y155.189 E.12539
G1 X193.342 Y155.055
G1 X193.342 Y154.522
G1 X193.208 Y154.656
G1 X190.091 Y157.773 E.13546
G1 X189.957 Y157.907
G1 X189.696 Y157.635
G1 X189.83 Y157.501
G1 X193.208 Y154.123 E.14681
G1 X193.342 Y153.989
G1 X193.342 Y153.456
G1 X193.208 Y153.589
G1 X189.54 Y157.258 E.15942
G1 X189.406 Y157.392
G1 X189.084 Y157.18
G1 X189.218 Y157.047
G1 X193.208 Y153.056 E.1734
G1 X193.342 Y152.922
G1 X193.342 Y152.389
G1 X193.208 Y152.523
G1 X188.864 Y156.867 E.18879
G1 X188.73 Y157.001
G1 X188.34 Y156.858
G1 X188.473 Y156.724
G1 X193.206 Y151.992 E.20566
G1 X193.34 Y151.858
G1 X193.006 Y151.658
G1 X192.873 Y151.792
G1 X188.039 Y156.626 E.21007
G1 X187.905 Y156.76
G1 X187.414 Y156.717
G1 X187.548 Y156.584
G1 X192.339 Y151.792 E.20823
G1 X192.473 Y151.658
G1 X191.94 Y151.658
G1 X191.806 Y151.792
G1 X186.974 Y156.624 E.20997
G1 X186.841 Y156.757
G1 X186.107 Y156.957
G1 X186.241 Y156.824
G1 X191.273 Y151.792 E.21867
G1 X191.407 Y151.658
G1 X190.873 Y151.658
G1 X190.74 Y151.792
G1 X174.323 Y168.208 E.71337
G1 X174.19 Y168.342
G1 X173.656 Y168.342
G1 X173.79 Y168.208
G1 X190.206 Y151.792 E.71337
G1 X190.34 Y151.658
G1 X189.807 Y151.658
G1 X189.673 Y151.792
G1 X173.257 Y168.208 E.71337
G1 X173.123 Y168.342
G1 X172.59 Y168.342
G1 X172.723 Y168.208
G1 X189.14 Y151.792 E.71337
G1 X189.274 Y151.658
G1 X188.74 Y151.658
G1 X188.607 Y151.792
G1 X181.437 Y158.962 E.31157
G1 X181.303 Y159.095
G1 X181.157 Y158.708
G1 X181.291 Y158.574
G1 X188.073 Y151.792 E.29473
G1 X188.207 Y151.658
G1 X187.674 Y151.658
G1 X187.54 Y151.792
G1 X181.145 Y158.187 E.27788
G1 X181.012 Y158.32
G1 X181.561 Y158.837
G1 X181.428 Y158.971
G1 X172.19 Y168.208 E.40142
G1 X172.057 Y168.342
G1 X171.523 Y168.342
G1 X171.657 Y168.208
G1 X180.909 Y158.957 E.40203
G1 X181.042 Y158.823
G1 X181.273 Y158.059
G1 X181.139 Y158.193
G1 X171.124 Y168.208 E.43521
G1 X170.99 Y168.342
G1 X170.457 Y168.342
G1 X170.59 Y168.208
G1 X187.007 Y151.792 E.71337
G1 X187.141 Y151.658
G1 X186.607 Y151.658
G1 X186.474 Y151.792
G1 X170.057 Y168.208 E.71337
G1 X169.924 Y168.342
G1 X169.39 Y168.342
G1 X169.524 Y168.208
G1 X185.94 Y151.792 E.71337
G1 X186.074 Y151.658
G1 X185.541 Y151.658
G1 X185.407 Y151.792
G1 X168.991 Y168.208 E.71337
G1 X168.857 Y168.342
G1 X168.324 Y168.342
G1 X168.457 Y168.208
G1 X184.874 Y151.792 E.71337
G1 X185.008 Y151.658
G1 X184.474 Y151.658
G1 X184.341 Y151.792
G1 X167.924 Y168.208 E.71337
G1 X167.791 Y168.342
G1 X167.257 Y168.342
G1 X167.391 Y168.208
G1 X183.807 Y151.792 E.71337
G1 X183.941 Y151.658
G1 X183.408 Y151.658
G1 X183.274 Y151.792
G1 X166.858 Y168.208 E.71337
G1 X166.724 Y168.342
G1 X166.191 Y168.342
G1 X166.324 Y168.208
G1 X182.741 Y151.792 E.71337
G1 X182.875 Y151.658
G1 X182.341 Y151.658
G1 X182.208 Y151.792
G1 X165.791 Y168.208 E.71337
G1 X165.658 Y168.342
G1 X165.124 Y168.342
G1 X165.258 Y168.208
G1 X181.674 Y151.792 E.71337
G1 X181.808 Y151.658
G1 X181.275 Y151.658
G1 X181.141 Y151.792
G1 X164.725 Y168.208 E.71337
G1 X164.591 Y168.342
G1 X164.058 Y168.342
G1 X164.191 Y168.208
M73 P88 R1
G1 X180.608 Y151.792 E.71337
G1 X180.741 Y151.658
G1 X180.208 Y151.658
G1 X180.075 Y151.792
G1 X163.658 Y168.208 E.71337
G1 X163.524 Y168.342
G1 X162.991 Y168.342
G1 X163.125 Y168.208
G1 X179.541 Y151.792 E.71337
G1 X179.675 Y151.658
G1 X179.142 Y151.658
G1 X179.008 Y151.792
G1 X162.592 Y168.208 E.71337
G1 X162.458 Y168.342
G1 X161.925 Y168.342
G1 X162.058 Y168.208
G1 X178.475 Y151.792 E.71337
G1 X178.608 Y151.658
G1 X178.075 Y151.658
G1 X177.942 Y151.792
G1 X161.525 Y168.208 E.71337
G1 X161.391 Y168.342
G1 X160.858 Y168.342
G1 X160.992 Y168.208
G1 X177.408 Y151.792 E.71337
G1 X177.542 Y151.658
G1 X177.009 Y151.658
G1 X176.875 Y151.792
G1 X160.459 Y168.208 E.71337
G1 X160.325 Y168.342
G1 X159.792 Y168.342
G1 X159.925 Y168.208
G1 X176.342 Y151.792 E.71337
G1 X176.475 Y151.658
G1 X175.942 Y151.658
G1 X175.809 Y151.792
G1 X159.392 Y168.208 E.71337
G1 X159.258 Y168.342
G1 X158.725 Y168.342
G1 X158.859 Y168.208
G1 X162.873 Y164.194 E.17444
G1 X163.007 Y164.06
G1 X162.785 Y164.282
G1 X162.919 Y164.148
G1 X175.275 Y151.792 E.53694
G1 X175.409 Y151.658
G1 X174.876 Y151.658
G1 X174.742 Y151.792
G1 X158.326 Y168.208 E.71337
G1 X158.192 Y168.342
G1 X157.659 Y168.342
G1 X157.792 Y168.208
G1 X174.209 Y151.792 E.71337
G1 X174.342 Y151.658
G1 X173.809 Y151.658
G1 X173.675 Y151.792
G1 X157.259 Y168.208 E.71337
G1 X157.125 Y168.342
G1 X156.592 Y168.342
G1 X156.726 Y168.208
G1 X173.142 Y151.792 E.71337
G1 X173.276 Y151.658
G1 X172.743 Y151.658
G1 X172.609 Y151.792
G1 X156.193 Y168.208 E.71337
G1 X156.059 Y168.342
G1 X155.526 Y168.342
G1 X155.659 Y168.208
G1 X172.076 Y151.792 E.71337
G1 X172.209 Y151.658
G1 X171.676 Y151.658
G1 X171.542 Y151.792
G1 X155.126 Y168.208 E.71337
G1 X154.992 Y168.342
G1 X154.459 Y168.342
G1 X154.593 Y168.208
G1 X171.009 Y151.792 E.71337
G1 X171.143 Y151.658
G1 X170.61 Y151.658
G1 X170.476 Y151.792
G1 X154.059 Y168.208 E.71337
G1 X153.926 Y168.342
G1 X153.393 Y168.342
G1 X153.526 Y168.208
G1 X169.943 Y151.792 E.71337
G1 X170.076 Y151.658
G1 X169.543 Y151.658
G1 X169.409 Y151.792
G1 X152.993 Y168.208 E.71337
G1 X152.859 Y168.342
G1 X152.326 Y168.342
G1 X152.46 Y168.208
G1 X163.08 Y157.587 E.46152
G1 X163.214 Y157.454
G1 X163.022 Y157.646
G1 X163.155 Y157.513
G1 X168.876 Y151.792 E.2486
G1 X169.01 Y151.658
G1 X168.477 Y151.658
G1 X168.343 Y151.792
G1 X151.926 Y168.208 E.71337
G1 X151.793 Y168.342
G1 X151.26 Y168.342
G1 X151.393 Y168.208
G1 X167.81 Y151.792 E.71337
G1 X167.943 Y151.658
G1 X167.41 Y151.658
G1 X167.276 Y151.792
G1 X150.86 Y168.208 E.71337
G1 X150.726 Y168.342
G1 X150.193 Y168.342
G1 X150.327 Y168.208
G1 X166.743 Y151.792 E.71337
G1 X166.877 Y151.658
G1 X166.344 Y151.658
G1 X166.21 Y151.792
G1 X149.793 Y168.208 E.71337
G1 X149.66 Y168.342
G1 X149.127 Y168.342
G1 X149.26 Y168.208
G1 X165.677 Y151.792 E.71337
G1 X165.81 Y151.658
G1 X165.277 Y151.658
G1 X165.143 Y151.792
G1 X148.727 Y168.208 E.71337
G1 X148.593 Y168.342
G1 X148.06 Y168.342
G1 X148.194 Y168.208
G1 X164.61 Y151.792 E.71337
G1 X164.744 Y151.658
G1 X164.21 Y151.658
G1 X164.077 Y151.792
G1 X147.66 Y168.208 E.71337
G1 X147.527 Y168.342
G1 X146.993 Y168.342
G1 X147.127 Y168.208
G1 X163.544 Y151.792 E.71337
G1 X163.677 Y151.658
G1 X163.144 Y151.658
G1 X163.01 Y151.792
G1 X146.794 Y168.008 E.70468
G1 X146.66 Y168.142
G1 X146.658 Y167.611
G1 X146.792 Y167.477
M73 P89 R1
G1 X162.477 Y151.792 E.6816
G1 X162.611 Y151.658
G1 X162.077 Y151.658
G1 X161.944 Y151.792
G1 X146.792 Y166.944 E.65843
G1 X146.658 Y167.077
G1 X146.658 Y166.544
G1 X146.792 Y166.411
G1 X161.411 Y151.792 E.63526
G1 X161.544 Y151.658
G1 X161.011 Y151.658
G1 X160.877 Y151.792
G1 X146.792 Y165.877 E.61208
G1 X146.658 Y166.011
G1 X146.658 Y165.478
G1 X146.792 Y165.344
G1 X160.344 Y151.792 E.58891
G1 X160.478 Y151.658
G1 X159.944 Y151.658
G1 X159.811 Y151.792
G1 X146.792 Y164.811 E.56574
G1 X146.658 Y164.944
G1 X146.658 Y164.411
G1 X146.792 Y164.278
G1 X159.278 Y151.792 E.54257
G1 X159.411 Y151.658
G1 X158.878 Y151.658
G1 X158.744 Y151.792
G1 X146.792 Y163.744 E.51939
G1 X146.658 Y163.878
G1 X146.658 Y163.345
G1 X146.792 Y163.211
G1 X158.211 Y151.792 E.49622
G1 X158.345 Y151.658
G1 X157.811 Y151.658
G1 X157.678 Y151.792
G1 X146.792 Y162.678 E.47305
G1 X146.658 Y162.811
G1 X146.658 Y162.278
G1 X146.792 Y162.144
G1 X157.145 Y151.792 E.44988
G1 X157.278 Y151.658
G1 X156.745 Y151.658
G1 X156.611 Y151.792
G1 X146.792 Y161.611 E.4267
G1 X146.658 Y161.745
G1 X146.658 Y161.212
G1 X146.792 Y161.078
G1 X156.078 Y151.792 E.40353
G1 X156.212 Y151.658
G1 X155.678 Y151.658
G1 X155.545 Y151.792
G1 X146.792 Y160.545 E.38036
G1 X146.658 Y160.678
G1 X146.658 Y160.145
G1 X146.792 Y160.011
G1 X155.011 Y151.792 E.35719
G1 X155.145 Y151.658
G1 X154.612 Y151.658
G1 X154.478 Y151.792
G1 X146.792 Y159.478 E.33401
G1 X146.658 Y159.612
G1 X146.658 Y159.079
G1 X146.792 Y158.945
G1 X153.945 Y151.792 E.31084
G1 X154.079 Y151.658
G1 X153.545 Y151.658
G1 X153.412 Y151.792
G1 X146.792 Y158.412 E.28767
G1 X146.658 Y158.545
G1 X146.658 Y158.012
G1 X146.792 Y157.878
G1 X152.878 Y151.792 E.2645
G1 X153.012 Y151.658
G1 X152.479 Y151.658
G1 X152.345 Y151.792
G1 X146.792 Y157.345 E.24132
G1 X146.658 Y157.479
G1 X146.658 Y156.946
G1 X146.792 Y156.812
G1 X151.812 Y151.792 E.21815
G1 X151.946 Y151.658
G1 X151.412 Y151.658
G1 X151.279 Y151.792
G1 X146.792 Y156.279 E.19498
G1 X146.658 Y156.412
G1 X146.658 Y155.879
G1 X146.792 Y155.745
G1 X150.745 Y151.792 E.1718
G1 X150.879 Y151.658
G1 X150.346 Y151.658
G1 X150.212 Y151.792
G1 X146.792 Y155.212 E.14863
G1 X146.658 Y155.346
G1 X146.658 Y154.813
G1 X146.792 Y154.679
G1 X149.679 Y151.792 E.12546
G1 X149.813 Y151.658
G1 X149.279 Y151.658
G1 X149.146 Y151.792
G1 X146.792 Y154.146 E.10229
G1 X146.658 Y154.279
G1 X146.658 Y153.746
G1 X146.792 Y153.612
G1 X148.612 Y151.792 E.07911
G1 X148.746 Y151.658
G1 X148.213 Y151.658
G1 X148.079 Y151.792
G1 X146.792 Y153.079 E.05594
G1 X146.658 Y153.213
G1 X146.658 Y152.679
G1 X146.792 Y152.546
G1 X147.546 Y151.792 E.03277
M204 S10000
G1 X147.269 Y151.773 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.290589
G1 F15000
G2 X146.952 Y151.925 I.327 J1.083 E.00712
G1 X146.913 Y151.969 E.00118
G2 X146.773 Y152.268 I1.584 J.925 E.00668
; WIPE_START
G1 X146.913 Y151.969 E-.16969
G1 X146.952 Y151.925 E-.02991
G1 X147.269 Y151.773 E-.18041
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I-.209 J1.199 P1  F60000
G1 X184.548 Y158.278 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.0997357
G1 F15000
G1 X184.462 Y158.392 E.00066
; WIPE_START
G1 X184.548 Y158.278 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I.852 J.869 P1  F60000
G1 X185.892 Y156.962 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.0997338
G1 F15000
G1 X185.778 Y157.048 E.00066
; WIPE_START
G1 X185.892 Y156.962 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I-.909 J.809 P1  F60000
G1 X190.347 Y161.964 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.125441
G1 F15000
G1 X189.926 Y162.425 E.0042
G1 X189.464 Y162.847 E.00421
; WIPE_START
G1 X189.926 Y162.425 E-.23785
G1 X190.178 Y162.149 E-.14215
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.4 I-1.068 J.583 P1  F60000
G1 X193.227 Y167.731 Z4.4
G1 Z4
G1 E.4 F1800
; LINE_WIDTH: 0.290689
G1 F15000
G3 X193.074 Y168.048 I-1.084 J-.327 E.00713
G1 X193.031 Y168.087 E.00118
G3 X192.731 Y168.227 I-.926 J-1.586 E.00669
; CHANGE_LAYER
; Z_HEIGHT: 4.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X193.031 Y168.087 E-.1697
G1 X193.074 Y168.048 E-.02989
G1 X193.227 Y167.731 E-.18041
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 21/28
; update layer progress
M73 L21
M991 S0 P20 ;notify layer change
M106 S252.45
G17
G3 Z4.4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3381
G1 X181.151 Y157.481 E.02025
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.104 E.00228
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G3 X180.585 Y159.8 I-28.422 J-7.634 E.0397
G1 X179.706 Y162.413 E.0847
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.207 Y156.576 I-2.975 J.924 E.03351
G2 X179.197 Y156.236 I-.857 J.875 E.03389
G1 X179.085 Y156.245 E.00346
G1 X179.085 Y155.713 E.01633
G3 X179.86 Y155.684 I.635 J6.609 E.02386
G3 X181.029 Y156.382 I-.049 J1.409 E.04363
G3 X181.5 Y157.295 I-6.006 J3.675 E.03159
G1 X183.423 Y162.413 E.16801
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.464 J-17.876 E.0502
G1 X181.007 Y158.56 E.01032
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276496
G1 F3381
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.319812
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360079
G1 X180.238 Y159.689 E.01177
; LINE_WIDTH: 0.401453
G1 X179.928 Y160.531 E.02623
; LINE_WIDTH: 0.446958
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492463
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.492673
G1 F3381
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454183
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415694
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379324
G1 X182.012 Y159.669 E.01048
; LINE_WIDTH: 0.345102
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.31088
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.281041
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255602
G1 X181.592 Y158.367 E.00523
G1 X180.916 Y156.572 F60000
; LINE_WIDTH: 0.315225
G1 F3381
G1 X180.918 Y157.534 E.02133
G1 X181.036 Y157.24 F60000
; LINE_WIDTH: 0.434839
G1 F3381
G1 X180.886 Y156.925 E.01115
G2 X180.463 Y156.296 I-1.994 J.886 E.02434
; LINE_WIDTH: 0.391361
G2 X180.266 Y156.147 I-.753 J.792 E.00701
; LINE_WIDTH: 0.351348
G1 X180.099 Y156.065 E.00469
; LINE_WIDTH: 0.310544
G1 X179.951 Y156.017 E.00337
; LINE_WIDTH: 0.279598
G1 X179.839 Y155.992 E.00222
; LINE_WIDTH: 0.252684
G1 X179.707 Y155.973 E.00229
; LINE_WIDTH: 0.208675
G1 X179.281 Y155.965 E.00575
; WIPE_START
G1 F15000
G1 X179.707 Y155.973 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10163
G3 X176.465 Y157.789 I1.035 J-.056 E.02879
G3 X177.337 Y157.616 I.694 J1.217 E.0278
G3 X178.043 Y157.72 I-.135 J3.365 E.02196
M73 P90 R1
G1 X178.043 Y158.134 E.01271
G2 X177.283 Y158.283 I-.226 J.862 E.02463
G2 X177.013 Y159.003 I.694 J.67 E.0243
G1 X177.013 Y161.871 E.08811
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.156395
G1 F3381
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203705
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251014
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298324
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345633
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392943
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440252
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487561
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534871
G1 X176.563 Y162.172 E.00113
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.13274
G1 F3381
G1 X177.79 Y162.172 E.00712
; WIPE_START
G1 F15000
G1 X176.817 Y162.172 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-1.215 J-.066 P1  F60000
G1 X176.749 Y163.423 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.230061
G1 F3381
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565836
G1 X176.563 Y162.172 E.00303
; LINE_WIDTH: 0.551784
G3 X176.564 Y158.982 I107.768 J-1.559 E.13228
G1 X176.583 Y158.638 E.01429
; LINE_WIDTH: 0.613631
G3 X176.641 Y158.37 I1.241 J.125 E.01277
G1 X176.718 Y158.214 E.00809
G3 X177.126 Y157.808 I3.022 J2.629 E.02679
G1 X176.355 Y158.304 F60000
; LINE_WIDTH: 0.422819
G1 F3381
G3 X177.469 Y157.822 I5.871 J12.047 E.0376
G1 X177.306 Y157.811 F60000
; LINE_WIDTH: 0.543442
G1 F3381
G2 X176.321 Y158.488 I3.419 J6.032 E.04881
; WIPE_START
G1 F14984.378
G1 X176.835 Y158.104 E-.24415
G1 X177.139 Y157.915 E-.13585
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-.66 J-1.023 P1  F60000
G1 X171.365 Y161.64 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G1 X171.368 Y161.642 E.0001
G2 X171.841 Y161.978 I.587 J-.326 E.01843
G2 X173.158 Y161.92 I.562 J-2.212 E.04106
G2 X173.589 Y161.44 I-.37 J-.767 E.02034
G1 X174.346 Y161.519 E.02339
G3 X173.258 Y162.421 I-1.368 J-.544 E.04528
G3 X171.22 Y162.291 I-.812 J-3.319 E.06374
G3 X170.796 Y160.362 I.462 J-1.113 E.07115
G3 X171.669 Y159.93 I1.309 J1.547 E.03025
G2 X173.117 Y159.579 I-8.359 J-37.683 E.04576
G2 X173.704 Y159.02 I-.211 J-.81 E.02601
G2 X173.087 Y158.131 I-.716 J-.162 E.03741
G2 X171.604 Y158.183 I-.641 J2.878 E.04612
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.416 Y157.711 I1.36 J.552 E.04447
G3 X172.676 Y157.608 I1.038 J4.922 E.03893
G3 X174.127 Y158.084 I.014 J2.406 E.04775
G3 X174.499 Y159.289 I-.856 J.925 E.0406
G3 X173.766 Y160.122 I-1.11 J-.238 E.03562
G3 X171.962 Y160.603 I-3.989 J-11.336 E.05742
G2 X171.383 Y160.964 I.238 J1.026 E.02135
G2 X171.296 Y161.444 I.573 J.351 E.01531
G1 X171.346 Y161.584 E.00457
M204 S10000
G1 X171.069 Y161.796 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.300321
G1 F3381
G1 X171.151 Y161.887 E.00257
; LINE_WIDTH: 0.271606
G1 X171.193 Y161.929 E.00111
; LINE_WIDTH: 0.234952
G1 X171.335 Y162.035 E.00276
; LINE_WIDTH: 0.187684
G2 X171.521 Y162.13 I.723 J-1.18 E.00247
; LINE_WIDTH: 0.127801
G2 X172.755 Y162.264 I.914 J-2.674 E.00865
G1 X172.981 Y162.232 E.00158
; LINE_WIDTH: 0.149797
G2 X173.264 Y162.152 I-.619 J-2.738 E.00257
G1 X173.332 Y162.125 E.00063
; LINE_WIDTH: 0.197172
G2 X173.52 Y162.024 I-.698 J-1.524 E.00268
; LINE_WIDTH: 0.243997
G2 X173.643 Y161.932 I-.739 J-1.125 E.00252
G1 X173.663 Y161.915 E.00043
; LINE_WIDTH: 0.301087
G2 X173.746 Y161.834 I-.825 J-.926 E.00242
G1 X173.781 Y161.793 E.00114
G1 X174.027 Y161.717 E.00542
; WIPE_START
G1 F15000
G1 X173.781 Y161.793 E-.22921
G1 X173.746 Y161.834 E-.04825
G1 X173.663 Y161.915 E-.10255
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I.056 J-1.216 P1  F60000
G1 X171.069 Y161.796 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.344739
G1 F3381
G3 X170.986 Y161.665 I.903 J-.67 E.00382
; LINE_WIDTH: 0.393916
G1 X170.98 Y161.654 E.00036
G3 X170.92 Y161.498 I1.359 J-.608 E.00477
; LINE_WIDTH: 0.436894
G3 X170.888 Y161.231 I.947 J-.25 E.00869
; LINE_WIDTH: 0.482495
G3 X171.229 Y160.531 I.81 J-.038 E.02906
; LINE_WIDTH: 0.430607
G1 X171.352 Y160.452 E.0046
G3 X171.505 Y160.376 I1.77 J3.367 E.00541
; LINE_WIDTH: 0.380653
G1 X171.527 Y160.366 E.00066
G3 X172.849 Y160.03 I3.013 J9.061 E.03759
G1 X173.244 Y159.921 E.01126
G1 X173.509 Y159.818 E.00782
; LINE_WIDTH: 0.425182
G2 X173.718 Y159.702 I-.647 J-1.409 E.00747
; LINE_WIDTH: 0.475248
G1 X173.881 Y159.57 E.00738
G1 X173.984 Y159.441 E.00582
; LINE_WIDTH: 0.486902
G2 X174.12 Y158.973 I-.818 J-.49 E.01782
; LINE_WIDTH: 0.438834
G1 X174.117 Y158.842 E.00422
G2 X174.082 Y158.647 I-1.357 J.143 E.00639
; LINE_WIDTH: 0.390997
G2 X174.017 Y158.487 I-1.332 J.451 E.00491
; LINE_WIDTH: 0.353886
G1 X173.976 Y158.419 E.002
; LINE_WIDTH: 0.322455
G1 X173.904 Y158.321 E.00277
; LINE_WIDTH: 0.276655
G1 X173.889 Y158.305 E.00042
G2 X173.801 Y158.216 I-.923 J.83 E.00238
; LINE_WIDTH: 0.231768
G1 X173.79 Y158.207 E.00022
G2 X173.682 Y158.123 I-.871 J1.008 E.0021
; LINE_WIDTH: 0.185785
G2 X173.48 Y158.01 I-.906 J1.381 E.0027
; LINE_WIDTH: 0.129729
G1 X173.148 Y157.901 E.00247
G1 X172.767 Y157.846 E.00273
; LINE_WIDTH: 0.122645
G1 X172.714 Y157.842 E.00034
G2 X171.48 Y157.959 I-.305 J3.354 E.0081
; LINE_WIDTH: 0.18244
G1 X171.275 Y158.047 E.00254
; LINE_WIDTH: 0.222284
G1 X171.17 Y158.109 E.00178
; LINE_WIDTH: 0.255033
G1 X171.071 Y158.182 E.00212
; LINE_WIDTH: 0.288374
G1 X170.98 Y158.265 E.00247
; LINE_WIDTH: 0.316466
G2 X170.92 Y158.356 I.039 J.091 E.00259
; LINE_WIDTH: 0.281585
G1 X170.983 Y158.495 E.00296
; WIPE_START
G1 F15000
G1 X170.92 Y158.356 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-1.135 J-.439 P1  F60000
G1 X168.829 Y163.759 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3381
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3381
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-.637 J-1.037 P1  F60000
G1 X164.661 Y161.172 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3381
G1 X164.523 Y161.196 E.00465
G1 X164.523 Y160.856 E.01127
G1 X164.739 Y160.831 E.00722
G1 X164.771 Y160.969 E.00471
G1 X164.83 Y161.144 E.00611
G1 X164.72 Y161.163 E.00368
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G3 X164.964 Y162.413 I-24.197 J-.853 E.02775
G1 X164.104 Y162.413 E.0264
G2 X164.131 Y161.61 I-13.065 J-.829 E.02468
G1 X164.131 Y157.697 E.12026
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.01 E.07107
G2 X165.323 Y161.267 I2.569 J.091 E.03999
G2 X166.478 Y161.81 I.996 J-.618 E.04145
G1 X166.668 Y161.788 E.0059
G1 X166.668 Y162.495 E.02172
G3 X165.801 Y162.23 I-.211 J-.863 E.02923
G3 X165.424 Y161.442 I2.46 J-1.663 E.02694
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X165.849 Y161.944 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.125332
G1 F3381
G2 X166.355 Y162.31 I8.079 J-10.622 E.0042
G1 X166.472 Y162.302 F60000
; LINE_WIDTH: 0.22451
G1 F3381
G1 X165.868 Y161.976 E.01017
G1 X165.9 Y162.031 F60000
; LINE_WIDTH: 0.275582
G1 F3381
G1 X166.165 Y162.131 E.00536
; LINE_WIDTH: 0.326435
G2 X166.3 Y162.157 I.224 J-.788 E.00319
G1 X166.472 Y162.165 E.00398
; WIPE_START
G1 F15000
G1 X166.3 Y162.157 E-.21108
G1 X166.165 Y162.131 E-.16892
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I.839 J-.882 P1  F60000
G1 X164.607 Y160.649 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.56692
G1 F3381
G1 X164.588 Y160.018 E.02696
G1 X164.588 Y157.893 E.09073
; WIPE_START
G1 F14312.979
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z4.6
G1 Z4.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3381
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3381
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168412
G1 F3381
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.21607
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263728
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.312349
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.361936
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.411524
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461112
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3381
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.6 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z4.6
G1 Z4.2
G1 E.4 F1800
; LINE_WIDTH: 0.463829
G1 F3381
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.419652
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365791
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 4.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 22/28
; update layer progress
M73 L22
M991 S0 P21 ;notify layer change
G17
G3 Z4.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3376
G1 X181.151 Y157.481 E.02025
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.103 E.00228
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G3 X180.585 Y159.8 I-28.476 J-7.65 E.03969
G1 X179.706 Y162.413 E.08471
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.208 Y156.576 I-2.978 J.925 E.03351
G2 X179.198 Y156.236 I-.857 J.875 E.03386
G1 X179.085 Y156.245 E.0035
G1 X179.085 Y155.713 E.01634
G3 X179.86 Y155.684 I.641 J6.816 E.02385
G3 X181.029 Y156.382 I-.048 J1.408 E.04364
G3 X181.5 Y157.295 I-6.003 J3.673 E.03159
G1 X183.423 Y162.413 E.16801
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.569 J-17.905 E.0502
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276524
G1 F3376
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.319849
G1 X180.39 Y159.26 E.01069
; LINE_WIDTH: 0.36008
G1 X180.238 Y159.688 E.01175
; LINE_WIDTH: 0.401416
G1 X179.929 Y160.531 E.02623
; LINE_WIDTH: 0.446935
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492455
G1 X179.309 Y162.217 E.0329
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.492672
G1 F3376
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454179
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415687
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379324
G1 X182.012 Y159.669 E.01047
; LINE_WIDTH: 0.345101
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310878
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.28106
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255621
G1 X181.592 Y158.367 E.00523
G1 X180.916 Y156.572 F60000
; LINE_WIDTH: 0.315226
G1 F3376
G1 X180.918 Y157.534 E.02133
G1 X181.033 Y157.246 F60000
; LINE_WIDTH: 0.435978
G1 F3376
G2 X180.463 Y156.296 I-2.519 J.867 E.03574
; LINE_WIDTH: 0.391337
G2 X180.265 Y156.147 I-.753 J.791 E.00705
; LINE_WIDTH: 0.351254
G1 X180.099 Y156.065 E.00467
; LINE_WIDTH: 0.31056
G1 X179.951 Y156.017 E.00338
; LINE_WIDTH: 0.279563
G1 X179.839 Y155.992 E.00222
; LINE_WIDTH: 0.252715
G1 X179.707 Y155.973 E.00228
; LINE_WIDTH: 0.208604
G1 X179.281 Y155.965 E.00575
; WIPE_START
G1 F15000
G1 X179.707 Y155.973 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10163
G3 X176.462 Y157.791 I1.037 J-.056 E.0287
G3 X177.337 Y157.616 I.697 J1.212 E.02788
M73 P91 R1
G3 X178.043 Y157.72 I-.135 J3.365 E.02197
G1 X178.037 Y158.132 E.01267
G2 X177.283 Y158.283 I-.214 J.894 E.0244
G2 X177.013 Y159.014 I.698 J.672 E.02462
G1 X177.013 Y161.871 E.08779
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.156396
G1 F3376
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203706
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251017
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298327
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345638
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392948
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440259
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487569
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.53488
G1 X176.563 Y162.172 E.00113
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.13274
G1 F3376
G1 X177.79 Y162.172 E.00712
; WIPE_START
G1 F15000
G1 X176.817 Y162.172 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-1.215 J-.066 P1  F60000
G1 X176.749 Y163.423 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.230061
M73 P91 R0
G1 F3376
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565838
G1 X176.563 Y162.172 E.00303
; LINE_WIDTH: 0.551743
G3 X176.564 Y158.998 I150.498 J-1.544 E.1316
G1 X176.583 Y158.638 E.01495
; LINE_WIDTH: 0.613597
G3 X176.702 Y158.239 I1.035 J.089 E.01949
G1 X176.719 Y158.213 E.00146
G3 X177.125 Y157.808 I2.971 J2.58 E.0267
G1 X176.356 Y158.302 F60000
; LINE_WIDTH: 0.42227
G1 F3376
G3 X177.471 Y157.822 I5.798 J11.923 E.03754
G1 X177.306 Y157.811 F60000
; LINE_WIDTH: 0.543515
G1 F3376
G2 X176.321 Y158.488 I3.425 J6.041 E.04881
; WIPE_START
G1 F14982.189
G1 X176.835 Y158.104 E-.24392
G1 X177.139 Y157.915 E-.13608
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-.661 J-1.022 P1  F60000
G1 X171.379 Y161.644 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G2 X171.937 Y162 I.612 J-.344 E.02118
G2 X173.157 Y161.92 I.476 J-2.079 E.03812
G2 X173.589 Y161.44 I-.379 J-.775 E.02032
G1 X174.346 Y161.519 E.0234
G3 X173.264 Y162.419 I-1.366 J-.542 E.04511
G3 X171.222 Y162.292 I-.818 J-3.319 E.06385
G3 X170.823 Y160.336 I.454 J-1.111 E.07242
G3 X171.757 Y159.906 I1.327 J1.652 E.03191
G2 X173.073 Y159.594 I-20.362 J-88.985 E.04157
G2 X173.705 Y159.019 I-.179 J-.831 E.02749
G2 X173.037 Y158.119 I-.747 J-.144 E.03873
G2 X171.603 Y158.183 I-.588 J2.897 E.04453
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.415 Y157.711 I1.36 J.552 E.04441
G3 X172.675 Y157.608 I1.04 J4.918 E.03898
G3 X174.132 Y158.089 I.007 J2.423 E.04797
G3 X174.23 Y159.809 I-.843 J.911 E.05852
G3 X173.199 Y160.312 I-1.426 J-1.614 E.03568
G2 X171.877 Y160.629 I19.893 J85.812 E.04179
G2 X171.31 Y161.129 I.154 J.746 E.02427
G2 X171.352 Y161.591 I.681 J.172 E.01453
M204 S10000
G1 X171.091 Y161.822 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.285271
G1 F3376
G2 X171.195 Y161.93 I1.029 J-.894 E.00297
; LINE_WIDTH: 0.23761
G2 X171.305 Y162.015 I.734 J-.834 E.0022
G1 X171.315 Y162.022 E.00019
; LINE_WIDTH: 0.190379
G2 X171.521 Y162.13 I.678 J-1.036 E.0028
; LINE_WIDTH: 0.127549
G2 X171.888 Y162.234 I.624 J-1.507 E.00264
G1 X172.151 Y162.267 E.00183
G1 X172.447 Y162.279 E.00205
G1 X172.876 Y162.25 E.00296
; LINE_WIDTH: 0.145
G2 X173.264 Y162.153 I-.257 J-1.853 E.00334
G1 X173.321 Y162.129 E.00051
; LINE_WIDTH: 0.194101
G1 X173.502 Y162.035 E.00251
; LINE_WIDTH: 0.230251
G1 X173.599 Y161.967 E.00181
; LINE_WIDTH: 0.259987
G1 X173.683 Y161.896 E.00194
; LINE_WIDTH: 0.303803
G1 X173.781 Y161.793 E.00302
G1 X174.024 Y161.722 E.00538
; WIPE_START
G1 F15000
G1 X173.781 Y161.793 E-.24354
G1 X173.683 Y161.896 E-.13646
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I.035 J-1.216 P1  F60000
G1 X171.091 Y161.822 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.319573
G1 F3376
G1 X171.049 Y161.767 E.00156
; LINE_WIDTH: 0.353567
G1 X170.979 Y161.651 E.00343
; LINE_WIDTH: 0.399328
G1 X170.914 Y161.469 E.00561
; LINE_WIDTH: 0.446091
G1 X170.895 Y161.36 E.00366
G3 X170.894 Y161.126 I1.415 J-.121 E.00769
; LINE_WIDTH: 0.485851
G1 X170.926 Y160.954 E.00633
G1 X170.988 Y160.8 E.00598
G3 X171.226 Y160.535 I.757 J.44 E.01293
; LINE_WIDTH: 0.430778
G1 X171.512 Y160.374 E.01039
; LINE_WIDTH: 0.380469
G1 X171.574 Y160.348 E.00183
G3 X173.069 Y159.973 I4.81 J16.006 E.04243
G1 X173.196 Y159.936 E.00363
G2 X173.509 Y159.818 I-.909 J-2.892 E.00919
; LINE_WIDTH: 0.422673
G2 X173.691 Y159.719 I-.701 J-1.515 E.00644
; LINE_WIDTH: 0.468219
G1 X173.813 Y159.632 E.00518
G1 X173.94 Y159.502 E.00632
; LINE_WIDTH: 0.485726
G2 X174.121 Y158.931 I-.68 J-.53 E.02207
; LINE_WIDTH: 0.436618
G1 X174.12 Y158.907 E.00077
G2 X174.083 Y158.652 I-.85 J-.004 E.00829
; LINE_WIDTH: 0.392062
G2 X174.02 Y158.494 I-.811 J.23 E.00487
; LINE_WIDTH: 0.355186
G1 X173.971 Y158.412 E.00241
; LINE_WIDTH: 0.321604
G1 X173.913 Y158.333 E.00222
; LINE_WIDTH: 0.298089
G1 X173.874 Y158.29 E.00123
; LINE_WIDTH: 0.266115
G1 X173.781 Y158.198 E.00237
; LINE_WIDTH: 0.22827
G1 X173.682 Y158.123 E.00187
; LINE_WIDTH: 0.185421
G1 X173.478 Y158.008 E.00272
; LINE_WIDTH: 0.124651
G1 X173.364 Y157.963 E.00082
G2 X171.505 Y157.95 I-.954 J3.51 E.01252
; LINE_WIDTH: 0.180047
G1 X171.275 Y158.047 E.00279
; LINE_WIDTH: 0.221844
G1 X171.17 Y158.109 E.00178
; LINE_WIDTH: 0.255244
G1 X171.071 Y158.182 E.00213
; LINE_WIDTH: 0.288372
G1 X170.98 Y158.265 E.00246
; LINE_WIDTH: 0.31637
G2 X170.92 Y158.357 I.038 J.091 E.0026
; LINE_WIDTH: 0.280939
G1 X170.983 Y158.495 E.00294
; WIPE_START
G1 F15000
G1 X170.92 Y158.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-1.135 J-.439 P1  F60000
G1 X168.829 Y163.759 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3376
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3376
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-.637 J-1.037 P1  F60000
G1 X164.661 Y161.173 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3376
G1 X164.523 Y161.196 E.00466
G1 X164.523 Y160.858 E.01124
G1 X164.737 Y160.831 E.00716
G1 X164.773 Y160.975 E.00493
G1 X164.83 Y161.144 E.00592
G1 X164.72 Y161.163 E.0037
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G3 X164.964 Y162.413 I-26.113 J-.948 E.02774
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.917 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.398 Y161.376 I2.281 J.139 E.0441
G2 X166.478 Y161.81 I.909 J-.701 E.03748
G1 X166.668 Y161.788 E.0059
G1 X166.668 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02922
G3 X165.424 Y161.442 I2.459 J-1.663 E.02696
G1 X165.071 Y161.501 E.01099
M204 S10000
G1 X165.854 Y161.952 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.149397
G1 F3376
G1 X165.981 Y162.04 E.00134
; LINE_WIDTH: 0.180512
G1 X166.415 Y162.314 E.00575
G1 X166.472 Y162.164 F60000
; LINE_WIDTH: 0.326484
G1 F3376
G1 X166.309 Y162.158 E.00378
G3 X166.167 Y162.131 I.038 J-.583 E.00335
; LINE_WIDTH: 0.281893
G1 X166.123 Y162.115 E.00091
; LINE_WIDTH: 0.237894
G1 X165.874 Y161.986 E.00445
; WIPE_START
G1 F15000
G1 X166.123 Y162.115 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I.846 J-.875 P1  F60000
G1 X164.607 Y160.65 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.566927
G1 F3376
G1 X164.588 Y160.017 E.02702
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.787
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z4.8
G1 Z4.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3376
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3376
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3376
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3376
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z4.8 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z4.8
G1 Z4.4
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3376
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 4.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 23/28
; update layer progress
M73 L23
M991 S0 P22 ;notify layer change
G17
G3 Z4.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3408
G1 X181.151 Y157.481 E.02024
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.103 E.00228
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G3 X180.585 Y159.8 I-28.45 J-7.642 E.0397
G1 X179.706 Y162.413 E.0847
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.208 Y156.576 I-2.978 J.925 E.0335
G2 X179.199 Y156.236 I-.857 J.875 E.03385
G1 X179.085 Y156.245 E.00351
G1 X179.091 Y155.712 E.01636
G3 X179.86 Y155.684 I.641 J7.015 E.02367
G3 X181.029 Y156.382 I-.047 J1.407 E.04365
G3 X181.5 Y157.295 I-6.002 J3.672 E.03159
G1 X183.423 Y162.413 E.168
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.505 J-17.887 E.0502
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276501
G1 F3408
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.31982
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360085
G1 X180.238 Y159.689 E.01176
; LINE_WIDTH: 0.401431
G1 X179.928 Y160.531 E.02623
; LINE_WIDTH: 0.446944
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492458
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.492671
G1 F3408
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454176
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415681
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379322
G1 X182.012 Y159.669 E.01048
; LINE_WIDTH: 0.345095
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310868
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.281044
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255611
G1 X181.592 Y158.367 E.00523
G1 X180.916 Y156.572 F60000
; LINE_WIDTH: 0.315205
G1 F3408
G1 X180.918 Y157.534 E.02133
G1 X181.034 Y157.246 F60000
; LINE_WIDTH: 0.436024
G1 F3408
G2 X180.464 Y156.297 I-2.525 J.87 E.03569
; LINE_WIDTH: 0.391351
G2 X180.265 Y156.147 I-.754 J.791 E.00712
; LINE_WIDTH: 0.351185
G1 X180.099 Y156.065 E.00465
; LINE_WIDTH: 0.310561
G1 X179.951 Y156.017 E.00338
; LINE_WIDTH: 0.279516
G1 X179.839 Y155.992 E.00223
; LINE_WIDTH: 0.252658
G1 X179.706 Y155.973 E.00229
; LINE_WIDTH: 0.208507
G1 X179.281 Y155.965 E.00574
; WIPE_START
G1 F15000
G1 X179.706 Y155.973 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10162
G3 X176.465 Y157.789 I1.003 J-.069 E.02885
M73 P92 R0
G3 X177.337 Y157.616 I.672 J1.104 E.02788
G3 X178.043 Y157.72 I-.135 J3.366 E.02198
G1 X178.043 Y158.134 E.01272
G2 X177.201 Y158.368 I-.219 J.843 E.02814
G2 X177.013 Y159.003 I.954 J.626 E.02064
G1 X177.013 Y161.871 E.08812
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13274
G1 F3408
G1 X177.79 Y162.172 E.00712
; WIPE_START
G1 F15000
G1 X176.817 Y162.172 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-1.215 J-.066 P1  F60000
G1 X176.749 Y163.423 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.230061
G1 F3408
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565836
G1 X176.563 Y162.172 E.00303
; LINE_WIDTH: 0.534871
G1 X176.591 Y162.172 E.00113
; LINE_WIDTH: 0.487561
G1 X176.619 Y162.172 E.00102
; LINE_WIDTH: 0.440252
G1 X176.647 Y162.172 E.00091
; LINE_WIDTH: 0.392943
G1 X176.676 Y162.172 E.0008
; LINE_WIDTH: 0.345633
G1 X176.704 Y162.172 E.0007
; LINE_WIDTH: 0.298324
G1 X176.732 Y162.172 E.00059
; LINE_WIDTH: 0.251014
G1 X176.76 Y162.172 E.00048
; LINE_WIDTH: 0.203705
G1 X176.788 Y162.172 E.00037
; LINE_WIDTH: 0.156395
G1 X176.817 Y162.172 E.00026
G1 X176.563 Y162.172 F60000
; LINE_WIDTH: 0.551867
G1 F3408
G3 X176.564 Y158.982 I107.914 J-1.559 E.13231
G1 X176.584 Y158.631 E.01457
; LINE_WIDTH: 0.620355
G3 X176.605 Y158.502 I1.889 J.246 E.00616
G1 X176.654 Y158.332 E.00834
G1 X176.72 Y158.211 E.00649
; LINE_WIDTH: 0.604504
G1 X176.805 Y158.128 E.00542
; LINE_WIDTH: 0.552238
G1 X176.868 Y158.081 E.00328
; LINE_WIDTH: 0.512287
G1 X177.341 Y157.813 E.02079
G1 X176.394 Y158.187 F60000
; LINE_WIDTH: 0.31285
G1 F3408
G3 X177.598 Y157.837 I4.692 J13.892 E.02758
G1 X177.507 Y157.826 F60000
; LINE_WIDTH: 0.410765
G1 F3408
G2 X176.353 Y158.313 I1.988 J6.332 E.0376
; WIPE_START
G1 F15000
G1 X177.037 Y157.994 E-.28685
G1 X177.268 Y157.911 E-.09315
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-.652 J-1.028 P1  F60000
G1 X171.372 Y161.651 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G1 X171.436 Y161.741 E.00339
G2 X171.854 Y161.981 I.523 J-.427 E.01513
G2 X173.157 Y161.92 I.547 J-2.291 E.04064
G2 X173.589 Y161.44 I-.37 J-.767 E.02035
G1 X174.347 Y161.519 E.0234
G3 X173.264 Y162.419 I-1.358 J-.532 E.04515
G3 X171.222 Y162.292 I-.817 J-3.319 E.06385
G3 X170.823 Y160.336 I.454 J-1.111 E.07243
G3 X171.757 Y159.906 I1.327 J1.653 E.03192
G2 X173.117 Y159.579 I-9.919 J-44.281 E.04297
G2 X173.705 Y159.019 I-.205 J-.803 E.02605
G2 X173.037 Y158.119 I-.747 J-.144 E.03872
G2 X171.604 Y158.183 I-.588 J2.903 E.04452
G2 X171.1 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.416 Y157.711 I1.331 J.517 E.04458
G3 X172.675 Y157.607 I1.038 J4.919 E.03892
G3 X174.064 Y158.032 I-.018 J2.541 E.04525
G3 X174.232 Y159.807 I-.772 J.969 E.06115
G3 X173.199 Y160.312 I-1.451 J-1.659 E.03575
G2 X171.876 Y160.63 I19.798 J85.41 E.0418
G2 X171.31 Y161.129 I.155 J.747 E.02426
G2 X171.346 Y161.597 I.649 J.185 E.01474
M204 S10000
G1 X171.048 Y161.767 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.296553
G1 F3408
G2 X171.405 Y162.155 I2.396 J-1.847 E.01091
; WIPE_START
G1 F15000
G1 X171.048 Y161.767 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I.02 J1.217 P1  F60000
G1 X174.026 Y161.719 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.302266
G1 F3408
G1 X173.781 Y161.794 E.0054
G1 X173.745 Y161.834 E.00115
G3 X173.663 Y161.915 I-.985 J-.92 E.00243
; LINE_WIDTH: 0.240345
G1 X173.653 Y161.925 E.00023
G3 X173.501 Y162.036 I-2.301 J-2.978 E.00302
; LINE_WIDTH: 0.192982
G1 X173.312 Y162.133 E.00261
; LINE_WIDTH: 0.141972
G1 X173.041 Y162.22 E.0023
G3 X172.813 Y162.258 I-.688 J-3.405 E.00186
; LINE_WIDTH: 0.127877
G1 X172.756 Y162.264 E.0004
G3 X171.521 Y162.13 I-.319 J-2.818 E.00867
; LINE_WIDTH: 0.19033
G3 X171.315 Y162.022 I.47 J-1.143 E.00281
; LINE_WIDTH: 0.252259
G1 X171.305 Y162.015 E.0002
G3 X170.731 Y161.516 I2.69 J-3.674 E.01298
G1 X171.048 Y161.767 F60000
; LINE_WIDTH: 0.354544
G1 F3408
G1 X170.975 Y161.644 E.00364
; LINE_WIDTH: 0.3976
G3 X170.92 Y161.496 I1.307 J-.574 E.00459
; LINE_WIDTH: 0.44061
G3 X170.89 Y161.178 I.984 J-.253 E.01039
; LINE_WIDTH: 0.484135
G3 X171.232 Y160.53 I.792 J.004 E.02737
; LINE_WIDTH: 0.431012
G1 X171.255 Y160.512 E.00094
G3 X171.501 Y160.378 I.703 J.996 E.00887
; LINE_WIDTH: 0.381723
G1 X171.574 Y160.348 E.00217
G3 X173.072 Y159.973 I4.839 J16.124 E.04265
G1 X173.359 Y159.88 E.00834
G1 X173.574 Y159.786 E.00648
; LINE_WIDTH: 0.441092
G1 X173.662 Y159.738 E.00324
G2 X173.814 Y159.631 I-.892 J-1.426 E.00604
; LINE_WIDTH: 0.484564
G2 X174.121 Y158.931 I-.542 J-.655 E.02854
; LINE_WIDTH: 0.433927
G1 X174.12 Y158.907 E.00077
G2 X174.072 Y158.619 I-.918 J.005 E.00933
; LINE_WIDTH: 0.382967
G1 X174.001 Y158.461 E.0048
; LINE_WIDTH: 0.337362
G1 X173.932 Y158.357 E.003
; LINE_WIDTH: 0.29156
G1 X173.833 Y158.245 E.00303
; LINE_WIDTH: 0.249933
G1 X173.746 Y158.17 E.00193
; LINE_WIDTH: 0.208566
G1 X173.688 Y158.128 E.00097
G2 X173.593 Y158.067 I-.678 J.959 E.00153
; LINE_WIDTH: 0.159825
G1 X173.313 Y157.946 E.0029
; LINE_WIDTH: 0.122717
G1 X173.202 Y157.914 E.00075
G2 X171.48 Y157.959 I-.77 J3.539 E.0113
; LINE_WIDTH: 0.18221
G1 X171.387 Y157.994 E.00113
G2 X171.275 Y158.047 I.624 J1.462 E.00141
; LINE_WIDTH: 0.222761
G1 X171.17 Y158.109 E.00179
; LINE_WIDTH: 0.255261
G1 X171.071 Y158.182 E.00212
; LINE_WIDTH: 0.28838
G1 X170.98 Y158.265 E.00246
; LINE_WIDTH: 0.316385
G2 X170.92 Y158.357 I.038 J.091 E.0026
; LINE_WIDTH: 0.281011
G1 X170.983 Y158.495 E.00294
; WIPE_START
G1 F15000
G1 X170.92 Y158.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-1.135 J-.439 P1  F60000
G1 X168.829 Y163.759 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3408
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3408
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-.637 J-1.037 P1  F60000
G1 X164.66 Y161.172 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3408
G1 X164.523 Y161.195 E.00463
G1 X164.523 Y160.858 E.01121
G1 X164.737 Y160.831 E.00716
G1 X164.771 Y160.968 E.00467
G1 X164.826 Y161.145 E.00615
G1 X164.719 Y161.163 E.00359
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G3 X164.964 Y162.413 I-24.232 J-.855 E.02775
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.916 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.398 Y161.376 I2.281 J.139 E.04411
G2 X166.478 Y161.81 I.905 J-.691 E.03751
G1 X166.668 Y161.788 E.00591
G1 X166.668 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02922
G3 X165.424 Y161.442 I2.46 J-1.663 E.02695
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X165.848 Y161.943 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.12079
G1 F3408
G2 X166.355 Y162.31 I6.991 J-9.111 E.00397
G1 X166.472 Y162.299 F60000
; LINE_WIDTH: 0.225392
G1 F3408
G3 X165.868 Y161.976 I3.118 J-6.557 E.0102
G1 X165.901 Y162.033 F60000
; LINE_WIDTH: 0.281054
G1 F3408
G1 X166.166 Y162.132 E.00548
; LINE_WIDTH: 0.326495
G2 X166.302 Y162.158 I.21 J-.724 E.0032
G1 X166.472 Y162.165 E.00394
; WIPE_START
G1 F15000
G1 X166.302 Y162.158 E-.20993
G1 X166.166 Y162.132 E-.17007
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I.838 J-.882 P1  F60000
G1 X164.607 Y160.649 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.566927
G1 F3408
G1 X164.588 Y160.017 E.02701
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.791
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z5
G1 Z4.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3408
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3408
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3408
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3408
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z5
G1 Z4.6
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3408
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 4.8
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 24/28
; update layer progress
M73 L24
M991 S0 P23 ;notify layer change
G17
G3 Z5 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3427
G1 X181.151 Y157.481 E.02025
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.104 E.00227
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G3 X180.585 Y159.8 I-28.412 J-7.63 E.03969
G1 X179.706 Y162.413 E.08471
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.208 Y156.576 I-2.978 J.925 E.03351
G2 X179.199 Y156.236 I-.857 J.875 E.03384
G1 X179.085 Y156.245 E.00351
G1 X179.085 Y155.713 E.01633
G3 X179.86 Y155.684 I.587 J5.29 E.02385
G3 X181.029 Y156.381 I-.049 J1.411 E.04364
G3 X181.5 Y157.296 I-5.841 J3.589 E.03163
G1 X183.423 Y162.413 E.16797
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.565 J-17.904 E.0502
G1 X181.007 Y158.56 E.01032
M204 S10000
G1 X180.695 Y158.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276512
G1 F3427
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.31983
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360081
G1 X180.238 Y159.688 E.01176
; LINE_WIDTH: 0.401432
G1 X179.929 Y160.531 E.02623
; LINE_WIDTH: 0.446946
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.49246
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.492674
G1 F3427
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454186
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415698
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379327
G1 X182.012 Y159.669 E.01047
; LINE_WIDTH: 0.345111
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310895
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.281063
G1 X181.684 Y158.655 E.00586
; LINE_WIDTH: 0.255631
G1 X181.592 Y158.367 E.00523
G1 X180.916 Y156.57 F60000
; LINE_WIDTH: 0.315242
G1 F3427
G1 X180.918 Y157.534 E.02139
G1 X181.034 Y157.244 F60000
; LINE_WIDTH: 0.435707
G1 F3427
G1 X180.887 Y156.925 E.01124
G2 X180.479 Y156.311 I-2.025 J.905 E.02371
; LINE_WIDTH: 0.393095
G2 X180.266 Y156.147 I-.741 J.741 E.00768
; LINE_WIDTH: 0.356209
G1 X180.147 Y156.086 E.00341
; LINE_WIDTH: 0.318021
G1 X179.952 Y156.017 E.00463
; LINE_WIDTH: 0.269706
G1 X179.871 Y155.998 E.00155
G2 X179.746 Y155.978 I-.363 J1.9 E.00234
; LINE_WIDTH: 0.224954
G1 X179.512 Y155.961 E.00348
; LINE_WIDTH: 0.197443
G1 X179.281 Y155.965 E.0029
; WIPE_START
G1 F15000
G1 X179.512 Y155.961 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-1.123 J-.47 P1  F60000
G1 X177.013 Y161.931 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
M73 P93 R0
G1 X176.114 Y158.624 E.10162
G3 X176.413 Y157.831 I1.071 J-.05 E.02676
G3 X177.162 Y157.612 I.664 J.879 E.02453
G1 X177.336 Y157.616 E.00535
G3 X178.043 Y157.72 I-.135 J3.367 E.02198
G1 X178.043 Y158.134 E.01271
G2 X177.201 Y158.368 I-.219 J.844 E.02813
G2 X177.013 Y159.026 I1.018 J.646 E.0213
G1 X177.013 Y161.871 E.08743
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.156396
G1 F3427
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203706
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251016
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298327
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345637
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392947
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440258
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487568
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534878
G1 X176.563 Y162.172 E.00113
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.13274
G1 F3427
G1 X177.79 Y162.172 E.00712
; WIPE_START
G1 F15000
G1 X176.817 Y162.172 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-1.215 J-.066 P1  F60000
G1 X176.749 Y163.423 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.230061
G1 F3427
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565835
G1 X176.563 Y162.172 E.00304
; LINE_WIDTH: 0.551684
G3 X176.564 Y159.012 I149.763 J-1.542 E.13103
G1 X176.583 Y158.64 E.01543
; LINE_WIDTH: 0.608807
G3 X176.689 Y158.258 I1.067 J.091 E.01839
G1 X176.714 Y158.219 E.00213
G3 X177.145 Y157.808 I2.502 J2.195 E.0275
G1 X177.331 Y157.812 F60000
; LINE_WIDTH: 0.510991
G1 F3427
G1 X176.874 Y158.078 E.02019
; LINE_WIDTH: 0.550763
G1 X176.318 Y158.521 E.0294
G1 X176.353 Y158.314 F60000
; LINE_WIDTH: 0.410972
G1 F3427
G3 X177.508 Y157.826 I3.095 J5.728 E.03767
G1 X177.599 Y157.837 F60000
; LINE_WIDTH: 0.310316
G1 F3427
G2 X176.395 Y158.186 I3.349 J13.813 E.02733
; WIPE_START
G1 F15000
G1 X177.204 Y157.939 E-.32131
G1 X177.353 Y157.9 E-.05869
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-.646 J-1.032 P1  F60000
G1 X171.369 Y161.647 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G1 X171.438 Y161.739 E.00355
G2 X171.841 Y161.978 I.524 J-.427 E.0147
G2 X173.2 Y161.899 I.562 J-2.065 E.04257
G2 X173.589 Y161.44 I-.418 J-.748 E.01887
G1 X174.347 Y161.519 E.02341
G3 X173.183 Y162.439 I-1.397 J-.572 E.04765
G3 X171.295 Y162.323 I-.727 J-3.611 E.05879
G3 X170.852 Y160.31 I.379 J-1.139 E.07621
G3 X171.757 Y159.906 I1.291 J1.675 E.03073
G2 X173.093 Y159.587 I-13.509 J-59.646 E.04222
G2 X173.705 Y159.019 I-.19 J-.817 E.02684
G2 X173.037 Y158.119 I-.746 J-.144 E.03874
G2 X171.604 Y158.183 I-.588 J2.903 E.04452
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.416 Y157.711 I1.335 J.522 E.04456
G3 X172.675 Y157.607 I1.038 J4.918 E.03892
G3 X174.125 Y158.082 I.013 J2.411 E.04769
G3 X174.493 Y159.321 I-.851 J.926 E.0417
G3 X173.766 Y160.122 I-1.157 J-.32 E.03445
G3 X172.149 Y160.555 I-3.46 J-9.685 E.05151
G2 X171.384 Y160.963 I.143 J1.19 E.02725
G2 X171.347 Y161.592 I.579 J.35 E.02015
M204 S10000
G1 X171.107 Y161.84 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.31713
G1 F3427
G1 X171.082 Y161.813 E.00083
G3 X170.686 Y161.28 I4.812 J-3.992 E.01484
; WIPE_START
G1 F15000
G1 X171.082 Y161.813 E-.35991
G1 X171.107 Y161.84 E-.02009
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I1.207 J-.155 P1  F60000
G1 X170.665 Y158.411 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.32295
G1 F3427
G1 X170.912 Y158.339 E.00588
G1 X170.98 Y158.265 E.0023
; LINE_WIDTH: 0.287912
G1 X171.071 Y158.182 E.00246
; LINE_WIDTH: 0.255263
G1 X171.17 Y158.109 E.00212
; LINE_WIDTH: 0.222712
G1 X171.275 Y158.047 E.00179
; LINE_WIDTH: 0.182244
G3 X171.387 Y157.994 I.758 J1.46 E.00141
G1 X171.48 Y157.959 E.00113
; LINE_WIDTH: 0.121993
G3 X172.962 Y157.867 I.954 J3.417 E.00963
G1 X173.199 Y157.913 E.00156
; LINE_WIDTH: 0.149378
G1 X173.549 Y158.043 E.00324
; LINE_WIDTH: 0.201212
G3 X173.733 Y158.16 I-.804 J1.475 E.00281
; LINE_WIDTH: 0.245919
G1 X173.824 Y158.237 E.00197
; LINE_WIDTH: 0.284637
G1 X173.914 Y158.334 E.0026
; LINE_WIDTH: 0.331067
G1 X173.997 Y158.454 E.00342
; LINE_WIDTH: 0.366392
G1 X174.033 Y158.52 E.00199
; LINE_WIDTH: 0.401691
G3 X174.094 Y158.691 I-.688 J.338 E.0053
; LINE_WIDTH: 0.443157
G3 X174.12 Y158.907 I-1.035 J.238 E.00712
G1 X174.118 Y158.988 E.00264
; LINE_WIDTH: 0.488087
G3 X173.981 Y159.446 I-.819 J.005 E.01762
; LINE_WIDTH: 0.478585
G3 X173.757 Y159.675 I-.804 J-.564 E.01144
; LINE_WIDTH: 0.429235
G1 X173.509 Y159.818 E.00901
; LINE_WIDTH: 0.379886
G1 X173.211 Y159.931 E.00874
G1 X172.761 Y160.05 E.01279
; LINE_WIDTH: 0.383007
G2 X171.48 Y160.387 I1.238 J7.306 E.03677
G1 X171.407 Y160.422 E.00222
; LINE_WIDTH: 0.443975
G2 X171.183 Y160.568 I.505 J1.022 E.00876
; LINE_WIDTH: 0.489612
G2 X170.902 Y161.059 I.483 J.602 E.02109
; LINE_WIDTH: 0.454017
G1 X170.888 Y161.236 E.00594
G1 X170.904 Y161.423 E.00631
; LINE_WIDTH: 0.409572
G2 X170.959 Y161.611 I1.48 J-.332 E.00584
; LINE_WIDTH: 0.363909
G2 X171.224 Y162.073 I2.457 J-1.104 E.01396
G1 X171.107 Y161.84 F60000
; LINE_WIDTH: 0.282429
G1 F3427
G1 X171.19 Y161.926 E.00233
; LINE_WIDTH: 0.243633
G1 X171.286 Y162.002 E.002
; LINE_WIDTH: 0.20926
G1 X171.398 Y162.072 E.0018
; LINE_WIDTH: 0.176472
G2 X171.562 Y162.147 I1.211 J-2.44 E.00196
; LINE_WIDTH: 0.128864
G2 X172.634 Y162.273 I.841 J-2.524 E.00762
G1 X172.98 Y162.233 E.00244
G1 X173.215 Y162.17 E.0017
; LINE_WIDTH: 0.176514
G1 X173.451 Y162.065 E.00281
; LINE_WIDTH: 0.215916
G1 X173.552 Y162.002 E.00169
; LINE_WIDTH: 0.247821
G1 X173.659 Y161.92 E.00224
; LINE_WIDTH: 0.298061
G1 X173.882 Y161.668 E.00699
; WIPE_START
G1 F15000
G1 X173.659 Y161.92 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-.433 J-1.137 P1  F60000
G1 X168.829 Y163.759 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3427
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3427
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-.637 J-1.037 P1  F60000
G1 X164.661 Y161.172 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3427
G1 X164.523 Y161.196 E.00465
G1 X164.523 Y160.858 E.01121
G1 X164.737 Y160.831 E.00716
G1 X164.773 Y160.973 E.00487
G1 X164.829 Y161.144 E.00597
G1 X164.72 Y161.163 E.00367
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G3 X164.964 Y162.413 I-24.331 J-.86 E.02775
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.916 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.399 Y161.377 I2.281 J.139 E.04412
G2 X166.477 Y161.81 I.907 J-.698 E.03746
G1 X166.668 Y161.788 E.00592
G1 X166.668 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02922
G3 X165.424 Y161.442 I2.46 J-1.664 E.02695
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X165.849 Y161.944 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.123254
G1 F3427
G2 X166.355 Y162.31 I9.343 J-12.376 E.00409
G1 X166.472 Y162.298 F60000
; LINE_WIDTH: 0.22574
G1 F3427
G3 X165.868 Y161.976 I2.926 J-6.225 E.01021
G1 X165.902 Y162.033 F60000
; LINE_WIDTH: 0.281351
G1 F3427
G1 X166.166 Y162.131 E.00548
; LINE_WIDTH: 0.326465
G2 X166.303 Y162.158 I.193 J-.635 E.00322
G1 X166.472 Y162.165 E.00392
; WIPE_START
G1 F15000
G1 X166.303 Y162.158 E-.20874
G1 X166.166 Y162.131 E-.17126
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I.838 J-.882 P1  F60000
G1 X164.607 Y160.65 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.566927
G1 F3427
G1 X164.588 Y160.017 E.02702
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.787
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z5.2
G1 Z4.8
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3427
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3427
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3427
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3427
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.2 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z5.2
G1 Z4.8
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3427
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 5
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 25/28
; update layer progress
M73 L25
M991 S0 P24 ;notify layer change
G17
G3 Z5.2 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3364
G1 X181.151 Y157.481 E.02027
G1 X181.41 Y158.17 E.02442
G1 X180.876 Y158.167 E.01769
G1 X180.902 Y158.104 E.00227
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G3 X180.585 Y159.8 I-28.446 J-7.641 E.0397
G1 X179.706 Y162.413 E.0847
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.208 Y156.576 I-2.977 J.925 E.03351
G2 X179.199 Y156.236 I-.857 J.875 E.03384
G1 X179.085 Y156.245 E.00351
G1 X179.085 Y155.713 E.01633
G3 X179.86 Y155.684 I.595 J5.476 E.02385
G3 X181.029 Y156.382 I-.049 J1.411 E.04368
G3 X181.5 Y157.296 I-5.847 J3.591 E.03159
G1 X183.423 Y162.413 E.16797
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I63.253 J-18.094 E.0502
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.363 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276545
G1 F3364
G1 X180.542 Y158.811 E.00902
; LINE_WIDTH: 0.319832
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360092
G1 X180.238 Y159.689 E.01176
; LINE_WIDTH: 0.401447
G1 X179.928 Y160.531 E.02623
; LINE_WIDTH: 0.446955
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492462
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.492671
G1 F3364
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454178
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415685
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379317
G1 X182.012 Y159.669 E.01048
; LINE_WIDTH: 0.345081
G1 X181.894 Y159.305 E.00941
; LINE_WIDTH: 0.310845
G1 X181.775 Y158.942 E.00835
; LINE_WIDTH: 0.281042
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255643
G1 X181.592 Y158.367 E.00523
G1 X180.916 Y156.57 F60000
; LINE_WIDTH: 0.315239
G1 F3364
G1 X180.918 Y157.534 E.02139
G1 X181.034 Y157.244 F60000
; LINE_WIDTH: 0.435704
G1 F3364
G1 X180.887 Y156.925 E.01123
G2 X180.479 Y156.311 I-2.028 J.906 E.02371
; LINE_WIDTH: 0.393091
G2 X180.266 Y156.147 I-.74 J.74 E.00769
; LINE_WIDTH: 0.356174
G1 X180.147 Y156.086 E.00341
; LINE_WIDTH: 0.318012
G1 X179.952 Y156.018 E.00463
; LINE_WIDTH: 0.270678
G1 X179.754 Y155.979 E.00375
; LINE_WIDTH: 0.228406
G1 X179.542 Y155.962 E.00322
; LINE_WIDTH: 0.19823
G1 X179.281 Y155.965 E.0033
; WIPE_START
G1 F15000
G1 X179.542 Y155.962 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-1.121 J-.475 P1  F60000
G1 X177.013 Y161.931 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
M73 P94 R0
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10162
G3 X176.462 Y157.791 I1.011 J-.066 E.02875
G3 X177.336 Y157.616 I.678 J1.12 E.02794
G3 X178.043 Y157.72 I-.135 J3.366 E.02198
G1 X178.043 Y158.134 E.01272
G2 X177.254 Y158.309 I-.21 J.918 E.02565
G2 X177.013 Y159.05 I.785 J.666 E.02455
G1 X177.013 Y161.871 E.08669
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13274
G1 F3364
G1 X177.79 Y162.172 E.00712
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.156395
G1 F3364
G1 X176.789 Y162.172 E.00026
; LINE_WIDTH: 0.203704
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251014
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298323
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345632
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392942
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440251
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.48756
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534869
G1 X176.563 Y162.172 E.00113
G1 X176.749 Y163.423 F60000
; LINE_WIDTH: 0.230061
G1 F3364
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565825
G1 X176.563 Y162.172 E.00304
; LINE_WIDTH: 0.551624
G3 X176.563 Y159.037 I176.755 J-1.532 E.12994
G1 X176.583 Y158.638 E.01657
; LINE_WIDTH: 0.619326
G3 X176.624 Y158.424 I1.412 J.157 E.01024
G1 X176.688 Y158.26 E.00825
G1 X176.766 Y158.161 E.00594
; LINE_WIDTH: 0.556928
G1 X176.82 Y158.114 E.00298
G3 X177.309 Y157.811 I2.267 J3.115 E.02411
G1 X177.45 Y157.82 F60000
; LINE_WIDTH: 0.427225
G1 F3364
G2 X176.959 Y158.03 I2.12 J5.624 E.01675
; LINE_WIDTH: 0.479854
G1 X176.341 Y158.36 E.02492
G1 X176.391 Y158.195 F60000
; LINE_WIDTH: 0.328862
G1 F3364
G3 X177.592 Y157.836 I4.409 J12.568 E.02922
; WIPE_START
G1 F15000
G1 X177.169 Y157.948 E-.16625
G1 X176.633 Y158.118 E-.21375
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-.689 J-1.003 P1  F60000
G1 X171.407 Y161.705 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G1 X171.417 Y161.707 E.00032
G2 X171.842 Y161.978 I.551 J-.395 E.01585
G2 X173.158 Y161.92 I.566 J-2.128 E.0411
G2 X173.589 Y161.44 I-.403 J-.796 E.02029
G1 X174.346 Y161.519 E.02339
G3 X173.183 Y162.439 I-1.392 J-.566 E.04765
G3 X171.295 Y162.323 I-.737 J-3.444 E.05885
G3 X170.852 Y160.31 I.379 J-1.139 E.07621
G3 X171.757 Y159.906 I1.291 J1.675 E.03073
G2 X173.073 Y159.594 I-20.728 J-90.544 E.04156
G2 X173.705 Y159.019 I-.172 J-.824 E.02753
G2 X173.037 Y158.119 I-.747 J-.143 E.03872
G2 X171.604 Y158.183 I-.588 J2.903 E.04452
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.346 Y158.597 E.02342
G3 X171.591 Y157.672 I1.412 J.599 E.04997
G3 X172.788 Y157.615 I.839 J4.957 E.03693
G3 X174.175 Y158.127 I-.049 J2.265 E.04628
G3 X174.184 Y159.855 I-.867 J.869 E.05888
G3 X173.309 Y160.282 I-1.354 J-1.664 E.03019
G2 X171.812 Y160.653 I7.572 J33.766 E.04739
G2 X171.323 Y161.519 I.156 J.659 E.03434
G1 X171.382 Y161.65 E.00441
M204 S10000
G1 X171.154 Y161.891 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.31748
G1 F3364
G3 X171.072 Y161.8 I.873 J-.869 E.00274
G1 X170.683 Y161.267 E.01478
; WIPE_START
G1 F15000
G1 X171.072 Y161.8 E-.32054
G1 X171.154 Y161.891 E-.05946
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I1.215 J-.061 P1  F60000
G1 X170.983 Y158.495 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.280111
G1 F3364
G1 X170.92 Y158.357 E.00292
; LINE_WIDTH: 0.316312
G3 X170.98 Y158.265 I.097 J-.002 E.00261
; LINE_WIDTH: 0.288385
G1 X171.071 Y158.182 E.00246
; LINE_WIDTH: 0.255844
G1 X171.17 Y158.109 E.00213
; LINE_WIDTH: 0.222042
G1 X171.276 Y158.047 E.00179
; LINE_WIDTH: 0.179629
G3 X171.387 Y157.994 I.866 J1.669 E.00138
G1 X171.505 Y157.95 E.00141
; LINE_WIDTH: 0.121433
G3 X172.962 Y157.867 I.928 J3.477 E.0094
G1 X173.245 Y157.926 E.00185
; LINE_WIDTH: 0.154526
G3 X173.579 Y158.059 I-.374 J1.421 E.00327
; LINE_WIDTH: 0.200253
G3 X173.695 Y158.132 I-.646 J1.164 E.00177
G1 X173.707 Y158.14 E.00018
; LINE_WIDTH: 0.242893
G3 X173.83 Y158.242 I-1.051 J1.389 E.00261
; LINE_WIDTH: 0.290807
G3 X173.932 Y158.356 I-2.088 J1.975 E.00309
; LINE_WIDTH: 0.335867
G1 X173.997 Y158.454 E.00279
; LINE_WIDTH: 0.366447
G1 X174.034 Y158.52 E.00199
; LINE_WIDTH: 0.403646
G3 X174.099 Y158.713 I-.701 J.344 E.00599
; LINE_WIDTH: 0.445061
G3 X174.12 Y158.907 I-.887 J.198 E.00641
G1 X174.118 Y158.988 E.00265
; LINE_WIDTH: 0.48664
G3 X173.84 Y159.609 I-.817 J.007 E.02538
G1 X173.81 Y159.635 E.00146
; LINE_WIDTH: 0.44109
G3 X173.668 Y159.734 I-1.763 J-2.363 E.00562
G1 X173.574 Y159.786 E.00348
; LINE_WIDTH: 0.381831
G1 X173.354 Y159.883 E.00663
G3 X171.82 Y160.266 I-8.332 J-30.119 E.04368
G1 X171.474 Y160.39 E.01015
; LINE_WIDTH: 0.435365
G2 X171.208 Y160.549 I.455 J1.065 E.00993
; LINE_WIDTH: 0.48758
G2 X170.902 Y161.059 I.461 J.624 E.02212
G1 X170.897 Y161.091 E.00118
; LINE_WIDTH: 0.452038
G2 X170.904 Y161.424 I1.074 J.143 E.01114
; LINE_WIDTH: 0.409317
G2 X170.96 Y161.611 I1.228 J-.265 E.00583
; LINE_WIDTH: 0.363298
G1 X170.973 Y161.641 E.00086
G2 X171.224 Y162.073 I3.103 J-1.517 E.01305
G1 X171.154 Y161.891 F60000
; LINE_WIDTH: 0.256207
G1 F3364
G2 X171.258 Y161.982 I.801 J-.815 E.0024
; LINE_WIDTH: 0.214355
G2 X171.398 Y162.072 I.691 J-.915 E.00233
; LINE_WIDTH: 0.176448
G2 X171.561 Y162.147 I1.777 J-3.673 E.00196
; LINE_WIDTH: 0.126772
G2 X172.814 Y162.258 I.875 J-2.764 E.00866
G1 X172.98 Y162.232 E.00115
; LINE_WIDTH: 0.152988
G1 X173.16 Y162.188 E.00166
G1 X173.372 Y162.107 E.00203
; LINE_WIDTH: 0.206919
G1 X173.557 Y161.999 E.00286
; LINE_WIDTH: 0.248627
G1 X173.658 Y161.919 E.00217
; LINE_WIDTH: 0.29801
G1 X173.882 Y161.668 E.00699
; WIPE_START
G1 F15000
G1 X173.658 Y161.919 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-.433 J-1.137 P1  F60000
G1 X168.829 Y163.759 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3364
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3364
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-.637 J-1.037 P1  F60000
G1 X164.661 Y161.172 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3364
G1 X164.523 Y161.195 E.00465
G1 X164.523 Y160.856 E.01127
G1 X164.739 Y160.831 E.00723
G1 X164.771 Y160.969 E.00469
G1 X164.829 Y161.144 E.00614
G1 X164.72 Y161.162 E.00367
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G3 X164.964 Y162.413 I-23.614 J-.821 E.02775
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.916 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.323 Y161.267 I2.569 J.091 E.04001
G2 X166.477 Y161.81 I.984 J-.593 E.04154
G1 X166.668 Y161.788 E.00592
G1 X166.668 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02923
G3 X165.424 Y161.442 I2.469 J-1.668 E.02694
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X165.868 Y161.974 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.224916
G1 F3364
G2 X166.472 Y162.298 I3.156 J-5.168 E.01017
G1 X166.472 Y162.165 F60000
; LINE_WIDTH: 0.326445
G1 F3364
G1 X166.304 Y162.158 E.0039
G3 X166.166 Y162.131 I.045 J-.601 E.00325
; LINE_WIDTH: 0.281459
G1 X165.902 Y162.034 E.00547
; WIPE_START
G1 F15000
G1 X166.166 Y162.131 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I.839 J-.882 P1  F60000
G1 X164.607 Y160.649 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.56692
G1 F3364
G1 X164.588 Y160.017 E.02698
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.978
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z5.4
G1 Z5
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3364
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3364
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3364
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3364
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.4 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z5.4
G1 Z5
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3364
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 5.2
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 26/28
; update layer progress
M73 L26
M991 S0 P25 ;notify layer change
G17
G3 Z5.4 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3411
G1 X181.151 Y157.481 E.02024
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.103 E.00228
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G3 X180.585 Y159.8 I-28.466 J-7.647 E.03969
G1 X179.706 Y162.413 E.08471
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.207 Y156.576 I-2.975 J.924 E.03351
G2 X179.199 Y156.236 I-.857 J.874 E.03384
G1 X179.085 Y156.245 E.00351
G1 X179.085 Y155.714 E.01632
G3 X179.859 Y155.684 I.595 J5.45 E.02384
G3 X181.029 Y156.381 I-.049 J1.411 E.04366
G3 X181.5 Y157.295 I-5.845 J3.591 E.03163
G1 X183.423 Y162.413 E.16798
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.482 J-17.881 E.0502
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276499
G1 F3411
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.319822
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360086
G1 X180.238 Y159.688 E.01175
; LINE_WIDTH: 0.401432
G1 X179.929 Y160.531 E.02623
; LINE_WIDTH: 0.446945
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492459
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.492671
G1 F3411
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454177
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415683
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379322
G1 X182.012 Y159.669 E.01048
; LINE_WIDTH: 0.345097
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310871
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.281048
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255625
G1 X181.592 Y158.368 E.00523
G1 X180.916 Y156.57 F60000
; LINE_WIDTH: 0.315263
G1 F3411
G1 X180.918 Y157.534 E.02139
G1 X181.034 Y157.244 F60000
; LINE_WIDTH: 0.4357
G1 F3411
G1 X180.886 Y156.923 E.01133
G2 X180.479 Y156.311 I-2.023 J.907 E.02362
; LINE_WIDTH: 0.388929
G2 X180.226 Y156.124 I-.777 J.784 E.00891
; LINE_WIDTH: 0.337912
G1 X180.194 Y156.107 E.00085
G2 X180.034 Y156.041 I-.858 J1.843 E.00417
; LINE_WIDTH: 0.289517
G2 X179.837 Y155.992 I-.552 J1.789 E.00409
; LINE_WIDTH: 0.252618
G1 X179.707 Y155.974 E.00225
; LINE_WIDTH: 0.208285
G1 X179.281 Y155.965 E.00574
; WIPE_START
G1 F15000
G1 X179.707 Y155.974 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10162
M73 P95 R0
G3 X176.464 Y157.79 I.987 J-.076 E.02886
G3 X177.336 Y157.616 I.677 J1.123 E.02788
G3 X178.043 Y157.72 I-.135 J3.367 E.02199
G1 X178.043 Y158.134 E.01271
G2 X177.199 Y158.371 I-.223 J.827 E.02827
G2 X177.013 Y159.038 I.989 J.635 E.02159
G1 X177.013 Y161.871 E.08706
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.156395
G1 F3411
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203704
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251013
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298323
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345632
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392941
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.44025
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487559
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534868
G1 X176.563 Y162.172 E.00113
; LINE_WIDTH: 0.551663
G3 X176.564 Y159.024 I168.93 J-1.536 E.13049
G1 X176.583 Y158.638 E.01604
; LINE_WIDTH: 0.61408
G3 X176.69 Y158.256 I1.066 J.094 E.01855
G1 X176.719 Y158.213 E.00243
G3 X177.123 Y157.809 I3.254 J2.852 E.0266
G1 X177.592 Y157.836 F60000
; LINE_WIDTH: 0.32774
G1 F3411
G2 X176.391 Y158.194 I3.268 J13.165 E.02911
G1 X176.351 Y158.317 F60000
; LINE_WIDTH: 0.437137
G1 F3411
G3 X177.451 Y157.82 I6.855 J13.684 E.03879
G1 X177.324 Y157.812 F60000
; LINE_WIDTH: 0.55007
G1 F3411
G2 X176.319 Y158.5 I2.408 J4.594 E.05045
; WIPE_START
G1 F14788.549
G1 X176.86 Y158.086 E-.25904
G1 X177.134 Y157.924 E-.12096
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-1.203 J.186 P1  F60000
G1 X177.79 Y162.172 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.13274
G1 F3411
G1 X176.817 Y162.172 E.00712
G1 X176.563 Y162.172 F60000
; LINE_WIDTH: 0.565831
G1 F3411
G1 X176.55 Y162.242 E.00304
; LINE_WIDTH: 0.553628
G1 X176.575 Y162.39 E.00623
; LINE_WIDTH: 0.507405
G1 X176.599 Y162.537 E.00566
; LINE_WIDTH: 0.461181
G1 X176.624 Y162.685 E.0051
; LINE_WIDTH: 0.414957
G1 X176.649 Y162.832 E.00454
; LINE_WIDTH: 0.368733
G1 X176.674 Y162.98 E.00397
; LINE_WIDTH: 0.322509
G1 X176.699 Y163.127 E.00341
; LINE_WIDTH: 0.276285
G1 X176.724 Y163.275 E.00285
; LINE_WIDTH: 0.230061
G1 X176.749 Y163.423 E.00228
; WIPE_START
G1 F15000
G1 X176.724 Y163.275 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I.34 J-1.168 P1  F60000
G1 X171.435 Y161.734 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G1 X171.469 Y161.779 E.00171
G2 X171.841 Y161.978 I.486 J-.463 E.01321
G2 X173.157 Y161.92 I.566 J-2.128 E.0411
G2 X173.589 Y161.44 I-.402 J-.796 E.02029
G1 X174.347 Y161.519 E.02341
G3 X173.184 Y162.439 I-1.382 J-.553 E.04769
G3 X171.222 Y162.292 I-.73 J-3.425 E.06127
G3 X170.852 Y160.31 I.449 J-1.109 E.07367
G3 X171.758 Y159.905 I1.37 J1.851 E.03072
G2 X173.105 Y159.583 I-11.399 J-50.617 E.04256
G2 X173.694 Y159.061 I-.216 J-.837 E.02512
G2 X173.037 Y158.119 I-.736 J-.187 E.04003
G2 X171.603 Y158.183 I-.588 J2.903 E.04453
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.591 Y157.672 I1.413 J.6 E.04993
G3 X172.788 Y157.615 I.839 J4.958 E.03692
G3 X174.174 Y158.126 I-.034 J2.225 E.04627
G3 X174.184 Y159.855 I-.868 J.87 E.05892
G3 X173.143 Y160.327 I-1.472 J-1.861 E.03549
G2 X171.876 Y160.63 I9.015 J40.519 E.04002
G2 X171.312 Y161.125 I.2 J.797 E.02396
G2 X171.364 Y161.636 I.643 J.192 E.01619
G1 X171.4 Y161.686 E.0019
M204 S10000
G1 X171.148 Y161.886 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.261843
G1 F3411
G1 X171.236 Y161.964 E.00209
; LINE_WIDTH: 0.226356
G1 X171.34 Y162.037 E.0019
; LINE_WIDTH: 0.185129
G2 X171.546 Y162.141 I.66 J-1.056 E.00268
; LINE_WIDTH: 0.127256
G2 X172.933 Y162.241 I.899 J-2.798 E.00964
G1 X173.045 Y162.218 E.00079
; LINE_WIDTH: 0.156686
G1 X173.372 Y162.107 E.0032
; LINE_WIDTH: 0.206641
G1 X173.555 Y162 E.00283
; LINE_WIDTH: 0.248342
G1 X173.658 Y161.919 E.0022
; LINE_WIDTH: 0.297989
G1 X173.882 Y161.668 E.00699
; WIPE_START
G1 F15000
G1 X173.658 Y161.919 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I.26 J-1.189 P1  F60000
G1 X170.684 Y161.268 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.317808
G1 F3411
G2 X171.077 Y161.807 I6.247 J-4.148 E.01494
G1 X171.148 Y161.886 E.00238
G1 X171.233 Y162.077 F60000
; LINE_WIDTH: 0.359646
G1 F3411
G3 X170.959 Y161.61 I3.388 J-2.306 E.01397
; LINE_WIDTH: 0.41042
G3 X170.903 Y161.418 I1.069 J-.418 E.006
; LINE_WIDTH: 0.453872
G3 X170.9 Y161.07 I1.201 J-.182 E.0117
; LINE_WIDTH: 0.487191
G1 X170.916 Y160.99 E.00296
G3 X171.223 Y160.537 I.751 J.178 E.02022
; LINE_WIDTH: 0.431836
G1 X171.257 Y160.512 E.00135
G3 X171.493 Y160.381 I.907 J1.364 E.00856
; LINE_WIDTH: 0.381852
G1 X171.764 Y160.283 E.00795
G2 X173.305 Y159.9 I-12.776 J-54.666 E.04388
G1 X173.49 Y159.827 E.0055
G2 X173.594 Y159.776 I-.704 J-1.563 E.00319
; LINE_WIDTH: 0.439376
G1 X173.613 Y159.765 E.00071
G2 X173.785 Y159.654 I-.738 J-1.328 E.00662
; LINE_WIDTH: 0.48378
G2 X174.12 Y158.928 I-.498 J-.67 E.02994
; LINE_WIDTH: 0.436377
G1 X174.12 Y158.901 E.00087
G2 X174.081 Y158.648 I-.888 J.006 E.00826
; LINE_WIDTH: 0.390674
G1 X174.016 Y158.487 E.0049
; LINE_WIDTH: 0.344868
G2 X173.941 Y158.366 I-1.407 J.795 E.00351
; LINE_WIDTH: 0.30037
G2 X173.861 Y158.276 I-1.057 J.852 E.00253
; LINE_WIDTH: 0.262397
G1 X173.777 Y158.195 E.00208
; LINE_WIDTH: 0.229575
G1 X173.69 Y158.128 E.00168
; LINE_WIDTH: 0.186305
G1 X173.476 Y158.008 E.00286
; LINE_WIDTH: 0.129494
G1 X173.202 Y157.914 E.00205
G1 X172.771 Y157.847 E.00308
; LINE_WIDTH: 0.121513
G1 X172.715 Y157.842 E.00036
G2 X171.505 Y157.95 I-.307 J3.395 E.00782
; LINE_WIDTH: 0.179715
G1 X171.387 Y157.994 E.00141
G2 X171.275 Y158.047 I.597 J1.4 E.00138
; LINE_WIDTH: 0.229603
G2 X171.126 Y158.14 I.706 J1.301 E.00268
; LINE_WIDTH: 0.27947
G1 X170.98 Y158.265 E.00369
; LINE_WIDTH: 0.316123
G2 X170.92 Y158.357 I.061 J.106 E.00254
; LINE_WIDTH: 0.280658
G1 X170.983 Y158.495 E.00293
; WIPE_START
G1 F15000
G1 X170.92 Y158.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-1.135 J-.439 P1  F60000
G1 X168.829 Y163.759 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3411
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3411
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-.637 J-1.037 P1  F60000
G1 X164.662 Y161.172 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3411
G1 X164.523 Y161.196 E.00467
G1 X164.523 Y160.856 E.01127
G1 X164.739 Y160.831 E.00723
G1 X164.772 Y160.973 E.00485
G1 X164.832 Y161.144 E.00599
G1 X164.721 Y161.162 E.00374
M204 S250
G1 X165.012 Y161.511 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G3 X164.964 Y162.413 I-23.43 J-.811 E.02775
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.918 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.323 Y161.267 I2.451 J.117 E.04005
G2 X166.477 Y161.81 I.983 J-.591 E.04155
G1 X166.668 Y161.788 E.00592
G1 X166.668 Y162.495 E.02172
G3 X165.801 Y162.23 I-.211 J-.863 E.02923
G3 X165.424 Y161.442 I2.468 J-1.667 E.02694
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X165.868 Y161.975 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.225422
G1 F3411
G2 X166.472 Y162.297 I3.119 J-5.126 E.01019
G1 X166.472 Y162.165 F60000
; LINE_WIDTH: 0.326444
G1 F3411
G1 X166.305 Y162.158 E.00387
G3 X166.166 Y162.131 I.036 J-.558 E.00328
; LINE_WIDTH: 0.281669
G1 X165.903 Y162.034 E.00547
; WIPE_START
G1 F15000
G1 X166.166 Y162.131 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I.839 J-.882 P1  F60000
G1 X164.607 Y160.649 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.56692
G1 F3411
G1 X164.588 Y160.017 E.02698
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.981
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z5.6
G1 Z5.2
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3411
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3411
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3411
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3411
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.6 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z5.6
G1 Z5.2
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3411
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 5.4
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 27/28
; update layer progress
M73 L27
M991 S0 P26 ;notify layer change
G17
G3 Z5.6 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.924 Y158.048
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3361
G1 X181.151 Y157.481 E.02025
G1 X181.41 Y158.17 E.02443
G1 X180.877 Y158.167 E.01769
G1 X180.902 Y158.103 E.00228
M204 S250
G1 X180.947 Y158.56 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G3 X180.585 Y159.8 I-28.47 J-7.648 E.0397
G1 X179.706 Y162.413 E.0847
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16124
G2 X180.208 Y156.576 I-2.983 J.929 E.03349
G2 X179.199 Y156.236 I-.857 J.874 E.03385
G1 X179.085 Y156.245 E.00351
G1 X179.085 Y155.713 E.01633
G3 X179.859 Y155.684 I.675 J7.65 E.02382
G3 X181.03 Y156.383 I-.045 J1.405 E.04373
G3 X181.5 Y157.295 I-5.846 J3.59 E.03158
G1 X183.423 Y162.413 E.16798
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07324
G3 X181.343 Y158.562 I62.595 J-17.912 E.0502
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.276513
G1 F3361
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.319821
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360086
G1 X180.238 Y159.689 E.01176
; LINE_WIDTH: 0.401431
G1 X179.928 Y160.531 E.02623
; LINE_WIDTH: 0.446945
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492458
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.492673
G1 F3361
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454183
G1 X182.381 Y160.761 E.02581
; LINE_WIDTH: 0.415693
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379325
G1 X182.012 Y159.669 E.01047
; LINE_WIDTH: 0.345106
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310887
G1 X181.775 Y158.942 E.00834
; LINE_WIDTH: 0.281065
G1 X181.684 Y158.655 E.00585
; LINE_WIDTH: 0.255635
G1 X181.592 Y158.368 E.00523
G1 X180.915 Y156.567 F60000
; LINE_WIDTH: 0.355692
G1 F3361
G1 X180.92 Y157.53 E.02456
G1 X181.035 Y157.243 F60000
; LINE_WIDTH: 0.435369
G1 F3361
G1 X180.886 Y156.924 E.01125
G2 X180.465 Y156.298 I-2.011 J.9 E.02426
; LINE_WIDTH: 0.388142
G1 X180.344 Y156.198 E.00439
G2 X180.227 Y156.124 I-.856 J1.236 E.0039
; LINE_WIDTH: 0.340411
G1 X180.194 Y156.107 E.00089
G2 X180.052 Y156.047 I-1.302 J2.859 E.00375
; LINE_WIDTH: 0.291572
G1 X180.034 Y156.041 E.00038
G2 X179.836 Y155.992 I-.55 J1.778 E.00414
; LINE_WIDTH: 0.252525
G1 X179.707 Y155.974 E.00223
; LINE_WIDTH: 0.208177
G1 X179.281 Y155.965 E.00573
; WIPE_START
G1 F15000
G1 X179.707 Y155.974 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
M73 P96 R0
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.624 E.10162
G3 X176.463 Y157.79 I1.036 J-.056 E.02872
G3 X177.189 Y157.612 I.619 J.951 E.0234
G1 X177.47 Y157.625 E.00865
G3 X178.043 Y157.72 I-.344 J3.831 E.01786
G1 X178.043 Y158.134 E.01271
G2 X177.206 Y158.363 I-.219 J.845 E.02791
G2 X177.013 Y159.003 I.986 J.646 E.02084
G1 X177.013 Y161.871 E.08812
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13274
G1 F3361
G1 X177.79 Y162.172 E.00712
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.156395
G1 F3361
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203705
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251014
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298324
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345633
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392943
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440252
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487561
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534871
G1 X176.563 Y162.172 E.00113
G1 X176.749 Y163.423 F60000
; LINE_WIDTH: 0.230061
G1 F3361
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565836
G1 X176.563 Y162.172 E.00303
; LINE_WIDTH: 0.551785
G3 X176.564 Y158.982 I107.842 J-1.559 E.13229
G1 X176.583 Y158.638 E.01428
; LINE_WIDTH: 0.610709
G3 X176.719 Y158.213 I.913 J.058 E.02085
G1 X177.136 Y157.809 E.02686
G1 X177.339 Y157.815 F60000
; LINE_WIDTH: 0.509741
G1 F3361
G2 X176.852 Y158.092 I1.798 J3.727 E.02132
; LINE_WIDTH: 0.553571
G1 X176.322 Y158.48 E.02732
G1 X176.351 Y158.316 F60000
; LINE_WIDTH: 0.411055
G1 F3361
G3 X177.508 Y157.826 I3.073 J5.65 E.03774
; WIPE_START
G1 F15000
G1 X177.035 Y157.994 E-.19065
G1 X176.584 Y158.206 E-.18935
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-.685 J-1.006 P1  F60000
G1 X171.422 Y161.722 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G1 X171.562 Y161.86 E.00605
G2 X171.842 Y161.978 I.392 J-.54 E.0094
G2 X173.158 Y161.92 I.566 J-2.129 E.0411
G2 X173.589 Y161.44 I-.402 J-.796 E.02029
G1 X174.346 Y161.519 E.02339
G3 X173.184 Y162.439 I-1.393 J-.566 E.04762
G3 X171.222 Y162.292 I-.733 J-3.383 E.0613
G3 X170.852 Y160.31 I.448 J-1.109 E.07368
G3 X171.756 Y159.906 I1.29 J1.674 E.0307
G2 X173.073 Y159.594 I-20.445 J-89.334 E.0416
G2 X173.694 Y159.06 I-.199 J-.859 E.02617
G2 X173.037 Y158.119 I-.735 J-.187 E.04003
G2 X171.604 Y158.183 I-.582 J3.022 E.04448
G2 X171.099 Y158.71 I.374 J.862 E.02302
G1 X170.347 Y158.598 E.02338
G3 X171.591 Y157.672 I1.413 J.6 E.04993
G3 X172.788 Y157.615 I.839 J4.958 E.03691
G3 X174.174 Y158.126 I-.028 J2.208 E.04629
G3 X174.184 Y159.855 I-.868 J.87 E.05892
G3 X173.143 Y160.327 I-1.522 J-1.972 E.03546
G2 X171.876 Y160.63 I9.029 J40.577 E.04002
G2 X171.288 Y161.274 I.145 J.723 E.02868
G2 X171.388 Y161.673 I.666 J.046 E.01284
M204 S10000
G1 X171.148 Y161.886 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.26187
G1 F3361
G1 X171.236 Y161.964 E.00209
; LINE_WIDTH: 0.226423
G1 X171.34 Y162.037 E.0019
; LINE_WIDTH: 0.186264
G2 X171.536 Y162.136 I.649 J-1.035 E.00257
; LINE_WIDTH: 0.127505
G2 X172.445 Y162.279 I.815 J-2.228 E.00639
G1 X172.975 Y162.233 E.00366
; LINE_WIDTH: 0.152958
G1 X173.16 Y162.188 E.00171
G1 X173.372 Y162.107 E.00203
; LINE_WIDTH: 0.206287
G1 X173.552 Y162.002 E.00278
; LINE_WIDTH: 0.247841
G1 X173.659 Y161.919 E.00225
; LINE_WIDTH: 0.298097
G1 X173.882 Y161.668 E.00699
; WIPE_START
G1 F15000
G1 X173.659 Y161.919 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I.26 J-1.189 P1  F60000
G1 X170.684 Y161.269 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.317792
G1 F3361
G2 X171.078 Y161.807 I6.326 J-4.211 E.01493
G1 X171.148 Y161.886 E.00238
G1 X171.233 Y162.077 F60000
; LINE_WIDTH: 0.359647
G1 F3361
G3 X170.959 Y161.611 I3.282 J-2.242 E.01396
; LINE_WIDTH: 0.409679
G3 X170.904 Y161.423 I1.17 J-.446 E.00585
; LINE_WIDTH: 0.450052
G1 X170.897 Y161.373 E.00167
G3 X170.893 Y161.124 I1.13 J-.141 E.00828
; LINE_WIDTH: 0.486075
G3 X171.223 Y160.537 I.796 J.06 E.0251
; LINE_WIDTH: 0.439543
G1 X171.406 Y160.422 E.00701
; LINE_WIDTH: 0.382978
G1 X171.694 Y160.305 E.00859
G1 X172.072 Y160.201 E.01086
G3 X172.763 Y160.05 I22.555 J101.179 E.01961
; LINE_WIDTH: 0.383822
G1 X173.196 Y159.936 E.01244
G2 X173.595 Y159.776 I-.783 J-2.537 E.01196
; LINE_WIDTH: 0.440064
G1 X173.614 Y159.766 E.00069
G2 X173.786 Y159.653 I-.844 J-1.478 E.00665
; LINE_WIDTH: 0.483894
G2 X174.12 Y158.929 I-.503 J-.672 E.0299
; LINE_WIDTH: 0.436764
G1 X174.119 Y158.872 E.00183
G2 X174.083 Y158.652 I-.805 J.021 E.00716
; LINE_WIDTH: 0.396557
G1 X174.033 Y158.52 E.00407
; LINE_WIDTH: 0.366316
G1 X173.997 Y158.454 E.00199
; LINE_WIDTH: 0.33107
G1 X173.914 Y158.334 E.00342
; LINE_WIDTH: 0.285647
G1 X173.829 Y158.242 E.00249
; LINE_WIDTH: 0.245603
G1 X173.73 Y158.157 E.00215
; LINE_WIDTH: 0.206527
G1 X173.591 Y158.065 E.00222
; LINE_WIDTH: 0.159744
G1 X173.316 Y157.947 E.00285
; LINE_WIDTH: 0.122213
G1 X173.205 Y157.915 E.00074
G2 X171.506 Y157.95 I-.775 J3.69 E.01108
; LINE_WIDTH: 0.179629
G1 X171.387 Y157.994 E.00141
G2 X171.275 Y158.047 I.595 J1.395 E.00138
; LINE_WIDTH: 0.229545
G2 X171.126 Y158.14 I.701 J1.295 E.00269
; LINE_WIDTH: 0.279112
G1 X171.071 Y158.182 E.00132
G2 X170.98 Y158.265 I1.306 J1.533 E.00237
; LINE_WIDTH: 0.315753
G1 X170.913 Y158.341 E.00225
G1 X170.92 Y158.357 E.00039
; LINE_WIDTH: 0.280843
G1 X170.983 Y158.495 E.00294
; WIPE_START
G1 F15000
G1 X170.92 Y158.357 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-1.135 J-.439 P1  F60000
G1 X168.829 Y163.759 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3361
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3361
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-.638 J-1.037 P1  F60000
G1 X164.662 Y161.174 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Inner wall
; LINE_WIDTH: 0.45
G1 F3361
G1 X164.523 Y161.198 E.00468
G1 X164.523 Y160.857 E.01131
G1 X164.737 Y160.831 E.00717
G1 X164.772 Y160.972 E.00483
G1 X164.83 Y161.146 E.00605
G1 X164.721 Y161.164 E.00366
M204 S250
G1 X165.012 Y161.512 F60000
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G3 X164.964 Y162.413 I-24.264 J-.857 E.02772
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.895 J-.826 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.399 Y161.377 I2.291 J.137 E.04414
G2 X166.478 Y161.81 I.907 J-.699 E.03745
G1 X166.668 Y161.788 E.00591
G1 X166.668 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02922
G3 X165.423 Y161.442 I2.487 J-1.679 E.02698
G1 X165.071 Y161.502 E.01097
M204 S10000
G1 X165.856 Y161.953 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.149898
G1 F3361
G1 X165.98 Y162.039 E.00132
; LINE_WIDTH: 0.181245
G2 X166.429 Y162.314 I5.029 J-7.703 E.00593
G1 X166.472 Y162.165 F60000
; LINE_WIDTH: 0.326594
G1 F3361
G1 X166.3 Y162.158 E.00398
G3 X166.166 Y162.131 I.09 J-.821 E.00316
; LINE_WIDTH: 0.275086
G1 X165.898 Y162.026 E.00545
; WIPE_START
G1 F15000
G1 X166.166 Y162.131 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I.839 J-.882 P1  F60000
G1 X164.607 Y160.649 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.566926
G1 F3361
G1 X164.588 Y160.017 E.02701
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.811
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I-.313 J-1.176 P1  F60000
G1 X158.062 Y160.633 Z5.8
G1 Z5.4
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3361
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120754
G1 F3361
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168411
G1 F3361
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216067
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263724
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.31235
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.36194
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.41153
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.461121
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493718
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3361
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z5.8 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z5.8
G1 Z5.4
G1 E.4 F1800
; LINE_WIDTH: 0.463828
G1 F3361
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.41965
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365798
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; CHANGE_LAYER
; Z_HEIGHT: 5.6
; LAYER_HEIGHT: 0.2
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
;============= H2S 20250611 =============
; layer num/total_layer_count: 28/28
; update layer progress
M73 L28
M991 S0 P27 ;notify layer change
G17
G3 Z5.8 I1.217 J0 P1  F60000
;========Date 20250925========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on

M1002 judge_flag timelapse_record_flag
M622 J1

 ; timelapse without wipe tower
    M971 S11 C10 O0
    M1004 S5 P1  ; external shutter

M623

; SKIPPABLE_END

; OBJECT_ID: 79
G1 X180.947 Y158.56
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G3 X180.585 Y159.8 I-28.47 J-7.648 E.03969
G1 X179.706 Y162.413 E.08471
G1 X178.758 Y162.413 E.02915
G1 X180.705 Y157.54 E.16123
G2 X180.208 Y156.576 I-2.978 J.925 E.03351
G2 X179.199 Y156.236 I-.857 J.875 E.03384
G1 X179.085 Y156.245 E.00351
G1 X179.085 Y155.714 E.01631
G3 X179.859 Y155.684 I.595 J5.403 E.02381
G3 X181.076 Y156.453 I-.056 J1.437 E.04633
G3 X181.5 Y157.295 I-5.267 J3.18 E.02901
G1 X183.423 Y162.413 E.16798
G1 X182.485 Y162.413 E.02882
G1 X181.773 Y160.138 E.07325
G3 X181.343 Y158.562 I62.345 J-17.844 E.05019
G1 X181.007 Y158.56 E.01031
M204 S10000
G1 X180.695 Y158.362 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.27651
G1 F3456
G1 X180.543 Y158.811 E.00902
; LINE_WIDTH: 0.319814
G1 X180.39 Y159.259 E.01069
; LINE_WIDTH: 0.360067
G1 X180.238 Y159.688 E.01175
; LINE_WIDTH: 0.401414
G1 X179.929 Y160.531 E.02623
; LINE_WIDTH: 0.44693
G1 X179.619 Y161.374 E.02956
; LINE_WIDTH: 0.492446
G1 X179.309 Y162.217 E.03289
; WIPE_START
G1 F15000
G1 X179.619 Y161.374 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-.304 J1.178 P1  F60000
G1 X182.882 Y162.217 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.49267
G1 F3456
G1 X182.631 Y161.489 E.02822
; LINE_WIDTH: 0.454174
G1 X182.381 Y160.76 E.02581
; LINE_WIDTH: 0.415679
G1 X182.13 Y160.032 E.02339
; LINE_WIDTH: 0.379335
G1 X182.012 Y159.669 E.01047
; LINE_WIDTH: 0.345135
G1 X181.894 Y159.306 E.00941
; LINE_WIDTH: 0.310935
G1 X181.776 Y158.943 E.00834
; LINE_WIDTH: 0.281093
G1 X181.684 Y158.655 E.00586
; LINE_WIDTH: 0.255632
G1 X181.592 Y158.367 E.00523
G1 X181.485 Y157.846 F60000
; FEATURE: Top surface
; LINE_WIDTH: 0.42
G1 F3456
M204 S2000
G1 X181.063 Y158.269 E.01835
M204 S10000
G1 X181.022 Y157.722 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.289556
G1 F3456
G1 X180.823 Y158.079 E.00821
; LINE_WIDTH: 0.262432
G1 X180.864 Y158.136 E.00126
; LINE_WIDTH: 0.217675
G1 X180.906 Y158.192 E.001
; LINE_WIDTH: 0.172919
G1 X180.947 Y158.249 E.00074
G1 X181.415 Y157.604 F60000
; LINE_WIDTH: 0.107917
G1 F3456
G1 X180.816 Y158.204 E.00449
; WIPE_START
G1 F15000
G1 X181.415 Y157.604 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I1.097 J-.528 P1  F60000
G1 X180.916 Y156.569 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.315223
G1 F3456
G1 X180.918 Y157.534 E.02141
G1 X181.034 Y157.244 F60000
; LINE_WIDTH: 0.435317
G1 F3456
G1 X180.886 Y156.923 E.01131
G2 X180.465 Y156.298 I-2.041 J.921 E.0242
; LINE_WIDTH: 0.388051
G2 X180.226 Y156.124 I-.767 J.802 E.00835
; LINE_WIDTH: 0.337979
G1 X180.194 Y156.107 E.00085
G2 X180.035 Y156.041 I-.856 J1.837 E.00416
; LINE_WIDTH: 0.289402
G2 X179.835 Y155.991 I-.554 J1.793 E.00413
; LINE_WIDTH: 0.252375
G1 X179.706 Y155.974 E.00222
; LINE_WIDTH: 0.208237
G1 X179.281 Y155.965 E.00573
; WIPE_START
G1 F15000
G1 X179.706 Y155.974 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-1.109 J-.501 P1  F60000
G1 X177.013 Y161.931 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G1 X177.986 Y161.931 E.0299
G1 X177.986 Y162.413 E.01481
G1 X177.013 Y162.413 E.0299
G1 X177.013 Y163.619 E.03705
G1 X176.537 Y163.619 E.01463
M73 P97 R0
G1 X176.119 Y162.413 E.03921
G1 X175.463 Y162.413 E.02017
G1 X175.463 Y161.931 E.01481
G1 X176.113 Y161.931 E.01998
G1 X176.114 Y158.626 E.10157
G3 X176.462 Y157.791 I1.012 J-.068 E.02881
G3 X177.199 Y157.612 I.631 J.995 E.0237
G1 X177.47 Y157.625 E.00834
G3 X178.043 Y157.72 I-.344 J3.83 E.01787
G1 X178.043 Y158.134 E.01271
G2 X177.203 Y158.366 I-.219 J.844 E.02804
G2 X177.013 Y159.003 I.946 J.628 E.02073
G1 X177.013 Y161.871 E.08812
M204 S10000
G1 X176.817 Y162.172 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.13274
G1 F3456
G1 X177.79 Y162.172 E.00712
G1 X176.817 Y162.172 F60000
; LINE_WIDTH: 0.156395
G1 F3456
G1 X176.788 Y162.172 E.00026
; LINE_WIDTH: 0.203705
G1 X176.76 Y162.172 E.00037
; LINE_WIDTH: 0.251014
G1 X176.732 Y162.172 E.00048
; LINE_WIDTH: 0.298324
G1 X176.704 Y162.172 E.00059
; LINE_WIDTH: 0.345633
G1 X176.676 Y162.172 E.0007
; LINE_WIDTH: 0.392943
G1 X176.647 Y162.172 E.0008
; LINE_WIDTH: 0.440252
G1 X176.619 Y162.172 E.00091
; LINE_WIDTH: 0.487561
G1 X176.591 Y162.172 E.00102
; LINE_WIDTH: 0.534871
G1 X176.563 Y162.172 E.00113
; WIPE_START
G1 F15000
G1 X176.591 Y162.172 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-1.207 J.152 P1  F60000
G1 X176.749 Y163.423 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.230061
G1 F3456
G1 X176.724 Y163.275 E.00228
; LINE_WIDTH: 0.276285
G1 X176.699 Y163.127 E.00285
; LINE_WIDTH: 0.322509
G1 X176.674 Y162.98 E.00341
; LINE_WIDTH: 0.368733
G1 X176.649 Y162.832 E.00397
; LINE_WIDTH: 0.414957
G1 X176.624 Y162.685 E.00454
; LINE_WIDTH: 0.461181
G1 X176.599 Y162.537 E.0051
; LINE_WIDTH: 0.507405
G1 X176.575 Y162.39 E.00566
; LINE_WIDTH: 0.553628
G1 X176.55 Y162.242 E.00623
; LINE_WIDTH: 0.565836
G1 X176.563 Y162.172 E.00303
; LINE_WIDTH: 0.551884
G1 X176.564 Y158.997 E.13168
G1 X176.584 Y158.63 E.01527
; LINE_WIDTH: 0.608416
G3 X176.719 Y158.213 I.924 J.069 E.02035
G3 X177.135 Y157.809 I2.307 J1.962 E.02678
G1 X177.325 Y157.814 F60000
; LINE_WIDTH: 0.511775
G1 F3456
G2 X176.846 Y158.096 I3.454 J6.425 E.02123
; LINE_WIDTH: 0.549056
G1 X176.324 Y158.457 E.02619
G1 X176.352 Y158.316 F60000
; LINE_WIDTH: 0.411323
G1 F3456
G3 X177.508 Y157.826 I3.049 J5.595 E.03776
; WIPE_START
G1 F15000
G1 X177.035 Y157.995 E-.19101
G1 X176.585 Y158.206 E-.18899
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-.689 J-1.003 P1  F60000
G1 X171.438 Y161.745 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G1 X171.565 Y161.862 E.00533
G2 X171.842 Y161.978 I.392 J-.547 E.00928
G2 X173.158 Y161.92 I.566 J-2.128 E.04111
G2 X173.589 Y161.44 I-.403 J-.796 E.02029
G1 X174.346 Y161.519 E.02339
G3 X173.186 Y162.438 I-1.396 J-.571 E.04755
G3 X171.297 Y162.324 I-.733 J-3.561 E.05882
G3 X170.769 Y160.388 I.393 J-1.147 E.07262
G3 X171.757 Y159.906 I1.349 J1.508 E.03421
G2 X173.117 Y159.579 I-9.962 J-44.465 E.04298
G2 X173.717 Y158.942 I-.174 J-.765 E.02854
G2 X173.087 Y158.131 I-.748 J-.069 E.03474
G2 X171.559 Y158.203 I-.635 J2.779 E.0476
G2 X171.1 Y158.71 I.462 J.879 E.02147
G1 X170.346 Y158.597 E.02343
G3 X171.5 Y157.691 I1.384 J.574 E.04712
G3 X172.557 Y157.603 I.916 J4.624 E.03267
G3 X174.005 Y157.989 I.069 J2.649 E.04666
G3 X174.464 Y159.427 I-.729 J1.025 E.04975
G3 X173.645 Y160.172 I-1.212 J-.511 E.03512
G3 X171.917 Y160.616 I-6.023 J-19.827 E.05484
G2 X171.311 Y161.129 I.161 J.805 E.02546
G2 X171.403 Y161.696 I.647 J.186 E.01825
M204 S10000
G1 X171.19 Y161.926 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.288617
G1 F3456
G3 X171.08 Y161.81 I1.057 J-1.11 E.00321
; LINE_WIDTH: 0.321361
G1 X171.048 Y161.768 E.00119
; LINE_WIDTH: 0.356376
G3 X170.973 Y161.641 I.887 J-.613 E.00377
; LINE_WIDTH: 0.402609
G1 X170.96 Y161.61 E.00097
G3 X170.91 Y161.454 I1.788 J-.655 E.00482
; LINE_WIDTH: 0.44735
G1 X170.904 Y161.423 E.00103
G3 X170.894 Y161.125 I1.05 J-.185 E.00987
; LINE_WIDTH: 0.486115
G1 X170.938 Y160.911 E.00789
G1 X171.008 Y160.767 E.00578
G3 X171.223 Y160.537 I.745 J.483 E.01143
; LINE_WIDTH: 0.431679
G1 X171.5 Y160.378 E.01011
; LINE_WIDTH: 0.381821
G1 X171.801 Y160.271 E.00883
G1 X172.072 Y160.201 E.00773
G2 X173.511 Y159.817 I-1.339 J-7.913 E.04119
G1 X173.596 Y159.775 E.00263
; LINE_WIDTH: 0.440267
G1 X173.615 Y159.765 E.00067
G2 X173.786 Y159.653 I-.835 J-1.462 E.00664
; LINE_WIDTH: 0.484139
G2 X174.12 Y158.938 I-.5 J-.669 E.02954
; LINE_WIDTH: 0.441748
G2 X174.096 Y158.702 I-.984 J-.016 E.00774
; LINE_WIDTH: 0.403891
G1 X174.038 Y158.533 E.00524
; LINE_WIDTH: 0.364269
G2 X173.982 Y158.427 I-.929 J.428 E.00315
; LINE_WIDTH: 0.325984
G1 X173.913 Y158.335 E.00265
; LINE_WIDTH: 0.28594
G1 X173.829 Y158.242 E.0025
; LINE_WIDTH: 0.245686
G1 X173.73 Y158.157 E.00215
; LINE_WIDTH: 0.208858
G1 X173.614 Y158.079 E.00189
; LINE_WIDTH: 0.170285
G1 X173.532 Y158.034 E.00097
G2 X173.41 Y157.98 I-.834 J1.694 E.00138
; LINE_WIDTH: 0.123789
G1 X173.144 Y157.901 E.00183
G1 X172.773 Y157.846 E.00247
G2 X171.483 Y157.958 I-.362 J3.329 E.00858
; LINE_WIDTH: 0.175301
G1 X171.33 Y158.019 E.00178
; LINE_WIDTH: 0.206761
G1 X171.221 Y158.077 E.00164
; LINE_WIDTH: 0.238639
G1 X171.12 Y158.144 E.00195
; LINE_WIDTH: 0.271948
G1 X171.025 Y158.222 E.00229
; LINE_WIDTH: 0.315876
G2 X170.809 Y158.469 I1.245 J1.308 E.0073
; WIPE_START
G1 F15000
G1 X171.025 Y158.222 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-1.216 J.054 P1  F60000
G1 X171.19 Y161.926 Z6
M73 P98 R0
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.243633
G1 F3456
G1 X171.286 Y162.002 E.00199
; LINE_WIDTH: 0.208696
G1 X171.402 Y162.075 E.00186
; LINE_WIDTH: 0.176249
G2 X171.562 Y162.146 I.681 J-1.296 E.0019
; LINE_WIDTH: 0.126682
G2 X172.814 Y162.257 I.874 J-2.745 E.00865
G1 X172.978 Y162.233 E.00113
; LINE_WIDTH: 0.153213
G1 X173.16 Y162.188 E.00168
G1 X173.372 Y162.107 E.00204
; LINE_WIDTH: 0.199632
G1 X173.506 Y162.032 E.00197
; LINE_WIDTH: 0.241109
G1 X173.658 Y161.919 E.00306
; LINE_WIDTH: 0.299838
G2 X173.742 Y161.838 I-.767 J-.876 E.00244
G1 X173.781 Y161.793 E.00124
G1 X174.025 Y161.718 E.00535
; WIPE_START
G1 F15000
G1 X173.781 Y161.793 E-.22532
G1 X173.742 Y161.838 E-.05225
G1 X173.658 Y161.919 E-.10243
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-.433 J-1.137 P1  F60000
G1 X168.829 Y163.759 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G1 X168.829 Y164.321 E.01729
G1 X167.915 Y164.321 E.02808
G1 X167.915 Y163.759 E.01729
G1 X168.769 Y163.759 E.02624
M204 S10000
G1 X168.633 Y164.04 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.21345
G1 F3456
G1 X168.111 Y164.04 E.00725
; WIPE_START
G1 F15000
G1 X168.633 Y164.04 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I1.208 J.146 P1  F60000
G1 X168.829 Y162.413 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G1 X167.915 Y162.413 E.02808
G1 X167.915 Y157.697 E.14491
G1 X168.829 Y157.697 E.02808
G1 X168.829 Y162.353 E.14307
M204 S10000
G1 X168.372 Y162.217 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.56478
G1 F3456
G1 X168.372 Y157.893 E.18388
; WIPE_START
G1 F14371.67
G1 X168.372 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-.748 J-.96 P1  F60000
G1 X165.012 Y161.511 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G3 X164.964 Y162.413 I-24.126 J-.849 E.02774
G1 X164.104 Y162.413 E.02641
G2 X164.131 Y161.61 I-12.916 J-.827 E.02468
G1 X164.131 Y157.697 E.12025
G1 X165.045 Y157.697 E.02808
G1 X165.045 Y160.009 E.07106
G2 X165.398 Y161.375 I2.282 J.139 E.04406
G2 X166.478 Y161.81 I.908 J-.696 E.03753
G1 X166.668 Y161.788 E.00591
G1 X166.669 Y162.495 E.02172
G3 X165.802 Y162.23 I-.211 J-.863 E.02922
G3 X165.424 Y161.442 I2.468 J-1.668 E.02695
G1 X165.071 Y161.501 E.01098
M204 S10000
G1 X164.792 Y161.742 F60000
; FEATURE: Top surface
G1 F3456
M204 S2000
G1 X164.328 Y162.205 E.02015
G1 X164.195 Y162.339
G1 X164.203 Y161.798
G1 X164.336 Y161.664
G1 X164.988 Y161.013 E.02831
M204 S10000
G1 X164.971 Y160.895 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.105364
G1 F3456
G1 X164.876 Y160.858 E.00052
G1 X164.319 Y160.867 E.00283
G1 X164.607 Y160.65 F60000
; LINE_WIDTH: 0.566927
G1 F3456
G1 X164.588 Y160.017 E.02702
G1 X164.588 Y157.893 E.09071
; WIPE_START
G1 F14312.784
G1 X164.588 Y158.893 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I-1.123 J.47 P1  F60000
G1 X165.903 Y162.035 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.281913
G1 F3456
G1 X166.167 Y162.131 E.00546
; LINE_WIDTH: 0.326483
G2 X166.309 Y162.158 I.181 J-.557 E.00336
G1 X166.472 Y162.164 E.00378
G1 X166.472 Y162.295 F60000
; LINE_WIDTH: 0.226563
G1 F3456
G3 X165.87 Y161.977 I2.623 J-5.693 E.01021
G1 X165.851 Y161.944 F60000
; LINE_WIDTH: 0.123726
G1 F3456
G2 X166.35 Y162.31 I8.462 J-11.024 E.00407
; WIPE_START
G1 F15000
G1 X165.851 Y161.944 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I.202 J-1.2 P1  F60000
G1 X158.062 Y160.633 Z6
G1 Z5.6
G1 E.4 F1800
; FEATURE: Outer wall
; LINE_WIDTH: 0.42
G1 F3456
M204 S5000
G1 X158.062 Y163.965 E.1024
G1 X157.082 Y163.965 E.03012
G1 X157.082 Y157.697 E.19261
G1 X158.062 Y157.697 E.03012
G1 X158.062 Y160.03 E.07171
G1 X159.135 Y160.851 E.04151
G1 X161.602 Y157.697 E.12304
G1 X162.715 Y157.697 E.03418
G1 X159.779 Y161.362 E.14429
G1 X162.409 Y163.965 E.11368
G1 X161.374 Y163.965 E.0318
G1 X158.104 Y160.675 E.14252
M204 S10000
G1 X158.29 Y160.513 F60000
; FEATURE: Gap infill
; LINE_WIDTH: 0.120752
G1 F3456
G1 X158.021 Y160.277 E.00227
G1 X158.29 Y160.513 F60000
; LINE_WIDTH: 0.168407
G1 F3456
G1 X158.558 Y160.75 E.00366
; LINE_WIDTH: 0.216061
G1 X158.827 Y160.986 E.00505
; LINE_WIDTH: 0.263715
G1 X159.096 Y161.222 E.00644
; LINE_WIDTH: 0.312335
G1 X159.15 Y161.24 E.00124
; LINE_WIDTH: 0.361927
G1 X159.203 Y161.259 E.00147
; LINE_WIDTH: 0.411518
G1 X159.257 Y161.278 E.0017
; LINE_WIDTH: 0.46111
G1 X159.31 Y161.296 E.00193
; LINE_WIDTH: 0.493729
G1 X162.001 Y157.893 E.15938
; WIPE_START
G1 F15000
G1 X161.381 Y158.677 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I.245 J-1.192 P1  F60000
G1 X157.572 Y157.893 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.63121
G1 F3456
G1 X157.572 Y163.769 E.2817
; WIPE_START
G1 F12748.815
G1 X157.572 Y162.769 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I.787 J.929 P1  F60000
G1 X159.31 Y161.296 Z6
G1 Z5.6
G1 E.4 F1800
; LINE_WIDTH: 0.463829
G1 F3456
G1 X159.342 Y161.36 E.00245
; LINE_WIDTH: 0.419652
G1 X159.375 Y161.424 E.0022
; LINE_WIDTH: 0.365784
G1 X159.407 Y161.488 E.00188
G1 X161.693 Y163.769 E.08496
; close powerlost recovery
M1003 S0
; WIPE_START
G1 F15000
G1 X160.985 Y163.063 E-.38
; WIPE_END
G1 E-.02 F1800
G17
G3 Z6 I1.217 J0 P1  F60000
M106 S0
M106 P2 S0
M981 S0 P20000 ; close spaghetti detector
; FEATURE: Custom
; MACHINE_END_GCODE_START
; filament end gcode 
;========== H2S end ==========
;===== date: 2026/03/13 =====

G392 S0 ;turn off nozzle clog detect
M993 A0 B0 C0 ; nozzle cam detection not allowed.

M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
M211 Z1

G90
G1 Z6 F900 ; lower z a little
M1002 judge_flag timelapse_record_flag
M622 J1
    G150.3
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S5 ;wait for last picture to be taken
M623  ;end of "timelapse_record_flag"

G90
G1 Z15.6 F900 ; lower z a little

M141 S0 ; turn off chamber heating
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

; pull back filament to AMS
M620 S65535
T65535
G150.2
M621 S65535

G150.3

M104 S0; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom

    
        G1 Z102.8 F600
        G1 Z100.8
    

M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude

M1015.4 S0 K0 ;disable air printing detect

;=====printer finish air purification=========
M622.1 S0
M1002 judge_flag print_finish_air_filt_flag

M622 J1
M1002 gcode_claim_action : 66
M145 P1
M106 P6 S255
M400 S180
M106 P6 S0
M623

M622 J2
M1002 gcode_claim_action : 66
M145 P0
M106 P3 S127
M400 S180
M106 P3 S0
M623
;=====printer finish air purification=========

;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A53 B10 L99 C53 D10 M99 E53 F10 N99 
M1006 A57 B10 L99 C57 D10 M99 E57 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A48 B10 L99 C48 D10 M99 E48 F10 N99 
M1006 A0 B15 L0 C0 D15 M0 E0 F15 N0 
M1006 A60 B10 L99 C60 D10 M99 E60 F10 N99 
M1006 W
;=====printer finish  sound=========
M400
M18

M73 P100 R0
; EXECUTABLE_BLOCK_END

