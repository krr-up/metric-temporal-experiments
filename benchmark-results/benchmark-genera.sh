#!/bin/bash

# Output file
OUTPUT_FILE="benchmark-results/plain.txt"

# Function to run benchmarks
run_benchmark() {
    local label="$1"
    local encoding="$2"
    local tool="$3"
    local sizes=("$@")

    echo -e "\n\n****************************************************************************************" >> "$OUTPUT_FILE"
    echo "$label" >> "$OUTPUT_FILE"
    echo "****************************************************************************************" >> "$OUTPUT_FILE"

    for size in "${sizes[@]:3}"; do
        local v=$((size * 110))
        echo "\n======== Size $size ============" >> "$OUTPUT_FILE"
        python -m clingo examples/dentist/dentist.lp --output=reify | \
        python -m "$tool" 0 - "$encoding" -c lambda=4 -c v="$v" --stats -c size="$size" -q >> "$OUTPUT_FILE" 2>&1
    done
}

# Clear output file

# Run benchmarks
run_benchmark "HTC clingcon" "./src/encodings/mlp-lpnmr-htc.lp" "clingcon" 1 5 7 10
run_benchmark "HTC clingodl" "./src/encodings/mlp-lpnmr-htcdl.lp" "clingodl" 1 5 7 10
run_benchmark "HT" "./src/encodings/mlp-lpnmr-ht.lp" "clingo" 1 5 7 10
