# Wolf Software Inno Setup Tools

Tools, that help you to build Inno Setup scripts during build pipeline.

# Installer Task

Acquires a specific version of Inno Setup from the internet and adds it to the PATH. Use this task to install Inno Setup for subsequent tasks.

* **Version** - Version that should be installed. You can find a complete list [here](https://jrsoftware.org/isdlold.php). Version is required.

# Build Task

This build task compile an Inno Setup script file (*.iss).

* **Version** - Version cached in Installer task. Version is required.

* **File** - File to compile (*.iss)*).

