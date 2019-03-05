# Docker WordPress Hosting 管理脚本

docker_wordpress_hosting 的脚本，整合 nginx reverse proxy 及 letsencrypt SSL 自动产生器，可以很方便的将一台主机（有公网 IP)，架设出一个多网域的 WordPress 环境。

## 环境安装及操作
1. 下载套件

	```
	$ git clone https://github.com/mobistor/docker_wordpress_hosting.git
	```
	会在当前目录下建立一个 docker_workdpress_hosting 的目录，其内容如下：
	
	
	```
	├── all.sh
	├── doc
	│   └── redis_cache.md
	├── gen.sh
	├── helper.sh
	├── nginx
	│   └── setup.sh
	├── template
	│   ├── config
	│   └── helper.sh -> ../../helper.sh
	```

2. 如果尚未安装 docker，请先安装 docker， ubuntu 系统下命令如下
	
	```
	$ apt install docker.io
	```
	
3. 在 nginx 下，先行安装 nginx 及 letsencrypt。

	```
	$ ./setup.sh
	```
3. 建立你第一个网站，假如你的网站的域名为　www.yourdomain.com，在目录下执行　
	
	```
	$ ./gen.sh www.yourdomain.com
	```
	会在 vhosts 下建立一个 www.yourdomain.com 的目录，里面有 config 及  helper.sh。请根据你的资料修改 config 文件的内容
	
	```
	# 将以下 <template> 至换
	# 虚拟主机的网域名称
	VHOST=www.yourdomain.com
	
	# 缩写名称，系统中必须唯一不可重复
	VID=yourdomain
	
	# email 用于 Letsencrypt SSL
	EMAIL=admin@yourdomain.com
	
	# 资源限制
	CPUS=".2"
	MEMORY="300m"
	
	# 资料库的设定
	MYSQL_ROOT_PASSWORD=rootwordpress
	MYSQL_DATABASE=wordpress
	MYSQL_USER=wordpress
	MYSQL_PASSWORD=wordpress
	```
4. 在 `www.yourdomain.com` 的目录下执行，网站就启动起来。
   
   ```
   $ ./helper.sh run
   ```
   可以在浏览器浏览这个的网站 `https://www.yourdomain.com`。这个域名必须解析到这台主机的 IP（公网IP)。

5. helper.sh 命令必须在网域的目录下面执行， 相关的指令如下。

   | 命令 |说明 |
   |:---:|:----|
   |run|建立相关的容器并启动，网域下只需执行一次，除非执行 clean 或 reset 后。|
   |stop|暂停这个网域的服务。│
   |start|启动这个服务，容器必须先被用 run 建立。|
   |status|显示三个容器资源的使用状态。 |
   |clean|将容器删除，但不删除网页，数据库，快取的资料。需要用 run 再次建立容器，但网站资料还是保留著。|
   |reset|将容器及相关的资料都删除，需要用 run 再次建立容器。 |
   
   * 每个域名会启动三个容器服务，分别为 wordpress，mariadb，redis 三个容器。
   
## 启用 Redis 快取
1. 在 WordPress 网站完成初始化设定后，编辑网域下的 ./vol/html　下的 `wp-config.php`。
2. 增加 `define('WP_REDIS_HOST', 'redis');` 的定义。
3. 在　WordPress 中，安装 "Redis Object Cache" 插件并启用及 enable。

##多 vhost 同时管理

`all.sh` 可以同时管理所有的网站，

```
$ ./all.sh [ start | stop | run | clean | reset ]
```

