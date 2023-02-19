FROM postgres:13.2

ENV POSTGRES_USER=root
ENV POSTGRES_PASSWORD=root

COPY postgres.conf /etc/postgresql/postgresql.conf

COPY init-db.sh /docker-entrypoint-initdb.d/init-db.sh
