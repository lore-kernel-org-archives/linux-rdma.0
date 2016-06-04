From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 10/10] IB/mlx5: Fix alternate path code
Date: Sat,  4 Jun 2016 15:15:37 +0300
Message-ID: <1465042537-26129-11-git-send-email-leon@kernel.org>
References: <1465042537-26129-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465042537-26129-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Userspace flag IBV_QP_ALT_PATH is supposed to set the alternate path
including fields alt_pkey_index and alt_timeout.
Added IB_QP_PKEY_INDEX and IB_QP_TIMEOUT to the attribute mask when
calling mlx5_set_path for the alternate path to force setting the
alt_pkey_index and alt_timeout values.

Fixes: bf24481a3a7c4 ('IB/mlx5: Consider alternate path in pkey ...')
Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 6b90bfd..ce43422 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1853,13 +1853,15 @@ static int modify_raw_packet_eth_prio(struct mlx5_core_dev *dev,
 static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			 const struct ib_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
-			 u32 path_flags, const struct ib_qp_attr *attr)
+			 u32 path_flags, const struct ib_qp_attr *attr,
+			 bool alt)
 {
 	enum rdma_link_layer ll = rdma_port_get_link_layer(&dev->ib_dev, port);
 	int err;
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
-		path->pkey_index = cpu_to_be16(attr->pkey_index);
+		path->pkey_index = cpu_to_be16(alt ? attr->alt_pkey_index :
+						     attr->pkey_index);
 
 	if (ah->ah_flags & IB_AH_GRH) {
 		if (ah->grh.sgid_index >=
@@ -1905,7 +1907,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	path->port = port;
 
 	if (attr_mask & IB_QP_TIMEOUT)
-		path->ackto_lt = attr->timeout << 3;
+		path->ackto_lt = (alt ? attr->alt_timeout : attr->timeout) << 3;
 
 	if ((qp->ibqp.qp_type == IB_QPT_RAW_PACKET) && qp->sq.wqe_cnt)
 		return modify_raw_packet_eth_prio(dev->mdev,
@@ -2279,7 +2281,7 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_AV) {
 		err = mlx5_set_path(dev, qp, &attr->ah_attr, &context->pri_path,
 				    attr_mask & IB_QP_PORT ? attr->port_num : qp->port,
-				    attr_mask, 0, attr);
+				    attr_mask, 0, attr, false);
 		if (err)
 			goto out;
 	}
@@ -2290,7 +2292,9 @@ static int __mlx5_ib_modify_qp(struct ib_qp *ibqp,
 	if (attr_mask & IB_QP_ALT_PATH) {
 		err = mlx5_set_path(dev, qp, &attr->alt_ah_attr,
 				    &context->alt_path,
-				    attr->alt_port_num, attr_mask, 0, attr);
+				    attr->alt_port_num,
+				    attr_mask | IB_QP_PKEY_INDEX | IB_QP_TIMEOUT,
+				    0, attr, true);
 		if (err)
 			goto out;
 	}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
