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
# rule = BoundedConfidence(bc = 1.0, inertia = 10.0)
rule = ContinuousHomophily(inertia = 20.0)
@time simulate(model, rule, 3, db, batchname = "test")
