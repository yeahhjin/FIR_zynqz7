#include <stdio.h>
#include "fir.h"

int main() {
    uint32_t x = 2;
    uint32_t y;
    int32_t dummy_cq = 0;    // 인터페이스 충족용 dummy 값
    uint32_t c_address = 0;  // 고정 계수 사용 시 의미 없음

    printf("입력값 x = 2 고정, FIR 필터 계수는 fir.c 내부 고정\n");

    for (int t = 0; t < 12; t++) {
        fir(x, &y, &dummy_cq, c_address);
        printf("t=%d, input=%d, output=%d\n", t, x, y);
    }

    return 0;
}
