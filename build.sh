#!/bin/bash

# Script de construcción para material de Algoritmos y Complejidad
# Universidad Técnica Federico Santa María

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorios
CLASES_DIR="clases"
OUTPUT_DIR="output"
LIB_DIR="lib"
FONTS_DIR="fonts"

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}Script de construcción para Material de Algoritmos${NC}"
    echo ""
    echo "Uso: $0 [OPCION]"
    echo ""
    echo "Opciones:"
    echo "  compile       Compilar todas las presentaciones"
    echo "  watch         Modo desarrollo (observa un archivo específico)"
    echo "  serve         Servidor HTTP con auto-refresh para PDFs"
    echo "  clean         Limpiar archivos generados"
    echo "  deploy        Generar PDFs en carpeta output"
    echo "  install-deps  Instalar dependencias (fuentes)"
    echo "  all           Ejecutar clean + compile + deploy"
    echo "  help          Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  $0 install-deps # Instala fuentes necesarias"
    echo "  $0 compile      # Compila todas las clases"
    echo "  $0 watch        # Modo desarrollo"
    echo "  $0 serve        # Servidor con auto-refresh"
    echo "  $0 all          # Construcción completa"
}

# Función para verificar dependencias
check_dependencies() {
    echo -e "${BLUE}[INFO]${NC} Verificando dependencias..."
    
    if ! command -v typst &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} Typst no está instalado"
        echo "Instala Typst desde: https://github.com/typst/typst"
        exit 1
    fi
    
    if ! command -v inotifywait &> /dev/null && [ "$1" = "watch" ]; then
        echo -e "${YELLOW}[WARN]${NC} inotify-tools no está instalado (necesario para modo watch)"
        echo "Instala con: sudo apt install inotify-tools"
    fi
    
    echo -e "${GREEN}[OK]${NC} Dependencias verificadas"
}


# Función para limpiar archivos generados
clean() {
    echo -e "${BLUE}[INFO]${NC} Limpiando archivos generados..."
    
    # Limpiar directorio output
    rm -rf "$OUTPUT_DIR"/*.pdf 2>/dev/null || true
    
    echo -e "${GREEN}[OK]${NC} Limpieza completada"
}

# Función para compilar una clase específica
compile_class() {
    local file="$1"
    local basename=$(basename "$file" .typ)
    
    # Crear directorio output si no existe
    mkdir -p "$OUTPUT_DIR"
    
    echo -e "${BLUE}[INFO]${NC} Compilando $basename..."
    
    if typst compile --root . --font-path "./fonts" "$file" "$OUTPUT_DIR/$basename.pdf" 2>/dev/null; then
        echo -e "${GREEN}[OK]${NC} $basename compilado exitosamente en $OUTPUT_DIR/"
        return 0
    else
        echo -e "${RED}[ERROR]${NC} Error compilando $basename"
        return 1
    fi
}

# Función para compilar todas las clases
compile_all() {
    echo -e "${BLUE}[INFO]${NC} Compilando todas las presentaciones..."
    
    local success=0
    local total=0
    
    for file in "$CLASES_DIR"/*.typ; do
        if [ -f "$file" ]; then
            total=$((total + 1))
            if compile_class "$file"; then
                success=$((success + 1))
            fi
        fi
    done
    
    echo ""
    echo -e "${BLUE}[RESUMEN]${NC} $success/$total clases compiladas exitosamente"
    
    if [ $success -eq $total ]; then
        echo -e "${GREEN}[OK]${NC} Todas las compilaciones exitosas"
        return 0
    else
        echo -e "${YELLOW}[WARN]${NC} Algunas compilaciones fallaron"
        return 1
    fi
}

# Función para desplegar PDFs
deploy() {
    echo -e "${BLUE}[INFO]${NC} Los PDFs ya están en $OUTPUT_DIR/"
    
    # Contar PDFs existentes
    local count=0
    for pdf in "$OUTPUT_DIR"/*.pdf; do
        if [ -f "$pdf" ]; then
            count=$((count + 1))
        fi
    done
    
    echo -e "${GREEN}[OK]${NC} $count PDFs disponibles en $OUTPUT_DIR/"
}

# Función para modo watch (desarrollo)
watch_mode() {
    echo -e "${BLUE}[INFO]${NC} Iniciando modo desarrollo..."
    echo ""
    
    # Solicitar archivo específico a observar
    echo -e "${YELLOW}[INPUT]${NC} ¿Qué archivo deseas observar?"
    echo "Archivos disponibles en $CLASES_DIR:"
    ls -1 "$CLASES_DIR"/*.typ 2>/dev/null | sed 's|.*/||' || echo "No se encontraron archivos .typ"
    echo ""
    echo -n "Ingresa el nombre del archivo (con extensión): "
    read -r target_file
    
    # Validar que el archivo existe
    if [ ! -f "$CLASES_DIR/$target_file" ]; then
        echo -e "${RED}[ERROR]${NC} Archivo '$target_file' no encontrado en $CLASES_DIR"
        return 1
    fi
    
    echo -e "${BLUE}[INFO]${NC} Observando archivo: $target_file"
    echo -e "${YELLOW}[INFO]${NC} Presiona Ctrl+C para salir"
    echo ""
    
    # Compilación inicial del archivo específico
    compile_class "$CLASES_DIR/$target_file"
    
    # Verificar si inotifywait está disponible
    if ! command -v inotifywait &> /dev/null; then
        echo -e "${YELLOW}[WARN]${NC} Modo watch limitado - inotify-tools no disponible"
        echo -e "${BLUE}[INFO]${NC} Usa: sudo apt install inotify-tools"
        return 1
    fi
    
    # Monitorear cambios usando polling (más compatible con WSL)
    echo -e "${BLUE}[INFO]${NC} Monitoreando cambios en:"
    echo "  - $CLASES_DIR/$target_file"
    echo "  - $LIB_DIR/ (dependencias)"
    echo ""
    echo -e "${YELLOW}[INFO]${NC} Usando modo polling para compatibilidad con WSL"
    echo -e "${BLUE}[WAITING]${NC} Esperando cambios... (Ctrl+C para salir)"
    echo ""
    
    # Obtener timestamp inicial del archivo
    local last_modified=$(stat -c %Y "$CLASES_DIR/$target_file" 2>/dev/null || echo "0")
    local lib_modified=""
    if [ -d "$LIB_DIR" ]; then
        lib_modified=$(find "$LIB_DIR" -type f -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1)
    fi
    
    while true; do
        sleep 0.1  # Chequear cada 100ms
        
        # Verificar archivo principal
        local current_modified=$(stat -c %Y "$CLASES_DIR/$target_file" 2>/dev/null || echo "0")
        
        # Verificar archivos en lib
        local current_lib_modified=""
        if [ -d "$LIB_DIR" ]; then
            current_lib_modified=$(find "$LIB_DIR" -type f -exec stat -c %Y {} \; 2>/dev/null | sort -n | tail -1)
        fi
        
        # Si el archivo principal cambió
        if [ "$current_modified" != "$last_modified" ]; then
            echo -e "${YELLOW}[CHANGE]${NC} Detectado cambio en: $target_file"
            echo -e "${BLUE}[INFO]${NC} Recompilando..."
            compile_class "$CLASES_DIR/$target_file"
            echo ""
            last_modified="$current_modified"
        # Si algún archivo en lib cambió  
        elif [ "$current_lib_modified" != "$lib_modified" ] && [ -n "$current_lib_modified" ]; then
            echo -e "${YELLOW}[CHANGE]${NC} Detectado cambio en dependencias ($LIB_DIR)"
            echo -e "${BLUE}[INFO]${NC} Recompilando $target_file..."
            compile_class "$CLASES_DIR/$target_file"
            echo ""
            lib_modified="$current_lib_modified"
        fi
    done
}

# Función para servidor HTTP con auto-refresh
serve_mode() {
    local PORT=8080
    echo -e "${BLUE}[INFO]${NC} Iniciando servidor HTTP con auto-refresh..."
    echo ""
    
    # Verificar que hay PDFs para servir
    if [ ! -d "$OUTPUT_DIR" ] || [ -z "$(ls -A "$OUTPUT_DIR"/*.pdf 2>/dev/null)" ]; then
        echo -e "${YELLOW}[WARN]${NC} No hay PDFs en $OUTPUT_DIR. Compilando primero..."
        compile_all
    fi
    
    # Buscar puerto disponible
    while netstat -ln 2>/dev/null | grep -q ":$PORT " || nc -z localhost $PORT 2>/dev/null; do
        PORT=$((PORT + 1))
    done
    
    echo -e "${GREEN}[INFO]${NC} Servidor iniciado en: http://localhost:$PORT"
    echo -e "${BLUE}[INFO]${NC} Archivos disponibles:"
    for pdf in "$OUTPUT_DIR"/*.pdf; do
        if [ -f "$pdf" ]; then
            local basename=$(basename "$pdf")
            echo "  - http://localhost:$PORT/${basename%.pdf}.html (con auto-refresh)"
        fi
    done
    echo ""
    echo -e "${YELLOW}[INFO]${NC} Presiona Ctrl+C para detener el servidor"
    echo ""
    
    # Crear HTML wrapper con auto-refresh para cada PDF
    for pdf in "$OUTPUT_DIR"/*.pdf; do
        if [ -f "$pdf" ]; then
            local pdf_name=$(basename "$pdf")
            local html_name="${pdf_name%.pdf}.html"
            
            cat > "$OUTPUT_DIR/$html_name" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>$pdf_name - Auto Refresh</title>
    <style>
        body { margin: 0; padding: 0; background: #333; }
        iframe { width: 100vw; height: 100vh; border: none; }
        .info { position: fixed; top: 10px; right: 10px; background: rgba(0,0,0,0.7); 
                color: white; padding: 5px 10px; border-radius: 3px; font-family: monospace; }
    </style>
</head>
<body>
    <div class="info" id="status">Auto-refresh: ON</div>
    <iframe src="$pdf_name" id="pdfFrame"></iframe>
    <script>
        let lastModified = 0;
        let isRefreshing = false;
        
        function updateStatus(msg) {
            document.getElementById('status').textContent = msg;
        }
        
        function checkForUpdates() {
            if (isRefreshing) return; // Evitar múltiples recargas
            
            fetch('$pdf_name', {method: 'HEAD'})
                .then(response => {
                    const modified = response.headers.get('Last-Modified');
                    const modifiedTime = new Date(modified).getTime();
                    
                    if (lastModified === 0) {
                        lastModified = modifiedTime;
                        updateStatus('Auto-refresh: Ready');
                    } else if (modifiedTime > lastModified) {
                        isRefreshing = true;
                        updateStatus('Updating PDF...');
                        console.log('PDF updated, refreshing...');
                        
                        // Precargar el nuevo PDF antes de cambiarlo
                        const newSrc = '$pdf_name?' + Date.now();
                        const tempFrame = document.createElement('iframe');
                        tempFrame.style.display = 'none';
                        tempFrame.src = newSrc;
                        document.body.appendChild(tempFrame);
                        
                        // Esperar un momento para cargar y luego cambiar
                        setTimeout(() => {
                            const mainFrame = document.getElementById('pdfFrame');
                            mainFrame.src = newSrc;
                            document.body.removeChild(tempFrame);
                            
                            // Confirmar que se cargó
                            mainFrame.onload = () => {
                                updateStatus('PDF Updated ✓');
                                isRefreshing = false;
                                setTimeout(() => updateStatus('Auto-refresh: ON'), 2000);
                            };
                            
                            // Timeout por si no carga
                            setTimeout(() => {
                                if (isRefreshing) {
                                    updateStatus('Auto-refresh: ON');
                                    isRefreshing = false;
                                }
                            }, 3000);
                        }, 200);
                        
                        lastModified = modifiedTime;
                    }
                })
                .catch(e => {
                    console.log('Check failed:', e);
                    if (!isRefreshing) updateStatus('Auto-refresh: Error');
                });
        }
        
        // Verificar cada 200ms - más rápido
        setInterval(checkForUpdates, 200);
        checkForUpdates();
    </script>
</body>
</html>
EOF
        fi
    done
    
    # Verificar si Python está disponible
    if command -v python3 &> /dev/null; then
        echo -e "${BLUE}[INFO]${NC} Usando servidor HTTP de Python..."
        cd "$OUTPUT_DIR"
        python3 -m http.server $PORT 2>/dev/null
    elif command -v python &> /dev/null; then
        echo -e "${BLUE}[INFO]${NC} Usando servidor HTTP de Python 2..."
        cd "$OUTPUT_DIR"
        python -m SimpleHTTPServer $PORT 2>/dev/null
    else
        echo -e "${RED}[ERROR]${NC} Python no está disponible para el servidor HTTP"
        echo "Instala Python o usa: sudo apt install python3"
        return 1
    fi
}

# Función para verificar permisos de escritura
check_write_permissions() {
    if [ ! -w "." ]; then
        echo -e "${RED}[ERROR]${NC} Sin permisos de escritura en el directorio actual"
        echo "Ejecuta con permisos adecuados o cambia al propietario"
        return 1
    fi
    
    if [ ! -w "$FONTS_DIR" ] && [ -d "$FONTS_DIR" ]; then
        echo -e "${RED}[ERROR]${NC} Sin permisos de escritura en $FONTS_DIR"
        echo "Ejecuta: chmod 755 $FONTS_DIR"
        return 1
    fi
    
    return 0
}

# Función para verificar si las fuentes están instaladas
check_fonts() {
    echo -e "${BLUE}[INFO]${NC} Verificando fuentes..."
    
    # Verificar fuentes en directorio local
    if [ -f "$FONTS_DIR/Roboto-Regular.ttf" ] && [ -f "$FONTS_DIR/FiraCode-Regular.ttf" ]; then
        echo -e "${GREEN}[OK]${NC} Fuentes encontradas en $FONTS_DIR"
        return 0
    fi
    
    # Verificar fuentes del sistema
    if command -v fc-list &> /dev/null; then
        if fc-list | grep -qi "roboto" && fc-list | grep -qi "fira"; then
            echo -e "${GREEN}[OK]${NC} Fuentes encontradas en el sistema"
            return 0
        fi
    fi
    
    echo -e "${YELLOW}[WARN]${NC} Fuentes no encontradas. Usa './build.sh install-deps' para instalarlas"
    return 1
}

# Función para descargar un archivo con reintentos
download_file() {
    local url="$1"
    local output="$2"
    local retries=3
    
    for i in $(seq 1 $retries); do
        echo -e "${BLUE}[INFO]${NC} Descargando $(basename "$output") (intento $i/$retries)..."
        
        if command -v wget &> /dev/null; then
            if wget -q --timeout=30 -O "$output" "$url"; then
                return 0
            fi
        elif command -v curl &> /dev/null; then
            if curl -L --max-time 30 -s -o "$output" "$url"; then
                return 0
            fi
        else
            echo -e "${RED}[ERROR]${NC} wget o curl no están disponibles"
            return 1
        fi
        
        sleep 2
    done
    
    echo -e "${RED}[ERROR]${NC} Falló la descarga de $(basename "$output")"
    return 1
}

# Función para instalar dependencias (fuentes)
install_deps() {
    echo -e "${BLUE}[INFO]${NC} Instalando dependencias..."
    
    # Verificar permisos
    if ! check_write_permissions; then
        return 1
    fi
    
    # Crear directorio de fuentes
    mkdir -p "$FONTS_DIR"
    
    local temp_dir=$(mktemp -d)
    local fonts_installed=0
    
    # Descargar e instalar Roboto
    echo -e "${BLUE}[INFO]${NC} Instalando fuente Roboto..."
    if download_file "https://github.com/googlefonts/roboto/releases/download/v2.138/roboto-unhinted.zip" "$temp_dir/roboto.zip"; then
        if command -v unzip &> /dev/null; then
            if unzip -q "$temp_dir/roboto.zip" -d "$temp_dir/roboto" 2>/dev/null; then
                find "$temp_dir/roboto" -name "Roboto-*.ttf" -exec cp {} "$FONTS_DIR/" \; 2>/dev/null || true
                fonts_installed=$((fonts_installed + 1))
                echo -e "${GREEN}[OK]${NC} Roboto instalado"
            else
                echo -e "${YELLOW}[WARN]${NC} Error extrayendo Roboto"
            fi
        else
            echo -e "${YELLOW}[WARN]${NC} unzip no disponible, descargando archivos individuales..."
            # Fallback: descargar archivos individuales
            download_file "https://github.com/googlefonts/roboto/raw/main/src/hinted/Roboto-Regular.ttf" "$FONTS_DIR/Roboto-Regular.ttf" && fonts_installed=$((fonts_installed + 1))
        fi
    fi
    
    # Descargar e instalar Fira Code
    echo -e "${BLUE}[INFO]${NC} Instalando fuente Fira Code..."
    if download_file "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip" "$temp_dir/firacode.zip"; then
        if command -v unzip &> /dev/null; then
            if unzip -q "$temp_dir/firacode.zip" -d "$temp_dir/firacode" 2>/dev/null; then
                find "$temp_dir/firacode" -name "FiraCode-*.ttf" -exec cp {} "$FONTS_DIR/" \; 2>/dev/null || true
                fonts_installed=$((fonts_installed + 1))
                echo -e "${GREEN}[OK]${NC} Fira Code instalado"
            else
                echo -e "${YELLOW}[WARN]${NC} Error extrayendo Fira Code"
            fi
        else
            # Fallback: descargar archivo individual
            download_file "https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf" "$FONTS_DIR/FiraCode-Regular.ttf" && fonts_installed=$((fonts_installed + 1))
        fi
    fi
    
    # Descargar Arial (desde fuente alternativa libre)
    echo -e "${BLUE}[INFO]${NC} Instalando fuente Arial compatible..."
    # Probar descarga directa de archivos individuales
    local arial_urls=(
        "https://github.com/liberationfonts/liberation-fonts/raw/master/liberation-fonts-ttf-2.1.5/LiberationSans-Regular.ttf"
        "https://github.com/liberationfonts/liberation-fonts/raw/master/liberation-fonts-ttf-2.1.5/LiberationSans-Bold.ttf"
    )
    
    local arial_installed=false
    for url in "${arial_urls[@]}"; do
        local filename=$(basename "$url")
        if download_file "$url" "$FONTS_DIR/$filename"; then
            arial_installed=true
        fi
    done
    
    if [ "$arial_installed" = true ]; then
        fonts_installed=$((fonts_installed + 1))
        echo -e "${GREEN}[OK]${NC} Arial compatible (Liberation Sans) instalado"
    else
        echo -e "${YELLOW}[WARN]${NC} No se pudo instalar Arial compatible"
    fi
    
    # Limpiar archivos temporales
    rm -rf "$temp_dir" 2>/dev/null || true
    
    # Actualizar cache de fuentes si es posible
    if command -v fc-cache &> /dev/null; then
        echo -e "${BLUE}[INFO]${NC} Actualizando cache de fuentes..."
        fc-cache -f "$FONTS_DIR" 2>/dev/null || true
    fi
    
    echo -e "${GREEN}[OK]${NC} Instalación completada. $fonts_installed fuentes instaladas en $FONTS_DIR"
    
    if [ $fonts_installed -eq 0 ]; then
        echo -e "${YELLOW}[WARN]${NC} No se pudieron instalar fuentes. El proyecto funcionará con fuentes del sistema."
        return 1
    fi
    
    return 0
}

# Función principal
main() {
    case "${1:-help}" in
        "compile")
            check_dependencies
            check_fonts || true  # No fallar si las fuentes no están
            compile_all
            ;;
        "watch")
            check_dependencies "watch"
            check_fonts || true
            watch_mode
            ;;
        "serve")
            check_dependencies
            check_fonts || true
            serve_mode
            ;;
        "clean")
            clean
            ;;
        "deploy")
            check_dependencies
            check_fonts || true
            deploy
            ;;
        "install-deps")
            install_deps
            ;;
        "all")
            check_dependencies
            check_fonts || true
            clean
            compile_all && deploy
            echo -e "${GREEN}[COMPLETE]${NC} Construcción completa finalizada"
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            echo -e "${RED}[ERROR]${NC} Opción desconocida: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"