#include "CH58x_common.h"
#include "CH58x_gpio.h"

int main() {
  GPIOA_ModeCfg(GPIO_Pin_5, GPIO_ModeOut_PP_5mA);
  GPIOA_SetBits(GPIO_Pin_5);

  while (TRUE) {
    GPIOA_InverseBits(GPIO_Pin_5);
    DelayMs(100);
  }

  return 0;
}