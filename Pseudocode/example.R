\documentclass[parskip=full]{bmcart}
\setlength{\parskip}{10pt}
\usepackage[vlined]{algorithm2e}
\begin{document}

\DontPrintSemicolon
\begin{algorithm}[H]
\SetAlgoLined
\KwData{Data frame input by user}
\KwResult{Interactive scatterplot matrix}

/* \textit{Declare Shiny server}\;
server $\leftarrow$ function(input, output, session)\{\;
    %\BlankLine
    \Indp/* \textit{Declare Shiny output scatterplot matrix}\;
    output\$scatMatPlot $\leftarrow$ renderPlotly(\{\;
        %\BlankLine
        \Indp\Indp/* Draw hexagons and x=y line in bottom-left corner of matrix\;
        my\_fn $\leftarrow$ function(data, mapping)\{\}\;
        %\BlankLine
        /* \textit{Create static scatterplot matrix}\;
        p $\leftarrow$ ggpairs(data, lower = list(continuous = my\_fn))\;
        %\BlankLine
        /* \textit{Convert ggplot2::ggplot() object to plotly object}\;
        ggP $\leftarrow$ ggplotly(p)\;
        %\BlankLine
        /* \textit{Tailor plotly scatterplot matrix interactivity with JavaScript}\;
        ggPR $\leftarrow$ ggP \%$>$\% onRender("function(el, x, data)\{\;
%\BlankLine
\Indp/* \textit{If the user clicks on the plotly scatterplot matrix object}\;
el.on('plotly\_click', function(e)\{\;
%\BlankLine
\Indp/* \textit{Delete any old superimposed plotly geoms (orange dots)}\;
if (x.data.length $>$ 0)\{Plotly.deleteTraces(el.id)\}\;
%\BlankLine
/* \textit{Determine gene IDs selected by user click. Save as object called selID with handle called 'selID' so it can be read outside current JavaScript function back in Shiny}\;
Shiny.onInputChange('selID', selID)\;
%\BlankLine
/* \textit{Create traces for selected gene IDs as orange points that state gene names upon hovering}\;
trace = \{mode: 'markers', color: 'orange', size: 6, text: selID, hoverinfo: 'text'\}\;
%\BlankLine
/* \textit{Superimpose traces onto the plotly scatterplot matrix object}\;
Plotly.addTraces(el.id, Traces)\;
\Indm\})\;
\Indm\}\;
%\BlankLine
\Indm/* \textit{Pass the R data object into the JavaScript function}\;
", data = data)\;
        \Indm\})\;
    
    \BlankLine
    
    /* \textit{Read into Shiny the gene IDs that user clicked on}\;
    selID $\leftarrow$ reactive(input\$selID)\;
    /* \textit{Create data subset (read counts) for only the selected gene IDs}\;
    pcpDat $\leftarrow$ reactive(data[which(data\$ID \%$>$\% selID()), ])\;
    /* \textit{Create static box plot of the full dataset}\;
    BP $\leftarrow$ ggplot(data) $+$ geom\_boxplot()\;
    /* \textit{Render boxplot interactive as a plotly object}\;
    ggBP $\leftarrow$ ggplotly(BP)\;
    
    \BlankLine
    
    /* \textit{Declare Shiny output boxplot}\;
    output\$boxPlot $\leftarrow$ renderPlotly(\{\;
        
        \Indp/* \textit{Tailor interactivity of the plotly boxplot object using custom JavaScript}\;
        ggBP \%$>$\% onRender("function(el, x, data)\{\;

\Indp/* \textit{Create traces for selected gene IDs as orange lines that state gene names upon hovering}\;
trace = \{mode: 'lines', color: 'orange', width: 1.5, text: selID, hoverinfo: 'text'\}\;

/* \textit{Push traces to be superimposed onto the plotly scatterplot matrix object}\;
Plotly.addTraces(el.id, Traces)\;

/* \textit{Pass R objects into the JavaScript function}\;
\Indm\}", data = list(pcpDat = pcpDat())\;
                              \Indm)\;
        \Indm\})\;
    \Indm\}\;

\caption{Psuedocode for interactive scatterplot matrix}
\end{algorithm}
\end{document}


