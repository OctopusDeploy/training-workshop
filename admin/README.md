# Admin Readme

## Prerequisites

### Terraform
You'll need Terraform tools installed to provision Octopus and Azure resources.

### Azure
To provision Azure resources using the local admin scripts, you'll need to be logged into Azure with an account that has rights on the `Octopus Commercial - Pre-production` subscription.
```
Connect-AzAccount
Set-AzContext -Subscription XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

### GitHub
You'll need repository write (contribute) access to this repo in order to generate the individualized student instructions that land in student branches.

### Local Configuration
To run/test locally, you'll need this local file (ignored by Git):
```
./admin/config.local.ps1
```

The file needs to contain these URLs and secrets:
```
$script:githubUrl = "{Octopus training GitHub repo URL}"
$script:octopusURL = "{Octopus training Cloud instance URL}"

$script:octopusKey = "API-XXXXXXXXXXXXXXXXXXXXXXXX"

$script:azSubscriptionId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$script:azTenantId = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$script:azUser = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
$script:azSecret = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

$script:slackUrl = "https://hooks.slack.com/services/XXXXXXXXX/XXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXX" #training-workshops
                                                     
$script:smtpServer = "smtp.gmail.com"

$script:fromAddress = "{your email address}"
$script:mailAccount = "{your email address}"
$script:mailSecret = "{your email account app login secret}"
```
Shared secrets can be found in the following LastPass item: `Shared-Sales-Ops/Octopus Training Workshop shared config values`

# Important Scripts

The follow scripts are the important ones for provisioning and de-provisioning students for the workshop.

## `provision-student.ps1`
Provisioning performs actions on a cloned Git repo and purges the directory so it needs to be run outside of this repo working directory.

Run the scripts from a directory called `workspace` that's next to the checkout root of this repo. (There's a safety check if you run it from a directory other than `workspace`.)

Example directory structure:
```
./repo  <== this repository
./workspace  <== working directory
```

From a command terminal in this directory:
```
mkdir ..\..\workspace
cd ..\..\workspace
```

```
..\repo\admin\provision-student.ps1 -studentName "{student name}" -studentEmail "{student email}"
```

Run the command with no student information to generate a random student (useful to create a clean student to use when delivering the workshop).
```
..\repo\admin\provision-student.ps1
```
Created student has a name like `Z-Student` for easy locating.

## `list-students.ps1`
This displays all the students provisioned as well as commands to deprovision them and other possibly useful commands. Student data is retrieved from Azure blob storage and cached locally.

## `deprovision-student.ps1`
This will delete an individual student's space and any Azure resources provisioned for them. Use `list-students.ps1` to list out the students and their slugs.
```
deprovision-student.ps1 -studentSlug "student slug"
```