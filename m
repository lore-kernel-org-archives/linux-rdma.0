From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 08/13] srp_daemon: Move lock file into /var/run/
Date: Fri, 23 Sep 2016 13:17:03 -0600
Message-ID: <1474658228-5390-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474658228-5390-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

'/var/tmp' is an inappropriate places for lock files of this nature,
they belong in /var/run. /var/lock does not seem suitable because
this lock is not against a basic device node.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/config.h.in               | 1 +
 srp_daemon/srp_daemon/srp_daemon.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index bbc279d3c9c3..78994a39d7ad 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -22,6 +22,7 @@
 #define IWPM_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/iwpmd.conf"
 
 #define SRP_DEAMON_CONFIG_FILE "@CMAKE_INSTALL_FULL_SYSCONFDIR@/srp_daemon.conf"
+#define SRP_DEAMON_LOCK_PREFIX "@CMAKE_INSTALL_FULL_RUNDIR@/srp_daemon"
 
 #define ACM_CONF_DIR "@CMAKE_INSTALL_FULL_SYSCONFDIR@/rdma"
 #define IBACM_LIB_PATH "@ACM_PROVIDER_DIR@"
diff --git a/srp_daemon/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon/srp_daemon.c
index 70764e00f851..f16674dbfafa 100644
--- a/srp_daemon/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon/srp_daemon.c
@@ -131,7 +131,7 @@ static int check_process_uniqueness(struct config_t *conf)
 	char path[256];
 	int fd;
 
-	snprintf(path, sizeof(path), "/var/tmp/srp_daemon_%s_%d",
+	snprintf(path, sizeof(path), SRP_DEAMON_LOCK_PREFIX "_%s_%d",
 		 conf->dev_name, conf->port_num);
 
 	if ((fd = open(path, O_CREAT|O_RDWR,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
