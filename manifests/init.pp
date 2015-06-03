# == Class: ciclgpack
#
# Installs a CIC language pack
#
# === Parameters
#
# [locale]
#   Country and language of the language packs to install
#   e.g. "fr" for French (France) or "en-UK" for English (United Kingdom) or zh-Hant for Chinese (Taiwan)
#   Supported locales are here: https://my.inin.com/products/cic/Pages/Localization.aspx and in the readme.MD file
#
# [cic_version]
#   Current version of CIC (i.e. "2015_R2")
#
# === Examples
#
#  class { 'ciclgpack':
#    ensure      => installed,
#    locale      => 'fr',
#    cic_version => '2015_R2',
#  }
#
# === Authors
#
# Pierrick Lozach <pierrick.lozach@inin.com>
#
# === Copyright
#
# Copyright 2015 Interactive Intelligence, Inc.
#
include stdlib

class ciclgpack (
  $ensure,
  $locale,
  $cic_version,
)
{
  $daascache        = 'C:\\daas-cache'
  $ciciso           = "CIC_${cic_version}.iso"
  $languagepackmsi  = 'LanguagePack'

 $cache_dir = hiera('core::cache_dir', 'c:/users/vagrant/appdata/local/temp') # If I use c:/windows/temp then a circular dependency occurs when used with SQL
  if (!defined(File[$cache_dir]))
  {
    file {$cache_dir:
      ensure   => directory,
      provider => windows,
    }
  }
  
  if ($::operatingsystem != 'Windows')
  {
    err('This module works on Windows only!')
    fail('Unsupported OS')
  }

  case downcase($locale)
  {
    'en-au':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_en_AU_${cic_version}.msi"
    }
    'en-gb':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_en_GB_${cic_version}.msi"
    }
    'en-nz':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_en_NZ_${cic_version}.msi"
    }
    'es-es':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_es_ES_${cic_version}.msi"
    }
    'fr-ca':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_fr_CA_${cic_version}.msi"
    }
    'pt-br':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_pt_BR_${cic_version}.msi"
    }
    'zh-hans':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_zh_Hans_${cic_version}.msi"
      $windowslocale = 'zh-CN'
    }
    'zh-hant':
    {
      $currentlanguagepackmsi = "${languagepackmsi}_zh_Hant_${cic_version}.msi"
      $windowslocale = 'zh-TW'
    }
    default:
    {
      $currentlanguagepackmsi = "${languagepackmsi}_${locale}_${cic_version}.msi"
      case downcase($locale)
      {
        'ar':
        {
          $windowslocale = 'ar-AE'
        }
        'de':
        {
          $windowslocale = 'de-DE'
        }
        'fr':
        {
          $windowslocale = 'fr-FR'
        }
        'he':
        {
          $windowslocale = 'he-IL'
        }
        'it':
        {
          $windowslocale = 'it-IT'
        }
        'ja':
        {
          $windowslocale = 'ja-JP'
        }
        'ko':
        {
          $windowslocale = 'ko-KR'
        }
        'nl':
        {
          $windowslocale = 'nl-NL'
        }
        'no':
        {
          $windowslocale = 'nn-NO'
        }
        'pl':
        {
          $windowslocale = 'pl-PL'
        }
        'ru':
        {
          $windowslocale = 'ru-RU'
        }
        'sr':
        {
          $windowslocale = 'Lt-sr-SP'
        }
        'sv':
        {
          $windowslocale = 'sv-SE'
        }
        'tr':
        {
          $windowslocale = 'tr-TR'
        }
        default:
        {
          fail("Unknown locale ${locale}")
        }
      }
    }
  }

  if '_' in $locale {
    # Windows expects ll-cc (l: language, c: country)
    $windowslocale = regsubst($locale, '_', '-', 'G')
  }

  debug("Installing Language Pack for ${locale}. MSI: ${currentlanguagepackmsi}. Windows Locale: ${windowslocale}.")

  case $ensure
  {
    installed:
    {

      # Mount CIC ISO
      debug('Mounting CIC ISO')
      exec {'mount-cic-iso-lgpack':
        command => "cmd.exe /c imdisk -a -f \"${daascache}\\${ciciso}\" -m n:",
        path    => $::path,
        cwd     => $::system32,
        creates => 'n:/Installs/Install.exe', # parameter does not allow variables
        timeout => 30,
      }

      debug("Installing Language Pack for ${locale}")
      package {'language-pack-install':
        ensure          => installed,
        source          => "n:\\Installs\\LanguagePacks\\${currentlanguagepackmsi}",
        install_options => [{'STARTEDBYEXEORIUPDATE' => '1'}, {'REBOOT' => 'ReallySuppress'},],
        require         => Exec['mount-cic-iso-lgpack'],
      }

      # Notifier Registry Fix
      debug('Creating Powershell script to fix Notifier registry value if needed...')
      file {"${cache_dir}\\FixNotifierRegistryValue_lgpack.ps1":
        ensure  => 'file',
        owner   => 'Vagrant',
        group   => 'Administrators',
        content => "
          \$NotifierRegPath = \"HKLM:\\SOFTWARE\\Wow6432Node\\Interactive Intelligence\\EIC\\Notifier\"
          \$NotifierKey = \"NotifierServer\"

          \$CurrentNotifierValue = (Get-ItemProperty -Path \$NotifierRegPath -Name \$NotifierKey).NotifierServer
          if (\$CurrentNotifierValue -ne \$CurrentComputerName)
          {
              Write-Host \"Current Notifier registry value is not set properly. Fixing...\"
              Set-ItemProperty -Path \$NotifierRegPath -Name \$NotifierKey -Value \$env:COMPUTERNAME
          }
        ",
        before  => Exec['notifier-fix-lgpack'],
      }

      debug('Fixing Notifier registry value if needed...')
      exec {'notifier-fix-lgpack':
        command => "${cache_dir}\\FixNotifierRegistryValue_lgpack.ps1",
        provider => powershell,
        timeout  => 3600,
        require  => Package['language-pack-install'],
      }

      debug('Adding instructions on desktop')
      file {'C:/Users/Vagrant/Desktop/MediaServer Language Analysis Instructions.txt':
        ensure  => present,
        content => "To configure Media Server speech for your language, create or update the 'Call Analysis Language' server parameter to one of the values listed on page 67 of the following document: https://my.inin.com/products/cic/Documentation/mergedProjects/wh_tr/bin/media_server_tr.pdf
                    You can also download dial plans from https://my.inin.com/products/cic/Pages/Localization.aspx under the 'Localized Dial Plans' section at the bottom of the page",
        require => Package['language-pack-install'],
      }

      debug("Setting Windows Culture to ${windowslocale}")
      exec {'set-windows-culture':
        command  => "Set-Culture ${windowslocale}",
        provider => powershell,
        path     => $::path,
        cwd      => $::system32,
        timeout  => 30,
        require  => Package['language-pack-install'],
      }

      # Unmount CIC ISO
      debug('Unmounting CIC ISO')
      exec {'unmount-cic-iso-lgpack':
        command => 'cmd.exe /c imdisk -D -m n:',
        path    => $::path,
        cwd     => $::system32,
        timeout => 30,
        require => [
                    Exec['mount-cic-iso-lgpack'],
                    Exec['set-windows-culture'],
                  ],
      }
    }
    default:
    {
      debug("Unknown command ${ensure}")
    }
  }
}