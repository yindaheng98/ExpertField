# ExpertField

现在网站做成了微服务的形式，服务分了三个容器：

## `center`容器

```docker-compose
center:
    build: ./center
    ports:
      - "80:3000"
    links:
      - web
      - redis
```

这是一个中央容器，上面可以运行nodejs。

这个容器的3000端口直接接着主机的80端口，所有的网页请求都要经过这个容器的nodejs转发到其他地方。

nodejs项目在`./center/app`下，容器启动的时候会自动把这个目录拷贝进去然后自动运行起来。

在写js的时候注意监听端口应该是3000。

写js的时候如果有加了一些包，记得一定要加到packet.json里面不然会报包找不到的错误（webstorm应该自带加packet.json的功能）。

## `web`容器

```docker-compose
web:
    build: ./web
    ports:
      - "3307:3306"
    links:
      - redis
    volumes:
      - "./Data:/var/lib/mysql"
```

这是主要的网页服务器，上面8080端口运行着一个jetty、80端口运行着一个apache2+php、和3306端口运行着一个mysql。

这个容器的3306端口直接接着主机的3307端口。

这个容器上面运行的mysql数据库会把所有数据文件存在主机当前目录的`Data`文件夹下，即使这个容器被删了，Data文件夹下的数据库文件也不会丢。并且下次启动的时候数据库会直接从Data文件夹里面初始化数据。

php项目文件放在`./web/app`文件夹下，jetty中的war放在`./web/webapps`文件夹下。容器启动的时候会自动把这两个目录拷贝进去然后自动运行起来（别问为什么有php，问就是别的镜像不会玩只会玩这个）。

## `redis`容器

```docker-compose
redis:
    image: redis
    ports:
      - "6379:6379"
```

这是一个直接从官方镜像初始化来的redis容器运行在6379端口，这个容器的6379端口直接接着主机的6379端口（一下就加好了，那就加一个吧，用不用都没关系）。

## 主机和容器间的访问关系

Docker内置DNS解析，下面写的地址都是`[网址]:[端口号]`的意思，比如`center`容器里面可以打`curl http://web:80`访问到php上面的网页。

* `center`容器可以通过`web:80`访问到`web`容器中的apache2+php页面
* `center`容器可以通过`web:8080`访问到`web`容器中的servlet和jsp（jetty服务器）
* `center`容器可以通过`web:3306`访问到`web`容器中的mysql数据库
* `center`容器和`web`容器都可以通过`redis:6379`访问到`redis`容器中的redis服务器

## 主机可以访问到的服务

* `localhost:80`->`center`容器，nodejs
* `localhost:81`->`web`容器，php，里面有个phpmyadmin
* `localhost:6379`->`redis`容器，redis

如果还想访问者里面的另外几个容器，可以自己在docker-compose.yml里面加ports。具体操作自己看一下docker-compose的文档。

## 启动这个项目

一般来说把转发的部分调完了就可以各自写各自部分的不用每次都开docker了，但是还是要说一哈怎么启动项目。

    docker-compose up --build

命令行打这个👆完事，等着就完事了

第一次开的时候数据库里面没东西