# Ubuntu 18.04 Vagrant Box with Docker

**Current Ubuntu Version Used**: 18.04.3

## Overview

Packer demo configuration for creating an `Ubuntu 18.04` box with Docker pre-installed.

Based on [geerlingguy/packer-ubuntu-1804](https://github.com/geerlingguy/packer-ubuntu-1804).

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/)

## Usage

Run the following command:

    $ packer build ubuntu1804.json

After a few minutes, Packer should tell you the box was generated successfully.

## Testing built boxes

The `Vagrantfile` included in this repository can be used to quickly test the Vagrant boxes that you build. 

From this same directory, run the following command after building the box:

    $ vagrant up
