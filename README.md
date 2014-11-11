# Puppet module: txtcmdr

This is a Puppet module for txtcmdr
It provides only package installation and file configuration.

Based on Example42 layouts by Alessandro Franceschi / Lab42

Official site: http://www.example42.com

Official git repository: http://github.com/example42/puppet-txtcmdr

Released under the terms of Apache 2 License.

This module requires the presence of Example42 Puppi module in your modulepath.


## USAGE - Basic management

* Install txtcmdr with default settings

        class { 'txtcmdr': }

* Install a specific version of txtcmdr package

        class { 'txtcmdr':
          version => '1.0.1',
        }

* Remove txtcmdr resources

        class { 'txtcmdr':
          absent => true
        }

* Enable auditing without without making changes on existing txtcmdr configuration *files*

        class { 'txtcmdr':
          audit_only => true
        }

* Module dry-run: Do not make any change on *all* the resources provided by the module

        class { 'txtcmdr':
          noops => true
        }


## USAGE - Overrides and Customizations
* Use custom sources for main config file 

        class { 'txtcmdr':
          source => [ "puppet:///modules/example42/txtcmdr/txtcmdr.conf-${hostname}" , "puppet:///modules/example42/txtcmdr/txtcmdr.conf" ], 
        }


* Use custom source directory for the whole configuration dir

        class { 'txtcmdr':
          source_dir       => 'puppet:///modules/example42/txtcmdr/conf/',
          source_dir_purge => false, # Set to true to purge any existing file not present in $source_dir
        }

* Use custom template for main config file. Note that template and source arguments are alternative. 

        class { 'txtcmdr':
          template => 'example42/txtcmdr/txtcmdr.conf.erb',
        }

* Automatically include a custom subclass

        class { 'txtcmdr':
          my_class => 'example42::my_txtcmdr',
        }



## TESTING
[![Build Status](https://travis-ci.org/example42/puppet-txtcmdr.png?branch=master)](https://travis-ci.org/example42/puppet-txtcmdr)
