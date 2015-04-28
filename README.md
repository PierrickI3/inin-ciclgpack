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
  locale      => 'fr',
  cic_version => '2015_R2',
}
```

## Supported Languages
Check the Localization(https://my.inin.com/products/cic/Pages/Localization.aspx) page for supported languages for your CIC version

At the time of writing this module, the following locale are supported:
* ar: Arabic
* da: Danish
* de: German
* en-AU: English (Australia)
* en-GB: English (United Kingdom)
* en-NZ: English (New Zealand)
* es: Spanish (Latin America)
* es-es: Spanish (Spain)
* fr: French
* fr-ca: French (Canada)
* he: Hebrew
* it: Italian
* ja: Japanese
* ko: Korean
* nl: Dutch
* no: Norwegian
* pl: Polish
* pt-BR: Portuguese (Brazil)
* ru: Russian
* sr: Serbian (Latin)
* sv: Swedish
* tr: Turkish
* zh_Hans: Chinese (Simplified)
* zh_Hant: Chinese (Taiwan)

## Limitations

* Windows 2012R2
* CIC 2015R2 or later