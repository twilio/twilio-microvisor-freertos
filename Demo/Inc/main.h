#ifndef MAIN_H
#define MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes */
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
// FreeRTOS
#include <FreeRTOS.h>
#include <task.h>
#include <queue.h>
// App
#include "mv_syscalls.h"
#include "stm32u5xx_hal.h"
#include "logging.h"


/* Exported functions prototypes */
void            Error_Handler(void);
void            SystemClock_Config(void);
static void     MX_GPIO_Init(void);
void            StartGPIOTask(void *unused_arg);
void            StartDebugTask(void *unused_arg);



#ifdef __cplusplus
}
#endif

#endif /* MAIN_H */