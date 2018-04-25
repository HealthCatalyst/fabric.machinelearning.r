FROM healthcatalyst/fabric.baseos:latest
LABEL maintainer="Health Catalyst"
LABEL version="1.0"

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all

RUN mkdir -p /usr/lib64/R/library \
    && chown docker:docker /usr/lib64/R/library \
    && mkdir -p /usr/share/doc/R-3.4.4/html \
    && chown docker:docker /usr/lib64/R/library 

RUN yum -y install R; yum clean all

ADD R.css /usr/share/doc/R-3.4.4/html/

# Setup R configs. R package versions are not yet specified; will use most recent.
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r); .libPaths('/usr/lib64/R/library')" > ~/.Rprofile \
    && Rscript -e "install.packages(c('ggplot2', 'needs', 'jsonlite', 'dplyr', 'RODBC', 'healthcareai'))"
# install any other packages here

# RUN cd \
#     && wget https://download2.rstudio.org/rstudio-server-rhel-1.0.136-x86_64.rpm \
#     && yum install --nogpgcheck rstudio-server-rhel-1.0.136-x86_64.rpm -y \
#     && systemctl status rstudio-server.service \
#     && systemctl enable rstudio-server.service

ADD docker-entrypoint.sh ./docker-entrypoint.sh

ENV R_HOME /usr/lib64/R

RUN dos2unix ./docker-entrypoint.sh \
	&& chmod a+x ./docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]

