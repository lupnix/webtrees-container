FROM registry.redhat.io/ubi9/php-80@sha256:ead84d80aae6fbb28aab88f3d6534413e848ba759cb22380d16878bf0512f59b
ARG WEBTREES_VERSION

RUN \
  cd /tmp && echo "Installing webtrees version ${WEBTREES_VERSION}" && \
  curl -L https://github.com/fisharebest/webtrees/archive/refs/tags/${WEBTREES_VERSION}.tar.gz | tar -xz && \
  mv webtrees-${WEBTREES_VERSION}/* ${APP_DATA} && rmdir webtrees-${WEBTREES_VERSION} && \
  bash

RUN \
    mkdir -p ${APP_ROOT}/bin && \
    curl -o ${APP_ROOT}/bin/composer.phar "https://getcomposer.org/download/2.3.5/composer.phar" && \
    echo "3b3b5a899c06a46aec280727bdf50aad14334f6bc40436ea76b07b650870d8f4 ${APP_ROOT}/bin/composer.phar" | sha256sum -c - && \
    chmod +x ${APP_ROOT}/bin/composer.phar && \
    ${APP_ROOT}/bin/composer.phar install --no-dev --no-interaction --no-ansi --optimize-autoloader

CMD /usr/libexec/s2i/run
