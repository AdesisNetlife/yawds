# yawds

> Yet another Windows development stack environment for unlucky Web developers

`work still in process`

## About

A modern and portable Web development stack environment for the f*ing Windows OS

If you are a lucky developer, you should use [FrontStack](https://github.com/frontstack/frontstack) instead of YAWDS

## Features

- Easy to use and install
- Fully portable
- Automatically packages provisioning
- Configurable (you can adapt it for your projects escenarios)
- Complete software stack for modern Web development
- OS dependencies checker
- Full isolation from the OS
- Support for updates
- Supports both 32 and 64 bits OS
- Supports Windows XP or greater
- Easy to use from continous integration servers

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

## Installation

1. [Download][1] the latest version

2. Uncompress the `zip` wherever you want

3. Run `start.cmd`

4. Start coding!

## Customize it for your project

`TODO`

## TODO/WISH list

- Improve configuration documentation 
- Read `ini` config instead of write and read environment variables from node scripts
- Self-contained Git?
- Support more packages pre-requisites (others SCM, specific binaries)
- Performs all the setup and configuration from node scripts
- Better isolation for environment variables

[1]: https://sourceforge.net/projects/yawds/files/latest/download
[2]: https://github.com/adesisnetlife/yawds/blob/master/environment/stack/PACKAGES.md
[3]: http://nodejs.org
[4]: http://rubylang.org
[5]: http://phantomjs.org
[6]: http://slimerjs.org
[7]: http://casperjs.org
