From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] infiniband-diags/rdma-ndd: add --pidfile option
Date: Mon, 16 Mar 2015 18:08:23 -0400
Message-ID: <1426543703-12841-2-git-send-email-ira.weiny@intel.com>
References: <1426543703-12841-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426543703-12841-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

rdma-ndd start up script works better with a pidfile.  This was partially
implemented in the start up script and not at all in the daemon.  Fully
implement this.

Reported-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Makefile.am               |  3 +++
 doc/man/rdma-ndd.8.in     |  3 +++
 doc/rst/rdma-ndd.8.in.rst |  3 +++
 etc/rdma-ndd.init.in      |  2 +-
 src/rdma-ndd.c            | 35 +++++++++++++++++++++++++++++++++--
 5 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 63c4b48..057508b 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -162,6 +162,9 @@ install-data-hook:
 	if test ! -d $(DESTDIR)/$(sysconfdir)/infiniband-diags; then \
 		$(top_srcdir)/config/install-sh -m 755 -d $(DESTDIR)/$(sysconfdir)/infiniband-diags; \
 	fi
+	if test ! -d $(DESTDIR)/$(localstatedir)/run; then \
+		mkdir -p $(DESTDIR)/$(localstatedir)/run; \
+	fi
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/scripts/IBswcountlimits.pm $(DESTDIR)/$(PERL_INSTALLDIR)/IBswcountlimits.pm
 	$(top_srcdir)/config/install-sh -c -m 444 $(top_srcdir)/etc/error_thresholds $(DESTDIR)/$(sysconfdir)/infiniband-diags
 	$(top_srcdir)/config/install-sh -c -m 400 $(top_srcdir)/etc/ibdiag.conf $(DESTDIR)/$(sysconfdir)/infiniband-diags
diff --git a/doc/man/rdma-ndd.8.in b/doc/man/rdma-ndd.8.in
index 1a7a1bb..f0a542d 100644
--- a/doc/man/rdma-ndd.8.in
+++ b/doc/man/rdma-ndd.8.in
@@ -64,6 +64,9 @@ Number of times to attempt to retry setting of the node description on failure.
 .sp
 \fB\-\-foreground, \-f\fP
 Run in the foreground instead of as a daemon
+.sp
+\fB\-\-pidfile <pidfile>\fP
+specify a pid file (daemon mode only)
 .SS Configuration flags
 .\" Define the common option -z
 .
diff --git a/doc/rst/rdma-ndd.8.in.rst b/doc/rst/rdma-ndd.8.in.rst
index afe7470..708a5ab 100644
--- a/doc/rst/rdma-ndd.8.in.rst
+++ b/doc/rst/rdma-ndd.8.in.rst
@@ -58,6 +58,9 @@ Number of times to attempt to retry setting of the node description on failure.
 **--foreground, -f**
 Run in the foreground instead of as a daemon
 
+**--pidfile <pidfile>**
+specify a pid file (daemon mode only)
+
 
 Configuration flags
 -------------------
diff --git a/etc/rdma-ndd.init.in b/etc/rdma-ndd.init.in
index 24ce1bd..75e6d37 100644
--- a/etc/rdma-ndd.init.in
+++ b/etc/rdma-ndd.init.in
@@ -75,7 +75,7 @@ start () {
 	return 1
     fi
     echo -n "Starting RDMA Node Description Daemon: "
-    @sbindir@/rdma-ndd > /dev/null
+    @sbindir@/rdma-ndd --pidfile $pidfile > /dev/null
     RETVAL=$?
     if [[ $RETVAL -eq 0 ]]; then
         success
diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
index bbde6af..194c2cd 100644
--- a/src/rdma-ndd.c
+++ b/src/rdma-ndd.c
@@ -68,6 +68,7 @@ char *sys_dir = DEF_SYS_DIR;
 int failure_retry_rate = DEFAULT_RETRY_RATE;
 int set_retry_cnt = DEFAULT_RETRY_COUNT;
 int foreground = 0;
+char *pidfile = NULL;
 
 static void newline_to_null(char *str)
 {
@@ -205,6 +206,9 @@ static int process_opts(void *context, int ch, char *optarg)
 {
 	unsigned long tmp;
 	switch (ch) {
+	case 0:
+		pidfile = optarg;
+		break;
 	case 'f':
 		foreground = 1;
 		break;
@@ -352,6 +356,29 @@ static void monitor(void)
 	}
 }
 
+static void remove_pidfile(void)
+{
+        if (pidfile)
+		unlink(pidfile);
+}
+
+static void write_pidfile(void)
+{
+	FILE *f;
+	if (pidfile) {
+		remove_pidfile();
+		f = fopen(pidfile, "w");
+		if (f) {
+			fprintf(f, "%d\n", getpid());
+			fclose(f);
+		} else {
+			syslog(LOG_ERR, "Failed to write pidfile : %s\n",
+				pidfile);
+			exit(errno);
+		}
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int fd;
@@ -368,6 +395,7 @@ int main(int argc, char *argv[])
 			"Number of times to attempt to retry setting "
 			"of the node description on failure\n"},
 		{"foreground", 'f', 0, NULL, "run in the foreground instead of as a daemon\n"},
+		{"pidfile", 0, 1, "<pidfile>", "specify a pid file (daemon mode only)\n"},
 		{0}
 	};
 
@@ -377,8 +405,6 @@ int main(int argc, char *argv[])
 	if (!ibd_nd_format)
 		ibd_nd_format = DEFAULT_ND_FORMAT;
 
-	setup_udev();
-
 	if (!foreground) {
 		closelog();
 		openlog("rdma-ndd", LOG_PID, LOG_DAEMON);
@@ -386,8 +412,11 @@ int main(int argc, char *argv[])
 			syslog(LOG_ERR, "Failed to daemonize\n");
 			exit(errno);
 		}
+		write_pidfile();
 	}
 
+	setup_udev();
+
 	syslog(LOG_INFO, "Node Descriptor format (%s)\n", ibd_nd_format);
 
 	fd = open(SYS_HOSTNAME, O_RDONLY);
@@ -398,5 +427,7 @@ int main(int argc, char *argv[])
 
 	monitor();
 
+	remove_pidfile();
+
 	return 0;
 }
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
