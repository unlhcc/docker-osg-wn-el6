FROM opensciencegrid/osg-wn:3.4-el6

# Required
# --------
# - cmsRun fails without stdint.h (from glibc-headers)
#   Tested CMSSW_7_4_5_patch1
#
# Other
# -----
# - ETF calls /usr/bin/lsb_release (from redhat-lsb-core)
# - sssd-client for LDAP lookups through the host
# - SAM tests expect cvmfs utilities
# - gcc is required by GLOW jobs (builds matplotlib)
#
# CMSSW dependencies
# ------------------
# Required software is listed under slc6_amd64_platformSeeds at
# http://cmsrep.cern.ch/cgi-bin/cmspkg/driver/cms/slc6_amd64_gcc700

RUN yum -y install cvmfs \
                   gcc \
                   glibc-headers \
                   openssh-clients \
                   osg-wn-client \
                   redhat-lsb-core \
                   sssd-client && \
    yum -y install glibc coreutils bash tcsh zsh perl tcl tk readline openssl \
                   ncurses e2fsprogs krb5-libs freetype compat-readline5 \
                   ncurses-libs perl-libs perl-ExtUtils-Embed fontconfig \
                   compat-libstdc++-33 libidn libX11 libXmu libSM libICE \
                   libXcursor libXext libXrandr libXft mesa-libGLU mesa-libGL \
                   e2fsprogs-libs libXi libXinerama libXft-devel libXrender \
                   libXpm libcom_err perl-Test-Harness libX11-devel \
                   libXpm-devel libXext-devel mesa-libGLU-devel nspr nss \
                   nss-util file file-libs readline zlib popt bzip2 \
                   bzip2-libs && \
    yum clean all

# Create condor user and group
RUN groupadd -r condor && \
    useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor

# Update to singularity from osg-development
RUN yum -y install --enablerepo osg-development singularity && \
    yum clean all

# Disable overlay
RUN perl -pi -e 's/^enable overlay =.*/enable overlay = no/g' /etc/singularity/singularity.conf

# Enable underlay
RUN perl -pi -e 's/^enable underlay =.*/enable underlay = yes/g' /etc/singularity/singularity.conf

# yum update
RUN yum update -y && \
    yum clean all
