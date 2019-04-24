let mysql = require('mysql');

function Connection() {
    this.mysql = mysql.createConnection({
            host: 'localhost',
            user: 'ExperimentData',
            password: 'ExperimentData',
            port: '3306',
            database: 'ExperimentData'
        });
    this.mysql.connect();
    this.redis = function () {};
}

module.exports = new Connection();
