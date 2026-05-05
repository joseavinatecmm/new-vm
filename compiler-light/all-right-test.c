#include <stdio.h>
#include "util.h"

#define MAX 100
#define PI 3.1416
#define MENSAJE "hola"

int global;
float promedio;
int contador = 0;

int suma(int a, int b) {
    int resultado;
    resultado = a + b;
    return resultado;
}

int incrementar(int x) {
    x = x + 1;
    return x;
}

int main() {
    int x;
    int y;
    int total;

    x = 5;
    y = 10;
    total = x + y * 2;

    if (total > 10) {
        total = total + 1;
    } else {
        total = total - 1;
    }

    while (x < total) {
        x = x + 1;
    }

    incrementar(x);

    return total;
}

