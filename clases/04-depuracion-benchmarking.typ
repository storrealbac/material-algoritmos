#import "../lib/polylux-compat.typ": *
#import "../lib/presentation-slides.typ": *
#import "../lib/sourcecode.typ": sourcecode

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Depuración y benchmarking ],
  subtitle: [ Como debuggear en problemas de programación\ sin morir en el intento],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[
  = Contenidos
  - Bugs comunes
  - GNU Debugger
  - Valgrind
  - Benchmarking
]

#slide[
  = Bugs comunes
  - Errores de desbordamiento
  - Fuera de rango
  - Errores de precisión de punto flotante
]

#slide[
  = Errores de desbordamiento

  Existen dos tipos de desbordamiento en numeros enteros, overflow y underflow.

  El _overflow_ ocurre cuando el valor resultante de una operación aritmética es mayor que el valor máximo que puede almacenar un tipo de dato.

  El _underflow_ ocurre cuando el valor resultante de una operación aritmética es menor que el valor mínimo que puede almacenar un tipo de dato.
]

#slide[

  = Errores de desbordamiento

  ¿Cuál sería el resultado de la siguiente operación en un entero de 32 bits?
  
  #sourcecode[
  ```cpp
    int a = 2147483647; // Máximo valor para un entero de 32 bits (INT_MAX)
    int b = a + 1;
  ```
  ]
  
]

#slide[
  = Ejemplos de errores de desbordamiento

  Supongamos que tenemos un arreglo $A$ y queremos obtener la suma de todos sus elementos.

  - $ 0 <= A_i <= 10^5 $
  - $ 1 <= abs(A) <= 10^6 $
]

#slide[
  = Ejemplos de errores de desbordamiento

  ¿Cuál es el error de este código?
  
  #sourcecode[
    ```cpp
    int suma(vector<int> &A) {
      int res = 0;
      for (int x : A)
        res += x;
      return res;
    }
    ```
  ]
  
]

#slide[
  = Ejemplos de errores de desbordamiento

  Supongamos que tenemos un arreglo $A$ y queremos obtener la multiplicación de todos sus elementos $(mod p)$

  - $ 0 <= A_i <= 10^5 $
  - $ 1 <= abs(A) <= 10^8 $
  - $ p = 10^9 + 7 $
  

]

#slide[
  = Ejemplos de errores de desbordamiento

  ¿Cuál es el error de este código?
  
  #sourcecode[
    ```cpp
    int mult(vector<int> &A) {
      int mod = (1e9 + 7);
      int res = 1;
      for (int x : A)
        res *= x;
      return res % mod;
    }
    ```
  ]
  
]

#slide[
  = Fuera de rango

  El término _fuera de rango_ o _out of bounds_ se refiere a una situación en la programación donde se intenta acceder a una posición de un array o estructura de datos que está fuera de los límites definidos por su tamaño.
]

#slide[
  = Ejemplos de fuera de rango

  Supongamos que deseamos calcular la suma de los prefijos de un arreglo $A$\

  $ S_n = sum_(i = 1)^(n) A_i $

]

#slide[
  = Ejemplos de fuera de rango

  ¿Cuál es el error de este código?
  
  #sourcecode[
    ```cpp
    vector<int> prefix_sum(vector<int> &A) {
      vector<int> res(A.size());
      for (int i = 0; i < A.size(); i++)
        res[i] = res[i-1] + A[i];
      return res;
    }
    ```
  ]
  
]

#slide[
  = Ejemplos de fuera de rango

  Supongamos que deseamos sumar la suma de todos los elementos de adyacentes de un arreglo $A$, es decir:

  $ S_i = A_i + A_(i+1) $
  
]

#slide[
  = Ejemplos de fuera de rango

  ¿Cuál es el error de este código?

  #sourcecode[
    ```cpp
    vector<int> adj_sum(vector<int> &A) {
      vector<int> res(A.size());
      for (int i = 0; i < A.size(); i++)
        res[i] = A[i] + A[i+1];
      return res;
    }
    ```
  ]
  
]

#slide[
  = Errores de precisión de punto flotante

  Los errores de precisión de punto flotante son problemas que surgen debido a la forma en que los números en punto flotante se representan y manipulan en la memoria de una computadora. Los números en punto flotante se representan con un número finito de bits, lo que significa que no todos los números pueden ser representados con precisión.
  
]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Supongamos que deseamos calcular la distancia entre dos puntos
  
  
  $ sqrt(Delta x^2 + Delta y^2) $

  Si $Delta x = Delta y = 10^200$, el resultado según el computador es `inf`

]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Puedo re-escribir la formula y acepta valores más grandes

  $ Delta x sqrt(1 + ((Delta y)/(Delta x))^2 ) $

]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Puedo re-escribir la formula y acepta valores más grandes

  $ Delta x sqrt(1 + ((Delta y)/(Delta x))^2 ) $

]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Aún así, si deseo comparar si una distancia es mayor que la otra, ¿es necesario usar esta formula?

]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  La relación de orden entre la distancia y distancia al cuadrado es lo mismo.

  Es decir que si deseamos comparar dos distancias, es mejor comparar la distancia al cuadrado, asi no tenemos perdida de precisión.


  #presentation-info-block(title: "Demostración")[
 La función $f(x) = x^2$ es *monótona creciente* en el intervalo $[0, oo)$. Esto significa que, para cualquier par de valores $x_1$ y $x_2$ tales que $x_1 <= x_2$, se cumple que $x_1^2 <= x_2^2$.
    
    Por lo tanto, si $d_1$ y $d_2$ son distancias no negativas, entonces $d_1 <= d_2$ implica que $(d_1)^2 <= (d_2)^2$, y viceversa.

    Para funciones de más dimensiones se hace un cambio de variable y es equivalente.
  ]

]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Supongamos que deseamos calcular lo siguiente:

  $ ceil(a/b) $

  - $a, b in ZZ$
  
]



#slide[
  = Ejemplo de errores de precisión de punto flotante

  Una implementación posible sería la siguiente:

  #sourcecode[
    ```cc
    int techo(int a, int b) {
      float x = ((float)a/((float)b);
      return ceil(x);
    }
    ```
  ]
  
]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  Una forma más inteligente podría ser la siguiente:

  #sourcecode[
    ```cc
    int techo(int a, int b) {
      if (a % b == 0) return a/b;
      return a/b + 1;
    }
    ```
  ]

  O más bien:

  #sourcecode[
    ```cc
    int techo(int a, int b) {
      return (a % b == 0) ? a/b : a/b + 1;
    }
    ```
  ]
]

#slide[
  = Ejemplo de errores de precisión de punto flotante

  La mejor que conozco:

  #sourcecode[
    ```cc
    int techo(int a, int b) {
      return (a + b - 1)/b;
    }
    ```
  ]
]

#slide[

  = GNU Debugger

  Es una herramienta de depuración que permite a los programadores ejecutar, detener y analizar el comportamiento de programas en C, C++, y otros lenguajes. Facilita la identificación y corrección de errores al inspeccionar variables, rastrear la ejecución, y observar la memoria en tiempo real.

]


#slide[
  = Valgrind

  Valgrind es una herramienta de análisis de programas que ayuda a detectar errores de memoria, fugas de memoria, y problemas de concurrencia en aplicaciones escritas en C, C++, y otros lenguajes. Es ampliamente utilizada para garantizar la correcta gestión de la memoria y mejorar la estabilidad del software.
  
]

#slide[
  = Benchmarking

  Benchmarking es el proceso de medir y comparar el rendimiento de diferentes algoritmos o implementaciones para determinar cuál es más eficiente en términos de tiempo de ejecución y/o uso de recursos.
  
]

#slide[
  = Benchmarking

  Benchmarking es el proceso de medir y comparar el rendimiento de diferentes algoritmos o implementaciones para determinar cuál es más eficiente en términos de tiempo de ejecución y/o uso de recursos.


]

#slide[
  = Benchmarking

  Esto se puede realizar de varias maneras:

  - *Tiempos de ejecución*: Medir el tiempo que tarda un algoritmo en completarse bajo diferentes condiciones.
  - *Comparación de algoritmos*: Ejecutar múltiples algoritmos para resolver el mismo problema y comparar sus tiempos de ejecución.
  - *Escalabilidad*: Evaluar cómo se comporta el rendimiento del algoritmo cuando se incrementa el tamaño de los datos de entrada.
  - *Pruebas de estrés*: Ejecutar el algoritmo bajo condiciones extremas para identificar cuellos de botella y puntos de fallo.
]

#slide[
  = Benchmarking

  - Asegúrate de ejecutar las pruebas en un entorno controlado para minimizar la variabilidad.
  
  - Repite las pruebas varias veces y utiliza promedios para obtener resultados más confiables.
  
  - Siempre documenta y reporta las condiciones bajo las cuales se realizó el benchmarking.
]

#slide[
  = Benchmarking

  - `time` en Linux: Comando de terminal para medir el tiempo total de ejecución de un programa.
  - `chrono` en C++: Librería estándar para medir tiempos de ejecución de manera precisa.
  - `time` en Python: Módulo que proporciona funciones para medir el tiempo y la duración de procesos en scripts Python.
]

#slide[
  = `time` en Linux

  El comando `time` en Linux se usa para medir el tiempo total de ejecución de un programa. Muestra los siguientes tiempos:

  - *Tiempo real*: Tiempo total desde el inicio hasta el fin de la ejecución.
  - *Tiempo de usuario*: Tiempo que el CPU pasa ejecutando el código del programa.
  - *Tiempo de sistema*: Tiempo que el CPU pasa ejecutando operaciones del sistema en nombre del programa.

  Ejemplo: `time ./mi_programa`
  #set text(size: 14pt)
  #sourcecode[
    ```
    real    0m0.064s
    user    0m0.000s
    sys     0m0.000s
    ```
  ]
]
#slide[
  = `chrono` en C++

  La librería `chrono` en C++ permite realizar mediciones de tiempo con alta precisión.

  - `high_resolution_clock`: Para mediciones precisas en nanosegundos.
  - `steady_clock`: Un reloj que no se ajusta ni cambia, útil para mediciones consistentes.
  - `duration_cast`: Para convertir las duraciones de tiempo en diferentes unidades (milisegundos, segundos, etc.).


  Ejemplo:
  #set text(size: 14pt)
  #sourcecode[
      ```cpp
  auto start = chrono::high_resolution_clock::now();
  // código a medir
  auto end = chrono::high_resolution_clock::now();
  ```
  ]
]

#slide[
  = `time` en Python

  El módulo `time` en Python proporciona funciones para medir y manipular el tiempo.

  - `time.time()`: Retorna el tiempo en segundos desde `(1970-01-01 00:00:00 UTC).`

    Ejemplo:
  #sourcecode[
  ```python
    import time
    start = time.time()
    # código a medir
    end = time.time()
    print("Duración:", end - start, "segundos")
  ```
  ]

]

#slide[
    = Recursos Adicionales
  - https://www.gnu.org/software/gdb/documentation/
  - https://valgrind.org/docs/manual/manual.html
  - https://en.cppreference.com/w/cpp/chrono
]


#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]