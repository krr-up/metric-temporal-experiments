# memelingo

A system to compute solutions for metric logic programs.
Contains the implementation of [Implementing Metric Temporal Answer Set Programming](https://arxiv.org/pdf/2601.20735).

This repository will not be maintained, for the latest work please visit the [metasp](https://github.com/potassco/metasp) system.
The *metasp* system contains an example with this implementation, additionally, it has features for interactivity and visualization of the traces.

## Installation

```shell
pip install . -r requirements.txt
```

## Usage

### Approaches

- `mlp-lpnmr-ht`:

    The approach presented in the MLP LPNMR 2024 paper, using *clingo*. Encoding can be found in [`src/memelingo/encodings/mlp-lpnmr-ht.lp`](src/memelingo/encodings/mlp-lpnmr-ht.lp).

- `mlp-lpnmr-htc`:

    The approach presented in the MLP LPNMR 2024 paper, using *clingcon*. Encoding can be found in [`src/memelingo/encodings/mlp-lpnmr-htc.lp`](src/memelingo/encodings/mlp-lpnmr-htc.lp).
- `mlp-lpnmr-htcdl`:

    The approach presented in the MLP LPNMR 2024 paper, using *clingoDL*. Encoding can be found in [`src/memelingo/encodings/mlp-lpnmr-htcdl.lp`](src/memelingo/encodings/mlp-lpnmr-htcdl.lp)
- `mlp-tplp-ht`:

    The approach presented in the TPLP 2024 paper, using *clingo*. Encoding can be found in [`src/memelingo/encodings/mlp-tplp-ht.lp`](src/memelingo/encodings/mlp-tplp-ht.lp).
- `mlp-tplp-htc`:

    The approach presented in the TPLP 2024 paper, using *clingcon*. Encoding can be found in [`src/memelingo/encodings/mlp-tplp-htc.lp`](src/memelingo/encodings/mlp-tplp-htc.lp).
- `mlp-tplp-htcdl`:

    The approach presented in the TPLP 2024 paper, using *clingoDL*. Encoding can be found in [`src/memelingo/encodings/mlp-tplp-htcdl.lp`](src/memelingo/encodings/mlp-tplp-htcdl.lp).


### Command Line

*memelingo* can be used as an application class.
One must first specify the approach from above, this will show all the options of the corresponding system.

```shell
memelingo <approach> -h
```

We suggest using the `mlp-tplp-htcdl` approach.

## Examples

### MLP (Plain approach)

No goal condition

#### clingo

```shell
memelingo mlp-lpnmr-ht 0 examples/dentist/dentist.lp  -c lambda=4  -c v=110
```

#### clingocon

```shell
memelingo mlp-lpnmr-htc 0 examples/dentist/dentist.lp  -c lambda=4  -c v=110
```

#### clingodl

```shell
memelingo mlp-lpnmr-htcdl 0 examples/dentist/dentist.lp  -c lambda=4  -c v=110
```

### MLP General approach

To get the single model including the goal

#### clingo

```shell
memelingo mlp-tplp-ht 0 examples/dentist/dentist.lp examples/dentist/dentist-goal.lp  -c lambda=4  -c v=110
```
#### clingcon

```shell
memelingo mlp-tplp-htc 0 examples/dentist/dentist.lp examples/dentist/dentist-goal.lp  -c lambda=4  -c v=110
```

#### clingodl

```shell
memelingo mlp-tplp-htcdl 0 examples/dentist/dentist.lp examples/dentist/dentist-goal.lp  -c lambda=4  -c v=110
```

