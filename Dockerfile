FROM centos:centos6

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

RUN yum -y install http://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm && \
    yum -y install epel-release \
                   yum-plugin-priorities && \
    yum -y install cvmfs \
                   gcc \
                   glibc-headers \
                   openssh-clients \
                   osg-wn-client \
                   osg-wn-client-glexec \
                   redhat-lsb-core \
                   sssd-client && \
    yum clean all

# Create condor user and group
RUN groupadd -r condor && \
    useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor

# Add lcmaps.db
COPY lcmaps.db /etc/lcmaps.db

# yum update
RUN yum update -y && \
    yum clean all

# Install Singularity
RUN yum -y install --enablerepo osg-upcoming-development singularity && yum clean all

# Add singularity.conf
COPY singularity.conf /etc/singularity/singularity.conf
