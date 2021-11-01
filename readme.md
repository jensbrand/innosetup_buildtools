# Wolf Software Inno Setup Tools

Tools, that help you to build Inno Setup scripts during build pipeline.

# Installer Task

Acquires a specific version of Inno Setup from the internet and adds it to the PATH. Use this task to install Inno Setup for subsequent tasks.

* **version** - Version that should be installed. You can find a complete list [here](https://jrsoftware.org/isdlold.php). Version is required.

# Build Task

This build task compiles an Inno Setup script file (*.iss). Optionally it can sign the installer (and also the uninstaller) with a digital certificate. When Setup has a valid digital signature, users will not see an "unidentified program" warning when launching it.

* **version** - Version cached in Installer task. Version is required.
* **file** - File to compile (*.iss)*). File is required.

The following Parameters are only required, if you wish to sign your installer with a digital certificate.

* **secureFileId** - This is the name of the secure file which contains the authenticode certificate to use. 
* **signCertPassword** - The password for the certificate file.
* **timeServer** - Server-Url for timestamp-server. Example: http://timestamp.comodoca.com/?td=sha256. 
* **signToolName** - This is the name of the Inno Setup signtool to define. You must define this name in your setup-script with the parameter [Setup]: SignTool (see: https://jrsoftware.org/ishelp/topic_setup_signtool.htm) and the name must be identical to this one.

