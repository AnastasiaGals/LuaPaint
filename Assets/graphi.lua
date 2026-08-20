graphi = {
  fonto=love.graphics.newImageFont("outlinefont.png", " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"),
  activetracking=false,
  tracktarget=nil,
  taketextinput=false,
  textinputlocation={55,230},
  textinputfinish=nil,
  textstorage="",
  prompt="filename:",
  inputmode = nil,
  iserasor=false,
  brushid=1
  
  
  
  }
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end



function graphi:updatediscolor()
for num, val in ipairs(self.colorsub) do
  val.col = drawi.color
end
for num, val in ipairs(self.colorsub2) do
  val.valuua = drawi.color[val.colorsub2]
  val.text:set(string.format("%.1f", val.valuua))
  val.siz2={val.text:getWidth(),val.text:getHeight() }
end
end

graphi.channels={
brush={function(va) drawi:setbrushsize(va) end}  ,
erasor={function(va) drawi.apply = drawi.subbo end },
pencil={function(va) drawi.apply = drawi.replo end},
ColRed={function(va) drawi:setonecol(va,1)
    graphi:updatediscolor() end  },
  ColGreen={function(va) drawi:setonecol(va,2)
    graphi:updatediscolor() end  },
  ColBlue={function(va) drawi:setonecol(va,3)
    graphi:updatediscolor() end  },
  ColAlpha={function(va) drawi:setonecol(va,4)
    graphi:updatediscolor() end  },
sampler={function(va) drawi.sampleactive =true end  },
save={function(va) 
    graphi.textinputfinish = function(vlua) 
      print(vlua[1])
      love.graphics.setCanvas(drawi.buffer)
      love.graphics.setBlendMode("alpha","alphamultiply")
      love.graphics.clear({drawi.bgcol[1]*drawi.bgcol[4],drawi.bgcol[2]*drawi.bgcol[4],drawi.bgcol[3]*drawi.bgcol[4],drawi.bgcol[4]*drawi.bgcol[4] })
      love.graphics.draw(drawi.BGbuffer)
      love.graphics.draw(drawi.drawing)
      love.graphics.setCanvas(drawi.edito)
      love.graphics.setBlendMode("replace","premultiplied")
      love.graphics.setShader(drawi.alphadivide)
      love.graphics.draw(drawi.buffer)
      love.graphics.setShader()
      love.graphics.setCanvas(drawi.buffer)
      
      drawi.edito:newImageData():encode("png","/drawings/" .. vlua .. ".png")
            love.graphics.setBlendMode("alpha","alphamultiply")
    end end, function(va) graphi:textlisten("txt",{55,220},"filename: ") end},
setwidth={function(va) 
    graphi.textinputfinish = function(vlua) 
      vlua = math.floor( vlua +0.5)
      drawi:setdimsscr(vlua, drawi.height,true, false)
    end end, function(va) graphi:textlisten("int",{55,233},"width: ") end},
  setheight={function(va) 
    graphi.textinputfinish = function(vlua) 
      vlua = math.floor( vlua +0.5)
      drawi:setdimsscr(drawi.width,vlua, true, false)
    end end, function(va) graphi:textlisten("int",{55,233},"height: ") end},
  importimage={function(va)
      graphi.textinputfinish = function(vlua)
        local rso, rso2 =pcall(function(B) return love.graphics.newImage("/drawings/"..B) end,vlua)
          if rso then
            drawi:setdimsscr(rso2:getWidth(), rso2:getHeight(), false, false)
            love.graphics.setCanvas(drawi.drawing)
            love.graphics.setShader()
            love.graphics.clear({0,0,0,0})
            love.graphics.setBlendMode("alpha","premultiplied")
            love.graphics.draw(rso2)
            love.graphics.setBlendMode("alpha","alphamultiply")
            love.graphics.setCanvas(drawi.storebuffer)
            drawi.historybufferposition=drawi:historyupdate(drawi.drawing, drawi.historybuffer, drawi.historybufferlength, drawi.historybufferposition)
          end 
          end
        end, function(va) graphi:textlisten("file",{55,260},"image: ") end
      },
  BGcol = {function(va)
    drawi.BGshader:send("bgcolor", drawi.color )
    drawi.bgcol=shallowcopy(drawi.color)
    --love.graphics.setBlendMode("alpha","premultiplied")
   -- love.graphics.draw(drawi.drawing)
    --love.graphics.setBlendMode("alpha","alphamultiply")
  end},
ForegroundToBackground = {function(va)
    love.graphics.setShader()
    love.graphics.setCanvas(drawi.BGbuffer)
            love.graphics.setBlendMode("alpha","premultiplied")
    love.graphics.draw(drawi.drawing)
            love.graphics.setBlendMode("alpha","alphamultiply")
    love.graphics.setCanvas(drawi.drawing)
    love.graphics.clear({0,0,0,0})
    love.graphics.setCanvas()
    
    
  end},
bgclear = {function(va)
    love.graphics.setCanvas(drawi.BGbuffer)
    love.graphics.clear({0,0,0,0})
    love.graphics.setCanvas()
  end}

}



function graphi:textlisten(inputtype, location, prompt)
  self.textstorage=""
  self.taketextinput=true
  self.textinputtype=inputtype
  self.textinputlocation=location
  self.prompt = prompt
  if inputtype == "file" then
    self.inputpoint=1
    self.files=love.filesystem.getDirectoryItems( "saves" )
    if #self.files >0 then
     self.textstorage= self.files[1]
    else
     self.textstorage= "no files in folder" 
    end
    
  end
end

graphi.colorsub={}
graphi.colorsub2={}


function graphi:sendsig(channel, sig)
for num, val in ipairs(self.channels[channel]) do
val(sig)
end
end

function graphi:addcolor(id)
  for Num, Val in ipairs(self.items) do
    if Val.id and Val.id==id then
    local table2 = shallowcopy( drawi.color)
    table.insert(Val.colorslist, table2)
    break
    end
  end
  
end

function graphi:removecolor(id)
  for Num, Val in ipairs(self.items) do
    if Val.id and Val.id==id then
    if Val.lastclicked and Val.colorslist[Val.lastclicked] then
      table.remove(Val.colorslist, Val.lastclicked)
    end
    break
    end
  end
  
end

--GUI system for my dumb ass
--1 = button
--2 = textbox
--3 = slider
--4 = colorbox
--colorbox dims are, all square {margin outside-box, size box margin, size box }
graphi.items={
{typ=2, pos={5,10}, siz={50,11}, text = love.graphics.newText(graphi.fonto,"SIZE" ), col={0,0,1,1}, col2={1,1,1,1}},
{typ=1, pos={50,23}, siz={5,11}, func = function() graphi:sendsig("brush",  drawi.brushsize + 1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, ">") }, 
{typ=1, pos={5,23}, siz={5,11}, func = function() graphi:sendsig("brush", drawi.brushsize - 1) end, col={1,1,0,1}, col2={1,0,1,1}, text=love.graphics.newText(graphi.fonto, "<")  } , 
{typ=3, pos={10,23}, siz={40,11}, valuua=5, channel="brush",col={1,1,1,1}, col2={1,1,1,1}, col3={0,1,1,1}, minval=0.5, maxval=100},
erasorbox={typ=1, pos={5,36}, siz={50,11}, func= function()  graphi:brushandle("erase") end, col={1,1,1,1}, col2={1,0,1,1}, text=love.graphics.newText(graphi.fonto,"erasor" )},
brushbox={typ=1, pos={5,49}, siz={50,11}, func= function() graphi:brushandle("next") end, col={1,1,1,1}, col2={1,0,1,1}, text=love.graphics.newText(graphi.fonto,"pencil" )},
{typ=2, pos={5,62}, siz={50,11}, text=love.graphics.newText(graphi.fonto, "color"), colorsub=true, col={1,1,1,1}, col2={1,1,1,1}},
{typ=3, pos={5,75}, siz={50,11}, valuua=1, channel="ColRed",col={0.5,0.2,0.2,1}, col2={1,0.5,0.5,1}, col3={1,0,0,1}, minval=0, maxval=1, colorsub2=1},
{typ=3, pos={5,88}, siz={50,11}, valuua=1, channel="ColGreen",col={0.2,0.5,0.2,1}, col2={0.5,1,0.5,1}, col3={0,1,0,1}, minval=0, maxval=1, colorsub2=2},
{typ=3, pos={5,101}, siz={50,11}, valuua=1, channel="ColBlue",col={0.2,0.2,0.5,1}, col2={0.5,0.5,1,1}, col3={0,0,1,1}, minval=0, maxval=1, colorsub2=3},
{typ=3, pos={5,115}, siz={50,11}, valuua=1, channel="ColAlpha",col={0.2,0.2,0.2,1}, col2={0.5,0.5,0.5,1}, col3={1,1,1,1}, minval=0, maxval=1, colorsub2=4},
{typ=4, pos={5,128}, siz={50,50}, dims={1,1,9}, colorslist={{1,1,1,1}, {0,0,1,1}, {0,1,0,1}, {0.5,0.2,0.8,1},{0,1,1,1},{1,0.5,1,1}} ,col={0.7,0.7,0.7,1}, col2={0.2,0.2,0.2,1}, col3={1,1,1,1}, minval=0, maxval=1, scrollpos={0,0}, id="1", lastclicked=nil},
{typ=1, pos={5,180}, siz={50,11}, func = function() graphi:addcolor("1") end, col={1,1,0,1}, col2={1,0,1,1}, text=love.graphics.newText(graphi.fonto, "ADD")  } ,
{typ=1, pos={5,193}, siz={50,11}, func = function() graphi:removecolor("1") end, col={1,1,0,1}, col2={1,0,1,1}, text=love.graphics.newText(graphi.fonto, "REMOVE")  } ,
{typ=1, pos={5,206}, siz={50,11}, func = function() graphi:sendsig("sampler",  drawi.brushsize + 1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "sample") }  ,
{typ=1, pos={5,219}, siz={50,11}, func = function() graphi:sendsig("save",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "save") }  ,
{typ=1, pos={5,232}, siz={24,11}, func = function() graphi:sendsig("setwidth",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "W") },
{typ=1, pos={31,232}, siz={24,11}, func = function() graphi:sendsig("setheight",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "H") } ,
{typ=1, pos={5,245}, siz={50,11}, func = function() graphi:sendsig("importimage",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "import") },
{typ=1, pos={5,258}, siz={50,11}, func = function() graphi:sendsig("BGcol",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "BGcol") },
{typ=1, pos={5,271}, siz={50,11}, func = function() graphi:sendsig("ForegroundToBackground",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "FG to BG") },
{typ=1, pos={5,284}, siz={50,11}, func = function() graphi:sendsig("bgclear",1) end, col={1,1,1,1}, text=love.graphics.newText(graphi.fonto, "BG clear") }

}
function graphi:setup()
    self.textbox=love.graphics.newText(graphi.fonto, self.prompt)
  
    for num, val in pairs(self.items) do
       if val.typ ==3 then
         val.text = love.graphics.newText(graphi.fonto,string.format("%.1f", val.valuua) )
              val.siz2={val.text:getWidth(),val.text:getHeight() }
              if not val.colorsub2 then
              table.insert(graphi.channels[val.channel], function(va) 
              val.valuua=va
              val.text:set(string.format("%.1f", va))
              val.siz2={val.text:getWidth(),val.text:getHeight() }
              end) end
        elseif val.typ==1 then
          if val.text then
            val.siz2 = {val.text:getWidth(),val.text:getHeight() }
            end
        elseif val.typ==4 then  
        val.canva=love.graphics.newCanvas(val.siz[1], val.siz[2])
        val.boxsize=val.dims[1]+val.dims[2]*2+val.dims[3]
        val.nwidth= math.floor(val.siz[1]/val.boxsize)
      end
      if val.colorsub then
        table.insert(self.colorsub, val)
      end
      if val.colorsub2 then
        table.insert(self.colorsub2, val)
    end
    end
  
  
  
end

function graphi:drawit()
  love.graphics.push()
  
    love.graphics.scale(push._SCALE.x, push._SCALE.y)
  
  local x, y = self:getmousepos()
  if x and y then
  if self.activetracking then
    self:sendsig(self.tracktarget.channel,self.tracktarget.minval+(self.tracktarget.maxval-self.tracktarget.minval)* math.max(math.min((x-self.tracktarget.pos[1])/self.tracktarget.siz[1] ,1) ,0))
    
    end
  end
  
  
  for num, val in pairs(self.items) do
  
    if val.typ ==1 then
      
      
      if x and y and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2] then
        if val.col2 then
          love.graphics.setColor(val.col2)
        else
          
          love.graphics.setColor(val.col[1]*0.5,val.col[2]*0.5,val.col[3]*0.5,val.col[4])
        end
         
        
      else
      love.graphics.setColor(val.col)
      end
      love.graphics.rectangle("fill",val.pos[1], val.pos[2],val.siz[1],val.siz[2])
      if val.text then 
          love.graphics.setColor(1,1,1,1)
          love.graphics.draw(val.text, val.pos[1]+math.floor(val.siz[1]*0.5-val.siz2[1]*0.5), val.pos[2]+math.floor(val.siz[2]*0.5-val.siz2[2]*0.5))
        end 
    elseif val.typ ==2 then
      love.graphics.setColor(val.col)
      love.graphics.rectangle("fill", val.pos[1], val.pos[2], val.siz[1], val.siz[2])
      if not val.siz2 then
        val.siz2={val.text:getWidth(),val.text:getHeight() }
      end
      
      love.graphics.setColor(val.col2)
      love.graphics.draw(val.text, val.pos[1]+math.floor(val.siz[1]*0.5-val.siz2[1]*0.5), val.pos[2]+math.floor(val.siz[2]*0.5-val.siz2[2]*0.5))
    elseif val.typ==3 then
    
    
      love.graphics.setColor(val.col2)
      love.graphics.rectangle("fill", val.pos[1], val.pos[2], val.siz[1], val.siz[2])
      love.graphics.setColor(val.col3)
      love.graphics.rectangle("fill", val.pos[1], val.pos[2], val.siz[1]*math.min(math.max((val.valuua-val.minval)/(val.maxval-val.minval),0),1), val.siz[2])
    
      love.graphics.setColor(val.col)
      love.graphics.draw(val.text, val.pos[1]+math.floor(val.siz[1]*0.5-val.siz2[1]*0.5), val.pos[2]+math.floor(val.siz[2]*0.5-val.siz2[2]*0.5))
      
   
  elseif val.typ == 4 then
    love.graphics.pop()
    
    local canvashold = love.graphics.getCanvas()
    love.graphics.setCanvas(val.canva)
    love.graphics.clear(val.col)
    local drawpoint=shallowcopy( val.scrollpos)
    local inatall = x and y and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2] 
    for Numbo, Valo in ipairs(val.colorslist) do
      if inatall and x>val.pos[1]+val.dims[1]+drawpoint[1] and x<val.pos[1]+val.boxsize+drawpoint[1] and y>val.pos[2]+drawpoint[2]+val.dims[1] and y<val.pos[2]+drawpoint[2]+val.boxsize then
      love.graphics.setColor(val.col3)
      else
      love.graphics.setColor(val.col2)
      end
      love.graphics.rectangle("fill", drawpoint[1]+val.dims[1], drawpoint[2]+val.dims[1], val.boxsize-val.dims[1], val.boxsize-val.dims[1]  )
      love.graphics.setColor(Valo)
      love.graphics.rectangle("fill", drawpoint[1]+val.dims[1]+val.dims[2], drawpoint[2]+val.dims[1]+val.dims[2], val.dims[3], val.dims[3] )
      if Numbo%val.nwidth==0 then
        drawpoint[1]=0
        drawpoint[2]=drawpoint[2]+val.boxsize
      else
        drawpoint[1]=drawpoint[1]+val.boxsize
      end
      
    end
    love.graphics.setColor({1,1,1,1})
    love.graphics.push()
    
    love.graphics.scale(push._SCALE.x, push._SCALE.y)
    love.graphics.setCanvas(canvashold)
    love.graphics.draw(val.canva,val.pos[1], val.pos[2])
    end
  end
    
    if self.taketextinput then
    love.graphics.setColor({1,1,1,1})
    self.textbox:set(self.prompt .. self.textstorage)
    love.graphics.draw(self.textbox, self.textinputlocation[1], self.textinputlocation[2])
    
    end
    
  love.graphics.pop()
    love.graphics.setColor(1,1,1,1)
end



function graphi:clickhancle(presses)
  local x, y = self:getmousepos()
  
  if x and y then
    
    local keyset={}
    local n=0
    for k,v in pairs(self.items) do
      n=n+1
      keyset[n]=k
    end

    for num=#keyset,1 ,-1 do
      local val=self.items[keyset[num]]
      if val.typ ==1 and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2] then
      val.func()
      return true
      elseif val.typ ==3 and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2] then
      self.activetracking=true
  self.tracktarget=val
    if presses >1 then
    
    local channo = val.channel
    graphi:textlisten("float",{val.pos[1]+val.siz[1],val.pos[2]},"value: ")
    self.textinputfinish = function(va)
    local thingo= tonumber(va)
    graphi:sendsig(channo, thingo)
    end
    end
      return true
    elseif val.typ ==4 and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2] then
    
    local drawpoint={0,0}
    for Numbo, Valo in ipairs(val.colorslist) do
      if  x>val.pos[1]+val.dims[1]+drawpoint[1] and x<val.pos[1]+val.boxsize+drawpoint[1] and y>val.pos[2]+drawpoint[2]+val.dims[1] and y<val.pos[2]+drawpoint[2]+val.boxsize then
      drawi:setcolor(shallowcopy(Valo))
      val.lastclicked=Numbo
      graphi:updatediscolor()
      return true
      end
      if Numbo%val.nwidth==0 then
        drawpoint[1]=0
        drawpoint[2]=drawpoint[2]+val.boxsize
      else
        drawpoint[1]=drawpoint[1]+val.boxsize
      end
      
    end
    
    return true
    end
    
  end
  
  
  
  
end
return false
end

function graphi:scrollhandeler(xo,yo)
  
  
  
  local x, y = self:getmousepos()
  if x and y then 
    for Numb, val in pairs(self.items) do
      if val.typ == 4 and x> val.pos[1] and y>val.pos[2] and x<val.pos[1]+val.siz[1] and y<val.pos[2]+val.siz[2]  then
      
        
        --val.scrollpos[2] = math.min( math.max(val.scrollpos[2]+xo,0),math.min(val.siz[2]-val.boxsize*math.ceil(#val.colorslist/val.nwidth),0))
        val.scrollpos[2]=math.max( math.min(val.scrollpos[2]+yo,0),math.min(val.siz[2]-val.boxsize*math.ceil(#val.colorslist/val.nwidth),0) )
        
        return true
      end
      
    end
    
  end
  return false
end


function graphi:unclickhandle()
  if self.activetracking then
    self.activetracking=false
    self.tracktarget=nil
    return true
  end
  
  return false

end

function graphi:getmousepos()
   local x, y = love.mouse.getPosition()
  
  if x and y then
    x,y = x/push._SCALE.x, y/push._SCALE.y
   
    return x,y
    
  else
    return x,y
  end
  
end

function graphi:brushandle(command)
  local brushtoset=nil
  if command == "erase" then
    if not self.iserasor then
    local brushmem= {brush=drawi.brush, store=drawi.store, apply=drawi.apply}
    self.brushes.remember=shallowcopy(brushmem)
    brushtoset = "erase"
    
              graphi.items.erasorbox.text:set("brush")
    else
    brushtoset = "remember"
              graphi.items.erasorbox.text:set("erasor")
    end
    
    
    
    graphi.items.erasorbox.siz2={graphi.items.erasorbox.text:getWidth(),graphi.items.erasorbox.text:getHeight() }
    self.iserasor=not self.iserasor
  elseif command=="next" then
    if self.iserasor then
      print("yoooo")
      self.iserasor= false
      graphi.items.erasorbox.text:set("erasor")
      graphi.items.erasorbox.siz2={graphi.items.erasorbox.text:getWidth(),graphi.items.erasorbox.text:getHeight() }
    end
    
  graphi.brushid = (graphi.brushid % #graphi.brushlist) +1
 
  brushtoset = graphi.brushlist[graphi.brushid]
     graphi.items.brushbox.text:set(graphi.brushlist[graphi.brushid])
      graphi.items.brushbox.siz2={graphi.items.brushbox.text:getWidth(),graphi.items.brushbox.text:getHeight() }
  end
print(brushtoset)
    local tocopy 
    tocopy=shallowcopy(graphi.brushes[brushtoset])
        for copy_key, copy_value in pairs(tocopy) do
            drawi[copy_key] = copy_value
        end
    
  
end

graphi.brushlist={"replace", "subtract","add"}
graphi.brushes ={
  replace = {brush={drawi.lino}, store=drawi.replo, apply=drawi.replo},
  subtract = {brush={drawi.lino}, store=drawi.replo, apply=drawi.subbo},
  erase = {brush={drawi.linowhite}, store=drawi.replo, apply=drawi.subbo},
  add = {brush={drawi.lino}, store=drawi.replo, apply=drawi.addo}

}
print("yo")
print(graphi.brushes.replace.store)
return graphi