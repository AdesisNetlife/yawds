var fs = require('fs')
var path = require('path')
var series = require('async').series
var prompt = require('promptly')
var util = require('../util')

var store = {}
var filepath = process.argv[2]
var prefix = process.argv[3]

series([
	promptUser,
	promptPassword,
	output
])

function promptUser(done) {
	prompt.prompt('Enter your user name:', function (err, value) {
		store.user = value
		done()
	})
}

function promptPassword(done) {
	prompt.password('Enter your password (masked):' , function (err, value) {
		store.password = value
		done()
	})
}

function output() {
	try {
		fs.writeFileSync(
			path.normalize(filepath),
			util.generateBatch(
				util.generateVars(
					store,
					prefix
				)
			)
		)
	} catch (e) {
		util.echo('Error writting the file:', e.message)
		util.exit(1)
	}
	util.exit(0)
}
