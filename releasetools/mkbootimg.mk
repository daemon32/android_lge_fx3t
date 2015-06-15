LOCAL_PATH := $(call my-dir)

## Imported from the original makefile...
KERNEL_CONFIG := $(KERNEL_OUT)/.config

KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage

define loki-boot
$(LOCAL_PATH)/loki_tool patch boot $(LOCAL_PATH)/aboot.img $(OUT)/boot.img $(OUT)/boot.lok
endef

define loki-recovery
$(LOCAL_PATH)/loki_tool patch recovery $(LOCAL_PATH)/aboot.img $(OUT)/recovery.img $(OUT)/recovery.lok
endef

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	$(call pretty,"Target boot image: $@")
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}
	$(call loki-boot)
	@echo -e ${CL_CYN}"Made lokied boot image"${CL_RST}
	@echo -e ${CL_CYN}"Thank you djrbliss (Dan Rosenberg)"${CL_RST}

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG)  $(recovery_ramdisk) $(recovery_kernel)
	@echo -e ${CL_CYN}"----- Making recovery image ------"${CL_RST}
	$(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(call loki-recovery)
	@echo -e ${CL_CYN}"Made lokied recovery image"${CL_RST}
	@echo -e ${CL_CYN}"Thank you djrbliss (Dan Rosenberg)"${CL_RST}
