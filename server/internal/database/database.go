package database

import (
	"database/sql"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

var DB *sql.DB

func Init(path string) {
	var err error
	DB, err = sql.Open("sqlite3", path+"?_journal_mode=WAL&_foreign_keys=on")
	if err != nil {
		log.Fatalf("Failed to open database: %v", err)
	}

	if err = DB.Ping(); err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	migrate()
	log.Println("Database initialized:", path)
}

func migrate() {
	queries := []string{
		`CREATE TABLE IF NOT EXISTS products (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			name TEXT NOT NULL,
			sku TEXT UNIQUE NOT NULL,
			price REAL NOT NULL DEFAULT 0,
			quantity INTEGER NOT NULL DEFAULT 0,
			category TEXT NOT NULL DEFAULT '',
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
			updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS sales (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			total REAL NOT NULL DEFAULT 0,
			created_at DATETIME DEFAULT CURRENT_TIMESTAMP
		)`,
		`CREATE TABLE IF NOT EXISTS sale_items (
			id INTEGER PRIMARY KEY AUTOINCREMENT,
			sale_id INTEGER NOT NULL,
			product_id INTEGER NOT NULL,
			product_name TEXT NOT NULL,
			price REAL NOT NULL,
			quantity INTEGER NOT NULL,
			subtotal REAL NOT NULL,
			FOREIGN KEY (sale_id) REFERENCES sales(id),
			FOREIGN KEY (product_id) REFERENCES products(id)
		)`,
	}

	for _, q := range queries {
		if _, err := DB.Exec(q); err != nil {
			log.Fatalf("Migration failed: %v", err)
		}
	}
}
