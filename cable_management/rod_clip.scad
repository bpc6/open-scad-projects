include <BOSL2/std.scad>
$fa = 1;
$fs = 0.4;

module rod_clip(rod_diam, width, thickness=2, slice_angle=230, anchor=CENTER, spin=0, orient=UP) {
    /*
        A clip that snaps firmly onto a metal rod.
    */
    rod_radius = rod_diam/2;

    attachable(anchor, spin, orient, r=rod_diam/2+thickness, l=width, axis=BACK) {
        rotate([90, slice_angle/2 + 90, 0]) {
            rotate_extrude(angle=slice_angle)
                translate([rod_radius, 0]) 
                rect([thickness, width], anchor=LEFT);
            
            right(rod_radius) cyl(d=thickness, h=width, anchor=LEFT);
            translate(rod_radius*[cos(slice_angle), sin(slice_angle), 0])
                cyl(d=thickness, h=width, anchor=LEFT, spin=slice_angle);
        }

    children();
    }
}

rod_clip(6.2, 5, anchor=BOTTOM)
    attach(BOTTOM, TOP, overlap=1.5) cube([7, 5, 2]);
