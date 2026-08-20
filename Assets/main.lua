    love.graphics.setDefaultFilter("nearest","nearest")
love.graphics.setBlendMode("alpha","alphamultiply")
push = require "push"
drawi = require "drawi"
graphi = require "graphi"
utf8 = require("utf8")
function love.load()
--love._openConsole()
print(love.graphics:getBlendMode())

love.filesystem.setIdentity("luapaint")
local mountstatus = love.filesystem.mount("drawings","saves")
if not mountstatus then
  love.filesystem.createDirectory("drawings")
 mountstatus = love.filesystem.mount("drawings","saves")
  
end
--local bobby = nil
--local  t=love.filesystem.getDirectoryItems( "saves" )
  --for A,B in ipairs(t) do
  --print(A,B)
  --local rso, rso2 =pcall(function(B) return love.graphics.newImage("/drawings/"..B) end,B)
  --if  rso  then
   -- print("true")
   -- print(rso2)
 -- else
   -- print("false")
    --print(rso2)
  --end
  --end
local xo,yo =500,500
push:setupScreen(xo, yo, 500, 500, {fullscreen = false, resizable=true, canvas=false, pixelperfect=false})
  local siz1,siz2 = push:getDimensions()
  love.graphics.setBackgroundColor(0,0,0,0)
  drawactive=false
  drawi:setup(xo,yo, 60,10, 0.8)
  graphi:setup()
  end

function love.resize(w, h)
  push:resize(w, h)
  
end


function love.textinput(text )
  local  t=love.filesystem.getDirectoryItems( "saves" )
  if graphi.taketextinput then
    if (graphi.textinputtype == "txt") or ((graphi.textinputtype == "float" or graphi.textinputtype == "int") and ( tonumber(text))) or (graphi.textinputtype == "float" and (text == "." ))  then
    graphi.textstorage=graphi.textstorage .. text
    print(graphi.textstorage)
    end
  end
end

function love.keypressed(key, scancode)
  print(key)
  if graphi.taketextinput then
    print(graphi.textinputtype)
    if graphi.textinputtype ~="file" then
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(graphi.textstorage, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            graphi.textstorage = string.sub(graphi.textstorage, 1, byteoffset - 1)
        end
    end
  else
    if key == "w" or key == "up" then
      graphi.inputpoint = graphi.inputpoint +1
    if graphi.inputpoint > #graphi.files then
      graphi.inputpoint = 1
    end
    graphi.textstorage= graphi.files[graphi.inputpoint]
    elseif key == "s" or key == "down" then
      graphi.inputpoint = graphi.inputpoint -1
    if graphi.inputpoint < 1 then
      graphi.inputpoint = #graphi.files
    end
    graphi.textstorage= graphi.files[graphi.inputpoint]
    end
    
    end
    
    if key == "return" then
      print(graphi.textstorage)
    graphi.textinputfinish(graphi.textstorage)
    graphi.taketextinput=false
    end
    if key=="escape" then
    graphi.taketextinput=false
    end
  
    
  else
  if (key == "lctrl" and love.keyboard.isDown("z")) or  (key == "z" and love.keyboard.isDown("lctrl"))  then
    
  drawi.gobackw = true
elseif (key == "lctrl" and love.keyboard.isDown("y")) or  (key == "y" and love.keyboard.isDown("lctrl"))  then

  drawi.goforthw = true
end
end
end


function love.mousepressed(x,y,button, istouch, presses)
  if not graphi:clickhancle(presses) then
  
  
  drawi:MouseDownHandeler(button)
  drawactive=true
  end
end

function love.mousereleased(x,y,button, istouch, presses )
  graphi:unclickhandle()
  if drawactive then
  drawi:MouseUpHandeler(button)
  end
end

function love.draw()
 --love.graphics.clear({0,0,0,0})
 
  love.graphics.setCanvas()
  drawi:DrawHandle()
  love.graphics.setCanvas()
  
  graphi:drawit()
  
    
end

function love.update(dt)
drawi:updatehandle(dt)
end

function love.wheelmoved(x,y)
  
 if not graphi:scrollhandeler(x*2,y*2) then
   drawi:scrollhandler(x*0.5,y*0.5)
  end
end



