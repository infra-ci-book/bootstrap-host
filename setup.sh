#!/bin/sh

set -e

if [ ${EUID:-${UID}} -ne 0 ]; then
  echo "WARN: This script must be run as root" 1>&2
  exit 1
fi

ANSIBLE_VERSION="2.4.2.0"

yum_makecache_retry() {
  tries=0
  until [ $tries -ge 5 ]
  do
    yum makecache && break
    let tries++
    sleep 1
  done
}

if [ -f /etc/centos-release ]; then
  # Check distro version
  if [ -n "$(rpm -q centos-release | grep el7)" ]; then
    # Check ansible is installed or not
    if [ -z "$(rpm -qa | grep ansible-$ANSIBLE_VERSION)" ]; then
      yum clean all
      rm -rf /var/cache/yum
      yum_makecache_retry
      # Install Git and Ansible
      yum -y install git ansible-$ANSIBLE_VERSION
    else
      INSTALLED_ANSIBLE=$(rpm -qa | grep ansible-$ANSIBLE_VERSION)
      echo "WARN: Ansible rpm: $INSTALLED_ANSIBLE is already installed"
    fi
  else
    echo "WARN: Could not detect supported specific CentOS version: CentOS 7.X"
  fi
else
  echo "WARN: Could not detect supported Linux distro: CentOS"
fi
