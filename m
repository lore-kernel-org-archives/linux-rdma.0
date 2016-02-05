From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc 4/4] RDMA/ocrdma: Fixing ocrdma debugfs directory remove
Date: Fri,  5 Feb 2016 20:06:40 +0530
Message-ID: <1454683001-21275-5-git-send-email-selvin.xavier@broadcom.com>
References: <1454683001-21275-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454683001-21275-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

During the ocrdma device remove sequence, the debugfs directory
tree of each ocrdma device needs to be removed. Use
debugfs_remove_recursive instead of debugfs_remove.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index fc02e86..255f774 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -851,7 +851,7 @@ void ocrdma_rem_port_stats(struct ocrdma_dev *dev)
 {
 	if (!dev->dir)
 		return;
-	debugfs_remove(dev->dir);
+	debugfs_remove_recursive(dev->dir);
 }
 
 void ocrdma_init_debugfs(void)
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
