#include <stdio.h>

int main(void)
{
    for (int i = 0; i < 256; ++i) {
		for (int j = 0; j < 256; ++j) {
			for (int k = 0; k < 256; k += 1) {
				printf("\E[0mr:%d, g:%d, b:%d ", i, j, k);
				printf("\E[38;2;%d;%d;%dmHello World", i, j, k);
				printf("\n");
			}
		}
    }
    return 0;
}
