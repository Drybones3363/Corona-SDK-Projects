-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")


-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local function get_image(s,typ)
	return "Images/"..s..(typ or ".png")
end

local objects = {}

local function Clear_Screen()
	for i,k in pairs (objects) do
		k:removeSelf()
		objects[i] = nil
	end
end

local function Start_Game(n)
	local randnums,num = {} --if random number is nil for a player, the player is eliminated
	math.randomseed(os.time())
	for i=1,n do
		table.insert(randnums,math.random(1337))
	end
	local plr = 1
	local lblTanR = display.newText(
		{
			text = "Tangent(R) = "..tostring(math.tan(randnums[plr])):sub(1,7),
			x = 160,
			y = 310,
			font = native.systemFont,
			align = "center"
		}
	)
	table.insert(objects,lblTanR)
	local lblR = display.newText(
		{
			text = "R = Random Number for each Player",
			x = 160,
			y = 280,
			font = native.systemFont,
			align = "center"
		}
	)
	table.insert(objects,lblR)
	local lblPlr = display.newText(
		{
			text = "Player 1",
			x = 160,
			y = 70,
			font = native.systemFont,
			fontSize = 75,
			align = "center"
		}
	)
	lblPlr:setTextColor(0,255,0)
	table.insert(objects,lblPlr)
	local lblNum = display.newText(
		{
			text = num and "Number to beat: "..tostring(num) or "",
			x = 160,
			y = 250,
			font = native.systemFont,
			align = "center"
		}
	)
	table.insert(objects,lblNum)
	local txtValue = native.newTextField(160,350,75,20)
	table.insert(objects,txtValue)
	local cmdEnter
	local function Visible(b)
		pcall(function()
			lblPlr.isVisible = b
			lblTanR.isVisible = b
			lblR.isVisible = b
			lblNum.isVisible = b
			txtValue.isVisible = b
			cmdEnter.isVisible = b
		end)
	end
	cmdEnter = widget.newButton(
		{
			x = 160,
			y = 420,
			defaultFile = get_image("Enter_s"),
			overFile = get_image("Enter_p"),
			width = 200,
			height = 100,
			onEvent = function(event)
				if event.phase == "ended" and tonumber(txtValue.text) then
					local plr_now = plr
					local txt = txtValue.text 
					txtValue.text = ""
					local val = math.tan(tonumber(txt)+randnums[plr_now])
					if num == nil or val > num then
						num = val
						lblNum.text = num and "Number to beat: "..tostring(num) or ""
					else
						randnums[plr_now] = nil
						Visible(false)
						local lblElim = display.newText(
							{
								text = "Player "..tostring(plr_now).." Eliminated!",
								x = 160,
								y = 250,
								font = native.systemFont,
								fontSize = 50,
								align = "center",
								height = 150,
								width = 320
							}
						)
						lblElim:setTextColor(255,0,0)
						timer.performWithDelay(2100,function()
							lblElim:removeSelf()
							Visible(true)
						end)
					end
					local left,winner = 0
					for i=1,n do
						left = left + (randnums[i] and 1 or 0)
						if not winner then winner = randnums[i] and i or nil end
					end
					if left <= 1 then
						timer.performWithDelay(2100,function()
							Clear_Screen()
							local lblElim = display.newText(
								{
									text = "Player "..tostring(winner).." Won!!!",
									x = 160,
									y = 150,
									font = native.systemFont,
									fontSize = 50,
									align = "center"
								}
							)
							lblElim:setTextColor(50,255,0)
							timer.performWithDelay(5000,function()
								randnums = nil
								plr = nil
								num = nil
								lblElim:removeSelf()
								Menu()
							end)
						end)
					end
					repeat
						plr = (plr + 1)%n
						if plr == 0 then plr = n end
					until randnums[plr]
					lblPlr.text = "Player "..tostring(plr)
					lblTanR.text = "Tangent(R) = "..tostring(math.tan(randnums[plr])):sub(1,7)
				end
			end
		}
	)
	table.insert(objects,cmdEnter)
end

local function Num_Plrs_View()
	Clear_Screen()
	local txtPlrs = native.newTextField(160,270,30,20)
	txtPlrs:addEventListener("userInput",function(event)
		if event.phase == "editing" and txtPlrs.text:len() > 2 then
			txtPlrs.text = txtPlrs.text:sub(1,2)
		end
	end)
	table.insert(objects,txtPlrs)
	local cmdStart = widget.newButton(
		{
			x = 160,
			y = 420,
			defaultFile = get_image("start_s"),
			overFile = get_image("start_p"),
			width = 200,
			height = 100,
			onEvent = function(event)
				if event.phase == "ended" and txtPlrs.text ~= "" then
					if tonumber(txtPlrs.text) and tonumber(txtPlrs.text) > 1 then
						Clear_Screen()
						Start_Game(tonumber(txtPlrs.text))
					else
						txtPlrs.text = ""
						local lbl = display.newText(
							{
								text = "Not a valid number of players",
								x = 160,
								y = 350,
								font = native.systemFont,
								align = "center"
							}
						)
						lbl:setTextColor(255,0,0)
						lbl.alpha = 1
						table.insert(objects,lbl)
						timer.performWithDelay(1000,function()
							for i=1,10 do
								timer.performWithDelay(100*i, function()
									if lbl.alpha > .1 then
										lbl.alpha = lbl.alpha - .1
									else
										lbl:removeSelf()
									end
								end)
							end
						end)
					end
				end
			end		
		
		}
	)
	table.insert(objects,cmdStart)
	local picLogo = display.newImageRect(get_image("NumPlrs"),320,200)
	picLogo.x = 160
	picLogo.y = 75
	table.insert(objects,picLogo)
end

function Menu()
	Clear_Screen()
	local cmdPlay = widget.newButton(
		{
			x=160,
			y=420,
			defaultFile = get_image("play_s"),
			overFile = get_image("play_p"),
			width = 200,
			height = 100,
			onEvent = function(event)
				if event.phase == "ended" then
					Num_Plrs_View()
				end
			end
		}
	)
	table.insert(objects,cmdPlay)
	local picLogo = display.newImageRect(get_image("Logo"),320,200)
	picLogo.x = 160
	picLogo.y = 75
	table.insert(objects,picLogo)
end

Menu()
