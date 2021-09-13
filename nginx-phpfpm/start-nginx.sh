#!/usr/bin/with-contenv bash
set -e;

if /usr/bin/find "/docker-entrypoint.nginx.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    echo "[nginx] /docker-entrypoint.nginx.d/ is not empty, will attempt to perform configuration"

    echo "[nginx] Looking for shell scripts in /docker-entrypoint.nginx.d/"
    find "/docker-entrypoint.nginx.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.sh)
                if [ -x "$f" ]; then
                    echo "[nginx] Launching $f";
                    "$f"
                else
                    # warn on shell scripts without exec bit
                    echo "[nginx] Ignoring $f, not executable";
                fi
                ;;
            *) echo "[nginx] Ignoring $f";;
        esac
    done

    echo "[nginx] Configuration complete; ready for start up"
else
    echo "[nginx] No files found in /docker-entrypoint.nginx.d/, skipping configuration"
fi

/usr/sbin/nginx
