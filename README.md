# Model of Party Negotiations

This will automatically fetch and format the database (on linux and possibly mac anyway...):

```
> ./get_data.sh
```

The basic workflow of [Negotiations.jl](https://github.com/social-dynamics/party-negotiations) is implemented in `test.jl`.
The workflow is as follows:

```
using Negotiations

params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite3")
model = setup_model(params, db)
simulate(model, 2, db)
```

The `simulate` function writes the simulation results to the provided database.
