library(reticulate)
library(shiny)
use_condaenv("pavian")



if(!require(pavian)){
  options(repos = c(CRAN = "http://cran.rstudio.com"))
  #runUrl("http://gitlab.naktuinbouw.net/bioinformatics/pavian/blob/master/pavian_0.8.4.tar.gz",filetype=".tar.gz.")
  #download.file("http://gitlab.naktuinbouw.net/bioinformatics/pavian/raw/master/pavian_0.8.4.tar.gz", "/tmp/pavian.tar.gz")
  #install.packages("/tmp/pavian.tar.gz", repos = NULL, type="source")
  install.packages(".", repos = NULL, type="source")
  library(pavian)
}

if (!require(Rsamtools)) {
  source("https://bioconductor.org/biocLite.R")
  biocLite("Rsamtools")
  library(Rsamtools)
}

if (!dir.exists(rappdirs::user_config_dir("pavian", expand = FALSE))) {
  dir.create(rappdirs::user_config_dir("pavian", expand = FALSE),
             recursive = TRUE)
}

### Option specifications
## Shiny options
# Specify the maximum web request size, which serves as a size limit for file uploads. If unset, the maximum request size defaults to 5MB
# see https://shiny.rstudio.com/reference/shiny/latest/shiny-options.html for global shiny options
options(shiny.maxRequestSize = 50 * 1024 ^ 2) # set to 50 MB
## do not set shiny.maxRequestSize here, because it overrides user options!

## DT options
# see https://datatables.net/reference/option/
options(
  DT.options = list(
    pageLength = 15,
    stateSave = TRUE,
    searchHighlight = TRUE,
    #scrollX = TRUE,
    dom = 'Bfrtip',
    ## Define the table control elements to appear
    #  B - Buttons
    #  f - filtering input
    #  r - processing display element
    #  t - The table!
    #  i - Table information summary
    #  p - pagination control
    lengthMenu = list(c(15, 25, 50, 100), c('15', '25', '50', '100')),
    search = list(regex = TRUE, caseInsensitive = TRUE)
  )
)

shiny::shinyApp(pavian::dashboardUI, pavian::pavianServer, enableBookmarking="server")
