package api

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/salmanfarhat1/chocolate_website/tree/main/backend/db"
	"github.com/salmanfarhat1/chocolate_website/tree/main/backend/models"
)

func CreateChocolateHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		var choc models.Chocolate
		if err := json.NewDecoder(r.Body).Decode(&choc); err != nil {
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			fmt.Println("❌ JSON decode error:", err)
			return
		}

		err := db.InsertChocolate(dbConn, &choc)
		if err != nil {
			http.Error(w, "Failed to insert chocolate", http.StatusInternalServerError)
			fmt.Println("❌ DB insert error:", err)
			return
		}

		fmt.Println("✅ Inserted chocolate:", choc)

		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": true,
			"data":    choc,
		})
	}
}
