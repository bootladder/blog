# Dockerfile for lighttpd
#run cd /var/www/localhost/htdocs; git clone https://github.com/bootladder/blog

from sebp/lighttpd
run apk add --update --no-cache git
#run mkdir /var/www/localhost/htdocs/blog
#copy jekyll /var/www/localhost/htdocs/blog
#copy index.html /var/www/localhost/htdocs/
#copy index.html /opt/
#copy index.html /home
#copy index.html /


