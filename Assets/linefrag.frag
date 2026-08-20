#pragma language glsl3

uniform vec2 resolution;
uniform vec2 cursorA;
uniform vec2 cursorB;
uniform vec4 colr;
uniform float distance;


vec4 effect(vec4 color, Image image, vec2 uvs, vec2 texture_coords) {
    vec2 realuvs=vec2(floor(uvs.x*resolution.x), floor(uvs.y*resolution.y));
    vec2 realdis = vec2(floor(realuvs.x-cursorA.x),floor(realuvs.y-cursorA.y) );
    vec2 realdis2 = vec2(floor(realuvs.x-cursorB.x),floor(realuvs.y-cursorB.y) );
    vec2 linedirvec = vec2(cursorB.x-cursorA.x,cursorB.y-cursorA.y);
    float scalo = sqrt(linedirvec.x*linedirvec.x+linedirvec.y*linedirvec.y );
    float disttoline = (linedirvec.y*realuvs.x-linedirvec.x*realuvs.y+cursorB.x*cursorA.y-cursorB.y*cursorA.x)/(scalo);
    vec2 posonline = vec2(realuvs.x-disttoline*linedirvec.y/scalo, realuvs.y+disttoline*linedirvec.x/scalo);
    
    if ((realdis.x * realdis.x+realdis.y*realdis.y < distance*distance) || (realdis2.x * realdis2.x+realdis2.y*realdis2.y < distance*distance)){
    return colr;
    }else{
   
    if (abs(disttoline)<distance){
    if (((posonline.x>=cursorA.x) ^^ (posonline.x>=cursorB.x))  	|| ((posonline.y>=cursorA.y) ^^ (posonline.y>=cursorB.y))){
    return colr;
    }
    }
    
    
    }
    return vec4(0,0,0,0);
}

