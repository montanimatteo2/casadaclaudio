# --- FASE 1: Builder ---
# Usiamo un'immagine leggera per preparare i file.
FROM busybox:latest AS builder

# Creiamo la cartella di lavoro
WORKDIR /app

# Copiamo SOLO i file e le cartelle che servono al sito per funzionare
COPY index.html .
COPY generate_gallery.sh .
COPY css/ ./css/
COPY js/ ./js/
COPY img/ ./img/
COPY lang/ ./lang/

# Eseguiamo lo script per generare la lista delle immagini
RUN chmod +x generate_gallery.sh && ./generate_gallery.sh

# --- FASE 2: Produzione ---
# Partiamo da un'immagine Nginx superleggera
FROM nginx:1.25-alpine

# Copiamo SOLO il risultato pulito dalla fase precedente.
# In questo modo, file come Dockerfile, .git, .github non vengono mai inclusi.
COPY --from=builder /app/ /usr/share/nginx/html

# Diciamo a Docker di esporre la porta 80
EXPOSE 80

# Comando per avviare il server Nginx
CMD ["nginx", "-g", "daemon off;"]