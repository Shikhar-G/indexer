# ***************************************************************************************#
# 										         #
# FILE: extract_schema.py								 #
# 										         #
# USAGE: python extract_schema.py [-h] SQL_FILE OUTPUT_DIR				 #
# 										         #
# DESCRIPTION: Extract the schema from a SQL file.					 #
# 											 #
# OPTIONS: List options for the script [-h]						 #
# 											 #
# ERROR CONDITIONS: exit 1  ---- Invalid SQL file.					 #
#                   exit 2  ---- Output directory not found and could not be created.	 #
#                   exit 3  ---- Invalid output directory.				 #
#                   exit 4  ---- Failed to extract schema.				 #
#                   exit 5  ---- Failed to save schema to file.				 #
# 											 #
# DEVELOPER: Shikhar Gupta								 #
# DEVELOPER EMAIL: shikhar.gupta.tx@gmail.com 						 #
# 											 #
# VERSION: 1.0										 #
# CREATED DATE-TIME: 2024-04-11-07:00 Central Time Zone USA				 #
# 											 #
# ***************************************************************************************#

import sqlglot
import sqlglot.expressions as exp
import json
import argparse
import os


def extract_schema(sql_file):
    """Extracts the schema from a SQL file.

    Args:
      sql_file: The path to the SQL file.

    Returns:
      A list of dictionaries, where each dictionary represents a table in the schema.
    """

    with open(sql_file, "r") as f:
        sql = f.read()

    # Parse the SQL file
    # mute the warnings

    result = sqlglot.parse(sql)

    # Extract the schema
    schema = []
    for statement in result:
        if isinstance(statement, exp.Create):
            args = statement.args["this"].args
            table = {}
            table["name"] = str(args["this"])
            table["columns"] = {}
            for column_arg in args["expressions"]:
                column = {}
                if isinstance(column_arg, exp.ColumnDef):
                    column["type"] = str(column_arg.args["kind"])
                    column["constraints"] = [
                        str(constraint) for constraint in column_arg.args["constraints"]
                    ]
                    table["columns"][str(column_arg.args["this"])] = column
                elif isinstance(column_arg, exp.ForeignKey):
                    name = column_arg.args["expressions"][0].args["this"]
                    references = column_arg.args["reference"].args["this"]
                    table["columns"][name][
                        "constraint"
                    ] = f"FOREIGN KEY REFERENCES {references}"
            schema.append(table)

    return schema


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Extract the schema from a SQL file.")
    parser.add_argument(
        "sql_file",
        type=str,
        help="The path to the SQL file containing the schema.",
    )
    parser.add_argument(
        "output_dir",
        type=str,
        help="The path to the output directory to save the schema.",
    )
    args = parser.parse_args()
    if not args.sql_file or not args.output_dir:
        # print help message if no arguments are provided
        parser.print_help()
        exit(0)
    # check that the file is a SQL file and exists
    if not args.sql_file.endswith(".sql") or not os.path.exists(args.sql_file):
        print("Please provide a valid SQL file.")
        exit(1)
    # check that the output directory exists and if not, create it
    if not os.path.exists(args.output_dir):
        # try to create the directory
        try:
            os.makedirs(args.output_dir)
        except OSError:
            print("Output directory not found and could not be created.")
            exit(2)
    if not os.path.isdir(args.output_dir):
        print("Please provide a valid output directory.")
        exit(3)
    output_file = os.path.join(
        args.output_dir,
        os.path.basename(args.sql_file).replace(".sql", "_schema.json"),
    )
    try:
        schema = extract_schema(args.sql_file)
    except Exception as e:
        print(f"Failed to extract schema: {e}")
        exit(4)
    with open(output_file, "w") as f:
        try:
            json.dump(schema, f, indent=2)
            print(f"Schema saved to {output_file}")
        except Exception as e:
            print(f"Failed to save schema to file: {e}")
            exit(5)
