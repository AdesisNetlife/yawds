# yawds [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/AdesisNetlife/yawds/trend.png)](https://bitdeli.com/AdesisNetlife/yawds "Bitdeli Badge")

> Yet another Windows development stack environment for unlucky Web developers

<div style="text-align: center">
  <a href="https://sourceforge.net/projects/yawds/files/latest/download">
   <img width="120" src="http://oi62.tinypic.com/206zmud.jpg" />
  </a>
</div>

## About

A modern, complete, portable and configurable Web development software stack environment for Windows

If you are a lucky developer, you should use [FrontStack](https://github.com/frontstack/frontstack) instead

## Features

- Easy to use
- Fully portable
- Automatic packages provisioning
- Configurable for your specific project runtime scenario
- Complete software stack for modern Web development and testing
- OS dependencies checker
- Auto-configured based on your existent environment variables
- Great isolation from the OS
- Support for environment updates with keeping all the user stuff
- Support both 32 and 64 bits OS
- Support Windows XP/Server 2003 or greater
- Easy to use from continous integration servers and deployment environments

## Installation

1. [Download][1] the latest version

2. Uncompress the `zip` wherever you want

3. Run `start.cmd`

4. Put your code in the `workspace/` directory

5. Start coding!

## Software stack

- [Node.js][3]
- [Ruby][4]
- [PhantomJS][5]
- [SlimerJS][6]
- [CasperJS][7]

Aditionally, the following tools binaries are also provided

- cURL
- Putty
- SFTP client
- 7zip
- Bash with *UNIX binaries (port to Win32)

See [PACKAGES][2] file for more information about versions

## Packages

By default, the following packages will be installed in the provisioning process

- bower@latest 
- yeoman@latest
- grunt-cli@latest
- compass@latest

You can configure it from the `package.ini` file

#### Custom packages

Aditionally, if you need to have custom packages that are not avalible from
npm or gem, you should put it in `packages/`. 

If your package has a `bin/` directory, it will be automatically available from %PATH%

Aditionally, if your package need to define specific environment variables, 
you should simply create a file called `_setenv.bat` in the root folder of your package

## Updates

You can easily uptade the whole software stack automatically when a new version is available

By default, `yawds` checks for new versions on each start, 
however you can do it manually running `update.cmd`

> Note that the environment only will update stack/ directory. 
> All the user configuration or packages installed will remain between updates

## Use the isolated environment context

To use the isolated specific environment context variables from a continous integration server
or for specific purposes, you should simply
call from your batch the `use_env.bat` script, located in `~\stack\scripts\`

## Make it yours

If you are a devops guy or an architect, `yawds` allows you to provide and easily configure a development environment for the projects you happy owns

You can provide a pre-configured environment for a specific execution environment,
for example, setting a pre-defined http proxy environment variable or custom packages installation 
according to your project  packages dependencies

### Create your custom environment

1. Clone/fork this repository

2. [Download][1] the latest version

3. Unzip it in `environment\` overriding (or erase it, preferably) the directory contents 

4. Customize `environment.ini` and `packages.ini` (both are commented in-line)

5. Run `scripts\release.bat`

You may customize `VERSION` and `CHANGELOG` files with you own project information

#### Configuration files

There are two configuration files you can adapt to your needs: `environment.ini` and `packages.ini`

Note that you should comment or remove the options you do not need

##### environment.ini

```ini
[general]
name = YAWDS development environment
shortname = YAWDS
prompt = [yawds %YAWDS_VERSION%] $P $_$G$S
console_color = 2

[requisites]
;; requires git must be installed in the system
git = true

[install]
;; display a custom welcome message on install process
message = Welcome to YAWDS development environment
;; set true if the user computer need to be authenticated 
;; to access to network resources, like source repositories
force_auth = false
;; set true if the user computer will be always behind a Web proxy
force_proxy = false

[install.ask]
;; ask the user about his network auth credentials
auth = false
auth_confirm = Do you want to enter your <company> credentials?
auth_username = Please, enter your <company>'s user credentials
;; ask the user about proxy auth credentials
proxy_auth = true
;; ask to configure git config (user, email and credentials storage)
git = true

[proxy]
;; from this section you can force set by default the web proxy 
;; configuration, avoiding to ask the user to enter it
http_proxy=http://proxy:3128
https_proxy=http://ssl.proxy:3128
no_proxy=.company,.google.com

[update]
enabled = true
check_url = https://raw.github.com/AdesisNetlife/yawds/master/environment/stack/VERSION
check_url_auth = false
check_on_startup = true

[scripts]
;; custom execution scripts, with relative path from stack/ directory
after_start=scripts\post_start.bat
after_install=scripts\post_install.bat
```

##### package.ini

Tell to `yawds` what should be instaled during the environment 
provisining process.

Example configuration file:
```ini
;; define the relative path for node or ruby packages installtion
;; you probably do not need to change this option
install_dir = packages

[provision]
;; enable/disable packages provisioning
enabled = true
;; this option allows to force to update Node/Ruby packages 
;; from latest versions on each environment start
keep_updated = false

[npm]
bower = latest
grunt-cli = latest
yo = latest

[gem]
compass = latest
```

You can aditionally create a `provision.lock` file in the `stack\` directory if you want
to permanently disable the provisioning or packages update process 

#### Updating the software stack

`yawds` provides support for automatic software stack updates, checking new versions from 
a remote `ini` file accesible via HTTP.
When a new version is available, `yawds` ask the user to process with the update 

You should create a well-formed `ini` like a version manifest file, 
and make it available from a HTTP server

The file must be called `VERSION` and it must exists in the `stack/` folder

Here is a complete file example with the supported values:

```ini
version = 0.1.0
download = http://downloads.mycompany.com/environment-latest.zip
release_notes_url = https://downloads.mycompany.com/environment-release-notes.txt
download_auth = false
post_update_script = scripts\post_update.bat
```

> Only `zip` and `7z` compression formats are supported

## Possible troubles

#### Cannot find global installed packages

If you cannot use global installed packages, like grunt or bower, you must check if you have 
`.npmrc` in your user home directory (`%USERPROFILE%`) and then remove the `prefix` option.

This trouble seems to be related to npm, since it tries to resolve npmrc config files 
in common paths like user home directory. 
Yawds forces to define the `userconfig` config value on each environment start, 
which defines the npm user config path, however npm always looks in the user home and load this config.

You can't have cross-enviroment npm config options at this time, sorry!
It was created the [#4](https://github.com/AdesisNetlife/yawds/issues/4) issue about this trouble

## Issues

If you experiment some issue, please feel free to [open][9] an Github issue reporting it

Note that `yawds` is still a beta version 

## To Do/Wish list

- Improve configuration documentation 
- Read `ini` config instead of write and read environment variables from node scripts
- Self-contained Git?
- Support more packages pre-requisites (others SCM, specific binaries)
- Performs all the setup and configuration from node scripts
- Better isolation in batch script variables 

## Contributors

[Tomás Aparicio](https://github.com/h2non)

## License

Copyright 2014 Adesis Netfile S.L and contributors

Released under [MIT][8] license

[1]: https://sourceforge.net/projects/yawds/files/latest/download
[2]: https://github.com/adesisnetlife/yawds/blob/master/environment/stack/PACKAGES.md
[3]: http://nodejs.org
[4]: http://rubylang.org
[5]: http://phantomjs.org
[6]: http://slimerjs.org
[7]: http://casperjs.org
[8]: http://opensource.org/licenses/MIT
[9]: https://github.com/AdesisNetlife/yawds/issues/new