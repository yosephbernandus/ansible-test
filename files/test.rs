use std::env;

fn main() {
    match env::var("DATABASE_URL") {
        Ok(url) => println!("Database URL from Rust: {}", url),
        Err(_) => println!("Database URL from Rust: not found"),
    }
}
