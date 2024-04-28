# Hospital Management System on Sui Framework

This project is a Hospital Management System developed using the Sui blockchain framework. It allows for the management of various hospital operations, including patient admission and discharge, hospital record management, and billing information.

## Overview

The Hospital Management System is designed to represent hospital objects and manage their interactions. Key components include modules for hospital, patient, and billing management.

## Features

- **Hospital Management:**
  - Represent a hospital as an object with details such as hospital ID, name, location, and capacity.
  - Functions to create, update, and delete hospital records.

- **Patient Management:**
  - Represent a patient as an object with attributes like patient ID, name, age, and medical history.
  - Functions to admit, discharge, and update patient records.
  - Maintain patient history with a detailed log of events and treatments.

- **Billing Management:**
  - Represent billing information as an object with attributes like bill ID, patient ID, and amount.
  - Functions to record bill payments and generate billing reports.

## Note

- The system should handle errors such as invalid hospital or patient records.
- Transactions such as patient admission and bill generation require sufficient gas.
- Implement access control mechanisms to ensure secure operations and prevent unauthorized access to sensitive information.
- Consider implementing events to track important actions like patient admission and billing.

## Dependency

- The Hospital Management System depends on the Sui blockchain framework for its smart contract functionality.
- Ensure you have the Move compiler installed and configured for the appropriate Sui framework (e.g., `framework/devnet` for Devnet or `framework/testnet` for Testnet).

```bash
Sui = { git = "https://github.com/MystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/devnet" }
```

## Installation

Follow these steps to deploy and use the Hospital Management System:

1. **Move Compiler Installation:**
   Ensure you have the Move compiler installed. Refer to the [Sui documentation](https://docs.sui.io/) for installation instructions.

2. **Compile the Smart Contract:**
   Switch the dependencies in the `Sui` configuration to match your chosen framework (`framework/devnet` or `framework/testnet`), then build the contract.

   ```bash
   sui move build
   ```

3. **Deployment:**
   Deploy the compiled smart contract to your chosen blockchain platform using the Sui command-line interface.

   ```bash
   sui client publish --gas-budget 100000000 --json
   ```

## Additional Notes

- Ensure your development environment is set up properly to avoid errors.
- Logs and debug reports can provide specific information to troubleshoot issues during deployment or execution.
- Consider implementing a testing suite to validate smart contract functions before deployment.
