From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 for-next 3/6] IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing
Date: Wed, 19 Jun 2013 10:47:08 +0300
Message-ID: <1371628031-17546-4-git-send-email-ogerlitz@mellanox.com>
References: <1371628031-17546-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1371628031-17546-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>

IP based RoCE gids don't store Ethernet L2 parameters, MAC and VLAN.

Hence, we need to extract them now from the CQE and place in struct
ib_wc (to be used for cases were they were taken from the gid).

Also, when modifying a QP or building address handle, instead of
parsing the dgid to get the MAC and VLAN, take them from the
address handle attributes.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c |   21 +++++++++------------
 drivers/infiniband/hw/mlx4/cq.c |    5 +++++
 drivers/infiniband/hw/mlx4/qp.c |   19 ++++++++++---------
 include/linux/mlx4/cq.h         |   14 ++++++++++----
 4 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index a251bec..3941700 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -92,21 +92,18 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
 	struct mlx4_dev *dev = ibdev->dev;
-	union ib_gid sgid;
-	u8 mac[6];
-	int err;
 	int is_mcast;
+	struct in6_addr in6;
 	u16 vlan_tag;
 
-	err = mlx4_ib_resolve_grh(ibdev, ah_attr, mac, &is_mcast, ah_attr->port_num);
-	if (err)
-		return ERR_PTR(err);
-
-	memcpy(ah->av.eth.mac, mac, 6);
-	err = ib_get_cached_gid(pd->device, ah_attr->port_num, ah_attr->grh.sgid_index, &sgid);
-	if (err)
-		return ERR_PTR(err);
-	vlan_tag = rdma_get_vlan_id(&sgid);
+	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof(in6));
+	if (rdma_is_multicast_addr(&in6)) {
+		is_mcast = 1;
+		rdma_get_mcast_mac(&in6, ah->av.eth.mac);
+	} else {
+		memcpy(ah->av.eth.mac, ah_attr->dmac, 6);
+	}
+	vlan_tag = ah_attr->vlan;
 	if (vlan_tag < 0x1000)
 		vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index d5e60f4..ba3f85b 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -793,6 +793,11 @@ repoll:
 			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 13;
 		else
 			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 12;
+		if (be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_VLAN_PRESENT_MASK)
+			wc->vlan = be16_to_cpu(cqe->sl_vid) & MLX4_CQE_VID_MASK;
+		else
+			wc->vlan = 0xffff;
+		memcpy(wc->smac, cqe->smac, 6);
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4f10af2..ddf5a1a 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1147,11 +1147,8 @@ static void mlx4_set_sched(struct mlx4_qp_path *path, u8 port)
 static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 			 struct mlx4_qp_path *path, u8 port)
 {
-	int err;
 	int is_eth = rdma_port_get_link_layer(&dev->ib_dev, port) ==
 		IB_LINK_LAYER_ETHERNET;
-	u8 mac[6];
-	int is_mcast;
 	u16 vlan_tag;
 	int vidx;
 
@@ -1188,16 +1185,12 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		if (!(ah->ah_flags & IB_AH_GRH))
 			return -1;
 
-		err = mlx4_ib_resolve_grh(dev, ah, mac, &is_mcast, port);
-		if (err)
-			return err;
-
-		memcpy(path->dmac, mac, 6);
+		memcpy(path->dmac, ah->dmac, 6);
 		path->ackto = MLX4_IB_LINK_TYPE_ETH;
 		/* use index 0 into MAC table for IBoE */
 		path->grh_mylmc &= 0x80;
 
-		vlan_tag = rdma_get_vlan_id(&dev->iboe.gid_table[port - 1][ah->grh.sgid_index]);
+		vlan_tag = ah->vlan;
 		if (vlan_tag < 0x1000) {
 			if (mlx4_find_cached_vlan(dev->dev, port, vlan_tag, &vidx))
 				return -ENOENT;
@@ -1236,6 +1229,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	enum mlx4_qp_optpar optpar = 0;
 	int sqd_event;
 	int err = -EINVAL;
+	int is_eth;
 
 	context = kzalloc(sizeof *context, GFP_KERNEL);
 	if (!context)
@@ -1464,6 +1458,13 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.ackto = (context->pri_path.ackto & 0xf8) |
 					MLX4_IB_LINK_TYPE_ETH;
 
+	if (ibqp->qp_type == IB_QPT_UD)
+		if (is_eth && (new_state == IB_QPS_RTR)) {
+			context->pri_path.ackto = MLX4_IB_LINK_TYPE_ETH;
+			optpar |= MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH;
+		}
+
+
 	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
 	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
 		sqd_event = 1;
diff --git a/include/linux/mlx4/cq.h b/include/linux/mlx4/cq.h
index 98fa492..72ba0a9 100644
--- a/include/linux/mlx4/cq.h
+++ b/include/linux/mlx4/cq.h
@@ -43,10 +43,15 @@ struct mlx4_cqe {
 	__be32			immed_rss_invalid;
 	__be32			g_mlpath_rqpn;
 	__be16			sl_vid;
-	__be16			rlid;
-	__be16			status;
-	u8			ipv6_ext_mask;
-	u8			badfcs_enc;
+	union {
+		struct {
+			__be16	rlid;
+			__be16  status;
+			u8      ipv6_ext_mask;
+			u8      badfcs_enc;
+		};
+		u8  smac[6];
+	};
 	__be32			byte_cnt;
 	__be16			wqe_index;
 	__be16			checksum;
@@ -83,6 +88,7 @@ struct mlx4_ts_cqe {
 enum {
 	MLX4_CQE_VLAN_PRESENT_MASK	= 1 << 29,
 	MLX4_CQE_QPN_MASK		= 0xffffff,
+	MLX4_CQE_VID_MASK		= 0xfff,
 };
 
 enum {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
