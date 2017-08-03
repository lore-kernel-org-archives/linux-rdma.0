From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/4] rdma-ndd: Use sd_notify to synchronize bootup
Date: Thu,  3 Aug 2017 16:04:04 -0600
Message-ID: <1501797846-8228-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1501797846-8228-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501797846-8228-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tell systemd that rdma-ndd is ready once it has scanned and set the
hostname of all currently present devices.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 rdma-ndd/CMakeLists.txt      |  5 ++++-
 rdma-ndd/rdma-ndd.8.in       |  3 +++
 rdma-ndd/rdma-ndd.8.in.rst   |  3 +++
 rdma-ndd/rdma-ndd.c          | 15 ++++++++++++---
 rdma-ndd/rdma-ndd.service.in |  3 ++-
 5 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/rdma-ndd/CMakeLists.txt b/rdma-ndd/CMakeLists.txt
index 99e183e34ef758..e8419a6c93116f 100644
--- a/rdma-ndd/CMakeLists.txt
+++ b/rdma-ndd/CMakeLists.txt
@@ -7,7 +7,10 @@ rdma_sbin_executable(rdma-ndd
   rdma-ndd.c
   )
 
-target_link_libraries(rdma-ndd LINK_PRIVATE ${UDEV_LIBRARIES})
+target_link_libraries(rdma-ndd LINK_PRIVATE
+  ${SYSTEMD_LIBRARIES}
+  ${UDEV_LIBRARIES}
+  )
 
 # FIXME Autogenerate from the .rst
 rdma_man_pages(
diff --git a/rdma-ndd/rdma-ndd.8.in b/rdma-ndd/rdma-ndd.8.in
index c0668d7f3eb62e..d6c75d3255d379 100644
--- a/rdma-ndd/rdma-ndd.8.in
+++ b/rdma-ndd/rdma-ndd.8.in
@@ -78,6 +78,9 @@ Run in the foreground instead of as a daemon
 .sp
 \fB\-d, \-\-debugging\fP
 Log additional debugging information to syslog
+.sp
+\fB\-\-systemd\fP
+Enable systemd integration.
 .SH AUTHOR
 .INDENT 0.0
 .TP
diff --git a/rdma-ndd/rdma-ndd.8.in.rst b/rdma-ndd/rdma-ndd.8.in.rst
index 12ba91b605501f..767f388e9ab925 100644
--- a/rdma-ndd/rdma-ndd.8.in.rst
+++ b/rdma-ndd/rdma-ndd.8.in.rst
@@ -74,6 +74,9 @@ Run in the foreground instead of as a daemon
 **-d, --debugging**
 Log additional debugging information to syslog
 
+**--systemd**
+Enable systemd integration.
+
 
 AUTHOR
 ======
diff --git a/rdma-ndd/rdma-ndd.c b/rdma-ndd/rdma-ndd.c
index 180cbb34a8e29b..418d1de9456b7d 100644
--- a/rdma-ndd/rdma-ndd.c
+++ b/rdma-ndd/rdma-ndd.c
@@ -49,6 +49,7 @@
 #include <stdlib.h>
 #include <stdbool.h>
 
+#include <systemd/sd-daemon.h>
 #include <libudev.h>
 
 static struct udev *g_udev;
@@ -237,7 +238,7 @@ static void process_udev_event(int ud_fd, const char *hostname)
 	}
 }
 
-static void monitor(void)
+static void monitor(bool systemd)
 {
 	char hostname[128];
 	int hn_fd;
@@ -265,6 +266,9 @@ static void monitor(void)
 	fds[1].fd = ud_fd;
 	fds[1].events = POLLIN;
 
+	if (systemd)
+		sd_notify(0, "READY=1");
+
 	while (1) {
 		if (poll(fds, numfds, -1) <= 0) {
 			syslog(LOG_ERR, "Poll %s failed; exiting\n", SYS_HOSTNAME);
@@ -285,12 +289,14 @@ static void monitor(void)
 int main(int argc, char *argv[])
 {
 	bool foreground = false;
+	bool systemd = false;
 
 	openlog(NULL, LOG_NDELAY | LOG_CONS | LOG_PID, LOG_DAEMON);
 
 	while (1) {
 		static const struct option long_opts[] = {
 			{ "foreground",   0, NULL, 'f' },
+			{ "systemd",      0, NULL, 's' },
 			{ "help",         0, NULL, 'h' },
 			{ "debug",        0, NULL, 'd' },
 			{ }
@@ -304,6 +310,9 @@ int main(int argc, char *argv[])
 		case 'f':
 			foreground = true;
 			break;
+		case 's':
+			systemd = true;
+			break;
 		case 'd':
 			debugging = true;
 			break;
@@ -317,7 +326,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
-	if (!foreground) {
+	if (!foreground && !systemd) {
 		if (daemon(0, 0) != 0) {
 			syslog(LOG_ERR, "Failed to daemonize\n");
 			return EXIT_FAILURE;
@@ -334,7 +343,7 @@ int main(int argc, char *argv[])
 
 	dbg_log("Node Descriptor format (%s)\n", g_nd_format);
 
-	monitor();
+	monitor(systemd);
 
 	return 0;
 }
diff --git a/rdma-ndd/rdma-ndd.service.in b/rdma-ndd/rdma-ndd.service.in
index ba6868cc13801a..56c5959505010f 100644
--- a/rdma-ndd/rdma-ndd.service.in
+++ b/rdma-ndd/rdma-ndd.service.in
@@ -3,6 +3,7 @@ Description=RDMA Node Description Daemon
 Documentation=man:rdma-ndd
 
 [Service]
+Type=notify
 Restart=always
-ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/rdma-ndd -f
+ExecStart=@CMAKE_INSTALL_FULL_SBINDIR@/rdma-ndd --systemd
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
