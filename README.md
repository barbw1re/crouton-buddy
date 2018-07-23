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

*Step 1 - Download Installer Script*
Download the latest script from https://raw.githubusercontent.com/barbw1re/crouton-buddy/master/crouton-buddy.sh and save to your **Downloads** directory on your chromebook.

*Step 2 - Open a Terminal*
On your chromebook, press Ctrl-T to open a crosh terminal.

*Step 3 - Enter a bash shell*
Type `shell` to enter a bash shell:
```
crosh> shell
```

*Step 4 - Run the script*
In your bash shell, run the script:
```
chromos@localhost / $ sudo sh ~/Downloads/crouton-buddy.sh
```

*Step 5 - Profit*
Err - yeah, profit!

## Prerequisites

As this is a wrapper around crouton, your Chromebook will need to be switched to Developer mode. See the [Crouton Github Page](https://github.com/dnschneid/crouton) for details.

## Host Actions

Running outside a chroot will present you with the following:

![Host Menu](https://raw.githubusercontent.com/barbw1re/crouton-buddy/assets/host-menu.png)

## Guest Action

Running inside a chroot will present you with the following:

![Host Menu](https://raw.githubusercontent.com/barbw1re/crouton-buddy/assets/guest-menu.png)

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/barbw1re/crouton-buddy/tags).

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
