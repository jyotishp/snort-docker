FROM centos:latest
MAINTAINER Jyotish P <me@jyotishp.ml>

# EPEL is needed for some dependencies
RUN yum -y install epel-release
# Instal DAQ and Snort from RPMs provided on snort.org
RUN yum -y install https://www.snort.org/downloads/snort/daq-2.0.6-1.centos7.x86_64.rpm \
	https://www.snort.org/downloads/snort/snort-2.9.11.1-1.centos7.x86_64.rpm

# Install libdnet (dependency for snort)
RUN yum -y install libdnet wget
RUN ln -s /usr/lib64/libdnet.so.1.0.1 /usr/lib64/libdnet.1

# The folders need to exist here too
RUN ln -s /usr/lib64/snort-2.9.11.1_dynamicengine \
       /usr/local/lib/snort_dynamicengine && \
    ln -s /usr/lib64/snort-2.9.11.1_dynamicpreprocessor \
       /usr/local/lib/snort_dynamicpreprocessor

# Download the ruleset and copy the config
RUN curl -LO https://researchweb.iiit.ac.in/~srisai.poonganam/config/snort.tar.xz
RUN mkdir -p snort && mkdir -p /usr/local/lib/snort_dynamicrules && tar xvf snort.tar.xz -C snort
RUN cp snort/etc/* /etc/snort/ && cp -r snort/preproc_rules/ /etc/snort/ && cp -r snort/rules /etc/snort/ && cp snort/so_rules/precompiled/Centos-7/x86-64/2.9.11.1/* /usr/local/lib/snort_dynamicrules/
