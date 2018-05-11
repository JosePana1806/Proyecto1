local daysMonths = {}
local daysYear = {}
local firstDay = 0
local year = 2015
local render = true

function setup ()   
    size(1200,600) 
    daysMonths = get_days_in_months(2015)
    firstDay = get_day_of_week(01, 01, year)[1]
    daysYear = get_days_of_year(year)        
    dayColor = os.date("*t",os.time{year=2015, month=5, day=1}).yday
    print (dayColor + (firstDay - 1))    
end

function draw ()
    if (render) then
        background(255)
        fill(255)
        stroke(0.5)
        drawCalendar()
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
        strokeWeight(0.3)
        rect(x*size,y+(daysYear[i]*size), size,size)
        if (daysYear[i] == 7) then            
            x = x + 1            
        end                    
        day = day + 1                   
    end
end