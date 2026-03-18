# memelingo



## Installation

```shell
pip install . -r requirements.txt
```

Note that for visualizing the traces using clingraph, Graphviz must be locally
installed.

```shell
sudo apt install graphviz
```

### During development

```shell
pip install -e .
```

## Usage

### As an Application

Memelingo extends the application class

```shell
memelingo -h
```

The direct command line is printed when using `--log info`

#### Traffic lights example

```shell
memelingo 0  -c lambda=3 examples/traffic-lights.lp
```

To visualize the timed traces obtained using clingraph  you can add the argument `--view`

```shell
memelingo 1  -c lambda=3 examples/traffic-lights.lp --view
```

### Via command line

```shell
python -m clingo examples/traffic-lights.lp --output=reify | python -m clingcon 0 - src/encodings/{meta-melingo,meta-clingcon-interval,meta}.lp -c lambda=3
```

## Dentist example

### MLP LPMNR paper 2024

No goal condition

#### clingo

```shell
memelingo 0  -c lambda=4 examples/dentist/dentist.lp --view --log info --approach mlp --timepoint-limit 100
```

#### clingocon

```shell
memelingo 0  -c lambda=4 examples/dentist/dentist.lp --view --log info --approach mlp-htc
```

### MLP extended with evetually and always

To get the single model including the goal

#### clingcon

```shell
memelingo 0  -c lambda=4 examples/dentist/dentist.lp examples/dentist/dentist-goal-always-body.lp --view --log info --approach mlp-htc-extended
```

### Full Tseiten

Single model with the goal

#### clingcon
```shell
memelingo 0  -c lambda=4 examples/dentist/dentist.lp examples/dentist/dentist-goal-always-body.lp --view --log info
```

#### clingo
```shell
memelingo 0  -c lambda=4 examples/dentist/dentist.lp examples/dentist/dentist-goal-always-body.lp --view --log info --approach asp -c v=100
```


## Development

To improve code quality, we run linters, type checkers, and unit tests. The
tools can be run using [nox]. We recommend installing nox using [pipx] to have
it available globally:

```bash
python -m pip install pipx
python -m pipx install nox
nox
```

You can invoke `nox -s` to run individual sessions. For example, to install
your package into a virtual environment and run your test suite, invoke:

```bash
nox -s test
```

We also provide a nox session that creates an environment for development. The
project is installed in [editable] mode into this environment along with
linting, type checking and formatting tools. Activating it allows your editor
of choice to access these tools for, e.g., linting and autocompletion. To
create and then activate virtual environment run:

```bash
nox -s dev
source .nox/dev/bin/activate
```

Furthermore, we provide individual sessions to easily run linting, type
checking and formatting via nox. These also create editable installs. So you
can safely skip the recreation of the virtual environment and reinstallation of
your package in subsequent runs by passing the `-R` command line argument. For
example, to auto-format your code using [black], run:

```bash
nox -Rs format -- check
nox -Rs format
```

The former command allows you to inspect changes before applying them.

Note that editable installs have some caveats. In case there are issues, try
recreating environments by dropping the `-R` option. If your project is
incompatible with editable installs, adjust the `noxfile.py` to disable them.

We also provide a [pre-commit][pre] config to automate this process. It can be
set up using the following commands:

```bash
python -m pipx install pre-commit
pre-commit install
```

This blackens the source code whenever `git commit` is used.

[doc]: https://potassco.org/clingo/python-api/current/
[nox]: https://nox.thea.codes/en/stable/index.html
[pipx]: https://pypa.github.io/pipx/
[pre]: https://pre-commit.com/
[black]: https://black.readthedocs.io/en/stable/
[editable]: https://setuptools.pypa.io/en/latest/userguide/development_mode.html
