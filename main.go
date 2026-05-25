package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/salmanfarhat1/chocolate-backend/api"
	"github.com/salmanfarhat1/chocolate-backend/db"
)

func main() {
	dbConn := db.InitDB()
	defer dbConn.Close()

	r := mux.NewRouter()

	// Routes
	r.HandleFunc("/", api.HelloHandler).Methods("GET")

	r.HandleFunc("/chocolates", api.GetChocolatesHandler(dbConn)).Methods("GET")
	r.HandleFunc("/chocolates", api.CreateChocolateHandler(dbConn)).Methods("POST")
	r.HandleFunc("/chocolates/{id}", api.UpdateChocolateHandler(dbConn)).Methods("PUT")
	r.HandleFunc("/chocolates/{id}", api.DeleteChocolateHandler(dbConn)).Methods("DELETE")

	r.HandleFunc("/variants", api.GetVariantsHandler(dbConn)).Methods("GET")
	r.HandleFunc("/variants", api.CreateVariantHandler(dbConn)).Methods("POST")
	r.HandleFunc("/variants/{id}", api.UpdateVariantHandler(dbConn)).Methods("PUT")
	r.HandleFunc("/variants/{id}", api.DeleteVariantHandler(dbConn)).Methods("DELETE")
	r.HandleFunc("/chocolates/{id}/variants", api.GetVariantsByChocolateIDHandler(dbConn)).Methods("GET")

	r.HandleFunc("/photos/upload", api.UploadPhotoHandler).Methods("POST", "OPTIONS")
	r.PathPrefix("/photos/").Handler(http.StripPrefix("/photos/", http.FileServer(http.Dir("./photos"))))
	r.PathPrefix("/admin/").Handler(http.StripPrefix("/admin/", http.FileServer(http.Dir("./admin"))))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	fmt.Println("Server running on :" + port)

	log.Fatal(http.ListenAndServe(":"+port, r))
}
