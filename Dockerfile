FROM lsiobase/xenial
MAINTAINER Ryan Flagler

# global environment settings
ENV DEBIAN_FRONTEND="noninteractive" \
COMPANY_NAME="digitalwatchdog" \
SOFTWARE_URL="http://digital-watchdog.com/DW_Spectrum/software/dwspectrum-server-3.0.0.15297-linux64.zip"

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
        python \
        upstart-job \
        psmisc \
        upstart \
        libsm6 \
        libice6 \
        libaudio2 \
        libogg0 \
        libxfixes3 \
        libxrender1 \
        unzip \
        fontconfig-config \
        fonts-dejavu-core \
        libdrm-amdgpu1 \
        libdrm-intel1 \
        libdrm-nouveau2 \
        libdrm-radeon1 \
        libfontconfig1 \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libglapi-mesa \
        libllvm4.0 \
        libpciaccess0 \
        libsensors4 \
        libtxc-dxtn-s2tc0 \
        libx11-xcb1 \
        libxcb-dri2-0 \
        libxcb-dri3-0 \
        libxcb-glx0 \
        libxcb-present0 \
        libxcb-sync1 \
        libxdamage1 \
        libxshmfence1 \
        libxxf86vm1 \
        mtools \
        syslinux \
        net-tools \
        libglib2.0 \
        syslinux-common && \

# install dwspectrum
 mkdir -p /opt/deb && \
 cd /opt/deb && \
 curl -O -L \
	"${SOFTWARE_URL}" && \
 unzip /opt/deb/${COMPANY_NAME}.zip || echo "Not a zip" && \
 dpkg-deb -R $(ls *.deb) extracted && \
 rm -rf ./extracted/etc/init.d && \
 sed -i '/service apport stop/q' ./extracted/DEBIAN/postinst && \
 dpkg-deb -b extracted ${COMPANY_NAME}.deb && \
 echo ${COMPANY_NAME} ${COMPANY_NAME}-mediaserver/accepted-mediaserver-eula boolean true | debconf-set-selections && \
 dpkg -i ${COMPANY_NAME}.deb && \

# cleanup
 apt-get clean && \
 rm -rf \
	/opt/deb \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

# add local files
COPY root/ /
		
# ports and volumes
EXPOSE 7001
VOLUME /config /archive
