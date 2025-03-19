Alexandre KAKAL

## TD Mflix - Étape 1

### 1. Connexion et sélection de la base de données

**Commande :**

```bash
mongosh -u admin -p secret --authenticationDatabase admin mongodb://localhost:27018
```

**Sortie attendue :**

```
switched to db mflix;
```

Puis, dans le shell interactif :

```bash
use mflix
```

---

### 2. Obtenir le nombre total de documents dans la collection **movies**

**Commande :**

```bash
db.movies.countDocuments({})
```

**Sortie :**

```
23539
```

---

### 3. Afficher le titre des 10 premiers documents

**Commande :**

```bash
db.movies.find({}, { title: 1, _id: 0 }).limit(10)
```

**Sortie :**

```json
[
  { "title": "A Corner in Wheat" },
  { "title": "The Great Train Robbery" },
  { "title": "The Birth of a Nation" },
  { "title": "The Cheat" },
  { "title": "In the Land of the Head Hunters" },
  { "title": "The Italian" },
  { "title": "Traffic in Souls" },
  { "title": "Regeneration" },
  { "title": "Les vampires" },
  { "title": "Civilization" }
]
```

---

### 4. Obtenir les différents types de contenu présents

**Commande :**

```bash
db.movies.distinct("type")
```

**Sortie :**

```
[ "movie", "series" ]
```

---

### 5. Nombre de documents par type de contenu

**Commande :**

```bash
db.movies.aggregate([
  { $group: { _id: "$type", count: { $sum: 1 } } }
])
```

**Sortie :**

```json
[
  { "_id": "series", "count": 254 },
  { "_id": "movie", "count": 23285 }
]
```

---

### 6. Films sortis depuis 2015, triés par ordre décroissant

**Commande :**

```bash
db.movies.find({ year: { $gte: 2015 } }).sort({ year: -1 })
```

**Exemple de sortie (premier document) :**

```json
{
  "_id": ObjectId("573a13e6f29313caabdc6a9a"),
  "title": "The Masked Saint",
  "year": 2016,
  "plot": "The journey of a professional wrestler who becomes a small town pastor...",
  ...
}
```

---

### 7. Nombre de films sortis depuis 2015 avec au moins 5 récompenses

**Commande :**

```bash
db.movies.countDocuments({ year: { $gte: 2015 }, "awards.wins": { $gte: 5 } })
```

**Sortie :**

```
34
```

---

### 8. Nombre de films sortis depuis 2015 disponibles en français

**Commande :**

```bash
db.movies.countDocuments({ year: { $gte: 2015 }, languages: "French" })
```

**Sortie :**

```
41
```

---

### 9. Nombre de films dont les genres incluent à la fois Thriller et Drama

**Commande :**

```bash
db.movies.countDocuments({ genres: { $all: ["Thriller", "Drama"] } })
```

**Sortie :**

```
1245
```

---

### 10. Afficher le titre et les genres des films dont le genre est Crime ou Thriller

**Commande :**

```bash
db.movies.find({ genres: { $in: ["Crime", "Thriller"] } }, { title: 1, genres: 1, _id: 0 })
```

**Exemple de sortie :**

```json
[
  { "title": "Traffic in Souls", "genres": [ "Crime", "Drama" ] },
  { "title": "Regeneration", "genres": [ "Biography", "Crime", "Drama" ] },
  { "title": "Les vampires", "genres": [ "Action", "Adventure", "Crime" ] },
  ...
]
```

---

### 11. Afficher le titre et les langues des films disponibles en français et en italien

**Commande :**

```bash
db.movies.find({ languages: { $all: ["French", "Italian"] } }, { title: 1, languages: 1, _id: 0 })
```

**Exemple de sortie :**

```json
[
  {
    "title": "Morocco",
    "languages": [ "English", "French", "Spanish", "Arabic", "Italian" ]
  },
  {
    "title": "The Gay Divorcee",
    "languages": [ "English", "French", "Italian" ]
  },
  {
    "title": "Toni",
    "languages": [ "French", "Italian", "Spanish" ]
  },
  ...
]
```

---

### 12. Afficher le titre et le genre des films dont la note d'IMDB est supérieure à 9

**Commande :**

```bash
db.movies.find({ "imdb.rating": { $gt: 9 } }, { title: 1, genres: 1, _id: 0 })
```

**Exemple de sortie :**

```json
[
  { "title": "The Godfather", "genres": [ "Crime", "Drama" ] },
  { "title": "The Godfather: Part II", "genres": [ "Crime", "Drama" ] },
  { "title": "The Shawshank Redemption", "genres": [ "Crime", "Drama" ] },
  ...
]
```

---

### 13. Nombre de contenus avec exactement 4 acteurs dans le casting

**Commande :**

```bash
db.movies.countDocuments({ cast: { $size: 4 } })
```

**Sortie :**

```
22389
```
