#!/bin/bash
VERSION=13.0

HOME_DIR=/opt/odoo
CONFIG_PATH=/etc/odoo.conf
CONFIG_URL=https://raw.githubusercontent.com/AfroMonkey/odoo_tools/$VERSION/odoo.conf
DAEMON_URL=https://raw.githubusercontent.com/AfroMonkey/odoo_tools/$VERSION/odoo

DEBIAN_FRONTEND=noninteractive


apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    bash-completion \
    git \
    python3 \
    python3-pip \
    sudo \
    vim \
    postgresql \
    wget

adduser --system --home=$HOME_DIR odoo

su postgres - c "service postgresql start && \
    createuser -dRS odoo && \
    service postgresql stop"


apt-get install -y \
    libpq-dev\
    zlib1g-dev\
    libjpeg8-dev\
    libjpeg-dev\
    build-essential\
    python3-dev\
    libxml2-dev\
    libpq-dev\
    libsasl2-dev\
    libldap2-dev\
    libevent-dev\
    libxslt-dev\
    python-dev

pip3 install \
    Pillow \
    pbr \
    funcsigs

su odoo -c "git clone https://github.com/odoo/odoo/ --single-branch -b $VERSION $HOME_DIR/odoo"

su odoo -c "pip3 install -U -r $HOME_DIR/odoo/requirements.txt"

wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb && \
    sudo dpkg -i wkhtmltox_0.12.5-1.bionic_amd64.deb || \
    sudo apt-get install -f -y

curl $CONFIG_URL > /etc/odoo.conf

touch /var/log/odoo.log
chown odoo /var/log/odoo.log

curl $DAEMON_URL > /etc/init.d/odoo
chmod +x /etc/init.d/odoo

service odoo enable
service odoo start
