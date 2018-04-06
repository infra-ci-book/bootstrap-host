#!/bin/sh

set -e

ANSIBLE_VERSION="2.4.2.0"
ANSIBLE_LINT_VERSION="3.4.21"

yum_makecache_retry() {
  tries=0
  until [ $tries -ge 5 ]
  do
    yum makecache && break
    let tries++
    sleep 1
  done
}

if [ ${EUID:-${UID}} -ne 0 ]; then
  echo "WARN: This script must be run as root." 1>&2
  exit 1
fi

# Check Linux distro
if [ ! -e /etc/centos-release ]; then
  echo "WARN: Could not detect supported Linux distro: CentOS." 1>&2
  exit 1
fi

# Check distro version
if [ -z "$(rpm -q centos-release | grep el7)" ]; then
  echo "WARN: Could not detect supported specific CentOS version: CentOS 7.X." 1>&2
  exit 1
fi

yum clean all
rm -rf /var/cache/yum
yum_makecache_retry
# Update all packages
yum -y update
yum -y install epel-release
# One more time with EPEL to avoid failures
yum_makecache_retry

# Check git is installed or not
if [ -n "$(which git)" ]; then
  echo "INFO: Git is already installed."
else
  ## Install Git
  yum -y install git
  echo "INFO: Git has been successfully installed."
fi

# Check Ansible is installed or not
if [ -n "$(which ansible-playbook)" ]; then
  INSTALLED_ANSIBLE_VERSION=$(ansible --version | awk 'NR==1' | awk -F' ' '{print $2}')
  echo "INFO: Ansible ${INSTALLED_ANSIBLE_VERSION} is already installed."
  echo ""
  echo "INFO: Installed Ansible version:          ${INSTALLED_ANSIBLE_VERSION}"
  echo "INFO: Target Ansible version we expected: ${ANSIBLE_VERSION}"
  echo ""
  if [ ${INSTALLED_ANSIBLE_VERSION} != ${ANSIBLE_VERSION} ]; then
    echo "WARN: Installed Ansible version does not equal to ${ANSIBLE_VERSION}." 1>&2
    echo "WARN: Please uninstall Ansible at once and execute this script again." 1>&2
    exit 1
  fi
else
  # Install Ansible
  yum -y install ansible-${ANSIBLE_VERSION}
  echo "INFO: Ansible has been successfully installed."
fi

# Check Ansible Lint is installed or not
if [ -n "$(which ansible-lint)" ]; then
  INSTALLED_ANSIBLE_LINT_VERSION=$(ansible-lint --version | awk 'NR==1' | awk -F' ' '{print $2}')
  echo "INFO: Ansible Lint ${INSTALLED_ANSIBLE_LINT_VERSION} is already installed."
  echo ""
  echo "INFO: Installed Ansible Lint version:          ${INSTALLED_ANSIBLE_LINT_VERSION}"
  echo "INFO: Target Ansible Lint version we expected: ${ANSIBLE_LINT_VERSION}"
  echo ""
  if [ ${INSTALLED_ANSIBLE_LINT_VERSION} != ${ANSIBLE_LINT_VERSION} ]; then
    echo "WARN: Installed Ansible Lint version does not equal to ${ANSIBLE_LINT_VERSION}." 1>&2
    echo "WARN: Please uninstall Ansible Lint at once and execute this script again." 1>&2
    exit 1
  fi
else
  # Install Ansible Lint
  yum -y install ansible-lint-${ANSIBLE_LINT_VERSION}
  echo "INFO: Ansible Lint has been successfully installed."
fi

