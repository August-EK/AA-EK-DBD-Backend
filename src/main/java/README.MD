# Premier League Database - Installation Guide

## Prerequisites

Before starting, ensure you have the following installed on your system:

- **Git** - [Download from git-scm.com](https://git-scm.com/downloads)
- **Docker Desktop** - [Download from docker.com](https://www.docker.com/products/docker-desktop/)
- **Java 21** - [Download OpenJDK 21](https://openjdk.org/projects/jdk/21/) or use SDKMAN
- **Maven** (optional - project includes Maven wrapper)

## Step 1: Clone the Repository

git clone https://github.com/August-EK/AA-EK-DBD-Backend.git

## Step 2: Start Docker Desktop

1. Launch Docker Desktop application
2. Wait for Docker to fully start 

## Step 3: Start PostgreSQL Database

Start only the PostgreSQL service from the Docker Compose configuration:

docker-compose up -d postgres

**What this does:**
- Downloads PostgreSQL 15 image (if not already present)
- Creates a container named `premier-league-postgres`
- Sets up database with credentials: `quarkus/quarkus`
- Database name: `quarkusdb`
- Exposes PostgreSQL on port `5432`


## Step 4: Start the Quarkus Application

Navigate to the project root directory and run:

./mvnw compile quarkus:dev

**On Windows use:**
mvnw.cmd compile quarkus:dev

**What this does:**
- Downloads Maven dependencies
- Compiles the Java code
- Starts Quarkus in development mode
- Automatically creates database schema
- Loads test data from SQL scripts
- Starts the application on `http://localhost:8080`


### Step 5 Test Database Connection
Open your browser and visit:
- **Swagger UI:** http://localhost:8080/q/swagger-ui

### 5.1 Test API Endpoints
Try these endpoints in your browser or Postman:

GET http://localhost:8080/api/mysql/clubs
GET http://localhost:8080/api/mysql/clubs/1
GET http://localhost:8080/api/mysql/clubs/country/England

### 5.2 Verify Database Data
Connect to PostgreSQL using your preferred database tool:

**Connection Details:**
- Host: `localhost`
- Port: `5432`
- Database: `quarkusdb`
- Username: `quarkus`
- Password: `quarkus`

**Quick verification queries:**
-- Check if tables were created
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';

-- Check sample data
SELECT name, country, city FROM clubs;

-- Test a view
SELECT * FROM v_current_pl_table LIMIT 5;

-- Test a function
SELECT calculate_player_age('1994-09-08');

**Installation Complete!** 🎉

Your Premier League Database is now running at: http://localhost:8080