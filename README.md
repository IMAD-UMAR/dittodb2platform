# dittodb2platform

[![R Version](https://img.shields.io/badge/R-%3E%3D%204.0-blue)](https://www.r-project.org/)
[![renv managed](https://img.shields.io/badge/renv-managed-blue)](https://rstudio.github.io/renv/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Mock database setup using `dittodb` to mock access to the IMAD-UMAR *platform* database.

This repo demonstrates the use of database querying functions from the `UMARaccessR` 
package to retrieve time series data from the IMAD-UMAR *platform* database.

Given that the database is only accessible on the internal institute network, we
use `dittodb` to mock database access. A selection of timeseries was made 
and the database queries recorded, the outputs of which are stored in `fixtures\platform`. 

Using the `mock_db_call` wrapper function the same queries can then be run
on any location and will return the same outputs as they would with direct 
database access. 


### Setup

#### Requirements

- R >= 4.0
- RStudio (recommended)
- Git credentials manager

#### Installation

1. Clone this repository
2. Open RStudio project file `dittodb2platform.Rproj`

#### GitHub Authentication

This project requires access to non-CRAN packages. You will need:

1. A GitHub Personal Access Token (PAT) with appropriate permissions:
 
- Go to github.com and click your profile photo → Settings → Developer Settings → Personal Access Tokens
- Create new token (classic)
- Select scopes: `repo`, `workflow`
- Copy the generated token

2. Store your token using Git Credential Manager (recommended) or manually in .Renviron


#### Set up the reproducible project environment with `renv`

Once your GitHub authentication is set up:

1. Install renv: `install.packages("renv")`
2. Restore project environment: `renv::restore()`

This will install all required packages in an isolated environment including:

- `dittodb` (for database mocking)
- `UMARaccessR` (for database access functions)

### Usage Example

Go to `R\example.R` and run the code. It demonstrates:

- Connecting to mocked database
- Retrieving multiple time series
- Joining results into a single dataframe