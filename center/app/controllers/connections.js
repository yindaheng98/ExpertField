let mysql = require('mysql');
// let redis = require('redis');

function Connection() {
    this.mysql = mysql.createConnection({
            host: 'web',
            user: 'ExperimentData',
            password: 'ExperimentData',
            port: '3306',
            database: 'ExperimentData'
        });
    this.mysql.connect();
    // this.redis = redis.createClient(6379,'redis');
}

module.exports = new Connection();
