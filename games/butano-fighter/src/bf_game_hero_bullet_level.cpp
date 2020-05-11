#include "bf_game_hero_bullet_level.h"

#include "btn_sound_items.h"
#include "bf_game_bullet_util.h"

namespace bf::game
{

namespace
{
    constexpr const hero_bullet_event _level0_events[] = {
        hero_bullet_event(direction_vector(0,       -1,     2.5),   1,  0,  true),
    };

    constexpr const hero_bullet_event _level1_events[] = {
        hero_bullet_event(direction_vector(0,       -1,     2.5),   1,  1,  true),
        hero_bullet_event(direction_vector(-0.075,  -1,     2.5),   11, 0,  true),
        hero_bullet_event(direction_vector(0.075,   -1,     2.5),   31, 0,  true),
    };

    constexpr const hero_bullet_event _level2_events[] = {
        hero_bullet_event(direction_vector(0,       -1,     1.75),  1,  2,  true),
        hero_bullet_event(direction_vector(-0.085,  -1,     2.5),   11, 0,  false),
        hero_bullet_event(direction_vector(0.05,    -1,     2.5),   21, 1,  true),
        hero_bullet_event(direction_vector(0.085,   -1,     2.5),   31, 0,  false),

        hero_bullet_event(direction_vector(0,       -1,     1.75),  41, 2,  true),
        hero_bullet_event(direction_vector(-0.085,  -1,     2.5),   51, 0,  false),
        hero_bullet_event(direction_vector(-0.05,   -1,     2.5),   61, 1,  true),
        hero_bullet_event(direction_vector(0.085,   -1,     2.5),   71, 0,  false),
    };

    constexpr const hero_bullet_level _levels[] = {
        hero_bullet_level(_level0_events, btn::fixed_size(7, 7),    btn::sound_items::gun_5,  6,
                btn::color(31, 28, 5),  20,   1),
        hero_bullet_level(_level1_events, btn::fixed_size(14, 14),  btn::sound_items::gun_5,  25,
                btn::color(31, 28, 5),  40,   2),
        hero_bullet_level(_level2_events, btn::fixed_size(11, 16),  btn::sound_items::gun_1,  50,
                btn::color(13, 2, 2),   80,   4),
    };
}

btn::span<const hero_bullet_level> hero_bullet_level::all_levels()
{
    return _levels;
}

}
