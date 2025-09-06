## SiFive Core Complex IP Arty boards specific files

This project provides support for the SiFive synthesised E31/E51 devices 
running on the Arty development board.

## Developer info

This section is intended to developers who plan to include this library in their own projects.

### Prerequisites

A recent [`xpm`](https://www.npmjs.com/package/xpm), which is a portable [Node.js](https://nodejs.org/) command line application.

Compiling the source code requires a modern C++ compiler, preferably GCC 5 or higher. 

### Easy install

This package is available as [`@sifive/arty-boards`](https://www.npmjs.com/package/@sifive/arty-boards) from the `npmjs.com` registry; with `xpm` available, installing the latest version of the package is quite easy:

```console
$ xpm install @sifive/arty-boards
```

This package is also available from [GitHub](https://github.com/micro-os-plus/sifive-arty-boards-xpack):

```console
$ git clone https://github.com/micro-os-plus/sifive-arty-boards-xpack.git sifive-arty-boards-xpack.git
```

### How to use

The standard way to include the board files is

```c
#include <micro-os-plus/board.h>
```

### Macros

* `SIFIVE_E31ARTY_BOARD`
* `SIFIVE_E51ARTY_BOARD`

### E31/E51 Core Complex FPGA Eval Kit Clock and Reset

The E31/E51 Core Complex FPGA Eval Kit has a 100MHz input to the FPGA. This is used to derive the Core Complex’s `io_coreClock` at 65 MHz, and the clock (peripheral clock) at 32.5 MHz. The `io_rtcToggle` is driven at approximately 32kHz.

The system reset driven by the Reset Button on the evaluation board is combined with the external debugger’s `SRST_n` pin as a full system reset for the E31/E51 Core Complex FPGA Eval KitT ̇his is combined with the `io_ndreset` to drive the reset input to the Core Complex.

The reset vector is set with Switch 0. Leave the switch in the “Off” position to execute from SPI Flash.

### Global interrupts

- UART TX/RX	1
- SWITCH 0 2
- SWITCH 1 3
- SWITCH 2 4
- SWITCH 3 5
- Quad SPI 6
- GPIO[0] LED 0 RED 	7
- GPIO[1] LED 0 GREEN	8
- GPIO[2] LED 0 BLUE	9
- GPIO[3] SWITCH 3	10
- GPIO[4] BUTTON 0	11
- GPIO[5] BUTTON 1	12
- GPIO[6] BUTTON 2	13
- GPIO[7] BUTTON 3	14
- GPIO[8] PMOD A[0]	15
- GPIO[9] PMOD A[1]	16
- GPIO[10] PMOD A[2]	17
- GPIO[11] PMOD A[3]	18
- GPIO[12] PMOD A[4]	19
- GPIO[13] PMOD A[5]	20
- GPIO[14] PMOD A[6]	21
- GPIO[15] PMOD A[7]	22
- PWM CMP[0] 23
- PWM CMP[1] LED 1 RED 24
- PWM CMP[2] LED 1 GREEN 25
- PWM CMP[3] LED 1 BLUE 26

## Maintainer info

### How to publish

* commit all changes
* update `CHANGELOG.md`; commit with a message like _CHANGELOG: prepare v0.1.2_
* `npm version patch`
* push all changes to GitHub
* `npm publish`

## License

The original content is released under the [MIT License](https://opensource.org/licenses/MIT), with all rights reserved to [Liviu Ionescu](https://github.com/ilg-ul).
