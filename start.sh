#!/bin/bash

# Change the size of the userland cache
cat > /etc/php5/mods-available/apcu.ini <<EOL
extension=apcu.so
apc.shm_size = ${APC_SHM_SIZE:-32M}
EOL

sed -i 's/memory_limit = .*/memory_limit = '${PHP_MEMORY_LIMIT:-128M}'/' /etc/php5/fpm/php.ini


# start all the services
/usr/bin/supervisord -n