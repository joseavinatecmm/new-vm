# MiniC Compiler Didáctico

## Descripción General

MiniC Compiler es un compilador construido con:

- Flex
- Bison
- GCC

El proyecto implementa:

1. Análisis léxico
2. Análisis sintáctico
3. Análisis semántico
4. Tabla de símbolos
5. Reporte detallado de errores
6. Generación de código ensamblador
7. Generación de ejecutable

El compilador analiza un subconjunto del lenguaje C.

---

# Arquitectura General

```text
archivo.c
   ↓
scanner.l
   ↓
parser.y
   ↓
symbol_table.c
   ↓
error_manager.c
   ↓
code_generator.c
   ↓
gcc
   ↓
programa ejecutable
```

---

# Componentes del Proyecto

| Archivo | Función |
|---|---|
| scanner.l | Analizador léxico |
| parser.y | Analizador sintáctico |
| symbol_table.c | Tabla de símbolos |
| error_manager.c | Manejo de errores |
| code_generator.c | Generación de ensamblador y ejecutable |

---

# Análisis Léxico

El analizador léxico reconoce:

## Palabras reservadas

```c
int
if
return
printf
```

## Directivas

```c
#include
#define
```

## Operadores

```c
+
-
*
/
=
```

## Delimitadores

```c
(
)
{
}
;
,
```

## Literales

```c
123
"Hola mundo"
```

## Identificadores

```c
x
contador
resultado
```

---

# Análisis Sintáctico

El parser reconoce:

- Variables globales
- Variables locales
- Funciones
- Parámetros
- Llamadas a funciones
- Expresiones aritméticas
- printf
- if
- bloques anidados
- return

---

# Análisis Semántico

El compilador verifica:

## Variables no declaradas

```c
x = y;
```

si `x` o `y` no existen.

---

## Redeclaraciones

```c
int x;
int x;
```

---

## Funciones no declaradas

```c
sumar(a, b);
```

---

## Errores de aridad

```c
suma(a);
```

cuando la función esperaba más parámetros.

---

## Variables no usadas

```c
int temporal;
```

---

## Macros duplicadas

```c
#define MAX 100
#define MAX 200
```

---

# Manejo de Ámbitos

El compilador soporta:

```c
{
    int x;

    {
        int y;
    }
}
```

Cada bloque genera un nuevo ámbito.

---

# Tabla de Símbolos

La tabla almacena:

| Campo | Descripción |
|---|---|
| nombre | Identificador |
| clase | variable, función o macro |
| ámbito | Nivel de bloque |
| aridad | Número de parámetros |
| activo | Vigencia del símbolo |
| usado | Indica si se utilizó |

---

# Errores Sintácticos

El compilador detecta:

## Falta de ;

```c
int x
```

## Bloques incompletos

```c
if (x) {
```

## Return incorrecto

```c
return x
```

---

# Errores Semánticos

Ejemplo:

```text
[SEMÁNTICO]
  Línea    : 22
  Categoría: Variable no declarada
  Detalle  : variable 'x' no declarada en el ámbito 2
```

---

# Generación de Código

Si el programa no contiene errores:

1. GCC genera ensamblador
2. Se imprime el ensamblador
3. Se genera archivo objeto
4. Se genera ejecutable
5. Se ejecuta el programa

---

# Compilación

## Generar parser

```bash
bison -d parser.y
```

## Generar lexer

```bash
flex scanner.l
```

## Compilar proyecto

```bash
gcc parser.tab.c lex.yy.c symbol_table.c error_manager.c code_generator.c -o analizador
```

---

# Ejecución

## Programa correcto

```bash
./analizador test_correcto.c
```

## Programa incorrecto

```bash
./analizador test_errores.c
```

---

# Código de Prueba Correcto

```c
#include <stdio.h>

#define MAX 100

int global;
int contador;

int suma(int a, int b) {

    int resultado;

    printf("Entrando a suma\n");

    resultado = a + b;

    printf("Resultado suma: %d\n", resultado);

    return resultado;
}

int multiplicar(int x, int y) {

    int producto;

    printf("Entrando a multiplicar\n");

    producto = x * y;

    printf("Producto: %d\n", producto);

    return producto;
}

int main() {

    int x;
    int y;
    int z;

    printf("Inicio del programa\n");

    x = 10;
    y = 20;

    z = x + y;

    printf("x = %d\n", x);
    printf("y = %d\n", y);
    printf("z = %d\n", z);

    suma(x, y);

    multiplicar(x, z);

    contador = z;

    global = contador;

    if (global) {

        int local;

        local = global;

        contador = local;

        printf("Dentro del if\n");
    }

    printf("Fin del programa\n");

    return contador;
}
```

---

# Código de Prueba Incorrecto

```c
#include <stdio.h>

#define MAX 100
#define MAX 200

int global
int global;

int suma(int a, int b) {

    int resultado;

    resultado = c + a;

    return resultado
}

int suma(int x) {

    return x;
}

int main() {

    int x;
    int y;

    x = w;

    printf("Valor x = %d\n", x);

    suma(x);

    noExiste(x);

    if (condicion) {

        int z;

        z = x;
    }

    z = x;

    return noDeclarada
}
```

---

# Salida Esperada del Programa Correcto

```text
Inicio del programa
Entrando a suma
Resultado suma: 30
Entrando a multiplicar
Producto: 600
Dentro del if
Fin del programa
```

---

# Salida Esperada del Programa Incorrecto

```text
[SINTÁCTICO]
Línea 6:
falta ';'

[SEMÁNTICO]
Variable 'c' no declarada

[SEMÁNTICO]
Función 'suma' redeclarada

[SEMÁNTICO]
Variable 'w' no declarada

[SEMÁNTICO]
Función 'noExiste' no declarada
```

---

# Objetivos Didácticos

Este proyecto permite estudiar:

- Flex
- Bison
- Gramáticas
- Parsers LR
- Compiladores
- Tablas de símbolos
- Manejo de ámbitos
- Errores sintácticos
- Errores semánticos
- Generación de código
- GCC
- Ensamblador

---

