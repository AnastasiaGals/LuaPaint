
local drawi = {
  width = 10,
  height = 10,
  active = false,
  sampleactive=false,
  dothething=false,
  cursormemory=nil,
  cursormemory2=nil,
  gobackw=false,
  goforthw=false,
  mousepanning=false,
  bgcol={0,0,0,0}

}




function drawi:setup(width, height, xloc, yloc, scale)
self.offsettim=0
self.width=width
self.height=height
self.scale=scale
self.xloc = xloc
self.yloc=yloc
self.dragposition={x=0,y=0}
local shad = love.filesystem.read("dot.frag")
self.dotshader=love.graphics.newShader(shad )
  shad = love.filesystem.read("replace.frag")
self.replaceshader = love.graphics.newShader(shad)
  shad = love.filesystem.read("add.frag")
self.addshader = love.graphics.newShader(shad)
  shad = love.filesystem.read("subtract.frag")
self.subtractshader=love.graphics.newShader(shad)
  shad = love.filesystem.read("invert.frag")
self.invershader= love.graphics.newShader(shad)
shad = love.filesystem.read("linefrag.frag")
self.lineshader= love.graphics.newShader(shad)
shad = love.filesystem.read("bgshader.frag")
self.BGshader = love.graphics.newShader(shad)
shad = love.filesystem.read("alphadivide.frag")
self.alphadivide = love.graphics.newShader(shad)
self.BGshader:send("bgcolor", {0,0,0,0} )
self.BGshader:send("offset", 0 )
self.BGshader:send("checkersiz", 0.05 )

self.drawing=love.graphics.newCanvas(width,height)
self.edito=love.graphics.newCanvas(width,height)
self.buffer=love.graphics.newCanvas(width,height)
self.storebuffer=love.graphics.newCanvas(width,height)
self.BGbuffer=love.graphics.newCanvas(width,height)

self.drawlist ={self.edito, self.buffer}
self:setdims(width,height)
self:setbrushsize(5)
self:setcolor({1,1,1,1})
  self.brush={self.lino}
  self.store=self.replo
  self.apply=self.replo
  self.historybuffer= {}
  self.historybufferlength=10
  self.historybufferposition=1
  table.insert(self.historybuffer,1,love.graphics.newImage(self.drawing:newImageData()))
end

function drawi:setdimsscr(width, height, store, request)
 
  print("setdis")
  print(width, height, store)
  print(love.graphics.getBlendMode())
  love.graphics.setBlendMode("replace", "premultiplied")
  
  love.graphics.setShader()
  local buffhold =love.graphics.newCanvas(width,height)
  love.graphics.setCanvas(buffhold)
  love.graphics.draw(self.drawing)
  self.drawing=buffhold
  
  
  local buffhold =love.graphics.newCanvas(width,height)
  love.graphics.setCanvas(buffhold)
  love.graphics.draw(self.edito)
  self.edito=buffhold
  
  local buffhold =love.graphics.newCanvas(width,height)
  love.graphics.setCanvas(buffhold)
  love.graphics.draw(self.buffer)
  self.buffer=buffhold
  print(love.graphics.getBlendMode())
  
  
  local buffhold =love.graphics.newCanvas(width,height)
  love.graphics.setCanvas(buffhold)
  love.graphics.draw(self.storebuffer)
  self.storebuffer=buffhold
  
  local buffhold =love.graphics.newCanvas(width,height)
  love.graphics.setCanvas(buffhold)
  love.graphics.draw(self.BGbuffer)
  self.BGbuffer=buffhold
  
  
  self.width=width
  self.height=height
  
  self.drawlist ={self.edito, self.buffer}
  self:setdims(width,height)
  love.graphics.setBlendMode("alpha","alphamultiply")
  print(love.graphics.getBlendMode())

  if store then
    print("bbbb")
  drawi.historybufferposition=drawi:historyupdate(drawi.drawing, drawi.historybuffer, drawi.historybufferlength, drawi.historybufferposition)
end
if request then
  return self.drawing
  end
end

function drawi:setdims(width, height)
  self.dotshader:send("resolution", {width,height})
  self.lineshader:send("resolution", {width,height})
  self.BGshader:send("resolution", {width,height})
end

function drawi:setbrushsize(size)
self.dotshader:send("distance",size*size)
self.lineshader:send("distance",size)
self.brushsize = size
  
end
function drawi:setcolor(col)
self.dotshader:send("colr",col)
self.lineshader:send("colr",col)
self.color = col
end

function drawi:setonecol(col, id)
  local colo = self.color
  colo[id]=col
  self:setcolor(colo)
end



function drawi:MouseDownHandeler(button)
  print(button)
  if button== 3 then
  self.mousepanning=true
    self.cursormemory2 = nil
  elseif self.sampleactive then
    local x, y = self:mousecoords()
      if x and y then
        if x>0 and y>0 and x<self.width and x<self.height then
        local imagedat = self.drawing:newImageData()
        local ra, ge, be, aa = imagedat:getPixel(math.floor(x), math.floor(y))
        self:setcolor({ra,ge,be,aa})
        graphi:updatediscolor()
    self.cursormemory = {x=x,y=y}
        end
      
      
    end
    self.sampleactive=false
  else
  
 -- self.brush={self.lino}
 -- self.store=self.replo
  self.active = true
  end
end

function drawi:MouseUpHandeler(button)
  if self.active==true then
  self.dothething=true
elseif self.mousepanning then
  self.mousepanning=false
  end
  self.active=false
  
end

function drawi:historyupdate(newcanvas, historybuffer, historylength, position)
  
  while position>1 do
    table.remove(historybuffer, 1)
    position=position-1
  end
  table.insert(historybuffer,1,love.graphics.newImage(newcanvas:newImageData()))
  while #historybuffer >historylength do
    table.remove(historybuffer,historylength +1)
  end
  print("aaaaaaaaaaaaaaaaa")
  print("update",position)
  return position
end

function drawi:goback(drawto, buffer, position)
  if position < #buffer then
  position=position+1
  if buffer[position]:getWidth() ~= drawto:getWidth() or buffer[position]:getHeight() ~= drawto:getHeight() then
    drawto=self:setdimsscr(buffer[position]:getWidth(), buffer[position]:getHeight(), false, true)
  end
  love.graphics.setShader()
  love.graphics.setCanvas(drawto)
  love.graphics.clear(0,0,0,0)
  
  
  love.graphics.draw(buffer[position])
  
  
  end
  print("back",position)
  return position 
end

function drawi:gofor(drawto, buffer, position)
    print("tt2222t")
  if position > 1 then
    print("tt22t")
  position=position-1
   if buffer[position]:getWidth() ~= drawto:getWidth() or buffer[position]:getHeight() ~= drawto:getHeight() then
     
    drawto=self:setdimsscr(buffer[position]:getWidth(), buffer[position]:getHeight(), false, true)
  end
  love.graphics.setShader()
  love.graphics.setCanvas(drawto)
  love.graphics.clear(0,0,0,0)
  
  
  love.graphics.draw(buffer[position])
  
  
  end
  print("for",position)
  return position 
end

function drawi:updatehandle(dt)
self.offsettim= (self.offsettim+dt/5)%1
self.BGshader:send("offset", self.offsettim )

end

function drawi:DrawHandle()
  self.indo = 1
  
  if self.mousepanning then
    
  local x, y = love.mouse.getPosition()
  if x and y then
    x,y = x/push._SCALE.x, y/push._SCALE.y
    
  if not self.cursormemory2 then
    self.cursormemory2 = {x=x,y=y}
  end
  self.dragposition={x=self.dragposition.x+x-self.cursormemory2.x,y=self.dragposition.y+y-self.cursormemory2.y}
  self.cursormemory2 = {x=x,y=y}
  else
  self.cursormemory2=nil
end
end

  if self.gobackw then
    self.historybufferposition=self:goback(self.drawing, self.historybuffer, self.historybufferposition)
    print(self.historybuffer[1])
    self.gobackw=false
   print(#self.historybuffer, self.historybufferposition)
  end
  if self.goforthw then
    self.historybufferposition=self:gofor(self.drawing, self.historybuffer, self.historybufferposition)
    self.goforthw=false
     print(#self.historybuffer, self.historybufferposition)
  end
  --applies the current brushstroke to the final image and then clears the brush buffer
  if self.dothething then
    
  self.apply(self,self.storebuffer,self.drawing )
  love.graphics.setCanvas(self.storebuffer)
    love.graphics.clear(0,0,0,0)
    self.dothething=false
    self.historybufferposition=self:historyupdate(self.drawing, self.historybuffer, self.historybufferlength, self.historybufferposition)
   print(#self.historybuffer, self.historybufferposition)
    
    end
  
  --fun through brush effect
  if not self.sampleactive and not self.mousepanning then
    for i=1,#self.brush do
      self.brush[i](self,self.drawlist[self.indo], self.drawlist[self.indo%2+1])
      love.graphics.setCanvas(self.drawlist[self.indo])
      love.graphics.clear(0,0,0,0)
      self.indo=self.indo%2+1
    end
    if #self.brush>0 then
      self.store(self,self.drawlist[self.indo],self.storebuffer )
      love.graphics.setCanvas(self.drawlist[self.indo])
      love.graphics.clear(0,0,0,0)
      self.indo=self.indo%2+1
    end
    love.graphics.setShader()
    love.graphics.setCanvas(self.drawlist[self.indo])
    love.graphics.setBlendMode("replace", "premultiplied")
        love.graphics.clear(0,0,0,0)
    love.graphics.draw(self.drawing)
love.graphics.setBlendMode("alpha","alphamultiply")

      if  self.apply then self.apply(self,self.storebuffer,self.drawlist[self.indo]) end
    
      if not self.active then
        love.graphics.setCanvas(self.storebuffer)
        love.graphics.clear(0,0,0,0)
      end
    love.graphics.setCanvas()
    
    love.graphics.push()
    
    love.graphics.scale(push._SCALE.x, push._SCALE.y)
    love.graphics.translate(self.xloc+self.dragposition.x,self.yloc+self.dragposition.y)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.setShader(self.BGshader)
love.graphics.setBlendMode("alpha","alphamultiply")
    love.graphics.draw(self.BGbuffer)
    love.graphics.setShader()
love.graphics.setBlendMode("alpha","alphamultiply")
    love.graphics.draw(self.drawlist[self.indo])
    --local xorr = 0
    --for i, v in ipairs(self.historybuffer) do
    --xorr= xorr + v:getWidth()+10
    --love.graphics.draw(v,xorr,0)
    --graphi.textbox:set(tostring(v:getHeight()))
    --love.graphics.draw(graphi.textbox, xorr,0)
    --if i==self.historybufferposition then
    --  love.graphics.setColor(0.5,0.5,0.5,1)
    --love.graphics.rectangle("fill", xorr,20, 10, 10)
    --  love.graphics.setColor(1,1,1,1)
    --end
    --end
    
     love.graphics.pop()
  else
    
    love.graphics.setShader()
    love.graphics.setCanvas()
    love.graphics.push()
    
    love.graphics.scale(push._SCALE.x, push._SCALE.y)
    love.graphics.translate(self.xloc+self.dragposition.x,self.yloc+self.dragposition.y)
    love.graphics.scale(self.scale, self.scale)
    
    love.graphics.setShader(self.BGshader)
love.graphics.setBlendMode("alpha","alphamultiply")
    love.graphics.draw(self.BGbuffer)
    love.graphics.setShader()
love.graphics.setBlendMode("alpha","alphamultiply")
    love.graphics.draw(self.drawlist[self.indo])
    --love.graphics.draw(self.BGbuffer)
    
    love.graphics.pop()
  end
  
end

--function drawi:dotto(bufferfrom, bufferto)
 -- love.graphics.setCanvas(bufferto)
  --  love.graphics.clear(0,0,0,0)
  --local x, y =  self:mousecoords()
  --if x and y then
  --self.dotshader:send("cursor", {math.floor(x),math.floor(y)})
  
 -- love.graphics.setShader(self.dotshader)
  --love.graphics.draw(bufferfrom)

  --end
  --end


function drawi:lino(bufferfrom, bufferto)
            love.graphics.setBlendMode("alpha","premultiplied")
  love.graphics.setCanvas(bufferto)
    love.graphics.clear(0,0,0,0)
  local x, y =  self:mousecoords()
  if x and y then
  if not self.cursormemory then
    self.cursormemory = {x=x,y=y}
  end
  self.lineshader:send("cursorA", {math.floor(x),math.floor(y)})
  self.lineshader:send("cursorB", {math.floor(self.cursormemory.x),math.floor(self.cursormemory.y)})
 
  if self.active then
  end
  self.cursormemory = {x=x,y=y}
  love.graphics.setShader(self.lineshader)
  love.graphics.draw(bufferfrom)

else
  self.cursormemory=nil
  end
            love.graphics.setBlendMode("alpha","alphamultiply")
  end


function drawi:linowhite(bufferfrom, bufferto)
  love.graphics.setCanvas(bufferto)
    love.graphics.clear(0,0,0,0)
  local x, y =  self:mousecoords()
  if x and y then
  if not self.cursormemory then
    self.cursormemory = {x=x,y=y}
  end
  
  self.lineshader:send("colr",{1,1,1,1})
  self.lineshader:send("cursorA", {math.floor(x),math.floor(y)})
  self.lineshader:send("cursorB", {math.floor(self.cursormemory.x),math.floor(self.cursormemory.y)})
 
  if self.active then
  end
  self.cursormemory = {x=x,y=y}
  love.graphics.setShader(self.lineshader)
  love.graphics.draw(bufferfrom)

else
  self.cursormemory=nil
  end
  self.lineshader:send("colr",self.color)
  end

function drawi:drawon(bufferfrom, bufferto)
  love.graphics.setCanvas({bufferto, stencil=true})
  love.graphics.setShader()
  love.graphics.draw(bufferfrom)
end

function drawi:subbo(bufferfrom, bufferto)
  love.graphics.setCanvas(bufferfrom)
  self.subtractshader:send("drawnow", love.graphics.newImage(bufferto:newImageData()))
love.graphics.setBlendMode("replace","premultiplied")
  love.graphics.setCanvas(bufferto)
  love.graphics.clear(0,0,0,0)
  love.graphics.setShader(self.subtractshader)
  love.graphics.draw(bufferfrom)
  love.graphics.setShader()
  
love.graphics.setBlendMode("alpha","alphamultiply")
end


function drawi:addo(bufferfrom, bufferto)
  love.graphics.setCanvas(bufferfrom)
  self.addshader:send("drawnow", love.graphics.newImage(bufferto:newImageData()))
love.graphics.setBlendMode("replace","premultiplied")
  love.graphics.setCanvas(bufferto)
  love.graphics.clear(0,0,0,0)
  love.graphics.setShader(self.addshader)
  love.graphics.draw(bufferfrom)
  love.graphics.setShader()
  
love.graphics.setBlendMode("alpha","alphamultiply")
end



function drawi:replo(bufferfrom, bufferto)
  love.graphics.setCanvas(bufferfrom)
  self.replaceshader:send("drawover", love.graphics.newImage(bufferto:newImageData()))
love.graphics.setBlendMode("replace","premultiplied")
  love.graphics.setCanvas(bufferto)
  love.graphics.setShader(self.replaceshader)
  love.graphics.draw(bufferfrom)
  love.graphics.setShader()
  
love.graphics.setBlendMode("alpha","alphamultiply")
  end

function drawi:mousecoords()
   local x, y = love.mouse.getPosition()
  
  if x and y then
    x,y = x/push._SCALE.x, y/push._SCALE.y
    x=x-self.xloc-self.dragposition.x
    y=y-self.yloc-self.dragposition.y
    x=x/self.scale
    
    y=y/self.scale
    return x,y
    
  else
    return x,y
  end
  
  
  
end

function drawi:scrollhandler(xo,yo)
  local scalechange = 1
  if yo>0 then
    scalechange = 1+yo
  elseif yo<0 then
    scalechange= 1/(1-yo)
  end
  self.scale=self.scale*scalechange
  local x, y = love.mouse.getPosition()
  if x and y then
    x,y = x/push._SCALE.x, y/push._SCALE.y
    x,y=x-self.xloc-self.dragposition.x,y-self.yloc-self.dragposition.y
    self.dragposition.x = self.dragposition.x-(scalechange-1)*x
    self.dragposition.y = self.dragposition.y-(scalechange-1)*y
    
  end
  
end




return drawi