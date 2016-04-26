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

RUN yum -y install http://repo.grid.iu.edu/osg/3.3/osg-3.3-el6-release-latest.rpm && \
    yum -y install epel-release && \
    yum -y install osg-wn-client osg-wn-client-glexec cvmfs && \
    yum -y install glibc-headers && \
    yum -y install redhat-lsb-core sssd-client && \
    yum clean all && \
    yum -y update

# Create condor user and group
RUN groupadd -r condor && \
    useradd -r -g condor -d /var/lib/condor -s /sbin/nologin condor

# Add HCC yum repo
ADD hcc-el6.repo /etc/yum.repos.d/hcc.repo

# Install local dependencies
RUN yum -y install \
        lcmaps-plugins-condor-update \

# These plugins are not working inside Docker
#        lcmaps-plugins-mount-under-scratch \
#        lcmaps-plugins-process-tracking
