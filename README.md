# Wolf Software Inno Setup Buildtools

Helps to build Inno-Setup installer packages on Azure Devops build pipelines.

For hints to use see [overview](./overview.md)



## To build the tools itself

### You need the following tools:

#### NodeJS

First, you need to install NodeJS. You can install it from [here](https://nodejs.org/). This will also install NPM for you to work with. You can leave the default options in the wizard.

We have tested the build with version 16.13.0

#### TFX

By installing TFX, you are able to create a package out of your files. Create it by using the following command in a PowerShell prompt:

```powershell
npm install -g tfx-cli
```

### Build

```powershell
tfx extension create --manifest-globs vss-extension.json
```

### Publish the task

All set, let’s publish our custom Azure DevOps pipeline task for  PowerShell to the market place, so we can make it available in our  organizations.
In your browser, open the [Market place.](https://marketplace.visualstudio.com/manage?WT.mc_id=AZ-MVP-5003674)

See also [Create a custom Azure DevOps pipeline task for PowerShell](https://4bes.nl/2021/02/21/create-a-custom-azure-devops-powershell-task/)

