let express = require('express');
let router = express.Router();
let webpipeto=require('./webpipeto');

/* GET users listing. */
router.use('/WebSiteAnalysisKit', function (req, res, next) {
    webpipeto(req,res,'web',8080)
});
router.use('/', function (req, res, next) {
    webpipeto(req,res,'web',80)
});

module.exports = router;
