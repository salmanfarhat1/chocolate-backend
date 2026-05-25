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

func GetVariantsHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		variants, err := db.GetVariants(dbConn)

		if err != nil {
			http.Error(w, "error in retreiving data of the all variants", http.StatusInternalServerError)
			return
		}
		json.NewEncoder(w).Encode(variants)
	}
}

func CreateVariantHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")

		var variant models.Variants
		if err := json.NewDecoder(r.Body).Decode(&variant); err != nil {
			http.Error(w, "Invalid request payload", http.StatusBadRequest)
			return
		}

		err := db.InsertVariant(dbConn, &variant)
		if err != nil {
			http.Error(w, "Failed to insert variant", http.StatusInternalServerError)
			return
		}

		json.NewEncoder(w).Encode(map[string]interface{}{
			"success": true,
			"data":    variant,
		})
	}
}

func UpdateVariantHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["id"])
		if err != nil {
			http.Error(w, "invalid id", http.StatusBadRequest)
			return
		}

		var variant models.Variants
		if err := json.NewDecoder(r.Body).Decode(&variant); err != nil {
			http.Error(w, "invalid body", http.StatusBadRequest)
			return
		}

		if err := db.UpdateVariant(dbConn, id, &variant); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(variant)
	}
}

func DeleteVariantHandler(dbConn *sql.DB) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		id, err := strconv.Atoi(vars["id"])
		if err != nil {
			http.Error(w, "invalid id", http.StatusBadRequest)
			return
		}

		_, err = dbConn.Exec("DELETE FROM chocolate_variants WHERE id = $1", id)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.WriteHeader(http.StatusNoContent)
	}
}
