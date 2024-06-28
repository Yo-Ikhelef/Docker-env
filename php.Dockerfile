# Utiliser l'image PHP de base
FROM php:8.3-apache

# Installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    gnupg2

# Ajouter le dépôt Microsoft et la clé GPG
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Installer les extensions SQLSRV et PDO_SQLSRV
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Copier le contenu de votre application
COPY ./php /var/www/html

# Donner les droits appropriés
RUN chown -R www-data:www-data /var/www/html

# Exposer le port
EXPOSE 80