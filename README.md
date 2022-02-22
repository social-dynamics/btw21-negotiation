# Model of Party Negotiations

Obtain the necessary data to setup the model:

```
> ./get_data.sh
```

Process the data:

```
> julia data_processing.jl
```

The basic workflow of [Negotiations.jl](https://github.com/social-dynamics/party-negotiations) is implemented in `test.jl`:

```{julia}
using Negotiations

params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite")
model = setup_model(params, db)
simulate(model, 2, db)
```

The `simulate` function writes the simulation results to the provided database.

This entire workflow can be executed with:

```
> ./run.sh
```


## Requirements

* sqlite3
* julia 1.7
* [Negotiations.jl](https://github.com/social-dynamics/Negotiations.jl) (apparently needs to be added manually)
* 
