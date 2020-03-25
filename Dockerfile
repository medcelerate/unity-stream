FROM centos:7

ENV LANG en_US.utf8

WORKDIR /root/
RUN yum update -y

RUN yum install -y wget build-essential curl sudo git mercurial lsb-core devscripts lintian quilt openssl-devel pcre-devel zlib-devel epel-release rpm-build gcc
RUN echo $'[nginx]\n\
name=nginx repo\n\
baseurl=https://nginx.org/packages/centos/7/$basearch/\n\
gpgcheck=0\n\
enabled=1' >> /etc/yum.repos.d/nginx.repo
RUN yum update -y && yum install -y nginx

RUN wget https://hg.nginx.org/pkg-oss/raw-file/default/build_module.sh

RUN chmod a+x build_module.sh
RUN f=$(nginx -v 2>&1) && g=$(echo $f | sed "s/nginx version: nginx\///g") && ./build_module.sh -v $g https://github.com/sergey-dryabzhinsky/nginx-rtmp-module.git
RUN yum localinstall -y ./rpmbuild/RPMS/x86_64/*.rpm

RUN rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
RUN rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

RUN yum install -y ffmpeg ffmpeg-devel

RUN sed -i "1 i\daemon off;" /etc/nginx/nginx.conf

#RUN sed -i 's/worker_processes  1;/worker_processes  auto;/' /etc/nginx/nginx.conf

#RUN sed -i '3i rtmp_auto_push on;' /etc/nginx/nginx.conf

RUN sed -i "1 i\load_module modules/ngx_rtmp_module.so;" /etc/nginx/nginx.conf

RUN sed -i '15 a rtmp {\n\tinclude /etc/nginx/conf.d/rtmp/*.conf;\n}' /etc/nginx/nginx.conf

CMD ["/sbin/nginx"]