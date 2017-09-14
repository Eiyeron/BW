uniform float time = 0;

// Good old wave effect
uniform vec2 amplitude = vec2(0 / 128., 8/128.);
uniform vec2 speed = vec2(1., 2.);
uniform vec2 frequency = vec2(1, 3);
uniform float sampling_factor = 0.025;
vec2 distort(vec2 texture_coords)
{
    vec2 offset = amplitude * sin(texture_coords.y * frequency + time * speed);
    return texture_coords + offset;
}

// Why the heck do I have to invert the colors manually like this?...
vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = distort(texture_coords);
    vec3 color = Texel(texture, uv).rgb;
    vec3 colorDown = Texel(texture, uv + vec2(0,1/240.)).rgb;
    vec3 colorUp = Texel(texture, uv + vec2(0,-1/240.)).rgb;
    color = color * (1 - sampling_factor*2) + colorDown * sampling_factor + colorUp * sampling_factor;
    color = color *sin(time);
    if (color.r <= 0/255.)
        return vec4(255/255.,241/255.,232/255.,1);
    else if (color.r <= 95/255.)
        return vec4(194/255.,195/255.,199/255.,1);
    else if (color.r <= 194/255.)
        return vec4(95/255.,87/255.,79/255.,1);
    else if (color.r <= 255/255.)
        return vec4(0,0,0,1);

    return vec4(color,1);
}