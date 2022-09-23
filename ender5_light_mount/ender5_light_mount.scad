use <../utils.scad>

$fa = 1;
$fs = 0.4;

tol = 0.001;

// clip plate
plate_l = 40;
plate_h = 20;
screw_diam_top = 5;
screw_len_top = 3;
screw_diam_bot = 3;
screw_len_bot = 3;
dist_betw_holes = 20;


module screw_hole(diam_top, depth_top, diam_bot, depth_bot) {
    /*
    Hole for mounting screws. Needs wide top and narrow bottom.
    */
    translate([0, 0, depth_top/2])
    cylinder(h=depth_top + tol, d=diam_top, center=true);

    translate([0, 0, -depth_bot/2])
    cylinder(h=depth_bot + tol, d=diam_bot, center=true);
}

plate_w = screw_len_top + screw_len_bot;

// mounting plate
rotate([90, 0, 0]) 
{
    mirror_copy([1, 0, 0])
    {
        difference()
        {
            // 1/2 plate
            translate([plate_l/4, 0, 0])
            cube([plate_l/2, plate_h, plate_w], center=true);

            // hole
            translate([dist_betw_holes/2, 0, 0])
            screw_hole(screw_diam_top, screw_len_top, screw_diam_bot, screw_len_bot);
        }
    }
}


// light mount
light_depth = 6;
light_diam = 10;
light_clamp_diam = 8;
side_l = 20 + plate_w;
side_l = 20;

module light_hole() {
    difference()
    {
        cylinder(h=light_depth, r=light_diam/2, center=true);

        mirror_copy([1, 0, 0])
        {
            translate([light_clamp_diam/2 + light_diam/2, 0, 0])
            cube([light_diam, light_diam, light_depth + tol], center=true);
        }
        
    }

}

translate([plate_l/2 + side_l/2 - tol, (side_l-plate_w)/2, (light_depth-plate_h)/2])

difference()
{
    union()
    {
        cylinder(d=side_l, h=light_depth - tol, center=true);
        translate([-side_l/4, 0, 0])
        cube([side_l/2, side_l, light_depth - tol], center=true);
    }

    light_hole();
}

// chamfer
chamf = 7;

translate([plate_l/2, 0, light_depth-plate_h/2])
rotate([90, 45, 0])
cube([chamf, chamf, plate_w], center=true);
