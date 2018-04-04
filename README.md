docker-image-imgproxy
----

# What's this?

This is docker image of `ngx_small_light` .

# How to use

```bash
$ docker pull fukata/imgproxy
$ docker run --env 'S3_BUCKET=example.com' -p 8888:80 fukata/imgproxy
$ open http://127.0.0.1:8888/thumb/dw=300,dh=300,q=100/1-1/o.jpg
```

# Environment Variables

|name|description|
|:---|:----------|
|S3_BUCKET|S3 bucket name. ex) img.example.com.s3-ap-northeast-1.amazonaws.com|
|S3_DIR_PREFIX|S3 dir prefix of image dir. default: `images/`|
|URL_PREFIX|URL prefix. default: `thumb/`|
|PROXY_CACHE_DIR|cache path part nginx proxy_cache_path. default: `/var/cache/imgproxy_cache`|
|PROXY_CACHE_LEVELS|levels part of nginx proxy_cache_path. default: `1:2`|
|PROXY_CACHE_MAX_SIZE|max_size part of nginx proxy_cache_path. default: `1G`|
|PROXY_CACHE_INACTIVE|inactive part of nginx proxy_cache_path. default: `1h`|
|PROXY_CACHE_ZONE_SIZE|keys_zone size part of nginx proxy_cache_path. default: `5m`|
|PROXY_CACHE_VALID_200|value of proxy_cache_valid. default: `1h`|
