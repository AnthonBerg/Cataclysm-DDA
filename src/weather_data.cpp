#include "weather.h" // IWYU pragma: associated

#include <cstddef>
#include <array>
#include <cmath>
#include <map>
#include <vector>
#include <iterator>

#include "color.h"
#include "game_constants.h"
#include "translations.h"

/**
 * @ingroup Weather
 * @{
 */

weather_animation_t get_weather_animation( weather_type const type )
{
    static const std::map<weather_type, weather_animation_t> map {
        {WEATHER_ACID_DRIZZLE, weather_animation_t {0.01f, c_light_green, '.'}},
        {WEATHER_ACID_RAIN,    weather_animation_t {0.02f, c_light_green, ','}},
        {WEATHER_DRIZZLE,      weather_animation_t {0.01f, c_light_blue,  '.'}},
        {WEATHER_RAINY,        weather_animation_t {0.02f, c_light_blue,  ','}},
        {WEATHER_THUNDER,      weather_animation_t {0.02f, c_light_blue,  '.'}},
        {WEATHER_LIGHTNING,    weather_animation_t {0.04f, c_light_blue,  ','}},
        {WEATHER_FLURRIES,     weather_animation_t {0.01f, c_white,   '.'}},
        {WEATHER_SNOW,         weather_animation_t {0.02f, c_white,   ','}},
        {WEATHER_SNOWSTORM,    weather_animation_t {0.04f, c_white,   '*'}}
    };

    const auto it = map.find( type );
    if( it != std::end( map ) ) {
        return it->second;
    }

    return {0.0f, c_white, '?'};
}
struct weather_result {
    weather_datum datum;
    bool is_valid;
};
static weather_result weather_data_internal( weather_type const type )
{
    /**
     * Weather types data definition.
     * Name, color in UI, color and glyph on map, ranged penalty, sight penalty,
     * light modifier, sound attenuation, warn player?
     * Note light modifier assumes baseline of DAYLIGHT_LEVEL at 60
     */
    static const std::array<weather_datum, NUM_WEATHER_TYPES> data {{
            weather_datum {
                "NULL Weather - BUG (weather_data.cpp:weather_data)", c_magenta, c_magenta_red,
                '0', 0, 0.0f, 0, 0, false,
                &weather_effect::none
            },
            weather_datum {
                translate_marker( "Clear" ), c_cyan, c_yellow_white, ' ', 0, 1.0f, 0, 0, false,
                &weather_effect::none
            },
            weather_datum {
                translate_marker( "Sunny" ), c_light_cyan, c_yellow_white, '*', 0, 1.0f, 2, 0, false,
                &weather_effect::sunny
            },
            weather_datum {
                translate_marker( "Cloudy" ), c_light_gray, c_dark_gray_white, '~', 0, 1.0f, -20, 0, false,
                &weather_effect::none
            },
            weather_datum {
                translate_marker( "Drizzle" ), c_light_blue, h_light_blue, '.', 1, 1.03f, -20, 1, false,
                &weather_effect::wet
            },
            weather_datum {
                translate_marker( "Rain" ), c_blue, h_blue, 'o', 3, 1.1f, -30, 4, false,
                &weather_effect::very_wet
            },
            weather_datum {
                translate_marker( "Thunder Storm" ), c_dark_gray, i_blue, '%', 4, 1.2f, -40, 8, false,
                &weather_effect::thunder
            },
            weather_datum {
                translate_marker( "Lightning Storm" ), c_yellow, h_yellow, '%', 4, 1.25f, -45, 8, false,
                &weather_effect::lightning
            },
            weather_datum {
                translate_marker( "Acidic Drizzle" ), c_light_green, c_yellow_green, '.', 2, 1.03f, -20, 1, true,
                &weather_effect::light_acid
            },
            weather_datum {
                translate_marker( "Acid Rain" ), c_green, c_yellow_green, 'o', 4, 1.1f, -30, 4, true,
                &weather_effect::acid
            },
            weather_datum {
                translate_marker( "Flurries" ), c_white, c_dark_gray_cyan, '.', 2, 1.12f, -15, 2, false,
                &weather_effect::flurry
            },
            weather_datum {
                translate_marker( "Snowing" ), c_white, c_dark_gray_cyan, '*', 4, 1.13f, -20, 4, false,
                &weather_effect::snow
            },
            weather_datum {
                translate_marker( "Snowstorm" ), c_white, c_white_cyan, '%', 6, 1.2f, -30, 6, false,
                &weather_effect::snowstorm
            }
        }};

    const auto i = static_cast<size_t>( type );
    if( i < NUM_WEATHER_TYPES ) {
        return { data[i], i > 0 };
    }

    return { data[0], false };
}

static weather_datum weather_data_interal_localized( weather_type const type )
{
    weather_result res = weather_data_internal( type );
    if( res.is_valid ) {
        res.datum.name = _( res.datum.name );
    }
    return res.datum;
}

weather_datum const weather_data( weather_type const type )
{
    return weather_data_interal_localized( type );
}

namespace weather
{
std::string name( weather_type const type )
{
    return weather_data_interal_localized( type ).name;
}
nc_color color( weather_type const type )
{
    return weather_data_internal( type ).datum.color;
}
nc_color map_color( weather_type const type )
{
    return weather_data_internal( type ).datum.map_color;
}
char glyph( weather_type const type )
{
    return weather_data_internal( type ).datum.glyph;
}
int ranged_penalty( weather_type const type )
{
    return weather_data_internal( type ).datum.ranged_penalty;
}
float sight_penalty( weather_type const type )
{
    return weather_data_internal( type ).datum.sight_penalty;
}
int light_modifier( weather_type const type )
{
    return weather_data_internal( type ).datum.light_modifier;
}
int sound_attn( weather_type const type )
{
    return weather_data_internal( type ).datum.sound_attn;
}
bool dangerous( weather_type const type )
{
    return weather_data_internal( type ).datum.dangerous;
}
weather_effect_fn effect( weather_type const type )
{
    return weather_data_internal( type ).datum.effect;
}
} // namespace weather

///@}
