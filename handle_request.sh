#!/bin/bash
OUTPUT_DIR="output"

read request
path=$(echo "$request" | cut -d' ' -f2 | cut -d'?' -f1)

if [ "$path" = "/" ]; then
    # Página de índice
    echo "HTTP/1.1 200 OK"
    echo "Content-Type: text/html"
    echo ""
    echo "<html><head><title>PDFs Disponibles</title></head><body>"
    echo "<h1>PDFs Disponibles</h1><ul>"
    for pdf in $OUTPUT_DIR/*.pdf; do
        if [ -f "$pdf" ]; then
            name=$(basename "$pdf")
            echo "<li><a href=\"/${name%.pdf}.html\">$name (con auto-refresh)</a></li>"
            echo "<li><a href=\"/$name\">$name (directo)</a></li>"
        fi
    done
    echo "</ul></body></html>"
elif [ -f "$OUTPUT_DIR$path" ]; then
    # Servir archivo
    if [[ "$path" == *.pdf ]]; then
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: application/pdf"
        echo "Last-Modified: $(date -r "$OUTPUT_DIR$path" -R)"
        echo ""
        cat "$OUTPUT_DIR$path"
    elif [[ "$path" == *.html ]]; then
        echo "HTTP/1.1 200 OK"
        echo "Content-Type: text/html"
        echo ""
        cat "$OUTPUT_DIR$path"
    fi
else
    echo "HTTP/1.1 404 Not Found"
    echo "Content-Type: text/html"
    echo ""
    echo "<html><body><h1>404 Not Found</h1></body></html>"
fi
