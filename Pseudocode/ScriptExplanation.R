server <- function(input, output, session) {

# Shiny object scatMat
output$scatMatPlot <- renderPlotly({

# This function converts a ggplot2::ggplot() object to a plotly object.
ggPS <- ggplotly(pS, width=700, height=600)

# Use this function to supplement the widget's built-in JavaScript rendering logic with additional custom JavaScript code, just for this specific widget object.
# Usage: onRender(x, jsCode, data = NULL)
# x - An HTML Widget object
# jsCode - Character vector containing JavaScript code (see Details)
# data - An additional argument to pass to the jsCode function. This can be any R object that can be serialized to JSON. If you have multiple objects to pass to the function, use a named list. This is the JavaScript equivalent of the R object passed into onRender as the data argument; this is an easy way to transfer e.g. data frames without having to manually do the JSON encoding. In this case, data is what the user passes in as the data frame of read counts.
ggPS2 <- ggPS %>% onRender("
    function(el, x, data) {

    # If the user clicks the plotly image
    el.on('plotly_click', function(e) {
    
    # JavaScript to delete any old Plotly traces (orange dots)
    if (x.data.length > noPoint){
    Plotly.deleteTraces(el.id, range(noPoint, (noPoint+(len*(len-1)/2-1)), 1));
    }
    
    # JavaScript code determine which gene IDs are selected (selID)

    # Save selected row IDs for PCP
    # 'Shiny' below refers to a JavaScript object that is provided by Shiny and is available in JavaScript during the lifetime of an app
    # Instead of sending a message from Shiny to JavaScript, we can also send messages from JavaScript to Shiny. 
    # Object with name selID, and subsequently use it to send a message back to Shiny. Here, we tell it to make the message available in the R world under the name selID. That is, in R we can now listen for events via input$selID
    Shiny.onInputChange('selID', selID);
    
    # Create Traces variable for orange dots (attributes from Plotly) 
    var Traces = [];
    var trace = {
    mode: 'markers',
    marker: {
    color: 'orange',
    size: 6
    },
    text: selID,
    hoverinfo: 'text',
    };
    Traces.push(trace);
    Plotly.addTraces(el.id, Traces);
    })}
    ", data = data)

ggPS2

})

# Read in saved selectedIDs (Shiny command)
selID <- reactive(input$selID)
# Get read counts from these selectedIDs
pcpDat <- reactive(data[which(data$ID %in% selID()), ])

# Empty plotly boxplot
ggBP <- ggplotly(BP, width=700)

# Shiny object empty boxplot
output$boxPlot <- renderPlotly({
ggBP %>% onRender("
function(el, x, data) {

# Create Traces variable
var Traces = [];

var traceHiLine = {
mode: 'lines',
line: {
color: 'orange',
width: 1.5
},
opacity: 0.9,
text: selID,
hoverinfo: 'text',
}
Traces.push(traceHiLine);

Plotly.addTraces(el.id, Traces);

}", data = list(pcpDat = pcpDat(), nVar = nVar, colNms = colNms))})

}

