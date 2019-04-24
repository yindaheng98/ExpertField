let express = require('express');
let router = express.Router();
let con = require('../controllers/connections');

/* GET users listing. */
router.get('/:id', function (req, res, next) {
    let id = req.params.id;
    let SQL = 'SELECT 创建时间 as `time`, 试验田名称 as `name`, 试验田描述 as `description` WHERE ID=?';
    con.mysql.query(SQL, [id], function (error, results, fields) {
        if (error) throw error;
        if(results.length<1){
            res.send(JSON.stringify({state:'error',info:'no info'}));
            return;
        }
        results[0].format=JSON.parse(results[0].format);
        res.send(JSON.stringify(results[0]));
    });
});

router.use('/', function (req, res, next) {
    res.send(JSON.stringify({state:'error',info:"no input"}));
});

module.exports = router;
