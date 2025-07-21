#include "fir.h"

#define N 11

void fir(
    uint32_t x,
    uint32_t* y,
    int32_t* c_q,       // tb.v에서 주소 맞춤용 dummy parameter 유지
    uint32_t c_address
) {
#pragma HLS INTERFACE s_axilite port=x bundle=CTRL
#pragma HLS INTERFACE s_axilite port=y bundle=CTRL
#pragma HLS INTERFACE s_axilite port=c_q bundle=CTRL
#pragma HLS INTERFACE s_axilite port=c_address bundle=CTRL
#pragma HLS INTERFACE s_axilite port=return bundle=CTRL

    static int32_t shift_reg[N] = {0};
#pragma HLS ARRAY_PARTITION variable=shift_reg complete dim=1

    // FIR 계수: 고정값 내부 선언
    const int32_t coeff[N] = {0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0};
#pragma HLS ARRAY_PARTITION variable=coeff complete dim=1

    // Shift register 업데이트
#pragma HLS PIPELINE II=1
    for (int i = N - 1; i > 0; i--) {
        shift_reg[i] = shift_reg[i - 1];
    }
    shift_reg[0] = x;

    // FIR 누산
    int64_t acc = 0;
#pragma HLS PIPELINE II=1
    for (int i = 0; i < N; i++) {
#pragma HLS UNROLL
        acc += (int64_t)shift_reg[i] * (int64_t)coeff[i];
    }

    *y = acc;
}
