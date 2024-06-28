#!/bin/bash

# Démarrer SQL Server en arrière-plan
/opt/mssql/bin/sqlservr &

# Attendre que SQL Server soit prêt
is_ready() {
    /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -Q "SELECT 1" >/dev/null 2>&1
}

# Attendre que SQL Server soit prêt
until is_ready; do
    echo "Waiting for SQL Server to be ready..."
    sleep 5
done

# Vérifier si la base de données existe déjà
DB_EXISTS=$(/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -Q "IF DB_ID(N'${DB_NAME}') IS NOT NULL PRINT 'EXISTS'" -h -1)

if [ "$DB_EXISTS" == "EXISTS" ]; then
    echo "Database ${DB_NAME} already exists. Skipping initialization."
else
    echo "Database ${DB_NAME} does not exist. Proceeding with initialization."


    i=0
    # Importer les données dans la base de données à partir de tous les fichiers SQL
    for f in /usr/src/app/sql-scripts/*.sql; do
        i=$((i+1))
        if [ -f "$f" ]; then
            echo "Executing $f..."
            /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${SA_PASSWORD}" -i "$f" -o /usr/src/app/sql-scripts/log"$i".txt
        fi
    done
fi

# Garder le conteneur en cours d'exécution
wait
