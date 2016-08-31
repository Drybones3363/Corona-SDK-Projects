local Data = {
	Computer = {
		Average = 350
	}

}

local Scores = {}

local Point_Table = {
    "1s" = {1,function (dice) return true end},
    "2s" = {2,function (dice) return true end},
    "3s" = {3,function (dice) return true end},
    "4s" = {4,function (dice) return true end},
    "5s" = {5,function (dice) return true end},
    "6s" = {6,function (dice) return true end},
    "Three of a Kind" = {0,function(dice)
        local t = {0,0,0,0,0,0}
        for i=1,#dice do
            t[dice[i] ] = t[dice[i] ] + 1
            if t[dice[i] ] >= 3 then
                return true
            end
        end
    end},
    "Four of a Kind" = {0,function(dice)
        local t = {0,0,0,0,0,0}
        for i=1,#dice do
            t[dice[i] ] = t[dice[i] ] + 1
            if t[dice[i] ] >= 4 then
                return true
            end
        end
    end},
    "Full House" = {25,function(dice) 
	local t = {0,0,0,0,0,0}
	for i=1,#dice do
            t[dice[i] ] = t[dice[i] ] + 1
        end
	local b2,b3
	for i=1,#t do
		if t[i] == 2 then
			b2 = true
		elseif t[i] == 3 then
			b3 = true
		end
		if b2 and b3 then
			return true
		end
	end
    end},
	"Yahtzee" = {50,function(dice)
		local t = {0,0,0,0,0,0}
		for i=1,#dice do
			t[dice[i] ] = t[dice[i] ] + 1
			if t[dice[i] ] >= 5 then
				return true
			end
		end
	end},
	"Chance" = {0,function(dice) return true end},
	"Small Straight" = {30,function(dice)
		local t = {0,0,0,0,0,0}
		for i=1,#dice do
			t[dice[i] ] = t[dice[i] ] + 1
		end
		local i = 0
		for e=1,#t do
			if t[e] > 2 then return end
			if t[e] > 0 then
				i = i + 1
			else
				i = 0
			end
			if i >= 4 then
				return true
			end
		end
	end},
	"Large Straight" = {40,function(dice)
		local t = {0,0,0,0,0,0}
		for i=1,#dice do
			t[dice[i] ] = t[dice[i] ] + 1
		end
		local i = 0
		for e=1,#t do
			if t[e] > 1 then return end
			if t[e] > 0 then
				i = i + 1
			else
				i = 0
			end
			if i >= 5 then
				return true
			end
		end
	end},

	
}

local function Load_Screen()
	
end

local function Roll()
	
end

local function Total(t)
	local total = 0 
	for i,k in pairs (t) do
		total = total + k*Point_Table[i]
	end
	return total
end

local function Get_Roll()
	local av = Data.Computer.Average
	local score = Total(Scores.Computer)
	if av > score + 100 then
		local dice = {}
		for i=1,5 do
			dice[i] = math.random(6)
		end
	else

	end
end

function Start_Game()
    local t = {}
    for i,k in pairs (Point_Table) do
        t[i] = 0
    end
    Scores.Player = t
    local t = {}
    for i,k in pairs (Point_Table) do
        t[i] = 0
    end
    Scores.Computer = t
end







