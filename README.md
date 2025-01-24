# dittodb2platform

Mock database setup using `dittodb` to mock access to the IMAD *platform* database.


### Setup

#### GitHub Authentication
This project requires access to private GitHub repositories. You will need:

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

