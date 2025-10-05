FROM alpine:latest

ENV LUA_VERSION=5.4
# ENV LOVE2D_VERSION=11.5-r0
# ENV DISPLAY=:1
# ENV XVFB_RESOLUTION=1024x768x24
# ENV SDL_VIDEODRIVER=dummy


RUN apk add --no-cache build-base lua${LUA_VERSION} lua${LUA_VERSION}-dev luarocks${LUA_VERSION}
# love=${LOVE2D_VERSION} mesa-dri-gallium mesa-egl xvfb ttf-freefont


WORKDIR /app

RUN ls /usr/bin | grep lua
# Criar links simbólicos em vez de aliases
RUN ln -sf /usr/bin/lua${LUA_VERSION} /usr/local/bin/lua && \
    ln -sf /usr/bin/luac${LUA_VERSION} /usr/local/bin/luac && \
    ln -sf /usr/bin/luarocks-${LUA_VERSION} /usr/local/bin/luarocks && \
    ln -sf /usr/bin/luarocks-admin-${LUA_VERSION} /usr/local/bin/luarocks-admin && \
    mkdir -p /usr/local/include/lua/ && \
    ln -sf /usr/include/lua${LUA_VERSION} /usr/local/include/lua/${LUA_VERSION}

CMD ["tail", "-f", "/dev/null"]
# CMD Xvfb :1 -screen 0 $XVFB_RESOLUTION & \
#     sleep 2 && \
#     tail -f /dev/null
