# PHP8.4-FPM
Small and easy to setup PHP8.4 FastCGI Process Manager.

## Running the server
```bash
docker run --detach --publish 9000:9000 --mount type=bind,source="/path/to/app",target="/path/to/app" --name php84-fpm hetsh/php84-fpm
```
The php source files of your app must be mounted, so that FPM can access them.

## Stopping the container
```bash
docker stop php84-fpm
```

## Configuration
Adjustments can be made via a custom `php.ini` file. It can be mounted readonly:
```bash
--mount type=bind,readonly,source="/path/to/php.ini",target="/etc/php/php.ini"
```
