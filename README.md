# multiboot-usb
Create a multiboot USB stick.

# to do

* implement *40_unpack_images.sh*

# usage

* Copy iso images to boot into the subdirectories to be used by the **memdisk method** or the **dd method**. I'd recommend to try **memdisk method** first. However, since this method should by working with any images it is the default mode.
* Set configurations in **config**.
* Start tool from command line: *sudo start.sh*.

### memdisk method
These images will be copied to the stick and will be loaded via *memdisk*. This will boot the iso images, but not all will work. If the system needs to access the image after the first start - i.e. after loading kernel and initial ramdisk - they will fail. This is because they cannot access the loaded image after start. This is a known problem with memdisk, afaik it's not a bug.

I'd recommend to try this method first. If it does not work, try to use extracted iso images.

### dd method
These images will be copied to an own partition on the stick via *dd*. These partitions are bootable themselfes and will be chainloaded by syslinux.

I'd recommend to try the *iso method* first.

## tested with

### working with **memdisk method**

* **clonezilla-live-2.5.2-31-amd64**: CloneZilla Live
* **dban.iso**: Darik's Boot and Nuke
* **hirens-boot-cd.iso**: Hiren's Boot CD, version 15.2
* **kali-linux-mini.iso**: Kali Linux Netinstall
* **plpbt.iso**: Plop Boot Manager
* **rescatux.iso**: RescATux
* **riplinux.iso**: RIPLinuX 11.7

### working with **dd method**

* **lubuntu-16.04.3-desktop-amd64.iso**: Lubuntu install disc

### not working

* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>
* <https://theartofmachinery.com/2016/04/21/partitioned_live_usb.html>
