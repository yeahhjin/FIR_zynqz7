#include <stdio.h>
#include "fir.h"

int main() {
    uint32_t x = 2;
    uint32_t y;
    int32_t dummy_cq = 0;    // �������̽� ������ dummy ��
    uint32_t c_address = 0;  // ���� ��� ��� �� �ǹ� ����

    printf("�Է°� x = 2 ����, FIR ���� ����� fir.c ���� ����\n");

    for (int t = 0; t < 12; t++) {
        fir(x, &y, &dummy_cq, c_address);
        printf("t=%d, input=%d, output=%d\n", t, x, y);
    }

    return 0;
}
