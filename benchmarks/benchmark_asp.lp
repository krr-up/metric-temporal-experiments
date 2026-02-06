%*! job(Name)

    Defines a job handler configuration, such as runlim.
    One can define sequential/distributed jobs and add settings for timeout, number of runs, memory, etc.

    Args:
        - Name: Name of the job
*%

job(my_seq_job).
	settings(my_seq_job,timeout,100). % Each setting is like the argument in the xml we keep it flexible
	settings(my_seq_job,runs,3).

%*! system(Name)

    Defines a system configuration, such as clingo with clasp.
    One can define multiple systems with different settings.

    Args:
        - Name: Name of the system
*%
system(clingo).
	settings(clingo,measures,clasp). %Like in the benchmark tool it is a python script that collects measures --stats

%* We just need a way to make it easier to create one for an application class (Like flingo)
Would be super nice if one can just write the command line here and that is enough... *%
system(my_flingo_system).
	settings(my_flingo_system,measures,my_measures).
	settings(my_flingo_system,command,"flingo").


% Matrix definition
% -----------------
%*! variable(Name, Type)

    Each variable can be then used to create combinations of runs.
    Possible values are defined via value/2 predicate.

    Args:
        - Name: Name of the variable
        - Type: Type of the variable, used by the system to generate the final command line can be:
            - file: A file path relative to somewhere
            - folder(Path): A folder path, will create one value/2 instance per file in the folder (Using like a propagator)
            - command(Template): A command line template where {} will be replaced by the value

*%
variable(encoding, file).
	value(encoding, "examples/benchmarks/job-shop/job-shop.lp").

% variable(instance, folder("examples/benchmarks/job-shop/instances")).
	% value(instance, I). is generated internally for each file in the folder

variable(approach, command("--approach={}")).
	value(approach, "mlp-tplp-ht").
	value(approach, "mlp-tplp-htc").
	value(approach, "mlp-tplp-htcdl").

variable(lambda, command("--c lambda={}")).
	value(lambda,15..20).

variable(timepoint, command("--timepoint={}")).
	value(timepoint,(930;55)).


% Running benchmarks
% ------------------

%*! run(Benchmark, Job, System, Config)

    Defines a run of a benchmark with a specific configuration.
    Each instance of run/4 will create a command line that is passed to the job handler.

    Args:
        - Benchmark: Name of the benchmark for the output
        - Job: Name of the job
        - System: Name of the system
        - Config: A tuple of ( (variable, value), ... ) defining the configuration
*%


run(mybench, J, S, ((encoding,E),(approach,A),(lambda,L),(timepoint,T))):-
	job(J),
	system(S),
	value(encoding,E),
	% value(instance, I),
	value(approach, A),
	value(lambda, L),
	value(timepoint, T).

    % Here we add some restrictions maybe we can do better than this via integrity constraints
    % but I am not sure how without using choices or complex predicates
	% I= "examples/benchmarks/job-shop/instances/ft06.lp",
	% T= 55.
