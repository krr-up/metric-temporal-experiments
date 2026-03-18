#!/bin/bash
# https://github.com/arminbiere/runlim

CAT="../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

runner=( "../../../../../../../../../programs/runlim" \
  --single \
  --space-limit=20000 \
  --output-file=runsolver.watcher \
  --real-time-limit=1200 \
  "../../../../../../../../../programs/memelingo-1" --project=show --stats --timepoint-limit=55 -c lambda=15 --approach=mlp-tplp-ht)

input=( "../../../../../../../../../../examples/benchmarks/job-shop/instances/ft06.lp" "../../../../../../../../../../examples/benchmarks/job-shop/job-shop.lp" )

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
