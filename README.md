# Complex-Postgres-Extension
This repository contains a lab project for the INFO-H417 Database System Architecture course focused on creating a PostgreSQL extension for complex numbers. The project involves compiling and installing a template extension to introduce a complex number data type in PostgreSQL, with further customization and feature additions.

## Key Files
- **complex--1.0.sql**: SQL script for extension creation.
- **complex.c**: C source code defining complex number operations.
- **Makefile**: Compilation instructions.
- **complex.control**: Metadata for the extension.

## Installation
1. Extract `complex-template.zip` and rename to `complex`.
2. Navigate to the `complex` directory in the terminal.
3. Run `make` to compile.
4. Use `sudo make install` to install.
5. Run `CREATE EXTENSION complex;` in PostgreSQL.

## Testing
Use `complex-test.sql` for sample queries to test functionality.
