var util = require('./util')
var url = require('url')

var filepath = process.argv[2]

if (!filepath) {
  util.fail('File path argument required')
}

function getHttpProxyVariables() {
	var uri
	var proxy = util.parseIni(filepath).proxy
	var variables = []
	var supported = [ 'http_proxy', 'https_proxy', 'no_proxy' ]
	
	if (proxy) {
		for (var name in proxy) {
			if (proxy.hasOwnProperty(name) && supported.indexOf(name) !== -1 && proxy[name]) {
				if (name === 'no_proxy') {
					variables.push(name + '=' + proxy[name])
					continue;
				}
				uri = url.parse(proxy[name])
				if (!uri.auth && proxy.user && proxy.password) {
					uri.auth = proxy.user + ':' + proxy.password
				}
				variables.push(name + '=' + url.format(uri))
			}
		}
	}
	return variables
}

util.echo(
	util.generateBatch(
		getHttpProxyVariables()
	)
)

util.exit(0)