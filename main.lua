require "HeatMap"
require "data/csv"

local year = 2015
local width = 1200
local height = 600
local x = 5
local y = 100
local squareSize = 17
local data

function setup ()
    size(width, height)
    local f = loadFont("data/Vera.ttf",18)
    textFont(f)
    data = readCSV("Files/DatosAverias.csv",true,',')
    data = {data['date'], data['value']}
    --tittle = "vehicles sold in 2018"
    tittle="Breakdowns in the telephone service"
    hmc = HeatMapCalendar:new(x, y, squareSize, year, data, tittle)
end

function draw ()
    hmc:plot()
end
