OUT := build

MPYCROSS := micropython/mpy-cross/mpy-cross
MPYC_FLAGS := -v -v -mcache-lookup-bc
UPYLIB_SRCDIR = micropython-lib

CFLAGS += -shared -fPIC

empty :=
space := $(empty) $(empty)

upy_srcdirs = $(shell find ${UPYLIB_SRCDIR}/* -maxdepth 0 -type d)
PYS := $(foreach d,${upy_srcdirs},$(shell cd ${d} && find . -type f \( -iname "*.py" ! -iname "setup.py" \)))
CSRCS := $(foreach d,${upy_srcdirs},$(shell cd ${d} && find . -type f \( -iname "*.c" \)))

MPYS := $(PYS:./%.py=${OUT}/%.mpy)
DLIBS := $(CSRCS:./%.c=${OUT}/%.so)

vpath %.py $(subst $() $(),:,$(upy_srcdirs))
vpath %.c $(subst $() $(),:,$(upy_srcdirs))

${OUT}/%.mpy: %.py
	@mkdir -p $(dir $@)
	${MPYCROSS} ${MPYC_FLAGS} -o $@ $<

${OUT}/%.so: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $< -o $@

all: ${MPYS} ${DLIBS}

