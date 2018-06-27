# multiboot-usb
Create a multiboot USB stick.

# to do

* implement *40_unpack_images.sh*

# usage

* copy iso images to boot into this directory
* *sudo start.sh <name of device>* from command line

## tested with

working:
* **kali-linux-mini.iso**: Kali Linux Netinstall
* **plpbt.iso**: Plop Boot Manager
* ~~**lubuntu-16.04.3-desktop-amd64.iso**: Lubuntu install disc~~ not working

not working:
* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)
* **kali-linux-2018.2-amd64.iso** Kali Linux 

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>