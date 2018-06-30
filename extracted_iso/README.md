Copy iso images to extract on the stick here.

These images will be mounted, their contents will copied on the stick. Then, the **isolinux.cfg**-files will be modified to be loaded by the stick. This may not work if the image is a **hybrid image**, i.e. if it has more than one partition. You can check this via *fdisk -l <image name>*. If partitions are shown, this method will probably fail.

I'd recommend to try this method if the memdisk method fails.