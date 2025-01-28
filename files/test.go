package main

import (
	"fmt"
	"os"
)

func main() {
	dbURL := os.Getenv("DATABASE_URL")
	fmt.Printf("Database URL from Go: %s\n", dbURL)
}
