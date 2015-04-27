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

* Installs a CIC Language pack
* Changes the Windows culture settings to the requested language
* Adds a file on the desktop to help configuring media server and import dial plans

### Setup Requirements

A fully working and licensed CIC server 201xRx (i.e. 2015R2)

### Beginning with ciclgpack

The CIC iso file should be available in a shared folder, available on the guest in the C:\daas-cache folder.

## Usage

```puppet
class { 'ciclgpack':
  ensure      => installed,
  locale      => 'fr-FR',
  cic_version => '2015_R2',
}
```

## Supported Languages
Check the Localization(https://my.inin.com/products/cic/Pages/Localization.aspx) page for supported languages for your CIC version

## Limitations

* Windows 2012R2
* CIC 2015R2 or later