# ExpertField

现在网站做成了微服务的形式，服务分了三个容器：

## `yindaheng98/expert-field-homepage`

这是一个Apache2服务器，里面包含项目的主页（静态网页）并设置了反向代理：

```xml
<VirtualHost *:80>
        ProxyPass /ExpertField http://localhost:8081/ExpertField
        ProxyPassReverse /ExpertField http://localhost:8081/ExpertField

        ProxyPass /caomei http://localhost:8080
        ProxyPassReverse /caomei http://localhost:8080
        ProxyPass /test http://localhost:8080/test
        ProxyPassReverse /test http://localhost:8080/test
        
        ProxyPass /api http://localhost:3000
        ProxyPassReverse /api http://localhost:3000
        
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
```

## `yindaheng98/expert-field-admin`

网页端应用。默认在8080端口。

## `yindaheng98/expert-field-android-backend`

这是一个Node.js容器，上面3000端口运行着我们的Android后端

在写js的时候注意监听端口应该是3000。

写js的时候如果有加了一些包，记得一定要加到packet.json里面不然会报包找不到的错误（webstorm应该自带加packet.json的功能）。

## `yindaheng98/expert-field-caomei`

java容器上端口8080运行着我们的合作组开发的Spring boot应用。

## 其他容器

本应用还需要一个位于`mysql:3306`的mysql服务器和一个位于`redis:6379`的redis服务器。请自行设置。

## 部署这个项目

### 下载到本地部署

```shell
kubectl apply -f ./expert-field.yaml
kubectl apply -f ./service.yaml
kubectl apply -f ./ingress.yaml
```

### 联网部署

```shell
URL=https://raw.githubusercontent.com/yindaheng98/ExpertField/master
kubectl apply -f $URL/expert-field.yaml
kubectl apply -f $URL/service.yaml
kubectl apply -f $URL/ingress.yaml
```

### 删除部署

```shell
kubectl delete ing ingress-expert-field
kubectl delete svc expert-field-android-backend
kubectl delete svc expert-field-admin
kubectl delete deploy expert-field-deploy
```
