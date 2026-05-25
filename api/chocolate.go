package api

import (
	"encoding/json"
	"net/http"
	"strconv"

	"database/sql"

	"github.com/gorilla/mux"
	"github.com/salmanfarhat1/chocolate-backend/db"
	"github.com/salmanfarhat1/chocolate-backend/models"
)

func GetChocolatesHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		chocolates, err := db.GetChocolates(dbConn)
		if err != nil {
			http.Error(w, "Failed to fetch chocolates", http.StatusInternalServerError)
			return
		}

		json.NewEncoder(w).Encode(chocolates)
	}
}

func UpdateChocolateHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["id"])
		if err != nil {
			http.Error(w, "invalid id", http.StatusBadRequest)
			return
		}

		var choc models.Chocolate
		if err := json.NewDecoder(r.Body).Decode(&choc); err != nil {
			http.Error(w, "invalid body", http.StatusBadRequest)
			return
		}

		if err := db.UpdateChocolate(dbConn, id, &choc); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(choc)
	}
}
func DeleteChocolateHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["id"])
		if err != nil {
			http.Error(w, "invalid id", http.StatusBadRequest)
			return
		}

		_, err = dbConn.Exec("DELETE FROM chocolates WHERE id = $1", id)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusNoContent)
	}
}
