LUA_DIR=/usr/local
LUA_LIBDIR=$(LUA_DIR)/lib/lua/5.2
LUA_SHAREDIR=$(LUA_DIR)/share/lua/5.2

all: typedlua/lsl.lua

typedlua/lsl.lua: typedlua/lsl.tld
	printf 'return [=========[' >$@
	cat $+ >>$@
	printf ']=========]' >>$@

install:
	mkdir -p $(DESTDIR)$(LUA_LIBDIR)/typedlua
	cp typedlua/*.lua   $(DESTDIR)$(LUA_LIBDIR)/typedlua

