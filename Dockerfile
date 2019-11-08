FROM rocker/r-ver:3.6.1

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget

RUN sudo apt-get install -y libbz2-dev liblzma-dev

RUN sudo apt-get install libmariadb-client-lgpl-dev -y

# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')"

COPY pavian /usr/bin/pavian

RUN R CMD INSTALL /usr/bin/pavian

RUN R -e "install.packages(c('reticulate','ggplot2'))"

#RUN R -e "install.packages('rhandsontable')"

#RUN R -e "install.packages('shinydashboard')"

#RUN R -e "install.packages(c('shinyjs', 'shinycssloaders', 'shinyWidgets', 'DT', 'dplyr', 'htmltools', 'htmlwidgets', 'plyr', 'rmarkdown', 'sankeyD3', 'shinyFileTree', 'RColorBrewer', 'colorspace', 'rappdirs'))"

RUN R -e "install.packages('remotes')"

RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager');BiocManager::install('Rhtslib');BiocManager::install('Rsamtools')"

#RUN R -e "BiocManager::install('devtools')"

RUN R -e "remotes::install_deps('/usr/bin/pavian')"

RUN R -e "install.packages(c('DBI','RMySQL'))"

RUN cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh

CMD ["/usr/bin/shiny-server.sh"]
