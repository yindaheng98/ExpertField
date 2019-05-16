# ExpertField

现在网站做成了微服务的形式，服务分了三个容器：

## `center`容器

```yml
web:
    build: ./web
    expose: 
     - "3306"
     - "80"
     - "8080"
    ports:
      - "8888:80"
      - "8080:8080"
      - "3307:3306"
    networks: 
      - "proxy"
    volumes: 
      - "./Data/mysql:/var/lib/mysql"
      - "./Data/php:/app"
      - "./Data/java:/jettybase/webapps"
      - "./Data/config/proxy_conf:/proxy_conf"
```

这是主节点容器，上面8080端口运行着一个jetty、80端口运行着一个带反向代理的apache2+php、和3306端口运行着一个mysql。

这个容器的80端口直接接着主机的8888端口，所有的网页请求都要经过这个容器的Apache2反向代理转发到其他地方。

mysql数据、php文件、jetty的war包、apache2的设置见[主节点容器镜像说明](https://github.com/yindaheng98/MultiBird)。

这个容器的3306端口直接接着主机的3307端口。

这个容器上面运行的mysql数据库会把所有数据文件存在主机当前目录的`Data`文件夹下，即使这个容器被删了，Data文件夹下的数据库文件也不会丢。并且下次启动的时候数据库会直接从Data文件夹里面初始化数据。

这里的数据库已经预先设置好了，测试数据也已经写好了。

php项目文件放在`./web/app`文件夹下，jetty中的war放在`./web/webapps`文件夹下。容器启动的时候会自动把这两个目录拷贝进去然后自动运行起来（别问为什么有php，问就是别的镜像不会玩只会玩这个）。


## `node`容器

```yml
node:
    restart: always
    depends_on: 
      - web
    build: ./node
    expose: 
     - "3000"
    ports: 
      - "3000:3000"
    networks: 
      - "proxy"
    volumes: 
      - "./Data/node/app:/home/node/app"
```

这是node容器，上面3000端口运行着我们的Android后端

在写js的时候注意监听端口应该是3000。

写js的时候如果有加了一些包，记得一定要加到packet.json里面不然会报包找不到的错误（webstorm应该自带加packet.json的功能）。

## `redis`容器

```yml
redis:
    image: redis
    ports: 
      - "6379:6379"
    networks: 
      - "proxy"
```

这是一个直接从官方镜像初始化来的redis容器运行在6379端口，这个容器的6379端口直接接着主机的6379端口（一下就加好了，那就加一个吧，用不用都没关系）。

## `java容器`

```yml
java:
    build: ./java
    ports:
      - "8081:8080"
```

java容器上端口8080运行着我们的合作组开发的Spring boot应用，映射到主机8081

## `FTP容器`

```yml
ftp:
    restart: always
    image: stilliard/pure-ftpd:hardened
    environment:
      FTP_USER_HOME: /home/Data
      PUBLICHOST: "localhost"
    ports:
     - "21:21"
     - "30000-30009:30000-30009"
    volumes: 
      - "./Data:/home/Data"
      - "./ftp-passwd:/etc/pure-ftpd/passwd"
```

FTP容器用于管理这些个远程文件使用方法见[stilliard/pure-ftpd的使用说明](https://hub.docker.com/r/stilliard/pure-ftpd)

## 主机和容器间的访问关系

Docker内置DNS解析，下面写的地址都是`[网址]:[端口号]`的意思，比如`web`容器里面可以打`curl http://node:80`访问到php上面的网页。

除java容器外，其他所有容器都在一个内置的DNS网络`proxy`中，互相可以打`[service名称]:[端口号]`访问

## 主机可以访问到的服务

* `localhost:8888`->`web`容器，apache2主节点，里面有个phpmyadmin
* `localhost:8080`->`web`容器，jetty
* `localhost:3307`->`web`容器，mysql
* `localhost:3000`->`node`容器，nodejs
* `localhost:8081`->`java`容器，合作组的Spring boot应用
* `localhost:6379`->`redis`容器，redis
* `localhost:21`->`ftp`容器，ftp服务

如果还想访问的另外几个容器，可以自己在docker-compose.yml里面加ports。具体操作自己看一下docker-compose的文档。

## 启动这个项目

一般来说把转发的部分调完了就可以各自写各自部分的不用每次都开docker了，但是还是要说一哈怎么启动项目。

    docker-compose up --build

命令行打这个👆完事，等着就完事了
