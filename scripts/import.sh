#!/usr/bin/env bash
_file="$1"

if [[ -z "$_file" ]]; then
  echo "Usage: $0 <path-to-sql-dump>" >&2
  exit 1
fi

if [[ ! -f "$_file" ]]; then
  echo "File not found: $_file" >&2
  exit 1
fi

read -r -p "This overwrites the current database with '$_file'. Continue? [y/N] " _confirm
if [[ ! $_confirm =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

# Import dump
IMPORT_COMMAND='exec mariadb "$MARIADB_DATABASE" -uroot -p"$MARIADB_ROOT_PASSWORD"'
docker compose exec -T db sh -c "$IMPORT_COMMAND" <"$_file"
