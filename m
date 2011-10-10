From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 3/5] net/mlx4_core: remove module param controlling the vlan
 table size
Date: Mon, 10 Oct 2011 10:55:36 +0200
Message-ID: <alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101047420.10901-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enable the maximum size (128) supported by the device for the shadow
vlans table, without a module param to override it. This table is only
used by the IBoE control plane for setting a vlan index into an RC/UC
QP context or UD Address Handle.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/mlx4/main.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index f0ee35d..0285c8a 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -93,9 +93,8 @@ static int log_num_mac = 2;
 module_param_named(log_num_mac, log_num_mac, int, 0444);
 MODULE_PARM_DESC(log_num_mac, "Log2 max number of MACs per ETH port (1-7)");

-static int log_num_vlan;
-module_param_named(log_num_vlan, log_num_vlan, int, 0444);
-MODULE_PARM_DESC(log_num_vlan, "Log2 max number of VLANs per ETH port (0-7)");
+/* Log2 max number of VLANs per ETH port (0-7) */
+#define MLX4_LOG_NUM_VLANS 7

 static int use_prio;
 module_param_named(use_prio, use_prio, bool, 0444);
@@ -230,7 +229,7 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.max_gso_sz	     = dev_cap->max_gso_sz;

 	dev->caps.log_num_macs  = log_num_mac;
-	dev->caps.log_num_vlans = log_num_vlan;
+	dev->caps.log_num_vlans = MLX4_LOG_NUM_VLANS;
 	dev->caps.log_num_prios = use_prio ? 3 : 0;

 	for (i = 1; i <= dev->caps.num_ports; ++i) {
@@ -1489,11 +1488,6 @@ static int __init mlx4_verify_params(void)
 		return -1;
 	}

-	if ((log_num_vlan < 0) || (log_num_vlan > 7)) {
-		pr_warning("mlx4_core: bad num_vlan: %d\n", log_num_vlan);
-		return -1;
-	}
-
 	if ((log_mtts_per_seg < 1) || (log_mtts_per_seg > 7)) {
 		pr_warning("mlx4_core: bad log_mtts_per_seg: %d\n", log_mtts_per_seg);
 		return -1;
-- 
1.7.4.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
