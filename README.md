                    ## Running PostgreSQL Locally on macOS

To start and interact with your local PostgreSQL server, follow these steps:

### 1. Start the PostgreSQL server

Run the PostgreSQL server by specifying the data directory (adjust the path if different):

```bash
postgres -D /opt/homebrew/var/postgres   

## Connect to PostgreSQL using the psql client

Open a new terminal and launch the interactive PostgreSQL shell:

```bash
psql postgres

### Useful PostgreSQL commands inside psql

```bash
psql postgres
\list show all DBs
\c DB_name list databases 
\dt show tables 
\d tableName shows the table header and types 
\du is to check the list of users


psql -U chocolate_admin -d chocolate_db  -W  # Will prompt for password
pass: 123Malak


docker run -d \
  --name postgres-db \
  -p 5432:5432 \
  -v 39f19ad8f50ab99a860e915c45251baadb1ffd7a42964e40bf458ca5a082269d:/var/lib/postgresql \
  -e POSTGRES_USER=chocolate_admin \
  -e POSTGRES_PASSWORD=123Malak \
  -e POSTGRES_DB=chocolate_db \
  postgres:latest


  to create postgresql with the same volume that is persistant

