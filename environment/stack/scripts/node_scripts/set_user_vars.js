var util = require('./util')

var filepath = process.argv[2]
var section = process.argv[3]

if (!filepath) {
  util.fail('File path argument required')
}

if (!section) {
  util.fail('Section argument required')
}

util.echo(
	util.generateBatch(
		util.generateVars(
			util.parseIni(filepath)[section],
			'user' + '_' + section
		)
	)
)

util.exit(0)