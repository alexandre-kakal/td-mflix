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

### 14. Nombre de documents associés à chaque genre, triés par ordre décroissant

**Commande :**

```bash
db.movies.aggregate([
  { $unwind: "$genres" },
  { $group: { _id: "$genres", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
])
```

**Exemple de sortie :**

```json
[
  { "_id": "Drama", "count": 13789 },
  { "_id": "Comedy", "count": 7024 },
  { "_id": "Romance", "count": 3665 },
  { "_id": "Crime", "count": 2678 },
  { "_id": "Thriller", "count": 2658 },
  { "_id": "Action", "count": 2539 },
  { "_id": "Documentary", "count": 2129 },
  { "_id": "Adventure", "count": 2045 },
  ...
]
```

---

### 15. Statistiques globales sur la collection movies

**Commande :**

```bash
db.movies.aggregate([
  {
    $group: {
      _id: null,
      count: { $sum: 1 },
      totalAwards: { $sum: "$awards.wins" },
      averageNominations: { $avg: "$awards.nominations" },
      averageAwards: { $avg: "$awards.wins" }
    }
  },
  {
    $project: { _id: 0, count: 1, totalAwards: 1, averageNominations: 1, averageAwards: 1 }
  }
])
```

**Exemple de sortie :**

```json
[
  {
    "count": 23539,
    "totalAwards": 96770,
    "averageNominations": 4.776031267258592,
    "averageAwards": 4.111049747228004
  }
]
```

---

### 16. Afficher le nombre d'acteurs au casting pour chaque document

**Commande :**

```bash
db.movies.aggregate([
  {
    $project: {
      title: 1,
      castTotal: { $size: "$cast" }
    }
  }
])
```

**Exemple de sortie (premiers documents) :**

```json
[
  {
    "_id": ObjectId("573a1390f29313caabcd446f"),
    "title": "A Corner in Wheat",
    "castTotal": 4
  },
  {
    "_id": ObjectId("573a1390f29313caabcd42e8"),
    "title": "The Great Train Robbery",
    "castTotal": 4
  },
  {
    "_id": ObjectId("573a1390f29313caabcd548c"),
    "title": "The Birth of a Nation",
    "castTotal": 4
  },
  ...
]
```

---

### 17. Films sortis entre 2000 et 2010 avec une note IMDB supérieure à 8 et plus de 10 récompenses

**Commande :**

```bash
db.movies.find({
  year: { $gte: 2000, $lte: 2010 },
  "imdb.rating": { $gt: 8 },
  "awards.wins": { $gt: 10 }
})
```

**Exemple de sortie (premier film correspondant) :**

```json
[
  {
    "_id": ObjectId("573a139af29313caabcf0782"),
    "fullplot": "Set in Hong Kong, 1962, Chow Mo-Wan is a newspaper editor who moves into a new building with his wife. At the same time, Su Li-zhen, a beautiful secretary and her executive husband also move in to the crowded building. With their spouses often away, Chow and Li-zhen spend most of their time together as friends. They have everything in common from noodle shops to martial arts. Soon, they are shocked to discover that their spouses are having an affair. Hurt and angry, they find comfort in their growing friendship even as they resolve not to be like their unfaithful mates.",
    "imdb": { "rating": 8.1, "votes": 67663, "id": 118694 },
    "year": 2000,
    "plot": "Two neighbors, a woman and a man, form a strong bond after both suspect extramarital activities of their spouses. However, they agree to keep their bond platonic so as not to commit similar wrongs.",
    "genres": [ "Drama", "Romance" ],
    "rated": "PG",
    "metacritic": 85,
    "title": "In the Mood for Love",
    "lastupdated": "2015-09-15 05:14:09.273000000",
    "languages": [ "Cantonese", "Shanghainese", "French" ],
    "writers": [ "Kar Wai Wong" ],
    "type": "movie",
    "tomatoes": { ... },
    "poster": "https://m.media-amazon.com/images/...",
    "num_mflix_comments": 1,
    "released": ISODate("2001-03-09T00:00:00.000Z"),
    "awards": {
      "wins": 49,
      "nominations": 33,
      "text": "Nominated for 1 BAFTA Film Award. Another 48 wins & 33 nominations."
    },
    "countries": [ "Hong Kong", "China" ],
    "cast": [
      "Maggie Cheung",
      "Tony Chiu Wai Leung",
      "Ping Lam Siu",
      "Tung Cho 'Joe' Cheung"
    ],
    "directors": [ "Kar Wai Wong" ],
    "runtime": 98
  },
  ...
]
```

---

### 18. Nouvelle question proposée : Pour chaque genre, quel est le film le mieux noté ?

**Commande :**

```bash
db.movies.aggregate([
  { $unwind: "$genres" },
  { $sort: { "imdb.rating": -1 } },
  { $group: {
      _id: "$genres",
      bestMovie: { $first: "$title" },
      rating: { $first: "$imdb.rating" }
  }},
  { $project: { _id: 0, genre: "$_id", bestMovie: 1, rating: 1 } }
])
```

**Exemple de sortie :**

```json
[
  { "bestMovie": "Prerokbe Ognja", "rating": 9, "genre": "Music" },
  { "bestMovie": "Most Likely to Succeed", "rating": 8.9, "genre": "News" },
  { "bestMovie": "The Late Shift", "rating": 7, "genre": "Talk-Show" },
  ...
]
```
