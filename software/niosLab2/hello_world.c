#include <stdio.h>
#include "system.h"
#include <alt_types.h>
#include <io.h> /* Leiutura e escrita no Avalon */



int main(void){
  unsigned int led = 0;

  printf("Embarcados++ \n");

  while(1){
      if (led <= 5){
          IOWR_32DIRECT(PIO_LEDS_BASE, 0, 0x01 <<led++);
          usleep(50000);
      }
      else{
          led = 0;
      }
  };

  return 0;
}
