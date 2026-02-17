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

echo "python -m clingo ${FILES[@]} --output=reify | python -m clingcon - ../../../../../../../../../../../src/memelingo/encodings/mlp-tplp-htc.lp ${ARGS[@]} --propagate=full"
python -m clingo "${FILES[@]}" --output=reify | \
python -m clingodl - ../../../../../../../../../../../src/memelingo/encodings/mlp-tplp-htcdl.lp "${ARGS[@]}" --propagate=full
