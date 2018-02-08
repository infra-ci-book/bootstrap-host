[![Build Status](https://travis-ci.org/infra-ci-book/bootstrap-host.svg?branch=master)](https://travis-ci.org/infra-ci-book/bootstrap-host)

# bootstrap-host
This repository contains [Ansible](https://www.ansible.com/) roles and
playbooks to install [Virtualbox](https://www.virtualbox.org/) and
[Vagrant](https://www.vagrantup.com/).

## Requirements

Install base dependencies:

Requirements:

- Ansible >= 2.4.0.0
- CentOS >= 7.4

----

CentOS:

```
yum -y update
yum -y install ansible
reboot
```

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

If the storage capacity on this device is greater than or equal to this
size (in GB), the bootstrap process will use it.

    bootstrap_host_data_disk_min_size: 20

Vagrant default version and download directory detail.

    vagrant_version: "2.0.1"
    vagrant_checksum_sha256: "df28c4ba7420dc6983955cf3af66dddddd892ad852154e9b9dbcd1acbebc083c"
    vagrant_tmp_dir: "/tmp/vagrant_downloads"

The default directory inside Vagrantfile will be stored.
The `vagrant_box` and `vagrant_box_version` show the default Linux distribution
to use as box and the box version.

    vagrantfile_dir: "~/vagrant/infraci"
    vagrant_box: "centos/7"
    vagrant_box_version: "1710.01"

Virtual default package name details.

    virtualbox_pkgname: VirtualBox-5.2
    virtualbox_version: latest

## Dependencies

None.

## Installation

This assumes that you've installed the base dependencies and you're running on
CentOS.

```
git clone https://github.com/infra-ci-book/bootstrap-host.git
cd bootstrap-host
ansible-playbook -i hosts/vagrant site.yml
```

## License

Apache-2.0


