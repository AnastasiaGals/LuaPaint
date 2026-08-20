#pragma language glsl3


uniform float offset;
uniform float checkersiz;
uniform vec2 resolution;
uniform vec4 bgcolor;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec2 realuvs=floor(uvs*resolution) ;
  float tot = mod(floor(realuvs.x*checkersiz+offset)+floor(realuvs.y*checkersiz+offset), 2.0);
  bool iseven =  tot==0.0;
  vec4 checkercolor = (iseven) ? vec4(0.6,0.6,0.6,1.) : vec4(0.4,0.4,0.4,1.);
  checkercolor = vec4(checkercolor.rgb*(1-bgcolor.a)+bgcolor.rgb*bgcolor.a, checkercolor.a*(1-bgcolor.a)+bgcolor.a );
  
  vec4 coloro = texture2D(image, uvs);
 
  
  
  return vec4(checkercolor.rgb*(1-coloro.a)+coloro.rgb*coloro.a, checkercolor.a*(1-coloro.a)+coloro.a );
  
  
}