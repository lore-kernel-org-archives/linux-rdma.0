From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2] infiniband-diags: add rdma-ndd daemon
Date: Fri, 31 Oct 2014 14:27:45 -0400
Message-ID: <1414780065-15267-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rdma-ndd is a system daemon which watches the procfs hostname file for updates.

Upon detecting an update it will update the Node Descriptions of the RDMA
devices in the system.

This deamon is intended to work with kernels which support polling of the
procfs hostname file.  If your kernel does not support this feature the daemon
will set the Node Descriptions to the hostname at start up and then sleep
forever.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes in V2
	fix Valgrind errors and comments from Bart


 Makefile.am              |  10 +-
 configure.ac             |  21 ++++
 etc/rdma-ndd.init.in     | 144 ++++++++++++++++++++++++
 infiniband-diags.spec.in |  36 +++++-
 man/rdma-ndd.8.in        |  41 +++++++
 src/rdma-ndd.c           | 285 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 534 insertions(+), 3 deletions(-)
 create mode 100644 etc/rdma-ndd.init.in
 create mode 100644 man/rdma-ndd.8.in
 create mode 100644 src/rdma-ndd.c

diff --git a/Makefile.am b/Makefile.am
index f44b4d6..2ce0d00 100644
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
@@ -71,7 +72,8 @@ man_MANS = doc/man/ibaddr.8 \
 		doc/man/vendstat.8 \
 		doc/man/infiniband-diags.8 \
 		man/dump_lfts.8 \
-		man/dump_mfts.8
+		man/dump_mfts.8 \
+		man/rdma-ndd.8
 
 # define this for the dist target
 compat_man_pages = man/ibdiscover.8 man/ibcheckerrors.8 man/ibcheckerrs.8 \
@@ -158,3 +160,7 @@ install-data-hook:
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
 	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
+
+install-exec-hook:
+	$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/init.d
+	$(top_srcdir)/config/install-sh -m 755 $(top_srcdir)/etc/rdma-ndd.init $(DESTDIR)/$(sysconfdir)/init.d/rdma-ndd
diff --git a/configure.ac b/configure.ac
index af5a5f4..d0ae11e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,6 +180,25 @@ fi
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
+dnl End rdma-ndd
+
 dnl Generate doc/man/*.in files if possible
 DOC_DATE="`date +%Y-%m-%d`"
 AC_SUBST(BUILD_DATE)
@@ -253,6 +272,8 @@ AC_CONFIG_FILES([\
 	doc/man/smpquery.8 \
 	doc/man/vendstat.8 \
 	doc/man/infiniband-diags.8 \
+	man/rdma-ndd.8 \
+	etc/rdma-ndd.init \
 	libibnetdisc/Makefile \
 ])
 AC_OUTPUT
diff --git a/etc/rdma-ndd.init.in b/etc/rdma-ndd.init.in
new file mode 100644
index 0000000..64c0537
--- /dev/null
+++ b/etc/rdma-ndd.init.in
@@ -0,0 +1,144 @@
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
+prefix=@prefix@
+exec_prefix=@exec_prefix@
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
+CONFIG=@sysconfdir@/sysconfig/rdma-ndd
+if [[ -s $CONFIG ]]; then
+    . $CONFIG
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
diff --git a/infiniband-diags.spec.in b/infiniband-diags.spec.in
index b3fe03a..100b2dc 100644
--- a/infiniband-diags.spec.in
+++ b/infiniband-diags.spec.in
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
diff --git a/man/rdma-ndd.8.in b/man/rdma-ndd.8.in
new file mode 100644
index 0000000..84dc9cb
--- /dev/null
+++ b/man/rdma-ndd.8.in
@@ -0,0 +1,41 @@
+.TH RDMA-NDD 8 "@BUILD_DATE@" "" "OpenIB Diagnostics"
+.SH NAME
+RDMA-NDD \- RDMA device Node Description update daemon
+
+.SH SYNOPSIS
+
+rdma-ndd <options>
+.SH DESCRIPTION
+
+rdma-ndd is a system daemon which watches the procfs hostname file for updates.
+
+Upon detecting an update it will update the Node Descriptions of the RDMA
+devices in the system.
+
+.SH DETAILS
+
+This deamon is intended to work with kernels which support polling of the procfs hostname file.  If your kernel does not support this feature the daemon will set the Node Descriptions to the hostname at start up and then sleep forever.
+
+.SH Node Description format
+
+This deamon uses the format of "<hostname> <device>" as the Node Description format unless the format specifier "%h" is set within the Node Description.  In that case rdma-ndd will simply rewrite the Node Description which should (depending on device support) signal a trap to the SM that the Node Description has changed.
+
+.SH OPTIONS
+
+\fB\-h\fP
+Print a help message.
+
+\fB\-t <retry_timer>\fP
+Length of time to sleep when system errors occur when attempting to poll and or read the hostname from the system.
+
+\fB\-r <retry_count>\fP
+Number of times to attempt to retry setting of the node description on failure.  Default 0
+
+\fB\-f\fP
+Run in the foreground instead of as a daemon
+
+.SH AUTHOR
+
+.B Ira Weiny
+< \fI\%ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org\fP >
+
diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
new file mode 100644
index 0000000..a3a23f9
--- /dev/null
+++ b/src/rdma-ndd.c
@@ -0,0 +1,285 @@
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
+#define SYS_HOSTNAME "/proc/sys/kernel/hostname"
+#define SYS_INFINIBAND "/sys/class/infiniband"
+#define DEFAULT_RETRY_RATE 60
+#define DEFAULT_RETRY_COUNT 0
+
+int failure_retry_rate = DEFAULT_RETRY_RATE;
+int set_retry_cnt = DEFAULT_RETRY_COUNT;
+int foreground = 0;
+
+void newline_to_null(char *str)
+{
+	char *term = index(str, '\n');
+	if (term)
+		*term = '\0';
+}
+
+void strip_domain(char *str)
+{
+	char *term = index(str, '.');
+	if (term)
+		*term = '\0';
+}
+
+int update_node_desc(const char *device, const char *hostname)
+{
+	int rc;
+	int format_specifier;
+	char node_desc[128];
+	char nd_file[PATH_MAX];
+	FILE *f;
+	char *tmp;
+
+	snprintf(nd_file, sizeof(nd_file), "%s/%s/node_desc",
+			SYS_INFINIBAND, device);
+	nd_file[sizeof(nd_file)-1] = '\0';
+
+	f = fopen(nd_file, "r+");
+	if (!f) {
+		syslog(LOG_ERR, "Failed to open %s\n", nd_file);
+		return -EIO;
+	}
+
+	if (!fgets(node_desc, sizeof(node_desc), f)) {
+		syslog(LOG_ERR, "Failed to read %s\n", nd_file);
+		rc = -EIO;
+		goto error;
+	}
+
+	newline_to_null(node_desc);
+
+	format_specifier = 0;
+	for (tmp = node_desc; tmp[0] != '\0'; tmp++) {
+		if (tmp[0] == '%' && tmp[1] == 'h') {
+			format_specifier = 1;
+			break;
+		}
+	}
+
+	rewind(f);
+	if (format_specifier) {
+		syslog(LOG_INFO,
+			"%s: format specifier found; preserving node description. (%s)\n",
+			device, node_desc);
+		fprintf(f, "%s", node_desc);
+	} else {
+		syslog(LOG_INFO,
+			"%s: format specifier not found; setting node description. (%s %s)\n",
+			device, hostname, device);
+		fprintf(f, "%s %s", hostname, device);
+	}
+
+	rc = 0;
+error:
+	fclose(f);
+	return rc;
+}
+
+int set_rdma_device_names(const char *hostname)
+{
+	DIR *class_dir;
+	struct dirent *dent;
+
+	class_dir = opendir(SYS_INFINIBAND);
+	if (!class_dir) {
+		syslog(LOG_INFO, "Failed to open %s", SYS_INFINIBAND);
+		return -ENOSYS;
+	}
+
+	while ((dent = readdir(class_dir))) {
+		int retry = set_retry_cnt;
+		if (dent->d_name[0] == '.')
+			continue;
+
+		while (update_node_desc(dent->d_name, hostname) && retry > 0) {
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
+int read_and_set_hostname(int fd)
+{
+	int rc;
+	char buf[128];
+	memset(buf, 0, sizeof(buf));
+	if (read(fd, buf, 64) >= 0) {
+		newline_to_null(buf);
+		strip_domain(buf);
+		syslog(LOG_INFO, "new hostname detected: %s", buf);
+		set_rdma_device_names((const char *)buf);
+		rc = 0;
+	} else {
+		syslog(LOG_ERR, "Read %s Failed\n", SYS_HOSTNAME);
+		rc = -EIO;
+	}
+	return rc;
+}
+
+int wait_hostname_change(int fd)
+{
+	int rc;
+	struct pollfd fds;
+
+	fds.fd = fd;
+	fds.events = 0;
+	rc = poll(&fds, 1, -1);
+	if (rc > 0) {
+		rc = read_and_set_hostname(fd);
+	} else {
+		syslog(LOG_ERR, "Poll %s Failed\n", SYS_HOSTNAME);
+		rc = -EIO;
+	}
+	return rc;
+}
+
+void usage_exit(char *proc_name)
+{
+	printf("%s <options>\n", proc_name);
+	printf("   -h print this help message\n");
+	printf("   -t <retry_timer> Length of tiem to sleep when system errors occur\n"
+	       "                    when attempting to poll and or read the hostname\n"
+	       "                    from the system.\n"
+	       "                    (default %u)\n",
+		failure_retry_rate);
+	printf("   -r <retry_count> Number of times to attempt to retry setting\n"
+	       "                    of the node description on failure\n"
+	       "                    (default %u)\n",
+		set_retry_cnt);
+	printf("   -f run in the foreground instead of as a daemon\n");
+}
+
+void process_opts(int argc, char *argv[])
+{
+	unsigned long tmp;
+	int opt;
+	while ((opt = getopt(argc, argv, "ht:f")) != -1) {
+		switch (opt) {
+		case 'h':
+			usage_exit(argv[0]);
+			break;
+		case 'f':
+			foreground = 1;
+			break;
+		case 't':
+			tmp = strtoul(optarg, NULL, 0);
+			if (tmp >= INT_MAX) {
+				syslog(LOG_ERR,
+					"Invalid retry rate specified: %lu s\n",
+					tmp);
+			} else {
+				failure_retry_rate = (int)tmp;
+			}
+			break;
+		case 'r':
+			tmp = strtoul(optarg, NULL, 0);
+			if (tmp >= INT_MAX) {
+				syslog(LOG_ERR,
+					"Invalid retry count specified: %lu\n",
+					tmp);
+			} else {
+				set_retry_cnt = (int)tmp;
+			}
+			break;
+		default:
+			syslog(LOG_ERR, "Ignoring invalid option %c\n", opt);
+			break;
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	int fd;
+
+	openlog("rdma-ndd", LOG_PID | LOG_PERROR, LOG_DAEMON);
+
+	process_opts(argc, argv);
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
+	syslog(LOG_INFO, "starting up...  retry_timer %u", failure_retry_rate);
+
+	fd = open(SYS_HOSTNAME, O_RDONLY);
+	read_and_set_hostname(fd);
+	close(fd);
+
+	while (1) {
+		fd = open(SYS_HOSTNAME, O_RDONLY);
+		if (fd < 0) {
+			syslog(LOG_ERR,
+				"Open %s Failed: retry in %d seconds\n",
+				SYS_HOSTNAME, failure_retry_rate);
+			sleep(failure_retry_rate);
+			continue;
+		}
+
+		if (wait_hostname_change(fd))
+			sleep(failure_retry_rate);
+
+		close(fd);
+	}
+}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
