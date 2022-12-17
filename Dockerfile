#Necessário ajustar as crons
FROM debian
LABEL Fernando Dias da Silva

RUN apt update -y && apt install cron nano wget apache2 -y
RUN apt install php php-curl php-gd php-cli php-mbstring php-mysql php-xml php-bz2 php-zip -y
RUN apt install php-cli php-cas php-imap php-ldap php-xmlrpc php-soap php-snmp php-apcu php-intl -y

RUN cd /tmp
RUN wget https://github.com/glpi-project/glpi/releases/download/10.0.2/glpi-10.0.2.tgz 
RUN tar -xvf glpi-10.0.2.tgz 
RUN chown -R www-data:www-data glpi && mv glpi /usr/share/.
RUN mkdir /etc/glpi && chown -R www-data:www-data /etc/glpi && chmod 775 /etc/glpi
RUN mkdir /var/lib/glpi && mkdir /var/lib/glpi/files 
RUN mkdir /var/log/glpi && chown -R www-data:www-data /var/log/glpi
RUN mkdir /var/lib/glpi/files/_cache /var/lib/glpi/files/_cron /var/lib/glpi/files/data-documents /var/lib/glpi/files/_dumps
RUN mkdir /var/lib/glpi/files/_graphs /var/lib/glpi/files/_lock /var/lib/glpi/files/_pictures /var/lib/glpi/files/_plugins
RUN mkdir /var/lib/glpi/files/_rss /var/lib/glpi/files/_sessions /var/lib/glpi/files/_tmp /var/lib/glpi/files/_uploads
RUN chown -R www-data:www-data /var/lib/glpi/files/.
ADD https://github.com/glpi-project/glpi-inventory-plugin/releases/download/1.0.3/glpi-glpiinventory-1.0.3.tar.bz2 /usr/share/glpi/plugins
ADDa https://github.com/pluginsGLPI/datainjection/releases/download/2.11.2/glpi-datainjection-2.11.2.tar.bz2 /usr/share/glpi/plugins
ADD https://github.com/pluginsGLPI/formcreator/releases/download/2.13.0-rc.1/glpi-formcreator-2.13.0-rc.1.tar.bz2 /usr/share/glpi/plugins
ADD https://github.com/pluginsGLPI/news/releases/download/1.10.4/glpi-news-1.10.4.tar.bz2 /usr/share/glpi/plugins
ADD https://github.com/pluginsGLPI/oauthimap/releases/download/1.4.1/glpi-oauthimap-1.4.1.tar.bz2 /usr/share/glpi/plugins
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-datainjection-2.11.2.tar.bz2 
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-formcreator-2.13.0-rc.1.tar.bz2
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-glpiinventory-1.0.3.tar.bz2 
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-glpiinventory-1.0.3.tar.bz2 
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-oauthimap-1.4.1.tar.bz2 
RUN cd /usr/share/glpi/plugins && tar -xvf /usr/share/glpi/plugins/glpi-news-1.10.4.tar.bz2
RUN cd /usr/share/glpi/plugins && rm -Rf *.bz2
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

EXPOSE 80/TCP
EXPOSE 443/TCP

VOLUME [/var/lib/glpi/files /var/lib/glpi/marketplace /usr/share/glpi/marketplace /usr/share/glpi/plugins]
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
