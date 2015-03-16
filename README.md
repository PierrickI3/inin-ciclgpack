# ciclgpack

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with ciclgpack](#setup)
    * [What ciclgpack affects](#what-ciclgpack-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ciclgpack](#beginning-with-ciclgpack)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Installs a CIC language pack silently and sets other settings accordingly

## Module Description

Simplifies the installation of a new language on a CIC 201xRx. Updates the media server analysis language model and the Windows culture settings accordingly.

## Setup

### What ciclgpack affects

* Installs the Language pack for the required language
* Changes the Windows culture settings to the requested language
* Updates the Media Server analysis language model via a server parameter

### Setup Requirements

A fully working and licensed CIC server 201xRx (i.e. 2015R1)

### Beginning with ciclgpack

Your language pack msi files should be available in a shared folder, available on the guest in the C:\daas-cache folder. This will soon change when mounting ISOs will be supported.

## Usage

class { 'ciclgpack':
  ensure      => installed,
  locale      => [ 'fr_FR', 'en_UK', 'nl_NL' ],
  cic_version => '2015_R2',
}

## Limitations

* Windows 2012R2
* CIC 2015R1 or later