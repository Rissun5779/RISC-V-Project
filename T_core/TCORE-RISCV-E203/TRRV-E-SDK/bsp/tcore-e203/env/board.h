// See LICENSE for license details.

#ifndef _TCORE_E203_H
#define _TCORE_E203_H

#include <stdint.h>

/****************************************************************************
 * GPIO Connections
 *****************************************************************************/

// GPIO bit offsets

#define LED_0_GPIO_OFFSET    0
#define LED_1_GPIO_OFFSET    1
#define LED_2_GPIO_OFFSET    2
#define LED_3_GPIO_OFFSET    3


#define SW_0_GPIO_OFFSET     4
#define SW_1_GPIO_OFFSET     5
#define SW_2_GPIO_OFFSET     6
#define SW_3_GPIO_OFFSET     7

#define KEY_0_GPIO_OFFSET    8
#define KEY_1_GPIO_OFFSET    9


#define RTC_FREQ 32768

void write_hex(int fd, unsigned long int hex);

#endif /* _TCORE_E203_H */
