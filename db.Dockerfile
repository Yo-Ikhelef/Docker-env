FROM mcr.microsoft.com/mssql/server:2019-latest

ENV SA_PASSWORD=${SA_PASSWORD}
ENV ACCEPT_EULA=Y

COPY shell-scripts/init-db.sh /usr/src/app/init-db.sh

# Command to run the script without changing its permissions
ENTRYPOINT ["/usr/src/app/init-db.sh"]