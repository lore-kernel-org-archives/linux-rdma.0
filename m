From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3] infiniband-diags: add rdma-ndd daemon
Date: Sun, 16 Nov 2014 03:39:43 -0500
Message-ID: <1416127183-32735-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rdma-ndd is a system daemon which watches the procfs hostname file as well as
monitoring for InfiniBand libudev device changes.

Upon detecting changes it will update the Node Descriptions of the RDMA devices
in the system.

This deamon is intended to work with kernels which support polling of the
procfs hostname.  If your kernel does not support this feature the daemon
will set the Node Descriptions to the hostname at start up only.

ibdiag.conf can be used to specify a node description format with the following
format specifier support.

%h == current hostname
%d == device name

Regardless of previous settings, all NDs are written at startup and
individually when a new device is detected.  Otherwise the ND is compared to
the existing one and not written if it has not changed.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

Changes from V2:
	Kernel Node Description change support is no longer required
	Node Description format specifiers can be set via ibdiags.conf
	libudev is now required to detect device adds
	Use rst man page processing to include ibdiags.conf documentation
	Minor code clean ups
	

 Makefile.am               |   8 +-
 configure.ac              |  23 +++
 doc/man/rdma-ndd.8.in     | 102 ++++++++++++
 doc/rst/rdma-ndd.8.in.rst |  85 ++++++++++
 etc/ibdiag.conf           |   3 +
 etc/rdma-ndd.init.in      | 137 ++++++++++++++++
 include/ibdiag_common.h   |   1 +
 infiniband-diags.spec.in  |  40 ++++-
 src/ibdiag_common.c       |   4 +
 src/rdma-ndd.c            | 400 ++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 799 insertions(+), 4 deletions(-)
 create mode 100644 doc/man/rdma-ndd.8.in
 create mode 100644 doc/rst/rdma-ndd.8.in.rst
 create mode 100644 etc/rdma-ndd.init.in
 create mode 100644 src/rdma-ndd.c

diff --git a/Makefile.am b/Makefile.am
index f44b4d6..4e08c2b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,8 @@ sbin_PROGRAMS = src/ibaddr src/ibnetdiscover src/ibping src/ibportstate \
 	        src/saquery src/vendstat src/iblinkinfo \
 		src/ibqueryerrors src/ibcacheedit src/ibccquery \
 		src/ibccconfig \
-		src/dump_fts
+		src/dump_fts \
+		src/rdma-ndd
 
 if ENABLE_TEST_UTILS
 sbin_PROGRAMS += src/ibsendtrap src/mcm_rereg_test
@@ -70,6 +71,7 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/smpquery.8 \
 		doc/man/vendstat.8 \
 		doc/man/infiniband-diags.8 \
+		doc/man/rdma-ndd.8 \
 		man/dump_lfts.8 \
 		man/dump_mfts.8
 
@@ -158,3 +160,7 @@ install-data-hook:
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
 	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
+
+install-exec-hook:
+	$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/init.d
+	$(top_srcdir)/config/install-sh -m 755 $(top_srcdir)/etc/rdma-ndd.init $(DESTDIR)/$(sysconfdir)/init.d/rdma-ndd
diff --git a/configure.ac b/configure.ac
index af5a5f4..c84b76e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,6 +180,27 @@ fi
 AC_SUBST(ibnetdisc_api_version)
 dnl End libibnetdisc stuff
 
+dnl configures for rdma-ndd startup script
+default_rdma_service=openibd
+AC_ARG_WITH([rdma_service],
+    AC_HELP_STRING([--with-rdma-service=name],
+                       [name of the RDMA service: "rdma" when using /etc/init.d/rdma to start RDMA services; "openibd" when using /etc/init.d/openibd to start RDMA services [default=${default_rdma_service}]]))
+AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})
+
+if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
+	default_stop="0 1 4 6"
+else
+	default_stop="0 1 6"
+fi
+
+default_start="null"
+
+AC_SUBST(DEFAULT_START, $default_start)
+AC_SUBST(DEFAULT_STOP, $default_stop)
+
+AC_CHECK_HEADER(libudev.h, with_udev="yes", with_udev="no")
+AC_CHECK_LIB(udev, udev_monitor_ref, [], AC_MSG_ERROR(libudev is required for rdma-ndd...))
+
 dnl Generate doc/man/*.in files if possible
 DOC_DATE="`date +%Y-%m-%d`"
 AC_SUBST(BUILD_DATE)
@@ -253,6 +274,8 @@ AC_CONFIG_FILES([\
 	doc/man/smpquery.8 \
 	doc/man/vendstat.8 \
 	doc/man/infiniband-diags.8 \
+	doc/man/rdma-ndd.8 \
+	etc/rdma-ndd.init \
 	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
diff --git a/doc/man/rdma-ndd.8.in b/doc/man/rdma-ndd.8.in
new file mode 100644
index 0000000..1a7a1bb
--- /dev/null
+++ b/doc/man/rdma-ndd.8.in
@@ -0,0 +1,102 @@
+.\" Man page generated from reStructuredText.
+.
+.TH RDMA-NDD 8 "@BUILD_DATE@" "" "OpenIB Diagnostics"
+.SH NAME
+RDMA-NDD \- RDMA device Node Description update daemon
+.
+.nr rst2man-indent-level 0
+.
+.de1 rstReportMargin
+\\$1 \\n[an-margin]
+level \\n[rst2man-indent-level]
+level margin: \\n[rst2man-indent\\n[rst2man-indent-level]]
+-
+\\n[rst2man-indent0]
+\\n[rst2man-indent1]
+\\n[rst2man-indent2]
+..
+.de1 INDENT
+.\" .rstReportMargin pre:
+. RS \\$1
+. nr rst2man-indent\\n[rst2man-indent-level] \\n[an-margin]
+. nr rst2man-indent-level +1
+.\" .rstReportMargin post:
+..
+.de UNINDENT
+. RE
+.\" indent \\n[an-margin]
+.\" old: \\n[rst2man-indent\\n[rst2man-indent-level]]
+.nr rst2man-indent-level -1
+.\" new: \\n[rst2man-indent\\n[rst2man-indent-level]]
+.in \\n[rst2man-indent\\n[rst2man-indent-level]]u
+..
+.SH SYNOPSIS
+.sp
+rdma\-ndd <options>
+.SH DESCRIPTION
+.sp
+rdma\-ndd is a system daemon which watches for rdma device changes and/or
+hostname changes and updates the Node Description of the rdma devices based on
+those changes.
+.SH DETAILS
+.sp
+Full operation of this deamon requires kernels which support polling of the
+procfs hostname file as well as libudev.
+.sp
+If your system does not support either of these features, the daemon will set
+the Node Descriptions at start up and then sleep forever.
+.SS Node Description format
+.sp
+The deamon uses the nd_format configuration option within the ibdiags.conf
+file.  %h and %d can be used as wildcards in that string to specify the dynamic
+use of <hostname> and <device> respectively.
+.sp
+NOTE: At startup and on new device detection the Node Description is always
+written to ensure the SM and this daemon are in sync.  Subsequent events will
+only write the Node Description on a device if it has changed.
+.SH OPTIONS
+.sp
+\fB\-\-retry_timer, \-t\fP
+Length of time to sleep when system errors occur when attempting to poll and or read the hostname from the system.
+.sp
+\fB\-\-retry_count, \-r\fP
+Number of times to attempt to retry setting of the node description on failure.  Default 0
+.sp
+\fB\-\-foreground, \-f\fP
+Run in the foreground instead of as a daemon
+.SS Configuration flags
+.\" Define the common option -z
+.
+.sp
+\fB\-\-config, \-z  <config_file>\fP Specify alternate config file.
+.INDENT 0.0
+.INDENT 3.5
+Default: @IBDIAG_CONFIG_PATH@/ibdiag.conf
+.UNINDENT
+.UNINDENT
+.SS Debugging flags
+.\" Define the common option -h
+.
+.sp
+\fB\-h, \-\-help\fP      show the usage message
+.\" Define the common option -V
+.
+.sp
+\fB\-V, \-\-version\fP     show the version info.
+.SH FILES
+.\" Common text for the config file
+.
+.SS CONFIG FILE
+.sp
+@IBDIAG_CONFIG_PATH@/ibdiag.conf
+.sp
+A global config file is provided to set some of the common options for all
+tools.  See supplied config file for details.
+.SH AUTHOR
+.INDENT 0.0
+.TP
+.B Ira Weiny
+< \fI\%ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org\fP >
+.UNINDENT
+.\" Generated by docutils manpage writer.
+.
diff --git a/doc/rst/rdma-ndd.8.in.rst b/doc/rst/rdma-ndd.8.in.rst
new file mode 100644
index 0000000..afe7470
--- /dev/null
+++ b/doc/rst/rdma-ndd.8.in.rst
@@ -0,0 +1,85 @@
+========
+RDMA-NDD
+========
+
+------------------------------------------
+RDMA device Node Description update daemon
+------------------------------------------
+
+:Date: @BUILD_DATE@
+:Manual section: 8
+:Manual group: OpenIB Diagnostics
+
+
+SYNOPSIS
+========
+
+rdma-ndd <options>
+
+DESCRIPTION
+===========
+
+rdma-ndd is a system daemon which watches for rdma device changes and/or
+hostname changes and updates the Node Description of the rdma devices based on
+those changes.
+
+
+DETAILS
+=======
+
+Full operation of this deamon requires kernels which support polling of the
+procfs hostname file as well as libudev.
+
+If your system does not support either of these features, the daemon will set
+the Node Descriptions at start up and then sleep forever.
+
+
+Node Description format
+-----------------------
+
+The deamon uses the nd_format configuration option within the ibdiags.conf
+file.  %h and %d can be used as wildcards in that string to specify the dynamic
+use of <hostname> and <device> respectively.
+
+NOTE: At startup and on new device detection the Node Description is always
+written to ensure the SM and this daemon are in sync.  Subsequent events will
+only write the Node Description on a device if it has changed.
+
+
+OPTIONS
+=======
+
+**--retry_timer, -t**
+Length of time to sleep when system errors occur when attempting to poll and or read the hostname from the system.
+
+**--retry_count, -r**
+Number of times to attempt to retry setting of the node description on failure.  Default 0
+
+**--foreground, -f**
+Run in the foreground instead of as a daemon
+
+
+Configuration flags
+-------------------
+
+.. include:: common/opt_z-config.rst
+
+Debugging flags
+---------------
+
+.. include:: common/opt_h.rst
+.. include:: common/opt_V.rst
+
+
+
+FILES
+=====
+
+.. include:: common/sec_config-file.rst
+
+
+AUTHOR
+======
+
+Ira Weiny
+        < ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org >
diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
index 9686d14..839b373 100644
--- a/etc/ibdiag.conf
+++ b/etc/ibdiag.conf
@@ -20,3 +20,6 @@
 
 # default smkey to be used for SA requests
 #sa_key=0x00
+
+# Set the Node Description format to be used by rdma-ndd
+#nd_format=%h %d
diff --git a/etc/rdma-ndd.init.in b/etc/rdma-ndd.init.in
new file mode 100644
index 0000000..41747f2
--- /dev/null
+++ b/etc/rdma-ndd.init.in
@@ -0,0 +1,137 @@
+#!/bin/bash
+#
+# rdma-ndd:		Manage RDMA Node Description Daemon
+#
+# chkconfig: - 09 91
+# description:  Manage RDMA Node Description Daemon
+#
+### BEGIN INIT INFO
+# Provides: rdma-ndd
+# Required-Start: $syslog @RDMA_SERVICE@
+# Required-Stop: $syslog @RDMA_SERVICE@
+# Default-Start: @DEFAULT_START@
+# Default-Stop: @DEFAULT_STOP@
+# Description:  Manage RDMA Node Description Daemon
+### END INIT INFO
+#
+# Copyright (c) 2014 Intel Corporation. All Rights Reserved
+# Copyright (c) 2008 Voltaire, Inc. All rights reserved.
+# Copyright 2006 PathScale, Inc.  All Rights Reserved.
+#
+# This Software is licensed under one of the following licenses:
+#
+# 1) under the terms of the "Common Public License 1.0" a copy of which is
+#    available from the Open Source Initiative, see
+#    http://www.opensource.org/licenses/cpl.php.
+#
+# 2) under the terms of the "The BSD License" a copy of which is
+#    available from the Open Source Initiative, see
+#    http://www.opensource.org/licenses/bsd-license.php.
+#
+# 3) under the terms of the "GNU General Public License (GPL) Version 2" a
+#    copy of which is available from the Open Source Initiative, see
+#    http://www.opensource.org/licenses/gpl-license.php.
+#
+# Licensee has the right to choose one of the above licenses.
+#
+# Redistributions of source code must retain the above copyright
+# notice and one of the license notices.
+#
+# Redistributions in binary form must reproduce both the above copyright
+# notice, one of the license notices in the documentation
+# and/or other materials provided with the distribution.
+
+pidfile=/var/run/rdma-ndd.pid
+
+# Source function library.
+if [[ -s /etc/init.d/functions ]]; then
+    # RHEL / CentOS / SL / Fedora.
+    . /etc/init.d/functions
+    rc_status() { :; }
+    rc_exit() { exit $RETVAL; }
+elif [[ -s /lib/lsb/init-functions ]]; then
+    # SLES / openSuSE / Debian.
+    . /lib/lsb/init-functions
+    rc_exit() { exit $RETVAL; }
+    success() { log_success_msg; }
+    failure() { log_failure_msg; }
+elif [[ -s /etc/rc.status ]]; then
+    # Older SuSE systems.
+    . /etc/rc.status
+    failure() { rc_status -v; }
+    success() { rc_status -v; }
+fi
+
+running () {
+    [ -e $pidfile ] &&
+        [ "$(readlink "/proc/$(<$pidfile)/exe")" = "@sbindir@/rdma-ndd" ]
+}
+
+start () {
+    if running; then
+	echo Already started
+	return 1
+    fi
+    echo -n "Starting RDMA Node Description Daemon: "
+    @sbindir@/rdma-ndd > /dev/null
+    RETVAL=$?
+    if [[ $RETVAL -eq 0 ]]; then
+        success
+    else
+        failure
+    fi
+    echo
+}
+
+stop () {
+    echo -n "Shutting down RDMA Node Description Daemon (rdma-ndd): "
+    killproc rdma-ndd
+    RETVAL=$?
+    if [[ $RETVAL -eq 0 ]]; then
+        success
+    else
+        failure
+    fi
+    echo
+}
+
+Xstatus () {
+	pid="`pidof rdma-ndd`"
+	ret=$?
+	if [ $ret -eq 0 ] ; then
+		echo "RDMA Node Description Daemon (rdma-ndd) is running... pid=$pid"
+	else
+		echo "RDMA Node Description Daemon (rdma-ndd) is not running."
+	fi
+}
+
+restart() {
+    stop
+    start
+}
+
+# See how we were called.
+case "$1" in
+    start)
+	start
+	;;
+    stop)
+	stop
+	;;
+    status)
+        Xstatus
+	;;
+    restart | force-reload | reload)
+	restart
+	;;
+    try-restart | condrestart)
+	[ -e $pidfile ] && restart
+	;;
+    *)
+	echo $"Usage: $0 {start|stop|status|restart|reload|condrestart}"
+	RETVAL=1
+	;;
+esac
+
+_rc_status_all=$RETVAL
+rc_exit
diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index ef3a46b..fd84f2d 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -54,6 +54,7 @@ extern uint32_t ibd_ibnetdisc_flags;
 extern uint64_t ibd_mkey;
 extern uint64_t ibd_sakey;
 extern int show_keys;
+extern char *ibd_nd_format;
 
 /*========================================================*/
 /*                External interface                      */
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index b3fe03a..c8e3984 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
@@ -11,8 +11,8 @@ Group: System Environment/Libraries
 BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
 Source: http://www.openfabrics.org/downloads/management/@TARBALL@
 Url: http://openfabrics.org/
-BuildRequires: libibmad-devel, opensm-devel, libibumad-devel, glib2-devel
-Requires: libibmad, opensm-libs, libibumad, glib2
+BuildRequires: libibmad-devel, opensm-devel, libibumad-devel, glib2-devel, libudev-devel
+Requires: libibmad, opensm-libs, libibumad, glib2, libudev
 Provides: perl(IBswcountlimits)
 Obsoletes: openib-diags
 
@@ -129,6 +129,8 @@ rm -rf $RPM_BUILD_ROOT
 %{_mandir}/man8/ibccconfig.8.gz
 %{_sbindir}/dump_fts
 %{_mandir}/man8/dump_fts.8.gz
+%{_sbindir}/rdma-ndd
+%{_mandir}/man8/rdma-ndd.8.gz
 
 # scripts here
 %{_sbindir}/ibhosts
@@ -164,9 +166,41 @@ rm -rf $RPM_BUILD_ROOT
 %{_includedir}/infiniband/*.h
 %define _perldir %(perl -e 'use Config; $T=$Config{installvendorlib}; print $T;')
 %{_perldir}/*
-%{_sysconfdir}/*
+%{_sysconfdir}/infiniband-diags/*
+%{_sysconfdir}/init.d/rdma-ndd
 %doc README COPYING ChangeLog
 
+
+%post
+if [ $1 = 1 ]; then
+    if [ -e /sbin/chkconfig ]; then
+        /sbin/chkconfig --add rdma-ndd
+        /sbin/chkconfig rdma-ndd on
+    elif [ -e /usr/sbin/update-rc.d ]; then
+        /usr/sbin/update-rc.d rdma-ndd defaults
+    else
+        /usr/lib/lsb/install_initd /etc/init.d/rdma-ndd
+    fi
+    if type systemctl >/dev/null 2>&1; then
+        systemctl --system daemon-reload
+    fi
+else
+    /etc/init.d/rdma-ndd condrestart
+fi
+
+%preun
+if [ $1 = 0 ]; then
+    /etc/init.d/rdma-ndd stop
+    if [ -e /sbin/chkconfig ]; then
+        /sbin/chkconfig --del rdma-ndd
+    elif [ -e /usr/sbin/update-rc.d ]; then
+        /usr/sbin/update-rc.d -f rdma-ndd remove
+    else
+        /usr/lib/lsb/remove_initd /etc/init.d/rdma-ndd
+    fi
+fi
+
+
 %changelog
 * Mon Mar 03 2008 Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> - 1.3.5
 - Add check_lft_balance script.
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 8c749c7..48964f7 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -74,6 +74,7 @@ uint32_t ibd_ibnetdisc_flags = IBND_CONFIG_MLX_EPI;
 uint64_t ibd_mkey;
 uint64_t ibd_sakey = 0;
 int show_keys = 0;
+char *ibd_nd_format = NULL;
 
 static const char *prog_name;
 static const char *prog_args;
@@ -163,6 +164,9 @@ void read_ibdiag_config(const char *file)
 		} else if (strncmp(name, "sa_key",
 				   strlen("sa_key")) == 0) {
 			ibd_sakey = strtoull(val_str, 0, 0);
+		} else if (strncmp(name, "nd_format",
+				   strlen("nd_format")) == 0) {
+			ibd_nd_format = strdup(val_str);
 		}
 	}
 
diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
new file mode 100644
index 0000000..f333202
--- /dev/null
+++ b/src/rdma-ndd.c
@@ -0,0 +1,400 @@
+/*
+ * Copyright (c) 2014 Intel Corporation. All Rights Reserved
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#if HAVE_CONFIG_H
+#  include <config.h>
+#endif				/* HAVE_CONFIG_H */
+
+#include <poll.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <assert.h>
+#include <string.h>
+#include <limits.h>
+#include <stdio.h>
+#include <syslog.h>
+#include <dirent.h>
+#include <errno.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <stdlib.h>
+
+#include <libudev.h>
+
+struct udev *udev;
+struct udev_monitor *mon;
+
+#include "ibdiag_common.h"
+
+#define SYS_HOSTNAME "/proc/sys/kernel/hostname"
+#define DEF_SYS_DIR "/sys"
+char *sys_dir = DEF_SYS_DIR;
+#define SYS_INFINIBAND "class/infiniband"
+#define DEFAULT_RETRY_RATE 60
+#define DEFAULT_RETRY_COUNT 0
+#define DEFAULT_ND_FORMAT "%h %d"
+
+int failure_retry_rate = DEFAULT_RETRY_RATE;
+int set_retry_cnt = DEFAULT_RETRY_COUNT;
+int foreground = 0;
+
+static void newline_to_null(char *str)
+{
+	char *term = index(str, '\n');
+	if (term)
+		*term = '\0';
+}
+
+static void strip_domain(char *str)
+{
+	char *term = index(str, '.');
+	if (term)
+		*term = '\0';
+}
+
+static void build_node_desc(char *dest, size_t len,
+		     const char *device, const char *hostname)
+{
+	char *end = dest + len-1;
+	const char *field;
+	char *src = ibd_nd_format;
+
+	while (*src && (dest < end)) {
+		if (*src != '%') {
+			*dest++ = *src++;
+		} else {
+			src++;
+			switch (*src) {
+			case 'h':
+				field = hostname;
+				while (*field && (*field != '.') && (dest < end))
+					*dest++ = *field++;
+				break;
+			case 'd':
+				field = device;
+				while (*field && (dest < end))
+					*dest++ = *field++;
+				break;
+			}
+			src++;
+		}
+	}
+	*dest = 0;
+}
+
+static int update_node_desc(const char *device, const char *hostname, int force)
+{
+	int rc;
+	char nd[128];
+	char new_nd[64];
+	char nd_file[PATH_MAX];
+	FILE *f;
+
+	snprintf(nd_file, sizeof(nd_file), "%s/%s/%s/node_desc",
+			sys_dir, SYS_INFINIBAND, device);
+	nd_file[sizeof(nd_file)-1] = '\0';
+
+	f = fopen(nd_file, "r+");
+	if (!f) {
+		syslog(LOG_ERR, "Failed to open %s\n", nd_file);
+		return -EIO;
+	}
+
+	if (!fgets(nd, sizeof(nd), f)) {
+		syslog(LOG_ERR, "Failed to read %s\n", nd_file);
+		rc = -EIO;
+		goto error;
+	}
+	newline_to_null(nd);
+
+	build_node_desc(new_nd, sizeof(new_nd), device, hostname);
+
+	if (!force && strncmp(new_nd, nd, sizeof(new_nd)) == 0) {
+		syslog(LOG_INFO, "%s: no change (%s)\n", device, new_nd);
+	} else {
+		syslog(LOG_INFO, "%s: change (%s) -> (%s)\n",
+			device, nd, new_nd);
+		rewind(f);
+		fprintf(f, new_nd);
+	}
+
+	rc = 0;
+error:
+	fclose(f);
+	return rc;
+}
+
+static int set_rdma_node_desc(const char *hostname, int force)
+{
+	DIR *class_dir;
+	struct dirent *dent;
+	char dev_dir[PATH_MAX];
+
+	snprintf(dev_dir, sizeof(dev_dir), "%s/%s", sys_dir, SYS_INFINIBAND);
+	dev_dir[sizeof(dev_dir)-1] = '\0';
+
+	class_dir = opendir(dev_dir);
+	if (!class_dir) {
+		syslog(LOG_INFO, "Failed to open %s", dev_dir);
+		return -ENOSYS;
+	}
+
+	while ((dent = readdir(class_dir))) {
+		int retry = set_retry_cnt;
+		if (dent->d_name[0] == '.')
+			continue;
+
+		while (update_node_desc(dent->d_name, hostname, force) && retry > 0) {
+			syslog(LOG_ERR, "retrying set Node Description on %s\n",
+				dent->d_name);
+			retry--;
+		}
+	}
+
+	closedir(class_dir);
+	return 0;
+}
+
+static int read_hostname(int fd, char *name, size_t len)
+{
+	int rc;
+	memset(name, 0, len);
+	if (read(fd, name, len-1) >= 0) {
+		newline_to_null(name);
+		strip_domain(name);
+		rc = 0;
+	} else {
+		syslog(LOG_ERR, "Read %s Failed\n", SYS_HOSTNAME);
+		rc = -EIO;
+	}
+	return rc;
+}
+
+static int process_opts(void *context, int ch, char *optarg)
+{
+	unsigned long tmp;
+	switch (ch) {
+	case 'f':
+		foreground = 1;
+		break;
+	case 't':
+		tmp = strtoul(optarg, NULL, 0);
+		if (tmp >= INT_MAX) {
+			syslog(LOG_ERR,
+				"Invalid retry rate specified: %lu s\n",
+				tmp);
+		} else {
+			failure_retry_rate = (int)tmp;
+		}
+		break;
+	case 'r':
+		tmp = strtoul(optarg, NULL, 0);
+		if (tmp >= INT_MAX) {
+			syslog(LOG_ERR,
+				"Invalid retry count specified: %lu\n",
+				tmp);
+		} else {
+			set_retry_cnt = (int)tmp;
+		}
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
+#define MSG_MAX 2048
+static void udev_log_fn(struct udev *ud, int priority, const char *file, int line,
+		const char *fn, const char *format, va_list args)
+{
+	int off = 0;
+	char msg[MSG_MAX];
+	off = snprintf(msg, MSG_MAX, "libudev: %s:%d %s",
+			file, line, fn);
+	if (off < MSG_MAX-1)
+		vsnprintf(msg+off, MSG_MAX-off, format, args);
+	syslog(LOG_ERR, msg);
+}
+
+static void setup_udev(void)
+{
+	udev = udev_new();
+	if (!udev) {
+		syslog(LOG_ERR, "udev_new failed\n");
+		return;
+	}
+
+	udev_set_log_fn(udev, udev_log_fn);
+	udev_set_log_priority(udev, LOG_INFO);
+	sys_dir = (char *)udev_get_sys_path(udev);
+}
+
+static int get_udev_fd(void)
+{
+	mon = udev_monitor_new_from_netlink(udev, "udev");
+	if (!mon) {
+		syslog(LOG_ERR, "udev monitoring failed\n");
+		return -1;
+	}
+
+	udev_monitor_filter_add_match_subsystem_devtype(mon, "infiniband", NULL);
+	udev_monitor_enable_receiving(mon);
+	return udev_monitor_get_fd(mon);
+}
+
+static void process_udev_event(int ud_fd, const char *hostname)
+{
+	struct udev_device *dev;
+
+	dev = udev_monitor_receive_device(mon);
+	if (dev) {
+		const char *device = udev_device_get_sysname(dev);
+		const char *action = udev_device_get_action(dev);
+
+		syslog(LOG_INFO, "Device event: %s, %s, %s\n",
+			udev_device_get_subsystem(dev),
+			device, action);
+
+		if (device && action
+		    && strncmp(action, "add", sizeof("add")) == 0)
+			update_node_desc(device, hostname, 1);
+
+		udev_device_unref(dev);
+	}
+}
+
+static void monitor(void)
+{
+	char hostname[128];
+	int hn_fd;
+	int rc;
+	struct pollfd fds[2];
+	int numfds = 1;
+	int ud_fd;
+
+	ud_fd = get_udev_fd();
+	if (ud_fd >= 0)
+		numfds = 2;
+
+	while (1) {
+		hn_fd = open(SYS_HOSTNAME, O_RDONLY);
+		if (hn_fd < 0) {
+			syslog(LOG_ERR,
+				"Open %s Failed: retry in %d seconds\n",
+				SYS_HOSTNAME, failure_retry_rate);
+			sleep(failure_retry_rate);
+			continue;
+		}
+
+		fds[0].fd = hn_fd;
+		fds[0].events = 0;
+		fds[0].revents = 0;
+
+		fds[1].fd = ud_fd;
+		fds[1].events = POLLIN;
+		fds[1].revents = 0;
+
+		rc = poll(fds, numfds, -1);
+
+		if (rc > 0) {
+			if (read_hostname(hn_fd, hostname, sizeof(hostname)) != 0)
+				hostname[0] = '\0';
+
+			if (fds[0].revents != 0)
+				syslog(LOG_ERR, "Hostname change: %s\n", hostname);
+
+			if (fds[1].revents != 0)
+				process_udev_event(ud_fd, hostname);
+
+			rc = set_rdma_node_desc((const char *)hostname, 0);
+		} else {
+			syslog(LOG_ERR, "Poll %s Failed\n", SYS_HOSTNAME);
+			rc = -EIO;
+		}
+
+		close(hn_fd);
+
+		if (rc)
+			sleep(failure_retry_rate);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	char hostname[128];
+
+	openlog("rdma-ndd", LOG_PID | LOG_PERROR, LOG_DAEMON);
+
+	const struct ibdiag_opt opts[] = {
+		{"retry_timer", 't', 1, "<retry_timer>",
+			"Length of time to sleep when system errors occur "
+			"when attempting to poll and or read the hostname "
+			"from the system.\n"},
+		{"retry_count", 'r', 1, "<retry_count>",
+			"Number of times to attempt to retry setting "
+			"of the node description on failure\n"},
+		{"foreground", 'f', 0, NULL, "run in the foreground instead of as a daemon\n"},
+		{0}
+	};
+
+	ibdiag_process_opts(argc, argv, NULL, "CPDLGtsKyevd", opts,
+			    process_opts, "", NULL);
+
+	if (!ibd_nd_format)
+		ibd_nd_format = DEFAULT_ND_FORMAT;
+
+	setup_udev();
+
+	if (!foreground) {
+		closelog();
+		openlog("rdma-ndd", LOG_PID, LOG_DAEMON);
+		if (daemon(0, 0) != 0) {
+			syslog(LOG_ERR, "Failed to daemonize\n");
+			exit(errno);
+		}
+	}
+
+	syslog(LOG_INFO, "Node Descriptor format (%s)\n", ibd_nd_format);
+
+	fd = open(SYS_HOSTNAME, O_RDONLY);
+	if (read_hostname(fd, hostname, sizeof(hostname)) != 0)
+		hostname[0] = '\0';
+	set_rdma_node_desc((const char *)hostname, 1);
+	close(fd);
+
+	monitor();
+
+	return 0;
+}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
