#pragma tangram: extensions

#ifdef GL_ES
precision mediump float;
#define LOWP lowp
#else
#define LOWP
#endif

#pragma tangram: defines

attribute LOWP vec2 a_position;
attribute LOWP vec2 a_screenPosition;
attribute vec2 a_uv;
attribute LOWP float a_alpha;
attribute LOWP float a_rotation;
attribute LOWP vec4 a_color;
attribute LOWP vec4 a_stroke;

uniform mat4 u_proj;
uniform vec3 u_map_position;
uniform vec3 u_tile_origin;
uniform vec2 u_resolution;
uniform float u_time;
uniform float u_meters_per_pixel;

#pragma tangram: uniforms

varying vec2 v_uv;
varying float v_alpha;
varying vec4 v_color;
varying vec4 v_strokeColor;
varying float v_strokeWidth;

#pragma tangram: global

void main() {
    if (a_alpha > TANGRAM_EPSILON) {
        float st = sin(a_rotation);
        float ct = cos(a_rotation);

        // rotates first around +z-axis (0,0,1) and then translates by (tx,ty,0)
        vec4 position = vec4(
            a_position.x * ct - a_position.y * st + a_screenPosition.x,
            a_position.x * st + a_position.y * ct + a_screenPosition.y,
            0.0, 1.0
        );

        #pragma tangram: position

        gl_Position = u_proj * position;
    } else {
        gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
    }

    v_alpha = a_alpha;
    v_uv = a_uv;
    v_color = a_color;
    v_strokeWidth = a_stroke.a;

    // If width of stroke is zero, set the stroke color to the fill color -
    // the border pixel of the fill is always slightly mixed with the stroke color
    v_strokeColor.rgb = (v_strokeWidth > TANGRAM_EPSILON) ? a_stroke.rgb : a_color.rgb;
}