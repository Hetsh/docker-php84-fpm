FROM amd64/alpine:20260127
ARG LAST_UPGRADE="2026-01-29T13:31:57+01:00"
RUN apk upgrade && \
    apk add --no-cache \
        php84=8.4.17-r0 \
        php84-fpm=8.4.17-r0

# App user
ARG APP_USER="http"
ARG APP_GROUP="$APP_USER"
ARG APP_UID="33"
ARG APP_GID="$APP_UID"
RUN addgroup \
    --gid "$APP_GID" \
    "$APP_GROUP" && \
    adduser \
    --disabled-password \
    --uid "$APP_UID" \
    --no-create-home \
    --gecos "$APP_USER" \
    --ingroup "$APP_GROUP" \
    --shell /sbin/nologin \
    "$APP_USER"

# Remove PHP version from paths & executable
ARG BIN_DIR="/usr/bin"
ARG SBIN_DIR="/usr/sbin"
ARG PHP_DIR="/etc/php"
ARG PHP84_DIR="/etc/php84"
ARG LOG84_DIR="/var/log/php84"
ARG LOG_DIR="/var/log/php"
ARG INI_CONF="$PHP84_DIR/php.ini"
ARG FPM_CONF="$PHP84_DIR/php-fpm.conf"
ARG WWW_CONF="$PHP84_DIR/php-fpm.d/www.conf"
RUN sed -i "s|$PHP84_DIR|$PHP_DIR|" "$INI_CONF" && \
    sed -i "s|$PHP84_DIR|$PHP_DIR|" "$FPM_CONF" && \
    sed -i "s|$PHP84_DIR|$PHP_DIR|" "$WWW_CONF" && \
    sed -i "s|$LOG84_DIR|$LOG_DIR|" "$INI_CONF" && \
    sed -i "s|$LOG84_DIR|$LOG_DIR|" "$FPM_CONF" && \
    sed -i "s|$LOG84_DIR|$LOG_DIR|" "$WWW_CONF" && \
    mv "$PHP84_DIR" "$PHP_DIR" && \
    ln -s "$PHP_DIR" "$PHP84_DIR" && \
    mv "$LOG84_DIR" "$LOG_DIR" && \
    ln -s "$LOG_DIR" "$LOG84_DIR" && \
    mv "$BIN_DIR/php84" "$BIN_DIR/php" && \
    ln -s "$BIN_DIR/php" "$BIN_DIR/php84" && \
    mv "$SBIN_DIR/php-fpm84" "$SBIN_DIR/php-fpm" && \
    ln -s "$SBIN_DIR/php-fpm" "$SBIN_DIR/php-fpm84"

# Configuration
ARG SOCK84_DIR="/run/php84"
ARG SOCK_DIR="/run/php"
ARG INI_CONF="$PHP_DIR/php.ini"
ARG FPM_CONF="$PHP_DIR/php-fpm.conf"
ARG WWW_CONF="$PHP_DIR/php-fpm.d/www.conf"
RUN sed -i "s|^include_path|;include_path|" "$INI_CONF" && \
    sed -i "s|^;error_log = syslog|error_log = $LOG_DIR/error.log|" "$INI_CONF" && \
    sed -i "s|^;daemonize.*|daemonize = no|" "$FPM_CONF" && \
    sed -i "s|^;log_level =.*|log_level = notice|" "$FPM_CONF" && \
    sed -i "s|^;access.log =.*|access.log = $LOG_DIR/access.log|" "$WWW_CONF" && \
    sed -i "s|^user.*|user = $APP_USER|" "$WWW_CONF" && \
    sed -i "s|^group.*|group = $APP_GROUP|" "$WWW_CONF" && \
    sed -i "s|^;env\[PATH\]|env\[PATH\]|" "$WWW_CONF" && \
    sed -i "s|^;clear_env =.*|clear_env = no|" "$WWW_CONF" && \
    sed -i "s|^listen.*|listen = 9000\n;listen = $SOCK84_DIR/php-fpm.sock|" "$WWW_CONF" && \
    sed -i "s|^;listen\.owner.*|listen.owner = $APP_USER|" "$WWW_CONF" && \
    sed -i "s|^;listen\.group.*|listen.group = $APP_GROUP|" "$WWW_CONF" && \
    sed -i "s|^;catch_workers_output.*|catch_workers_output = yes|" "$WWW_CONF" && \
    sed -i "s|^;decorate_workers_output.*|decorate_workers_output = no|" "$WWW_CONF"

# Folders
ARG SRV_DIR="/srv"
RUN mkdir "$SOCK_DIR" && \
    chmod 750 "$SOCK_DIR" && \
    chown -R "$APP_USER":"$APP_GROUP" "$SRV_DIR" "$SOCK_DIR" "$LOG_DIR"

WORKDIR "$SRV_DIR"
ENTRYPOINT ["php-fpm"]
