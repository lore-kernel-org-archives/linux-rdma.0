From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/8] srp_daemon: Add a --systemd option
Date: Wed, 26 Jul 2017 13:59:07 -0600
Message-ID: <1501099152-6344-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This changes how logging is setup to send log messages only to syslog,
instead of to stderr and to syslog. If messages are sent to both
places then systemd will create duplicate log entries.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 srp_daemon/srp_daemon.1.in             |  3 +++
 srp_daemon/srp_daemon.c                | 38 ++++++++++++++++++++++++++++++++--
 srp_daemon/srp_daemon_port@.service.in |  2 +-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/srp_daemon/srp_daemon.1.in b/srp_daemon/srp_daemon.1.in
index 82dc3241ea5e36..0534cf4301a916 100644
--- a/srp_daemon/srp_daemon.1.in
+++ b/srp_daemon/srp_daemon.1.in
@@ -91,6 +91,9 @@ Perform \fIretries\fR retries on each send to MAD (default: 3 retries).
 .TP
 \fB\-n\fR
 New format - use also initiator_ext in the connection command.
+.TP
+\fB\--systemd\fR
+Enable systemd integration.
 
 .SH FILES
 @CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf -
diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index 836e2e5d1487b5..4fc029e9d0c875 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -42,6 +42,7 @@
 #include <assert.h>
 #include <stdarg.h>
 #include <stddef.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -234,6 +235,7 @@ static void usage(const char *argv0)
 	fprintf(stderr, "-t <timeout>		Timeout for mad response in milliseconds\n");
 	fprintf(stderr, "-r <retries>		number of send Retries for each mad\n");
 	fprintf(stderr, "-n 			New connection command format - use also initiator extension\n");
+	fprintf(stderr, "--systemd		Enable systemd integration.\n");
 	fprintf(stderr, "\nExample: srp_daemon -e -n -i mthca0 -p 1 -R 60\n");
 }
 
@@ -1595,6 +1597,29 @@ out:
 	return ret;
 }
 
+static const struct option long_opts[] = {
+	{ "systemd",        0, NULL, 'S' },
+	{}
+};
+static const char short_opts[] = "caveod:i:j:p:t:r:R:T:l:Vhnf:";
+
+/* Check if the --systemd options was passed in very early so we can setup
+ * logging properly.
+ */
+static bool is_systemd(int argc, char *argv[])
+{
+	while (1) {
+		int c;
+
+		c = getopt_long(argc, argv, short_opts, long_opts, NULL);
+		if (c == -1)
+			break;
+		if (c == 'S')
+			return true;
+
+	}
+	return false;
+}
 
 static int get_config(struct config_t *conf, int argc, char *argv[])
 {
@@ -1621,10 +1646,11 @@ static int get_config(struct config_t *conf, int argc, char *argv[])
 	conf->rules			= NULL;
 	conf->tl_retry_count		= 0;
 
+	optind = 1;
 	while (1) {
 		int c;
 
-		c = getopt(argc, argv, "caveod:i:j:p:t:r:R:T:l:Vhnf:");
+		c = getopt_long(argc, argv, short_opts, long_opts, NULL);
 		if (c == -1)
 			break;
 
@@ -1721,6 +1747,8 @@ static int get_config(struct config_t *conf, int argc, char *argv[])
 				return -1;
 			}
 			break;
+		case 'S':
+			break;
 		case 'h':
 		default:
 			usage(argv[0]);
@@ -2093,6 +2121,7 @@ int main(int argc, char *argv[])
 	int			subscribed;
 	int			lockfd = -1;
 	int			received_signal = 0;
+	bool                    systemd;
 
 #ifndef __CHECKER__
 	/*
@@ -2116,7 +2145,12 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	openlog("srp_daemon", LOG_PID | LOG_PERROR, LOG_DAEMON);
+	systemd = is_systemd(argc, argv);
+
+	if (systemd)
+		openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
+	else
+		openlog("srp_daemon", LOG_PID, LOG_DAEMON);
 
 	config = calloc(1, sizeof(*config));
 	if (!config) {
diff --git a/srp_daemon/srp_daemon_port@.service.in b/srp_daemon/srp_daemon_port@.service.in
index 0ec966f912aec8..acec1a228fec89 100644
--- a/srp_daemon/srp_daemon_port@.service.in
+++ b/srp_daemon/srp_daemon_port@.service.in
@@ -9,7 +9,7 @@ Before=remote-fs-pre.target
 
 [Service]
 Type=simple
-ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/srp_daemon -e -c -n -j %I -R 60
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/srp_daemon --systemd -e -c -n -j %I -R 60
 MemoryDenyWriteExecute=yes
 PrivateNetwork=yes
 PrivateTmp=yes
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
