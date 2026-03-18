#!/bin/bash

# Output file
# Function to run benchmarks
run_benchmark() {
    local label="$1"
    local encoding="$2"
    local tool="$3"
    local output_file="$4"
    local sizes=("$@")

    echo -e "\n\n****************************************************************************************" >> "$output_file"
    echo "$label" >> "$output_file"
    echo "****************************************************************************************" >> "$output_file"

    for size in "${sizes[@]:4}"; do
        local v=$((size * 110))
        echo "\n======== Size $size ============" >> "$output_file"
        # python -m clingo examples/dentist/dentist.lp --output=reify | \
        python -m clingo examples/dentist/dentist.lp examples/dentist/dentist-goal-eventually-body.lp --output=reify | \
        python -m "$tool" 0 - "$encoding" -c lambda=4 -c v="$v" --stats -c size="$size" -q >> "$output_file" 2>&1
    done
}

# Clear output file

# # Plain
# run_benchmark "HTC clingcon" "./src/encodings/mlp-lpnmr-htc.lp" "clingcon" "benchmark-results/plain.txt" 1 5 7 10
# run_benchmark "HTC clingodl" "./src/encodings/mlp-lpnmr-htcdl.lp" "clingodl" "benchmark-results/plain.txt" 1 5 7 10
# run_benchmark "HT" "./src/encodings/mlp-lpnmr-ht.lp" "clingo" "benchmark-results/plain.txt" 1 5 7 10


# # General
# run_benchmark "HTC clingcon" "./src/encodings/mlp-tplp-htc.lp" "clingcon" "benchmark-results/general.txt" 1 5 7 10
# run_benchmark "HTC clingodl" "./src/encodings/mlp-tplp-htcdl.lp" "clingodl" "benchmark-results/general.txt" 1 5 7 10
# run_benchmark "HT" "./src/encodings/mlp-tplp-ht.lp" "clingo" "benchmark-results/general.txt" 1 5 7 10


# General-goal
run_benchmark "HTC clingcon" "./src/encodings/mlp-tplp-htc.lp" "clingcon" "benchmark-results/general-goal.txt" 1 5 7 10
run_benchmark "HTC clingodl" "./src/encodings/mlp-tplp-htcdl.lp" "clingodl" "benchmark-results/general-goal.txt" 1 5 7 10
run_benchmark "HT" "./src/encodings/mlp-tplp-ht.lp" "clingo" "benchmark-results/general-goal.txt" 1 5 7 10
