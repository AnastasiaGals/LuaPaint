#pragma language glsl3

uniform vec2 screensize;



vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec4 texture = texture2D(image, uvs);
    //float bob =mod(floor(screensize.x*uvs.x/3)+floor(screensize.y*uvs.y/3),2);
    //return vec4(texture.r*(1-0.01*uvs.x)*bob,texture.g*(1-0.01*uvs.y)*bob , bob   ,texture.a);
    return vec4(floor(uvs.x*screensize.x*0.5)/screensize.x, floor(uvs.y*screensize.y*0.5)/screensize.y, texture.b,texture.a);
}