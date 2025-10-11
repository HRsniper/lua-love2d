FROM alpine:latest

ENV LUA_VERSION=5.4
# ENV LOVE2D_VERSION=11.5-r0

RUN apk add --no-cache build-base lua${LUA_VERSION} lua${LUA_VERSION}-dev luarocks${LUA_VERSION}
# love=${LOVE2D_VERSION}

WORKDIR /app

# RUN ls /usr/bin | grep lua
# RUN ls /usr/include/lua${LUA_VERSION}
# RUN ls /usr/lib/lua${LUA_VERSION}

# Criar links simbólicos em vez de aliases
RUN ln -sf /usr/bin/lua${LUA_VERSION} /usr/local/bin/lua && \
    ln -sf /usr/bin/luac${LUA_VERSION} /usr/local/bin/luac && \
    ln -sf /usr/bin/luarocks-${LUA_VERSION} /usr/local/bin/luarocks && \
    ln -sf /usr/bin/luarocks-admin-${LUA_VERSION} /usr/local/bin/luarocks-admin && \
    ln -sf /usr/lib/lua${LUA_VERSION}/liblua.so /usr/lib/liblua.so && \
    ln -sf /usr/lib/lua${LUA_VERSION}/liblua.a /usr/lib/liblua.a && \
    ln -sf /usr/include/lua${LUA_VERSION}/lauxlib.h /usr/include/lauxlib.h && \
    ln -sf /usr/include/lua${LUA_VERSION}/lua.h /usr/include/lua.h && \
    ln -sf /usr/include/lua${LUA_VERSION}/lua.hpp /usr/include/lua.hpp && \
    ln -sf /usr/include/lua${LUA_VERSION}/luaconf.h /usr/include/luaconf.h && \
    ln -sf /usr/include/lua${LUA_VERSION}/lualib.h /usr/include/lualib.h

CMD ["tail", "-f", "/dev/null"]
