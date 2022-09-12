use <../utils.scad>

$fa = 1;
$fs = 0.4;

// clip plate
plate_l = 40;
plate_h = 20;
screw_diam_top = 5;
screw_len_top = 3;
screw_diam_bot = 3;
screw_len_bot = 3;
dist_betw_holes = 20;

tol = 0.001;


module screw_hole(diam_top, depth_top, diam_bot, depth_bot) {
    translate([0, 0, depth_top/2])
    cylinder(h=depth_top + tol, r=diam_top/2, center=true);

    translate([0, 0, -depth_bot/2])
    cylinder(h=depth_bot + tol, r=diam_bot/2, center=true);
}


rotate([90, 0, 0])
{
    mirror_copy([1, 0, 0])
    {
        difference()
        {
        translate([plate_l/4, 0, 0])
        cube([plate_l/2, plate_h, screw_len_top + screw_len_bot], center=true);

        translate([dist_betw_holes/2, 0, 0])
        screw_hole(screw_diam_top, screw_len_top, screw_diam_bot, screw_len_bot);
        }
    }
}

// cup
cup_l = 20;

