package db

import (
	"database/sql"
	"log"

	"github.com/lib/pq"
	"github.com/salmanfarhat1/chocolate-backend/models"
)

func GetChocolates(db *sql.DB) ([]models.Chocolate, error) {
	rows, err := db.Query("SELECT id, name, ingredients, photo_urls FROM chocolates")
	if err != nil {
		log.Println("❌ Query failed:", err)
		return nil, err
	}
	defer rows.Close()

	var chocolates []models.Chocolate

	for rows.Next() {
		var choco models.Chocolate
		if err := rows.Scan(
			&choco.ID,
			&choco.Name,
			&choco.Ingredients,
			pq.Array(&choco.PhotoUrls), // ✅ Handle text[] properly
		); err != nil {
			log.Println("❌ Scan failed:", err)
			return nil, err
		}
		chocolates = append(chocolates, choco)
	}
	return chocolates, nil
}

func UpdateChocolate(db *sql.DB, id int, choc *models.Chocolate) error {
	query := `
        UPDATE chocolates
        SET name = $1, ingredients = $2, photo_urls = $3
        WHERE id = $4
    `
	_, err := db.Exec(query,
		choc.Name,
		choc.Ingredients,
		pq.Array(choc.PhotoUrls),
		id,
	)
	return err
}

func InsertChocolate(db *sql.DB, choc *models.Chocolate) error {
	query := `INSERT INTO chocolates (name, ingredients, photo_urls) VALUES ($1, $2, $3) RETURNING id`
	return db.QueryRow(
		query,
		choc.Name,
		choc.Ingredients,
		pq.Array(choc.PhotoUrls), // ✅ Convert []string to text[]
	).Scan(&choc.ID)
}
