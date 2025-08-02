#import "../lib/polylux-compat.typ": *
#import "../lib/presentation-slides.typ": *
#import "../lib/sourcecode.typ": sourcecode

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Backtracking no es fuerza bruta],
  subtitle: [ Diferencias entre fuerza bruta y backtracking],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[

  = Contenidos
  - Fuerza bruta
  - Backtracking
  - Heuristicas que no mejoran cota pero si tiempo
  - Principio de generar no filtrar
  - Branch & bound
  
]

#slide[

  = Fuerza bruta
  
  En computación, fuerza bruta se refiere a una técnica o estrategia para resolver problemas mediante la búsqueda exhaustiva de todas las posibles soluciones hasta encontrar la correcta.

  Es decir:
  - Un método de búsqueda exhaustiva
  - Para cada solución... (de alguna forma iterarlas)
  - Ver si anda / evaluarla / procesarla
  
]

#slide[
  = Ejemplo de fuerza bruta

  Si deseamos calcular cuantos trios pitagoricos menores a $n$ existen podemos hacer lo siguiente:

 #sourcecode[```cc
int count = 0;
for (int a = 1; a < n; ++a)
  for (int b = a + 1; b < n; ++b)
    for (int c = b + 1; c < n; ++c)
      if (a * a + b * b == c * c)
        count++;
cout << count << endl;
 ```]
]

#slide[
  = Backtracking

  El backtracking es una técnica utilizada en computación para resolver problemas mediante la exploración sistemática de soluciones, donde tenemos la capacidad de devolvernos al paso anterior en caso de que una solución no sea factible.

  Es un *proceso incremental de construcción* de posibules soluciones, *paso a paso*, en cada paso evaluamos y no solamente al final.

  #presentation-alert-block(title: "Importante")[
    Notar que la definición de backtracking *nunca* habla de recursividad, se puede implementar de forma iterativa.
  ]
  
]

#slide[
  = Ejemplo de backtracking
  Este es el mismo código, pero hecho con backtracking, aquí en cada paso se verifica si cumplen la condición:

  #sourcecode[```cc
    for (int a = 1; a < n; ++a)
      if (a * a < n * n)
      for (int b = a + 1; b < n; ++b)
        if (a * a + b * b <= (n - 1) * (n - 1))
        for (int c = b + 1; c < n; ++c)
          if (a * a + b * b == c * c)
              count++;
    cout << count << endl;
  ```]
]

#slide[
  = Ejemplo: prefi-primos
  Un número es _prefi-primo_ si todos sus prefijos son primos:
  - 233 es prefi-primo, porque 2, 23 y 233 son primos.
  - 251 es primo, pero no _prefi-primo_, _25_ no es primo.
  Sea $f_n := "La cantidad de prefi-primos de" n "digitos"$.\
  Sea $n$ un valor acotado por $1 <= n <= 10^4$. Calcular $f_n$

  _Asuma que existe una forma de hacer test de primalidad en $O(1)$_
  #presentation-info-block(title: "Significado de prefijo")[
    Un prefijo en arreglos y cadenas de textos es cualquier subsecuencia contigua que contenga el primer elemento, por ejemplo, _abc_ es un prefijo de _abcde_, pero _bc_ no lo es.
  ]
]

#slide[
  = Opción fuerza bruta
  
  Computar $f_n$ aquí nos tomaría $O(n dot 10^n)$
  
  #sourcecode[```cc
  for (int a = 1; a <= 9; a++)
   for (int b = 0; b <= 9; b++)
   for (int c = 0; c <= 9; c++)
   for (int d = 0; d <= 9; d++)
     if (primo(a) and primo(10*a+b) and primo(100*a+10*b+c) )
     if (primo(1000*a+100*b+10*c+d))
      ret++;
  ```]

  ¿Se puede hacer mejor?
]

#slide[
  = Opción backtracking
  Computar $f_n$ aquí nos tomaria $O(n dot (f_1 + f_2 + ... +f_n) )$
  #sourcecode[```cc
  for (int a = 1; a <= 9; a++)
  if (primo(a))
  for (int b = 0; b <= 9; b++)
  if (primo(10*a+b))
  for (int c = 0; c <= 9; c++)
  if (primo(100*a+10*b+c))
  for (int d = 0; d <= 9; d++)
  if (primo(1000*a+100*b+10*c+d))
    ret++;
  ```
  ]
  ¿Es realmente mejor que el ejemplo anterior?
]

#slide[
  = Existen MUY POCOS prefi-primos
  - $f_1 = 4$
  - $f_2 = 9$
  - $f_3 = 14$
  - $f_4 = 16$
  - $f_5 = 15$
  - $f_6 = 12$
  - $f_7 = 8$
  - $f_8 = 5$
  - $f_i = 0, forall i >= 9$
]

#slide[
  = Conclusiones de mejora del rendimiento
  - Pasamos de una fuerza bruta de $10^8$ operaciones a $664$
  - Aunque no es necesario que se mejora la cota asintotica, tambien es posible como en el ejemplo de los prefi-primos
]

#slide[
  = Heuristicas que no mejoran cota pero si tiempo

  ¿Es posible mejorar el tiempo drasticamente de un problema, incluso si el peor caso ajustado sigue siendo costoso?

  La respuesta es un rotundo *SI*
]

#slide[
  = Knight tour problem

Un tour del caballo es una secuencia de movimientos de un caballo en un tablero de ajedrez de $n times n$ siguiendo las reglas del ajedrez, de manera que el caballo visite cada casilla exactamente una vez.

  #align(center)[
    #image("../assets/img/6/knight-tour.png", width: 8em)
  ]
  
]

#slide[
  = Solución con backtracking

  Una solución con backtracking en un tablero de $n times n$ podría generar $8^n^2$ secuencias posibles.

  Si fuera un tablero de $8 times 8$, existiran $8^64$ secuencias posibles.

  Este programa terminaria en un aproximado de $10^41$ años, lo cual es mayor que la edad actual del universo.

  Existe una forma de hacerlo en $<= 1 [s]$ con un backtracking con el *mismo* peor caso.
]

#slide[
  = Regla de Warnsdorff's

  El código unicamente cambiaria en una parte, cuando se quiera mover a una casilla, se tiene que mover a la casilla que tenga menor cantidad de movimientos posibles.

  Esto funciona porque al momento de movernos de casilla, siempre decrecemos la cantidad de movimientos, lo cual está muy lejanos del peor caso.
]

#slide[
  = Principo de generar y no filtrar

  Supongamos que queremos saber cuantos numeros cumplen cierta condición. 

  - Es posible generar todas las posibilidades y filtrar las correctas
  - También podemos generar todas las posibilidades, sin filtrar.
]

#slide[
  = Ejemplo de generar y no filtrar

  Supongamos que queremos buscar todos los palindromos binarios menores a $n$

  _Un palindromo binario de tamaño $n$ es una cadena de caracteres donde cada caracter pertenece al alfabeto $Sigma = {0, 1}$_

  Restricciones:
  
  - $Sigma = {0, 1}$
  - $ 1 <= n <= 10^10$
  - El primer digito es distinto a $0$
]

#slide[
  = Solución fuerza bruta

  La complejidad de este código es $O(n dot log(n))$. En el peor caso son $approx 5 dot 10^10$ operaciones, *muy malo*.

  #sourcecode[```cpp
    int respuesta = 0;
    for (int i = 1; i <= n; i++) {
      if (esBinario(i) and esPalindromo(i))
        respuesta++;
    }
    return respuesta;
  ```]
]

#slide[
  = Solución backtracking

  Podemos generar todas las cadenas binarias de tamaño, sea $k$ la cantidad de digitos, sabemos que la cantidad de digitos está definido por $floor(log_10 (n) ) + 1$, podemos generar siempre secuencias de tamaño $k/2$, ya que los primeros $k/2$ son iguales a los ultimos $k/2$ digitos.

  En el peor caso solo hariamos $approx 2^5$, nunca generariamos un caso invalido y solo pasamos por los válidos.

  _Código se deja como tarea al lector_
]

#slide[
  = Consejos al momento de hacer backtracking

  Es muy importante mantener una constante baja al momento de correr el programa, porque mientras más rapido se hagan las operaciones elementales, más podemos recorrer.

  - Si se pueden usar operaciones de bits, usarlas.
  - Evitar usar memoria dinámica (usar `int x[n]` en vez de `vector<int> x(n)`)
  - Pasar por referencia en lugar de copiar
  - Precomputar, para evitar multiplicar en la parte exponencial
]

#slide[
  = Branch and bound

  - En cada nodo del árbol de backtracking se computan cotas inferior y superior $L$, $U$ (con $L <= U$) a las posibles soluciones desde ese nodo.
  - Se mantiene una variable global `best` con el valor de la mejor solución encontrada
  - Para un problema de minimización, `best` tiene en todo momento el mínimo $U$ que hemos visto en todo el algoritmo
  -  Para un problema de minimización, si `L >= best` podemos descartar ese nodo y todo su subárbol
  -  Lo esencial: meter un `if (L >= best)` return; al comienzo de la función recursiva
]

#slide[
  = Ejemplo de branch and bound: Knapsack

  El problema de la mochila (knapsack) consiste en que tienes $n$ objetos, donde cada uno tiene un peso $w_i$ y una valor $v_i$, donde existe una mochila $W$, puedes elegir la cantidad de objetos que desees.
  
  Tu objetivo es maximizar la suma de $v_i$ elegidos sin que supere el peso $W$.
  
]

#slide[
  = Solución branch and bound

  - El $U$ puede ser calculado usando un algoritmo greedy (lo entenderán en el futuro)
  - El $L$ puede ser recalculado dinamicamente mientras hacemos el backtracking, es decir `L := best`

  Todo lo demás se reduce es exactamente que hacer un backtracking.

  _Lo mejor de todo, es que esta no es la mejor solución :) _
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]