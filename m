From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 09/10] IB/mlx5: Fix pkey_index length in the QP path record
Date: Sat,  4 Jun 2016 15:15:36 +0300
Message-ID: <1465042537-26129-10-git-send-email-leon@kernel.org>
References: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042537-26129-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Pkey index fields in the QP context path record are extended to 16
bits, as required by IB spec (version 1.3).
This change affects all QP commands which include path records.

To enable this change, moved the free adaptive routing flag bit
(free_ar) to the most significant byte of the QP path record.

Fixes: e126ba97dba9e ('mlx5: Add driver for Mellanox Connect-IB ...')
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 15 ++++++++-------
 include/linux/mlx5/qp.h         |  5 ++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 43c1441..6b90bfd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1859,7 +1859,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	int err;
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
-		path->pkey_index = attr->pkey_index;
+		path->pkey_index = cpu_to_be16(attr->pkey_index);
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >=
@@ -1879,9 +1879,9 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 							  ah->grh.sgid_index);
 		path->dci_cfi_prio_sl = (ah->sl & 0x7) << 4;
 	} else {
-		path->fl = (path_flags & MLX5_PATH_FLAG_FL) ? 0x80 : 0;
-		path->free_ar = (path_flags & MLX5_PATH_FLAG_FREE_AR) ? 0x80 :
-									0;
+		path->fl_free_ar = (path_flags & MLX5_PATH_FLAG_FL) ? 0x80 : 0;
+		path->fl_free_ar |=
+			(path_flags & MLX5_PATH_FLAG_FREE_AR) ? 0x40 : 0;
 		path->rlid = cpu_to_be16(ah->dlid);
 		path->grh_mlid = ah->src_path_bits & 0x7f;
 		if (ah->ah_flags & IB_AH_GRH)
@@ -2266,7 +2266,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 		context->log_pg_sz_remote_qpn = cpu_to_be32(attr->dest_qp_num);
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
-		context->pri_path.pkey_index = attr->pkey_index;
+		context->pri_path.pkey_index = cpu_to_be16(attr->pkey_index);
 
 	/* todo implement counter_index functionality */
 
@@ -4015,11 +4015,12 @@ static int query_qp_attr(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
 		to_ib_ah_attr(dev, &qp_attr->ah_attr, &context->pri_path);
 		to_ib_ah_attr(dev, &qp_attr->alt_ah_attr, &context->alt_path);
-		qp_attr->alt_pkey_index = context->alt_path.pkey_index & 0x7f;
+		qp_attr->alt_pkey_index =
+			be16_to_cpu(context->alt_path.pkey_index);
 		qp_attr->alt_port_num	= qp_attr->alt_ah_attr.port_num;
 	}
 
-	qp_attr->pkey_index = context->pri_path.pkey_index & 0x7f;
+	qp_attr->pkey_index = be16_to_cpu(context->pri_path.pkey_index);
 	qp_attr->port_num = context->pri_path.port;
 
 	/* qp_attr->en_sqd_async_notify is only applicable in modify qp */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 6422102..e4e2988 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -460,10 +460,9 @@ struct mlx5_core_qp {
 };
 
 struct mlx5_qp_path {
-	u8			fl;
+	u8			fl_free_ar;
 	u8			rsvd3;
-	u8			free_ar;
-	u8			pkey_index;
+	__be16			pkey_index;
 	u8			rsvd0;
 	u8			grh_mlid;
 	__be16			rlid;
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
