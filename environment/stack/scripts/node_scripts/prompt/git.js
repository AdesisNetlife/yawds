var series = require('async').series
var prompt = require('promptly')
var util = require('../util')
var writeIni = util.writeIni
var exists = util.exists
var exit = util.exit

var store = {}
var filepath = process.argv[2]
var envVar = util.envPartial('YAWDS_CONF') 

series([
	confirmGit,
	promptUser,
	promptEmail,
	promptCredentialStore,
	outputIni
])

function confirmGit(done) {
	if (!exists(envVar('REQUISITES_GIT'))) {
		return exit()
	}
	if (!exists(envVar('INSTALL_ASK_GIT'))) {
		return exit()
	}
	prompt.confirm('Do you want to configure Git? [Y/n]:', function (err, value) {
		if (!value) {
			exit()
		}
		done()
	})
}

function promptUser(done) {
	prompt.prompt('Enter your user name for Git (e.g: Philip Morris):', function (err, value) {
		store.username = value
		done()
	})
}

function promptEmail(done) {
	prompt.password('Enter your user email for Git (e.g: me@company.net):' , function (err, value) {
		store.email = value
		done()
	})
}

function promptCredentialStore(done) {
	prompt.confirm('Do you want to use Git credentials storage [Y/n]:' , function (err, value) {
		if (!value) {
			store.credentials = 'true'
			outputIni()
		}
		done()
	})
}

function outputIni() {
	writeIni(filepath, store, 'git')
	exit()
}
