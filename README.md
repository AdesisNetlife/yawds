# yawds

> Yet another Windows development stack environment for unlucky Web developers

`still a beta version`

## About

A modern, complete, portable and configurable Web development software stack environment solution for Windows

If you are a lucky developer, you should use [FrontStack](https://github.com/frontstack/frontstack) instead

## Features

- Easy to use
- Portable
- Automatic packages provisioning
- Fully configurable for your projects
- Complete software stack for modern Web development and testing
- OS dependencies checker
- Auto-configured based on your existent environment variables
- Great isolation from the OS
- Support for environment updates with keeping all the user stuff
- Support both 32 and 64 bits OS
- Support Windows XP or greater
- Easy to use from continous integration servers and deployment environments

## Installation

1. [Download][1] the latest version

2. Uncompress the `zip` wherever you want

3. Run `start.cmd`

4. Put your code in the `workspace/` directory

5. Start coding!

## Packages

By default, the following packages will be installed in the provisioning process

- bower@latest 
- yeoman@latest
- grunt-cli@latest
- compass@latest

You can configure it from the `package.ini` file

## Update

You can easily uptade the whole software stack automatically when a new version is available

By default, `yawds` checks for new versions on each start, 
however you can do it manually running `update.cmd`

> Note that the environment only will update stack/ directory. 
> All the user configuration or packages installed will remain between updates

## Customization

If you are a devops guy or an architect, `yawds` allows you to provide and easily configure a development environment for the projects you own

You can provide a pre-configured environment for a specific execution environment,
for example, setting a pre-defined http proxy or packages provisioning

### Create your custom environment

1. Clone/fork this repository

2. [Download][1] the latest version

3. Unzip it in `environment\` overriding (or erase it, preferably) the directory contents 

4. Customize `environment.ini` and `packages.ini` (both are commented in-line)

5. Run `scripts\release.bat`

Aditionally, you may customize `VERSION` and `CHANGELOG` files with you own project 
information and customized version

`TODO: create a dev kit to automate the above`

#### Configuration files

There are two configuration files: `environment.ini` and `packages.ini`

Here are both files in-line commented

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
message = Welcome to YAWSD development environment
;; set true if the user computer must be authenticated 
;; to access to network resources, like source repositories
force_auth = false
;; set true if the user computer will be behind a Web proxy
force_proxy = false

[install.ask]
;; ask the user about his network auth credentials
auth = false
;auth_confirm = Do you want to enter your <company> auth credentials?
;auth_username = Please, enter your <company>'s user credentials
;; ask the user about proxy auth credentials
proxy_auth = true
;; ask to configure git config (user, email and credentials storage)
git = true

[proxy]
;; from this section you can set by default the web proxy 
;; configuration, avoiding to ask the user to enter it
;http_proxy=http://proxy:3128
;https_proxy=http://ssl.proxy:3128
;no_proxy=.company,.google.com

[update]
enabled = true
check_url = https://raw.github.com/AdesisNetlife/yawds/master/environment/stack/VERSION
check_url_auth = false
check_on_startup = true

[scripts]
;; custom execution scripts, with relative path from stack/ directory
;after_start=scripts\post_start.bat
;after_install=scripts\post_install.bat
```

##### package.ini

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

#### Update

`yawds` provides support for automatic software stack updates, checking new versions from 
a remote `ini` file accesible via HTTP.
When a new version is available, `yawds` ask the user to process with the update 

You should create a well-formed `ini` like version manifest file, 
and make it avaiable from a HTTP server

The file must called `VERSION` and it must exists in the `stack/` folder

Here is a complete file example with the supported values:

```ini
version = 0.1.0
download = http://downloads.mycompany.com/environment-latest.zip
release_notes_url = https://downloads.mycompany.com/environment-release-notes.txt
download_auth = false
post_update_script = scripts\post_update.bat
```

> Only `zip` and `7z` compression formats are supported

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

## Issues

If you experiment some issue, please feel free to [open][9] an Github issue reporting it

Note that `yawds` is still a beta version 

## TODO/WISH list

- Improve configuration documentation 
- Read `ini` config instead of write and read environment variables from node scripts
- Self-contained Git?
- Support more packages pre-requisites (others SCM, specific binaries)
- Performs all the setup and configuration from node scripts
- Better isolation in batch script variables 
- Create a devkit for enviroment customization automation

## License

Copyright (C) 2013 Adesis Netfile S.L

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