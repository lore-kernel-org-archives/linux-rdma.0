From: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCHv8 09/11] mlx4: Add support for IBoE - address resolution
Date: Thu, 18 Feb 2010 19:24:36 +0200
Message-ID: <20100218172436.GJ12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The following patch handles address vectors creation for IBoE ports. mlx4 needs
the MAC address of the remote node to include it in the WQE of a UD QP or in
the QP context of connected QPs. Address resolution is done atomically in the
case of a link local address or a multicast GID and otherwise -EINVAL is
returned.  mlx4 transport packets were changed too to accommodate for IBoE.
Multicast groups attach/detach calls dev_mc_add/remove to update the NIC's
multicast filters.Since attaching a QP to a multicast group does not require
the QP to be in a state different then INIT - this is fine for IB. For IBoE
however, we need the port assigned to the QP in order to call dev_mc_add() for
the correct netdevice, while port is assigned when moving from INIT to RTR.
Hence, we must keep track of all the multicast groups attached to a QP and call
dev_mc_add() when the port becomes available.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Changes from v7:

1. Fix failure to initialize gid_index in create_iboe_ah()
2. Move call register_netdevice_notifier() after call to ib_register_device()
3. Call flush_workqueue() after unregister notifier to flush any pending work
   requesets.
4. Change build_mlx_header to match changes to ud_header.c


 drivers/infiniband/hw/mlx4/ah.c        |  182 ++++++++++---
 drivers/infiniband/hw/mlx4/mad.c       |   32 ++-
 drivers/infiniband/hw/mlx4/main.c      |  497 +++++++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h   |   35 +++-
 drivers/infiniband/hw/mlx4/qp.c        |  139 +++++++--
 drivers/infiniband/hw/mthca/mthca_qp.c |    2 +
 drivers/net/mlx4/en_port.c             |    4 +-
 drivers/net/mlx4/en_port.h             |    3 +-
 drivers/net/mlx4/fw.c                  |    3 +-
 include/linux/mlx4/cmd.h               |    1 +
 include/linux/mlx4/device.h            |   31 ++-
 include/linux/mlx4/qp.h                |    7 +-
 12 files changed, 819 insertions(+), 117 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index c75ac94..0a2f1fb 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -31,63 +31,158 @@
  */
 
 #include "mlx4_ib.h"
+#include <rdma/ib_addr.h>
+#include <linux/inet.h>
+#include <linux/string.h>
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
+			u8 *mac, int *is_mcast, u8 port)
 {
-	struct mlx4_dev *dev = to_mdev(pd->device)->dev;
-	struct mlx4_ib_ah *ah;
+	struct mlx4_ib_iboe *iboe = &dev->iboe;
+	struct in6_addr in6;
 
-	ah = kmalloc(sizeof *ah, GFP_ATOMIC);
-	if (!ah)
-		return ERR_PTR(-ENOMEM);
+	*is_mcast = 0;
+	spin_lock(&iboe->lock);
+	if (!iboe->netdevs[port - 1]) {
+		spin_unlock(&iboe->lock);
+		return -EINVAL;
+	}
+	spin_unlock(&iboe->lock);
 
-	memset(&ah->av, 0, sizeof ah->av);
+	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof in6);
+	if (rdma_link_local_addr(&in6))
+		rdma_get_ll_mac(&in6, mac);
+	else if (rdma_is_multicast_addr(&in6)) {
+		rdma_get_mcast_mac(&in6, mac);
+		*is_mcast = 1;
+	} else
+		return -EINVAL;
 
-	ah->av.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
-	ah->av.g_slid  = ah_attr->src_path_bits;
-	ah->av.dlid    = cpu_to_be16(ah_attr->dlid);
-	if (ah_attr->static_rate) {
-		ah->av.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
-		while (ah->av.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
-		       !(1 << ah->av.stat_rate & dev->caps.stat_rate_support))
-			--ah->av.stat_rate;
-	}
-	ah->av.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
+	return 0;
+}
+
+static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				  struct mlx4_ib_ah *ah)
+{
+	struct mlx4_dev *dev = to_mdev(pd->device)->dev;
+
+	ah->av.ib.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
+	ah->av.ib.g_slid  = ah_attr->src_path_bits;
 	if (ah_attr->ah_flags & IB_AH_GRH) {
-		ah->av.g_slid   |= 0x80;
-		ah->av.gid_index = ah_attr->grh.sgid_index;
-		ah->av.hop_limit = ah_attr->grh.hop_limit;
-		ah->av.sl_tclass_flowlabel |=
+		ah->av.ib.g_slid   |= 0x80;
+		ah->av.ib.gid_index = ah_attr->grh.sgid_index;
+		ah->av.ib.hop_limit = ah_attr->grh.hop_limit;
+		ah->av.ib.sl_tclass_flowlabel |=
 			cpu_to_be32((ah_attr->grh.traffic_class << 20) |
 				    ah_attr->grh.flow_label);
-		memcpy(ah->av.dgid, ah_attr->grh.dgid.raw, 16);
+		memcpy(ah->av.ib.dgid, ah_attr->grh.dgid.raw, 16);
+	}
+
+	ah->av.ib.dlid    = cpu_to_be16(ah_attr->dlid);
+	if (ah_attr->static_rate) {
+		ah->av.ib.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
+		while (ah->av.ib.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
+		       !(1 << ah->av.ib.stat_rate & dev->caps.stat_rate_support))
+			--ah->av.ib.stat_rate;
+	}
+	ah->av.ib.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
+
+	return &ah->ibah;
+}
+
+static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				    struct mlx4_ib_ah *ah)
+{
+	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
+	struct mlx4_dev *dev = ibdev->dev;
+	u8 mac[6];
+	int err;
+	int is_mcast;
+
+	err = mlx4_ib_resolve_grh(ibdev, ah_attr, mac, &is_mcast, ah_attr->port_num);
+	if (err)
+		return ERR_PTR(err);
+
+	memcpy(ah->av.eth.mac_0_1, mac, 2);
+	memcpy(ah->av.eth.mac_2_5, mac + 2, 4);
+	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
+	ah->av.eth.gid_index = ah_attr->grh.sgid_index;
+	if (ah_attr->static_rate) {
+		ah->av.eth.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
+		while (ah->av.eth.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
+		       !(1 << ah->av.eth.stat_rate & dev->caps.stat_rate_support))
+			--ah->av.eth.stat_rate;
 	}
 
+	/*
+	 * HW requires multicast LID so we just choose one.
+	 */
+	if (is_mcast)
+		ah->av.ib.dlid = cpu_to_be16(0xc000);
+
+	memcpy(ah->av.eth.dgid, ah_attr->grh.dgid.raw, 16);
+	ah->av.eth.sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
+
 	return &ah->ibah;
 }
 
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+{
+	struct mlx4_ib_ah *ah;
+	struct ib_ah *ret;
+
+	ah = kzalloc(sizeof *ah, GFP_ATOMIC);
+	if (!ah)
+		return ERR_PTR(-ENOMEM);
+
+	if (rdma_port_link_layer(pd->device, ah_attr->port_num) == IB_LINK_LAYER_ETHERNET) {
+		if (!(ah_attr->ah_flags & IB_AH_GRH)) {
+			ret = ERR_PTR(-EINVAL);
+			goto out;
+		} else {
+			/* TBD: need to handle the case when we get called
+			in an atomic context and there we might sleep. We
+			don't expect this currently since we're working with
+			link local addresses which we can translate without
+			going to sleep */
+			ret = create_iboe_ah(pd, ah_attr, ah);
+			if (IS_ERR(ret))
+				goto out;
+			else
+				return ret;
+		}
+	} else
+		return create_ib_ah(pd, ah_attr, ah); /* never fails */
+
+out:
+	kfree(ah);
+	return ret;
+}
+
 int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
 {
 	struct mlx4_ib_ah *ah = to_mah(ibah);
+	enum rdma_link_layer ll;
 
 	memset(ah_attr, 0, sizeof *ah_attr);
-	ah_attr->dlid	       = be16_to_cpu(ah->av.dlid);
-	ah_attr->sl	       = be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
-	ah_attr->port_num      = be32_to_cpu(ah->av.port_pd) >> 24;
-	if (ah->av.stat_rate)
-		ah_attr->static_rate = ah->av.stat_rate - MLX4_STAT_RATE_OFFSET;
-	ah_attr->src_path_bits = ah->av.g_slid & 0x7F;
+	ah_attr->sl = be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
+	ah_attr->port_num = be32_to_cpu(ah->av.ib.port_pd) >> 24;
+	ll = rdma_port_link_layer(ibah->device, ah_attr->port_num);
+	ah_attr->dlid = ll == IB_LINK_LAYER_INFINIBAND ? be16_to_cpu(ah->av.ib.dlid) : 0;
+	if (ah->av.ib.stat_rate)
+		ah_attr->static_rate = ah->av.ib.stat_rate - MLX4_STAT_RATE_OFFSET;
+	ah_attr->src_path_bits = ah->av.ib.g_slid & 0x7F;
 
 	if (mlx4_ib_ah_grh_present(ah)) {
 		ah_attr->ah_flags = IB_AH_GRH;
 
 		ah_attr->grh.traffic_class =
-			be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 20;
+			be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20;
 		ah_attr->grh.flow_label =
-			be32_to_cpu(ah->av.sl_tclass_flowlabel) & 0xfffff;
-		ah_attr->grh.hop_limit  = ah->av.hop_limit;
-		ah_attr->grh.sgid_index = ah->av.gid_index;
-		memcpy(ah_attr->grh.dgid.raw, ah->av.dgid, 16);
+			be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) & 0xfffff;
+		ah_attr->grh.hop_limit  = ah->av.ib.hop_limit;
+		ah_attr->grh.sgid_index = ah->av.ib.gid_index;
+		memcpy(ah_attr->grh.dgid.raw, ah->av.ib.dgid, 16);
 	}
 
 	return 0;
@@ -98,3 +193,24 @@ int mlx4_ib_destroy_ah(struct ib_ah *ah)
 	kfree(to_mah(ah));
 	return 0;
 }
+
+int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
+			    int sgid_idx, u8 *mac, u16 *vlan_id)
+{
+	int err;
+	struct mlx4_ib_dev *ibdev = to_mdev(device);
+	struct ib_ah_attr ah_attr = {
+		.port_num = port,
+	};
+	int is_mcast;
+
+	memcpy(ah_attr.grh.dgid.raw, gid, 16);
+	err = mlx4_ib_resolve_grh(ibdev, &ah_attr, mac, &is_mcast, port);
+	if (err)
+		ERR_PTR(err);
+
+	*vlan_id = 0;
+
+	return 0;
+}
+
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 19e68ab..e75b14d 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -310,19 +310,25 @@ int mlx4_ib_mad_init(struct mlx4_ib_dev *dev)
 	struct ib_mad_agent *agent;
 	int p, q;
 	int ret;
+	enum rdma_link_layer ll;
 
-	for (p = 0; p < dev->num_ports; ++p)
+	for (p = 0; p < dev->num_ports; ++p) {
+		ll = rdma_port_link_layer(&dev->ib_dev, p + 1);
 		for (q = 0; q <= 1; ++q) {
-			agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
-						      q ? IB_QPT_GSI : IB_QPT_SMI,
-						      NULL, 0, send_handler,
-						      NULL, NULL);
-			if (IS_ERR(agent)) {
-				ret = PTR_ERR(agent);
-				goto err;
-			}
-			dev->send_agent[p][q] = agent;
+			if (ll == IB_LINK_LAYER_INFINIBAND) {
+				agent = ib_register_mad_agent(&dev->ib_dev, p + 1,
+							      q ? IB_QPT_GSI : IB_QPT_SMI,
+							      NULL, 0, send_handler,
+							      NULL, NULL);
+				if (IS_ERR(agent)) {
+					ret = PTR_ERR(agent);
+					goto err;
+				}
+				dev->send_agent[p][q] = agent;
+			} else
+				dev->send_agent[p][q] = NULL;
 		}
+	}
 
 	return 0;
 
@@ -343,8 +349,10 @@ void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev)
 	for (p = 0; p < dev->num_ports; ++p) {
 		for (q = 0; q <= 1; ++q) {
 			agent = dev->send_agent[p][q];
-			dev->send_agent[p][q] = NULL;
-			ib_unregister_mad_agent(agent);
+			if (agent) {
+				dev->send_agent[p][q] = NULL;
+				ib_unregister_mad_agent(agent);
+			}
 		}
 
 		if (dev->sm_ah[p])
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index e596537..3b8ab83 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -34,9 +34,13 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+#include <linux/rtnetlink.h>
 
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_addr.h>
 
 #include <linux/mlx4/driver.h>
 #include <linux/mlx4/cmd.h>
@@ -57,6 +61,15 @@ static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
 
+struct update_gid_work {
+	struct work_struct work;
+	union ib_gid gids[128];
+	int port;
+	struct mlx4_ib_dev *dev;
+};
+
+static struct workqueue_struct *wq;
+
 static void init_query_mad(struct ib_smp *mad)
 {
 	mad->base_version  = 1;
@@ -152,28 +165,19 @@ out:
 	return err;
 }
 
-static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
-			      struct ib_port_attr *props)
+static enum rdma_link_layer
+mlx4_ib_port_link_layer(struct ib_device *device, u8 port_num)
 {
-	struct ib_smp *in_mad  = NULL;
-	struct ib_smp *out_mad = NULL;
-	int err = -ENOMEM;
-
-	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
-	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
-	if (!in_mad || !out_mad)
-		goto out;
+	struct mlx4_dev *dev = to_mdev(device)->dev;
 
-	memset(props, 0, sizeof *props);
-
-	init_query_mad(in_mad);
-	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
-	in_mad->attr_mod = cpu_to_be32(port);
-
-	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
-	if (err)
-		goto out;
+	return dev->caps.port_mask & (1 << (port_num - 1)) ?
+		IB_LINK_LAYER_INFINIBAND : IB_LINK_LAYER_ETHERNET;
+}
 
+static void ib_link_query_port(struct ib_device *ibdev, u8 port,
+			       struct ib_port_attr *props,
+			       struct ib_smp *out_mad)
+{
 	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc		= out_mad->data[34] & 0x7;
 	props->sm_lid		= be16_to_cpup((__be16 *) (out_mad->data + 18));
@@ -193,6 +197,128 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	props->subnet_timeout	= out_mad->data[51] & 0x1f;
 	props->max_vl_num	= out_mad->data[37] >> 4;
 	props->init_type_reply	= out_mad->data[41] >> 4;
+	props->link_layer	= IB_LINK_LAYER_INFINIBAND;
+}
+
+int eth_to_ib_width(int w)
+{
+	switch (w) {
+	case 4:
+		return 2;
+	case 8:
+	case 16:
+		return 4;
+	case 32:
+		return 8;
+	default:
+		return 1;
+	}
+}
+
+int eth_to_ib_speed(int s)
+{
+	switch (s) {
+	case 256:
+		return 1;
+	case 512:
+		return 2;
+	case 1024:
+		return 4;
+	default:
+		return 1;
+	}
+}
+
+static int eth_link_query_port(struct ib_device *ibdev, u8 port,
+			       struct ib_port_attr *props,
+			       struct ib_smp *out_mad)
+{
+	struct mlx4_ib_iboe *iboe = &to_mdev(ibdev)->iboe;
+	struct net_device *ndev;
+	struct mlx4_cmd_mailbox *mailbox;
+	struct mlx4_dev *dev = to_mdev(ibdev)->dev;
+	int err;
+	u32 *outbox;
+	u32 fl;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox))
+		return PTR_ERR(mailbox);
+
+	err = mlx4_cmd_box(dev, 0, mailbox->dma, port, 0, MLX4_CMD_QUERY_PORT,
+			   MLX4_CMD_TIME_CLASS_B);
+	if (err)
+		goto out;
+	outbox = mailbox->buf;
+
+	fl = be32_to_cpu(outbox[0x43]);
+	if (fl & 1 << 31)
+		props->active_width = eth_to_ib_width(fl & 0xffff);
+	else
+		props->active_width = 0;
+
+	fl = be32_to_cpu(outbox[0x41]);
+	if (fl & 1 << 31)
+		props->active_speed = eth_to_ib_speed(fl & 0xffff);
+	else
+		props->active_speed = 0;
+
+	props->port_cap_flags	= IB_PORT_CM_SUP;
+	props->gid_tbl_len	= to_mdev(ibdev)->dev->caps.gid_table_len[port];
+	props->max_msg_sz	= to_mdev(ibdev)->dev->caps.max_msg_sz;
+	props->pkey_tbl_len	= 1;
+	props->bad_pkey_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 46));
+	props->qkey_viol_cntr	= be16_to_cpup((__be16 *) (out_mad->data + 48));
+	props->max_mtu		= out_mad->data[41] & 0xf;
+	props->subnet_timeout	= 0;
+	props->max_vl_num	= out_mad->data[37] >> 4;
+	props->init_type_reply	= 0;
+	props->link_layer	= IB_LINK_LAYER_ETHERNET;
+	props->state		= IB_PORT_DOWN;
+	props->phys_state	= props->state;
+	props->active_mtu	= IB_MTU_256;
+	spin_lock(&iboe->lock);
+	ndev = iboe->netdevs[port - 1];
+	if (!ndev)
+		goto out_ul;
+
+	props->active_mtu	= iboe_get_mtu(ndev->mtu);
+	props->state		= netif_running(ndev) &&  netif_oper_up(ndev) ?
+					IB_PORT_ACTIVE : IB_PORT_DOWN;
+	props->phys_state	= props->state;
+
+out_ul:
+	spin_unlock(&iboe->lock);
+out:
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	return err;
+}
+
+static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
+			      struct ib_port_attr *props)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	memset(props, 0, sizeof *props);
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
+	in_mad->attr_mod = cpu_to_be32(port);
+
+	err = mlx4_MAD_IFC(to_mdev(ibdev), 1, 1, port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	mlx4_ib_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND ?
+		ib_link_query_port(ibdev, port, props, out_mad) :
+		eth_link_query_port(ibdev, port, props, out_mad);
 
 out:
 	kfree(in_mad);
@@ -201,8 +327,8 @@ out:
 	return err;
 }
 
-static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
-			     union ib_gid *gid)
+static int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+			       union ib_gid *gid)
 {
 	struct ib_smp *in_mad  = NULL;
 	struct ib_smp *out_mad = NULL;
@@ -239,6 +365,25 @@ out:
 	return err;
 }
 
+static int iboe_query_gid(struct ib_device *ibdev, u8 port, int index,
+			  union ib_gid *gid)
+{
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+
+	*gid = dev->iboe.gid_table[port - 1][index];
+
+	return 0;
+}
+
+static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
+			     union ib_gid *gid)
+{
+	if (rdma_port_link_layer(ibdev, port) == IB_LINK_LAYER_INFINIBAND)
+		return __mlx4_ib_query_gid(ibdev, port, index, gid);
+	else
+		return iboe_query_gid(ibdev, port, index, gid);
+}
+
 static int mlx4_ib_query_pkey(struct ib_device *ibdev, u8 port, u16 index,
 			      u16 *pkey)
 {
@@ -287,6 +432,7 @@ static int mlx4_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_viols,
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	int err;
+	u8 is_eth = dev->dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH;
 
 	mailbox = mlx4_alloc_cmd_mailbox(dev->dev);
 	if (IS_ERR(mailbox))
@@ -302,7 +448,7 @@ static int mlx4_SET_PORT(struct mlx4_ib_dev *dev, u8 port, int reset_qkey_viols,
 		((__be32 *) mailbox->buf)[1] = cpu_to_be32(cap_mask);
 	}
 
-	err = mlx4_cmd(dev->dev, mailbox->dma, port, 0, MLX4_CMD_SET_PORT,
+	err = mlx4_cmd(dev->dev, mailbox->dma, port, is_eth, MLX4_CMD_SET_PORT,
 		       MLX4_CMD_TIME_CLASS_B);
 
 	mlx4_free_cmd_mailbox(dev->dev, mailbox);
@@ -445,18 +591,131 @@ static int mlx4_ib_dealloc_pd(struct ib_pd *pd)
 	return 0;
 }
 
+static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
+{
+	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
+	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
+	struct gid_entry *ge;
+
+	ge = kzalloc(sizeof *ge, GFP_KERNEL);
+	if (!ge)
+		return -ENOMEM;
+
+	ge->gid = *gid;
+	if (mlx4_ib_add_mc(mdev, mqp, gid)) {
+		ge->port = mqp->port;
+		ge->added = 1;
+	}
+
+	mutex_lock(&mqp->mutex);
+	list_add_tail(&ge->list, &mqp->gid_list);
+	mutex_unlock(&mqp->mutex);
+
+	return 0;
+}
+
+int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
+		   union ib_gid *gid)
+{
+	u8 mac[6];
+	struct net_device *ndev;
+	int ret = 0;
+
+	if (!mqp->port)
+		return 0;
+
+	spin_lock(&mdev->iboe.lock);
+	ndev = mdev->iboe.netdevs[mqp->port - 1];
+	if (ndev)
+		dev_hold(ndev);
+	spin_unlock(&mdev->iboe.lock);
+	if (ndev) {
+		rdma_get_mcast_mac((struct in6_addr *)gid, mac);
+		rtnl_lock();
+		dev_mc_add(mdev->iboe.netdevs[mqp->port - 1], mac, 6, 0);
+		ret = 1;
+		rtnl_unlock();
+		dev_put(ndev);
+	}
+
+	return ret;
+}
+
 static int mlx4_ib_mcg_attach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	return mlx4_multicast_attach(to_mdev(ibqp->device)->dev,
-				     &to_mqp(ibqp)->mqp, gid->raw,
-				     !!(to_mqp(ibqp)->flags &
-					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK));
+	int err;
+	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
+	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
+
+	err = mlx4_multicast_attach(mdev->dev, &mqp->mqp, gid->raw, !!(mqp->flags &
+				    MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK));
+	if (err)
+		return err;
+
+	err = add_gid_entry(ibqp, gid);
+	if (err)
+		goto err_add;
+
+	return 0;
+
+err_add:
+	mlx4_multicast_detach(mdev->dev, &mqp->mqp, gid->raw);
+	return err;
+}
+
+struct gid_entry *find_gid_entry(struct mlx4_ib_qp *qp, u8 *raw)
+{
+	struct gid_entry *ge;
+	struct gid_entry *tmp;
+	struct gid_entry *ret = NULL;
+
+	list_for_each_entry_safe(ge, tmp, &qp->gid_list, list) {
+		if (!memcmp(raw, ge->gid.raw, 16)) {
+			ret = ge;
+			break;
+		}
+	}
+
+	return ret;
 }
 
 static int mlx4_ib_mcg_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	return mlx4_multicast_detach(to_mdev(ibqp->device)->dev,
-				     &to_mqp(ibqp)->mqp, gid->raw);
+	int err;
+	struct mlx4_ib_dev *mdev = to_mdev(ibqp->device);
+	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
+	u8 mac[6];
+	struct net_device *ndev;
+	struct gid_entry *ge;
+
+	err = mlx4_multicast_detach(mdev->dev,
+				    &mqp->mqp, gid->raw);
+	if (err)
+		return err;
+
+	mutex_lock(&mqp->mutex);
+	ge = find_gid_entry(mqp, gid->raw);
+	if (ge) {
+		spin_lock(&mdev->iboe.lock);
+		ndev = ge->added ? mdev->iboe.netdevs[ge->port - 1] : NULL;
+		if (ndev)
+			dev_hold(ndev);
+		spin_unlock(&mdev->iboe.lock);
+		rdma_get_mcast_mac((struct in6_addr *)gid, mac);
+		if (ndev) {
+			rtnl_lock();
+			dev_mc_delete(mdev->iboe.netdevs[ge->port - 1], mac, 6, 0);
+			rtnl_unlock();
+			dev_put(ndev);
+		}
+		list_del(&ge->list);
+		kfree(ge);
+	} else
+		printk(KERN_WARNING "could not find mgid entry\n");
+
+	mutex_unlock(&mqp->mutex);
+
+	return 0;
 }
 
 static int init_node_data(struct mlx4_ib_dev *dev)
@@ -541,15 +800,143 @@ static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_board_id
 };
 
+static void mlx4_addrconf_ifid_eui48(u8 *eui, struct net_device *dev)
+{
+	memcpy(eui, dev->dev_addr, 3);
+	memcpy(eui + 5, dev->dev_addr + 3, 3);
+	eui[3] = 0xFF;
+	eui[4] = 0xFE;
+	eui[0] ^= 2;
+}
+
+static void update_gids_task(struct work_struct *work)
+{
+	struct update_gid_work *gw = container_of(work, struct update_gid_work, work);
+	struct mlx4_cmd_mailbox *mailbox;
+	union ib_gid *gids;
+	int err;
+	struct mlx4_dev	*dev = gw->dev->dev;
+	struct ib_event event;
+
+	mailbox = mlx4_alloc_cmd_mailbox(dev);
+	if (IS_ERR(mailbox)) {
+		printk(KERN_WARNING "update gid table failed %ld\n", PTR_ERR(mailbox));
+		return;
+	}
+
+	gids = mailbox->buf;
+	memcpy(gids, gw->gids, sizeof gw->gids);
+
+	err = mlx4_cmd(dev, mailbox->dma, MLX4_SET_PORT_GID_TABLE << 8 | gw->port,
+		       1, MLX4_CMD_SET_PORT, MLX4_CMD_TIME_CLASS_B);
+	if (err)
+		printk(KERN_WARNING "set port command failed\n");
+	else {
+		memcpy(gw->dev->iboe.gid_table[gw->port - 1], gw->gids, sizeof gw->gids);
+		event.device = &gw->dev->ib_dev;
+		event.element.port_num = gw->port;
+		event.event    = IB_EVENT_LID_CHANGE;
+		ib_dispatch_event(&event);
+	}
+
+	mlx4_free_cmd_mailbox(dev, mailbox);
+	kfree(gw);
+}
+
+static int update_ipv6_gids(struct mlx4_ib_dev *dev, int port, int clear)
+{
+	struct net_device *ndev = dev->iboe.netdevs[port - 1];
+	struct update_gid_work *work;
+
+	work = kzalloc(sizeof *work, GFP_ATOMIC);
+	if (!work)
+		return -ENOMEM;
+
+	if (!clear) {
+		mlx4_addrconf_ifid_eui48(&work->gids[0].raw[8], ndev);
+		work->gids[0].global.subnet_prefix = cpu_to_be64(0xfe80000000000000LL);
+	}
+
+	INIT_WORK(&work->work, update_gids_task);
+	work->port = port;
+	work->dev = dev;
+	queue_work(wq, &work->work);
+
+	return 0;
+}
+
+static void handle_en_event(struct mlx4_ib_dev *dev, int port, unsigned long event)
+{
+	switch (event) {
+	case NETDEV_UP:
+		update_ipv6_gids(dev, port, 0);
+		break;
+
+	case NETDEV_DOWN:
+		update_ipv6_gids(dev, port, 1);
+		dev->iboe.netdevs[port - 1] = NULL;
+	}
+}
+
+static void netdev_added(struct mlx4_ib_dev *dev, int port)
+{
+	update_ipv6_gids(dev, port, 0);
+}
+
+static void netdev_removed(struct mlx4_ib_dev *dev, int port)
+{
+	update_ipv6_gids(dev, port, 1);
+}
+
+static int mlx4_ib_netdev_event(struct notifier_block *this, unsigned long event,
+				void *ptr)
+{
+	struct net_device *dev = ptr;
+	struct mlx4_ib_dev *ibdev;
+	struct net_device *oldnd;
+	struct mlx4_ib_iboe *iboe;
+	int port;
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return NOTIFY_DONE;
+
+	ibdev = container_of(this, struct mlx4_ib_dev, iboe.nb);
+	iboe = &ibdev->iboe;
+
+	spin_lock(&iboe->lock);
+	mlx4_foreach_ib_transport_port(port, ibdev->dev) {
+		oldnd = iboe->netdevs[port - 1];
+		iboe->netdevs[port - 1] = mlx4_get_prot_dev(ibdev->dev, MLX4_PROT_EN, port);
+		if (oldnd != iboe->netdevs[port - 1]) {
+			if (iboe->netdevs[port - 1])
+				netdev_added(ibdev, port);
+			else
+				netdev_removed(ibdev, port);
+		}
+	}
+
+	if (dev == iboe->netdevs[0])
+		handle_en_event(ibdev, 1, event);
+	else if (dev == iboe->netdevs[1])
+		handle_en_event(ibdev, 2, event);
+
+	spin_unlock(&iboe->lock);
+
+	return NOTIFY_DONE;
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
 	int num_ports = 0;
 	int i;
+	int err;
+	int port;
+	struct mlx4_ib_iboe *iboe;
 
 	printk_once(KERN_INFO "%s", mlx4_ib_version);
 
-	mlx4_foreach_port(i, dev, MLX4_PORT_TYPE_IB)
+	mlx4_foreach_ib_transport_port(i, dev)
 		num_ports++;
 
 	/* No point in registering a device with no ports... */
@@ -562,6 +949,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		return NULL;
 	}
 
+	iboe = &ibdev->iboe;
+
 	if (mlx4_pd_alloc(dev, &ibdev->priv_pdn))
 		goto err_dealloc;
 
@@ -606,10 +995,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 		(1ull << IB_USER_VERBS_CMD_CREATE_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_MODIFY_SRQ)		|
 		(1ull << IB_USER_VERBS_CMD_QUERY_SRQ)		|
-		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ);
+		(1ull << IB_USER_VERBS_CMD_DESTROY_SRQ)		|
+		(1ull << IB_USER_VERBS_CMD_GET_ETH_L2_ADDR);
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
+	ibdev->ib_dev.get_link_layer	= mlx4_ib_port_link_layer;
 	ibdev->ib_dev.query_gid		= mlx4_ib_query_gid;
 	ibdev->ib_dev.query_pkey	= mlx4_ib_query_pkey;
 	ibdev->ib_dev.modify_device	= mlx4_ib_modify_device;
@@ -653,6 +1044,11 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.map_phys_fmr	= mlx4_ib_map_phys_fmr;
 	ibdev->ib_dev.unmap_fmr		= mlx4_ib_unmap_fmr;
 	ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
+	ibdev->ib_dev.get_eth_l2_addr	= mlx4_ib_get_eth_l2_addr;
+
+	mlx4_foreach_ib_transport_port(port, dev)
+		iboe->netdevs[port - 1] = mlx4_get_prot_dev(dev, MLX4_PROT_EN, port);
+	spin_lock_init(&iboe->lock);
 
 	if (init_node_data(ibdev))
 		goto err_map;
@@ -666,16 +1062,28 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (mlx4_ib_mad_init(ibdev))
 		goto err_reg;
 
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE && !iboe->nb.notifier_call) {
+		iboe->nb.notifier_call = mlx4_ib_netdev_event;
+		err = register_netdevice_notifier(&iboe->nb);
+		if (err)
+			goto err_reg;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(mlx4_class_attributes); ++i) {
 		if (device_create_file(&ibdev->ib_dev.dev,
 				       mlx4_class_attributes[i]))
-			goto err_reg;
+			goto err_notif;
 	}
 
 	ibdev->ib_active = true;
 
 	return ibdev;
 
+err_notif:
+	if (unregister_netdevice_notifier(&ibdev->iboe.nb))
+		printk(KERN_WARNING "failure unregistering notifier\n");
+	flush_workqueue(wq);
+
 err_reg:
 	ib_unregister_device(&ibdev->ib_dev);
 
@@ -701,11 +1109,16 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 
 	mlx4_ib_mad_cleanup(ibdev);
 	ib_unregister_device(&ibdev->ib_dev);
+	if (ibdev->iboe.nb.notifier_call) {
+		if (unregister_netdevice_notifier(&ibdev->iboe.nb))
+			printk(KERN_WARNING "failure unregistering notifier\n");
+		ibdev->iboe.nb.notifier_call = NULL;
+	}
+	iounmap(ibdev->uar_map);
 
-	for (p = 1; p <= ibdev->num_ports; ++p)
+	mlx4_foreach_port(p, dev, MLX4_PORT_TYPE_IB)
 		mlx4_CLOSE_PORT(dev, p);
 
-	iounmap(ibdev->uar_map);
 	mlx4_uar_free(dev, &ibdev->priv_uar);
 	mlx4_pd_free(dev, ibdev->priv_pdn);
 	ib_dealloc_device(&ibdev->ib_dev);
@@ -747,17 +1160,31 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 static struct mlx4_interface mlx4_ib_interface = {
 	.add	= mlx4_ib_add,
 	.remove	= mlx4_ib_remove,
-	.event	= mlx4_ib_event
+	.event	= mlx4_ib_event,
+	.protocol	= MLX4_PROT_IB
 };
 
 static int __init mlx4_ib_init(void)
 {
-	return mlx4_register_interface(&mlx4_ib_interface);
+	int err;
+
+	wq = create_singlethread_workqueue("mlx4_ib");
+	if (!wq)
+		return -ENOMEM;
+
+	err = mlx4_register_interface(&mlx4_ib_interface);
+	if (err) {
+		destroy_workqueue(wq);
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit mlx4_ib_cleanup(void)
 {
 	mlx4_unregister_interface(&mlx4_ib_interface);
+	destroy_workqueue(wq);
 }
 
 module_init(mlx4_ib_init);
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 3486d76..8fc842b 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -112,6 +112,13 @@ enum mlx4_ib_qp_flags {
 	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
 };
 
+struct gid_entry {
+	struct list_head	list;
+	union ib_gid		gid;
+	int			added;
+	u8			port;
+};
+
 struct mlx4_ib_qp {
 	struct ib_qp		ibqp;
 	struct mlx4_qp		mqp;
@@ -138,6 +145,8 @@ struct mlx4_ib_qp {
 	u8			resp_depth;
 	u8			sq_no_prefetch;
 	u8			state;
+	int			mlx_type;
+	struct list_head	gid_list;
 };
 
 struct mlx4_ib_srq {
@@ -157,7 +166,14 @@ struct mlx4_ib_srq {
 
 struct mlx4_ib_ah {
 	struct ib_ah		ibah;
-	struct mlx4_av		av;
+	union mlx4_ext_av       av;
+};
+
+struct mlx4_ib_iboe {
+	spinlock_t		lock;
+	struct net_device      *netdevs[MLX4_MAX_PORTS];
+	struct notifier_block 	nb;
+	union ib_gid		gid_table[MLX4_MAX_PORTS][128];
 };
 
 struct mlx4_ib_dev {
@@ -176,6 +192,7 @@ struct mlx4_ib_dev {
 
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
+	struct mlx4_ib_iboe	iboe;
 };
 
 static inline struct mlx4_ib_dev *to_mdev(struct ib_device *ibdev)
@@ -314,9 +331,23 @@ int mlx4_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list, int npages,
 int mlx4_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx4_ib_fmr_dealloc(struct ib_fmr *fmr);
 
+int mlx4_ib_resolve_grh(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah_attr,
+			u8 *mac, int *is_mcast, u8 port);
+
+int mlx4_ib_get_eth_l2_addr(struct ib_device *device, u8 port, union ib_gid *gid,
+			    int sgid_idx, u8 *mac, u16 *vlan_id);
+
 static inline int mlx4_ib_ah_grh_present(struct mlx4_ib_ah *ah)
 {
-	return !!(ah->av.g_slid & 0x80);
+	u8 port = be32_to_cpu(ah->av.ib.port_pd) >> 24 & 3;
+
+	if (rdma_port_link_layer(ah->ibah.device, port) == IB_LINK_LAYER_ETHERNET)
+		return 1;
+
+	return !!(ah->av.ib.g_slid & 0x80);
 }
 
+int mlx4_ib_add_mc(struct mlx4_ib_dev *mdev, struct mlx4_ib_qp *mqp,
+		   union ib_gid *gid);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 2a97c96..6356532 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -32,6 +32,7 @@
  */
 
 #include <linux/log2.h>
+#include <linux/netdevice.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_pack.h>
@@ -47,17 +48,24 @@ enum {
 
 enum {
 	MLX4_IB_DEFAULT_SCHED_QUEUE	= 0x83,
-	MLX4_IB_DEFAULT_QP0_SCHED_QUEUE	= 0x3f
+	MLX4_IB_DEFAULT_QP0_SCHED_QUEUE	= 0x3f,
+	MLX4_IB_LINK_TYPE_IB		= 0,
+	MLX4_IB_LINK_TYPE_ETH		= 1
 };
 
 enum {
 	/*
 	 * Largest possible UD header: send with GRH and immediate data.
+	 * 4 bytes added to accommodate for eth header instead of lrh
 	 */
-	MLX4_IB_UD_HEADER_SIZE		= 72,
+	MLX4_IB_UD_HEADER_SIZE		= 76,
 	MLX4_IB_LSO_HEADER_SPARE	= 128,
 };
 
+enum {
+	MLX4_IBOE_ETHERTYPE = 0x8915
+};
+
 struct mlx4_ib_sqp {
 	struct mlx4_ib_qp	qp;
 	int			pkey_index;
@@ -459,6 +467,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 	mutex_init(&qp->mutex);
 	spin_lock_init(&qp->sq.lock);
 	spin_lock_init(&qp->rq.lock);
+	INIT_LIST_HEAD(&qp->gid_list);
 
 	qp->state	 = IB_QPS_RESET;
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
@@ -646,6 +655,16 @@ static void mlx4_ib_unlock_cqs(struct mlx4_ib_cq *send_cq, struct mlx4_ib_cq *re
 	}
 }
 
+static void del_gid_entries(struct mlx4_ib_qp *qp)
+{
+	struct gid_entry *ge, *tmp;
+
+	list_for_each_entry_safe(ge, tmp, &qp->gid_list, list) {
+		list_del(&ge->list);
+		kfree(ge);
+	}
+}
+
 static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 			      int is_user)
 {
@@ -692,6 +711,8 @@ static void destroy_qp_common(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp,
 		if (!qp->ibqp.srq)
 			mlx4_db_free(dev->dev, &qp->db);
 	}
+
+	del_gid_entries(qp);
 }
 
 struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
@@ -849,6 +870,12 @@ static void mlx4_set_sched(struct mlx4_qp_path *path, u8 port)
 static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 			 struct mlx4_qp_path *path, u8 port)
 {
+	int err;
+	int is_eth = rdma_port_link_layer(&dev->ib_dev, port) ==
+		IB_LINK_LAYER_ETHERNET ? 1 : 0;
+	u8 mac[6];
+	int is_mcast;
+
 	path->grh_mylmc     = ah->src_path_bits & 0x7f;
 	path->rlid	    = cpu_to_be16(ah->dlid);
 	if (ah->static_rate) {
@@ -879,9 +906,33 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 	path->sched_queue = MLX4_IB_DEFAULT_SCHED_QUEUE |
 		((port - 1) << 6) | ((ah->sl & 0xf) << 2);
 
+	if (is_eth) {
+		if (!(ah->ah_flags & IB_AH_GRH))
+			return -1;
+
+		err = mlx4_ib_resolve_grh(dev, ah, mac, &is_mcast, port);
+		if (err)
+			return err;
+
+		memcpy(path->dmac, mac, 6);
+		path->ackto = MLX4_IB_LINK_TYPE_ETH;
+		/* use index 0 into MAC table for IBoE */
+		path->grh_mylmc &= 0x80;
+	}
+
 	return 0;
 }
 
+static void update_mcg_macs(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
+{
+	struct gid_entry *ge, *tmp;
+
+	list_for_each_entry_safe(ge, tmp, &qp->gid_list, list) {
+		if (!ge->added && mlx4_ib_add_mc(dev, qp, &ge->gid))
+			ge->added = 1;
+	}
+}
+
 static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			       const struct ib_qp_attr *attr, int attr_mask,
 			       enum ib_qp_state cur_state, enum ib_qp_state new_state)
@@ -977,7 +1028,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_TIMEOUT) {
-		context->pri_path.ackto = attr->timeout << 3;
+		context->pri_path.ackto |= (attr->timeout << 3);
 		optpar |= MLX4_QP_OPTPAR_ACK_TIMEOUT;
 	}
 
@@ -1115,8 +1166,10 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 		qp->atomic_rd_en = attr->qp_access_flags;
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC)
 		qp->resp_depth = attr->max_dest_rd_atomic;
-	if (attr_mask & IB_QP_PORT)
+	if (attr_mask & IB_QP_PORT) {
 		qp->port = attr->port_num;
+		update_mcg_macs(dev, qp);
+	}
 	if (attr_mask & IB_QP_ALT_PATH)
 		qp->alt_port = attr->alt_port_num;
 
@@ -1223,43 +1276,60 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	int header_size;
 	int spc;
 	int i;
+	union ib_gid sgid;
+	int is_eth;
+	int is_grh;
+	int err;
 
 	send_size = 0;
 	for (i = 0; i < wr->num_sge; ++i)
 		send_size += wr->sg_list[i].length;
 
-	ib_ud_header_init(send_size, mlx4_ib_ah_grh_present(ah), &sqp->ud_header);
+	is_eth = rdma_port_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
+	is_grh = mlx4_ib_ah_grh_present(ah);
+	err = ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+				ah->av.ib.gid_index, &sgid);
+	if (err)
+		return err;
 
-	sqp->ud_header.lrh.service_level   =
-		be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 28;
-	sqp->ud_header.lrh.destination_lid = ah->av.dlid;
-	sqp->ud_header.lrh.source_lid      = cpu_to_be16(ah->av.g_slid & 0x7f);
-	if (mlx4_ib_ah_grh_present(ah)) {
+	ib_ud_header_init(send_size, !is_eth, is_eth, is_grh, 0, &sqp->ud_header);
+
+	if (!is_eth) {
+		sqp->ud_header.lrh.service_level =
+			be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 28;
+		sqp->ud_header.lrh.destination_lid = ah->av.ib.dlid;
+		sqp->ud_header.lrh.source_lid = cpu_to_be16(ah->av.ib.g_slid & 0x7f);
+	}
+
+	if (is_grh) {
 		sqp->ud_header.grh.traffic_class =
-			(be32_to_cpu(ah->av.sl_tclass_flowlabel) >> 20) & 0xff;
+			(be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 20) & 0xff;
 		sqp->ud_header.grh.flow_label    =
-			ah->av.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
-		sqp->ud_header.grh.hop_limit     = ah->av.hop_limit;
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.port_pd) >> 24,
-				  ah->av.gid_index, &sqp->ud_header.grh.source_gid);
+			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
+		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
+		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+				  ah->av.ib.gid_index, &sqp->ud_header.grh.source_gid);
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
-		       ah->av.dgid, 16);
+		       ah->av.ib.dgid, 16);
 	}
 
 	mlx->flags &= cpu_to_be32(MLX4_WQE_CTRL_CQ_UPDATE);
-	mlx->flags |= cpu_to_be32((!sqp->qp.ibqp.qp_num ? MLX4_WQE_MLX_VL15 : 0) |
-				  (sqp->ud_header.lrh.destination_lid ==
-				   IB_LID_PERMISSIVE ? MLX4_WQE_MLX_SLR : 0) |
-				  (sqp->ud_header.lrh.service_level << 8));
-	mlx->rlid   = sqp->ud_header.lrh.destination_lid;
+
+	if (!is_eth) {
+		mlx->flags |= cpu_to_be32((!sqp->qp.ibqp.qp_num ? MLX4_WQE_MLX_VL15 : 0) |
+					  (sqp->ud_header.lrh.destination_lid ==
+					   IB_LID_PERMISSIVE ? MLX4_WQE_MLX_SLR : 0) |
+					  (sqp->ud_header.lrh.service_level << 8));
+		mlx->rlid = sqp->ud_header.lrh.destination_lid;
+	}
 
 	switch (wr->opcode) {
 	case IB_WR_SEND:
-		sqp->ud_header.bth.opcode	 = IB_OPCODE_UD_SEND_ONLY;
+		sqp->ud_header.bth.opcode        = IB_OPCODE_UD_SEND_ONLY;
 		sqp->ud_header.immediate_present = 0;
 		break;
 	case IB_WR_SEND_WITH_IMM:
-		sqp->ud_header.bth.opcode	 = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
+		sqp->ud_header.bth.opcode        = IB_OPCODE_UD_SEND_ONLY_WITH_IMMEDIATE;
 		sqp->ud_header.immediate_present = 1;
 		sqp->ud_header.immediate_data    = wr->ex.imm_data;
 		break;
@@ -1267,9 +1337,20 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		return -EINVAL;
 	}
 
-	sqp->ud_header.lrh.virtual_lane    = !sqp->qp.ibqp.qp_num ? 15 : 0;
-	if (sqp->ud_header.lrh.destination_lid == IB_LID_PERMISSIVE)
-		sqp->ud_header.lrh.source_lid = IB_LID_PERMISSIVE;
+	if (is_eth) {
+		u8 *smac;
+
+		memcpy(sqp->ud_header.eth.dmac_h, ah->av.eth.mac_0_1, 6);
+		smac = to_mdev(sqp->qp.ibqp.device)->iboe.netdevs[sqp->qp.port - 1]->dev_addr; /* fixme: cache this value */
+		memcpy(sqp->ud_header.eth.smac_h, smac, 6);
+		if (!memcmp(sqp->ud_header.eth.smac_h, sqp->ud_header.eth.dmac_h, 6))
+			mlx->flags |= cpu_to_be32(MLX4_WQE_CTRL_FORCE_LOOPBACK);
+		sqp->ud_header.eth.type = cpu_to_be16(MLX4_IBOE_ETHERTYPE);
+	} else {
+		sqp->ud_header.lrh.virtual_lane    = !sqp->qp.ibqp.qp_num ? 15 : 0;
+		if (sqp->ud_header.lrh.destination_lid == IB_LID_PERMISSIVE)
+			sqp->ud_header.lrh.source_lid = IB_LID_PERMISSIVE;
+	}
 	sqp->ud_header.bth.solicited_event = !!(wr->send_flags & IB_SEND_SOLICITED);
 	if (!sqp->qp.ibqp.qp_num)
 		ib_get_cached_pkey(ib_dev, sqp->qp.port, sqp->pkey_index, &pkey);
@@ -1304,7 +1385,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	 * segments to hold the UD header.
 	 */
 	spc = MLX4_INLINE_ALIGN -
-		((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
+	      ((unsigned long) (inl + 1) & (MLX4_INLINE_ALIGN - 1));
 	if (header_size <= spc) {
 		inl->byte_count = cpu_to_be32(1 << 31 | header_size);
 		memcpy(inl + 1, sqp->header_buf, header_size);
@@ -1334,7 +1415,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	}
 
 	*mlx_seg_len =
-		ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
+	ALIGN(i * sizeof (struct mlx4_wqe_inline_seg) + header_size, 16);
 	return 0;
 }
 
@@ -1419,6 +1500,8 @@ static void set_datagram_seg(struct mlx4_wqe_datagram_seg *dseg,
 	memcpy(dseg->av, &to_mah(wr->wr.ud.ah)->av, sizeof (struct mlx4_av));
 	dseg->dqpn = cpu_to_be32(wr->wr.ud.remote_qpn);
 	dseg->qkey = cpu_to_be32(wr->wr.ud.remote_qkey);
+	dseg->vlan = to_mah(wr->wr.ud.ah)->av.eth.vlan;
+	memcpy(dseg->mac, to_mah(wr->wr.ud.ah)->av.eth.mac_0_1, 6);
 }
 
 static void set_mlx_icrc_seg(void *dseg)
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index c10576f..0070c50 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1494,7 +1494,9 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 	u16 pkey;
 
 	ib_ud_header_init(256, /* assume a MAD */
+			  1, 0,
 			  mthca_ah_grh_present(to_mah(wr->wr.ud.ah)),
+			  0,
 			  &sqp->ud_header);
 
 	err = mthca_read_ah(dev, to_mah(wr->wr.ud.ah), &sqp->ud_header);
diff --git a/drivers/net/mlx4/en_port.c b/drivers/net/mlx4/en_port.c
index a29abe8..a249887 100644
--- a/drivers/net/mlx4/en_port.c
+++ b/drivers/net/mlx4/en_port.c
@@ -127,8 +127,8 @@ int mlx4_SET_PORT_qpn_calc(struct mlx4_dev *dev, u8 port, u32 base_qpn,
 	memset(context, 0, sizeof *context);
 
 	context->base_qpn = cpu_to_be32(base_qpn);
-	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_SHIFT | base_qpn);
-	context->mcast = cpu_to_be32(1 << SET_PORT_PROMISC_SHIFT | base_qpn);
+	context->promisc = cpu_to_be32(promisc << SET_PORT_PROMISC_EN_SHIFT | base_qpn);
+	context->mcast = cpu_to_be32(1 << SET_PORT_PROMISC_MODE_SHIFT | base_qpn);
 	context->intra_no_vlan = 0;
 	context->no_vlan = MLX4_NO_VLAN_IDX;
 	context->intra_vlan_miss = 0;
diff --git a/drivers/net/mlx4/en_port.h b/drivers/net/mlx4/en_port.h
index e6477f1..9354891 100644
--- a/drivers/net/mlx4/en_port.h
+++ b/drivers/net/mlx4/en_port.h
@@ -36,7 +36,8 @@
 
 
 #define SET_PORT_GEN_ALL_VALID	0x7
-#define SET_PORT_PROMISC_SHIFT	31
+#define SET_PORT_PROMISC_EN_SHIFT	31
+#define SET_PORT_PROMISC_MODE_SHIFT	30
 
 enum {
 	MLX4_CMD_SET_VLAN_FLTR  = 0x47,
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 04f42ae..5b3593d 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -98,7 +98,8 @@ static void dump_dev_cap_flags(struct mlx4_dev *dev, u32 flags)
 		[20] = "Address vector port checking support",
 		[21] = "UD multicast support",
 		[24] = "Demand paging support",
-		[25] = "Router support"
+		[25] = "Router support",
+		[30] = "IBoE support"
 	};
 	int i;
 
diff --git a/include/linux/mlx4/cmd.h b/include/linux/mlx4/cmd.h
index 0f82293..22bd8d3 100644
--- a/include/linux/mlx4/cmd.h
+++ b/include/linux/mlx4/cmd.h
@@ -140,6 +140,7 @@ enum {
 	MLX4_SET_PORT_MAC_TABLE = 0x2,
 	MLX4_SET_PORT_VLAN_TABLE = 0x3,
 	MLX4_SET_PORT_PRIO_MAP  = 0x4,
+	MLX4_SET_PORT_GID_TABLE = 0x5,
 };
 
 struct mlx4_dev;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index e92d1bf..1653906 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -67,7 +67,8 @@ enum {
 	MLX4_DEV_CAP_FLAG_ATOMIC	= 1 << 18,
 	MLX4_DEV_CAP_FLAG_RAW_MCAST	= 1 << 19,
 	MLX4_DEV_CAP_FLAG_UD_AV_PORT	= 1 << 20,
-	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21
+	MLX4_DEV_CAP_FLAG_UD_MCAST	= 1 << 21,
+	MLX4_DEV_CAP_FLAG_IBOE		= 1 << 30
 };
 
 enum {
@@ -373,6 +374,28 @@ struct mlx4_av {
 	u8			dgid[16];
 };
 
+struct mlx4_eth_av {
+	__be32		port_pd;
+	u8		reserved1;
+	u8		smac_idx;
+	u16		reserved2;
+	u8		reserved3;
+	u8		gid_index;
+	u8		stat_rate;
+	u8		hop_limit;
+	__be32		sl_tclass_flowlabel;
+	u8		dgid[16];
+	u32		reserved4[2];
+	__be16		vlan;
+	u8		mac_0_1[2];
+	u8		mac_2_5[4];
+};
+
+union mlx4_ext_av {
+	struct mlx4_av		ib;
+	struct mlx4_eth_av	eth;
+};
+
 struct mlx4_dev {
 	struct pci_dev	       *pdev;
 	unsigned long		flags;
@@ -401,6 +424,12 @@ struct mlx4_init_port_param {
 		if (((type) == MLX4_PORT_TYPE_IB ? (dev)->caps.port_mask : \
 		     ~(dev)->caps.port_mask) & 1 << ((port) - 1))
 
+#define mlx4_foreach_ib_transport_port(port, dev)			\
+	for ((port) = 1; (port) <= (dev)->caps.num_ports; (port)++)	\
+		if (((dev)->caps.port_mask & 1 << ((port) - 1)) ||	\
+		    ((dev)->caps.flags & MLX4_DEV_CAP_FLAG_IBOE))
+
+
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 		   struct mlx4_buf *buf);
 void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf);
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index 9f29d86..3308f3c 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -112,7 +112,8 @@ struct mlx4_qp_path {
 	u8			snooper_flags;
 	u8			reserved3[2];
 	u8			counter_index;
-	u8			reserved4[7];
+	u8			reserved4;
+	u8			dmac[6];
 };
 
 struct mlx4_qp_context {
@@ -166,6 +167,7 @@ enum {
 	MLX4_WQE_CTRL_TCP_UDP_CSUM	= 1 << 5,
 	MLX4_WQE_CTRL_INS_VLAN		= 1 << 6,
 	MLX4_WQE_CTRL_STRONG_ORDER	= 1 << 7,
+	MLX4_WQE_CTRL_FORCE_LOOPBACK	= 1 << 0,
 };
 
 struct mlx4_wqe_ctrl_seg {
@@ -219,7 +221,8 @@ struct mlx4_wqe_datagram_seg {
 	__be32			av[8];
 	__be32			dqpn;
 	__be32			qkey;
-	__be32			reservd[2];
+	__be16			vlan;
+	u8			mac[6];
 };
 
 struct mlx4_wqe_lso_seg {
-- 
1.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
