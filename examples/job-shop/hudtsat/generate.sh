EPATH=examples/benchmarks/job-shop
Factor=1
rm -f $EPATH/instances/*
for NJobs in {10..11}; do
    for NMachines in {3..3}; do


        python -m clingo $EPATH/instance-gen.lp --out-ifs="\n" --out-atomf=%s. -c duration_factor=$Factor -c n_machines=$NMachines -c n_jobs=$NJobs --heuristic=Domain > $EPATH/instances/model-$NJobs-$NMachines-$Factor.lp
        sed -n '/^Answer: 1$/,/^SATISFIABLE$/p' $EPATH/instances/model-$NJobs-$NMachines-$Factor.lp | sed '1d;$d' > $EPATH/instances/job-shop-$NJobs-$NMachines-$Factor.lp
        rm $EPATH/instances/model-$NJobs-$NMachines-$Factor.lp
    done
done
