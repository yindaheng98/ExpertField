let createError = require('http-errors');
let express = require('express');
let path = require('path');
let cookieParser = require('cookie-parser');
let logger = require('morgan');

let expertRouter = require('./routes/expertInfo');//初始化路由
let fieldRouter = require('./routes/fieldInfo');
let indexRouter = require('./routes/index');
let uploadRouter = require('./routes/upload');
let otherRouter = require('./routes/other');

let app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/getExpertInfo', require('./routes/expertInfo'));
app.use('/getFieldInfo', fieldRouter);
app.use('/index', indexRouter);
app.use('/upload', uploadRouter);
app.use('/', otherRouter);//前面没有匹配到的全部仍这里

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;