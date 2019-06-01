ui <- shinydashboard::dashboardPage()

server <- function(input, output, session) {
    
    # User input options
    shiny::observeEvent(input$goButton, values$x <- values$x + 1)
    shiny::observeEvent(input$selPair, values$x <- 0)
    shiny::observeEvent(input$selMetric, values$x <- 0)
    shiny::observeEvent(input$selOrder, values$x <- 0)
    shiny::observeEvent(input$binSize, values$x <- 0)
    
    # Create reactive expression of plotly background litre plot
    gP <- reactive({
        p <- ggplot2::ggplot(hexdf)
        gP <- plotly::ggplotly(p)
    })
    
    output$hexPlot <- plotly::renderPlotly({
        plotlyHex <- reactive(gP())

        # Use this function to supplement the widget's built-in JavaScript rendering logic with additional custom JavaScript code, just for this specific widget object.
        # Usage: onRender(x, jsCode, data = NULL)
        # x - An HTML Widget object
        # jsCode - Character vector containing JavaScript code (see Details)
        # data - An additional argument to pass to the jsCode function. This can be any R object that can be serialized to JSON. If you have multiple objects to pass to the function, use a named list. This is the JavaScript equivalent of the R object passed into onRender as the data argument; this is an easy way to transfer e.g. data frames without having to manually do the JSON encoding. In this case, data is what the user passes in as the data frame of read counts.
        plotlyHex() %>% onRender("
         function(el, x, data) {
         
         # 
         Shiny.addCustomMessageHandler('points', function(drawPoints) {
         
         # JavaScript to delete any old Plotly traces (orange dots)
         if (x.data.length > noPoint){
         Plotly.deleteTraces(el.id, x.data.length-1);
         }
         var Traces = [];
         var trace = {
         x: drawPoints.geneX,
         y: drawPoints.geneY,
         mode: 'markers',
         marker: {
         color: drawPoints.pointColor,
         size: drawPoints.pointSize
         },
         text: drawPoints.geneID,
         hoverinfo: 'text',
         showlegend: false
         };
         Traces.push(trace);
         Plotly.addTraces(el.id, Traces);
         });}")
    })
    
    observe({
        pointSize <- input$pointSize * 4
        
        # Send x and y values of selected row into onRender() function
        session$sendCustomMessage(type = "points", message=list(geneX=geneX, geneY=geneY, pointSize = pointSize, geneID=geneID, pointColor=pointColor))
    })
    
    output$boxPlot <- plotly::renderPlotly({

        BP <- reactive(ggplot2::ggplot() + geom_boxplot())
        ggBP <- reactive(plotly::ggplotly(BP()))
        
        observe({
            session$sendCustomMessage(type = "lines", message=list(geneInfo=currGene(), geneID=geneID, pointColor=pointColor))
        })
        
        ggBP() %>% onRender("
        function(el, x, data) {
        
        noPoint = x.data.length;
        
        Shiny.addCustomMessageHandler('lines',
        function(drawLines) {
        
        Plotly.deleteTraces(el.id, (i-1));
        
        var dLength = drawLines.geneInfo.length
        
        var Traces = [];
        var traceLine = {
        x: range(1, dLength, 1),
        y: drawLines.geneInfo,
        mode: 'lines',
        line: {
        color: drawLines.pointColor,
        width: 2
        },
        opacity: 0.9,
        text: drawLines.geneID,
        hoverinfo: 'text',
        }
        Traces.push(traceLine);
        Plotly.addTraces(el.id, Traces);
        })
        }")})
}

shiny::shinyApp(ui = ui, server = server)
