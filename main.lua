--Variables
local title="Migrant deaths in the Mediterranean";
local units=" dead or missing";
local breaks=[10,25,50,100];
local colours=["#ffffd4","#fed98e","#fe9929","#d95f0e","#993404"];

    --general layout information
    local cellSize = 17;
    local xOffset=20;
    local yOffset=60;
    local calY=50;--offset of calendar in each group
    local calX=25;
    local width = 960;
    local height = 163;
    local parseDate = d3.time.format("%d/%m/%y").parse;
    format = d3.time.format("%d-%m-%Y");
    toolDate = d3.time.format("%d/%b/%y");

    d3.csv("data.csv", function(error, data) {

        --set up an array of all the dates in the data which we need to work out the range of the data
        local dates = new Array();
        local values = new Array();

        --parse the data
        data.forEach(function(d)    {
                dates.push(parseDate(d.date));
                values.push(d.value);
                d.date=parseDate(d.date);
                d.value=d.value;
                d.year=d.date.getFullYear();--extract the year from the data
        });

        local yearlyData = d3.nest()
            .key(function(d){return d.year;})
            .entries(data);

        local svg = d3.select("body").append("svg")
            .attr("width","90%")
            .attr("viewBox","0 0 "+(xOffset+width)+" 540")

        --title
        svg.append("text")
        .attr("x",xOffset)
        .attr("y",20)
        .text(title);

        --create an SVG group for each year
        local cals = svg.selectAll("g")
            .data(yearlyData)
            .enter()
            .append("g")
            .attr("id",function(d){
                return d.key;
            })
            .attr("transform",function(d,i){
                return "translate(0,"+(yOffset+(i*(height+calY)))+")";
            })

        local labels = cals.append("text")
            .attr("class","yearLabel")
            .attr("x",xOffset)
            .attr("y",15)
            .text(function(d){return d.key});

        --create a daily rectangle for each year
        local rects = cals.append("g")
            .attr("id","alldays")
            .selectAll(".day")
            .data(function(d) { return d3.time.days(new Date(parseInt(d.key), 0, 1), new Date(parseInt(d.key) + 1, 0, 1)); })
            .enter().append("rect")
            .attr("id",function(d) {
                return "_"+format(d);
                --return toolDate(d.date)+":\n"+d.value+" dead or missing";
            })
            .attr("class", "day")
            .attr("width", cellSize)
            .attr("height", cellSize)
            .attr("x", function(d) {
                return xOffset+calX+(d3.time.weekOfYear(d) * cellSize);
            })
            .attr("y", function(d) { return calY+(d.getDay() * cellSize); })
            .datum(format);

        --create day labels
        local days = ['Su','Mo','Tu','We','Th','Fr','Sa'];
        local dayLabels=cals.append("g").attr("id","dayLabels")
        days.forEach(function(d,i)    {
            dayLabels.append("text")
            .attr("class","dayLabel")
            .attr("x",xOffset)
            .attr("y",function(d) { return calY+(i * cellSize); })
            .attr("dy","0.9em")
            .text(d);
        })

        --let's draw the data on
        local dataRects = cals.append("g")
            .attr("id","dataDays")
            .selectAll(".dataday")
            .data(function(d){
                return d.values;
            })
            .enter()
            .append("rect")
            .attr("id",function(d) {
                return format(d.date)+":"+d.value;
            })
            .attr("stroke","#ccc")
            .attr("width",cellSize)
            .attr("height",cellSize)
            .attr("x", function(d){return xOffset+calX+(d3.time.weekOfYear(d.date) * cellSize);})
            .attr("y", function(d) { return calY+(d.date.getDay() * cellSize); })
            .attr("fill", function(d) {
                if (d.value<breaks[0]) {
                    return colours[0];
                }
                for (i=0;i<breaks.length+1;i++){
                    if (d.value>=breaks[i]&&d.value<breaks[i+1]){
                        return colours[i];
                    }
                }
                if (d.value>breaks.length-1){
                    return colours[breaks.length]
                }
            })

        --append a title element to give basic mouseover info
        dataRects.append("title")
            .text(function(d) { return toolDate(d.date)+":\n"+d.value+units; });

        --add montly outlines for calendar
        cals.append("g")
        .attr("id","monthOutlines")
        .selectAll(".month")
        .data(function(d) {
            return d3.time.months(new Date(parseInt(d.key), 0, 1),
                                  new Date(parseInt(d.key) + 1, 0, 1));
        })
        .enter().append("path")
        .attr("class", "month")
        .attr("transform","translate("+(xOffset+calX)+","+calY+")")
        .attr("d", monthPath);

        --retreive the bounding boxes of the outlines
        local BB = new Array();
        local mp = document.getElementById("monthOutlines").childNodes;
        for (var i=0;i<mp.length;i++){
            BB.push(mp[i].getBBox());
        }

        local monthX = new Array();
        BB.forEach(function(d,i){
            boxCentre = d.width/2;
            monthX.push(xOffset+calX+d.x+boxCentre);
        })

        --create centred month labels around the bounding box of each month path
        --create day labels
        local months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
        local monthLabels=cals.append("g").attr("id","monthLabels")
        months.forEach(function(d,i)    {
            monthLabels.append("text")
            .attr("class","monthLabel")
            .attr("x",monthX[i])
            .attr("y",calY/1.2)
            .text(d);
        })

         --create key
        local key = svg.append("g")
            .attr("id","key")
            .attr("class","key")
            .attr("transform",function(d){
                return "translate("+xOffset+","+(yOffset-(cellSize*1.5))+")";
            });

        key.selectAll("rect")
            .data(colours)
            .enter()
            .append("rect")
            .attr("width",cellSize)
            .attr("height",cellSize)
            .attr("x",function(d,i){
                return i*130;
            })
            .attr("fill",function(d){
                return d;
            });

        key.selectAll("text")
            .data(colours)
            .enter()
            .append("text")
            .attr("x",function(d,i){
                return cellSize+5+(i*130);
            })
            .attr("y","1em")
            .text(function(d,i){
                if (i<colours.length-1){
                    return "up to "+breaks[i];
                }   else    {
                    return "over "+breaks[i-1];
                }
            });

    });--end data load

    --pure Bostock - compute and return monthly path data for any year
    function monthPath(t0) {
      var t1 = new Date(t0.getFullYear(), t0.getMonth() + 1, 0),
          d0 = t0.getDay(), w0 = d3.time.weekOfYear(t0),
          d1 = t1.getDay(), w1 = d3.time.weekOfYear(t1);
      return "M" + (w0 + 1) * cellSize + "," + d0 * cellSize
          + "H" + w0 * cellSize + "V" + 7 * cellSize
          + "H" + w1 * cellSize + "V" + (d1 + 1) * cellSize
          + "H" + (w1 + 1) * cellSize + "V" + 0
          + "H" + (w0 + 1) * cellSize + "Z";
    }