# POS Inventory System — Tech Stack & Project Setup

## Tech Stack

### Backend — Go (Gin) + SQLite

| Component | Choice | Why |
|-----------|--------|-----|
| Language | Go 1.22+ | Compiles to a single binary, low resource usage, easy to self-host |
| Framework | Gin | Lightweight HTTP framework with routing, middleware, and JSON binding |
| Database | SQLite (WAL mode) | Zero-config, single-file database — no separate DB server needed |
| Driver | mattn/go-sqlite3 | Mature CGo-based SQLite driver for Go |

### Android App — Kotlin + Jetpack Compose

| Component | Choice | Why |
|-----------|--------|-----|
| Language | Kotlin | Official Android language, concise syntax |
| UI | Jetpack Compose | Modern declarative UI toolkit, less boilerplate than XML |
| Networking | Retrofit | Type-safe HTTP client for calling the REST API |
| Local cache | Room | Offline-capable local database that mirrors server data |
| DI | Hilt | Standard dependency injection for Android |

### Dashboard — HTMX + Go Templates

| Component | Choice | Why |
|-----------|--------|-----|
| Rendering | Go html/template | Server-side rendering, no JS build step |
| Interactivity | HTMX | Adds dynamic behavior (live updates, partial page swaps) with HTML attributes |
| Styling | Custom CSS | Minimal stylesheet, no framework dependency |

### API — REST (JSON)

Simple RESTful endpoints consumed by both the Android app and the HTMX dashboard. No authentication yet (planned for a future phase).

---

## Project Structure

```
POS-Inventory-System/
├── .gitignore
├── docs/
│   └── TECH_STACK.md              # This file
├── server/
│   ├── go.mod                     # Go module definition & dependencies
│   ├── cmd/
│   │   └── api/
│   │       └── main.go            # Entry point — starts server on :8080
│   ├── internal/
│   │   ├── database/
│   │   │   └── database.go        # SQLite connection, auto-migration
│   │   ├── handlers/
│   │   │   ├── products.go        # CRUD endpoints for products
│   │   │   ├── sales.go           # Create & list sales
│   │   │   └── dashboard.go       # Aggregated stats endpoint
│   │   ├── middleware/
│   │   │   └── cors.go            # CORS middleware for Android access
│   │   └── models/
│   │       └── models.go          # Data structs (Product, Sale, SaleItem, DashboardStats)
│   ├── static/
│   │   └── css/
│   │       └── style.css          # Dashboard stylesheet
│   └── templates/
│       └── pages/
│           └── dashboard.html     # HTMX-powered dashboard UI
└── android/
    └── app/src/main/
        ├── java/com/pos/inventory/
        │   ├── ui/                # Jetpack Compose screens, components, theme
        │   ├── data/              # API client, local DB, repositories
        │   └── di/                # Dependency injection modules
        └── res/                   # Android resources
```

---

## Scaffolding Steps

### 1. Created the project directory

```bash
mkdir -p ~/Documents/POS-Inventory-System
```

### 2. Scaffolded the folder structure

Created all directories in one command:

- `server/cmd/api/` — Go entry point
- `server/internal/{handlers,models,middleware,database}/` — Business logic
- `server/templates/{layouts,pages,partials}/` — Dashboard HTML templates
- `server/static/{css,js}/` — Static assets
- `android/app/src/main/java/com/pos/inventory/{ui,data,di}/` — Android app
- `docs/` — Documentation

### 3. Created the Go module

Initialized `go.mod` with:
- `github.com/gin-gonic/gin` — HTTP framework
- `github.com/mattn/go-sqlite3` — SQLite driver

### 4. Defined data models

`models.go` contains four structs:
- **Product** — id, name, SKU, price, quantity, category, timestamps
- **Sale** — id, line items, total, timestamp
- **SaleItem** — links a product to a sale with price and quantity
- **DashboardStats** — total products, low stock count, today's sales & revenue

### 5. Set up SQLite with auto-migration

`database.go` opens SQLite in WAL mode with foreign keys enabled and runs `CREATE TABLE IF NOT EXISTS` for three tables: `products`, `sales`, `sale_items`.

### 6. Built the API handlers

| File | Endpoints |
|------|-----------|
| `products.go` | `GET /api/products`, `GET /api/products/:id`, `POST /api/products`, `PUT /api/products/:id`, `DELETE /api/products/:id` |
| `sales.go` | `GET /api/sales`, `POST /api/sales` (uses a transaction to insert sale + items and deduct inventory) |
| `dashboard.go` | `GET /api/dashboard/stats` (aggregates product count, low stock, today's sales & revenue) |

### 7. Created the main entry point

`main.go` initializes the database, loads templates, mounts static files, registers all API routes under `/api`, and serves the dashboard at `/`.

### 8. Built the dashboard

`dashboard.html` uses HTMX attributes (`hx-get`, `hx-trigger="load, every 30s"`) to auto-refresh stats, inventory, and sales data without JavaScript.

### 9. Added CORS middleware

`cors.go` allows all origins so the Android app can reach the API from the local network.

### 10. Created .gitignore

Excludes SQLite database files, Go binaries, Android build artifacts, and IDE files.

---

## Running the Server

```bash
cd ~/Documents/POS-Inventory-System/server
go mod tidy
go run cmd/api/main.go
```

The server starts on `http://localhost:8080`. Open that URL in a browser to see the dashboard.

---

## Next Steps

- [ ] Scaffold Android app starter files (Retrofit client, Room DB, Compose screens)
- [ ] Add authentication (API key or JWT)
- [ ] Seed sample data for development
- [ ] Deploy instructions (systemd service, Docker, etc.)
