// Return magenta if anything's wrong
vec4 effect(vec4 loveColor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    return vec4(1.,0.,1.,1.) * Texel(texture, texture_coords);
}
