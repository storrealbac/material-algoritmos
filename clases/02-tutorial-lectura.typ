#import "../lib/polylux-compat.typ": *
#import "../lib/presentation-slides.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Tutorial de como leer],
  subtitle: [Como afrontar un problema de programación\ competitiva de forma correcta y obtener soluciones],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[
  = Reglas generales para leer enunciados

  - Leer el enunciado suele ser un modelo matemático puro. Si la historia ayuda a una comprensión correcta, puedes mantenerla, pero intenta descartar tantos detalles innecesarios como sea posible.

  - Imagina que quieres contarle el problema a alguien más. ¿Qué partes quieres contar?

  - Intenta encontrar patrones familiares, quizás objetos sobre los que ya sabes algo.

  - Los creadores de los problemas no escriben cosas al azar en los enunciados. 

]

#slide[

  = Como afrontar un ejercicio de forma correcta

  Es mala idea pensar que un problema se puede resolver sólo con una técnica.

  Por lo general una forma eficiente de leer es la siguiente:

  *1.* Leer la entrada  y salida del problema
  
  *2.* Leer el enunciado (Si leimos la entrada y salida antes, podemos descartar información antes más rapido)
  
  *3.* Obtener observaciones y propiedades sobre el problema *(MUY IMPORTANTE)*

  *4.* Pensar en algoritmo, si el algoritmo hace menos de $10^8$ operaciones lo programas, en caso contrario, vuelves al paso 3

]

#slide[
  = ¿Por que son $10^8$ operaciones?

  Este límite de tiempo varía, pero a menudo se establece en $1$ o $2$ segundos para muchos problemas. La cifra de $10^8$
  operaciones por segundo es una estimación práctica basada en la capacidad de las CPU modernas para ejecutar operaciones en ese período de tiempo.
]

#slide[
  = ¿Cuales son las complejidades normalmente aceptadas?

  #align(center)[
    #image(height: 13em, "../assets/img/complexity.png")
  ]
]

#slide[
  = Tecnicas para encontrar observaciones y propiedades

  *(1)* De lo especifico a lo general

  Supongamos que has encontrado la solución al problema (¡hurra!). Consideremos algún caso particular del problema. Por supuesto, puedes aplicar el algoritmo/solución a ese caso. Por eso, para resolver un problema general, necesitas resolver todos sus casos específicos. Intenta resolver algunos (o varios) casos específicos y luego generalízalos para encontrar la solución del problema principal.
]

#slide[
  = Tecnicas para encontrar observaciones y propiedades

  *(2)* Yo confio

  No tengas miedo de hacer hipótesis muy duras que te parezcan verdaderas. No tienes que probar tus soluciones durante la resolución del problema, confía en tu intuición. Cuando tengas una hipótesis, intenta probarla: puede funcionar bien o darte una idea de cómo refutarla.

  Ejemplos:
  - En este problema la solución siempre existe para $n >= 10$

  - El número cromatico del grafo para $n>=5$ siempre es $4$
]

#slide[
  = Tecnicas para encontrar observaciones y propiedades

  *(3)* Elige un método

  Intenta revisar algoritmos o métodos populares que puedan aplicarse al problema de alguna manera. Es útil ver los límites del problema. Al elegir un método, intenta pensar en la solución asumiendo que el problema se resuelve usando este método.

  *OJO, NO HAY QUE CASARSE CON LA TÉCNICA*
]

#slide[

  = No se me ocurre un ejercicio, ¿qué hago?

  - Lo pensaste durante suficiente tiempo ($>60 [min]$)
    - Si la respuesta es sí, quizas es buena idea pedir ayuda

  - No se te ocurre el ejercicio completo, pero, encontraste propiedades y observaciones interesantes
    - Sigue intentandolo durante media hora más, si no hay cambios, es buena idea pedir ayuda
]

#slide[
  = ¿Consejos para mejorar?

  Programar
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]