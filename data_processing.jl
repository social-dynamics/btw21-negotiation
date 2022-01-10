using Pkg
Pkg.activate(".")

# Download, filter, and rename data
run(`wget https://www.bpb.de/system/files/datei/Wahl-O-Mat%20Bundestag%202021_Datensatz_v1.02.zip -P data`)
run(`7z x -odata data/'Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.zip'`)
run(`rm data/'Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.zip'`)
run(`mv 'data/Wahl-O-Mat Bundestag 2021_Datensatz_v1.02.xlsx' data/wahlomat.xlsx`)
run(`rm data/Hinweis.txt`)

# Dependencies for formatting
using DataFrames
using XLSX
using SQLite

# Read data
df = DataFrame(
    XLSX.readtable(
        "data/wahlomat.xlsx",
        "Datensatz Bundestag 2021"
    )...
)

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

# Split tables
party_table = unique!(df[:, [:party_id, :party_shorthand, :party_name]])
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




statement_table = df[:, [:statement_id, :statement_title, :statement]]
opinion_table = df[:, [:party_id, :statement_id, :position, :position_rationale]]

# Create database
db = SQLite.DB("./db.sqlite3")
SQLite.load!(party_table, db, "party")
SQLite.load!(statement_table, db, "statement")
SQLite.load!(opinion_table, db, "opinion")

# Set keys
SQLite.execute(db, """
    PRAGMA foreign_keys=off;
    BEGIN TRANSACTION;
    ALTER TABLE party RENAME TO party_old;
    CREATE TABLE party
    (
        party_id INTEGER NOT NULL PRIMARY KEY,
        party_shorthand TEXT,
        party_name TEXT,
    );
    INSERT INTO party SELECT * FROM party_old;
    COMMIT;
    PRAGMA foreign_keys=on;
    DROP TABLE party_old;
""")

SQLite.execute(db, """
    PRAGMA foreign_keys=off;
    BEGIN TRANSACTION;
    ALTER TABLE statement RENAME TO statement_old;
    CREATE TABLE statement
    (
        statement_id INTEGER NOT NULL PRIMARY KEY,
        statement_title TEXT,
        statement TEXT,
    );
    INSERT INTO statement SELECT * FROM statement_old;
    COMMIT;
    PRAGMA foreign_keys=on;
    DROP TABLE statement_old;
""")

SQLite.execute(db, """
    PRAGMA foreign_keys=on;
    BEGIN TRANSACTION;
    ALTER TABLE opinion RENAME TO opinion_old;
    CREATE TABLE opinion
    (
        party_id INTEGER NOT NULL,
        statement_id INTEGER NOT NULL,l
        position INTEGER,
        position_rationale TEXT,
        FOREIGN KEY(party_id) REFERENCES party(party_id),
        FOREIGN KEY(statement_id) REFERENCES statement(statement_id),
        PRIMARY KEY(party_id, statement_id)
    );
    INSERT INTO opinion SELECT * FROM opinion_old;
    COMMIT;
    DROP TABLE statement_old;
""")
