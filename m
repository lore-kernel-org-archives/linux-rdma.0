From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ibacm: Fixes to ACM package to support distros
Date: Tue, 3 Apr 2012 19:10:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823734519A805@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Set of changes to fixup the ibacm package for inclusion into RedHat 6.
Changes are based on feedback from Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.
These are primarily changes to the build files, along with name changes
to the man pages and sample configuration files.

Rename the ib_acm service to match the package name, ibacm.

Rename the ibacm configuration files to use the prefix 'ibacm' instead
of 'acm'.  The new sample files are 'ibacm_addr.cfg' and 'ibacm_opts.cfg'.

Move location of ACM lock and configuration files and ibacm.pid
files.  They are currently in non-standard locations.

Modify ibacm and ib_acme to use $sysconfdir and $bindir configure 
values.  The ibacm_addr.cfg and ibacm_opt.cfg files will now be 
read/written to $sysconfdir/rdma by default.  And ibacm will execute
$bindir/ib_acme if it needs to create the ibacm_addr.cfg file.  Without
$bindir, the ibacm service can fail to launch ib_acme when started
from an init script.

Add init script as part of install.  The init script is installed
into $sysconfdir/init.d.

Fixup man pages based on changes.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am    |   30 +++++++++----
 acm_addr.cfg   |   24 ----------
 acm_opts.cfg   |  130 --------------------------------------------------------
 ibacm.init     |  102 ++++++++++++++++++++++++++++++++++++++++++++
 ibacm.spec.in  |   68 ++++++++++++++++++++++-------
 ibacm_addr.cfg |   24 ++++++++++
 ibacm_opts.cfg |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 linux/osd.h    |   12 ++++-
 man/ib_acm.1   |  130 --------------------------------------------------------
 man/ib_acm.7   |   33 --------------
 man/ib_acme.1  |   14 +++---
 man/ibacm.1    |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/ibacm.7    |   31 +++++++++++++
 src/acm.c      |   17 ++++---
 src/acme.c     |   16 +++----
 15 files changed, 523 insertions(+), 368 deletions(-)
 delete mode 100644 acm_addr.cfg
 delete mode 100644 acm_opts.cfg
 create mode 100644 ibacm.init
 create mode 100644 ibacm_addr.cfg
 create mode 100644 ibacm_opts.cfg
 delete mode 100644 man/ib_acm.1
 delete mode 100644 man/ib_acm.7
 create mode 100644 man/ibacm.1
 create mode 100644 man/ibacm.7

diff --git a/Makefile.am b/Makefile.am
index 503ad72..58e3415 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,12 +1,12 @@
 INCLUDES = -I$(srcdir)/include -I$(srcdir)/linux
 
-AM_CFLAGS = -g -Wall -D_GNU_SOURCE
+AM_CFLAGS = -g -Wall -D_GNU_SOURCE -DSYSCONFDIR=\"${sysconfdir}\" -DBINDIR=\"$(bindir)\"
 
 bin_PROGRAMS = util/ib_acme
-sbin_PROGRAMS = svc/ib_acm
-svc_ib_acm_SOURCES = src/acm.c
+sbin_PROGRAMS = svc/ibacm
+svc_ibacm_SOURCES = src/acm.c
 util_ib_acme_SOURCES = src/acme.c linux/acme_linux.c src/libacm.c linux/libacm_linux.c src/parse.c
-svc_ib_acm_CFLAGS = $(AM_CFLAGS)
+svc_ibacm_CFLAGS = $(AM_CFLAGS)
 util_ib_acme_CFLAGS = $(AM_CFLAGS)
 
 ibacmincludedir = $(includedir)/infiniband
@@ -15,12 +15,24 @@ ibacminclude_HEADERS = include/infiniband/acm.h
 
 man_MANS = \
 	man/ib_acme.1 \
-	man/ib_acm.1 \
-	man/ib_acm.7
+	man/ibacm.1 \
+	man/ibacm.7
 
-EXTRA_DIST = src/acm_mad.h src/libacm.h \
-	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) acm_opts.cfg \
-	     acm_addr.cfg
+EXTRA_DIST = src/acm_mad.h src/libacm.h ibacm.init \
+	     linux/osd.h linux/dlist.h ibacm.spec.in $(man_MANS) ibacm_opts.cfg \
+	     ibacm_addr.cfg
+
+install-exec-hook:
+	if ! test -d $(DESTDIR)$(sysconfdir); then \
+		mkdir -p $(DESTDIR)$(sysconfdir); \
+	fi; \
+	if ! test -d $(DESTDIR)$(sysconfdir)/rdma; then \
+		mkdir -p $(DESTDIR)$(sysconfdir)/rdma; \
+	fi; \
+	if ! test -d $(DESTDIR)$(sysconfdir)/init.d; then \
+		mkdir -p $(DESTDIR)$(sysconfdir)/init.d; \
+	fi; \
+	install -m 755 ibacm.init $(DESTDIR)$(sysconfdir)/init.d/ibacmd;
 
 dist-hook: ibacm.spec
 	cp ibacm.spec $(distdir)
diff --git a/acm_addr.cfg b/acm_addr.cfg
deleted file mode 100644
index cfb17de..0000000
--- a/acm_addr.cfg
+++ /dev/null
@@ -1,24 +0,0 @@
-# InfiniBand Communication Management Assistant for clusters address file
-#
-# Use ib_acme utility with -G option to automatically generate a sample
-# acm_addr.cfg file for the current system.
-#
-# Entry format is:
-# address device port pkey
-#
-# The address may be one of the following:
-# host_name - ascii character string, up to 31 characters
-# address - IPv4 or IPv6 formatted address
-#
-# device name - struct ibv_device name
-# port number - valid port number on device (numbering starts at 1)
-# pkey - partition key in hex (can specify 'default' for pkey 0xFFFF)
-#
-# Up to 4 addresses can be associated with a given <device, port, pkey> tuple
-#
-# Samples:
-# node31      ibv_device0 1 default
-# node31-1    ibv_device0 1 0x00FF
-# node31-2    ibv_device0 2 0x00FF
-# 192.168.0.1 ibv_device0 1 0xFFFF
-# 192.168.0.2 ibv_device0 2 default
\ No newline at end of file
diff --git a/acm_opts.cfg b/acm_opts.cfg
deleted file mode 100644
index 7147fe2..0000000
--- a/acm_opts.cfg
+++ /dev/null
@@ -1,130 +0,0 @@
-# InfiniBand Multicast Communication Manager for clusters configuration file
-#
-# Use ib_acme utility with -O option to automatically generate a sample
-# acm_opts.cfg file for the current system.
-#
-# Entry format is:
-# name value
-
-# log_file:
-# Specifies the location of the ACM service output.  The log file is used to
-# assist with ACM service debugging and troubleshooting.  The log_file can
-# be set to 'stdout', 'stderr', or the name of a file.
-# Examples:
-# log_file stdout
-# log_file stderr
-# log_file /var/log/ibacm.log
-
-log_file /var/log/ibacm.log
-
-# log_level:
-# Indicates the amount of detailed data written to the log file.  Log levels
-# should be one of the following values:
-# 0 - basic configuration & errors
-# 1 - verbose configuation & errors
-# 2 - verbose operation
-
-log_level 0
-
-# lock_file:
-# Specifies the location of the ACM lock file used to ensure that only a
-# single instance of ACM is running.
-
-lock_file /var/lock/ibacm.pid
-
-# addr_prot:
-# Default resolution protocol to resolve IP addresses into IB GIDs.
-# Supported protocols are:
-# acm - Use ACM multicast protocol, which is similar to ARP.
-
-addr_prot acm
-
-# route_prot:
-# Default resolution protocol to resolve IB routing information.
-# Supported protocols are:
-# sa - Query SA for path record data and cache results.
-# acm - Use ACM multicast protocol.
-
-route_prot sa
-
-# loopback_prot:
-# Address and route resolution protocol to resolve local addresses
-# Supported protocols are:
-# none - Use same protocols defined for addr_prot and route_prot
-# local - Resolve information used locally available data
-
-loopback_prot local
-
-# server_port:
-# TCP port number that the server listens on.
-# If this value is changed, then a corresponding change is required for
-# client applications.
-
-server_port 6125
-
-# timeout:
-# Additional time, in milliseconds, that the ACM service will wait for a
-# response from a remote ACM service or the IB SA.  The actual request
-# timeout is this value plus the subnet timeout.
-
-timeout 2000
-
-# retries:
-# Number of times that the ACM service will retry a request.  This affects
-# both ACM multicast messages and and IB SA messages.
-
-retries 2
-
-# resolve_depth:
-# Specifies the maximum number of outstanding requests that can be in
-# progress simultaneously.  A larger resolve depth allows for greater
-# parallelism, but increases system resource usage and subnet load.
-# If the number of pending requests is greater than the resolve_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.
-
-resolve_depth 1
-
-# sa_depth:
-# Specifies the maximum number of outstanding requests to the SA that
-# can be in progress simultaneously.  A larger SA depth allows for greater
-# parallelism, but increases system resource usage and SA load.
-# If the number of pending SA requests is greater than the sa_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.  The number of outstanding SA requests
-# is separate from the specified resolve_depth.
-
-sa_depth 1
-
-# send_depth:
-# Specifies the maximum number of outstanding requests that can be in
-# progress simultaneously.  A larger send depth allows for greater
-# parallelism, but increases system resource usage and subnet load.
-# If the number of pending requests is greater than the send_depth,
-# the additional requests will automatically be queued until some of
-# the previous requests complete.
-
-send_depth 1
-
-# recv_depth:
-# Specifies the number of buffers allocated and ready to receive remote
-# requests.  A larger receive depth consumes more system resources, but
-# can avoid dropping requests due to insufficient receive buffers.
-
-recv_depth 1024
-
-# min_mtu:
-# Indicates the minimum MTU supported by the ACM service.  The ACM service
-# negotiates to use the largest MTU available between both sides of a
-# connection.  It is most efficient and recommended that min_mtu be set
-# to the largest MTU value supported by all nodes in a cluster.
-
-min_mtu 2048
-
-# min_rate:
-# Indicates the minimum link rate, in Gbps, supported by the ACM service.
-# The ACM service negotiates to use the highest rate available between both
-# sides of a connection.  It is most efficient and recommended that the
-# min_rate be set to the largest rate supported by all nodes in a cluster.
-
-min_rate 10
diff --git a/ibacm.init b/ibacm.init
new file mode 100644
index 0000000..2cf45fa
--- /dev/null
+++ b/ibacm.init
@@ -0,0 +1,102 @@
+#!/bin/bash
+#
+# Bring up/down the ibacm daemon
+#
+# chkconfig: 2345 25 75
+# description: Starts/Stops InfiniBand ACM service
+#
+### BEGIN INIT INFO
+# Provides:       ibacm
+# Default-Start: 2 3 4 5
+# Default-Stop: 0 1 6
+# Required-Start: rdma $network
+# Required-Stop: rdma $network
+# Should-Start:
+# Should-Stop:
+# Short-Description: Starts and stops the InfiniBand ACM service
+# Description: The InfiniBand ACM service provides a user space implementation
+#	of someting resembling an ARP cache for InfiniBand SA queries and
+#	host route lookups.
+### END INIT INFO
+
+PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
+prog=ibacm
+pidfile=/var/run/$prog.pid
+subsys=/var/lock/subsys/$prog
+progd=$(which $prog)
+
+. /etc/rc.d/init.d/functions
+
+start()
+{
+    echo -n "Starting $prog daemon:"
+
+    daemon $progd
+    RC=$?
+    [ $RC -eq 0 ] && touch $subsys
+    echo
+    return $RC
+}
+
+stop()
+{
+    echo -n "Stopping $prog daemon:"
+
+    killproc -p $pidfile $progd
+    RC=$?
+    rm -f $subsys
+    echo
+    return $RC
+}
+
+status()
+{
+    if [ ! -f $subsys -a ! -f $pidfile ]; then
+    	return 3
+    fi
+    if [ -f $pidfile ]; then
+	checkpid `cat $pidfile`
+	return $?
+    fi
+    if [ -f $subsys ]; then
+	return 2
+    fi
+}
+
+restart ()
+{
+    stop
+    start
+}
+
+condrestart ()
+{
+    [ -e $subsys ] && restart || return 0
+}
+
+usage ()
+{
+    echo
+    echo "Usage: `basename $0` {start|stop|restart|condrestart|try-restart|force-reload|status}"
+    echo
+    return 2
+}
+
+case $1 in
+    start|stop|restart|condrestart|try-restart|force-reload)
+	[ `id -u` != "0" ] && exit 4 ;;
+esac
+
+case $1 in
+    start) start; RC=$? ;;
+    stop) stop; RC=$? ;;
+    restart) restart; RC=$? ;;
+    reload) RC=3 ;;
+    condrestart) condrestart; RC=$? ;;
+    try-restart) condrestart; RC=$? ;;
+    force-reload) condrestart; RC=$? ;;
+    status) status; RC=$? ;;
+    *) usage; RC=$? ;;
+esac
+
+exit $RC
diff --git a/ibacm.spec.in b/ibacm.spec.in
index a926fea..31d5a07 100644
--- a/ibacm.spec.in
+++ b/ibacm.spec.in
@@ -1,53 +1,89 @@
-%define ver @VERSION@
-
 Name: ibacm
 Version: 1.0.5
 Release: 1%{?dist}
 Summary: InfiniBand Communication Manager Assistant
 
-Group: System Environment/Libraries
+Group: System Environment/Daemons
 License: GPLv2 or BSD
 Url: http://www.openfabrics.org/
 Source: http://www.openfabrics.org/downloads/rdmacm/%{name}-%{version}.tar.gz
+Source1: ibacm.init
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 
-BuildRequires: libibverbs-devel >= 1.1-1
+BuildRequires: libibverbs-devel >= 1.1-1, autoconf, libtool, libibumad-devel
+Requires(post): chkconfig
+Requires(preun): chkconfig
+ExcludeArch: s390, s390x
 
 %description
-ibacm assists with establishing communication over Infiniband.
+The ib_acm daemon helps reduce the load of managing path record lookups on
+large InfiniBand fabrics by providing a user space implementation of what
+is functionally similar to an ARP cache.  The use of ib_acm, when properly
+configured, can reduce the SA packet load of a large IB cluster from O(n^2)
+to O(n).  The ib_acm daemon is started and normally runs in the background,
+user applications need not know about this daemon as long as their app
+uses librdmacm to handle connection bring up/tear down.  The librdmacm
+library knows how to talk directly to the ib_acm daemon to retrieve data.
 
-%package svc
-Summary: IB CM pre-connection service application
-Group: System Environment/Libraries
-Requires: %{name} = %{version}-%{release} %{_includedir}/infiniband/verbs.h
+%package devel
+Summary: Headers file needed when building apps to talk directly to ibacm.
+Requires: %{name} = %{version}-%{release}
 
-%description svc
-Application daemon for IB CM pre-connection services.
+%description devel
+Most applications do not need to know how to talk directly to the ibacm
+daemon, but it does have a socket that it listens on, and it has a
+specific protocol for incoming/outgoing data.  So if you wish to build
+the ability to communicate directly with ib_acm into your own application,
+the protocol used to communicate with it, and the data structures
+involved, are in this header file.  Please note that this is an unsupported
+method of using this daemon.  The only supported means of using this is
+via librdmacm.  As such, even though this header file is provided, no
+further documentation is available.  One must read the source if they
+wish to make use of this header file.
 
 %prep
-%setup -q -n %{name}-%{ver}
+%setup -q -n %{name}-%{version}
 
 %build
-%configure
+aclocal -I config && libtoolize --force --copy && autoheader && \
+	automake --foreign --add-missing --copy && autoconf
+%configure --sysconfdir=/etc/rdma CFLAGS="$CXXFLAGS -fno-strict-aliasing" LDFLAGS=-lpthread
 make %{?_smp_mflags}
 
 %install
 rm -rf $RPM_BUILD_ROOT
+make DESTDIR=%{buildroot} install
+install -D -m 755 %{SOURCE1} %{buildroot}%{_initrddir}/ibacm
 %makeinstall
 
 %clean
 rm -rf $RPM_BUILD_ROOT
 
-%post -p /sbin/ldconfig
-%postun -p /sbin/ldconfig
+%post
+if [ $1 = 1 ]; then
+	chkconfig --add ibacm
+fi
+%preun
+if [ $1 = 1 ]; then
+	chkconfig --del ibacm
+fi
 
 %files
 %defattr(-,root,root,-)
 %doc AUTHORS COPYING README
 %{_bindir}/ib_acme
-%{_sbindir}/ib_acm
+%{_sbindir}/ibacm
 %{_mandir}/man1/*
 %{_mandir}/man7/*
+%config(noreplace) %{_sysconfdir}/rdma/*
+%{_initrddir}/ibacm
+
+%files devel
+%defattr(-,root,root,-)
 %{_includedir}/infiniband/acm.h
 
 %changelog
+* Tue Feb 28 2012 Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> - 1.0.5-1
+- Ininital version for rhel6
+- Related: bz700285
+
diff --git a/ibacm_addr.cfg b/ibacm_addr.cfg
new file mode 100644
index 0000000..cfb17de
--- /dev/null
+++ b/ibacm_addr.cfg
@@ -0,0 +1,24 @@
+# InfiniBand Communication Management Assistant for clusters address file
+#
+# Use ib_acme utility with -G option to automatically generate a sample
+# acm_addr.cfg file for the current system.
+#
+# Entry format is:
+# address device port pkey
+#
+# The address may be one of the following:
+# host_name - ascii character string, up to 31 characters
+# address - IPv4 or IPv6 formatted address
+#
+# device name - struct ibv_device name
+# port number - valid port number on device (numbering starts at 1)
+# pkey - partition key in hex (can specify 'default' for pkey 0xFFFF)
+#
+# Up to 4 addresses can be associated with a given <device, port, pkey> tuple
+#
+# Samples:
+# node31      ibv_device0 1 default
+# node31-1    ibv_device0 1 0x00FF
+# node31-2    ibv_device0 2 0x00FF
+# 192.168.0.1 ibv_device0 1 0xFFFF
+# 192.168.0.2 ibv_device0 2 default
\ No newline at end of file
diff --git a/ibacm_opts.cfg b/ibacm_opts.cfg
new file mode 100644
index 0000000..7147fe2
--- /dev/null
+++ b/ibacm_opts.cfg
@@ -0,0 +1,130 @@
+# InfiniBand Multicast Communication Manager for clusters configuration file
+#
+# Use ib_acme utility with -O option to automatically generate a sample
+# acm_opts.cfg file for the current system.
+#
+# Entry format is:
+# name value
+
+# log_file:
+# Specifies the location of the ACM service output.  The log file is used to
+# assist with ACM service debugging and troubleshooting.  The log_file can
+# be set to 'stdout', 'stderr', or the name of a file.
+# Examples:
+# log_file stdout
+# log_file stderr
+# log_file /var/log/ibacm.log
+
+log_file /var/log/ibacm.log
+
+# log_level:
+# Indicates the amount of detailed data written to the log file.  Log levels
+# should be one of the following values:
+# 0 - basic configuration & errors
+# 1 - verbose configuation & errors
+# 2 - verbose operation
+
+log_level 0
+
+# lock_file:
+# Specifies the location of the ACM lock file used to ensure that only a
+# single instance of ACM is running.
+
+lock_file /var/lock/ibacm.pid
+
+# addr_prot:
+# Default resolution protocol to resolve IP addresses into IB GIDs.
+# Supported protocols are:
+# acm - Use ACM multicast protocol, which is similar to ARP.
+
+addr_prot acm
+
+# route_prot:
+# Default resolution protocol to resolve IB routing information.
+# Supported protocols are:
+# sa - Query SA for path record data and cache results.
+# acm - Use ACM multicast protocol.
+
+route_prot sa
+
+# loopback_prot:
+# Address and route resolution protocol to resolve local addresses
+# Supported protocols are:
+# none - Use same protocols defined for addr_prot and route_prot
+# local - Resolve information used locally available data
+
+loopback_prot local
+
+# server_port:
+# TCP port number that the server listens on.
+# If this value is changed, then a corresponding change is required for
+# client applications.
+
+server_port 6125
+
+# timeout:
+# Additional time, in milliseconds, that the ACM service will wait for a
+# response from a remote ACM service or the IB SA.  The actual request
+# timeout is this value plus the subnet timeout.
+
+timeout 2000
+
+# retries:
+# Number of times that the ACM service will retry a request.  This affects
+# both ACM multicast messages and and IB SA messages.
+
+retries 2
+
+# resolve_depth:
+# Specifies the maximum number of outstanding requests that can be in
+# progress simultaneously.  A larger resolve depth allows for greater
+# parallelism, but increases system resource usage and subnet load.
+# If the number of pending requests is greater than the resolve_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.
+
+resolve_depth 1
+
+# sa_depth:
+# Specifies the maximum number of outstanding requests to the SA that
+# can be in progress simultaneously.  A larger SA depth allows for greater
+# parallelism, but increases system resource usage and SA load.
+# If the number of pending SA requests is greater than the sa_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.  The number of outstanding SA requests
+# is separate from the specified resolve_depth.
+
+sa_depth 1
+
+# send_depth:
+# Specifies the maximum number of outstanding requests that can be in
+# progress simultaneously.  A larger send depth allows for greater
+# parallelism, but increases system resource usage and subnet load.
+# If the number of pending requests is greater than the send_depth,
+# the additional requests will automatically be queued until some of
+# the previous requests complete.
+
+send_depth 1
+
+# recv_depth:
+# Specifies the number of buffers allocated and ready to receive remote
+# requests.  A larger receive depth consumes more system resources, but
+# can avoid dropping requests due to insufficient receive buffers.
+
+recv_depth 1024
+
+# min_mtu:
+# Indicates the minimum MTU supported by the ACM service.  The ACM service
+# negotiates to use the largest MTU available between both sides of a
+# connection.  It is most efficient and recommended that min_mtu be set
+# to the largest MTU value supported by all nodes in a cluster.
+
+min_mtu 2048
+
+# min_rate:
+# Indicates the minimum link rate, in Gbps, supported by the ACM service.
+# The ACM service negotiates to use the highest rate available between both
+# sides of a connection.  It is most efficient and recommended that the
+# min_rate be set to the largest rate supported by all nodes in a cluster.
+
+min_rate 10
diff --git a/linux/osd.h b/linux/osd.h
index 33ea842..169e041 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -45,9 +45,15 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 
-#define ACM_DEST_DIR "/etc/ibacm"
-#define ACM_ADDR_FILE "acm_addr.cfg"
-#define ACM_OPTS_FILE "acm_opts.cfg"
+#ifndef SYSCONFDIR
+#define SYSCONFDIR "/etc"
+#endif
+#ifndef BINDIR
+#define BINDIR "/usr/bin"
+#endif
+#define ACM_CONF_DIR  SYSCONFDIR "/rdma"
+#define ACM_ADDR_FILE "ibacm_addr.cfg"
+#define ACM_OPTS_FILE "ibacm_opts.cfg"
 
 #define LIB_DESTRUCTOR __attribute__((destructor))
 #define CDECL_FUNC
diff --git a/man/ib_acm.1 b/man/ib_acm.1
deleted file mode 100644
index af57d0b..0000000
--- a/man/ib_acm.1
+++ /dev/null
@@ -1,130 +0,0 @@
-.TH "ib_acm" 1 "2010-12-08" "ib_acm" "ib_acm" ib_acm
-.SH NAME
-ib_acm \- address and route resolution services for InfiniBand.
-.SH SYNOPSIS
-.sp
-.nf
-\fIib_acm\fR
-.fi
-.SH "DESCRIPTION"
-The IB ACM implements and provides a framework for name,
-address, and route (path) resolution services over InfiniBand.
-It is intended to address connection setup scalability issues running
-MPI applications on large clusters.  The IB ACM provides information
-needed to establish a connection, but does not implement the CM protocol.
-.P
-A primary user of the ib_acm service is the librdmacm library.  This
-enables applications to make use of the ib_acm service without code
-changes or needing to be aware that the service is in use. 
-The librdmacm can invoke IB ACM services when built using the --with-ib_acm
-option.  The IB ACM services tie in under the rdma_resolve_addr,
-rdma_resolve_route, and rdma_getaddrinfo routines.  For maximum benefit,
-the rdma_getaddrinfo routine should be used, however existing applications
-should still see significant connection scaling benefits using the calls
-available in librdmacm 1.0.11 and previous releases.
-.P
-The IB ACM is focused on being scalable and efficient.  The current
-implementation limits network traffic, SA interactions, and centralized
-services.  ACM supports multiple resolution protocols in order to handle
-different fabric topologies.
-.P
-The IB ACM package is comprised of two components: the ib_acm service
-and a test/configuration utility - ib_acme.  Both are userspace components
-and are available for Linux and Windows.  Additional details are given below.
-.SH "QUICK START GUIDE"
-1. Prerequisites: libibverbs and libibumad must be installed.
-The IB stack should be running with IPoIB configured.
-These steps assume that the user has administrative privileges.
-.P
-2. Install the IB ACM package.  This installs ib_acm, and ib_acme.
-.P
-3. Run 'ib_acm' as administrator to start the ib_acm daemon.
-.P
-4. Optionally, run 'ib_acme -d <dest_ip> -v' to verify that
-the ib_acm service is running.
-.P
-5. Install librdmacm using the build option --with-ib_acm.
-The librdmacm will automatically use the ib_acm service.
-On failures, the librdmacm will fall back to normal resolution.
-.SH "NOTES"
-ib_acme:
-.P
-The ib_acme program serves a dual role.  It acts as a utility to test
-ib_acm operation and help verify if the ib_acm service and selected
-protocol is usable for a given cluster configuration.   Additionally,
-it automatically generates ib_acm configuration files to assist with
-or eliminate manual setup.
-.P
-acm configuration files:
-.P
-The ib_acm service relies on two configuration files.
-.P
-The acm_addr.cfg file contains name and address mappings for each IB
-<device, port, pkey> endpoint.  Although the names in the acm_addr.cfg
-file can be anything, ib_acme maps the host name and IP addresses to
-the IB endpoints.  If the address file cannot be found, the ib_acm
-service will attempt to create one using default values.
-.P
-The acm_opts.cfg file provides a set of configurable options for the
-ib_acm service, such as timeout, number of retries, logging level, etc.
-ib_acme generates the acm_opts.cfg file using static information.  If
-an option file cannot be found, ib_acm will use default values. 
-.P
-ib_acm:
-.P
-The ib_acm service is responsible for resolving names and addresses to
-InfiniBand path information and caching such data.  It
-should execute with administrative privileges.
-.P
-The ib_acm implements a client interface over TCP sockets, which is
-abstracted by the librdmacm library.  One or more back-end protocols are
-used by the ib_acm service to satisfy user requests.  Although the
-ib_acm supports standard SA path record queries on the back-end, it
-also supports a resolution protocol based on multicast traffic.
-The latter is not usable on all fabric topologies, specifically
-ones that may not have reversible paths or fabrics using torus routing.
-Users should use the ib_acme utility to verify that multicast protocol
-is usable before running other applications.
-.P
-Conceptually, the ib_acm service implements an ARP like protocol and either
-uses IB multicast records to construct path record data or queries the
-SA directly, depending on the selected route protocol.  By default, the
-ib_acm services uses and caches SA path record queries.
-.P
-Specifically, all IB endpoints join a number of multicast groups.
-Multicast groups differ based on rates, mtu, sl, etc., and are prioritized.
-All participating endpoints must be able to communicate on the lowest
-priority multicast group.  The ib_acm assigns one or more names/addresses
-to each IB endpoint using the acm_addr.cfg file.  Clients provide source
-and destination names or addresses as input to the service, and receive
-as output path record data.
-.P
-The service maps a client's source name/address to a local IB endpoint.
-If a client does not provide a source address, then the ib_acm service
-will select one based on the destination and local routing tables.  If the
-destination name/address is not cached locally, it sends a multicast
-request out on the lowest priority multicast group on the local endpoint.
-The request carries a list of multicast groups that the sender can use.
-The recipient of the request selects the highest priority multicast group
-that it can use as well and returns that information directly to the sender.
-The request data is cached by all endpoints that receive the multicast
-request message.  The source endpoint also caches the response and uses
-the multicast group that was selected to construct or obtain path record
-data, which is returned to the client.
-.P
-The current implementation of the IB ACM has several additional restrictions:
-.P
-- The ib_acm is limited in its handling of dynamic changes.
-ib_acm must be stopped and restarted if a cluster is reconfigured.
-.P
-- Cached data does not timed out and is only updated if a new resolution
-request is received from a different QPN than a cached request.
-.P
-- Support for IPv6 has not been verified.
-.P
-- The number of addresses that can be assigned to a single endpoint is
-limited to 4.
-.P
-- The number of multicast groups that an endpoint can support is limited to 2.
-.SH "SEE ALSO"
-ib_acm(7) ib_acme(1), rdma_cm(7)
diff --git a/man/ib_acm.7 b/man/ib_acm.7
deleted file mode 100644
index f26ffb8..0000000
--- a/man/ib_acm.7
+++ /dev/null
@@ -1,33 +0,0 @@
-.TH "IB_ACM" 7 "2009-09-09" "IB_ACM" "IB ACM User Guide" IB_ACM
-.SH NAME
-ib_acm \- InfiniBand communication management assistant
-.SH SYNOPSIS
-.B "#include <infiniband/ib_acm.h>"
-.SH "DESCRIPTION"
-Used to resolve remote endpoint information before establishing communications
-over InfiniBand.
-.SH "NOTES"
-Th IB ACM provides scalable address and route resolution services over
-InfiniBand.  It resolves system network names and IP addresses to InfiniBand
-path record data using efficient mechanisms, including caching of data.
-.P
-The IB ACM provides information needed to establish a connection, but does
-not implement the communication management protocol.  It provides services
-similar to rdma_getaddrinfo, rdma_resolve_addr, and rdma_resolve_route using
-IB multicast.
-The IB ACM does not require IPoIB or use standard naming services, such as
-DNS, and limits network communication, especially with the IB SA.
-Because it uses multicast traffic and limits SA interaction, it may
-not support all cluster configurations.  The ib_acme utility assists in
-verifying what options of the ib_acm service may be usable.
-.P
-Client interactions with the ib_acm service are done over sockets through
-a standard TCP connection.  The librdmacm abstracts this interaction.
-.SH "RETURN CODES"
-.IP "== 0"
-success
-.IP "!= 0"
-error
-.SH "SEE ALSO"
-ib_acm_resolve_name(3), ib_acm_resolve_ip(3), ib_acm_resolve_path(3)
-ib_acme(1), ib_acm(1)
diff --git a/man/ib_acme.1 b/man/ib_acme.1
index 9e44822..a00e64e 100644
--- a/man/ib_acme.1
+++ b/man/ib_acme.1
@@ -10,10 +10,10 @@ ib_acme \- test and configuration utility for the IB ACM
 \fIib_acme\fR [-G] [-O]
 .fi
 .SH "DESCRIPTION"
-ib_acme provides assistance configuring and testing the ib_acm service.
-The first usage of the service will test that the ib_acm is running
+ib_acme provides assistance configuring and testing the ibacm service.
+The first usage of the service will test that the ibacm is running
 and operating correctly.  The second usage model will automatically
-create address and configuration files for the ib_acm service.
+create address and configuration files for the ibacm service.
 .SH "OPTIONS"
 .TP
 \-f addr_format
@@ -64,13 +64,13 @@ generated files are text based and may be edited.  These options are intended
 to provide a simple way to configure address and option information on all
 nodes on a cluster.
 .P
-The other function of the ib_acme utility is to test the ib_acm service,
+The other function of the ib_acme utility is to test the ibacm service,
 including helping to verify that the service is usable given the current
 cluster configuration.  The ib_acme utility can resolve IP addresses,
 network names, or IB LIDs into a path record.  It can then compare that
 path record against one obtained by the SA.  When used to test the
-ib_acm service, the ib_acme utility has the side effect of loading the
-ib_acm caches.
+ibacm service, the ib_acme utility has the side effect of loading the
+ibacm caches.
 .P
 Multiple, numerical destinations can be specified by adding brackets [] to
 the end of a base destination name or address.  Users may specify a list of
@@ -78,4 +78,4 @@ numerical ranges inside the brackets using the following example as a
 guide: node[1-3,5,7-8].  This will result in testing node1, node2, node3,
 node5, node7, and node8.   
 .SH "SEE ALSO"
-ib_acm(7) ib_acm(1)
+ib_acm(7) ibacm(1)
diff --git a/man/ibacm.1 b/man/ibacm.1
new file mode 100644
index 0000000..ed4b7a5
--- /dev/null
+++ b/man/ibacm.1
@@ -0,0 +1,130 @@
+.TH "ibacm" 1 "2012-03-01" "ibacm" "ibacm" ibacm
+.SH NAME
+ibacm \- address and route resolution services for InfiniBand.
+.SH SYNOPSIS
+.sp
+.nf
+\fIibacm\fR
+.fi
+.SH "DESCRIPTION"
+The IB ACM implements and provides a framework for name,
+address, and route (path) resolution services over InfiniBand.
+It is intended to address connection setup scalability issues running
+MPI applications on large clusters.  The IB ACM provides information
+needed to establish a connection, but does not implement the CM protocol.
+.P
+A primary user of the ibacm service is the librdmacm library.  This
+enables applications to make use of the ibacm service without code
+changes or needing to be aware that the service is in use. 
+The librdmacm can invoke IB ACM services when built using the --with-ib_acm
+option.  The IB ACM services tie in under the rdma_resolve_addr,
+rdma_resolve_route, and rdma_getaddrinfo routines.  For maximum benefit,
+the rdma_getaddrinfo routine should be used, however existing applications
+should still see significant connection scaling benefits using the calls
+available in librdmacm 1.0.11 and previous releases.
+.P
+The IB ACM is focused on being scalable and efficient.  The current
+implementation limits network traffic, SA interactions, and centralized
+services.  ACM supports multiple resolution protocols in order to handle
+different fabric topologies.
+.P
+The IB ACM package is comprised of two components: the ibacm service
+and a test/configuration utility - ib_acme.  Both are userspace components
+and are available for Linux and Windows.  Additional details are given below.
+.SH "QUICK START GUIDE"
+1. Prerequisites: libibverbs and libibumad must be installed.
+The IB stack should be running with IPoIB configured.
+These steps assume that the user has administrative privileges.
+.P
+2. Install the IB ACM package.  This installs ibacm, and ib_acme.
+.P
+3. Run 'ibacm' as administrator to start the ibacm daemon.
+.P
+4. Optionally, run 'ib_acme -d <dest_ip> -v' to verify that
+the ibacm service is running.
+.P
+5. Install librdmacm using the build option --with-ib_acm.
+The librdmacm will automatically use the ibacm service.
+On failures, the librdmacm will fall back to normal resolution.
+.SH "NOTES"
+ib_acme:
+.P
+The ib_acme program serves a dual role.  It acts as a utility to test
+ibacm operation and help verify if the ibacm service and selected
+protocol is usable for a given cluster configuration.   Additionally,
+it automatically generates ibacm configuration files to assist with
+or eliminate manual setup.
+.P
+acm configuration files:
+.P
+The ibacm service relies on two configuration files.
+.P
+The acm_addr.cfg file contains name and address mappings for each IB
+<device, port, pkey> endpoint.  Although the names in the acm_addr.cfg
+file can be anything, ib_acme maps the host name and IP addresses to
+the IB endpoints.  If the address file cannot be found, the ibacm
+service will attempt to create one using default values.
+.P
+The acm_opts.cfg file provides a set of configurable options for the
+ibacm service, such as timeout, number of retries, logging level, etc.
+ib_acme generates the acm_opts.cfg file using static information.  If
+an option file cannot be found, ibacm will use default values. 
+.P
+ibacm:
+.P
+The ibacm service is responsible for resolving names and addresses to
+InfiniBand path information and caching such data.  It
+should execute with administrative privileges.
+.P
+The ibacm implements a client interface over TCP sockets, which is
+abstracted by the librdmacm library.  One or more back-end protocols are
+used by the ibacm service to satisfy user requests.  Although the
+ibacm supports standard SA path record queries on the back-end, it
+also supports a resolution protocol based on multicast traffic.
+The latter is not usable on all fabric topologies, specifically
+ones that may not have reversible paths or fabrics using torus routing.
+Users should use the ib_acme utility to verify that multicast protocol
+is usable before running other applications.
+.P
+Conceptually, the ibacm service implements an ARP like protocol and either
+uses IB multicast records to construct path record data or queries the
+SA directly, depending on the selected route protocol.  By default, the
+ibacm services uses and caches SA path record queries.
+.P
+Specifically, all IB endpoints join a number of multicast groups.
+Multicast groups differ based on rates, mtu, sl, etc., and are prioritized.
+All participating endpoints must be able to communicate on the lowest
+priority multicast group.  The ibacm assigns one or more names/addresses
+to each IB endpoint using the acm_addr.cfg file.  Clients provide source
+and destination names or addresses as input to the service, and receive
+as output path record data.
+.P
+The service maps a client's source name/address to a local IB endpoint.
+If a client does not provide a source address, then the ibacm service
+will select one based on the destination and local routing tables.  If the
+destination name/address is not cached locally, it sends a multicast
+request out on the lowest priority multicast group on the local endpoint.
+The request carries a list of multicast groups that the sender can use.
+The recipient of the request selects the highest priority multicast group
+that it can use as well and returns that information directly to the sender.
+The request data is cached by all endpoints that receive the multicast
+request message.  The source endpoint also caches the response and uses
+the multicast group that was selected to construct or obtain path record
+data, which is returned to the client.
+.P
+The current implementation of the IB ACM has several additional restrictions:
+.P
+- The ibacm is limited in its handling of dynamic changes.
+ibacm must be stopped and restarted if a cluster is reconfigured.
+.P
+- Cached data does not timed out and is only updated if a new resolution
+request is received from a different QPN than a cached request.
+.P
+- Support for IPv6 has not been verified.
+.P
+- The number of addresses that can be assigned to a single endpoint is
+limited to 4.
+.P
+- The number of multicast groups that an endpoint can support is limited to 2.
+.SH "SEE ALSO"
+ibacm(7) ib_acme(1), rdma_cm(7)
diff --git a/man/ibacm.7 b/man/ibacm.7
new file mode 100644
index 0000000..c0c63fc
--- /dev/null
+++ b/man/ibacm.7
@@ -0,0 +1,31 @@
+.TH "IBACM" 7 "2012-03-01" "IBACM" "IB ACM User Guide" IBACM
+.SH NAME
+ibacm \- InfiniBand communication management assistant
+.SH SYNOPSIS
+.B "#include <infiniband/ib_acm.h>"
+.SH "DESCRIPTION"
+Used to resolve remote endpoint information before establishing communications
+over InfiniBand.
+.SH "NOTES"
+Th IB ACM provides scalable address and route resolution services over
+InfiniBand.  It resolves system network names and IP addresses to InfiniBand
+path record data using efficient mechanisms, including caching of data.
+.P
+The IB ACM provides information needed to establish a connection, but does
+not implement the communication management protocol.  It provides services
+similar to rdma_getaddrinfo, rdma_resolve_addr, and rdma_resolve_route using
+IB multicast.
+The IB ACM does not require IPoIB or use standard naming services, such as
+DNS, and limits network communication, especially with the IB SA.
+The ib_acme utility assists in verifying what options of the ibacm service
+may be usable for the current fabric topology.
+.P
+Client interactions with the ibacm service are done over sockets through
+a standard TCP connection.  The librdmacm abstracts this interaction.
+.SH "RETURN CODES"
+.IP "== 0"
+success
+.IP "!= 0"
+error
+.SH "SEE ALSO"
+ib_acme(1), ibacm(1)
diff --git a/src/acm.c b/src/acm.c
index 906c926..4e90e8c 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -205,11 +205,12 @@ static atomic_t counter[ACM_MAX_COUNTER];
 /*
  * Service options - may be set through acm_opts file.
  */
-static char *opts_file = "/etc/ibacm/acm_opts.cfg";
-static char *addr_file = "/etc/ibacm/acm_addr.cfg";
+static char *acme = BINDIR "/ib_acme -A";
+static char *opts_file = ACM_CONF_DIR "/" ACM_OPTS_FILE;
+static char *addr_file = ACM_CONF_DIR "/" ACM_ADDR_FILE;
 static char log_file[128] = "/var/log/ibacm.log";
 static int log_level = 0;
-static char lock_file[128] = "/var/lock/ibacm.pid";
+static char lock_file[128] = "/var/run/ibacm.pid";
 static enum acm_addr_prot addr_prot = ACM_ADDR_PROT_ACM;
 static enum acm_route_prot route_prot = ACM_ROUTE_PROT_ACM;
 static enum acm_loopback_prot loopback_prot = ACM_LOOPBACK_PROT_LOCAL;
@@ -2507,9 +2508,9 @@ static FILE *acm_open_addr_file(void)
 	if ((f = fopen(addr_file, "r")))
 		return f;
 
-	acm_log(0, "notice - generating acm_addr.cfg file\n");
-	if (!(f = popen("ib_acme -A", "r"))) {
-		acm_log(0, "ERROR - cannot generate acm_addr.cfg\n");
+	acm_log(0, "notice - generating %s file\n", addr_file);
+	if (!(f = popen(acme, "r"))) {
+		acm_log(0, "ERROR - cannot generate %s\n", addr_file);
 		return NULL;
 	}
 	pclose(f);
@@ -3156,9 +3157,9 @@ static void show_usage(char *program)
 	printf("   [-D]             - run as a daemon (default)\n");
 	printf("   [-P]             - run as a standard process\n");
 	printf("   [-A addr_file]   - address configuration file\n");
-	printf("                      (default %s/%s\n", ACM_DEST_DIR, ACM_ADDR_FILE);
+	printf("                      (default %s/%s\n", ACM_CONF_DIR, ACM_ADDR_FILE);
 	printf("   [-O option_file] - option configuration file\n");
-	printf("                      (default %s/%s\n", ACM_DEST_DIR, ACM_OPTS_FILE);
+	printf("                      (default %s/%s\n", ACM_CONF_DIR, ACM_OPTS_FILE);
 }
 
 int CDECL_FUNC main(int argc, char **argv)
diff --git a/src/acme.c b/src/acme.c
index 3d7461b..5bc6461 100644
--- a/src/acme.c
+++ b/src/acme.c
@@ -43,7 +43,7 @@
 #include <infiniband/acm.h>
 #include "libacm.h"
 
-static char *dest_dir = ACM_DEST_DIR;
+static char *dest_dir = ACM_CONF_DIR;
 static char *addr_file = ACM_ADDR_FILE;
 static char *opts_file = ACM_OPTS_FILE;
 
@@ -69,7 +69,7 @@ extern char **parse(char *args, int *count);
 static void show_usage(char *program)
 {
 	printf("usage 1: %s\n", program);
-	printf("Query specified ib_acm service for data\n");
+	printf("Query specified ibacm service for data\n");
 	printf("   [-f addr_format] - i(p), n(ame), l(id), g(gid), or u(nspecified)\n");
 	printf("                      address format for -s and -d options, default: 'u'\n");
 	printf("   [-s src_addr]    - source address for path queries\n");
@@ -79,13 +79,13 @@ static void show_usage(char *program)
 	printf("   [-P]             - query performance data from destination service\n");
 	printf("   [-S svc_addr]    - address of ACM service, default: local service\n");
 	printf("usage 2: %s\n", program);
-	printf("Generate default ib_acm service configuration and option files\n");
+	printf("Generate default ibacm service configuration and option files\n");
 	printf("   -A [addr_file]   - generate local address configuration file\n");
 	printf("                      (default is %s)\n", ACM_ADDR_FILE);
-	printf("   -O [opt_file]    - generate local acm_opts.cfg options file\n");
+	printf("   -O [opt_file]    - generate local ibacm_opts.cfg options file\n");
 	printf("                      (default is %s)\n", ACM_OPTS_FILE);
 	printf("   -D dest_dir      - specify destination directory for output files\n");
-	printf("                      (default is %s)\n", ACM_DEST_DIR);
+	printf("                      (default is %s)\n", ACM_CONF_DIR);
 	printf("   -V               - enable verbose output\n");
 }
 
@@ -94,7 +94,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# InfiniBand Multicast Communication Manager for clusters configuration file\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Use ib_acme utility with -O option to automatically generate a sample\n");
-	fprintf(f, "# acm_opts.cfg file for the current system.\n");
+	fprintf(f, "# ibacm_opts.cfg file for the current system.\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Entry format is:\n");
 	fprintf(f, "# name value\n");
@@ -123,7 +123,7 @@ static void gen_opts_temp(FILE *f)
 	fprintf(f, "# Specifies the location of the ACM lock file used to ensure that only a\n");
 	fprintf(f, "# single instance of ACM is running.\n");
 	fprintf(f, "\n");
-	fprintf(f, "lock_file /var/lock/ibacm.pid\n");
+	fprintf(f, "lock_file /var/run/ibacm.pid\n");
 	fprintf(f, "\n");
 	fprintf(f, "# addr_prot:\n");
 	fprintf(f, "# Default resolution protocol to resolve IP addresses into IB GIDs.\n");
@@ -253,7 +253,7 @@ static void gen_addr_temp(FILE *f)
 	fprintf(f, "# InfiniBand Communication Management Assistant for clusters address file\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Use ib_acme utility with -G option to automatically generate a sample\n");
-	fprintf(f, "# acm_addr.cfg file for the current system.\n");
+	fprintf(f, "# ibacm_addr.cfg file for the current system.\n");
 	fprintf(f, "#\n");
 	fprintf(f, "# Entry format is:\n");
 	fprintf(f, "# address device port pkey\n");


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
