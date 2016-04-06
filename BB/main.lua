local sounds = {
	--door_shut = audio.loadSound("Audio/DoorShut.wav"),
	
}

local widget = require("widget")

display.setStatusBar(display.HiddenStatusBar)

local objects = {}

local function Clear_Screen()
	for i,k in pairs (objects) do
		k:removeSelf()
		objects[i] = nil
	end
end

local function get_image(s,typ)
	if s == nil then return end
	return "Images/"..s..(typ or ".png")
end

local Tween_Table = {}

local function in_tween_tbl(gui)
	for i,k in pairs (Tween_Table) do
		if k[1] == gui then
			return k[2],i
		end
	end
end

local function Tween(gui,x,y,t)
	if not gui or not gui.x or not gui.y then return end
	if not x then x = gui.x end
	if not y then y = gui.y end
	local b,index,b2 = in_tween_tbl(gui)
	if not b then 
		table.insert(Tween_Table,{gui,true})
		index = #Tween_Table
		b2 = true
	else
		Tween_Table[index][2] = not Tween_Table[index][2]
		b2 = Tween_Table[index][2]
	end
	local xs,ys = gui.x,gui.y
	local xdif,ydif = xs-x,ys-y
	for i=1,31 do
		if i == 31 then
			timer.performWithDelay(33*i*t,function()
				if Tween_Table[index][2] == b2 then
					gui.x = x
					gui.y = y
				end
			end)
		else
			timer.performWithDelay(33*i*t,function()
				if gui.x and gui.y and Tween_Table[index][2] == b2 then
					gui.x = gui.x - xdif*(1/30)
					gui.y = gui.y - ydif*(1/30)
				end
			end)
		end
	end
end

--background sky color = Color3.new(.5,.5,1) (127,127,255)
