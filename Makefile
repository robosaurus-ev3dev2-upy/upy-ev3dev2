OUT := build

MICROPYTHON_DIR = micropython
UPYLIB_SRCDIR = micropython-lib
EVDEV_SRCDIR = python-evdev
EV3DEV2_SRCDIR = ev3dev-lang-python

MPYCROSS := /usr/bin/mpy-cross
MPYC_FLAGS := -v -v -mcache-lookup-bc

CFLAGS = -I$(MICROPYTHON_DIR) -I$(MICROPYTHON_DIR)/py
CFLAGS += -I$(MICROPYTHON_DIR)/ports/unix -I$(MICROPYTHON_DIR)/ports/unix/build -DMICROPY_PY_THREAD=0
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

libs: ${MPYS} ${DLIBS}

upy:
	@make -C ${MICROPYTHON_DIR}/ports/unix

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

install_upy: upy
	-rm -rf /usr/bin/micropython
	-rm -rf /usr/bin/mpy-cross
	cp ${MICROPYTHON_DIR}/mpy-cross/mpy-cross /usr/bin/mpy-cross
	cp ${MICROPYTHON_DIR}/ports/unix/micropython /usr/bin/micropython

install_libs: libs
	-rm -rf /usr/lib/micropython
	mkdir /usr/lib/micropython
	cp -R build/* /usr/lib/micropython/
