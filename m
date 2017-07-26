From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 7/8] iwpmd: Add --systemd option
Date: Wed, 26 Jul 2017 13:59:11 -0600
Message-ID: <1501099152-6344-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501099152-6344-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501099152-6344-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This avoids daemonizing the server and forking as systemd does
all of that for us. The notable benefit is to allow stderr to
be routed to the journal in case there is any sort of internal
fault (eg a glibc memory failure)

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 iwpmd/iwarp_pm_server.c                   | 29 ++++++++++++++++++++++++++---
 iwpmd/iwpmd.8.in                          |  4 ++++
 iwpmd/{iwpmd.service => iwpmd.service.in} |  3 +--
 3 files changed, 31 insertions(+), 5 deletions(-)
 rename iwpmd/{iwpmd.service => iwpmd.service.in} (75%)

diff --git a/iwpmd/iwarp_pm_server.c b/iwpmd/iwarp_pm_server.c
index ec5721020e224c..928b8631fe89d3 100644
--- a/iwpmd/iwarp_pm_server.c
+++ b/iwpmd/iwarp_pm_server.c
@@ -32,6 +32,7 @@
  */
 
 #include "config.h"
+#include <getopt.h>
 #include "iwarp_pm.h"
 
 static const char iwpm_ulib_name [] = "iWarpPortMapperUser";
@@ -1355,14 +1356,13 @@ iwarp_port_mapper_exit:
 
 /**
  * daemonize_iwpm_server - Make iwarp port mapper a daemon process
- */ 
+ */
 static void daemonize_iwpm_server(void)
 {
 	if (daemon(0, 0) != 0) {
 		syslog(LOG_ERR, "Failed to daemonize\n");
 		exit(EXIT_FAILURE);
 	}
-	umask(0); /* change file mode mask */
 
 	syslog(LOG_WARNING, "daemonize_iwpm_server: Starting iWarp Port Mapper V%d process\n",
 				iwpm_version);
@@ -1374,10 +1374,33 @@ int main(int argc, char *argv[])
 	int known_clients;
 	FILE *fp;
 	int ret = EXIT_FAILURE;
+	bool systemd = false;
+
+	while (1) {
+		static const struct option long_opts[] = {
+			{"systemd", 0, NULL, 's'},
+			{}
+		};
+
+		int c = getopt_long(argc, argv, "fs", long_opts, NULL);
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 's':
+			systemd = true;
+			break;
+		default:
+			break;
+
+		}
+	}
 
 	openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
 
-	daemonize_iwpm_server();
+	if (!systemd)
+		daemonize_iwpm_server();
+	umask(0); /* change file mode mask */
 
 	fp = fopen(IWPM_CONFIG_FILE, "r");
 	if (fp) {
diff --git a/iwpmd/iwpmd.8.in b/iwpmd/iwpmd.8.in
index c42f2dd3de2b8a..76efaa46e8a014 100644
--- a/iwpmd/iwpmd.8.in
+++ b/iwpmd/iwpmd.8.in
@@ -45,6 +45,10 @@ which then releases the TCP port.
 The message exchange between iwpmd and the iWARP Connection Manager
 (between user space and kernel space) is implemented using netlink
 sockets.
+.SH OPTIONS
+.sp
+\fB\-s, \-\-systemd\fP
+Enable systemd integration.
 .SH "SIGNALS"
 SIGUSR1 will force a dump of the current mappings
 to the system message log.
diff --git a/iwpmd/iwpmd.service b/iwpmd/iwpmd.service.in
similarity index 75%
rename from iwpmd/iwpmd.service
rename to iwpmd/iwpmd.service.in
index 6d093fb2fda5a7..25740ebdcf9a82 100644
--- a/iwpmd/iwpmd.service
+++ b/iwpmd/iwpmd.service.in
@@ -4,9 +4,8 @@ Documentation=man:iwpmd file:/etc/iwpmd.conf
 After=network.target
 
 [Service]
-ExecStart=/usr/bin/iwpmd
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/iwpmd --systemd
 LimitNOFILE=102400
-KillMode=process
 
 [Install]
 WantedBy=multi-user.target
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
