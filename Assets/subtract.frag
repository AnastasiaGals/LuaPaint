#pragma language glsl3

uniform Image drawnow;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec4 texture = texture2D(drawnow, uvs);
    vec4 texture2 = texture2D(image, uvs);
    return texture-texture2;
}