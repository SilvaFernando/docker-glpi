FROM debian

RUN apt update -y && apt install cron wget apache2 -y
RUN apt install php php-curl php-gd php-cli php-mbstring php-mysql php-xml -y
RUN apt install php-cli php-cas php-imap php-ldap php-xmlrpc php-soap php-snmp php-apcu php-intl -y

RUN cd /tmp
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.2/glpi-10.0.2.tgz 
RUN tar -xvf glpi-10.0.2.tgz 
RUN chown -R www-data:www-data glpi && mv glpi /usr/share/.
RUN mkdir /etc/glpi && chown -R www-data:www-data /etc/glpi && chmod 775 /etc/glpi
RUN mkdir /var/lib/glpi && mkdir /var/lib/glpi/files 
RUN mkdir /var/log/glpi && chown -R www-data:www-data /var/log/glpi
RUN mkdir /var/lib/glpi/files/_cron
RUN mkdir /var/lib/glpi/files/data-documents
RUN mkdir /var/lib/glpi/files/_dumps
RUN mkdir /var/lib/glpi/files/_graphs
RUN mkdir /var/lib/glpi/files/_lock
RUN mkdir /var/lib/glpi/files/_pictures
RUN mkdir /var/lib/glpi/files/_plugins
RUN mkdir /var/lib/glpi/files/_rss
RUN mkdir /var/lib/glpi/files/_sessions
RUN mkdir /var/lib/glpi/files/_tmp
RUN mkdir /var/lib/glpi/files/_uploads
RUN chown -R www-data:www-data /var/lib/glpi/files/.

RUN echo '<VirtualHost *:80> \n \
        ServerAdmin webmaster@localhost \n \
        DocumentRoot /usr/share/glpi \n \
        CustomLog ${APACHE_LOG_DIR}/access.log combined \n \
    </VirtualHost>' > /etc/apache2/sites-available/000-default.conf

RUN echo "<?php" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php  && \
    echo "// config" >> /usr/share/glpi/inc/downstream.php &&\
    echo "defined('GLPI_CONFIG_DIR') or define('GLPI_CONFIG_DIR', (getenv('GLPI_CONFIG_DIR') ?: '/etc/glpi'));" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \
    echo "if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {" >> /usr/share/glpi/inc/downstream.php && \
    echo "   require_once GLPI_CONFIG_DIR . '/local_define.php';" >> /usr/share/glpi/inc/downstream.php && \
    echo "}" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \
    echo "// marketplace plugins" >> /usr/share/glpi/inc/downstream.php && \
    echo "defined('GLPI_MARKETPLACE_ALLOW_OVERRIDE') or define('GLPI_MARKETPLACE_ALLOW_OVERRIDE', false);" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \ 
    echo "// runtime data" >> /usr/share/glpi/inc/downstream.php && \
    echo "defined('GLPI_VAR_DIR') or define('GLPI_VAR_DIR', '/var/lib/glpi/files');" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_DOC_DIR', GLPI_VAR_DIR. '/data-documents');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_CRON_DIR', GLPI_VAR_DIR . '/_cron');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_DUMP_DIR', GLPI_VAR_DIR . '/_dumps');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_GRAPH_DIR', GLPI_VAR_DIR . '/_graphs');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_LOCK_DIR', GLPI_VAR_DIR . '/_lock');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_PICTURE_DIR', GLPI_VAR_DIR . '/_pictures');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_PLUGIN_DOC_DIR', GLPI_VAR_DIR . '/_plugins');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_RSS_DIR', GLPI_VAR_DIR . '/_rss');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_SESSION_DIR',    GLPI_VAR_DIR . '/_sessions');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_TMP_DIR', GLPI_VAR_DIR . '/_tmp');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_UPLOAD_DIR', GLPI_VAR_DIR . '/_uploads');" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_CACHE_DIR',      GLPI_VAR_DIR . '/_cache');" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \
    echo "// log" >> /usr/share/glpi/inc/downstream.php && \
    echo "defined('GLPI_LOG_DIR') or define('GLPI_LOG_DIR', '/var/log/glpi');" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php && \
    echo "// use system cron" >> /usr/share/glpi/inc/downstream.php && \
    echo "define('GLPI_SYSTEM_CRON', true);" >> /usr/share/glpi/inc/downstream.php && \
    echo "" >> /usr/share/glpi/inc/downstream.php
 
EXPOSE 80 443
VOLUME [/var/lib/glpi/files /var/lib/glpi/marketplace /usr/share/glpi/marketplace /usr/share/glpi/plugins]
