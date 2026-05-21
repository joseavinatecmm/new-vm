#include <stdio.h>

#define MAX 100

int global;
int contador;

int suma(int a, int b) {
    int resultado;

    printf("Entrando a suma\n");

    resultado = a + b;

    printf("Resultado calculado en suma: %d\n", resultado);

    return resultado;
}

int multiplicar(int x, int y) {
    int producto;

    printf("Entrando a multiplicar\n");

    producto = x * y;

    printf("Producto calculado: %d\n", producto);

    return producto;
}

int main() {
    int x;
    int y;
    int z;

    printf("Iniciando programa MiniC\n");

    x = 10;
    y = 20;

    z = x + y;

    printf("Valor de x: %d\n", x);
    printf("Valor de y: %d\n", y);
    printf("Valor de z: %d\n", z);

    suma(x, y);
    multiplicar(x, z);

    contador = z;
    global = contador;

    if (global) {
        int local;

        local = global;
        contador = local;

        printf("Dentro del bloque if\n");
        printf("Valor de contador: %d\n", contador);
    }

    printf("Fin del programa\n");

    return contador;
}
