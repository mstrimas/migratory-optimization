// developed by Nadieh Bremer
// http://bl.ocks.org/nbremer/5cd07f2cb4ad202a9facfbd5d2bc842e

///////////////////////////////////////////////////////////////////////////
//////////////////// Set up and initiate svg containers ///////////////////
///////////////////////////////////////////////////////////////////////////	

var margin = {
	top: 30,
	right: 30,
	bottom: 50,
	left: 30
};

//First try for width
var width = 250;
var height = 20;


//SVG container
var svg = d3.select('#legend')
	.append("svg")
	.attr("width", width + margin.left + margin.right)
	.attr("height", height + margin.top + margin.bottom)
	.append("g")
	.attr("transform", "translate(" + margin.left + ")");
	
//Needed for gradients			
var defs = svg.append("defs");

///////////////////////////////////////////////////////////////////////////
//////// Get continuous color scale for the Yellow-Green-Blue fill ////////
///////////////////////////////////////////////////////////////////////////

var coloursYGB = ["#0D0887FF", "#1B068DFF", "#270591FF", "#300597FF", "#3A049AFF", "#43039EFF", "#4B03A1FF", "#5402A3FF", "#5C01A6FF", "#6400A7FF", "#6C00A8FF", "#7401A8FF", "#7C02A8FF", "#8405A7FF", "#8B0AA5FF", "#920FA3FF", "#99159FFF", "#A11A9CFF", "#A72197FF", "#AD2793FF", "#B32C8EFF", "#B93289FF", "#BE3885FF", "#C43E7FFF", "#C9447AFF", "#CD4A76FF", "#D25071FF", "#D7566CFF", "#DB5C68FF", "#DF6263FF", "#E3685FFF", "#E76E5BFF", "#EB7557FF", "#EE7B51FF", "#F1814DFF", "#F48849FF", "#F68F44FF", "#F9963FFF", "#FA9E3BFF", "#FCA537FF", "#FDAC33FF", "#FDB42FFF", "#FEBC2AFF", "#FDC527FF", "#FCCD25FF", "#FBD524FF", "#F9DE25FF", "#F6E726FF", "#F3F027FF", "#F0F921FF"];
var colourRangeYGB = d3.range(0, 1, 1.0 / (coloursYGB.length - 1));
colourRangeYGB.push(1);
		   
//Create color gradient
var colorScaleYGB = d3.scale.linear()
	.domain(colourRangeYGB)
	.range(coloursYGB)
	.interpolate(d3.interpolateHcl);

//Needed to map the values of the dataset to the color scale
var colorInterpolateYGB = d3.scale.linear()
	.domain([1,52])
	.range([0,1]);

///////////////////////////////////////////////////////////////////////////
///////////////////// Create the YGB color gradient ///////////////////////
///////////////////////////////////////////////////////////////////////////

//Calculate the gradient	
defs.append("linearGradient")
	.attr("id", "gradient-ygb-colors")
	.attr("x1", "0%").attr("y1", "0%")
	.attr("x2", "100%").attr("y2", "0%")
	.selectAll("stop") 
	.data(coloursYGB)                  
	.enter().append("stop") 
	.attr("offset", function(d,i) { return i/(coloursYGB.length-1); })   
	.attr("stop-color", function(d) { return d; });

///////////////////////////////////////////////////////////////////////////
////////////////////////// Draw the legend ////////////////////////////////
///////////////////////////////////////////////////////////////////////////

var legendWidth = 200,
	legendHeight = 20;

//Color Legend container
var legendsvg = svg.append("g")
	.attr("class", "legendWrapper")
	.attr("transform", "translate(" + (width/2 - 10) + "," + (height+20) + ")");

//Draw the Rectangle
legendsvg.append("rect")
	.attr("class", "legendRect")
	.attr("x", -legendWidth/2)
	.attr("y", 10)
	//.attr("rx", legendHeight/2)
	.attr("width", legendWidth)
	.attr("height", legendHeight)
	.style("fill", "none");
	
//Append title
legendsvg.append("text")
	.attr("class", "legendTitle")
	.attr("x", 0)
	.attr("y", -2)
	.text("Selection frequency (# weeks)");

//Set scale for x-axis
var xScale = d3.scale.linear()
	 .range([0, legendWidth])
	 .domain([1,52]);
	 //.domain([d3.min(pt.legendSOM.colorData)/100, d3.max(pt.legendSOM.colorData)/100]);

//Define x-axis
var xAxis = d3.svg.axis()
	  .orient("bottom")
	  //.ticks(2)
	  .tickValues(xScale.domain())
	  .scale(xScale);

//Set up X axis
legendsvg.append("g")
	.attr("class", "axis")  //Assign "axis" class
	.attr("transform", "translate(" + (-legendWidth/2) + "," + (10 + legendHeight) + ")")
	.call(xAxis);

//Fill the legend rectangle
svg.select(".legendRect")
	.style("fill", "url(#gradient-ygb-colors)");
currentFill = "YGB";