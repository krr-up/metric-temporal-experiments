#!/bin/bash
# https://github.com/arminbiere/runlim

CAT="../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

runner=( "../../../../../../../../../programs/runlim" \
  --single \
  --space-limit=20000 \
  --output-file=runsolver.watcher \
  --real-time-limit=1200 \
  "../../../../../../../../../programs/memelingo-1" \
  --project=show --stats -c lambda=10 --approach=mlp-tplp-ht --timepoint-limit=150 \
     )

input=( "../../../../../../../../../../examples/benchmarks/mapf/instances/x6_y6_a2_f10.lp" "../../../../../../../../../../examples/benchmarks/mapf/mapf.lp" )

if [[ ! -e .finished ]]; then
  {
    if file -b --mime-type -L  "${input[@]}" | grep -qv "text/"; then
      "$CAT" "${input[@]}" | "${runner[@]}"
    else
      "${runner[@]}" "${input[@]}"
    fi
  } > runsolver.solver
fi

touch .finished
