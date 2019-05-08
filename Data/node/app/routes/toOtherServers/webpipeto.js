let http=require('http');
/*
这个函数用于进行端口转发
把请求req转发到url:port上
然后把结果流式返给res
 */
module.exports = function (req, res,host ,port) {

    const options={
        hostname:host,
        port:port,
        path:req.originalUrl,
        method:req.method,
        headers:req.headers
    };
    options.headers.host=host+':'+port;

    http.request(options, (response)=>{
        res.writeHead(response.statusCode,response.headers);
        response.setEncoding('utf8');
        response.on('data', (chunk) => {
            res.write(chunk);
        });
        response.on('end', () => {
            res.end();
        });
        //response.pipe(res);//流式转发
    }).end();
};