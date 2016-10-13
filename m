From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/32] srp_daemon: give initialize_sysfs a proper ANSI-C prototype
Date: Thu, 13 Oct 2016 19:51:10 +0200
Message-ID: <1476381095-20041-8-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 srp_daemon/srp_daemon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/srp_daemon/srp_daemon.c b/srp_daemon/srp_daemon.c
index f0f05cf..6cb22e4 100644
--- a/srp_daemon/srp_daemon.c
+++ b/srp_daemon/srp_daemon.c
@@ -647,7 +647,7 @@ recv:
 	return -1;
 }
 
-static void initialize_sysfs()
+static void initialize_sysfs(void)
 {
 	char *env;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
