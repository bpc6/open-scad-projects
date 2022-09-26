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
    width,
    thickness,
    top_rail_radius,
    bot_rail_radius,
    bot_rail_pos,
    top_rail_pos,
    overlap,
    clip_thickness = 2
) {
    top_z_sign = sign(top_rail_pos.z);
    top_rel_bottom = top_rail_pos - bot_rail_pos;

    // rotation matrices
    rot_bot = [ BOT, CTR, RIGHT+top_z_sign*TOP ];
    rot_top = [ BOT, CTR, RIGHT ];

    //orientations
    bot_clip_orientation = normalize(rot_bot * top_rel_bottom);
    top_clip_orientation = normalize(rot_top * top_rel_bottom);

    echo(bot_pos=bot_rail_pos);
    echo(bot_orient=bot_clip_orientation);
    echo(top_pos=top_rail_pos);
    echo(top_orient=top_clip_orientation);

    // define the linkage to connect all the clips
    module linkage() {
        bot_link_pos = bot_rail_pos - bot_clip_orientation * (bot_rail_radius + thickness/2 - overlap);
        top_link_pos = top_rail_pos - top_clip_orientation * (top_rail_radius + thickness/2 - overlap);

        difference() {
            chain_hull() {
                up(bot_link_pos.z) cube([.01, width, thickness], anchor=LEFT);
                translate(bot_link_pos) ycyl(d=thickness, h=width);
                translate(top_link_pos) ycyl(d=thickness, h=width);
            }
            translate(bot_rail_pos) ycyl(h=width+tol, d=bot_rail_diam+2*clip_thickness);
            translate(top_rail_pos) ycyl(h=width+tol, d=top_rail_diam+2*clip_thickness);
        }
    }

    module clips() {
        translate(bot_rail_pos) rod_clip(bot_rail_radius*2, width, thickness=clip_thickness, orient=bot_clip_orientation);
        translate(top_rail_pos) rod_clip(top_rail_radius*2, width, thickness=clip_thickness, orient=top_clip_orientation);
    }

    mirror_copy() {
        linkage();
        clips();
    }
}



// inputs to cable_management module
top_rail_diam = 8;
bot_rail_diam = 9.25;
dist_betw_bot_rails = 60;
dist_betw_top_rails = 90;
dist_from_bot_to_top_rails = -30;

radius_bot = bot_rail_diam/2;
radius_top = top_rail_diam/2;
// rail positions
bot_rail_pos = [dist_betw_bot_rails/2 + radius_bot, 0, 0];
top_z_sign = sign(dist_from_bot_to_top_rails);
top_rail_pos = [dist_betw_top_rails/2 + radius_top, 0, dist_from_bot_to_top_rails + top_z_sign*(radius_bot + radius_top)];



// actually place stuff on the map
mirror_copy()
for (pos = [bot_rail_pos, top_rail_pos])
    translate(pos) color("yellow") ycyl(h=30, d=bot_rail_diam);

bracket(
    width = 8,
    thickness = 6,
    bot_rail_radius=radius_bot,
    top_rail_radius=radius_top,
    bot_rail_pos=bot_rail_pos,
    top_rail_pos=top_rail_pos,
    overlap=1.5
);
