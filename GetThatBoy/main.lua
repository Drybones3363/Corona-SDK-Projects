local function get_image(s,typ)
	if s == nil then return end
	return "Images/"..s..(typ or ".png")
end

local Fonts = {
	JuneBug = native.newFont("Fonts/JuneBug.ttf",50)
}

local tablemt = { __index = table }

local Label = {}

Label.new = function(t)
	local tbl = {}
	if t.textStrokeWidth == nil then
		t.textStrokeWidth = 0
	end
	for i=t.textStrokeWidth,0,-1 do
		local lbl = display.newText(
			{
				x = t.x-i*t.shadowThickness*math.cos(math.rad(t.shadowAngle)),
				y = t.y-i*t.shadowThickness*math.sin(math.rad(t.shadowAngle)),
				width = t.width+5*i,
				height = t.height,
				font = t.font,
				fontSize = t.fontSize+i,
				text = t.text,
			}
		)
		if i == 0 then
			lbl:setFillColor(t.color.r,t.color.g,t.color.b)
		else
			lbl:setFillColor(t.textStrokeColor.r,t.textStrokeColor.g,t.textStrokeColor.b)
		end
		table.insert(tbl,lbl)
	end
	return setmetatable(tbl or {},tablemt)
end

function table.removeObj(tbl)
	for i,k in pairs (type(tbl) == "table" and tbl or {}) do
		pcall(function()
			k:removeSelf()
		end)
	end
end

function table.SetText(tbl,str)
	for i,k in pairs (type(tbl) == "table" and tbl or {}) do
		pcall(function()
			k.text = str
		end)
	end
end

function table.SetColor(tbl,base,stroke)
	pcall(function()
		tbl[#tbl]:setFillColor(base.r,base.g,base.b)
	end)
	if #tbl > 1 and stroke then
		for i=1,#tbl-1 do
			pcall(function()
				tbl[i]:setFillColor(stroke.r,stroke.g,stroke.b)
			end)
		end
	end
end

function table.RemoveStroke(tbl)
	if #tbl > 1 then
		for i=1,#tbl-1 do
			pcall(function()
				tbl[i]:removeSelf()
				tbl[i] = nil
			end)
		end
	end
end

local boy = graphics.newImageSheet(get_image("Boy"),{
		width = 146,
		height = 169,
		numFrames = 6,
		sheetContentWidth = 881,
		sheetContentHeight = 169
	}
)
local boy2 = graphics.newImageSheet(get_image("Boy2"),{
		width = 146,
		height = 169,
		numFrames = 6,
		sheetContentWidth = 881,
		sheetContentHeight = 169
	}
)

local lblWave = Label.new(
		{
			x = 300,
			y = 50,
			width = 300,
			height = 50,
			font = Fonts.JuneBug,
			fontSize = 30,
			text = '',
			color = {r=1,g=1,b=0},
			textStrokeWidth = 3,
			textStrokeColor = {r=.5,g=.5,b=0},
			shadowThickness = 3,
			shadowAngle = 90
	}
)

local Round = 0

function Wave(n)
	Round = n
	lblWave:SetText("WAVE "..tostring(n))
	local its = n*5 < 75 and n*5 or 75 --iterations
	local it = math.random(its) --dat boi
	local deb = 1/n*500 > 20 and 1/n*500 or 20
	local size = .8/math.ceil(n/3) + .2
	for i=1,its do
		timer.performWithDelay(deb*i,function()
			
			local anim = display.newSprite(it == i and boy or boy2,{
				start = 1,
				count = 6,
				time = 800*(size<.4 and .7 or 1),
				loopCount = 0
			})
			anim:scale(size,size)
			anim.x = -200
			anim.y = math.random(150,450)
			local did = false
			if i == it then
				anim:addEventListener('touch',function(event)
					if did == false then
						did = true
						Wave(n+1)
					end
				end)
			end
			timer.performWithDelay(33,function()
				if Round == n then
					pcall(function()
						anim.x = anim.x + 7 + math.ceil(n/4)--(size < .4 and 8 or 0)
					end)
				else
					pcall(function()
						anim:removeSelf()
						anim = nil
					end)
				end
			end,100)
			timer.performWithDelay(33*150,function()
				pcall(function()
					anim:removeSelf()
					anim = nil
					if i == it then
						lblWave:SetText("game over")
						lblWave:SetColor({r=1,g=.2,b=.2})
						lblWave:RemoveStroke()
					end
				end)
			end)
			anim:play()
		end)
	end
end

Wave(1)
