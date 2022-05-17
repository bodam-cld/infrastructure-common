# Development related notes

## Terragrunt and Terraform

Fundamentally there are two types of Terraform modules in *Bodam* projects. ([Terragrunt complicates matters further a bit](https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#a-note-about-using-modules-from-the-registry))


### root modules
Directly called via a module repo from *Terragrunt* like this:
```
source = "git::git@github.com:/bodam-cld/terraform-modules.git//core-aws?ref=v0.4.0"
```

In order to work with a local copy one can simply override the module source for the specific *Terragrunt group*:
```
cd terraform/core
terragrunt apply --terragrunt-source ~/bodam/terraform-modules//core-aws/
```

This is simple and quick but the rest of the module calls would still remain the original git url source.

Another option is to use `terragrunt run-all` which has a side effect of combining the source paths:
- clone module repo to _terraform/_dev
- `export TERRAGRUNT_SOURCE="$(realpath  ~/bodam/vulkaza/infrastructure/environments/_terraform)"`
- `export BODAM_DEV=true`
- `terragrunt run-all plan`
- (don't forget to unset these variables if you need to switch back)


### proxy modules

*Terragrunt* calls a *local module*:
```
source = "${get_repo_root()}/environments/_terraform//service-shopify/"
```

In these local proxy modules unfortunately Terraform does not allow variables in the `source`. However by commenting out the preset dev source (something like `source = "../_dev/terraform-modules/ecs-service"`) one can switch to the local version.
