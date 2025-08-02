#import "../lib/polylux-compat.typ": *
#import "../lib/presentation-slides.typ": *
#import "../lib/sourcecode.typ": sourcecode

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Algoritmos greedy],
  subtitle: [ Fácil pero dificil  ],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[

  = Qué es un algoritmo greedy

  Un algoritmo voraz es un algoritmo que construye un objeto $X$ paso a paso, eligiendo en cada paso la mejor opción local.


  En algunos casos, los algoritmos voraces construyen el mejor objeto globalmente al elegir repetidamente la mejor opción local.
]

#slide[

  #align(center)[
    #image("../assets/img/7/grafico.png", height: 250pt)
  ]
]

#slide[
  = Ventajas de los greedy

  Los "greedy" tienen ventajas muy importantes sobre otros enfoques algoritmicos:
  
  - *Simplicidad:* Los algoritmos voraces suelen ser más fáciles de describir y programar que otros algoritmos.

  - *Eficiencia:* Los algoritmos voraces a menudo pueden implementarse de manera más eficiente que otros algoritmos.
]

#slide[
  = Desventajas de los greedy

  Los algoritmos voraces tienen varias desventajas:

  - *Dificiles de diseñar*: Una vez que has encontrado el enfoque "greedy" adecuado, diseñar algoritmos voraces puede ser fácil. Sin embargo, encontrar el enfoque correcto puede ser complicado. 

  - *Dificiles de verificar*: Demostrar que un algoritmo "greedy" es correcto a menudo requiere un argumento detallado y matizado.
]

#slide[
  = Problema del arbol de expansión minima

  Dado un grafo, ¿cuál es la cantidad minima de aristas (y las más baratas), que me permitan conectar todo el grafo, de forma que exista un camino de un nodo a cualquier otro nodo?

]

#slide[
  #align(center)[
    #image("../assets/img/7/arbol.png", height: 300pt)
  ]
]

#slide[
  = Formalizando el problema

  Sea $G = (V, E)$. Un árbol de expansión (spanning tree) de $G$ es un grafo $(V, T)$ tal que $(V, T)$ es un árbol.

  - PVamos a identificar un arbol de expansión con un conjunto $T$


  Supongamos que cada arista $(u, v) in E$ asignado con un costo $c(u, v)$.

  El costo de un arbol denotado por $c(T)$ es la suma de todas las aristas de de $T$

$ c(T) = sum_( (u,v) in T) c(u, v) $

Un un arbol de expansión minima (MST) es el arbol tal que: $min sum_( (u,v) in T) c(u, v)$
  
]

#slide[
  = Observaciones importantes

  Recordando que un arbol es un grafo conexo aciclico

  - Si quitamos cualquier arista de un arbol, siempre queda disconexo, entonces esa es la representación minima de aristas necesarias que puede tener un grafo conexo.

  - Si tiene $V$ nodos, tiene exactamente $V-1$ aristas. Demostración al ojo
  
]

#slide[
  = Solución (Algoritmo de Kruskal)

  - Sea $T = Ø$
  - Por cada arista $(u, v)$ ordenadas de menor a mayor por su costo
    - Si existe un camino de $u$ a $v$ en $T$, agrega la arista $(u, v)$ a $T$.

  Se puede demostrar por inducción que el resultado del algoritmo es:

  - Existen exactamente $V-1$ aristas (es un árbol)

  - No existen ciclos (se puede intuir de lo anterior)

  De forma ingenua se puede programar en $O(V dot E)$, pero se puede optimizar haciendolo en $O(E dot alpha(V))$, donde $alpha(n)$ es la función inversa de Ackermann, usando _Disjoint-set Union_.
]

#slide[
  = Problema de scheduling

- Se te da una lista de actividades $(s_1, e_1), (s_2, e_2), dots, (s_n, e_n)$ denotadas por sus tiempos de inicio y finalización.

- Todas las actividades son igualmente atractivas para ti, y deseas maximizar el número de actividades que realizas.

Objetivo: Escoger la mayor cantidad de actividades no superpuestas posible.
]

#slide[
  = Problema de scheduling

  #align(center)[
    #image("../assets/img/7/scheduling.png", height: 250pt)
  ]
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 2em, "¿Ideas?")
  ]
]

#slide[
  = Soluciones malas

  - Elegir siempre las con menor duración: la de menor de duración puede intersectar a dos con mayor duración pero que no intersectan

  - Elegir las que comienzan antes: puede existir una tarea muy larga que comienza antes y que intersecta en todas

 ]

#slide[
  = Solución (ordenar por fín)

  El criterio correcto siempre es elegir el la tarea que termina antes:

  ¿Por qué funciona?
  - Mientras antes podamos elegir otra tarea, mas tareas podremos elegir, en un futuro, a pesar que de que sean largas.

  Ejemplo en pizarra :P
]

#slide[
  = Problema del cambio de monedas

  Considera un sistema monetario compuesto por $n$ monedas. Cada moneda tiene un valor entero positivo.
  
  Tu tarea es producir una suma de dinero $x$ utilizando las monedas disponibles de manera que el número de monedas sea mínimo. Por ejemplo, si las monedas son ${1, 5, 7}$ y la suma deseada es $11$, una solución óptima es $5+5+1$, lo cual requiere $3$ monedas.

]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 2em, "¿Ideas?")
  ]
]

#slide[
  = ¿Solución?

  Ordenar el conjunto de monedas en orden decreciente, de tal forma que se vaya restando de la moneda mas grande, si no se puede, se sigue con la siguiente más grande así sucesivamente.
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 2em, "¿Siempre funciona?")
  ]
]

#slide[
  = No, no siempre funciona

  - No asegura que encuentre una solución factible
    - Por ejemplo: usando el conjunto ${5, 4, 3}$ para obtener $7$ de cambio. Nuestro algoritmo se quedaría atascado.

  - No asegura mejor solución para todos los conjuntos de monedas:
    - Por ejemplo: Usando el conjunto ${4, 3, 1}$ para obtener $6$, la respuesta usando el criterio sería $3$ y el optimo es $2$.
    
]

#slide[
  = ¿Qué hacemos?

  No siempre tendremos conjuntos de monedas variables (de hecho, existe un estandar)

  - Se ha demostrado que este greedy es optimo con el conjunto de monedas con la denominación chilena

  Para cada denominación de monedas podemos demostrar si es o no optimo.

  #presentation-info-block(title: "Truco rapido para saber si sirve")[
    Si se cumple que, dado que $M$ sea el conjunto de monedas, se cumple: $2 dot M_(i-1) <= M_i$

    Demostración al lector.
  ]
]

#slide[
  = Problema de la mochila fraccionario

  El problema de la mochila clásico tienes las siguientes condiciones:

  - Tienes un conjunto de $n$ objetos con peso y valor
  - Solo puedes *incluir o excluir* cada objeto
  - El objeto es maximizar el valor total dentro del limite de peso

  La mochila fraccionaria (la modificación del problema original)
  - Puedes elegir fracciones más pequeñas de cada objeto
  - El objetivo es maximizar el valor total, tomando fracciones de objetos
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 2em, "¿Ideas?")
  ]
]

#slide[
  = Solución

  - Creamos un ratio $r_i = v_i/w_i$, donde $v_i$ y $w_i$ es el valor y peso del objeto $i$ respectivamente.

  - Ordenamos en orden decreciente según el ratio $r$.

  - Del primer elemento al ultimo, de la lista ordenada, intentamos obtener todo el objeto, si no se puede, agarramos lo máximo posible.

  ¿Siempre funciona?, sí :)

  
]


#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]