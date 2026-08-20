#pragma language glsl3

uniform Image drawnow;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec4 texture = texture2D(drawnow, uvs);
    vec4 texture2 = texture2D(image, uvs);
    return vec4(texture.r+texture2.r,texture.g+texture2.g,texture.b+texture2.b,texture.a+texture2.a);
}