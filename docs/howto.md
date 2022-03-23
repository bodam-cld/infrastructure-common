# Bodam fnfrastructure project how-to

## Prerequisites

## Tools

### submodules

either clone the project with
```
git clone --recurse-submodules
```
or if already cloned run the following in the project root:
```
make git-update-submodules
```


### asdf

* It is a CLI tool that can manage multiple language runtime versions on a per-project basis
* `.tool-versions` contains the list of managed tools
* [download and install](http://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
* once `asdf` is installed execute `make install-asdf-tools` to install and update required tools for this project

### direnv

* It is an extension for your shell. It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.
* installed by `asdf`
* hook `direnv` into your shell: https://direnv.net/docs/hook.html
* when you `cd` to a directory with an `.envrc` file (`environments/<environment>`) in it you are asked to allow loading those variables
  * issue `direnv allow` to do so
  
### AWS accounts and access

#### As individual admin user

* access keys to an IAM user with permissions to assume the admin role (see next step)
  * add an entry for each project to `~/.aws/credentials` like the following:
  ```
    [<projec name>-main_admin]
    iam_user: <your IAM user name as reminder>
    aws_access_key_id = <access key>
    aws_secret_access_key = <secret access key>
  ```
    *  where
       *  `<projec name>-main` is the name of the AWS account containing the IAM user
       *  `iam_user` is not an actual coniguration parameter but only a reminder for the user
    *  this profile name is expected to follow the naming convention (see below)
* assumable role with full (or the necessary level of) access to the destination account
  * add an entry for each environment to `environments/aws_config_<project name>` like the following:
  ```
    [profile <project>-<environment>_admin-role]
    role_arn=<role arn>
    source_profile=<project name>-main_admin
  ```
    * this file is part of the project therefore only needs to be created once
    * where `role arn` in the case of AWS Organization child accounts should be `arn:aws:iam::<account id>:role/<environment>-admin` (`arn:aws:iam::<account id>:role/OrganizationAccountAccessRole` for the first run when only that exists)

Verification and debugging:
  * to check if everything works as expected:
    * `cd environments/<environment>`
    * `echo $AWS_PROFILE` (direnv should have set the environment variable already to the admin role)
    * `aws sts get-caller-identity` should return the arn of the role mentioned above
  * if something is not right try the same command with your individual user:
    * `aws --profile <project name>-main_admin sts get-caller-identity`

#### MFA
- some roles (like production admin) might enforce the use of MFA (see `BODAM_AUTH_MFA_ENABLED` environment variable)
- in such a case a virtual MFA device need to be added to your IAM user
- get the MFA serial number arn from the AWS console or with cli: `aws --profile <project name>-main_admin iam list-mfa-devices --user-name <your IAM user name>`
- create the file `environments/.env` and add the `BODAM_AWS_MFA_ARN` variable as follows:
```
BODAM_AWS_MFA_ARN="arn:aws:iam::<main account id>:mfa/<your IAM user name>"
```
- `cd environments/<environment>` and you should be asked to run `aws_get_session.sh`


## Directory structure

- `common` - files shared and reused by different projects
- `commond/scripts` - shell scrtips
- `common/terraform/bodam` - local bodam module repo
  - use for local iterations and refer to these with a git url from terragrunt files
  - [Terragrunt complicates matters a bit](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#a-note-about-using-modules-from-the-registry)
- `environments/.env` - individual file for common variables (under gitignore)
- `environments/project_vars.hcl` - common terragrunt variables, all layers include this
- `environments/_env_common` - files shared by each env
- `environments/_env_common/terraform/project` - project specific terraform root modules to be used in `terragrunt.hcl`
- `environments/_env_common/terraform/bodam` - links to or contains the bodam module repo
  - this hack is necessary as `terragrunt` supports only one module source
- `environments/_env_common/terragrunt` - files to be linked as `terragrunt.hcl`
- `environments/<environment>` - each env has its own subfolder
- `environments/<environment>/.envrc` - entry point for `Direnv`
- `environments/<environment>/terraform` - Terragrunt(Terraform) configuration
- `environments/<environment>/terraform/core` - what is needed to provision the core infrastructure
- `environments/<environment>/terraform/app` - what is needed to be able to deploy various application services

## Outputs
  * app/serverless-common:
    * serverless_deployer_aws_iam_user_keys: user credentials to be used for CI/CD
