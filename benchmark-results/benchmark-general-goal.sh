
echo "\n\n======== HTC ============" > general-clingo-out-goal.txt

echo "======== Size 1 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingcon 0 - ./src/encodings/mlp-tplp-htc.lp -c lambda=4 -c v=110 --stats -c size=1 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 5 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingcon 0 - ./src/encodings/mlp-tplp-htc.lp -c lambda=4 -c v=550 --stats -c size=5 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 10 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingcon 0 - ./src/encodings/mlp-tplp-htc.lp -c lambda=4 -c v=1100 --stats -c size=10 -q >> general-clingo-out-goal.txt 2>&1


echo "\n\n======== HTC DL ============" >> general-clingo-out-goal.txt

echo "======== Size 1 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingodl 0 - ./src/encodings/mlp-tplp-htcdl.lp -c lambda=4 -c v=110 --stats -c size=1 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 5 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingodl 0 - ./src/encodings/mlp-tplp-htcdl.lp -c lambda=4 -c v=550 --stats -c size=5 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 10 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingodl 0 - ./src/encodings/mlp-tplp-htcdl.lp -c lambda=4 -c v=1100 --stats -c size=10 -q >> general-clingo-out-goal.txt 2>&1


echo "\n\n======== HT ============" >> general-clingo-out-goal.txt

echo "======== Size 1 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingo 0 - ./src/encodings/mlp-tplp-ht.lp -c lambda=4 -c v=110 --stats -c size=1 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 5 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingo 0 - ./src/encodings/mlp-tplp-ht.lp -c lambda=4 -c v=550 --stats -c size=5 -q >> general-clingo-out-goal.txt 2>&1
echo "======== Size 10 ============" >> general-clingo-out-goal.txt
python -m clingo examples/dentist/dentist.lp  examples/dentist/dentist-goal-eventually-body.lp --output=reify | python -m clingo 0 - ./src/encodings/mlp-tplp-ht.lp -c lambda=4 -c v=1100 --stats -c size=10 -q >> general-clingo-out-goal.txt 2>&1
