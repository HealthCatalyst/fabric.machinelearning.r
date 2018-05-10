FROM healthcatalyst/fabric.baseos:latest
LABEL maintainer="Health Catalyst"
LABEL version="1.1"

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all

RUN mkdir -p /usr/lib64/R/library \
    && chown docker:docker /usr/lib64/R/library \
    && mkdir -p /usr/share/doc/R-3.4.4/html \
    && chown docker:docker /usr/share/doc/R-3.4.4/html \
    && mkdir -p /usr/lib64/R/doc/html \
    && chown docker:docker /usr/lib64/R/doc/html 
    
RUN yum -y install R libcurl-devel; yum clean all

ADD R.css /usr/share/doc/R-3.4.4/html/

ENV R_HOME /usr/lib64/R

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
ADD login.sh ./login.sh
ADD testsql.R ./testsql.R

RUN curl -o /etc/yum.repos.d/mssql-release.repo https://packages.microsoft.com/config/rhel/7/prod.repo && echo "curled" \
    && yum remove unixODBC-utf16 unixODBC-utf16-devel \
    && ACCEPT_EULA=Y yum install -y msodbcsql17-17.1.0.1-1 mssql-tools-17.1.0.1-1 unixODBC-devel && echo "installed" \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && echo "exported to bash_profile" \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && echo "exported to bashrc" \
    && source ~/.bashrc

RUN dos2unix ./docker-entrypoint.sh
RUN chmod a+x ./docker-entrypoint.sh
RUN dos2unix ./login.sh
RUN chmod a+x ./login.sh 

ENTRYPOINT ["./docker-entrypoint.sh"]

