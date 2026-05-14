
#include <stdio.h>
#include "util.h"
#define MAX 100
#define MENSAJE "hola"

int global;

func suma(a,b) {
    int resultado;
    resultado = a;
    return resultado;
}

func main() {
    int x;
    int y;

    x = y;
    suma(x,y);

    {
        int z;
        z = x;
    }

    return x;
}


