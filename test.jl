using Pkg
Pkg.activate(".")

using Negotiations

params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite3")
model = setup_model(params, db)
simulate(model, 1, db)
