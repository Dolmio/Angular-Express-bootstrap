chai = require('chai')
chai.should()
require("mocha-as-promised")()
require('../../server/db/db')('test_db')