FROM archlinux/base

WORKDIR /etc/easy-rsa
ADD . /data

RUN [ "sh", "-c", "pacman -Syy --noconfirm - < /data/packages.txt" ]

CMD [ "/data/generate_keys.sh", "full"]