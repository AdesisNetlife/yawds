var util = require('./util')

var filepath = process.argv[2]
var subprefix = process.argv[3]

if (!filepath) {
  util.fail('File path argument required')
}

util.echo(
	util.generateBatch(
		util.generateVars(
			util.parseIni(filepath),
			subprefix
		)
	)
)

util.exit(0)