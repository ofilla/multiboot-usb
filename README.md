# multiboot-usb
Create a multiboot USB stick.

# to do

* implement *40_unpack_images.sh*

# usage

* Copy iso images to boot into the subdirectories **iso** or **extracted iso** according to load mode (check according README files). I'd recommend to try the method used in **iso** first.
* Set configurations in **config**.
* Start tool from command line: *sudo start.sh*.

## tested with

### working as **iso**

* **clonezilla-live-2.5.2-31-amd64**: CloneZilla Live
* **dban.iso**: Darik's Boot and Nuke
* **hirens-boot-cd.iso**: Hiren's Boot CD, version 15.2
* **kali-linux-mini.iso**: Kali Linux Netinstall
* **plpbt.iso**: Plop Boot Manager
* **rescatux.iso**: RescATux
* **riplinux.iso**: RIPLinuX 11.7

### working as **extracted iso**
not working yet

* ~~**lubuntu-16.04.3-desktop-amd64.iso**: Lubuntu install disc~~


### not working

* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>
