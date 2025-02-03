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

#### GitHub Security Setup


1. Enable two-factor authentication (2FA) on your GitHub account using one of the methods 
   described [here](https://docs.github.com/en/authentication/securing-your-account-with-two-factor-authentication-2fa/configuring-two-factor-authentication)

2. Create a Personal Access Token (PAT):

- Go to github.com → Settings → Developer Settings
- Create new token (classic)
- Select scopes: `repo`, `workflow`
- Save the token (you'll need it in the next step)
     
When you run `renv::restore()` in the next section, Windows will prompt for GitHub 
credentials:

- Enter your GitHub username
- Use your PAT as the password

This is a one-off steo and Git Credential Manager will securely store these credentials for future use. Do not 
store your PAT in the `.Revniron` file.

#### Set up the reproducible project environment with `renv`

Once your GitHub authentication is set up:

1. Install renv: `install.packages("renv")`
2. Restore project environment: `renv::restore()`

This will install all required packages in an isolated environment including:

- `dittodb` (for database mocking)
- `UMARaccessR` (for database access functions)

#### Environment setup based on database access

Set up your environment based on your database access:

1. For the CE team (using the mock database):
```r
file.copy(".Rprofile.CE", ".Rprofile", overwrite = TRUE)
```
2. For the UMAR team (direct database access):
```r
file.copy(".Rprofile.UMAR", ".Rprofile", overwrite = TRUE)
file.copy(".Renviron.template", ".Renviron", overwrite = TRUE)
```
Then edit `.Renviron` with your database credentials. This file is not tracked by git.


### Usage example

Go to `R\example.R` and run the code. It demonstrates:

- Connecting to mocked database
- Retrieving multiple time series
- Joining results into a single dataframe