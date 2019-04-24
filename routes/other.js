let express = require('express');
let router = express.Router();
let con = require('../controllers/connections');

/* GET users listing. */
router.use('/', function (req, res, next) {
    res.send("您正在前往其他站点");
});

module.exports = router;
