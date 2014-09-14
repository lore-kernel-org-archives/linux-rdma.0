From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/mlx5: Remove duplicate code from mlx5_set_path
Date: Sun, 14 Sep 2014 16:47:54 +0300
Message-ID: <1410702475-28826-6-git-send-email-eli@mellanox.com>
References: <1410702475-28826-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410702475-28826-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some of the fields where set twice. Re-organize to avoid that.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8c574b63d77b..34b92fc345b7 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1302,6 +1302,11 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 	path->rlid	= cpu_to_be16(ah->dlid);
 
 	if (ah->ah_flags & IB_AH_GRH) {
+		if (ah->grh.sgid_index >= dev->mdev->caps.port[port - 1].gid_table_len) {
+			pr_err(KERN_ERR "sgid_index (%u) too large. max is %d\n",
+			       ah->grh.sgid_index, dev->mdev->caps.port[port - 1].gid_table_len);
+			return -EINVAL;
+		}
 		path->grh_mlid |= 1 << 7;
 		path->mgid_index = ah->grh.sgid_index;
 		path->hop_limit  = ah->grh.hop_limit;
@@ -1317,22 +1322,6 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, const struct ib_ah_attr *ah,
 	path->static_rate = err;
 	path->port = port;
 
-	if (ah->ah_flags & IB_AH_GRH) {
-		if (ah->grh.sgid_index >= dev->mdev->caps.port[port - 1].gid_table_len) {
-			pr_err(KERN_ERR "sgid_index (%u) too large. max is %d\n",
-			       ah->grh.sgid_index, dev->mdev->caps.port[port - 1].gid_table_len);
-			return -EINVAL;
-		}
-
-		path->grh_mlid |= 1 << 7;
-		path->mgid_index = ah->grh.sgid_index;
-		path->hop_limit  = ah->grh.hop_limit;
-		path->tclass_flowlabel =
-			cpu_to_be32((ah->grh.traffic_class << 20) |
-				    (ah->grh.flow_label));
-		memcpy(path->rgid, ah->grh.dgid.raw, 16);
-	}
-
 	if (attr_mask & IB_QP_TIMEOUT)
 		path->ackto_lt = attr->timeout << 3;
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
