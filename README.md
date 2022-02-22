# Model of Party Negotiations

Obtain the necessary data to setup the model:

```
> ./get_data.sh
```

Process the data:

```
> julia data_processing.jl
```

Run the model:

```
> julia run_model.jl
```

The julia runs can be sped up by starting julia with multiple threads:

```
> julia --threads 4 data_processing.jl
> julia --threads 4 run_model.jl
```


## Working with Negotiations.jl

The basic workflow of [Negotiations.jl](https://github.com/social-dynamics/party-negotiations) is as follows:

```{julia}
using Negotiations

params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite")
model = setup_model(params, db)
rule = ContinuousHomophily(inertia = 20.0)
simulate(model, rule, 3, db, batchname = "my_batchname")
```

The `simulate` function writes the simulation results to the provided database.


## Shortcut

This entire workflow can be executed with:

```
> ./run.sh
```


## Requirements

* [sqlite3](https://sqlite.org/download.html)
* [julia 1.7](https://julialang.org/downloads/)
* [Negotiations.jl](https://github.com/social-dynamics/Negotiations.jl) (apparently needs to be added manually)
* [7z](https://www.7-zip.org/download.html)
* [wget](https://www.gnu.org/software/wget/)
