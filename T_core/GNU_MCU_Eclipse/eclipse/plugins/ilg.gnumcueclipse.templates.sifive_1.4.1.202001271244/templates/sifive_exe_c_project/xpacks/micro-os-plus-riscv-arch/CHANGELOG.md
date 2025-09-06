## Change log

Changes in reverse chronological order.

### v1.0.2 (2018-04-16)

* bump deps & move back to npm
* update README developer info

### v1.0.1 (2018-01-24)

* update dependencies

### v1.0.0 (2018-01-24)

### 2018-01-20

* [#271] Reimplement RISC-V semihosting
* semihosting asm: remove "cc"

### 2018-01-15

* [#2] Use wfi() in infinite loops
* [#3] Add semihosting call_host() implementation

### v0.2.0 (2018-01-09)

### 2017-11-10

* README: reformat prerequisites
* arch-functions.cpp: fix typo
* README: explain xpm install
* README: refer to CHANGELOG in message
* README: update license with links
* do not ignore package-lock

### 2017-11-07 

* traps.cpp: add `handle_machine_ext()` declaration
* ignore package-lock for now
* rework interrupts to use namespaces

### 2017-10-30 
* arch-defines: fix `MCAUSE_CAUSE` for 32-bits
* traps.cpp: fix section `.traps_handlers`
* reset-entry.S: cosmetise comments

### 2017-10-29 
* include/\*: rename csr set/clear_\*_bits
* include/\*/arch-defines.h: simplify & prefix
* include/\*/arch-types.h: add exc & irq enums
* include/board-functions-inlines.h added
* src/traps.cpp: rename `riscv_interrupts_local_handlers`
* include/core-functions.h: move `riscv_trap_entry()` here
* include/\*: update guard macros

### 2017-10-28

* src/traps.cpp: move local handlers to device
* include/riscv-arch/arch-defines.h: number of exc
* update for device-peripherals.h

### v0.1.0 (2017-10-26)

* update for new GitHub names

### v0.0.4 (2017-10-04)

* package.json clean-ups
* add CHANGELOG.md

### v0.0.3 (2017-09-18)

* add enable/disable M external interrupts
* add plic-functions.h
* traps.cpp: use new plic api
* csr-functions*.h: add `mhartid()`
* `*_exception_`, `*_interrupt_local_`
    * for improved readability, use full names
    * use local_device array, if needed

### v0.0.2, v0.0.1 (2017-09-04)

* initial version, copied from µOS++.


