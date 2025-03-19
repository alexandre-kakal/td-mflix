#!/bin/bash

echo "⏳ Attente de MongoDB pour être prêt..."

# On utilise --quiet pour récupérer uniquement la valeur de "ok"
until [ "$(mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" \
    --authenticationDatabase admin --quiet --eval 'db.runCommand({ ping: 1 }).ok')" -eq 1 ]; do
    echo "🔄 MongoDB n'est pas encore prêt... Attente de 5 secondes..."
    sleep 5
done

echo "✅ MongoDB est maintenant prêt."

# Partie 1 : Importation des books dans la base "library"
echo "📂 Création de la base de données 'library' et de la collection 'books'..."
mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" \
    --authenticationDatabase admin <<EOF
use library;
db.createCollection("books");
EOF
echo "✅ Base de données 'library' et collection 'books' créées."

if [ -f "/tmp/import/books.json" ]; then
    echo "📥 Importation des données depuis /tmp/import/books.json..."
    mongoimport --db "library" --collection "books" \
      --file /tmp/import/books.json --jsonArray \
      --username "$MONGO_INITDB_ROOT_USERNAME" --password "$MONGO_INITDB_ROOT_PASSWORD" \
      --authenticationDatabase admin
    echo "✅ Importation des books terminée."
else
    echo "⚠️ Le fichier books.json est introuvable dans /tmp/import/. Vérifiez qu'il est bien placé."
fi

# Partie 2 : Importation des movies dans la base "mflix"
echo "📂 Création de la base de données 'mflix' et de la collection 'movies'..."
mongosh -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" \
    --authenticationDatabase admin <<EOF
use mflix;
db.createCollection("movies");
EOF
echo "✅ Base de données 'mflix' et collection 'movies' créées."

if [ -f "/tmp/import/movies.json" ]; then
    echo "📥 Importation des données depuis /tmp/import/movies.json..."
    mongoimport --db "mflix" --collection "movies" \
      --file /tmp/import/movies.json --jsonArray \
      --username "$MONGO_INITDB_ROOT_USERNAME" --password "$MONGO_INITDB_ROOT_PASSWORD" \
      --authenticationDatabase admin
    echo "✅ Importation des movies terminée."
else
    echo "⚠️ Le fichier movies.json est introuvable dans /tmp/import/. Vérifiez qu'il est bien placé."
fi

echo "🚀 MongoDB est prêt avec les données importées !"
