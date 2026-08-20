#pragma language glsl3

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
 vec4 coloro = texture2D(image, uvs);
  return vec4(coloro.rgb/coloro.a, coloro.a); 
}