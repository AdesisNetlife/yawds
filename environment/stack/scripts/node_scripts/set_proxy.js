var util = require('./util')
var url = require('url')

var filepath = process.argv[2]

if (!filepath) {
  util.fail('File path argument required')
}

function getFile() {
	var uri
	var proxy = util.parseIni(filepath).proxy
	var variables = []
	var supported = [ 'http_proxy', 'https_proxy', 'no_proxy' ]
	
	if (proxy && proxy.user && proxy.password) {
		for (var name in proxy) {
			if (proxy.hasOwnProperty(name) && name in suported) {
				uri = url.parse(name)
				uri.auth = proxy.user + ':' + proxy.password
				variables.push(url.format(name))
			}
		}
	}
	return variables
}

util.echo(
	util.generateBatch(
		util.generateVars(
			util.parseIni(filepath)
		)
	)
)

util.exit(0)