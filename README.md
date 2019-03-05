# Docker WordPress Hosting 管理脚本

## 目标
Docker WordPress Hosting 的脚本，整合 nginx reverse proxy 及 letsencrypt SSL 自动产生器，可以很方便的在一台有公网 IP 主机上，建置一个多支持多网域的 WordPress 环境。

## 环境安装及操作
1. 下载套件

	```
	$ git clone https://github.com/mobistor/docker_wordpress_hosting.git
	```
	会在当前路径下建立一个 `docker_workdpress_hosting` 的目录，其内容如下：
	
	
	```
	├── all.sh
	├── gen.sh
	├── helper.sh
	├── nginx
	│   └── setup.sh
	├── README.md
	├── template
	│   ├── config
	│   └── helper.sh -> ../../helper.sh
	└── vhosts
	```

2. 如系统尚未安装 docker，请先安装 docker。Ubuntu 系统下可用以下命令安装 docker。
	
	```
	$ apt install docker.io
	```
	
3. 在 nginx 下，先行安装 nginx reverse proxy 及 letsencrypt 的 docker 容器。

	```
	$ ./setup.sh
	```
4. 开始建立您的第一个网站。假如网站的域名为 `www.yourdomain.com`，执行下列的命令　
	
	```
	$ ./gen.sh www.yourdomain.com
	```
	在 vhosts 下将建立一个 `www.yourdomain.com` 的目录，里面有 `config` 及  `helper.sh`　两个文件。`config` 文件的内容为 `www.yourdomain.com`　的基本设定，请根据网站的属性来设定。 
	
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
	
	**VID** 为此网域用来做为相关容器命名使用，务必保持这个名称的唯一性，不能与其他网域定义相同的名称。
	
4. 在 `www.yourdomain.com` 的目录下执行以下的命令
   
   ```
   $ ./helper.sh run
   ```
   这个命令将 build 出三个属于这个网域的服务容器，分别为 wordpress，mariadb　及 redis。容器名称就是以 VID 为首的命名。
   
   建立成功后，三个容器依据顺序，自动启动。可在浏览器内开始浏览这个的网域 `https://www.yourdomain.com`。因为才刚建立完成，所以在浏览的时候，可能会有连不上，SSL 不信任等讯息，稍等几分钟就会正常。
   
   **特别注意 :** 这个域名必须事先解析到这台主机的公网IP。
   

5. helper.sh 命令必须在网域的目录下面执行， 相关的子指令如下。

   | 子命令 |说明 |
   |:-----:|:----|
   |run|建立相关的容器并启动，网域下只需执行一次，除非执行 clean 或 reset 后才需重新执行 run 命令。|
   |stop|停止这个网域的所有容器。│
   |start|启动这个网域的所有容器，必须先用 run 建立。|
   |status|显示容器资源的使用状态。 |
   |clean|将所有容器删除，但不删除网页，数据库，快取等用户资料。需要用 run 再次建立容器。|
   |reset|将所有容器及相关的资料都删除，需要用 run 再次建立容器。 |
   
## 启用 Redis 快取
1. 在 WordPress 网站完成初始化设定后，编辑网域下的 ./vol/html　下的 `wp-config.php`。
2. 增加 `define('WP_REDIS_HOST', 'redis');` 的定义。
3. 在　WordPress 中，安装 "Redis Object Cache" 插件并启用及 enable。

## 多 vhost 同时管理

`all.sh` 可以同时管理所有的网站，

```
$ ./all.sh [ start | stop | run | clean | reset ]
```

## 参考资料

[LetsEncrypt companion container for nginx-proxy](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion)

[Quickstart: Compose and WordPress](https://docs.docker.com/compose/wordpress/)

[Redis Object Cache](https://wordpress.org/plugins/redis-cache/)



