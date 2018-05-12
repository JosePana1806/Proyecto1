require "data/csv"
require "data/dbg/DklBaseGraphics"

local bg
local data

function setup()
	size(500,350)
	local f = loadFont("data/Vera.ttf",18)
	textFont(f)
	bg = DklBaseGraphics:new(width(),height())
	data = readCSV("data/data.csv",true,',')		
end

function draw()
	background(255)
	--bg:plot(data['date'],data['value'],{main="Pressure (mm Hg)",xlab="temperature",ylab="pressure"})
end

function windowResized(w,h)
	bg:resize_window(w,h)
end
