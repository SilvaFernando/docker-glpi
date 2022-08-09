Esta imagem contempla somente o FrontEnd do GLPi - Apache + PHP
Recomendo montar volumes apontando para os seguintes diretórios:
/usr/share/glpi/plugins
/usr/share/glpi/marketplace
/var/lib/glpi/marketplace
/var/lib/glpi/files
A intuição destes volumes é você não perder plugins, files do GLPI
Rodar o comando /etc/init.d/apache2 start


Para alterar a versão do GLPI que você vai subir altere as linhas 8 e 9

Aceito sugestões para ja startar o container com o apache2 startado
