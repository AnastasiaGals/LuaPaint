#pragma language glsl3

uniform Image drawover;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec4 texture = texture2D(image, uvs);
    if (texture.a>0.){
    return texture;
    
    }else{
    return texture2D(drawover, uvs);
    }
}