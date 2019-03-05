
### 如何启用 Redis 快取
1. 在 WordPress 网站完成初始化设定后，编辑 ./vol/html 下的 `wp-config.php`。
2. 增加 `define('WP_REDIS_HOST', 'redis');` 的定义。
3. 在　WordPress 中，安装 "Redis Object Cache" 插件，并启用及 enable。
