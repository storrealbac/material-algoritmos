#import "../lib/polylux-compat.typ": *
#import "../lib/presentation-slides.typ": *
#import "../lib/sourcecode.typ": sourcecode

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#show: presentation-theme.with(
  title: [ Estructuras de datos en C++],
  subtitle: [Como utilizar estructuras y funciones built-in\ de la libreria estandar y programar para jueces\ virtuales],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide() 

#slide[
  = Librerias

  Existen muchas librerias disponible dentro de lo estandar de C++

  #set text(size: 15pt)
  #grid(columns: 6, gutter: 1em)[
- iostream
- iomanip
- fstream
- sstream
- vector
- deque
- list
  ][
- set
- unordered_set
- map
- unordered_map
- stack
- queue
- bitset
- algorithm
  ][
- numeric
- functional
- utility
- tuple
- memory
- limits
- exception
- cmath 
  ][
- cstdlib
- cstdio
- cstring
- string
- climits
- cfloat
- queue
- stack 
  ][
- priority_queue
- thread
- mutex
- condition_variable
- cassert
- ctime
- random
- chrono    
  ][
- ratio
- array
- complex
- type_traits
- typeinfo
- cstddef
- initializer_list
  ]

]

#slide[
  = Librerias

  Pero todas se resumen en la siguiente

  - bits/stdc++.h

  Simplemente es un header que incluye todas las librerias anteriormente mencionadas

    #presentation-alert-block(title: "¡Importante!")[
    Sólo está disponible en el compilador de `g++`, no funciona con `clang`
  ]


]

#slide[
  = Código plantilla

  Hay de muchos estilos y gustos, pero este es el que usa el ayudante:

    #sourcecode[
    ```cpp
    #include<bits/stdc++.h>

    using namespace std;

    using ll = long long;
    using ld = long double;

    int main() {
      // Acá se escribe el código
      return 0;
    }

    ```    
  ]    
]

#slide[
  = Código plantilla 

  Alternativa, usado por mis compañero de equipos
  #set text(size: 12pt)
    #sourcecode[
    ```cpp
#include <bits/stdc++.h>
#include <ext/pb_ds/assoc_container.hpp>
#include <ext/pb_ds/tree_policy.hpp>
using namespace __gnu_pbds;
using namespace std;
template <typename T> using oset = tree<T, null_type, less<T>, rb_tree_tag, tree_order_statistics_node_update>;
#define int long long
#define endl '\n'
#define vvi vector<vector<int>>
#define pii pair<int,int>
#define usm freopen("input.txt","r",stdin); freopen("output.txt","w",stdout);
#define ld long double

// ...

int main() { /* ... */ }
    ```    
  ]
    _Creditos a abner\_vidal_
]

#slide[
  = Código plantilla 

  Alternativa, usado por mis compañero de equipos
  #set text(size: 14pt)
    #sourcecode[
    ```cpp
#pragma GCC optimize("O3,unroll-loops")
#pragma GCC target("avx2,bmi,bmi2,lzcnt,popcnt")
#include <bits/stdc++.h>
#define forn(i,i0,n) for(ll i = int(i0); i < int(n); ++i)
#define USM ios_base::sync_with_stdio(false),cin.tie(NULL)
#define double long double
#define endl '\n'
#define pcount(a) __builtin_popcountll(a)
#define INF LLONG_MAX/100
using namespace std;
typedef long long ll;

int main(){ USM; }
    ```    

  ]
    _Creditos a CharlesLakes_
]

#slide[
  = Contenedores

  - `vector<T>`
  - `queue<T>`
  - `stack<T>`
  - `set<T>`
  - `map<T1, T2>`
  - `pair<T1, T2>`
]

#slide[
  = Contenedores: `vector`
  Un _vector_ es un contenedor que representa un arreglo dinámico. Puedes definirlo de las siguientes formas:

  #sourcecode[
    ```cpp
 // Estructura básica. En T se  especifica el tipo de dato a almacenar
 vector<T> nombre_de_variable; 
 
 vector<int> arr1; // Arreglo vacío de int's
 
 vector<int> arr2(10); // Arreglo inicializado con 10 elementos
 
 vector<int> arr3(8, -1); // Arreglo inicializado con 8 elementos, asignando -1 a todas las posiciones
 
 vector<vector<string>> arr5; // Vector que almacena vectores de string
    ```
  ]
]

#slide[
  = Contenedores: `vector`
  Algunas operaciones básicas que podemos realizar:
  #set text(size: 13.5pt)
  #sourcecode[
    ```cpp
 arr1.push_back(10); // Inserta 10 al final en O(1)
 
 arr2.pop_back(); // Elimina el último elemento en O(1)
 
 arr2[0] = -1; // Asigna -1 en la posición 0
 
 arr2[3] = 15; // Asigna 15 en la posición 3
 
 arr2.clear(); // Elimina todos los elementos del vector
 
 cout << arr3.size(); // Devuelve el tamaño del vector
 
 // Recorrer el vector usando un bucle for tradicional
 for(int i = 0; i < arr1.size(); i++)
  cout << arr1[i] << endl;
  
 // Recorrer el vector usando un foreach
 for(int numero : arr1)
  cout << numero << endl;
    ```
  ]
]

#slide[
  = Contenedores: `queue`

  Una `queue` (cola) es un contenedor que sigue el principio FIFO (First In, First Out). Se define
 de la siguiente manera:

 #sourcecode[
   ```cpp
queue<tipo_de_dato> nombre_de_variable;
queue<int> cola;
   ```
 ]
]

#slide[
  = Contenedores: `queue`

  Algunas operaciones básicas que podemos realizar:
  #set text(size: 16pt)
 #sourcecode[
   ```cpp
// Inserta el valor 20 al final de la cola
cola.push(20);

// Imprime el valor en el frente de la cola
cout << cola.front() << endl;

// Elimina el elemento al frente de la cola
 cola.pop();

 // Devuelve la cantidad de elementos en la cola
cout << cola.size() << endl;

// Verifica si la cola está vacía
cout << (cola.empty() ? "Cola vacía" : "Cola no vacía") << endl;
   ```
 ]
]

#slide[
  = Contenedores: `stack`

   Una `stack` (pila) es un contenedor que sigue el principio LIFO (Last In, First Out). Se define de la siguiente manera:

   #sourcecode[
     ```cpp
stack<tipo_de_dato> nombre_de_variable;
stack<int> pila;
     ```
   ]
]

#slide[
  = Contenedores: `stack`
  Algunas operaciones básicas que podemos realizar:

  #set text(size: 17pt)
  #sourcecode[
    ```cpp
// Inserta el valor 30 en la pila
pila.push(30);

// Imprime el valor en el tope de la pila
cout << pila.top() << endl;

// Elimina el elemento en el tope de la pila
pila.pop();

// Devuelve la cantidad de elementos en la pila
cout << pila.size() << endl;

// Verifica si la pila está vacía
cout << (pila.empty() ? "Pila vacía" : "Pila no vacía") << endl; 

    ```
  ]
]

#slide[
  = Contenedores: `set`

   Un set es un contenedor que almacena elementos únicos en orden específico. Se define de la siguiente manera:

   #sourcecode[
     ```cpp
set<tipo_de_dato> nombre_de_variable;
set<int> conjunto;
     ```
   ]
 ]

#slide[
  = Contenedores: `set`

  Algunas operaciones básicas que podemos realizar (1):

  #sourcecode[
    ```cpp
 conjunto.insert(15); // Inserta el valor 15 en el set
 conjunto.insert(20); // Inserta el valor 20 en el set
 conjunto.insert(10); // Inserta el valor 10 en el set

 // Devuelve la cantidad de elementos en el set
 cout << conjunto.size() << endl;
 
 // Verifica si el set está vacío
 cout << (conjunto.empty() ? "Set vacío" : "Set no vacío") << endl;
 // Imprimir todos los elementos del set
 for (int elemento : conjunto)
  cout << elemento << " "; // Imprime cada elemento
    ```
  ]
]

#slide[
  = Contenedores: `set`

  Algunas operaciones básicas que podemos realizar (2):

  #set text(size: 13pt)
  #sourcecode[
    ```cpp
// Eliminar un elemento
conjunto.erase(20); // Elimina el elemento 20 del set

// Uso de lower_bound (Encuentra el primer elemento no menor que 12)
auto it_lower = conjunto.lower_bound(12);
if (it_lower != conjunto.end())
 cout << "El primer elemento no menor que 12 es: " << *it_lower << endl;
else cout << "No hay elementos no menores que 12 en el set" << endl;

// Uso de upper_bound (Encuentra el primer elemento mayor que 12)
auto it_upper = conjunto.upper_bound(12);
if (it_upper != conjunto.end())
 cout << "El primer elemento mayor que 12 es: " << *it_upper << endl;
else cout << "No hay elementos mayores que 12 en el set" << endl;
    ```
  ]
]

#slide[
  = Contenedores: `map`

  Un map es un contenedor que almacena pares clave-valor ordenados por las claves. Se define de la siguiente manera:

  #sourcecode[
    ```cpp
map<tipo_de_clave, tipo_de_valor> nombre_de_variable;
map<string, int> mapa;
    ```
  ]
]

#slide[
  = Contenedores: `map`
  Algunas operaciones básicas que podemos realizar (1):

  #sourcecode[
    ```cpp
mapa["manzanas"] = 10; // Asigna el valor 10 a la clave "manzanas"
mapa["naranjas"] = 5; // Asigna el valor 5 a la clave "naranjas"

// Imprime el valor asociado a la clave
cout << mapa["manzanas"] << endl;

// Elimina el par clave-valor con la clave "naranjas"
mapa.erase("naranjas");

// Devuelve la cantidad de elementos en el map
cout << mapa.size() << endl;
    ```
  ]
]

#slide[
  = Contenedores: `map`
  Algunas operaciones básicas que podemos realizar (2):

  #sourcecode[
    ```cpp
// Verifica si el map está vacío
cout << (mapa.empty() ? "Mapa vacío" : "Mapa no vacío") << endl;

// Iteración sobre el map usando un foreach
for (auto par : mapa) {
 cout << "Clave: " << par.first << ", Valor: " << par.second << endl;
 // Imprime cada clave y su valor asociado
}
    ```
  ]
]

#slide[
  = Contenedores: `pair`

Un `pair` es una estructura que puede contener dos valores de diferentes tipos. Se usa comúnmente para almacenar pares de datos relacionados, como coordenadas o claves y valores.

#sourcecode[
  ```cpp
 pair<tipo_de_dato1, tipo_de_dato2> nombre_de_variable;
 pair<int, string> par;
 
 // Inicializar un par
 par = make_pair(1, "uno");
 
 // Acceso a elementos
 cout << par.first << endl; // Imprime el primer elemento (1)
 cout << par.second << endl; // Imprime el segundo elemento ("uno")
  ```
]

]

#slide[
  = Algoritmos
  - `std::sort`
  - `std::reverse`
  - `std::lower_bound`
  - `std::upper_bound`
  - `std::next_permutation`
]

#slide[
  = Algoritmos: `sort`

  La función `sort` es utilizada para ordenar elementos en un contenedor. Esta función es parte de la librería `<algorithm>`

  #sourcecode[
    ```cpp
vector<int> numeros = {5, 2, 9, 1, 5, 6};

// Ordenar el vector en orden ascendente
sort(numeros.begin(), numeros.end());

// Ordenar el vector en orden descendente
sort(numeros.begin(), numeros.end(), greater<int>());
```
]

]

#slide[
  = Algoritmos: `sort`

  Ordenando usando otra relación de orden (cambiando el criterio de comparación)
  
  #set text(size: 16pt)
  #sourcecode[
    ```cpp
// Ordena de menor a mayor segun el segundo del par
bool compararPorSegundo(pair<int, int> a, pair<int, int> b) {
  return a.second < b.second;
}
 
int main() {
 vector<pair<int, int>> pares = {{1, 4}, {2, 2}, {3, 3}};
 // Ordenar el vector de pares usando una función de comparación
 sort(pares.begin(), pares.end(), compararPorSegundo);

 // ...
}
```
]

]

#slide[
  = Algoritmos: `reverse`

  La función `reverse` invierte el orden de los elementos en un contenedor
  
  #set text(size: 16pt)
  #sourcecode[
    ```cpp
 vector<int> numeros = {1, 2, 3, 4, 5};
 
 // Invertir el vector
 reverse(numeros.begin(), numeros.end());
 
 // Imprimir el vector invertido
 cout << "Vector invertido: ";
 
 for (int num : numeros)
  cout << num << " ";
```
]

]

#slide[
  = Algoritmos: `lower_bound`/`upper_bound`

 Las funciones `lower_bound` y  `upper_bound` se utilizan para buscar elementos en contenedores ordenados. lower_bound devuelve un iterador al primer elemento que no es menor que el valor especificado, mientras que upper_bound devuelve un iterador al primer elemento mayor que el valor especificado.
 
  #set text(size: 16pt)
  #sourcecode[
    ```cpp
vector<int> numeros = {1, 2, 4, 4, 5, 6, 7};
auto it_lower = lower_bound(numeros.begin(), numeros.end(), 4);
auto it_upper = upper_bound(numeros.begin(), numeros.end(), 4);

// Índice del primer 4
cout << "Lower bound de 4: " << distance(numeros.begin(), it_lower) << endl;

 // Índice del primer elemento mayor que 4
 cout << "Upper bound de 4: " << distance(numeros.begin(), it_upper) << endl;
```
]

]

#slide[
  = Algoritmos: `next_permutation`

   La función `next_permutation` transforma el contenedor en la siguiente permutación lexicográficamente mayor. Si el contenedor está en su última permutación posible, lo transforma a la primera permutación.

   #sourcecode[
     ```cpp
  vector<int> numeros = {1, 2, 3};
 do {
   // Imprimir la permutación actual
   for (int num : numeros) {
   cout << num << " ";
   }
 cout << endl;
 } while (next_permutation(numeros.begin(), numeros.end()));
     ```
   ]
]

#slide[
  #align(center + horizon)[
    #text(weight: "bold", size: 5em, "¡Fin!")
  ]
]