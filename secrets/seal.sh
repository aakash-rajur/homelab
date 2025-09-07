#! /usr/bin/env bash

controller_namespace="${CONTROLLER_NAMESPACE:-sealed-secrets}"
controller_name="${CONTROLLER_NAME:-sealed-secrets}"
entries=()
files=()
name=""
format="yaml"
namespace="default"

print_help() {
  cat <<EOF
Usage: $(basename "$0") <target> [options]

Required:
  name                    Name of the secret. Must be provided.

Options:
  -e, --entry KEY=VALUE   Provide an entry (can be repeated).
  -f, --file FILE         Provide a file containing entries (can be repeated).
                          Each line must be in KEY=VALUE format.
  -n, --namespace NS      Namespace to use (default: default).
  --format [json|yaml]    Output format (default: yaml).
  -h, --help              Show this help message and exit.

Notes:
  - At least one --entry or --file must be provided.
  - Lines in files not matching KEY=VALUE will trigger warnings.
EOF
}

is_entry() {
  [[ "$1" =~ ^[^=]+=[^=]+$ ]]
}

read_entries_from_file() {
  local file="$1"
  local collected=()

  if [[ ! -f "$file" ]]; then
    echo "Warning: file not found: $file" >&2
    return
  fi

  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    if is_entry "$line"; then
      collected+=("$line")
    else
      echo "Warning: invalid entry format in $file: '$line'" >&2
    fi
  done <"$file"

  # Print collected entries (space-separated, safe for array capture)
  printf '%s\n' "${collected[@]}"
}

case "$1" in
-h | --help)
  print_help
  exit 0
  ;;
-*)
  echo "Error: first positional argument <target> is required, not an option" >&2
  print_help
  exit 1
  ;;
*)
  name="$1"
  shift
  ;;
esac

while [[ $# -gt 0 ]]; do
  case "$1" in
  -e | --entry)
    if is_entry "$2"; then
      entries+=("$2")
    else
      echo "Error: entry must be in key=value format (got '$2')" >&2
      exit 1
    fi
    shift 2
    ;;
  -f | --file)
    files+=("$2")
    shift 2
    ;;
  --format)
    case "$2" in
    json | yaml)
      format="$2"
      ;;
    *)
      echo "Error: --format must be 'json' or 'yaml' (got '$2')" >&2
      exit 1
      ;;
    esac
    shift 2
    ;;
  -n | --namespace)
    namespace="$2"
    shift 2
    ;;
  -h | --help)
    print_help
    exit 0
    ;;
  --)
    shift
    break
    ;;
  -*)
    echo "Unknown option: $1" >&2
    print_help
    exit 1
    ;;
  *)
    shift
    ;;
  esac
done


if [[ ${#entries[@]} -eq 0 && ${#files[@]} -eq 0 ]]; then
  echo "Error: at least one --entry or --file must be provided." >&2
  exit 1
fi

# Collect entries from files (functional style)
for f in "${files[@]}"; do
  mapfile -t new_entries < <(read_entries_from_file "$f")
  entries+=("${new_entries[@]}")
done

args=()
for entry in "${entries[@]}"; do
  args+=(--from-literal="$entry")
done

# kubectl create secret generic my-secret

generated=$(
  kubectl \
    --namespace "$namespace" \
    create secret generic "$name" \
    "${args[@]}" \
    --dry-run=client -o json \
  | kubeseal \
      --controller-namespace "$controller_namespace" \
      --controller-name "$controller_name" \
      --namespace "$namespace" \
      -o "$format"
);

echo -n "$generated";
