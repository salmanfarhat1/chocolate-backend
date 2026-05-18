package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/salmanfarhat1/chocolate_website/tree/main/backend/api"
	"github.com/salmanfarhat1/chocolate_website/tree/main/backend/db"
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

	fmt.Println("Server on http://localhost:3000")
	http.ListenAndServe(":3000", r)
}
