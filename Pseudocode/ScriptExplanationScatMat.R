
server <- function(input, output, session) {
    
# Declare shiny output scatterplot matrix
output$scatMatPlot <- renderPlotly({

# Draw hexagon geoms and red x=y line in scatterplots in bottom-left corner of matrix
my_fn <- function(data, mapping, ...){}
    
# Create static scatterplot
p <- ggpairs(data, lower = list(continuous = my_fn))

# Convert a ggplot2::ggplot() object to a plotly object
ggP <- ggplotly(p)

# Specify that hovering over hexagons should indicate count number

# Tailor interactivity of the plotly scatterplot matrix object using custom JavaScript
ggPR <- ggP %>% onRender("function(el, x, data) {

    # If the user clicks on the plotly scatterplot matrix object
    el.on('plotly_click', function(e) {
    
    # If present, delete old superimposed plotly geoms (orange dots)
    if (x.data.length > 0){Plotly.deleteTraces(el.id)}
    
    # Determine which gene IDs are selected by the user click. Save as object called selID.

    # Save selID object with a handle called 'selID' so it can be read outside this JavaScript function back in Shiny
    Shiny.onInputChange('selID', selID);
    
    # Create traces for selected gene IDs as orange points that state gene names upon hovering
    trace = {mode: 'markers', color: 'orange', size: 6, text: selID, hoverinfo: 'text'}
    
    # Push traces to be superimposed onto the plotly scatterplot matrix object
    Plotly.addTraces(el.id, Traces);
    })}
    # Pass the R data object into the JavaScript function
    ", data = data)
})

# Read into Shiny the gene IDs that user clicked on
selID <- reactive(input$selID)
# Create data subset (read counts) for only the selected gene IDs
pcpDat <- reactive(data[which(data$ID %in% selID()), ])

# Create static box plot of the full dataset
BP <- ggplot(data) + geom_boxplot()

# Render boxplot interactive as a plotly object
ggBP <- ggplotly(BP)

# Declare shiny output boxplot
output$boxPlot <- renderPlotly({
# Tailor interactivity of the plotly boxplot object using custom JavaScript
ggBP %>% onRender("
function(el, x, data) {

# Create traces for selected gene IDs as orange lines that state gene names upon hovering
trace = {mode: 'lines', color: 'orange', width: 1.5, text: selID, hoverinfo: 'text'}
                  
# Push traces to be superimposed onto the plotly scatterplot matrix object
Plotly.addTraces(el.id, Traces);

# Pass R objects into the JavaScript function
}", data = list(pcpDat = pcpDat()))})
}

