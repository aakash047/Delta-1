cp /home/aakash/Desktop/Delta/Core/mentees_domain.txt /var/www/mentees_domain.txt

touch /etc/apache2/sites-available/gemini.club.conf

echo "<VirtualHost *:80>
    ServerAdmin webmaster@gemini.club.com
    ServerName gemini.club
    ServerAlias www.gemini.club
    DocumentRoot /var/www
    DirectoryIndex index.html
    <Directory /var/www/>
        Options Indexes FollowSymLinks
        AllowOverride None
    Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/gemini.club.conf

echo "ServerName gemini.club" >> /etc/apache2/apache2.conf

ln -s /var/www/mentees_domain.txt /var/www/index.html

service apache2 start

a2ensite gemini.club.conf

a2dissite 000-default.conf

service apache2 reload

chmod 644 /var/www/mentees_domain.txt

