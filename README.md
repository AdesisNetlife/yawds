# yawds

> Yet another Windows development stack environment for unlucky Web developers

`still a beta version`

## About

A modern, complete, portable and configurable Web development stack environment for the f*ing Windows OS

If you are a lucky developer, you should use [FrontStack](https://github.com/frontstack/frontstack) instead

## Features

- Easy to use and install
- Fully portable
- Automatically packages provisioning
- Configurable (you can configure it for your projects)
- Complete software stack for modern Web development and testing
- OS dependencies checker
- Fully isolated from the OS
- Support for environment updates
- Support both 32 and 64 bits OS
- Support Windows XP or greater
- Easy to use from continous integration servers

## Installation

1. [Download][1] the latest version

2. Uncompress the `zip` wherever you want

3. Run `start.cmd`

4. Put your code in the `workspace/` directory

5. Start coding!

## Update

You can easily uptade the whole software stack automatically when a new version is available

To update it, you just need to run `update.cmd`

> Note that the environment only will update stack/ directory. 
> All the user configuration or packages installed will remain across updates

## Customization

If you are a devops or an architect, `YAWDS` allows you to configure the environment
for your own projects.

You can provide a pre-configured environment for a specific execution environment,
for example, setting a pre-defined http proxy

### Create your custom environment

1. Clone/fork this repository

2. [Download][1] the latest version

3. Unzip it in `environment/` overriding the directory in the cloned repository

4. Customize `environment.ini` and `packages.ini` (both are commented in-line)

5. Run `scripts\release.bat`

Aditionally, you should cuStomize `VERSION` and `CHANGELOG` files with you own project information

`TODO: create an utility to automate this process`

#### Update

`YAWDS` provides support for automatic software stack updates, checking new versions from 
a remote `ini` file accesible via HTTP

When a new version exists, `YAWDS` ask the user to process with the update 

You should create a well-formed `ini` file like a version manifest file, 
and make it avaiable from a HTTP server

Here is a complete file example with the supported values:
```ini
version=0.1.0
download=http://downloads.mycompany.com/environment-latest.zip
release_notes_url=https://downloads.mycompany.com/environment-release-notes.txt
download_auth = false
post_update_script=scripts\post_update.bat
```

## Software stack

- [Node.js][3]
- [Ruby][4]
- [PhantomJS][5]
- [SlimerJS][6]
- [CasperJS][7]

Aditionally, the following tools binaries are provided

- cURL
- Putty
- SFTP client
- 7zip
- Bash with *UNIX binaries (port to Win32)

See [PACKAGES][2] file for more information about versions

## Issues

If you experiment some issue, please feel free to [open][9] an Github issue reporting it

Note that `YAWDS` still beta version 

## TODO/WISH list

- Improve configuration documentation 
- Read `ini` config instead of write and read environment variables from node scripts
- Self-contained Git?
- Support more packages pre-requisites (others SCM, specific binaries)
- Performs all the setup and configuration from node scripts
- Better isolation in batch script variables 
- Create a development kit for enviroment customization

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