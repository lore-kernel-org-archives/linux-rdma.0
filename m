From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/11] IB/mlx5: Enable QP creation with cvlan offload
Date: Wed, 18 Jan 2017 15:40:03 +0200
Message-ID: <20170118134004.5380-11-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable creating a RAW Ethernet QP with cvlan stripping offload when
it's supported by the hardware.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 ++++++
 drivers/infiniband/hw/mlx5/qp.c      | 13 ++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e1a4b93d..42007eb 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -220,6 +220,10 @@ struct wr_list {
 	u16	next;
 };
 
+enum mlx5_ib_rq_flags {
+	MLX5_IB_RQ_CVLAN_STRIPPING	= 1 << 0,
+};
+
 struct mlx5_ib_wq {
 	u64		       *wrid;
 	u32		       *wr_data;
@@ -308,6 +312,7 @@ struct mlx5_ib_rq {
 	struct mlx5_db		*doorbell;
 	u32			tirn;
 	u8			state;
+	u32			flags;
 };
 
 struct mlx5_ib_sq {
@@ -392,6 +397,7 @@ enum mlx5_ib_qp_flags {
 	MLX5_IB_QP_SQPN_QP1			= 1 << 6,
 	MLX5_IB_QP_CAP_SCATTER_FCS		= 1 << 7,
 	MLX5_IB_QP_RSS				= 1 << 8,
+	MLX5_IB_QP_CVLAN_STRIPPING		= 1 << 9,
 };
 
 struct mlx5_umr_wr {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 74c242f..e333bda 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1141,7 +1141,8 @@ static int create_raw_packet_qp_rq(struct mlx5_ib_dev *dev,
 		return -ENOMEM;
 
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
-	MLX5_SET(rqc, rqc, vsd, 1);
+	if (!(rq->flags & MLX5_IB_RQ_CVLAN_STRIPPING))
+		MLX5_SET(rqc, rqc, vsd, 1);
 	MLX5_SET(rqc, rqc, mem_rq_type, MLX5_RQC_MEM_RQ_TYPE_MEMORY_RQ_INLINE);
 	MLX5_SET(rqc, rqc, state, MLX5_RQC_STATE_RST);
 	MLX5_SET(rqc, rqc, flush_in_error_en, 1);
@@ -1238,6 +1239,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
 
+		if (qp->flags & MLX5_IB_QP_CVLAN_STRIPPING)
+			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
 		err = create_raw_packet_qp_rq(dev, rq, in);
 		if (err)
 			goto err_destroy_sq;
@@ -1559,6 +1562,14 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
 
+	if (init_attr->create_flags & IB_QP_CREATE_CVLAN_STRIPPING) {
+		if (!(MLX5_CAP_GEN(dev->mdev, eth_net_offloads) &&
+		      MLX5_CAP_ETH(dev->mdev, vlan_cap)) ||
+		    (init_attr->qp_type != IB_QPT_RAW_PACKET))
+			return -EOPNOTSUPP;
+		qp->flags |= MLX5_IB_QP_CVLAN_STRIPPING;
+	}
+
 	if (pd && pd->uobject) {
 		if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd))) {
 			mlx5_ib_dbg(dev, "copy failed\n");
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
