LOCAL_PATH := $(call my-dir)
DEBUG = 0
FRONTEND_SUPPORTS_RGB565 = 1
FAST = 1

include $(CLEAR_VARS)

ifeq ($(TARGET_ARCH),arm)
LOCAL_CXXFLAGS += -DANDROID_ARM
LOCAL_CFLAGS +=-DANDROID_ARM
LOCAL_ARM_MODE := arm
endif

ifeq ($(TARGET_ARCH),x86)
LOCAL_CXXFLAGS +=  -DANDROID_X86
LOCAL_CFLAGS += -DANDROID_X86
IS_X86 = 1
endif

ifeq ($(TARGET_ARCH),mips)
LOCAL_CXXFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
LOCAL_CFLAGS += -DANDROID_MIPS -D__mips__ -D__MIPSEL__
endif

MEDNAFEN_DIR := ../mednafen
MEDNAFEN_LIBRETRO_DIR := ..

LOCAL_MODULE    := libretro

# If you have a system with 1GB RAM or more - cache the whole 
# CD for CD-based systems in order to prevent file access delays/hiccups
CACHE_CD = 0

ifeq ($(core), lynx)
   core = lynx
   NEED_BPP = 32
   NEED_BLIP = 1
   NEED_STEREO_SOUND = 1
   CORE_DEFINE := -DWANT_LYNX_EMU
   CORE_DIR := $(MEDNAFEN_DIR)/lynx
   NEED_CRC32 = 1

CORE_SOURCES := $(CORE_DIR)/cart.cpp \
	$(CORE_DIR)/c65c02.cpp \
	$(CORE_DIR)/memmap.cpp \
	$(CORE_DIR)/mikie.cpp \
	$(CORE_DIR)/ram.cpp \
	$(CORE_DIR)/rom.cpp \
	$(CORE_DIR)/susie.cpp \
	$(CORE_DIR)/system.cpp
TARGET_NAME := mednafen_lynx_libretro
else ifeq ($(core), gba)
   core = gba
   NEED_BPP = 32
   NEED_BLIP = 1
	NEED_STEREO_SOUND = 1
   NEED_CRC32 = 1
   CORE_DEFINE := -DWANT_GBA_EMU
   CORE_DIR := $(MEDNAFEN_DIR)/gba-09333

CORE_SOURCES := $(CORE_DIR)/arm.cpp \
	$(CORE_DIR)/bios.cpp \
	$(CORE_DIR)/eeprom.cpp \
	$(CORE_DIR)/flash.cpp \
	$(CORE_DIR)/GBA.cpp \
	$(CORE_DIR)/GBAinline.cpp \
	$(CORE_DIR)/Gfx.cpp \
	$(CORE_DIR)/Globals.cpp \
	$(CORE_DIR)/Mode0.cpp \
	$(CORE_DIR)/Mode1.cpp \
	$(CORE_DIR)/Mode2.cpp \
	$(CORE_DIR)/Mode3.cpp \
	$(CORE_DIR)/Mode4.cpp \
	$(CORE_DIR)/Mode5.cpp \
	$(CORE_DIR)/RTC.cpp \
	$(CORE_DIR)/Sound.cpp \
	$(CORE_DIR)/sram.cpp \
	$(CORE_DIR)/thumb.cpp

HW_SOUND_SOURCES := $(MEDNAFEN_DIR)/hw_sound/gb_apu/Gb_Apu.cpp \
						$(MEDNAFEN_DIR)/hw_sound/gb_apu/Gb_Apu_State.cpp \
						$(MEDNAFEN_DIR)/hw_sound/gb_apu/Gb_Oscs.cpp
EXTRA_CORE_INCDIR = $(MEDNAFEN_DIR)/hw_sound/ $(MEDNAFEN_DIR)/include/blip
TARGET_NAME := mednafen_$(core)_libretro
else ifeq ($(core), snes)
   core = snes
   NEED_BPP = 32
   NEED_BLIP = 1
	NEED_STEREO_SOUND = 1
   CORE_DEFINE := -DWANT_SNES_EMU
   CORE_DIR := $(MEDNAFEN_DIR)/snes

CORE_SOURCES := $(CORE_DIR)/interface.cpp \
	$(CORE_DIR)/src/cartridge/cartridge.cpp \
	$(CORE_DIR)/src/cartridge/header.cpp \
	$(CORE_DIR)/src/cartridge/gameboyheader.cpp \
	$(CORE_DIR)/src/cartridge/serialization.cpp \
	$(CORE_DIR)/src/cheat/cheat.cpp \
	$(CORE_DIR)/src/chip/21fx/21fx.cpp \
	$(CORE_DIR)/src/chip/bsx/bsx.cpp \
	$(CORE_DIR)/src/chip/bsx/bsx_base.cpp \
	$(CORE_DIR)/src/chip/bsx/bsx_cart.cpp \
	$(CORE_DIR)/src/chip/bsx/bsx_flash.cpp \
	$(CORE_DIR)/src/chip/cx4/cx4.cpp \
	$(CORE_DIR)/src/chip/cx4/data.cpp \
	$(CORE_DIR)/src/chip/cx4/functions.cpp \
	$(CORE_DIR)/src/chip/cx4/oam.cpp \
	$(CORE_DIR)/src/chip/cx4/opcodes.cpp \
	$(CORE_DIR)/src/chip/cx4/serialization.cpp \
	$(CORE_DIR)/src/chip/dsp1/dsp1.cpp \
	$(CORE_DIR)/src/chip/dsp2/dsp2.cpp \
	$(CORE_DIR)/src/chip/dsp3/dsp3.cpp \
	$(CORE_DIR)/src/chip/dsp4/dsp4.cpp \
	$(CORE_DIR)/src/chip/obc1/obc1.cpp \
	$(CORE_DIR)/src/chip/sa1/sa1.cpp \
	$(CORE_DIR)/src/chip/sdd1/sdd1.cpp \
	$(CORE_DIR)/src/chip/spc7110/spc7110.cpp \
	$(CORE_DIR)/src/chip/srtc/srtc.cpp \
	$(CORE_DIR)/src/chip/st010/st010.cpp \
	$(CORE_DIR)/src/chip/st011/st011.cpp \
	$(CORE_DIR)/src/chip/st018/st018.cpp \
	$(CORE_DIR)/src/chip/superfx/superfx.cpp \
	$(CORE_DIR)/src/chip/supergameboy/supergameboy.cpp \
	$(CORE_DIR)/src/cpu/cpu.cpp \
	$(CORE_DIR)/src/cpu/core/core.cpp \
	$(CORE_DIR)/src/cpu/scpu/scpu.cpp \
	$(CORE_DIR)/src/dsp/sdsp/sdsp.cpp \
	$(CORE_DIR)/src/memory/memory.cpp \
	$(CORE_DIR)/src/memory/smemory/smemory.cpp \
	$(CORE_DIR)/src/ppu/ppu.cpp \
	$(CORE_DIR)/src/ppu/bppu/bppu.cpp \
	$(CORE_DIR)/src/smp/smp.cpp \
	$(CORE_DIR)/src/smp/core/core.cpp \
	$(CORE_DIR)/src/smp/ssmp/ssmp.cpp \
	$(CORE_DIR)/src/system/system.cpp

LIBRETRO_SOURCES_C := $(CORE_DIR)/src/lib/libco/libco.c

HW_SOUND_SOURCES := $(MEDNAFEN_DIR)/sound/Fir_Resampler.cpp
EXTRA_CORE_INCDIR = $(MEDNAFEN_DIR)/hw_sound/ $(MEDNAFEN_DIR)/include/blip $(MEDNAFEN_DIR)/snes/src/lib
TARGET_NAME := mednafen_snes_libretro
LDFLAGS += -ldl
endif

ifeq ($(NEED_STEREO_SOUND), 1)
SOUND_DEFINE := -DWANT_STEREO_SOUND
endif

CORE_INCDIR := $(CORE_DIR)

ifeq ($(NEED_THREADING), 1)
FLAGS += -DWANT_THREADING
THREAD_SOURCES += $(MEDNAFEN_LIBRETRO_DIR)/threads.c
endif

ifeq ($(NEED_CRC32), 1)
FLAGS += -DWANT_CRC32
CORE_SOURCES += $(MEDNAFEN_LIBRETRO_DIR)/scrc32.cpp
endif

ifeq ($(NEED_DEINTERLACER), 1)
FLAGS += -DNEED_DEINTERLACER
endif

ifeq ($(NEED_SCSI_CD), 1)
SCSI_CD_SOURCES := $(MEDNAFEN_DIR)/cdrom/scsicd.cpp
endif

ifeq ($(NEED_CD), 1)
CDROM_SOURCES := $(MEDNAFEN_DIR)/cdrom/CDAccess.cpp $(MEDNAFEN_DIR)/cdrom/CDAccess_Image.cpp $(MEDNAFEN_DIR)/cdrom/CDAccess_CCD.cpp $(MEDNAFEN_DIR)/cdrom/CDUtility.cpp $(MEDNAFEN_DIR)/cdrom/lec.cpp $(MEDNAFEN_DIR)/cdrom/SimpleFIFO.cpp $(MEDNAFEN_DIR)/cdrom/audioreader.cpp $(MEDNAFEN_DIR)/cdrom/galois.cpp $(MEDNAFEN_DIR)/cdrom/recover-raw.cpp $(MEDNAFEN_DIR)/cdrom/l-ec.cpp $(MEDNAFEN_DIR)/cdrom/cdromif.cpp $(MEDNAFEN_DIR)/cdrom/crc32.cpp
FLAGS += -DNEED_CD
endif

ifeq ($(NEED_TREMOR), 1)
TREMOR_SRC := $(wildcard $(MEDNAFEN_DIR)/tremor/*.c)
FLAGS += -DNEED_TREMOR
endif


MEDNAFEN_SOURCES := $(MEDNAFEN_DIR)/mednafen.cpp \
	$(MEDNAFEN_DIR)/error.cpp \
	$(MEDNAFEN_DIR)/math_ops.cpp \
	$(MEDNAFEN_DIR)/settings.cpp \
	$(MEDNAFEN_DIR)/general.cpp \
	$(MEDNAFEN_DIR)/FileWrapper.cpp \
	$(MEDNAFEN_DIR)/FileStream.cpp \
	$(MEDNAFEN_DIR)/MemoryStream.cpp \
	$(MEDNAFEN_DIR)/Stream.cpp \
	$(MEDNAFEN_DIR)/state.cpp \
	$(MEDNAFEN_DIR)/mempatcher.cpp \
	$(MEDNAFEN_DIR)/video/Deinterlacer.cpp \
	$(MEDNAFEN_DIR)/video/surface.cpp \
	$(MEDNAFEN_DIR)/sound/Blip_Buffer.cpp \
	$(MEDNAFEN_DIR)/sound/Stereo_Buffer.cpp \
	$(MEDNAFEN_DIR)/file.cpp \
	$(MEDNAFEN_DIR)/endian.cpp \
	$(MEDNAFEN_DIR)/cputest/cputest.c \
	$(OKIADPCM_SOURCES) \
	$(MEDNAFEN_DIR)/md5.cpp


LIBRETRO_SOURCES := $(MEDNAFEN_LIBRETRO_DIR)/libretro.cpp $(THREAD_STUBS)

SOURCES_C := 	$(TREMOR_SRC) $(LIBRETRO_SOURCES_C) $(MEDNAFEN_DIR)/trio/trio.c $(MEDNAFEN_DIR)/trio/triostr.c $(THREAD_SOURCES)

LOCAL_SRC_FILES += $(LIBRETRO_SOURCES) $(CORE_SOURCES) $(MEDNAFEN_SOURCES) $(CDROM_SOURCES) $(SCSI_CD_SOURCES) $(HW_CPU_SOURCES) $(HW_MISC_SOURCES) $(HW_SOUND_SOURCES) $(HW_VIDEO_SOURCES) $(SOURCES_C) $(CORE_CD_SOURCES)

WARNINGS := -Wall \
	-Wno-sign-compare \
	-Wno-unused-variable \
	-Wno-unused-function \
	-Wno-uninitialized \
	$(NEW_GCC_WARNING_FLAGS) \
	-Wno-strict-aliasing

EXTRA_GCC_FLAGS := -funroll-loops

ifeq ($(NO_GCC),1)
	EXTRA_GCC_FLAGS :=
	WARNINGS :=
endif

ifeq ($(DEBUG),0)
   FLAGS += -O3 $(EXTRA_GCC_FLAGS)
else
   FLAGS += -O0 -g
endif

ifneq ($(OLD_GCC),1)
NEW_GCC_WARNING_FLAGS += -Wno-narrowing \
	-Wno-unused-but-set-variable \
	-Wno-unused-result \
	-Wno-overflow
NEW_GCC_FLAGS += -fno-strict-overflow
endif

LDFLAGS += $(fpic) $(SHARED)
FLAGS += $(fpic) $(NEW_GCC_FLAGS)
LOCAL_C_INCLUDES += .. ../mednafen ../mednafen/include ../mednafen/intl ../mednafen/hw_cpu ../mednafen/hw_sound ../mednafen/hw_misc ../mednafen/hw_video $(CORE_INCDIR) $(EXTRA_CORE_INCDIR)

FLAGS += $(ENDIANNESS_DEFINES) -DSIZEOF_DOUBLE=8 $(WARNINGS) -DMEDNAFEN_VERSION=\"0.9.26\" -DPACKAGE=\"mednafen\" -DMEDNAFEN_VERSION_NUMERIC=926 -DPSS_STYLE=1 -DMPC_FIXED_POINT $(CORE_DEFINE) -DSTDC_HEADERS -D__STDC_LIMIT_MACROS -D__LIBRETRO__ -DNDEBUG -D_LOW_ACCURACY_ $(SOUND_DEFINE) -DLSB_FIRST

ifeq ($(IS_X86), 1)
FLAGS += -DARCH_X86
endif

ifeq ($(CACHE_CD), 1)
FLAGS += -D__LIBRETRO_CACHE_CD__
endif

ifeq ($(NEED_BPP), 16)
FLAGS += -DWANT_16BPP
endif

ifeq ($(WANT_NEW_API), 1)
FLAGS += -DWANT_NEW_API
endif

ifeq ($(FRONTEND_SUPPORTS_RGB565), 1)
FLAGS += -DFRONTEND_SUPPORTS_RGB565
endif

ifeq ($(NEED_BPP), 32)
FLAGS += -DWANT_32BPP
endif

LOCAL_CFLAGS =  $(FLAGS) 
LOCAL_CXXFLAGS = $(FLAGS) -fexceptions

include $(BUILD_SHARED_LIBRARY)
