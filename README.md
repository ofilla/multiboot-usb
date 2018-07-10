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

I'd recommend to try this method first. If it does not work, try to use the *dd method*.

### dd method
These images will be copied to an own partition on the stick via *dd*. These partitions are bootable themselfes and will be chainloaded by syslinux.

I'd recommend to try the *iso method* first.

### extracting method

These images will be mounted, their contents will copied on the stick. Then, the **isolinux.cfg**-files will be modified to be loaded by the stick. This may not work if the image is a **hybrid image**, i.e. if it has more than one partition. You can check this via *fdisk -l <image name>*. If partitions are shown, this method will probably fail.

Currently, this method fails. I stopped development of this method since the *dd method* works.

**Alternative:** The images may be extracted to an own partition, like in the *dd method*. The main difference to the latter is that the partition size can be set manually - and the partition can be *writable*. Theirfore, changes can be made on the image, e.g. the *filesystem.squashfs* can be modified, e.g. by installing updates.

If this variation of the *extracting method* shall be used, syslinux must be installed on that partition, too. Maybe it is needed to rename the directory *isolinux* and / or to rename *isolinux.cfg* to *syslinux.cfg*. Then, the partition can be chainloaded from syslinux on partition 1.

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
* **kali-linux-2018.2-amd64.iso**: Kali Linux 2018.2
### not working

* **hacking-live-1.0.iso** LiveCD from the book [Hacking - The Art of Exploitation](https://nostarch.com/hackingCD.htm)

# see also

only some of many pages with information:

* <https://blog.sleeplessbeastie.eu/2015/12/07/how-to-create-bootable-usb-flash-drive/>
* <https://theartofmachinery.com/2016/04/21/partitioned_live_usb.html>
