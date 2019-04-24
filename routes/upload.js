const express = require('express');
const multer  = require('multer');
const crypto  = require('crypto');
const path    = require("path");

var app = express.Router();

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, '../uploads/');  // 文件存储的路径
    },
    filename: function (req, file, cb) {
        crypto.pseudoRandomBytes(16, function (err, raw) {
            let newFilename = raw.toString('hex') + path.extname(file.originalname);  //文件命名方式
            req.new_filename = newFilename;
            console.log("filename: " + newFilename);
            cb(null, newFilename);
        });
    }
});
const upload = multer({storage: storage}).array('voices', 3);   // 二进制字段，数组最大长度

app.post('/', function (req, res, next) {
    upload(req, res, err => {
        if (!err) {
            console.log(req.body.data); // 收到普通的字段
            res.json({msg:'ok'});
        }else{
            res.json({msg:'不ok'});
        }
    });
});

module.exports=app;
