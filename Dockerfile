# Questo è il file che definisce l'ambiente standard e riproducibile dell'applicazione.

# Stage 1: Build/Costruttore - Prepara i file del sito
# Uso un'immagine molto leggera solo per eseguire uno script
FROM busybox:latest AS builder
WORKDIR /app
COPY . .
# Rendi eseguibile lo script e lancialo per generare gallery.json
# Dò i permessi di exec al file .sh della gallery e lo eseguo.
# Così la lista delle immagini del carosello sono sempre aggiornate 
# Quando faccio un nuovo commit.
RUN chmod +x generate_gallery.sh && ./generate_gallery.sh

# Stage 2: Production - Servi i file con Nginx
# Uso l'immagine ufficiale di Nginx per un web server veloce e leggero.
FROM nginx:1.25-alpine
# Copia solo i file necessari per il sito dallo stage precedente,
# in modo da mantenere l'immagine finale piccola e pulita.
COPY --from=builder /app/ /usr/share/nginx/html
# Rimuovi i file non necessari per la produzione
RUN rm /usr/share/nginx/html/Dockerfile \
       /usr/share/nginx/html/generate_gallery.sh \
       /usr/share/nginx/html/.gitignore \
       /usr/share/nginx/html/.github/workflows/deploy.yml
# Dico a Docker che il container andrà ad esporre la porta 80
EXPOSE 80
# Comando che viene eseguito quando parte il container
CMD ["nginx", "-g", "daemon off;"]