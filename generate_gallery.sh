#!/bin/sh
# Questo script genera il file gallery.json basandosi sulle immagini in img/gallery/

GALLERY_DIR="img/gallery"
OUTPUT_FILE="gallery.json"

# Inizia a creare il file JSON
echo '{' > $OUTPUT_FILE
echo '  "images": [' >> $OUTPUT_FILE

# Trova tutti i file di immagine e aggiungili al JSON
# `find` cerca i file, `sort` li ordina, `sed` formatta l'output
# `head -n -1` rimuove la virgola dall'ultimo elemento
find "$GALLERY_DIR" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort | sed 's/^/    "/' | sed 's/$/",/' | head -n -1 >> $OUTPUT_FILE

# Aggiunge l'ultimo elemento senza virgola
find "$GALLERY_DIR" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort | sed 's/^/    "/' | sed 's/$/"/' | tail -n 1 >> $OUTPUT_FILE

# Chiude il JSON
echo '  ]' >> $OUTPUT_FILE
echo '}' >> $OUTPUT_FILE

echo "$OUTPUT_FILE generated successfully."