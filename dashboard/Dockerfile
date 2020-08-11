FROM openanalytics/r-base

RUN R -e "install.packages(c('shiny', 'rmarkdown', 'shinydashboard', 'leaflet'), repos='https://cloud.r-project.org/')"

RUN mkdir /root/app

COPY . /root/app

COPY Rprofile.site /usr/lib/R/etc/

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/root/app')"]
