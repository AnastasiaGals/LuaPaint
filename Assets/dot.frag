#pragma language glsl3

uniform vec2 resolution;
uniform vec2 cursor;
uniform vec4 colr;
uniform float distance;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec2 realdis = vec2(floor(uvs.x*resolution.x-cursor.x),floor(uvs.y*resolution.y-cursor.y) );
    if (realdis.x * realdis.x+realdis.y*realdis.y < distance){
    return colr;
    }else{
    return vec4(0,0,0,0);
    }
}