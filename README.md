# Crouton Buddy

A bunch of bash scripts to simplify the installation and management of crouton chroots.

## Features

Crouton Buddy will run in one of two modes depending on the environment that is executing it.

In **host** mode, when run outside a chroot, you are offered the ability to perform general Crouton tasks such as:

* Create, update, or delete chroot environment
* Backup or restore a chroot environment
* Start and enter a chroot environment (either via terminal or GUI)

In **guest** mode, when run inside a chroot, you are offered tasks to configure your environment and install additional software.

## Getting Started

#### Step 1 - Download Installer Script

Download the latest script from https://raw.githubusercontent.com/barbw1re/crouton-buddy/master/crouton-buddy.sh and save to your **Downloads** directory on your chromebook.

#### Step 2 - Open a Terminal

On your chromebook, press Ctrl-T to open a crosh terminal.

#### Step 3 - Enter a bash shell

Type `shell` to enter a bash shell:
```
crosh> shell
```

#### Step 4 - Run the script

In your bash shell, run the script:
```
chromos@localhost / $ sudo sh ~/Downloads/crouton-buddy.sh
```

#### Step 5 - Profit

Err - yeah, profit!

## Prerequisites

As this is a wrapper around crouton, your Chromebook will need to be switched to Developer mode. See the [Crouton Github Page](https://github.com/dnschneid/crouton) for details.

## Host Actions

Running outside a chroot will present you with the following:

![Host Menu](https://raw.githubusercontent.com/barbw1re/crouton-buddy/assets/host-menu.png)

#### Create a new environment

Create a new chroot environment..

#### Configure/manage environment

Enter the specified environment and run Crouton Buddy in **guest** mode to install and update packages.

#### Enter an environment (terminal)

Open up a terminal to the specified environment.

#### Start an environment (Gnome)

Start Gnome (disconnected) on the specified environment.

#### Start an environment (KDE)

Start KDE (disconnected) on the specified environment.

#### Update an existing environment

Update (via Crouton) the core of the specified environment.

#### Backup environment

Backup the specified environment.

#### Restore environment

Create a new chroot environment from a specified backup archive - either creating a new environment from scratch, or replacing an existing one.

#### Delete environment

Delete the specified environment.

#### Purge cached bootstrap

Delete the cached Crouton bootstrap to ensure subsequent installations use the latest version.

#### Update Crouton Buddy scripts

Update the Crouton Buddy installation to get any bug fixes or new application packages.

## Guest Action

Running inside a chroot will present you with the following:

![Host Menu](https://raw.githubusercontent.com/barbw1re/crouton-buddy/assets/guest-menu.png)

#### Install common dependencies and core system applications

Update the Ubuntu installation to ensure it has very commonly expected packages installed such as the base English language pack and support for installing software over HTTPS.

#### Update all installed packages

Update all currently installed Ubuntu software.

#### Gnome desktop setup

Install the latest Gnome desktop, extensions, and utilities.

#### Desktop (general) packages

Choose from and install a selection of common desktop applications (see package index below).

#### Common Developer packages

Choose from and install a selection of common software developer applications (see package index below).

## Packages available for installing

The following is a list of the applications currently packaged for installation into a chroot environment. They are broadly categorised to simplify selecting applications which are suitable for your current use-case.

#### Desktop Category

* Numix
* FileZilla

#### Developer Category

* Git
* Visual Studio Code

## Versioning

Versioning follows [SemVer](http://semver.org/) (or tries to, at least) For the versions available, see the [tags on this repository](https://github.com/barbw1re/crouton-buddy/tags).

## Authors

* **Kris Johnson** - *Initial work* - [barbw1re](https://github.com/barbw1re)
See also the list of [contributors](https://github.com/barbw1re/crouton-buddy/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

This was inspired by:

* [crouton-auto](https://github.com/andrewbrg/crouton-auto)
* And the purchase of an ASUS C302CA-DHM4 Chromebook Flip

But would be nothing without the amazing [Crouton](https://github.com/dnschneid/crouton)
