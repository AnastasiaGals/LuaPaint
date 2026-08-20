#pragma language glsl3



vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec4 texture = texture2D(image, uvs);
    return vec4(1.-texture.r,1.-texture.g,1.-texture.b,1.-texture.a);
}