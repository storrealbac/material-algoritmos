#import "../lib/presentation-slides.typ": *
#import "../lib/polylux-compat.typ": *
#import "../lib/sourcecode.typ": sourcecode

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Complejidad y correctitud ],
  subtitle: [ Notación asintotica, teorema maestro y \
  analisis de correctitud],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[

  = Notación asintotica
  
  La notación asintótica en ciencias de la computación describe cómo varía el tiempo de ejecución o el uso de memoria de un algoritmo a medida que crece el tamaño de la entrada. Permite analizar y comparar la eficiencia de algoritmos sin considerar detalles específicos como la implementación exacta o las constantes ocultas.
  
]

#slide[
   = Notación $O$

  La notación $O$ define una _cota asintotica superior_.
   
  #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
    For a given functiong $g(n)$, we denote by $O(g(n))$ (pronounced "big-oh of g of n" or sometimes just "oh of g of n") the _set of functions_

    $ O(g(n)) = { f(n) : "there exist positive constants" c "and " n_0 "such that" 0 <= f(n) <= c g(n)" for all " n >= n_0} $

    A function $f(n)$ belongs to the set $O(g(n))$ if there exists a positive constant $c$ such that $f(n) <= c g(n)$ for sufficiently large $n$.
  ]
  
]


#slide[
   = Notación $Omega$

   La notación $Omega$ define una _cota asintotica inferior._

    #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
    For a given function $g(n)$, we denote by $Omega(g(n))$ (pronounced "big-omega of g of n" or sometimes just "omega of g of n") the _set of functions_

    $ Omega(g(n)) = { f(n) : "there exist positive constants" c "and " n_0 "such that" 0 <= c g(n) <= f(n)" for all " n >= n_0} $

    A function $f(n)$ belongs to the set $Omega(g(n))$ if there exists a positive constant $c$ such that $f(n) >= c g(n)$ for sufficiently large $n$.
  ]
   
]


#slide[
  = Notación $Theta$

   La notación $Theta$ define una _cota asintotica ajustada._

    #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
      For a given function $g(n)$, we denote by $Theta(g(n))$ ("theta of g of n") the _set of functions_

    $ Theta(g(n)) = { f(n) : "there exist positive constants" c "and " n_0 "such that" c_1 g(n) <= f(n) <= c_2 g(n)" for all " n >= n_0} $

    A function $f(n)$ belongs to the set $Theta(g(n))$ if there exists a positive constant $c$ such that $c_1 g(n) <= f(n) <= c_2 g(n)$ for sufficiently large $n$.
  ]
]

#slide[
  = Notación $Theta$

  Básicamente:

  $ Theta(f(n)) = O(f(n)) sect Omega(f(n)) $
]

#slide[
   = Notación $o$

  La notación $o$ define una _cota asintotica estrictamente superior_

    #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
      For a given function $g(n)$, we denote by $o(g(n))$ ("little-oh of g of n") the _set of functions_

    $ Theta(g(n)) = { f(n) : "for any positive constants" c "and " n_0 "such that" 0 <= f(n) < c g(n)" for all " n >= n_0} $

    A function $f(n)$ belongs to the set $o(g(n))$ if for any a positive constant $c$ such that $f(n) < c g(n)$ for sufficiently large $n$.
  ]
]

#slide[
   = Notación $o$

  Una definición alternativa es

  $ lim_(n -> oo) (f(n))/(g(n)) = 0 $
  
]

#slide[
   = Notación $omega$

  La notación $omega$ define una _cota asintotica estrictamente superior_

    #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
      For a given function $g(n)$, we denote by $omega(g(n))$ ("little-omega of g of n") the _set of functions_

    $ omega(g(n)) = { f(n) : "for any positive constants" c "and " n_0 "such that" 0 <= c g(n) < f(n)" for all " n >= n_0} $

    A function $f(n)$ belongs to the set $o(g(n))$ if for any a positive constant $c$ such that $c g(n) < f(n)$ for sufficiently large $n$.
  ]
]

#slide[
   = Notación $omega$

  Una definición alternativa es

  $ lim_(n -> oo) (f(n))/(g(n)) = oo $
  
]

#slide[
  = A tener cuidado

  Tal como aparece en la definición, la notación asintotica es un conjunto de funciones _(a set of functions)_.

  Por lo tanto la igualdad en contexto de notación asintotica no cumple con simetria.

  $ f(n) = T(n)  =>  f(n) in T(n) $

  Con esto es claro que no siempre se cumple que:

  $ T(n) = f(n) $

]

#slide[

  = Propiedades interesantes

  Es transitiva, es decir:
  
  $ f(n) = Theta(g(n)) and g(n) = Theta(h(n)) $

  $ "implica" $

  $ f(n) = Theta(h(n)) $

  _Esto es equivalente para $O$, $o$, $Omega$ y $omega$._
  
]

#slide[

  = Propiedades interesantes

  Es reflexiva, es decir:
  
  - $f(n) = Theta(f(n))$
  - $f(n) = O(f(n))$
  - $f(n) = Omega(f(n))$

    #presentation-alert-block(title: "Importante")[
      Esto *no* se cumple para $o$ y $omega$.
  ]

]

#slide[

  = Propiedades interesantes

  Para $O$ y $Omega$ existe simetria de la transposición:
  
  $ f(n) = O(g(n)) => g(n) = Omega(f(n)) $
  $ f(n) = Omega(g(n)) => g(n) = O(f(n)) $


  _Esto es equivalente con $o$ y $omega$._

]

#slide[
  = Un pequeño life-hack

  - $f(n) = o(n)$ implica $f(n) = O(n)$
  - $f(n) = omega(n)$ implica $f(n) = Omega(n)$

]

#slide[
  = Recordatorio mental

  Podemos hacer una analogia de las asintoticas como si fueran dos numeros reales $a$ y $b$.

  - $f(n) = O(g(n))$ es como $a <= b$
  - $f(n) = Omega(g(n))$ es como $a >= b$
  - $f(n) = Theta(g(n))$ es como $a = b$
  - $f(n) = o(g(n))$ es como $a < b$
  - $f(n) = omega(g(n))$ es como $a > b$
  
]

#slide[
  = Teorema maestro

  El teorema maestro es una receta para resolver recurrencias algoritmicas, donde cumple la siguiente forma:

  $ T(n) = a dot T(n/b) + O(n^d) $

  Donde:
  - $a$ es la cantidad de llamadas recursivas
  - $b$ es factor de reducción del tamaño de la entrada
  - $d$ es el exponente en el tiempo de ejecución del "paso de combinación"

  _Notar que $T(n)$ es recursiva_
  
]

#slide[

  = Teorema maestro

  
    #presentation-info-block(title: "Definición formal")[
    #set text(12pt)
    *Theorem 4.1 (Master Method)* If $T(n)$ is defined by a standard recurrence with parameteres $a >= 1$, $b > 1$ and $d>=0$ then

    $ T(n) = cases(
      O(n^d log n) "if" a = b^d,
      O(n^d) "if" a < b^d,
      O(n^(log_b a)) "if" a > b^d,
    ) $

  ]
  
]

#slide[
  = Ejemplo de recurrencias del teorema maestro

  - Busqueda binaria: $T(n) = T(n/2) + O(1)$
  - Recorrer un arbol binario: $T(n) = 2 T(n/2) + O(1)$
  - Merge-sort: $T(n) = 2 T(n/2) + O(n)$
  - Multiplicación Toom-4: $T(n) = 7 T(n/4) + O(n)$
  - Multiplicación Toom-3: $T(n) = 5 T(n/3) + O(n)$
  - Karatsuba: $T(n) = 3 T(n/2) + O(n)$
  - Stooge-sort: $T(n) = 3 T(n/1.5) + O(n)$
  - Multiplicación Strassen: $T(n) = 7 T(n/2) + O(n^2)$
]

#slide[
  = Correctitud

En teoría de la computación, la corrección de un algoritmo, también llamada correctitud (como adaptación de la palabra inglesa correctness), corresponde a una propiedad que distingue a un algoritmo de un procedimiento efectivo. 

Un algoritmo es correcto si:
- Resuelve el problema para el que fue diseñado
- Para cada entrada, produce una salida
- Termina en un tiempo de ejecución finito

Si no se cumple cada punto, entonces es un algoritmo *incorrecto*.
  
]

#slide[
  = Correctitud

  Para demostrar que un algoritmo es correcta existen muchas formas, pero veremos dos en el curso:

  - Inducción
  - Invariante de ciclo
  - Por contradicción
]

#slide[
  = Inducción

  Una pequeña cita para entender qué es inducción:
  
  #presentation-info-block(title:"")[
    La inducción matemática demuestra que podemos subir tan alto como queramos en una escalera, si demostramos que podemos subir el primer peldaño (el "caso base") y que desde cada peldaño podemos subir al siguiente (el "paso" inductivo).

    #align(end)[
      _Concrete Mathematics, pág. 3, margen (en inglés)._
    ]
  ]
]


#slide[
  
  = Inducción

  Se tienen que seguir los siguientes casos:
  
  *Caso base*: Demuestra que la afirmación es verdadera para el valor inicial (ej: $n=1$ o $n=0$).

  *Paso inductivo:* Asume que la afirmación es verdadera para $n=k$ y demuestra que es verdadera para $n=k+1$.

  Si ambos pasos se cumplen, la afirmación es verdadera para todos los valores de $n$.
]

#slide[
  = Inducción

  Por ejemplo, se sabe que la suma de los primeros $n$ numeros naturales es $n(n-1)/2$, demostremos mediante inducción
]

#slide[
  = Inducción

    Por ejemplo, se sabe que la suma de los primeros $n$ numeros naturales es $n(n-1)/2$, demostremos mediante inducción:

    #presentation-example-block(title: "Demostración")[
    *Caso base:* Para $n = 1$, la suma es $1$ y $1(1+1)/2 = 1$. Se cumple.
    
    *Paso inductivo:* Asumimos que para $n = k$, $S_k = k(k+1)/2$.
    
    Demostremos para $n = k+1$:
    
    $S_(k+1) = S_k + (k+1) = k(k+1)/2 + (k+1)$
    
    $S_(k+1) = (k+1)(k+2)/2$
    
    
    Por lo tanto, se cumple para todos los $n$.
    ]
]

#slide[
  = Correctitud del merge sort

  *Caso base:* Sub-arreglos de tamaño $1$, por definición, ya está ordenado.

  *Paso inductivo:* Asumiendo la correctitud del mezclado de dos arreglos ordenados. El _merge-sort_ hace dos llamadas recursivas de tamaño $n/2$, las cuales contiene los indices de dos _sub-arreglos_ ya ordenados. Haciendo el mezclado de los dos _sub-arreglos_, ya tendriamos el de tamaño $n$ ordenado.

  Como conclusión, el _merge-sort_ es correcto.

  
  
]

#slide[
  = Invariante de ciclo

  En ciencias de la computación, una invariante es una propiedad o condición que permanece constante o verdadera durante la ejecución de un programa o de un algoritmo.
  
]

#slide[
  = Invariante de ciclo

  Tiene tres propiedades principales:

  - *Inicialización:* Es verdadera antes de la inicialización de la primera iteración.

  - *Mantenimiento:* Si es verdadera antes de una iteración del bucle, permanece verdadera antes de la siguiente iteración del bucle.

  - *Terminación:* Cuando el bucle termina, la invariante del bucle proporciona una propiedad útil que nos ayuda a demostrar que el algoritmo es correcto.

]

#slide[

  = Insertion sort

  #set text(13pt)
  #sourcecode[
   ```cc
    void insertionSort(vector<int>& vec) {
      int n = vec.size();
      for (int i = 1; i < n; ++i) {
          int key = vec[i];
          int j = i - 1;
  
          // Mueve los elementos de vec[0..i-1] que son mayores que key,
          while (j >= 0 and vec[j] > key) {
              vec[j + 1] = vec[j];
              j--;
          }
          vec[j + 1] = key;
      }
    }
   ```
  ]

]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]