var util = require('./util')

var filepath = process.argv[2]

if (!filepath) {
  util.fail('File path argument required')
}

function generateCode() {
	var statements = []
	var config = util.parseIni(filepath)

	function packageInstall(type) {
		var lines = []
		var packages = config[type]

		util.each(packages, function (pkg, version) {
			switch (type) {
			case 'npm':
				lines.push('CALL npm install -g ' + pkg + '@' + (version ? version : 'latest'))
				break;
			case 'gem':
				lines.push('CALL gem instal ' + pkg +  (version && version !== 'latest' ? ' -v ' + version : ''))
				break;
			}
		})

		statements = statements.concat(lines)
	}

	['npm', 'gem'].forEach(packageInstall)

	return statements
}

util.echo(
	util.generateBatch(
		generateCode(),
		true
	)
)

util.exit(0)