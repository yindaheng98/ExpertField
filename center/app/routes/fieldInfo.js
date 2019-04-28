let express = require('express');
let router = express.Router();
let Connection = require('../controllers/connections');
let con=null;

/* GET users listing. */
router.get('/:id', function (req, res, next) {
    if(con==null)con=new Connection();//这么写是因为这个脚本初始化的时候隔壁mysql容器还没启动好
    let id = req.params.id;
    let SQL = 'SELECT 创建时间 as `time`, 试验田名称 as `name`, 试验田描述 as `description` FROM 试验田 WHERE ID=?';
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
