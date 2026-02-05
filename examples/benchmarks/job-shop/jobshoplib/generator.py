import json
from job_shop_lib.benchmarking import (
    load_benchmark_instance,
    load_all_benchmark_instances,
)
from job_shop_lib import JobShopInstance, Operation
import sys

if len(sys.argv) < 2:
    print(load_all_benchmark_instances().keys())
    sys.exit(1)

instance = load_benchmark_instance(sys.argv[1])

# CPU = 0
# GPU = 1
# DATA_CENTER = 2

# job_1 = [Operation(CPU, 1), Operation(GPU, 1), Operation(DATA_CENTER, 7)]
# job_2 = [Operation(GPU, 5), Operation(DATA_CENTER, 1), Operation(CPU, 1)]
# job_3 = [Operation(DATA_CENTER, 1), Operation(CPU, 3), Operation(GPU, 2)]

# jobs = [job_1, job_2, job_3]

# instance = JobShopInstance(jobs, name="Example", optimum=15)


asp_str = "% ========= Metadata =========\n"
args = ["name", "num_jobs", "num_machines", "num_operations"]
for n in args:
    asp_str += f"   meta({n},{getattr(instance, n)}).\n"

n = ["optimum", "upper_bound", "lower_bound"]
for key in n:
    if key in instance.metadata:
        asp_str += f"   meta({key},{instance.metadata[key]}).\n"
asp_str += "% ==========================\n\n\n"


asp_str += f"machine(0..{instance.num_machines}).\n"

for idx, job in enumerate(instance.jobs):
    asp_str += f"\n%--- Job {idx}\n"
    asp_str += f"job({idx}).\n"
    for op in job:
        for m in op.machines:
            asp_str += f"operation({idx},{op.operation_id},{m},{op.duration}).\n"


# Convert to JSON
# print(json.dumps(info, indent=2))
# print(instance.to_dict())
print(asp_str)


# from job_shop_lib.constraint_programming import ORToolsSolver

# solver = ORToolsSolver()
# schedule = solver(instance)
# schedule.schedule
# print(schedule.schedule)
# print(f"Is complete?: {schedule.is_complete()}")
# print(f"Meta data: {schedule.metadata}")
# print(f"Makespan: {schedule.makespan()}")
