include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <../htd-pulley.scad>
include <../htd-linear-clamp.scad>
include <../n5065-mounts.scad>

$fn = 64;

// 完整组装：N5065 mounts + drive pulley + idler + carriage
n5065_mounts(thickness=6, inside_thickness=6);

// 加 pulley、carriage 等（按你的实际布局）
// ...