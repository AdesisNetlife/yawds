var url = require('url')
var series = require('async').series
var prompt = require('promptly')
var util = require('../util')
var writeIni = util.writeIni
var exists = util.exists
var exit = util.exit

var env = process.env
var store = {}
var filepath = process.argv[2]
var getInstallVar = util.envPartial('YAWDS_CONF_INSTALL') 
var getProxyVar = util.envPartial('YAWDS_CONF_PROXY') 

series([
	confirmProxy,
	promptHost,
	proxyAuth,
	promptUser,
	promptPassword,
	outputIni
])

function confirmProxy(done) {
	if (exists(getInstallVar('FORCE_PROXY'))) {
		return done()
	}
	prompt.confirm('Are you behind a Web proxy [Y/n]:', function (err, value) {
		if (!value) {
			exit()
		}
		done()
	})
}

function promptHost(done) {
	if (exists(getProxyVar('HTTP_PROXY')) || exists(getProxyVar('HTTPS_PROXY'))) {
		store.http_proxy = getProxyVar('HTTP_PROXY')
		store.https_proxy = getProxyVar('HTTPS_PROXY') || getProxyVar('HTTP_PROXY') 
		if (getProxyVar('NO_PROXY')) {
			store.node_proxy = getProxyVar('NO_PROXY')
		}
		return done()
	}
	
	function validUrl(string) {
		if (!(/^http[s]?/.test(string))) {
			throw new Error('Invalid url, enter it again')
		}
		return string
	}
	
	prompt.prompt('Enter the web proxy server:', { validator: validUrl }, function (err, value) {
		store.http_proxy = value
		store.https_proxy = value
		prompt.confirm('Do you want to define the "no_proxy" variable? [y/N]:', function (err, value) {
			if (value) {
				prompt.prompt('Enter the no_proxy hosts (comma separated): ', function (err, value) {
					store.no_proxy = value
					done()
				})
			} else {
				done()
			}
		})
	})
}

function proxyAuth(done) {
	if (getInstallVar('ASK_PROXY_AUTH') === '0') {
		return exit()
	}
	if (!exists(getInstallVar('ASK_PROXY_AUTH'))) {
		return done()
	}
	prompt.confirm('The web proxy requires authentication? [y/n]:', function (err, value) {
		if (!value) {
			return outputIni()
		}
		if (env['YAWDS_USER'] && env['YAWDS_PASSWORD']) {
			prompt.confirm('The proxy auth credentials for the proxy? [y/n]:', function (err, value) {
				if (value) {
					store.user = env['YAWDS_USER']
					store.password = env['YAWDS_USER']
				}
			})
		} else {
			done()
		}
	})
}

function promptUser(done) {
	prompt.prompt('Enter the proxy user name:', function (err, value) {
		store.user = value
		done()
	})
}

function promptPassword(done) {
	prompt.password('Enter your password:' , function (err, value) {
		store.password = value
		done()
	})
}

function outputIni() {
	writeIni(filepath, store, 'proxy')
	exit()
}