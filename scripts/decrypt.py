# ***************************************************************************************#
# 										         #
# FILE: decrypt.py								         #
# 										         #
# USAGE: python decrypt.py [-h] --input_file INPUT_FILE --output_dir OUTPUT_DIR	         #
# 										         #
# DESCRIPTION: Read a json file containing a block of transactions,               	 #
#              decrypt the transactions using base64 api, and save the decrypted         #
#              transactions to a JSON file.						 #
# 											 #
# OPTIONS: List options for the script [-h]						 #
# 											 #
# ERROR CONDITIONS: exit 1 ---- Input file not found.					 #
#                   exit 2 ---- Invalid JSON file.					 #
#                   exit 3 ---- Invalid block file format.				 #
#                   exit 4 ---- Output file directory not found or could not be created. #
#                   exit 5 ---- Failed to decode transaction.				 #
# 											 #
# DEVELOPER: Shikhar Gupta								 #
# DEVELOPER EMAIL: shikhar.gupta.tx@gmail.com 						 #
# 											 #
# VERSION: 1.0										 #
# CREATED DATE-TIME: 2024-04-02-07:00 Central Time Zone USA				 #
# 											 #
# ***************************************************************************************#

import json
import requests
import os
import argparse


url = "https://phoenix-lcd.terra.dev/cosmos/tx/v1beta1/decode"
headers = {"Content-Type": "application/json"}


def process_and_decrypt_transaction_data(input_file_path, output_dir):
    """
    Read a json file, and isolate the txs special key. If the key is empty, return a message saying "no transactions found".
    If the key contains a transaction, remove any unnecessary characters and assign the transaction to variable "code".
    Decrypt the transaction using base64 api and save the decoded data to a JSON file.
    Args: input_file_path (str): The path to the input json file.
          output_dir (str): The path to the output directory to save the decrypted transactions. File will be saved with the same name as the input file, with '_decoded' appended to the end.
    Returns:
        0: If the transactions are successfully decrypted and saved to the output file, or if there are no transactions in the input file.
        1: If the input file is not found.
        2: If the input file is not a valid JSON file.
        3: Invalid block file format.
        4: Output file directory not found or could not be created.
        5: Failed to decode transaction.
    """
    try:
        if not os.path.exists(input_file_path):
            print("Input File not found.")
            return 1
        with open(input_file_path, "r") as input_file:
            data = json.load(input_file)
            if not isValidBlockFile(data):
                print("Invalid block file format.")
                return 3
            transactions = data["block"]["data"]["txs"]
            if len(transactions) == 0:
                print("No transactions found. Output file(s) not created.")
                return 0

            # check that directory exists
            if not os.path.exists(output_dir):
                # try to create the directory
                try:
                    os.makedirs(output_dir)
                except OSError:
                    print("Output directory not found and could not be created.")
                    return 4

            output_file_path = os.path.join(
                output_dir,
                os.path.basename(input_file_path).replace(".json", "_decoded.json"),
            )

            output_transactions = []
            # decrypt transaction using base64 api
            for transaction in transactions:
                data = json.dumps({"tx_bytes": transaction})
                response = requests.post(url, headers=headers, data=data)
                if response.status_code != 200:
                    print(
                        f"Failed to decode transaction. Status code: {response.status_code}"
                    )
                    return 5
                decoded_response = response.json()
                output_transactions.append(decoded_response)

            file_paths_output = []

            for i, transaction in enumerate(output_transactions):
                output_file_path = os.path.join(
                    output_dir,
                    os.path.basename(input_file_path).replace(".json", f"_{i+1}.json"),
                )
                with open(output_file_path, "w") as output_file:
                    json.dump(transaction, output_file, indent=2)
                file_paths_output.append(output_file_path)

            print(
                f"{len(output_transactions)} transaction(s) decoded and saved to {output_dir}"
            )
            return 0

    except json.JSONDecodeError:
        print("Invalid JSON file.")
        return 2


def isValidBlockFile(data):
    """
    Check if the input data is a valid block file format.
    Args:
        data (dict): The data loaded from the JSON file.
    Returns:
        bool: True if the data is a valid block file format, False otherwise.
    """
    if "block" in data and "data" in data["block"] and "txs" in data["block"]["data"]:
        return True
    return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Process and decrypt transaction data."
    )
    parser.add_argument(
        "--input_file",
        type=str,
        help="The path to the input json file containing transaction data.",
    )
    parser.add_argument(
        "--output_dir",
        type=str,
        help="The path to the output json file to save the decrypted transactions. If not provided, the decoded data will be saved to a file with the same name as the input file, with '_decoded' appended to the end.",
    )
    args = parser.parse_args()
    return_code = process_and_decrypt_transaction_data(args.input_file, args.output_dir)
    exit(return_code)
