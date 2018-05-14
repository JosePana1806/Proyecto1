local daysMonths = {}
local daysYear = {}
local firstDay = 0
local year = 2015
local render = true
local squareSize = 0
local dayColors = {}
local data = {}
local tittle = ""
local monthNames = {"JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"}
local daysNames = {"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
local xPosition = 0
local yPosition = 0

local mousePress=false --boolean
local  mousex = 0
local mousey = 0

HeatMapCalendar = HeatMapCalendar or {}

function HeatMapCalendar:new (x, y, sqrSz, yr, dt, pTittle)
    d = {}
    setmetatable(d, self)
    self.__index = self
    squareSize = sqrSz or 17
    year = yr or 2015
    tittle = pTittle or "Titulo"
    xPosition = x or 0
    yPosition = y or 0
    daysMonths = get_days_in_months(year)
    firstDay = get_day_of_week(01, 01, year)[1]
    daysYear = get_days_of_year(year)

    data = dt or {}
    dayColors = convertDataToDayColors(data, daysYear)
    return d
end

function HeatMapCalendar:plot ()
    if(render) then
        background(255)
        header()
        fill(255)
        stroke(0.5)
        drawCalendar(x, y, squareSize)
        render = false
    end
end

function get_days_in_months(yr)
    months_days = {}
    for mnth=1, 13 do
        months_days[mnth] = os.date('*t',os.time{year=yr,month=mnth+1,day=0})['day']
  end
    return months_days
end

function get_day_of_week(dd, mm, yy)
    dw=os.date('*t',os.time{year=yy,month=mm,day=dd})['wday']
    return {dw,({"Dom","Lun","Mar","Mier","Jue","Vie","Sab" })[dw]}
end

function get_days_of_year(yyyy)
    days = 365
    month = 1
    day = 1
    days_of_year = {}
    if (daysMonths[2] == 29) then
        days = 366
    end
    for i=firstDay, days + firstDay - 1 do
        if (day > daysMonths[month]) then
            day = 1
            month = month + 1
        end

        days_of_year[i] = get_day_of_week(day, month, year)[1]
        day = day + 1
    end
    return days_of_year
end

--Mouse region
function regionhit(x, y, w, h)
    if (mousex < x or
      mousey < y or
      mousex >= x + w or
      mousey >= y + h) then
        return false
   end
    return true
end

function mouseMoved(x,y)
   mousex = x
   mousey = y
end

function mousePressed(x,y)
    mousePress = true
    return true
end

function mousePressedOff(x,y)
    mousePress = false
    print(mousePress)
end
--end mouse region

function drawCalendar(x, y, size)
    x = x or 5
    y = y or 100
    size = size or 17
    day = 1
    month = 1
    for i = firstDay, #daysYear do
        strokeWeight(3)
        if (day > daysMonths[month]) then
            --x = x + 1
            day = 1
            month = month + 1
            line(x*size, y+(daysYear[i]*size), (x*size) + size, y+(daysYear[i]*size))
            line(x*size, y+(daysYear[i]*size), (x*size), y+(daysYear[i]*size) + ((8-daysYear[i])*size))
            line(x*size + size, y+(size), x*size + size, y+(daysYear[i]*size) + ((8-daysYear[i])*size))
        end
        if (daysYear[i-1] == nil or daysYear[i-1] > daysYear[i]) then
            line(x*size, y+(daysYear[i]*size), (x*size) + size, y+(daysYear[i]*size))
            if (daysYear[i-1] == nil) then
                line(x*size, y+(daysYear[i]*size), (x*size), y+(daysYear[i]*size) + ((8-daysYear[i])*size))
                line(x*size + size, y+(size), x*size + size, y+(daysYear[i]*size) + ((8-daysYear[i])*size))
            end
        elseif (daysYear[i+1] == nil or daysYear[i+1] < daysYear[i]) then
            strokeWeight(2)
            line(x*size, (y+(daysYear[i]*size)+size), (x*size) + size, (y+(daysYear[i]*size)+size))
            if (daysYear[i+1] == nil) then
                line(x*size, (y+(daysYear[i]*size)+size), (x*size), (y+(daysYear[i]*size)+size) + ((7-daysYear[i])*size))
                line(x*size + size, y+(size), x*size + size, y+(daysYear[i]*size) + ((6-daysYear[i])*size))
            end
        end
        if (dayColors[i]) then
            if (dayColors[i] > 0 and dayColors[i] <= 10) then
                fill("#FFFFB9")
            elseif (dayColors[i] > 10 and dayColors[i] <= 25) then
                fill("#FFC28E")
            elseif (dayColors[i] > 25 and dayColors[i] <= 50) then
                fill("#FF7C61")
            elseif (dayColors[i] > 50 and dayColors[i] <= 100) then
                fill("#D35940")
            elseif (dayColors[i] > 100) then
                fill("#88301E")
            end
        else
            fill(255)
        end

          strokeWeight(0.3)
          rect(x*size,y+(daysYear[i]*size), size,size)

        --  if(mousePressed(x*size,y+(daysYear[i]*size)) and regionhit(x*size,y+(daysYear[i]*size), size,size)) then
        --    print("si")
        --    rect(x*size,y+(daysYear[i]*size), size,size)
        --  end

        if (daysYear[i] == 7) then
            x = x + 1
        end
        day = day + 1
    end
end

function day_of_year(date)
    local i = 1
    dateArray = {}
    for token in string.gmatch(date, "[^%/]+") do
        dateArray[i] = token
        i = i + 1
    end
    dayColor = os.date("*t",os.time{year=dateArray[3], month=dateArray[2], day=dateArray[1]}).yday
    dayColor = dayColor + (firstDay - 1)
    return dayColor
end

function convertDataToDayColors(data, days)
    colors = {}
    for i=1, #data[1] do
        colors[day_of_year(data[1][i])] = tonumber(data[2][i])
    end
    return colors
end

function header()
    local gap = 50
    text(tittle, xPosition*squareSize, yPosition-4*squareSize)
    local f = loadFont("data/Vera.ttf",14)
    textFont(f)
    fill("#FFFFB9")
    rect(1*squareSize + gap + xPosition, (yPosition-2*squareSize)-squareSize, squareSize, squareSize)
    fill("#FFC28E")
    rect(8*squareSize + gap + xPosition, (yPosition-2*squareSize)-squareSize, squareSize, squareSize)
    fill("#FF7C61")
    rect(16*squareSize + gap + xPosition, (yPosition-2*squareSize)-squareSize, squareSize, squareSize)
    fill("#D35940")
    rect(24*squareSize + gap + xPosition, (yPosition-2*squareSize)-squareSize, squareSize, squareSize)
    fill("#88301E")
    rect(32*squareSize + gap + xPosition, (yPosition-2*squareSize)-squareSize, squareSize, squareSize)
    fill(0)
    text("up to 10", 1*squareSize + gap + xPosition + squareSize, yPosition-2*squareSize)
    text("up to 25", 8*squareSize + gap + xPosition + squareSize, yPosition-2*squareSize)
    text("up to 50", 16*squareSize + gap + xPosition + squareSize, yPosition-2*squareSize)
    text("up to 100",24*squareSize + gap + xPosition + squareSize, yPosition-2*squareSize)
    text("over 100", 32*squareSize + gap + xPosition + squareSize, yPosition-2*squareSize)
    fill(130)
    text(year, xPosition*squareSize, yPosition-squareSize)
    for i=1, #daysNames do
        text(daysNames[i], xPosition+2*squareSize, (yPosition+squareSize)+(i*squareSize))
    end
    for i=1, #monthNames do
        text(monthNames[i], ((1*squareSize + gap + 2*xPosition)*i) + squareSize, yPosition+(squareSize/2))
    end
end
