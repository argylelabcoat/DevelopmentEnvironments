FROM alpine:edge

ARG GUIX_SYSTEM=x86_64-linux

RUN apk update; apk add wget bash tar xz gnupg dumb-init

WORKDIR /tmp

# RUN wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh; chmod +x guix-install.sh; ./guix-install.sh
RUN wget -q https://ftp.gnu.org/gnu/guix/guix-binary-1.1.0.$GUIX_SYSTEM.tar.xz.sig &&  wget -q https://ftp.gnu.org/gnu/guix/guix-binary-1.1.0.$GUIX_SYSTEM.tar.xz
RUN wget https://sv.gnu.org/people/viewgpg.php?user_id=15145 \
      -qO - | gpg --import -
RUN gpg --verify guix-binary-1.1.0.$GUIX_SYSTEM.tar.xz.sig
RUN tar -xf  guix-binary-1.1.0.$GUIX_SYSTEM.tar.xz  

RUN mv var/guix /var/ && mv gnu /

RUN mkdir -p ~root/.config/guix

RUN ln -sf /var/guix/profiles/per-user/root/current-guix \
         ~root/.config/guix/current

RUN GUIX_PROFILE="`echo ~root`/.config/guix/current" ; \
  source $GUIX_PROFILE/etc/profile


RUN \
mkdir -p /usr/local/bin && \
cd /usr/local/bin && \
ln -s /var/guix/profiles/per-user/root/current-guix/bin/guix

RUN \ 
mkdir -p /usr/local/share/info && \
cd /usr/local/share/info && \
for i in /var/guix/profiles/per-user/root/current-guix/share/info/* ; \
  do ln -s $i ; done

RUN \
 addgroup --system guixbuild && \
 for i in `seq -w 1 10`; \
  do \
    adduser -G guixbuild           \
            -H -S     \
            -g "Guix build user $i"  \
            guixbuilder$i; \
  done

RUN echo "#!/bin/sh" > /etc/init.d/rcS; \
echo "/root/.config/guix/current/bin/guix-daemon --build-users-group=guixbuild &" >> /etc/init.d/rcS; \
echo "alias shutdown='kill 1'" >> /etc/init.d/rcS; \
chmod +x /etc/init.d/rcS

RUN echo "::sysinit:/etc/init.d/rcS " > /etc/inittab; \
echo "::askfirst:-/bin/bash" >> /etc/inittab

RUN echo "alias shutdown='kill 1'" >> /etc/bashrc; \
chmod +x /etc/bashrc

# RUN alias shutdown="kill 1"
# CMD [ "bash", "-c", "~root/.config/guix/current/bin/guix-daemon \
       # --build-users-group=guixbuild"]
ENV HOME=/root
ENV TERM=xterm
ENTRYPOINT ["busybox", "init"]

