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

> Note that the environment only will update stack/ directory
> All the user config or packages installed will remain across updates

## Customization

`TODO`

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

## TODO/WISH list

- Improve configuration documentation 
- Read `ini` config instead of write and read environment variables from node scripts
- Self-contained Git?
- Support more packages pre-requisites (others SCM, specific binaries)
- Performs all the setup and configuration from node scripts
- Better isolation in batch script variables 

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