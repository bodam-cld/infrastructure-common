# AWS

## Accounts and links

| Account name | Account Id | Root user | Parent | Console URL | Assume admin [^1] |
|--------------|------------|-----------|--------|-------------|------------------------|
| -main [^2] |  |  |  | [Console](https://aws.amazon.com) |  |

## Access control

* child accounts are accessed via cross account trust relationships
  * IAM users in the main account are allowed to assume various roles based on group memberhips


## How-to

- log in to the *main* account with the Console link (note account name in the top right corner of the AWS Console)
- you should be the member of one of the role groups (other than users) to be able to assume (switch to) another role in another account (for instance the *testing-admin* role in the *testing* account)
- click on the Assume link in the row of e.g. the *testing* account in the table above, then just pick a colour and accept everything
  - note that this switch will be reflected in the top right corner (where you will also have quick access to recent roles)

**MFA**: pls set up MFA for your personal user in the *main* account
  * watch https://www.youtube.com/watch?v=BzllYQluoJw for help (Google Authenticator is recommened but your mileage may vary)

### Groups

|group name|description|
|--|--|
| users | everyone should be a member, allow to self manage keys, password, MFA, view only access at resource level |
| super-admins | allowed to assume any roles in any account, read only access to billing in the main account |
| ```<environment```-admins | allowed to assume role ```<environment name>-admin``` in the matching target account |
| ```<environment```-powerusers | allowed to assume role ```<environment name>-poweruser``` in the matching target account |
| ```<environment```-readonly | allowed to assume role ```<environment name>-readonly``` in the matching target account |

### Roles

* **admin**: have full access (god mode) and can delegate permissions to every service and resource in AWS
  * AdministratorAccess https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_administrator
* **poweruser**: are allowed all actions for all AWS services and for all resources except AWS Identity and Access Management and AWS Organizations
  * PowerUserAccess https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_developer-power-user  
* **readonly**: can view a list of AWS resources and basic metadata in the account across all services, cannot read resource content or metadata that goes beyond the quota and list information for resources nor can decrypt secrets
  * ViewOnlyAccess https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_job-functions.html#jf_view-only-user

more about roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use.html

#### Note
The target role name in the assume link combined with the account id can be used to reconstruct the role arn: `arn:aws:iam::<id>:role/<role>`_
  
## Footnotes

[^1]: Log in with your personal IAM user to the _main_ account and then navigate to one of these _assume role_ links
[^2]: Make sure to enable MFA for your individual IAM user in the main account
