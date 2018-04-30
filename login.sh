#!/bin/sh

echo "---- begin login.sh from fabric.machinelearning.r version 2018.04.30.01 ----"

if [[ ! -z "${SERVICE_USER:-}" ]]; then
    if [[ -z "${SERVICE_USER:-}" ]]; then
        echo "SERVICE_USER must be specified"
        exit 1
    fi
    if [[ -z "${SERVICE_PASSWORD:-}" ]]; then
        echo "SERVICE_PASSWORD must be specified"
        exit 1
    fi
    if [[ -z "${AD_DOMAIN:-}" ]]; then
        echo "AD_DOMAIN must be specified"
        exit 1
    fi
    if [[ -z "${AD_DOMAIN_SERVER:-}" ]]; then
        echo "AD_DOMAIN_SERVER must be specified"
        exit 1
    fi

    /opt/install/setupkeytab.sh $SERVICE_USER $AD_DOMAIN $SERVICE_PASSWORD $AD_DOMAIN_SERVER

    echo "testing login to Active Directory"
    Rscript -e ./testsql.R
else
    echo "No SERVICE_USER was specified so running without authenticating to Active Directory"
fi

echo "---- end of login.sh from fabric.machinelearning.r ---"