let mysql = require('mysql');
// let redis = require('redis');

function Connection() {
    this.mysql = mysql.createConnection({
            host: '120.79.175.123',
            user: 'db_expfield',
            password: 'CiRaxkG28H',
            port: '3306',
            database: 'db_expfield'
        });
    this.mysql.connect();
    // this.redis = redis.createClient(6379,'redis');
}

module.exports = Connection;
