let express = require('express');
let router = express.Router();
let Connection = require('../controllers/connections');
let con=null;

/* GET users listing. */
router.get('/:id', function (req, res, next) {
    if(con==null)con=new Connection();//这么写是因为这个脚本初始化的时候隔壁mysql容器还没启动好
    let id = req.params.id;
    let SQL = "SELECT e_f.试验田ID AS 'field_id', e_f.试验ID  AS 'exp_id', e.* FROM 试验_试验田 e_f RIGHT JOIN 试验 e ON e_f.试验ID = e.ID WHERE e_f.试验田ID = ?;";
    con.mysql.query(SQL, [id], function (error, results, fields) {
        if (error) throw error;
        if(results.length<1){
            res.send(JSON.stringify({state:'error',info:'no info'}));
            return;
        }
        results.forEach(e => {
            e.format = JSON.parse(e.format);
        });
        res.json(JSON.stringify(results));

        // results[0].format=JSON.parse(results[0].format);
        // res.send(JSON.stringify(results[0]));
    });
});

router.use('/', function (req, res, next) {
    res.send(JSON.stringify({state:'error',info:"no input"}));
});

module.exports = router;
