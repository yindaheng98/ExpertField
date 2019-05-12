const express = require('express');
const multer  = require('multer');
const crypto  = require('crypto');
const path    = require("path");
const con     = require("../controllers/connections");
const app = express.Router();

function toSqlDateFormat(javaDateFormatStr) {
    let dt = new Date(javaDateFormatStr);
    let current_date = dt.getDate();
    let current_month = dt.getMonth() + 1;
    let current_year = dt.getFullYear();
    let current_hrs = dt.getHours();
    let current_mins = dt.getMinutes();
    let current_secs = dt.getSeconds();
    return current_year + "-" + current_month + "-" + current_date + " " + current_hrs + ":" + current_mins + ":" + current_secs;
}

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './uploads/');  // 文件存储的路径
    },
    filename: function (req, file, cb) {
        crypto.pseudoRandomBytes(16, function (err, raw) {
            let newFilename = raw.toString('hex') + path.extname(file.originalname);  //文件命名方式
            if (typeof req.new_filename === 'undefined') req.new_filename = [];
            req.new_filename.push(newFilename);
            console.log("filename: " + req.new_filename);
            // newFilename = "api/uploads/"+newFilename;
            cb(null, newFilename);
        });
    }
});
const upload = multer({storage: storage}).array('voices', 5);   // 二进制字段，数组最大长度

const SQL_CMD = "INSERT INTO 试验数据 (试验_试验田ID, 录入时间, 数据, 语音) VALUES (?,?,?,?);";
function execute_sql(id, time, data, voices) {
    console.log("wtmd" + time);
    time = toSqlDateFormat(time);
    console.log(time);

    voices = JSON.stringify(voices);
    return new Promise(((resolve, reject) => {
        let query = con.mysql.query(SQL_CMD, [id, time, data, voices], function (err, results) {
            if (!err) {
                resolve();
            } else {
                console.log(err);
                reject();
            }
        })
    }));
}

app.post('/', function (req, res, next) {
    upload(req, res, err => {
        if (!err) {
            new_filenames = req.new_filename || [];
            new_filenames = new_filenames.map(f=>"api/uploads/"+f);
            execute_sql(req.body.exp_field_id, req.body.time, req.body.data, new_filenames).then(
                () => {
                    res.json({msg: 'ok'});
                },
                () => {
                    res.json({msg: '不ok'});
                }
            );
        }else{
            console.log(err);
            res.json({msg:'不ok'});
        }
    });
});

module.exports=app;
