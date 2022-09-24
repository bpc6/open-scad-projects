include <BOSL2/std.scad>
$fa = 1;
$fs = 0.4;

module rod_clip(rod_diam, width) {
    /*
        A clip that snaps firmly onto a metal rod.
    */
    thickness = 3;
    slice_angle = 210;

    zrot(-slice_angle / 2) {
        rotate_extrude(angle=slice_angle)
            translate([rod_diam, 0]) rect([thickness, width], anchor=LEFT);
        
        right(rod_diam) cyl(d=thickness, h=width, anchor=LEFT);
        translate(rod_diam*[cos(slice_angle), sin(slice_angle), 0])
            cyl(d=thickness, h=width, anchor=LEFT, spin=slice_angle);
    }
}

rod_clip(7.5, 7);
right(8) cube([4, 12, 7], anchor=LEFT);
