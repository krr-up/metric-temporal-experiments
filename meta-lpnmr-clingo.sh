#!/usr/bin/env bash

# Separate files from other arguments
FILES=()
ARGS=()

for arg in "$@"; do
    if [[ "$arg" == *.lp ]] || [[ "$arg" == *.asp ]] || [[ "$arg" == *.clingo ]]; then
        FILES+=("$arg")
    else
        ARGS+=("$arg")
    fi
done

echo "python -m clingo ${FILES[@]} --output=reify | python -m clingo - src/memelingo/encodings/mlp-lpnmr-ht.lp ${ARGS[@]}"
python -m clingo "${FILES[@]}" --output=reify | \
python -m clingo - src/memelingo/encodings/mlp-lpnmr-ht.lp "${ARGS[@]}"
