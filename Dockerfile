FROM r-base

RUN apt-get update && apt-get install -y \
  build-essential \
  libcurl4-gnutls-dev \
  libxml2-dev \
  libssl-dev

RUN R -e "install.packages(c('shiny', 'shinydashboard', 'ggplot2', 'remotes', 'dplyr', 'stringr'), repos='https://cloud.r-project.org/')"

RUN R -e "remotes::install_github('plotly/plotly')"
#RUN R -e "remotes::install_github('rstudio/leaflet')"

RUN mkdir /root/app

COPY . /root/app

COPY Rprofile.site /usr/ib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app')"]
