import json
from job_shop_lib.benchmarking import load_benchmark_instance
import sys

instance = load_benchmark_instance(sys.argv[1])


from job_shop_lib.constraint_programming import ORToolsSolver

solver = ORToolsSolver()
schedule = solver(instance)
schedule.schedule
print(schedule.schedule)
print(f"Is complete?: {schedule.is_complete()}")
print(f"Meta data: {schedule.metadata}")
print(f"Makespan: {schedule.makespan()}")
