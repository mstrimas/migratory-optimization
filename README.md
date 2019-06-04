# Migratory optimization

This Shiny application maps the results from prioritizing land to support at least 30% of the global abundances of a suite of 117 Neotropical migratory bird species. The prioritizations are based on [eBird Status and Trends](https://ebird.org/science/status-and-trends) results, which use data from the citizen science project eBird to produce full annual cycle estimates of relative abundace at high spatiotemporal resolution. [Schuster et al. (2019)](https://www.nature.com/articles/s41467-019-09723-8) used these abundance maps to identify the optimal set of sites that protect at least 30% of the population of each species under different conservation scenarios. To run this application locally:

1. Install the latest versions of [R](https://cloud.r-project.org/) and [RStudio](https://www.rstudio.com/products/rstudio/download/#download).
2. [Download the contents of this repository](https://github.com/mstrimas/migatory-optimization/archive/master.zip) and unzip them. Then open the file `ebird-target-map.Rproj` in RStudio.
3. Install the required packages by running the following in the RStudio console: `install.packages(c("shiny", "leaflet"))`
4. At the console, run `shiny::runApp()` to start the application.

Schuster, R., Wilson, S., Rodewald, A.D., Arcese, P., Fink, D., Auer, T. and Bennett, J.R., 2019. Optimizing the conservation of migratory species over their full annual cycle. Nature communications, 10(1), p.1754.

