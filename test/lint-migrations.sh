#!/bin/sh
set -eu

failed=0

for file in migrations/*.sql; do
  if grep -Eiq '(password|passwd|secret)[[:space:]]*=' "$file"; then
    echo "possible credential in $file" >&2
    failed=1
  fi

  if grep -Eiq '(^|[[:space:]])GO([[:space:]]|$)' "$file"; then
    echo "Sybase GO delimiter found in PostgreSQL migration $file" >&2
    failed=1
  fi
done

versions=$(find migrations -type f -name 'V*__*.sql' -exec basename {} \; | sed -E 's/^V([^_]+)__.*/\1/' | sort)
duplicates=$(printf '%s\n' "$versions" | uniq -d)

if [ -n "$duplicates" ]; then
  echo "duplicate migration versions: $duplicates" >&2
  failed=1
fi

exit "$failed"
