# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1

ARG VERSION

# Set Python and runtime environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_ROOT_USER_ACTION=ignore \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_PREFER_BINARY=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://alpine-wheels.github.io/index https://pypi.org/simple https://wheel-index.linuxserver.io/alpine-3.22/  https://wheels.home-assistant.io/musllinux-index/" \
    UV_INDEX_STRATEGY="unsafe-best-match" \
    PATH="/usr/local/bin:$PATH"

ENV GPG_KEY 7169605F62C751356D054A26A821E680E5FA6305

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -eux; \
	\
	apk add --no-cache --virtual .build-deps \
		gnupg \
		tar \
		xz \
		bluez-dev \
		bzip2-dev \
		dpkg-dev dpkg \
		findutils \
		gcc \
		gdbm-dev \
		libc-dev \
		libffi-dev \
		libnsl-dev \
		libtirpc-dev \
		linux-headers \
		make \
        musl-dev \
		ncurses-dev \
		openssl-dev \
		pax-utils \
		readline-dev \
		sqlite-dev \
		tcl-dev \
		tk \
		tk-dev \
		util-linux-dev \
		xz-dev \
		zlib-dev \
	; \
	\
	wget -O python.tar.xz "https://www.python.org/ftp/python/${VERSION%%[a-z]*}/Python-${VERSION}.tar.xz"; \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${VERSION%%[a-z]*}/Python-${VERSION}.tar.xz.asc"; \
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
	gpg --batch --verify python.tar.xz.asc python.tar.xz; \
	gpgconf --kill all; \
	rm -rf "$GNUPGHOME" python.tar.xz.asc; \
	mkdir -p /usr/src/python; \
	tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
	rm python.tar.xz; \
	\
	cd /usr/src/python; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-lto \
		--with-ensurepip \
        --enable-optimizations \
	; \
	nproc="$(nproc)"; \
    # set thread stack size to 1MB so we don't segfault before we hit sys.getrecursionlimit()
    # https://github.com/alpinelinux/aports/commit/2026e1259422d4e0cf92391ca2d3844356c649d0
	EXTRA_CFLAGS="-DTHREAD_STACK_SIZE=0x100000"; \
	LDFLAGS="${LDFLAGS:--Wl},--strip-all"; \
    # https://docs.python.org/3.12/howto/perf_profiling.html
    # https://github.com/docker-library/python/pull/1000#issuecomment-2597021615
	# https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/x86-Options.html#index-momit-leaf-frame-pointer-2
	# https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/AArch64-Options.html#index-momit-leaf-frame-pointer
	EXTRA_CFLAGS="${EXTRA_CFLAGS:-} -fno-omit-frame-pointer -mno-omit-leaf-frame-pointer"; \
# https://github.com/docker-library/python/issues/160#issuecomment-509426916
		PROFILE_TASK='-m test.regrtest --pgo \
          test_array \
          test_base64 \
          test_binascii \
          test_binhex \
          test_binop \
          test_bytes \
          test_class \
          test_cmath \
          test_codecs \
          test_compile \
          test_complex \
          test_csv \
          test_dict
          test_float \
          test_fstring \
          test_io \
          test_iter \
          test_json \
          test_long \
          test_memoryview \
          test_pickle \
          test_set \
          test_slice \
          test_struct \
          test_threading \
          test_traceback \
          test_unicode \
		' \
          ## More tests \
          # test_abc \
          # test_aifc \
          # test_argparse \
          # test_ast \
          # test_asynchat \
          # test_asyncio \
          # test_asyncore \
          # test_atexit \
          # test_audioop \
          # test_bdb \
          # test_bisect \
          # test_bz2 \
          # test_calendar \
          # test_cgi \
          # test_chunk \
          # test_cmd \
          # test_code \
          # test_codeop \
          # test_collections \
          # test_colorsys \
          # test_compileall \
          # test_concurrent \
          # test_configparser \
          # test_contextlib \
          # test_copy \
          # test_copyreg \
          # test_curses \
          # test_dataclasses \
          # test_distutils \
          # test_doctest \
          # test_dummy_threading \
          # test_email \
          # test_enumerate \
          # test_functools \
          # test_gdbm \
          # test_genericpath \
          # test_gettext \
          # test_glob \
          # test_graphlib \
          # test_gzip \
          # test_heapq \
          # test_hmac \
          # test_html \
          # test_http \
          # test_idlelib \
          # test_imp \
          # test_io \
          # test_ipaddress \
          # test_itertools \
          # test_keyword \
          # test_linecache \
          # test_logging \
          # test_lzma \
          # test_mailbox \
          # test_mailcap \
          # test_marshal \
          # test_mimetypes \
          # test_modulefinder \
          # test_multibytecodec \
          # test_multiprocessing \
          # test_netrc \
          # test_nntplib \
          # test_numbers \
          # test_operator \
          # test_optparse \
          # test_pathlib \
          # test_pipes \
          # test_pkgutil \
          # test_platform \
          # test_plistlib \
          # test_poplib \
          # test_posix \
          # test_posixpath \
          # test_pprint \
          # test_profile \
          # test_pstats \
          # test_ptypes \
          # test_queue \
          # test_quopri \
          # test_random \
          # test_readline \
          # test_reprlib \
          # test_resource \
          # test_rlcompleter \
          # test_runpy \
          # test_sched \
          # test_sdbm \
          # test_select \
          # test_shelve \
          # test_shlex \
          # test_shutil \
          # test_signal \
          # test_site \
          # test_smtpd \
          # test_smtplib \
          # test_socket \
          # test_socketserver \
          # test_spwd \
          # test_sqlite3 \
          # test_ssl \
          # test_stat \
          # test_statistics \
          # test_string \
          # test_stringprep \
          # test_subprocess \
          # test_sunau \
          # test_surt \
          # test_symtable \
          # test_sys \
          # test_sysconfig \
          # test_tarfile \
          # test_telnetlib \
          # test_tempfile \
          # test_textwrap \
          # test_timeit \
          # test_tkinter \
          # test_token \
          # test_tokenize \
          # test_tracemalloc \
          # test_turtle \
          # test_turtledemo \
          # test_types \
          # test_typing \
          # test_unittest \
          # test_urllib \
          # test_uuid \
          # test_venv \
          # test_warnings \
          # test_wave \
          # test_weakref \
          # test_webbrowser \
          # test_xdrlib \
          # test_xml \
          # test_xmlrpc \
          # test_zipapp \
          # test_zipfile \
          # test_zipimport \
          # test_zlib \

	make -j "$nproc" \
		"EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
		"LDFLAGS=${LDFLAGS:-}" \
        "PROFILE_TASK=${PROFILE_TASK:-}" \
	; \
    # https://github.com/docker-library/python/issues/784
    # prevent accidental usage of a system installed libpython of the same version
	rm python; \
	make -j "$nproc" \
		"EXTRA_CFLAGS=${EXTRA_CFLAGS:-}" \
		"LDFLAGS=${LDFLAGS:--Wl},-rpath='\$\$ORIGIN/../lib'" \
        "PROFILE_TASK=${PROFILE_TASK:-}" \
		python \
	; \
	make install; \
	\
	cd /; \
	rm -rf /usr/src/python; \
	\
	find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
			-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
		\) -exec rm -rf '{}' + \
	; \
	\
	find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
		| tr ',' '\n' \
		| sort -u \
		| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
		| xargs -rt apk add --no-network --virtual .python-rundeps \
	; \
	apk del --no-network .build-deps; \
	python3 --version; \
	pip3 --version

# make some useful symlinks that are expected to exist ("/usr/local/bin/python" and friends)
RUN set -eux; \
	for src in idle3 pip3 pydoc3 python3 python3-config; do \
		dst="$(echo "$src" | tr -d 3)"; \
		[ -s "/usr/local/bin/$src" ]; \
		[ ! -e "/usr/local/bin/$dst" ]; \
		ln -svT "$src" "/usr/local/bin/$dst"; \
	done

USER nobody:nogroup

CMD ["python3"]
