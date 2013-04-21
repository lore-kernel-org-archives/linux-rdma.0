From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] net/mlx4_core: Deprecate warning message for SRQ_LIMIT event to debug level
Date: Sun, 21 Apr 2013 18:09:59 +0300
Message-ID: <1366557001-29408-2-git-send-email-ogerlitz@mellanox.com>
References: <1366557001-29408-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1366557001-29408-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Commit acba2420 "mlx4_core: Add wrapper functions and comm channel and slave
event support to EQs" introduced a warning printout for SRQ LIMIT events.

This warning can flood the log when apps use SRQ LIMIT events as a trigger to
post WQEs to SRQs. The warning message must be deprecated to be a debug printout.

Reported-by: Rick Warner <rick-RG+SVkAMv1FWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/eq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index 8e3123a..6000342 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -497,8 +497,8 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			break;
 
 		case MLX4_EVENT_TYPE_SRQ_LIMIT:
-			mlx4_warn(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT\n",
-				  __func__);
+			mlx4_dbg(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT\n",
+				 __func__);
 		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
 			if (mlx4_is_master(dev)) {
 				/* forward only to slave owning the SRQ */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
