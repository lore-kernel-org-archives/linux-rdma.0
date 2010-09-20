From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] mlx4: Extend log_mtts_per_seg range
Date: Mon, 20 Sep 2010 08:42:38 +0200
Message-ID: <20100920064238.GA9223@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

As there are now machines with more physical memory, we need to be able to
register more memory. This patch lifts the upper limit of log_mtts_per_seg from
5 to 7, increasing the amount of memory that can be registered.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/net/mlx4/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 5102ab1..4f6a859 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -103,7 +103,7 @@ MODULE_PARM_DESC(use_prio, "Enable steering by VLAN priority on ETH ports "
 
 static int log_mtts_per_seg = ilog2(MLX4_MTT_ENTRY_PER_SEG);
 module_param_named(log_mtts_per_seg, log_mtts_per_seg, int, 0444);
-MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-5)");
+MODULE_PARM_DESC(log_mtts_per_seg, "Log2 number of MTT entries per segment (1-7)");
 
 int mlx4_check_port_params(struct mlx4_dev *dev,
 			   enum mlx4_port_type *port_type)
@@ -1304,7 +1304,7 @@ static int __init mlx4_verify_params(void)
 		return -1;
 	}
 
-	if ((log_mtts_per_seg < 1) || (log_mtts_per_seg > 5)) {
+	if ((log_mtts_per_seg < 1) || (log_mtts_per_seg > 7)) {
 		pr_warning("mlx4_core: bad log_mtts_per_seg: %d\n", log_mtts_per_seg);
 		return -1;
 	}
-- 
1.7.2.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
