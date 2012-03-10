# Example Rails application

1. Deployment with Capistrano
2. Server with Unicorn + Nginx proxy
3. Database with Sqlite3

# Example nginx proxy config

```nginx
server {
  listen   80;
  server_name  ad.niczsoft.com;

  access_log  /var/log/nginx/ad.niczsoft.com.access.log;
  error_log  /var/log/nginx/ad.niczsoft.com.error.log;

  location / {
    proxy_pass        http://unix:/home/ad/app/shared/pids/unicorn.socket;
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Real-IP         $remote_addr;
    proxy_set_header  Host              $http_host;
    # this is required for HTTPS (another server section):
    # proxy_set_header X-Forwarded-Proto https;
  }
}
```
