From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 11/11] mlx4: Add vlan support to IBoE
Date: Thu, 18 Feb 2010 19:24:50 +0200
Message-ID: <20100218172450.GL12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch allows IBoE traffic to be encapsulated in 802.1q tagged VLAN
frames. The VLAN tag is encoded in the GID and derived from it by a simple
computation. The netdev notifier callback is modified to catch new VLAN devices
addition/removal and the port's GID table is updated to reflect the change such
that for each netdevice there is an entry in the GID table. When the port's GID
table is exhausted, GID entries will not be added. Only children of the main
interface's can add to the GID table. If a vlan interface is added on another
vlan interface (e.g. vconfig add eth2.6 8), then that interfaces will not add
an entry to the GID table.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/ah.c        |   22 +++++++--
 drivers/infiniband/hw/mlx4/main.c      |   84 +++++++++++++++++++++++++++-----
 drivers/infiniband/hw/mlx4/mlx4_ib.h   |    4 +-
 drivers/infiniband/hw/mlx4/qp.c        |   49 +++++++++++++++---
 drivers/infiniband/hw/mthca/mthca_qp.c |    2 +-
 drivers/net/mlx4/en_netdev.c           |   10 ++++
 drivers/net/mlx4/mlx4_en.h             |    1 +
 drivers/net/mlx4/port.c                |   19 +++++++
 include/linux/mlx4/device.h            |    1 +
 include/linux/mlx4/qp.h                |    2 +-
 10 files changed, 166 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 0a2f1fb..32911c0 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -34,6 +34,7 @@
 #include <rdma/ib_addr.h>
 #include <linux/inet.h>
 #include <linux/string.h>
+#include <rdma/ib_cache.h>
 
 int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
 			u8 *mac, int *is_mcast, u8 port)
@@ -98,6 +99,8 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	u8 mac[6];
 	int err;
 	int is_mcast;
+	u16 vlan_tag;
+	union ib_gid sgid;
 
 	err = mlx4_ib_resolve_grh(ibdev, ah_attr, mac, &is_mcast, ah_attr->port_num);
 	if (err)
@@ -105,8 +108,14 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 
 	memcpy(ah->av.eth.mac_0_1, mac, 2);
 	memcpy(ah->av.eth.mac_2_5, mac + 2, 4);
+	err = ib_get_cached_gid(pd->device, ah_attr->port_num, ah_attr->grh.sgid_index, &sgid);
+	if (err)
+		return ERR_PTR(err);
+	vlan_tag = rdma_get_vlan_id(&sgid);
+	vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
 	ah->av.eth.gid_index = ah_attr->grh.sgid_index;
+	ah->av.eth.vlan = cpu_to_be16(vlan_tag);
 	if (ah_attr->static_rate) {
 		ah->av.eth.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
 		while (ah->av.eth.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
@@ -194,8 +203,8 @@ int mlx4_ib_destroy_ah(struct ib_ah *ah)
 	return 0;
 }
 
-int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
-			    int sgid_idx, u8 *mac, u16 *vlan_id)
+int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *dgid,
+			    int sgid_idx, u8 *mac, u16 *vlan_id, u8 *tagged)
 {
 	int err;
 	struct mlx4_ib_dev *ibdev = to_mdev(device);
@@ -203,13 +212,18 @@ int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid
 		.port_num = port,
 	};
 	int is_mcast;
+	union ib_gid sgid;
 
-	memcpy(ah_attr.grh.dgid.raw, gid, 16);
+	memcpy(ah_attr.grh.dgid.raw, dgid, 16);
 	err = mlx4_ib_resolve_grh(ibdev, &ah_attr, mac, &is_mcast, port);
 	if (err)
 		ERR_PTR(err);
 
-	*vlan_id = 0;
+	err = ib_get_cached_gid(device, port, sgid_idx, &sgid);
+	if (err)
+		return err;
+	*vlan_id = rdma_get_vlan_id(&sgid);
+	*tagged = !!(*vlan_id);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 3b8ab83..f02897d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -37,6 +37,7 @@
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/if_vlan.h>
 
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
@@ -78,6 +79,8 @@ static void init_query_mad(struct ib_smp *mad)
 	mad->method	   = IB_MGMT_METHOD_GET;
 }
 
+static union ib_gid zgid;
+
 static int mlx4_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props)
 {
@@ -800,12 +803,17 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
-static void mlx4_addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
+static void mlx4_addrconf_ifid_eui48(u8 *eui, int is_vlan, u16 vlan_id, struct net_device *dev)
 {
 	memcpy(eui, dev->dev_addr, 3);
 	memcpy(eui + 5, dev->dev_addr + 3, 3);
-	eui[3] = 0xFF;
-	eui[4] = 0xFE;
+	if (is_vlan) {
+		eui[3] = vlan_id >> 8;
+		eui[4] = vlan_id & 0xff;
+	} else {
+		eui[3] = 0xff;
+		eui[4] = 0xfe;
+	}
 	eui[0] ^= 2;
 }
 
@@ -847,22 +855,74 @@ static int update_ipv6_gids(struct mlx4_ib_dev *dev, int port, int clear)
 {
 	struct net_device *ndev = dev->iboe.netdevs[port - 1];
 	struct update_gid_work *work;
+	struct net_device *tmp;
+	int i;
+	u8 *hits;
+	int ret;
+	union ib_gid gid;
+	int free = -1;
+	int found;
+	int need_update = 0;
 
 	work = kzalloc(sizeof *work, GFP_ATOMIC);
 	if (!work)
 		return -ENOMEM;
 
-	if (!clear) {
-		mlx4_addrconf_ifid_eui48(&work->gids[0].raw[8], ndev);
-		work->gids[0].global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	hits = kzalloc(128, GFP_KERNEL);
+	if (!hits) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	INIT_WORK(&work->work, update_gids_task);
-	work->port = port;
-	work->dev = dev;
-	queue_work(wq, &work->work);
+	read_lock(&dev_base_lock);
+	for_each_netdev(&init_net, tmp) {
+		if (ndev && (tmp == ndev || rdma_vlan_dev_real_dev(tmp) == ndev)) {
+			gid.global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+			mlx4_addrconf_ifid_eui48(&gid.raw[8], tmp->priv_flags & IFF_802_1Q_VLAN,
+						 rdma_vlan_dev_vlan_id(tmp), ndev);
+			found = 0;
+			for (i = 0; i < 128; ++i) {
+				if (free < 0 &&
+				    !memcmp(&dev->iboe.gid_table[port - 1][i], &zgid, sizeof zgid))
+					free = i;
+				if (!memcmp(&dev->iboe.gid_table[port - 1][i], &gid, sizeof gid)) {
+					hits[i] = 1;
+					found = 1;
+					break;
+				}
+			}
+			if (!found && free >= 0) {
+				dev->iboe.gid_table[port - 1][free] = gid;
+				hits[free] = 1;
+				++need_update;
+			}
+		}
+	}
+	read_unlock(&dev_base_lock);
 
+	for (i = 0; i < 128; ++i)
+		if (!hits[i]) {
+			if (memcmp(&dev->iboe.gid_table[port - 1][i], &zgid, sizeof zgid))
+				++need_update;
+			dev->iboe.gid_table[port - 1][i] = zgid;
+		}
+
+
+	if (need_update) {
+		memcpy(work->gids, dev->iboe.gid_table[port - 1], sizeof work->gids);
+		INIT_WORK(&work->work, update_gids_task);
+		work->port = port;
+		work->dev = dev;
+		queue_work(wq, &work->work);
+	} else
+		kfree(work);
+
+	kfree(hits);
 	return 0;
+
+out:
+	kfree(work);
+	return ret;
 }
 
 static void handle_en_event(struct mlx4_ib_dev *dev, int port, unsigned long event)
@@ -915,9 +975,9 @@ static int mlx4_ib_netdev_event(struct notifier_block *this, unsigned long event
 		}
 	}
 
-	if (dev == iboe->netdevs[0])
+	if (dev == iboe->netdevs[0] || rdma_vlan_dev_real_dev(dev) == iboe->netdevs[0])
 		handle_en_event(ibdev, 1, event);
-	else if (dev == iboe->netdevs[1])
+	else if (dev == iboe->netdevs[1] || rdma_vlan_dev_real_dev(dev) == iboe->netdevs[1])
 		handle_en_event(ibdev, 2, event);
 
 	spin_unlock(&iboe->lock);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 8fc842b..88f1ba6 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -334,8 +334,8 @@ int mlx4_ib_fmr_dealloc(struct ib_fmr *fmr);
 int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
 			u8 *mac, int *is_mcast, u8 port);
 
-int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
-			    int sgid_idx, u8 *mac, u16 *vlan_id);
+int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *dgid,
+			    int sgid_idx, u8 *mac, u16 *vlan_id, u8 *tagged);
 
 static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 {
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 6356532..dc7d7d9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -36,6 +36,7 @@
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
+#include <rdma/ib_addr.h>
 
 #include <linux/mlx4/qp.h>
 
@@ -875,6 +876,8 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		IB_LINK_LAYER_ETHERNET ? 1 : 0;
 	u8 mac[6];
 	int is_mcast;
+	u16 vlan_tag;
+	int vidx;
 
 	path->grh_mylmc     = ah->src_path_bits & 0x7f;
 	path->rlid	    = cpu_to_be16(ah->dlid);
@@ -903,10 +906,10 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		memcpy(path->rgid, ah->grh.dgid.raw, 16);
 	}
 
-	path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
-		((port - 1) << 6) | ((ah->sl & 0xf) << 2);
-
 	if (is_eth) {
+		path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
+			((port - 1) << 6) | ((ah->sl & 0xf) << 3);
+
 		if (!(ah->ah_flags & IB_AH_GRH))
 			return -1;
 
@@ -918,7 +921,18 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 		path->ackto = MLX4_IB_LINK_TYPE_ETH;
 		/* use index 0 into MAC table for IBoE */
 		path->grh_mylmc &= 0x80;
-	}
+
+		vlan_tag = rdma_get_vlan_id(&dev->iboe.gid_table[port - 1][ah->grh.sgid_index]);
+		if (vlan_tag) {
+			if (mlx4_find_cached_vlan(dev->dev, port, vlan_tag, &vidx))
+				return -ENOENT;
+
+			path->vlan_index = vidx;
+			path->fl = 1 << 6;
+		}
+	} else
+		path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
+			((port - 1) << 6) | ((ah->sl & 0xf) << 2);
 
 	return 0;
 }
@@ -1279,7 +1293,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	union ib_gid sgid;
 	int is_eth;
 	int is_grh;
+	int is_vlan;
 	int err;
+	__be16 vlan;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
@@ -1292,7 +1308,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	if (err)
 		return err;
 
-	ib_ud_header_init(send_size, !is_eth, is_eth, is_grh, 0, &sqp->ud_header);
+	vlan = cpu_to_be16(rdma_get_vlan_id(&sgid));
+	is_vlan = !!vlan;
+	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sqp->ud_header);
 
 	if (!is_eth) {
 		sqp->ud_header.lrh.service_level =
@@ -1345,7 +1363,15 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		memcpy(sqp->ud_header.eth.smac_h, smac, 6);
 		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
 			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
-		sqp->ud_header.eth.type = cpu_to_be16(MLX4_IBOE_ETHERTYPE);
+		if (!is_vlan)
+			sqp->ud_header.eth.type = cpu_to_be16(MLX4_IBOE_ETHERTYPE);
+		else {
+			u16 pcp;
+
+			sqp->ud_header.vlan.type = cpu_to_be16(MLX4_IBOE_ETHERTYPE);
+			pcp = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 23 & 0xe0;
+			sqp->ud_header.vlan.tag = vlan | pcp;
+		}
 	} else {
 		sqp->ud_header.lrh.virtual_lane    = !sqp->qp.ibqp.qp_num ? 15 : 0;
 		if (sqp->ud_header.lrh.destination_lid == IB_LID_PERMISSIVE)
@@ -1495,13 +1521,14 @@ static void set_atomic_seg(struct mlx4_wqe_atomic_seg *aseg, struct ib_send_wr *
 }
 
 static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
-			     struct ib_send_wr *wr)
+			     struct ib_send_wr *wr, __be16 *vlan)
 {
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = cpu_to_be32(wr->wr.ud.remote_qpn);
 	dseg->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
 	dseg->vlan = to_mah(wr->wr.ud.ah)->av.eth.vlan;
 	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->av.eth.mac_0_1, 6);
+	*vlan = dseg->vlan;
 }
 
 static void set_mlx_icrc_seg(void *dseg)
@@ -1604,6 +1631,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	__be32 uninitialized_var(lso_hdr_sz);
 	__be32 blh;
 	int i;
+	__be16 vlan = 0;
 
 	spin_lock_irqsave(&qp->sq.lock, flags);
 
@@ -1693,7 +1721,7 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			break;
 
 		case IB_QPT_UD:
-			set_datagram_seg(wqe, wr);
+			set_datagram_seg(wqe, wr, &vlan);
 			wqe  += sizeof (struct mlx4_wqe_datagram_seg);
 			size += sizeof (struct mlx4_wqe_datagram_seg) / 16;
 
@@ -1771,6 +1799,11 @@ int mlx4_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 		ctrl->owner_opcode = mlx4_ib_opcode[wr->opcode] |
 			(ind & qp->sq.wqe_cnt ? cpu_to_be32(1 << 31) : 0) | blh;
 
+		if (vlan) {
+			ctrl->ins_vlan = 1 << 6;
+			ctrl->vlan_tag = vlan;
+		}
+
 		stamp = ind + qp->sq_spare_wqes;
 		ind += DIV_ROUND_UP(size * 16, 1U << qp->sq.wqe_shift);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 0070c50..53984d1 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1494,7 +1494,7 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 	u16 pkey;
 
 	ib_ud_header_init(256, /* assume a MAD */
-			  1, 0,
+			  1, 0, 0,
 			  mthca_ah_grh_present(to_mah(wr->wr.ud.ah)),
 			  0,
 			  &sqp->ud_header);
diff --git a/drivers/net/mlx4/en_netdev.c b/drivers/net/mlx4/en_netdev.c
index c48b0f4..610b7ca 100644
--- a/drivers/net/mlx4/en_netdev.c
+++ b/drivers/net/mlx4/en_netdev.c
@@ -68,6 +68,7 @@ static void mlx4_en_vlan_rx_add_vid(struct net_device *dev, unsigned short vid)
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	int err;
+	int idx;
 
 	if (!priv->vlgrp)
 		return;
@@ -82,7 +83,10 @@ static void mlx4_en_vlan_rx_add_vid(struct net_device *dev, unsigned short vid)
 		if (err)
 			en_err(priv, "Failed configuring VLAN filter\n");
 	}
+	if (mlx4_register_vlan(mdev->dev, priv->port, vid, &idx))
+		en_err(priv, "failed adding vlan %d\n", vid);
 	mutex_unlock(&mdev->state_lock);
+
 }
 
 static void mlx4_en_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid)
@@ -90,6 +94,7 @@ static void mlx4_en_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid)
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	int err;
+	int idx;
 
 	if (!priv->vlgrp)
 		return;
@@ -100,6 +105,11 @@ static void mlx4_en_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid)
 
 	/* Remove VID from port VLAN filter */
 	mutex_lock(&mdev->state_lock);
+	if (!mlx4_find_cached_vlan(mdev->dev, priv->port, vid, &idx))
+		mlx4_unregister_vlan(mdev->dev, priv->port, idx);
+	else
+		en_err(priv, "could not find vid %d in cache\n", vid);
+
 	if (mdev->device_up && priv->port_up) {
 		err = mlx4_SET_VLAN_FLTR(mdev->dev, priv->port, priv->vlgrp);
 		if (err)
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 82c3ebc..978e1fb 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -494,6 +494,7 @@ struct mlx4_en_priv {
 	struct mlx4_en_port_stats port_stats;
 	struct dev_mc_list *mc_list;
 	struct mlx4_en_stat_out_mbox hw_stats;
+	int vids[128];
 };
 
 
diff --git a/drivers/net/mlx4/port.c b/drivers/net/mlx4/port.c
index 606aa58..e7d1840 100644
--- a/drivers/net/mlx4/port.c
+++ b/drivers/net/mlx4/port.c
@@ -182,6 +182,25 @@ static int mlx4_set_port_vlan_table(struct mlx4_dev *dev, u8 port,
 	return err;
 }
 
+int mlx4_find_cached_vlan(struct mlx4_dev *dev, u8 port, u16 vid, int *idx)
+{
+	struct mlx4_vlan_table *table = &mlx4_priv(dev)->port[port].vlan_table;
+	int i;
+
+	for (i = 0; i < MLX4_MAX_VLAN_NUM; ++i) {
+		if (table->refs[i] &&
+		    (vid == (MLX4_VLAN_MASK &
+			      be32_to_cpu(table->entries[i])))) {
+			/* Vlan already registered, increase refernce count */
+			*idx = i;
+			return 0;
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(mlx4_find_cached_vlan);
+
 int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index)
 {
 	struct mlx4_vlan_table *table = &mlx4_priv(dev)->port[port].vlan_table;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 1653906..245cb1a 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -497,6 +497,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16]);
 int mlx4_register_mac(struct mlx4_dev *dev, u8 port, u64 mac, int *index);
 void mlx4_unregister_mac(struct mlx4_dev *dev, u8 port, int index);
 
+int mlx4_find_cached_vlan(struct mlx4_dev *dev, u8 port, u16 vid, int *idx);
 int mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan, int *index);
 void mlx4_unregister_vlan(struct mlx4_dev *dev, u8 port, int index);
 
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 3308f3c..a654bd4 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -109,7 +109,7 @@ struct mlx4_qp_path {
 	__be32			tclass_flowlabel;
 	u8			rgid[16];
 	u8			sched_queue;
-	u8			snooper_flags;
+	u8			vlan_index;
 	u8			reserved3[2];
 	u8			counter_index;
 	u8			reserved4;
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
