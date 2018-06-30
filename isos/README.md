Copy iso images to load **via memdisk** here.

These images will be copied to the stick and will be loaded via *memdisk*. This will boot the iso images, but not all will work. If the system needs to access the image after the first start - i.e. after loading kernel and initial ramdisk - they will fail. This is because they cannot access the loaded image after start. This is a known problem with memdisk, afaik it's not a bug.

I'd recommend to try this method first. If it does not work, try to use extracted iso images.