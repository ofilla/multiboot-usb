# multiboot-usb
Create a multiboot USB stick.

# to do

* implement *40_unpack_images.sh*

# usage

* copy iso images to boot into this directory
* *sudo start.sh <name of device>* from command line

## tested with

working:
* **clonezilla-live-2.5.2-31-amd64**: CloneZilla Live
* **dban.iso**: Darik's Boot and Nuke
* **hirens-boot-cd.iso**: Hiren's Boot CD, version 15.2
* **kali-linux-mini.iso**: Kali Linux Netinstall
* **plpbt.iso**: Plop Boot Manager
* **rescatux.iso**: RescATux
* **riplinux.iso**: RIPLinuX 11.7

not working:
* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)
* **KNOPPIX_2013-06-16-DE.iso**: Knoppix
* **lubuntu-16.04.3-desktop-amd64.iso**: Lubuntu install disc

The problems with Knoppix and Lubuntu are the same: They start, but when they search for the disk to access it (e.g. casper-files) they fail. This is a known problem with memdisk, afaik it's not a bug.

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>
