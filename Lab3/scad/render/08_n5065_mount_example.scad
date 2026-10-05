include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../n5065-mounts.scad>



$fn = 64;

// N5065 mount example used by the homework:
// the N5065 sits on a 25 x 25 mm square tube, while the MGN9H rail
// is fastened to the 10 x 10 mm square tube. The render shows the
// motor, front/rear mount plates, encoder envelope, and tube interfaces.
mount_plate_thickness = 6;
rail_tube_side = 10;
chassis_tube_side = 25;
motor_center_z = -9.25;


echo("=== 數值驗證 ===");
echo("前板中心 z = ", motor_center_z);
echo("後板後端 z = ", motor_center_z - n5065_motor_length() - mount_plate_thickness);
echo("編碼器中心 z = ", motor_center_z - n5065_motor_length() - mount_plate_thickness - 4);
echo("兩者差距 = ", 4, " mm（應該等於 4）");
echo("=== 結束 ===");

// 25 x 25 mm chassis square tube interface.
move([0, 0, 2])
    cuboid([chassis_tube_side, chassis_tube_side, 18], anchor=BOTTOM);

// 10 x 10 mm rail square tube interface.
move([32, 0, 0])
    cuboid([rail_tube_side, rail_tube_side, 45], anchor=BOTTOM);

// Representative MGN9H carriage envelope on the rail tube.
move([32, 0, 32])
    cuboid([20, 25, 12], anchor=CENTER);

// Complete N5065 mount stack. The front plate is centered at z = 20 mm,
// so the motor centre is 58.5 / 2 mm behind it.
move([0, 0, motor_center_z]) {
    n5065_front_mount(thickness=mount_plate_thickness, circle=false) {
        attach(TOP, BOT)
            zrot(25)
                arc_copies(d=22, n=3, sa=0, ea=360)
                    cuboid([3, 6, 6], anchor=CENTER);
    }
    %down(n5065_motor_length() / 2 + mount_plate_thickness / 2)
        cyl(d=n5065_motor_diameter(), h=n5065_motor_length(), anchor=CENTER);
    %down(n5065_motor_length() + mount_plate_thickness / 2)
        n5065_rear_mount(thickness=mount_plate_thickness, circle=false);
}

// Representative AMT103 encoder envelope on the rear face.
move([0, 0, motor_center_z - n5065_motor_length() - mount_plate_thickness - 4])
// change number basen on AMT103
    cyl(d=28.6, h=9, anchor=CENTER);
