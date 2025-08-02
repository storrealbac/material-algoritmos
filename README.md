# Material de Algoritmos y Complejidad

Material educativo para el curso de Algoritmos y Complejidad de la Universidad Técnica Federico Santa María (UTFSM).

## 🚀 Inicio Rápido

```bash
# Instalar fuentes necesarias
./build.sh install-deps

# Compilar todas las presentaciones
./build.sh compile

# Generar PDFs en carpeta output/
./build.sh deploy

# Todo en uno
./build.sh all
```

## 📁 Estructura del Proyecto

```
material-algoritmos/
├── clases/                     # Presentaciones del curso
├── lib/                        # Librerías y plantillas
├── assets/                     # Recursos multimedia
│   ├── img/                    # Imágenes por clase
│   └── presentation/           # Logos institucionales
├── fonts/                      # Fuentes locales del proyecto
├── output/                     # PDFs generados
└── build.sh                    # Script de construcción
```

## 🛠️ Comandos Disponibles

| Comando | Descripción |
|---------|-------------|
| `./build.sh install-deps` | Instala fuentes necesarias |
| `./build.sh compile` | Compila todas las presentaciones |
| `./build.sh watch` | Modo desarrollo (recompila automáticamente) |
| `./build.sh clean` | Limpia archivos generados |
| `./build.sh deploy` | Copia PDFs a output/ |
| `./build.sh all` | Construcción completa |
| `./build.sh help` | Muestra ayuda |

## 📋 Requisitos

- **Typst** (sistema de composición tipográfica)
- **wget** o **curl** (para descargar fuentes)
- **unzip** (para extraer fuentes)

### Instalación de Typst

```bash
# Ubuntu/Debian
curl -fsSL https://typst.community/typst-install/install.sh | sh

# macOS
brew install typst

# Windows
winget install --id Typst.Typst
```

## 🎨 Fuentes

El proyecto utiliza:
- **Roboto** (presentaciones)
- **Fira Code** (código)

Las fuentes se instalan automáticamente en la carpeta `fonts/` con:
```bash
./build.sh install-deps
```

## ⚙️ Configuración

### Variables de Entorno
- `TYPST_FONT_PATHS`: Rutas adicionales de fuentes (automático)

### Personalización
- Edita `lib/presentation-slides.typ` para cambiar el tema
- Modifica colores en las variables `presentation-green` y `presentation-blue`
- Ajusta márgenes en las variables `_presentation-*-margin`

## 🔧 Desarrollo

### Modo Desarrollo
```bash
./build.sh watch
```
Recompila automáticamente al detectar cambios en archivos.

### Estructura de Clases
Cada presentación sigue este formato:
```typst
#import "../lib/presentation-slides.typ": *

#show: presentation-theme.with(
  title: [Título de la Clase],
  subtitle: [Descripción de la clase],
  institute: [Universidad Técnica Federico Santa María],
  show-page-count: true,
)

#title-slide()

#slide[
  = Contenido
  // Tu contenido aquí
]
```

## 🐛 Solución de Problemas

### Error de fuentes
```bash
./build.sh install-deps
```

### Error de permisos
```bash
chmod +x build.sh
chmod 755 fonts/
```

### PDFs no se generan
Verifica que Typst esté instalado:
```bash
typst --version
```


## 📄 Licencia

Este proyecto está bajo la licencia especificada en el archivo `LICENSE`.

## 👨‍🏫 Autor

**Sebastián Torrealba**  
Universidad Técnica Federico Santa María
