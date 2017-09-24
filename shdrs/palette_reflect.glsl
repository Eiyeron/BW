#define PALETTE_SIZE 4
uniform float time = 0;

// Good old wave effect
uniform vec2 amplitude = vec2(0 / 128., 8/128.);
uniform vec2 speed = vec2(1., 2.);
uniform vec2 frequency = vec2(1, 3);
uniform float sampling_factor = 0.5;
uniform vec3 palette[PALETTE_SIZE+1];
uniform bool inverse = false;

vec2 distort(vec2 texture_coords)
{
    vec2 offset = amplitude * sin(texture_coords.y * frequency + time * speed);
    return texture_coords + offset;
}

vec4 color_replace_inv(Image texture, vec2 texture_coords)
{
    vec3 color = Texel(texture, texture_coords).rgb;
    vec3 colorDown = Texel(texture, texture_coords + vec2(0,1/(128*2.))).rgb;
    vec3 colorUp = Texel(texture, texture_coords + vec2(0,-1/(128*2.))).rgb;
    color = color * (1 - sampling_factor*2) + colorDown * sampling_factor + colorUp * sampling_factor;
    for (int i = 0; i < PALETTE_SIZE; i++)
        if (color.r <= i/3.)
            return vec4(palette[(PALETTE_SIZE-1)-i].rgb/255.,1);

    return vec4(color,1);
}

vec4 color_replace(Image texture, vec2 texture_coords)
{
    vec3 color = Texel(texture, texture_coords).rgb;
    vec3 colorDown = Texel(texture, texture_coords + vec2(0,1/(128*2.))).rgb;
    vec3 colorUp = Texel(texture, texture_coords + vec2(0,-1/(128*2.))).rgb;
    color = color * (1 - sampling_factor*2) + colorDown * sampling_factor + colorUp * sampling_factor;
    for (int i = 0; i < PALETTE_SIZE; i++)
        if (color.r <= i/(PALETTE_SIZE-1.))
            return vec4(palette[i].rgb/255.,1);

    return vec4(color,1);
}

vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = distort(texture_coords);
    if (inverse)
        return color_replace_inv(texture, uv);
    else
        return color_replace(texture, uv);
}