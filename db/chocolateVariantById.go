package db

import (
	"database/sql"
	"log"

	"github.com/salmanfarhat1/chocolate_website/tree/main/backend/models"
)

func GetVariantsByChocolateID(db *sql.DB, chocolateID int) ([]models.Variants, error) {
	rows, err := db.Query(`
		SELECT id, chocolate_id, size, weight, price
		FROM chocolate_variants
		WHERE chocolate_id = $1
	`, chocolateID)
	if err != nil {
		log.Println("❌ Query failed:", err)
		return nil, err
	}
	defer rows.Close()

	var variants []models.Variants
	for rows.Next() {
		var v models.Variants
		if err := rows.Scan(
			&v.ID,
			&v.ChocolateID,
			&v.Size,
			&v.Weight,
			&v.Price,
		); err != nil {
			log.Println("❌ Scan error:", err)
			return nil, err
		}
		variants = append(variants, v)
	}

	return variants, nil
}

func InsertVariant(db *sql.DB, variant *models.Variants) error {
	query := `
		INSERT INTO chocolate_variants (chocolate_id, size, weight, price)
		VALUES ($1, $2, $3, $4)
		RETURNING id
	`

	return db.QueryRow(query,
		variant.ChocolateID,
		variant.Size,
		variant.Weight,
		variant.Price,
	).Scan(&variant.ID)
}
