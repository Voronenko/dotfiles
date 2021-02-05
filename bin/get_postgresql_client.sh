#!/bin/bash

CLIENT_TOOLS_VERSION=${1:-12}

# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# echo install client tools:
sudo apt-get install postgresql-client-${CLIENT_TOOLS_VERSION}

exit $?

# If you are considering branch deploy box with blueprint db

echo <<<EXAMPLE

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE apiuser PASSWORD 'apiuser' NOSUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;
    GRANT ALL PRIVILEGES ON DATABASE blueprint TO apiuser;
    CREATE ROLE portal PASSWORD 'portal' NOSUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;
    GRANT ALL PRIVILEGES ON DATABASE blueprint TO portal;
EOSQL


EXAMPLE


# for automatic psql login, consider creating

cat <<<EXAMPLE

touch ~/.pgpass
chmod 0600 ~/.pgpass
echo "hostname:port:database:username:password" > ~/.pgpass

EXAMPLE


# as a simple option you could also use

cat <<<EXAMPLE

PGPASSWORD=YOUR_PASSRORD psql -h YOUR_PG_HOST -U YOUR_USER_NAME ...

EXAMPLE
