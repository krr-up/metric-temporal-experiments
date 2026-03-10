#!/bin/bash
# https://github.com/arminbiere/runlim

CAT="../../../../../../../../../../programs/gcat.sh"

cd "$(dirname $0)"

runner=( "../../../../../../../../../../programs/runlim" \
  --single --debug \
  --space-limit=20000 \
  --output-file=runsolver.watcher \
  --real-time-limit=1200 \
  "../../../../../../../../../../programs/memelingo-1" \
   mlp-tplp-ht --models=0 --project=show --stats -c lambda=4 -c v=1100 \
     )

input=( "../../../../../../../../../../../examples/dentist/instances/size-10.lp" "../../../../../../../../../../../examples/dentist/dentist-goal.lp" "../../../../../../../../../../../examples/dentist/dentist.lp" )

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
