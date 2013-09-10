From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 4/9] IB/mlx4: Handle Ethernet L2 parameters for IP based GID addressing
Date: Tue, 10 Sep 2013 17:41:34 +0300
Message-ID: <1378824099-22150-5-git-send-email-ogerlitz@mellanox.com>
References: <1378824099-22150-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378824099-22150-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IP based RoCE gids don't store Ethernet L2 parameters, MAC and VLAN.

Hence, we need to extract them now from the CQE and place in struct
ib_wc (to be used for cases were they were taken from the gid).

Also, when modifying a QP or building address handle, instead of
parsing the dgid to get the MAC and VLAN, take them from the
address handle attributes.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c           |   40 +++---------
 drivers/infiniband/hw/mlx4/cq.c           |    9 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    3 -
 drivers/infiniband/hw/mlx4/qp.c           |  105 ++++++++++++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/port.c |   20 ++++++
 include/linux/mlx4/cq.h                   |   15 +++-
 6 files changed, 130 insertions(+), 62 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index a251bec..170dca6 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -39,25 +39,6 @@
 
 #include "mlx4_ib.h"
 
-int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
-			u8 *mac, int *is_mcast, u8 port)
-{
-	struct in6_addr in6;
-
-	*is_mcast = 0;
-
-	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof in6);
-	if (rdma_link_local_addr(&in6))
-		rdma_get_ll_mac(&in6, mac);
-	else if (rdma_is_multicast_addr(&in6)) {
-		rdma_get_mcast_mac(&in6, mac);
-		*is_mcast = 1;
-	} else
-		return -EINVAL;
-
-	return 0;
-}
-
 static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 				  struct mlx4_ib_ah *ah)
 {
@@ -92,21 +73,18 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
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
+		memcpy(ah->av.eth.mac, ah_attr->dmac, ETH_ALEN);
+	}
+	vlan_tag = ah_attr->vlan_id;
 	if (vlan_tag < 0x1000)
 		vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index d5e60f4..5f6113b 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -793,6 +793,15 @@ repoll:
 			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 13;
 		else
 			wc->sl  = be16_to_cpu(cqe->sl_vid) >> 12;
+		if (be32_to_cpu(cqe->vlan_my_qpn) & MLX4_CQE_VLAN_PRESENT_MASK) {
+			wc->vlan_id = be16_to_cpu(cqe->sl_vid) &
+				MLX4_CQE_VID_MASK;
+		} else {
+			wc->vlan_id = 0xffff;
+		}
+		wc->wc_flags |= IB_WC_WITH_VLAN;
+		memcpy(wc->smac, cqe->smac, ETH_ALEN);
+		wc->wc_flags |= IB_WC_WITH_SMAC;
 	}
 
 	return 0;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 133f41f..c06f571 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -678,9 +678,6 @@ int __mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			union ib_gid *gid, int netw_view);
 
-int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
-			u8 *mac, int *is_mcast, u8 port);
-
 static inline bool mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 {
 	u8 port = be32_to_cpu(ah->av.ib.port_pd) >> 24 & 3;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index da6f5fa..e0c2186 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -90,6 +90,21 @@ enum {
 	MLX4_RAW_QP_MSGMAX	= 31,
 };
 
+#ifndef ETH_ALEN
+#define ETH_ALEN        6
+#endif
+static inline u64 mlx4_mac_to_u64(u8 *addr)
+{
+	u64 mac = 0;
+	int i;
+
+	for (i = 0; i < ETH_ALEN; i++) {
+		mac <<= 8;
+		mac |= addr[i];
+	}
+	return mac;
+}
+
 static const __be32 mlx4_ib_opcode[] = {
 	[IB_WR_SEND]				= cpu_to_be32(MLX4_OPCODE_SEND),
 	[IB_WR_LSO]				= cpu_to_be32(MLX4_OPCODE_LSO),
@@ -1144,16 +1159,15 @@ static void mlx4_set_sched(struct mlx4_qp_path *path, u8 port)
 	path->sched_queue = (path->sched_queue & 0xbf) | ((port - 1) << 6);
 }
 
-static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
-			 struct mlx4_qp_path *path, u8 port)
+static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
+			  u64 smac, u16 vlan_tag, struct mlx4_qp_path *path,
+			  u8 port)
 {
-	int err;
 	int is_eth = rdma_port_get_link_layer(&dev->ib_dev, port) ==
 		IB_LINK_LAYER_ETHERNET;
-	u8 mac[6];
-	int is_mcast;
-	u16 vlan_tag;
 	int vidx;
+	int smac_index;
+
 
 	path->grh_mylmc     = ah->src_path_bits & 0x7f;
 	path->rlid	    = cpu_to_be16(ah->dlid);
@@ -1188,22 +1202,27 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		if (!(ah->ah_flags & IB_AH_GRH))
 			return -1;
 
-		err = mlx4_ib_resolve_grh(dev, ah, mac, &is_mcast, port);
-		if (err)
-			return err;
-
-		memcpy(path->dmac, mac, 6);
+		memcpy(path->dmac, ah->dmac, ETH_ALEN);
 		path->ackto = MLX4_IB_LINK_TYPE_ETH;
-		/* use index 0 into MAC table for IBoE */
-		path->grh_mylmc &= 0x80;
+		/* find the index  into MAC table for IBoE */
+		if (!is_zero_ether_addr((const u8 *)&smac)) {
+			if (mlx4_find_cached_mac(dev->dev, port, smac,
+						 &smac_index))
+				return -ENOENT;
+		} else {
+			smac_index = 0;
+		}
+
+		path->grh_mylmc &= 0x80 | smac_index;
 
-		vlan_tag = rdma_get_vlan_id(&dev->iboe.gid_table[port - 1][ah->grh.sgid_index]);
+		path->feup |= MLX4_FEUP_FORCE_ETH_UP;
 		if (vlan_tag < 0x1000) {
 			if (mlx4_find_cached_vlan(dev->dev, port, vlan_tag, &vidx))
 				return -ENOENT;
 
 			path->vlan_index = vidx;
 			path->fl = 1 << 6;
+			path->feup |= MLX4_FVL_FORCE_ETH_VLAN;
 		}
 	} else
 		path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
@@ -1212,6 +1231,28 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 	return 0;
 }
 
+static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_qp_attr *qp,
+			 enum ib_qp_attr_mask qp_attr_mask,
+			 struct mlx4_qp_path *path, u8 port)
+{
+	return _mlx4_set_path(dev, &qp->ah_attr,
+			      mlx4_mac_to_u64((u8 *)qp->smac),
+			      (qp_attr_mask & IB_QP_VID) ? qp->vlan_id : 0xffff,
+			      path, port);
+}
+
+static int mlx4_set_alt_path(struct mlx4_ib_dev *dev,
+			     const struct ib_qp_attr *qp,
+			     enum ib_qp_attr_mask qp_attr_mask,
+			     struct mlx4_qp_path *path, u8 port)
+{
+	return _mlx4_set_path(dev, &qp->alt_ah_attr,
+			      mlx4_mac_to_u64((u8 *)qp->alt_smac),
+			      (qp_attr_mask & IB_QP_ALT_VID) ?
+			      qp->alt_vlan_id : 0xffff,
+			      path, port);
+}
+
 static void update_mcg_macs(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 {
 	struct mlx4_ib_gid_entry *ge, *tmp;
@@ -1329,7 +1370,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_AV) {
-		if (mlx4_set_path(dev, &attr->ah_attr, &context->pri_path,
+		if (mlx4_set_path(dev, attr, attr_mask, &context->pri_path,
 				  attr_mask & IB_QP_PORT ?
 				  attr->port_num : qp->port))
 			goto out;
@@ -1352,8 +1393,8 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		    dev->dev->caps.pkey_table_len[attr->alt_port_num])
 			goto out;
 
-		if (mlx4_set_path(dev, &attr->alt_ah_attr, &context->alt_path,
-				  attr->alt_port_num))
+		if (mlx4_set_alt_path(dev, attr, attr_mask, &context->alt_path,
+				      attr->alt_port_num))
 			goto out;
 
 		context->alt_path.pkey_index = attr->alt_pkey_index;
@@ -1464,6 +1505,17 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		context->pri_path.ackto = (context->pri_path.ackto & 0xf8) |
 					MLX4_IB_LINK_TYPE_ETH;
 
+	if (ibqp->qp_type == IB_QPT_UD && (new_state == IB_QPS_RTR)) {
+		int is_eth = rdma_port_get_link_layer(
+				&dev->ib_dev, qp->port) ==
+				IB_LINK_LAYER_ETHERNET;
+		if (is_eth) {
+			context->pri_path.ackto = MLX4_IB_LINK_TYPE_ETH;
+			optpar |= MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH;
+		}
+	}
+
+
 	if (cur_state == IB_QPS_RTS && new_state == IB_QPS_SQD	&&
 	    attr_mask & IB_QP_EN_SQD_ASYNC_NOTIFY && attr->en_sqd_async_notify)
 		sqd_event = 1;
@@ -1561,18 +1613,21 @@ int mlx4_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	struct mlx4_ib_qp *qp = to_mqp(ibqp);
 	enum ib_qp_state cur_state, new_state;
 	int err = -EINVAL;
-	int p = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+	int ll;
 	mutex_lock(&qp->mutex);
 
 	cur_state = attr_mask & IB_QP_CUR_STATE ? attr->cur_qp_state : qp->state;
 	new_state = attr_mask & IB_QP_STATE ? attr->qp_state : cur_state;
 
-	if (cur_state == new_state && cur_state == IB_QPS_RESET)
-		p = IB_LINK_LAYER_UNSPECIFIED;
+	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
+		ll = IB_LINK_LAYER_UNSPECIFIED;
+	} else {
+		int port = attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+		ll = rdma_port_get_link_layer(&dev->ib_dev, port);
+	}
 
 	if (!ib_modify_qp_is_ok(cur_state, new_state, ibqp->qp_type,
-				attr_mask,
-				rdma_port_get_link_layer(&dev->ib_dev, p))) {
+				attr_mask, ll)) {
 		pr_debug("qpn 0x%x: invalid attribute mask specified "
 			 "for transition %d to %d. qp_type %d,"
 			 " attr_mask 0x%x\n",
@@ -1789,8 +1844,10 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 				return err;
 		}
 
-		vlan = rdma_get_vlan_id(&sgid);
-		is_vlan = vlan < 0x1000;
+		if (ah->av.eth.vlan != 0xffff) {
+			vlan = be16_to_cpu(ah->av.eth.vlan) & 0x0fff;
+			is_vlan = 1;
+		}
 	}
 	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sqp->ud_header);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 946e0af..fbe76f9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -123,6 +123,26 @@ static int mlx4_set_port_mac_table(struct mlx4_dev *dev, u8 port,
 	return err;
 }
 
+int mlx4_find_cached_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *idx)
+{
+	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
+	struct mlx4_mac_table *table = &info->mac_table;
+	int i;
+
+	for (i = 0; i < MLX4_MAX_MAC_NUM; i++) {
+		if (!table->refs[i])
+			continue;
+
+		if (mac == (MLX4_MAC_MASK & be64_to_cpu(table->entries[i]))) {
+			*idx = i;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(mlx4_find_cached_mac);
+
 int __mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac)
 {
 	struct mlx4_port_info *info = &mlx4_priv(dev)->port[port];
diff --git a/include/linux/mlx4/cq.h b/include/linux/mlx4/cq.h
index 98fa492..e186299 100644
--- a/include/linux/mlx4/cq.h
+++ b/include/linux/mlx4/cq.h
@@ -34,6 +34,7 @@
 #define MLX4_CQ_H
 
 #include <linux/types.h>
+#include <uapi/linux/if_ether.h>
 
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
@@ -43,10 +44,15 @@ struct mlx4_cqe {
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
+		u8  smac[ETH_ALEN];
+	};
 	__be32			byte_cnt;
 	__be16			wqe_index;
 	__be16			checksum;
@@ -83,6 +89,7 @@ struct mlx4_ts_cqe {
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
