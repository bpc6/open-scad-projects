include <BOSL2/std.scad>
include <../utils.scad>
use <bracket.scad>

$fa = 1;
$fs = 0.4;
tol = .001;

module cable_management(
    rail_len = 1219.2,  // 48 inches
    top_rail_diam = 8,
    bot_rail_diam = 16,
    dist_betw_bot_rails = 40,
    dist_betw_top_rails = 90,
    dist_from_bot_to_top_rails = 20,
    bracket_width = 6,
    num_brackets = 8,
    extra_rod_at_end=10
) {
    radius_bot = bot_rail_diam/2;
    radius_top = top_rail_diam/2;

    // rail positions
    bot_rail_pos = [dist_betw_bot_rails/2 + radius_bot, 0, 0];
    top_rail_pos = [dist_betw_top_rails/2 + radius_top, 0, dist_from_bot_to_top_rails + radius_bot + radius_top];

    // rails
    mirror_copy() {
        translate(bot_rail_pos) color("yellow") ycyl(h=rail_len, d=bot_rail_diam);
        translate(top_rail_pos) color("yellow") ycyl(h=rail_len, d=top_rail_diam);
    }
    
    
    edge_y = (rail_len - bracket_width - extra_rod_at_end) / 2;

    // end brackets
    for (dir = [-1, 1]) fwd(dir*edge_y) bracket(
        bot_rail_radius=radius_bot,
        top_rail_radius=radius_top,
        bot_rail_pos=bot_rail_pos,
        top_rail_pos=top_rail_pos,
        width=bracket_width
    );

    brack_max_y = edge_y - bracket_width;
    brack_dist = brack_max_y * 2 / num_brackets;
    for (y = [-brack_max_y : brack_dist : brack_max_y])
        fwd(y) xrot(180) bracket(
            bot_rail_radius=radius_bot,
            top_rail_radius=radius_top,
            bot_rail_pos=bot_rail_pos,
            top_rail_pos=[top_rail_pos.x, 0, -top_rail_pos.z],
            width=bracket_width
        );


}

cable_management();
