library(leaflet)
library(shiny)

gh_repo <- "https://github.com/mstrimas/migratory-optimization/raw/master/"

ui <- bootstrapPage(
  tags$head(includeCSS("www/style.css"),
            tags$link(href = "https://fonts.googleapis.com/css?family=Open+Sans:300,400,700",
                      rel = "stylesheet",
                      type = "text/css"),
            tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.6/d3.min.js")),
  title = "Optimal conservation of migratory species",
  
  fluidRow(id = "main-row",
    # control panel
    column(width = 4, id = "sidebar-container", class = "well",
      h4("Optimal conservation of migratory species"),
      p("The following maps compare different approaches for prioritizing",
        "land to support at least 30% of the global abundances of a suite of",
        "117 Neotropical migratory bird species. The prioritizations are",
        "based on",
        a("eBird Status and Trends", 
          href = "https://ebird.org/science/status-and-trends"),
        "results, which use data from the citizen science project",
        a("eBird", href = "https://ebird.org"),
        "to produce full annual cycle estimates of relative abundace at high",
        "spatiotemporal resolution.",
        a("Schuster et al. (2019)", 
          href = "https://www.nature.com/articles/s41467-019-09723-8"),
        "used these abundance maps to identify the optimal set of sites that",
        "protect at least 30% of the population of each species under",
        "different conservation scenarios. Choose a scenario to view",
        "the selected sites."),
      
      # choose scenario
      span(strong("Weekly vs. yearly")),
      tags$small("Prioritize sites for each week individually ",
                 "(weekly), then combines the selected sites, ",
                 "or simultaneously prioritizes sites for all weeks",
                 "(yearly)."),
      radioButtons("week_year", NULL, inline = TRUE,
                   choices = c("Weekly" = "wk", 
                               "Yearly" = "yr")),
      
      span(strong("Intact habitat vs. shared-use")),
      tags$small("Emphasize the protection of relatively intact habitat",
                 "(intact habitat), based on the ",
                 a("Human Footprint Index", 
                   href = "https://wcshumanfootprint.org",
                   target = "_blank"),
                 ", or permit the inclusion of landscapes converted to more",
                 "intensive use by humans (shared-use)."),
      radioButtons("footprint", NULL, inline = TRUE,
                   choices = c("Intact habitat" = "hf", 
                               "Shared-use" = "nh")),
      
      span(strong("Clustering")),
      tags$small("Protect 30% of the global population of each species",
                 "(single population) or spatially cluster the abundance of",
                 "each species into five groups, then protect 30% of each",
                 "subpopulation (spatial clustering)."),
      radioButtons("clustering", NULL, inline = TRUE,
                   choices = c("Single population" = "nc", 
                               "Spatial clustering" = "cl")),
      div(class="text-center", 
          actionButton("submit_button", "View prioritization")
      ),
      
      div(class="text-center", 
          a("Download prioritization maps", 
            href = paste0(gh_repo, "data/migratory-optimization.zip"))
      ),
      
      # lengend
      conditionalPanel("input.week_year == 'wk'", {
        div(class = "text-center", id = "legend")
      }),
      conditionalPanel("input.week_year == 'yr'", {
        div(class = "text-center", 
            br(),
            tags$table(style = "border:0;width:50%;margin:auto", tags$tr(
              tags$td(style = "background-color:#cc4678;width:20px;height:20px"),
              tags$td("Selected sites",
                      style = "padding: 0 5px")
            )))
      }),
      includeScript("www/legend.js"),
      div(class = "text-center",
          htmlOutput("download_link", inline = TRUE)
      )
    ),
    
    # map
    column(width = 8, id = "map-container",
      leafletOutput("map")
    )
  )
)
