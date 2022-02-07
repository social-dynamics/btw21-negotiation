# Activate local environment
using Pkg
Pkg.activate(".")

# Load module
using Negotiations

# Run model
params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite")
model = setup_model(params, db)
simulate(model, 1, db, batchname = "test")
