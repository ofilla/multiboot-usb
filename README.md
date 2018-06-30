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
* ~~**lubuntu-16.04.3-desktop-amd64.iso**: Lubuntu install disc~~ not working

not working:
* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)
* **KNOPPIX_2013-06-16-DE.iso**: Knoppix

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>
