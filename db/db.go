package db

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
)

func InitDB() *sql.DB {
	err := godotenv.Load()
	if err != nil {
		log.Println("No .env file found")
	}
	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", // Force disable
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
		// Removed DB_SSLMODE from here
	)

	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal("Connection failed:", err)
	}

	// Set connection pool settings
	db.SetMaxOpenConns(25)
	db.SetMaxIdleConns(25)
	db.SetConnMaxLifetime(5 * time.Minute)

	err = db.Ping()
	if err != nil {
		log.Fatal("Ping failed:", err)
	}

	log.Println("✅ Connected to the database")
	return db
}
