# Node Offline Bundle

Boilerplate scripts to install a Node service offline on Windows or Linux.

## Explanation

This project is designed to make deploying a Node project to a machine that doesn't have internet access easy. It acccomplishes this through a series of scripts that download and compress a project's dependencies on a machine that has internet access, then decompresses them on the installation target that does not.

## Setup

Copy the `/scripts/deployment/` folder into your project. Then, copy the contents of the `scripts` section of `package.json`. Finally, add `bundle.tar.gz`, `bundle.zip`, and `bundle.json` to `.gitignore`.

## Usage

There are three steps to offline installation. First, bundle all dependancies in an environment that has an internet connection. Second, copy the entire project folder to the installation target machine. Third, decompress dependencies from the offline bundle.

On a machine that has internet access, `cd` into the project directory and execute:

```sh
npm run bundle
```

The `script-for-os` wrapper will automatically determine whether to run the PowerShell or Bash version of the script. All production dependencies will be populated and compressed into `bundle.tar.gz`. The version of the OS, npm, node, and all dependencies are saved in a `bundle.json`. On Windows, an additional `.zip` bundle is also created.

Copy the entire project folder to the installation target. Then, on that machine, execute:

```sh
npm run unbundle
```

This script will attempt to connect to the `npm` registry. If the connection is successful, it will execute `npm install --production`. If not, it checks for the presence of an offline dependency bundle. If the host machine's OS, release, or npm version don't match the bundle info archive, an error will be displayed.

On *nix systems, it uses `tar` to decompress the offline bundle and populate `node_modules`.

### Windows

Microsoft has shipped `tar.exe` with Windows 10 since version 1803 (April 2018). If Tar is installed, the `unbundle` script will check for tar and attempt to use it, if available. If not, it checks for the `Expand-Archive` PowerShell cmdlet (released with PowerShell 5.0 in February 2016) and attempt to use that to decompress the `.zip` archive instead. If neither are available, it will display an error asking the user to manually extract the dependency bundle.

## Example

This repository has a few dependencies defined in `package.json` as well as a small http server that relies on them in `/src/index.js`. To test the bundle / unbundle scripts, try them out here.

## License

MIT © Jesse Youngblood
