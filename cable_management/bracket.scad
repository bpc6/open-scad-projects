include <BOSL2/std.scad>
include <../utils.scad>
use <rod_clip.scad>

$fa = 1;
$fs = 0.4;
tol = .001;

/*
Bracket for holding cable managment rails. Should be able to create bottom or top by using a negating dist_from_bot_to_top_rails.
*/
module bracket(
    top_rail_radius,
    bot_rail_radius,
    bot_rail_pos,
    top_rail_pos,
    width = 6,
    thickness = 5,
    overlap = 2,
    clip_thickness = 2,
    stem_width = 10,
    stem_height = 110,
    dist_to_hole = 15,
    top_hole_diam = 6.8,
    top_edge_to_hole = 6
) {
    top_z_sign = sign(top_rail_pos.z);
    top_rel_bottom = top_rail_pos - bot_rail_pos;

    // clip rotation matrices
    rot_bot = [ BOT, CTR, RIGHT+top_z_sign*TOP ];
    rot_top = [ BOT, CTR, RIGHT ];

    // orientations
    bot_clip_orientation = normalize(rot_bot * top_rel_bottom);
    top_clip_orientation = normalize(rot_top * top_rel_bottom);

    // linkage postitions
    bot_link_pos = bot_rail_pos - bot_clip_orientation * (bot_rail_radius + thickness/2 - overlap);
    top_link_pos = top_rail_pos - top_clip_orientation * (top_rail_radius + thickness/2 - overlap);

    // define the linkage to connect all the clips
    module linkage() {
        difference() {
            union() {
                up(bot_link_pos.z) cube([bot_link_pos.x, width, thickness], anchor=LEFT);
                hull() {
                    translate(bot_link_pos) ycyl(d=thickness, h=width);
                    translate(top_link_pos) ycyl(d=thickness, h=width);
                }
            }
            translate(bot_rail_pos) ycyl(h=width+tol, d=bot_rail_diam+2*clip_thickness);
            translate(top_rail_pos) ycyl(h=width+tol, d=top_rail_diam+2*clip_thickness);
        }
    }

    module clips() {
        translate(bot_rail_pos) rod_clip(bot_rail_radius*2, width, thickness=clip_thickness, orient=bot_clip_orientation);
        translate(top_rail_pos) rod_clip(top_rail_radius*2, width, thickness=clip_thickness, slice_angle=240, orient=top_clip_orientation);
    }

    module desk_mount() {
        arm_start_pos = [0, 0, bot_link_pos.z + thickness/2];
        global_top = stem_height + bot_link_pos.z + thickness/2;
        hole_y = dist_to_hole + top_hole_diam/2;
        top_plate_width = top_hole_diam + 2 * top_edge_to_hole;
        top_plate_depth = hole_y + top_hole_diam/2 + top_edge_to_hole + width;
        translate(arm_start_pos) cube([stem_width, width, stem_height], anchor=BOT);
        difference() {
            translate([0,-width/2,global_top]) cube([top_plate_width, top_plate_depth, thickness], anchor=TOP+FRONT);
            translate([0,hole_y,global_top+tol/2]) cylinder(d=top_hole_diam, h=thickness+tol, anchor=TOP+FRONT);
        }
    }


    mirror_copy() {
        linkage();
        clips();
    }
    if (top_rail_pos.z > bot_rail_pos.z) desk_mount();
}



// inputs to cable_management module
top_rail_diam = 8;
bot_rail_diam = 16;
dist_betw_bot_rails = 40;
dist_betw_top_rails = 90;
dist_from_bot_to_top_rails = 15; // positive for underside, negative for topside

radius_bot = bot_rail_diam/2;
radius_top = top_rail_diam/2;
// rail positions
bot_rail_pos = [dist_betw_bot_rails/2 + radius_bot, 0, 0];
top_z_sign = sign(dist_from_bot_to_top_rails);
top_rail_pos = [dist_betw_top_rails/2 + radius_top, 0, dist_from_bot_to_top_rails + top_z_sign*(radius_bot + radius_top)];



// actually place stuff on the map
*mirror_copy()
    for (pos = [bot_rail_pos, top_rail_pos])
    translate(pos) color("yellow") ycyl(h=30, d=bot_rail_diam);

bracket(
    bot_rail_radius=radius_bot,
    top_rail_radius=radius_top,
    bot_rail_pos=bot_rail_pos,
    top_rail_pos=top_rail_pos,
    overlap=1
); 
