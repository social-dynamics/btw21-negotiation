# - Prerequesites:
# --- either:
# ----- download wahlomat data manually from:
#       https://www.bpb.de/system/files/datei/Wahl-O-Mat%20Bundestag%202021_Datensatz_v1.02.zip
# ----- unzip, rename to 'wahlomat.xlsx', delete everything else
# --- or:
# ----- ./get_data.sh

# Activate julia env
using Pkg
Pkg.activate(".")
Pkg.update()

# Reset database
if isfile("./db.sqlite")
    Base.Filesystem.rm("./db.sqlite")  # hard reset: if db exists, drop it
end

# Dependencies for formatting
using Negotiations
using DataFrames
using XLSX
using SQLite
using Match

# function to code opinion numerically
function recode_opinion(opinion::String)
    @match opinion begin
        "stimme zu" => 1
        "neutral" => 0
        "stimme nicht zu" => -1
        _ => -10
    end
end

printstyled("  Processing "; color = :green, bold = true)
print("data...\n")

# Read data
df = DataFrame(XLSX.readtable("data/wahlomat.xlsx", "Datensatz Bundestag 2021")...)

# Sane column names
rename!(
    df,
    [
        "party_id",
        "party_shorthand",
        "party_name",
        "statement_id",
        "statement_title",
        "statement",
        "position",
        "position_rationale"
    ]
)

# Split and process tables
party_table = unique(df[:, [:party_id, :party_shorthand, :party_name]])
party_table.party_shorthand = replace.(party_table.party_shorthand, "Ä" => "AE")
party_table.party_shorthand = replace.(party_table.party_shorthand, "ä" => "ae")
party_table.party_shorthand = replace.(party_table.party_shorthand, "Ö" => "OE")
party_table.party_shorthand = replace.(party_table.party_shorthand, "ö" => "oe")
party_table.party_shorthand = replace.(party_table.party_shorthand, "Ü" => "UE")
party_table.party_shorthand = replace.(party_table.party_shorthand, "ü" => "ue")
party_table.party_shorthand = replace.(party_table.party_shorthand, "/" => " ")
party_table.party_shorthand = replace.(party_table.party_shorthand, "³" => "3")
party_table.party_shorthand = replace.(party_table.party_shorthand, r"\." => " ")
party_table.party_shorthand = replace.(party_table.party_shorthand, r"-" => " ")
party_table.party_shorthand = replace.(party_table.party_shorthand, " " => "")

statement_table = unique(df[:, [:statement_id, :statement_title, :statement]])

opinion_table = df[:, [:party_id, :statement_id, :position, :position_rationale]]
opinion_table.position = [recode_opinion(o) for o in opinion_table.position]

printstyled("  Creating "; color = :green, bold = true)
print("database...\n")

# Create database
db = initialize_db("db")
SQLite.load!(party_table, db, "party")
SQLite.load!(statement_table, db, "statement")
SQLite.load!(opinion_table, db, "opinion")
