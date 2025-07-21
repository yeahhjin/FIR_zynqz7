// fir_j.h
#ifndef FIR_J_H_
#define FIR_J_H_

#include <stdint.h>

#define N 11

void fir(
    uint32_t x,
    uint32_t* y,
    int32_t* c_q,
    uint32_t c_address
    );

#endif
