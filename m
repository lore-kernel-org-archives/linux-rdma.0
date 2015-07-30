From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/4] IB/mlx4: Deprecate mcast group warning message to debug because of flooding
Date: Thu, 30 Jul 2015 17:34:22 +0300
Message-ID: <1438266864-3584-3-git-send-email-ogerlitz@mellanox.com>
References: <1438266864-3584-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438266864-3584-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The mcg "too many pending requests" warning message fills the log
when OpenSM is downed. Deprecate the warning to be debug output.


Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index a0559a8..2d5bccd 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -51,6 +51,10 @@
 	pr_warn("%s-%d: %16s (port %d): WARNING: " format, __func__, __LINE__,\
 	(group)->name, group->demux->port, ## arg)
 
+#define mcg_debug_group(group, format, arg...) \
+	pr_debug("%s-%d: %16s (port %d): WARNING: " format, __func__, __LINE__,\
+		 (group)->name, (group)->demux->port, ## arg)
+
 #define mcg_error_group(group, format, arg...) \
 	pr_err("  %16s: " format, (group)->name, ## arg)
 
@@ -962,8 +966,8 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
 		mutex_lock(&group->lock);
 		if (group->func[slave].num_pend_reqs > MAX_PEND_REQS_PER_FUNC) {
 			mutex_unlock(&group->lock);
-			mcg_warn_group(group, "Port %d, Func %d has too many pending requests (%d), dropping\n",
-				       port, slave, MAX_PEND_REQS_PER_FUNC);
+			mcg_debug_group(group, "Port %d, Func %d has too many pending requests (%d), dropping\n",
+					port, slave, MAX_PEND_REQS_PER_FUNC);
 			release_group(group, 0);
 			kfree(req);
 			return -ENOMEM;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
