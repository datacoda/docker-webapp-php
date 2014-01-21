#
# Image Name:: dataferret/webapp-php
#
# Copyright 2014, Nephila Graphic.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM dataferret/apache-event
MAINTAINER Ted Chen <ted@nephilagraphic.com>

# Fix locales
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

RUN apt-get update && \
    apt-get install supervisor mysql-client libapache2-mod-fastcgi \
    php5-fpm php5 php5-apcu php5-common curl php5-curl \
    php5-mysql php5-memcache php5-tidy php5-mcrypt php5-imagick php5-gd -y

# Clean Apt
RUN apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/;date\.timezone =/date\.timezone = 'UTC'/' /etc/php5/fpm/php.ini
RUN sed -i 's/listen = .*/listen=127.0.0.1:9000/' /etc/php5/fpm/pool.d/www.conf
RUN a2enmod proxy_fcgi


ADD start.sh /start.sh
ADD apache2/vhost.conf /etc/apache2/sites-available/000-default.conf
ADD supervisord/php5-fpm.conf /etc/supervisor/conf.d/php5-fpm.conf

RUN echo "<?php echo phpinfo(); ?>" > /var/www/test.php

CMD ["/bin/bash", "/start.sh"]
