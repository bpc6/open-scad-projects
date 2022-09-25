include <BOSL2/std.scad>
use <rod_clip.scad>
$fa = 1;
$fs = 0.4;


module bottom_bracket(
    bracket_width, bracket_thickness, top_clip_diam, bottom_clip_diam, dist_betw_bot_rails, dist_betw_top_rails, top_rail_height
) {
    /*
        A bracket that attaches to the desk and has inserts for each of the rods
    */
    mirror_copy([1, 0, 0]) {
        top_rel_bottom = [dist_betw_top_rails/2-dist_betw_bot_rails/2, 0, top_rail_height];

        m_bot = [
            [0, 0, -1],
            [0, 0, 0],
            [1, 0, 1]
        ];
        right(dist_betw_bot_rails/2)
            rod_clip(bottom_clip_diam, bracket_width, orient=m_bot*top_rel_bottom);

        m_top = [
            [0, 0, -1],
            [0, 0, 0],
            [1, 0, 0]
        ];
        translate([dist_betw_top_rails/2, 0, top_rail_height])
            rod_clip(bottom_clip_diam, bracket_width, orient=m_top*top_rel_bottom);
    }
}

bottom_bracket(8, 5, 13, 14, 60, 90, 30);
