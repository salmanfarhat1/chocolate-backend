package api

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
	"github.com/salmanfarhat1/chocolate-backend/db"
)

func GetVariantsByChocolateIDHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		// 🔥 Extract {id} from URL
		vars := mux.Vars(r)
		idStr := vars["id"]

		// 🔁 Convert to int
		chocolateID, err := strconv.Atoi(idStr)
		if err != nil {
			http.Error(w, "Invalid chocolate ID", http.StatusBadRequest)
			return
		}

		// ✅ Call the DB function and pass the ID
		variants, err := db.GetVariantsByChocolateID(dbConn, chocolateID)
		if err != nil {
			http.Error(w, "Error fetching variants", http.StatusInternalServerError)
			return
		}

		json.NewEncoder(w).Encode(variants)
	}
}
