# Activate local environment
using Pkg
Pkg.activate(".")

printstyled("  Running "; color = :green, bold = true)
print("model...\n")

# Load module
using Negotiations

# Run model
params = parameter_set_from_config("config.yaml")
db = load_database("db.sqlite")
model = setup_model(params, db)
@time simulate(model, 3, db, batchname = "test")
