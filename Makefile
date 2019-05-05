OUT := build

MICROPYTHON = micropython
UPYLIB_SRCDIR = micropython-lib
EVDEV_SRCDIR = python-evdev
EV3DEV2_SRCDIR = ev3dev-lang-python

MPYCROSS := ${MICROPYTHON}/mpy-cross/mpy-cross
MPYC_FLAGS := -v -v -mcache-lookup-bc

CFLAGS += -shared -fPIC

upy_srcdirs = $(shell find ${UPYLIB_SRCDIR}/* -maxdepth 0 -type d)
PYS := $(foreach d,${upy_srcdirs},$(shell cd ${d} && find . -type f \( -iname "*.py" ! -iname "setup.py" \)))
CSRCS := $(foreach d,${upy_srcdirs},$(shell cd ${d} && find . -type f \( -iname "*.c" \)))

PYS += $(shell cd ${EVDEV_SRCDIR} && find ./evdev -type f \( -iname "*.py" ! -iname "setup.py" \))
CSRCS += $(shell cd ${EVDEV_SRCDIR} && find ./evdev -type f \( -iname "*.c" \))
PYS += $(shell cd ${EV3DEV2_SRCDIR} && find ./ev3dev2 -type f \( -iname "*.py" ! -iname "setup.py" \))
CSRCS += $(shell cd ${EV3DEV2_SRCDIR} && find ./ev3dev2 -type f \( -iname "*.c" \))

MPYS := $(PYS:./%.py=${OUT}/%.mpy)
DLIBS := $(CSRCS:./%.c=${OUT}/%.so)

vpath %.py $(subst $() $(),:,$(upy_srcdirs))
vpath %.c $(subst $() $(),:,$(upy_srcdirs))
vpath %.py $(EVDEV_SRCDIR)
vpath %.c $(EVDEV_SRCDIR)
vpath %.py $(EV3DEV2_SRCDIR)
vpath %.c $(EV3DEV2_SRCDIR)

${OUT}/%.mpy: %.py
	@mkdir -p $(dir $@)
	${MPYCROSS} ${MPYC_FLAGS} -o $@ $<

${OUT}/%.so: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $< -o $@

all: ${MPYS} ${DLIBS}
