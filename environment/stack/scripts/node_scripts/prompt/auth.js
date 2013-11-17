var series = require('async').series
var prompt = require('promptly')
var util = require('../util')
var writeIni = util.writeIni
var exists = util.exists
var exit = util.exit

var store = {}
var filepath = process.argv[2]
var authVar = util.envPartial('YAWDS_CONF_INSTALL') 

series([
	confirmAuth,
	promptUser,
	promptPassword,
	outputIni
])

function confirmAuth(done) {
	if (exists(authVar('FORCE_AUTH'))) {
		return done()
	}
	if (!exists(authVar('ASK_AUTH'))) {
		return exit()
	}
	prompt.confirm(authVar('AUTH_CONFIRM') || 'Do you want to enter auth credentials [Y/n]:', function (err, value) {
		if (!value) {
			exit()
		}
		done()
	})
}

function promptUser(done) {
	prompt.prompt(authVar('AUTH_USERNAME') || 'Enter your user name:', function (err, value) {
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

function outputIni(done) {
	writeIni(filepath, store, 'auth')
	done()
	exit()
}
