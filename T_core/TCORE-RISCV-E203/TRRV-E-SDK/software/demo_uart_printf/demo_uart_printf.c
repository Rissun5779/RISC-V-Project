#include <stdio.h>
#include <platform.h>

static const char terasic_msg[] =
    "\n\r"
    "    ######   ###    #####   #####         #     #\n\r"
    "    #     #   #    #     # #     #        #     #\n\r"
    "    #     #   #    #       #              #     #\n\r"
    "    ######    #     #####  #       #####  #     #\n\r"
    "    #   #     #          # #               #   #\n\r"
    "    #    #    #    #     # #     #          # #\n\r"
    "    #      # ###    #####   #####            #\n\r"
    "\n\r"
    "\n\r";

void delay(int s)
{
    int i = s * 1000;
    while (i--)
        ;
}

int main(void)
{
    while (1)
    {
        printf("%s", terasic_msg);
        delay(1000);
    }
}