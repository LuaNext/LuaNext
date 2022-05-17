GIT ?= git
LUA ?= lua5.3
LUANEXT ?= luanext

NIGHT ?= night
NIGHT_VERSION := $(shell $(NIGHT) -v 2>/dev/null)

GIT_VERSION := $(shell $(GIT) --version 2>/dev/null)
LUA_VERSION := $(shell $(LUA) -v 2>/dev/null)
LUANEXT_VERSION := $(shell $(LUANEXT) -v 2>/dev/null)

ifndef LUA_VERSION
	$(error LuaNext requires Lua in order to compile itself.)
endif

ifndef GIT_VERSION
	$(error LuaNext requires Git in order to compile itself.)
endif

.PHONY: test compile

test:
ifdef NIGHT_VERSION
	$(NIGHT) tests
else
	git clone -b release https://github.com/LuaNext/night.git
	$(LUA) ./night/main.lua tests
	rm -rf ./night
endif

compile:
ifdef LUANEXT_VERSION
	$(LUANEXT) main.lua
else
	git clone -b release https://github.com/LuaNext/LuaNext.git
	$(LUA) ./LuaNext/main.lua main
	rm -rf ./LuaNext
endif

flatten:
	@echo "target: lua5.3\nstrict flat minify" > .luanext
	make compile
	@echo "target: lua5.3\nstrict" > .luanext
