From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next v2 07/10] IB/core: Use GID table in AH creation and dmac resolution
Date: Thu, 15 Oct 2015 18:38:51 +0300
Message-ID: <1444923534-10882-8-git-send-email-matanb@mellanox.com>
References: <1444923534-10882-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444923534-10882-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Previously, vlan id and source MAC were used from QP attributes. Since
the net device is now stored in the GID attributes, they could be used
instead of getting this information from the QP attributes.

IB_QP_SMAC, IB_QP_ALT_SMAC, IB_QP_VID and IB_QP_ALT_VID were removed
because there is no known libibverbs that uses them.

This commit also modifies the vendors (mlx4, ocrdma) drivers in order
to use the new approach.

ocrdma driver changes were done by Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c           |   3 +-
 drivers/infiniband/core/core_priv.h      |   4 +-
 drivers/infiniband/core/uverbs_cmd.c     |   2 +-
 drivers/infiniband/core/verbs.c          | 160 ++++++++++++++++++-------------
 drivers/infiniband/hw/mlx4/ah.c          |  17 +++-
 drivers/infiniband/hw/mlx4/mad.c         |  12 ++-
 drivers/infiniband/hw/mlx4/mcg.c         |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h     |   2 +-
 drivers/infiniband/hw/mlx4/qp.c          |  47 +++++++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c |  22 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c |  30 +++---
 include/rdma/ib_addr.h                   |   2 +-
 12 files changed, 193 insertions(+), 110 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 746cdf5..d3c42b3 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -458,7 +458,7 @@ static void resolve_cb(int status, struct sockaddr *src_addr,
 }
 
 int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
-			       u8 *dmac, u16 *vlan_id)
+			       u8 *dmac, u16 *vlan_id, int if_index)
 {
 	int ret = 0;
 	struct rdma_dev_addr dev_addr;
@@ -476,6 +476,7 @@ int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgi
 	rdma_gid2ip(&dgid_addr._sockaddr, dgid);
 
 	memset(&dev_addr, 0, sizeof(dev_addr));
+	dev_addr.bound_dev_if = if_index;
 
 	ctx.addr = &dev_addr;
 	init_completion(&ctx.comp);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 0df82b1..5cf6eb7 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -46,8 +46,8 @@ void ib_device_unregister_sysfs(struct ib_device *device);
 void ib_cache_setup(void);
 void ib_cache_cleanup(void);
 
-int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
-			    struct ib_qp_attr *qp_attr, int *qp_attr_mask);
+int ib_resolve_eth_dmac(struct ib_qp *qp,
+			struct ib_qp_attr *qp_attr, int *qp_attr_mask);
 
 typedef void (*roce_netdev_callback)(struct ib_device *device, u8 port,
 	      struct net_device *idev, void *cookie);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index be4cb9f..b242480 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2221,7 +2221,7 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
 	if (qp->real_qp == qp) {
-		ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
+		ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
 		if (ret)
 			goto release_qp;
 		ret = qp->device->modify_qp(qp, attr,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6012f5e..46d97f0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -41,6 +41,9 @@
 #include <linux/export.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <net/addrconf.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_cache.h>
@@ -308,6 +311,35 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_create_ah);
 
+struct find_gid_index_context {
+	u16 vlan_id;
+};
+
+static bool find_gid_index(const union ib_gid *gid,
+			   const struct ib_gid_attr *gid_attr,
+			   void *context)
+{
+	struct find_gid_index_context *ctx =
+		(struct find_gid_index_context *)context;
+
+	if ((!!(ctx->vlan_id != 0xffff) == !is_vlan_dev(gid_attr->ndev)) ||
+	    (is_vlan_dev(gid_attr->ndev) &&
+	     vlan_dev_vlan_id(gid_attr->ndev) != ctx->vlan_id))
+		return false;
+
+	return true;
+}
+
+static int get_sgid_index_from_eth(struct ib_device *device, u8 port_num,
+				   u16 vlan_id, const union ib_gid *sgid,
+				   u16 *gid_index)
+{
+	struct find_gid_index_context context = {.vlan_id = vlan_id};
+
+	return ib_find_gid_by_filter(device, sgid, port_num, find_gid_index,
+				     &context, gid_index);
+}
+
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
 		       struct ib_ah_attr *ah_attr)
@@ -318,21 +350,30 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 
 	memset(ah_attr, 0, sizeof *ah_attr);
 	if (rdma_cap_eth_ah(device, port_num)) {
+		u16 vlan_id = wc->wc_flags & IB_WC_WITH_VLAN ?
+				wc->vlan_id : 0xffff;
+
 		if (!(wc->wc_flags & IB_WC_GRH))
 			return -EPROTOTYPE;
 
-		if (wc->wc_flags & IB_WC_WITH_SMAC &&
-		    wc->wc_flags & IB_WC_WITH_VLAN) {
-			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
-			ah_attr->vlan_id = wc->vlan_id;
-		} else {
+		if (!(wc->wc_flags & IB_WC_WITH_SMAC) ||
+		    !(wc->wc_flags & IB_WC_WITH_VLAN)) {
 			ret = rdma_addr_find_dmac_by_grh(&grh->dgid, &grh->sgid,
-					ah_attr->dmac, &ah_attr->vlan_id);
+							 ah_attr->dmac,
+							 wc->wc_flags & IB_WC_WITH_VLAN ?
+							 NULL : &vlan_id,
+							 0);
 			if (ret)
 				return ret;
 		}
-	} else {
-		ah_attr->vlan_id = 0xffff;
+
+		ret = get_sgid_index_from_eth(device, port_num, vlan_id,
+					      &grh->dgid, &gid_index);
+		if (ret)
+			return ret;
+
+		if (wc->wc_flags & IB_WC_WITH_SMAC)
+			memcpy(ah_attr->dmac, wc->smac, ETH_ALEN);
 	}
 
 	ah_attr->dlid = wc->slid;
@@ -344,10 +385,13 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = grh->sgid;
 
-		ret = ib_find_cached_gid(device, &grh->dgid,
-					 NULL, &port_num, &gid_index);
-		if (ret)
-			return ret;
+		if (!rdma_cap_eth_ah(device, port_num)) {
+			ret = ib_find_cached_gid_by_port(device, &grh->dgid,
+							 port_num, NULL,
+							 &gid_index);
+			if (ret)
+				return ret;
+		}
 
 		ah_attr->grh.sgid_index = (u8) gid_index;
 		flow_class = be32_to_cpu(grh->version_tclass_flow);
@@ -617,9 +661,7 @@ EXPORT_SYMBOL(ib_create_qp);
 static const struct {
 	int			valid;
 	enum ib_qp_attr_mask	req_param[IB_QPT_MAX];
-	enum ib_qp_attr_mask	req_param_add_eth[IB_QPT_MAX];
 	enum ib_qp_attr_mask	opt_param[IB_QPT_MAX];
-	enum ib_qp_attr_mask	opt_param_add_eth[IB_QPT_MAX];
 } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
 	[IB_QPS_RESET] = {
 		[IB_QPS_RESET] = { .valid = 1 },
@@ -700,12 +742,6 @@ static const struct {
 						IB_QP_MAX_DEST_RD_ATOMIC	|
 						IB_QP_MIN_RNR_TIMER),
 			},
-			.req_param_add_eth = {
-				[IB_QPT_RC]  = (IB_QP_SMAC),
-				[IB_QPT_UC]  = (IB_QP_SMAC),
-				[IB_QPT_XRC_INI]  = (IB_QP_SMAC),
-				[IB_QPT_XRC_TGT]  = (IB_QP_SMAC)
-			},
 			.opt_param = {
 				 [IB_QPT_UD]  = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
@@ -726,21 +762,7 @@ static const struct {
 				 [IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
 						 IB_QP_QKEY),
 			 },
-			.opt_param_add_eth = {
-				[IB_QPT_RC]  = (IB_QP_ALT_SMAC			|
-						IB_QP_VID			|
-						IB_QP_ALT_VID),
-				[IB_QPT_UC]  = (IB_QP_ALT_SMAC			|
-						IB_QP_VID			|
-						IB_QP_ALT_VID),
-				[IB_QPT_XRC_INI]  = (IB_QP_ALT_SMAC			|
-						IB_QP_VID			|
-						IB_QP_ALT_VID),
-				[IB_QPT_XRC_TGT]  = (IB_QP_ALT_SMAC			|
-						IB_QP_VID			|
-						IB_QP_ALT_VID)
-			}
-		}
+		},
 	},
 	[IB_QPS_RTR]   = {
 		[IB_QPS_RESET] = { .valid = 1 },
@@ -962,13 +984,6 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 	req_param = qp_state_table[cur_state][next_state].req_param[type];
 	opt_param = qp_state_table[cur_state][next_state].opt_param[type];
 
-	if (ll == IB_LINK_LAYER_ETHERNET) {
-		req_param |= qp_state_table[cur_state][next_state].
-			req_param_add_eth[type];
-		opt_param |= qp_state_table[cur_state][next_state].
-			opt_param_add_eth[type];
-	}
-
 	if ((mask & req_param) != req_param)
 		return 0;
 
@@ -979,41 +994,52 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 }
 EXPORT_SYMBOL(ib_modify_qp_is_ok);
 
-int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
-			    struct ib_qp_attr *qp_attr, int *qp_attr_mask)
+int ib_resolve_eth_dmac(struct ib_qp *qp,
+			struct ib_qp_attr *qp_attr, int *qp_attr_mask)
 {
 	int           ret = 0;
-	union ib_gid  sgid;
 
-	if ((*qp_attr_mask & IB_QP_AV)  &&
-	    (rdma_cap_eth_ah(qp->device, qp_attr->ah_attr.port_num))) {
-		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
-				   qp_attr->ah_attr.grh.sgid_index, &sgid,
-				   NULL);
-		if (ret)
-			goto out;
+	if (*qp_attr_mask & IB_QP_AV) {
+		if (qp_attr->ah_attr.port_num < rdma_start_port(qp->device) ||
+		    qp_attr->ah_attr.port_num > rdma_end_port(qp->device))
+			return -EINVAL;
+
+		if (!rdma_cap_eth_ah(qp->device, qp_attr->ah_attr.port_num))
+			return 0;
+
 		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
-			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw, qp_attr->ah_attr.dmac);
-			rdma_get_ll_mac((struct in6_addr *)sgid.raw, qp_attr->smac);
-			if (!(*qp_attr_mask & IB_QP_VID))
-				qp_attr->vlan_id = rdma_get_vlan_id(&sgid);
+			rdma_get_ll_mac((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw,
+					qp_attr->ah_attr.dmac);
 		} else {
-			ret = rdma_addr_find_dmac_by_grh(&sgid, &qp_attr->ah_attr.grh.dgid,
-					qp_attr->ah_attr.dmac, &qp_attr->vlan_id);
-			if (ret)
-				goto out;
-			ret = rdma_addr_find_smac_by_sgid(&sgid, qp_attr->smac, NULL);
-			if (ret)
+			union ib_gid		sgid;
+			struct ib_gid_attr	sgid_attr;
+			int			ifindex;
+
+			ret = ib_query_gid(qp->device,
+					   qp_attr->ah_attr.port_num,
+					   qp_attr->ah_attr.grh.sgid_index,
+					   &sgid, &sgid_attr);
+
+			if (ret || !sgid_attr.ndev) {
+				if (!ret)
+					ret = -ENXIO;
 				goto out;
+			}
+
+			ifindex = sgid_attr.ndev->ifindex;
+
+			ret = rdma_addr_find_dmac_by_grh(&sgid,
+							 &qp_attr->ah_attr.grh.dgid,
+							 qp_attr->ah_attr.dmac,
+							 NULL, ifindex);
+
+			dev_put(sgid_attr.ndev);
 		}
-		*qp_attr_mask |= IB_QP_SMAC;
-		if (qp_attr->vlan_id < 0xFFFF)
-			*qp_attr_mask |= IB_QP_VID;
 	}
 out:
 	return ret;
 }
-EXPORT_SYMBOL(ib_resolve_eth_l2_attrs);
+EXPORT_SYMBOL(ib_resolve_eth_dmac);
 
 
 int ib_modify_qp(struct ib_qp *qp,
@@ -1022,7 +1048,7 @@ int ib_modify_qp(struct ib_qp *qp,
 {
 	int ret;
 
-	ret = ib_resolve_eth_l2_attrs(qp, qp_attr, &qp_attr_mask);
+	ret = ib_resolve_eth_dmac(qp, qp_attr, &qp_attr_mask);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 1688a17..86af713 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -76,7 +76,10 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	struct mlx4_dev *dev = ibdev->dev;
 	int is_mcast = 0;
 	struct in6_addr in6;
-	u16 vlan_tag;
+	u16 vlan_tag = 0xffff;
+	union ib_gid sgid;
+	struct ib_gid_attr gid_attr;
+	int ret;
 
 	memcpy(&in6, ah_attr->grh.dgid.raw, sizeof(in6));
 	if (rdma_is_multicast_addr(&in6)) {
@@ -85,7 +88,17 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	} else {
 		memcpy(ah->av.eth.mac, ah_attr->dmac, ETH_ALEN);
 	}
-	vlan_tag = ah_attr->vlan_id;
+	ret = ib_get_cached_gid(pd->device, ah_attr->port_num,
+				ah_attr->grh.sgid_index, &sgid, &gid_attr);
+	if (ret)
+		return ERR_PTR(ret);
+	memset(ah->av.eth.s_mac, 0, ETH_ALEN);
+	if (gid_attr.ndev) {
+		if (is_vlan_dev(gid_attr.ndev))
+			vlan_tag = vlan_dev_vlan_id(gid_attr.ndev);
+		memcpy(ah->av.eth.s_mac, gid_attr.ndev->dev_addr, ETH_ALEN);
+		dev_put(gid_attr.ndev);
+	}
 	if (vlan_tag < 0x1000)
 		vlan_tag |= (ah_attr->sl & 7) << 13;
 	ah->av.eth.port_pd = cpu_to_be32(to_mpd(pd)->pdn | (ah_attr->port_num << 24));
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1cd75ff..63aa1eb 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1172,7 +1172,7 @@ static int is_proxy_qp0(struct mlx4_ib_dev *dev, int qpn, int slave)
 int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index,
 			 u32 remote_qpn, u32 qkey, struct ib_ah_attr *attr,
-			 u8 *s_mac, struct ib_mad *mad)
+			 u8 *s_mac, u16 vlan_id, struct ib_mad *mad)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
@@ -1259,6 +1259,9 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	wr.send_flags = IB_SEND_SIGNALED;
 	if (s_mac)
 		memcpy(to_mah(ah)->av.eth.s_mac, s_mac, 6);
+	if (vlan_id < 0x1000)
+		vlan_id |= (attr->sl & 7) << 13;
+	to_mah(ah)->av.eth.vlan = cpu_to_be16(vlan_id);
 
 
 	ret = ib_post_send(send_qp, &wr, &bad_wr);
@@ -1295,6 +1298,7 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 	u8 *slave_id;
 	int slave;
 	int port;
+	u16 vlan_id;
 
 	/* Get slave that sent this packet */
 	if (wc->src_qp < dev->dev->phys_caps.base_proxy_sqpn ||
@@ -1383,10 +1387,10 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 		fill_in_real_sgid_index(dev, slave, ctx->port, &ah_attr);
 
 	memcpy(ah_attr.dmac, tunnel->hdr.mac, 6);
-	ah_attr.vlan_id = be16_to_cpu(tunnel->hdr.vlan);
+	vlan_id = be16_to_cpu(tunnel->hdr.vlan);
 	/* if slave have default vlan use it */
 	mlx4_get_slave_default_vlan(dev->dev, ctx->port, slave,
-				    &ah_attr.vlan_id, &ah_attr.sl);
+				    &vlan_id, &ah_attr.sl);
 
 	mlx4_ib_send_to_wire(dev, slave, ctx->port,
 			     is_proxy_qp0(dev, wc->src_qp, slave) ?
@@ -1394,7 +1398,7 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 			     be16_to_cpu(tunnel->hdr.pkey_index),
 			     be32_to_cpu(tunnel->hdr.remote_qpn),
 			     be32_to_cpu(tunnel->hdr.qkey),
-			     &ah_attr, wc->smac, &tunnel->mad);
+			     &ah_attr, wc->smac, vlan_id, &tunnel->mad);
 }
 
 static int mlx4_ib_alloc_pv_bufs(struct mlx4_ib_demux_pv_ctx *ctx,
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 2d5bccd..99451d8 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -222,7 +222,7 @@ static int send_mad_to_wire(struct mlx4_ib_demux_ctx *ctx, struct ib_mad *mad)
 	spin_unlock_irqrestore(&dev->sm_lock, flags);
 	return mlx4_ib_send_to_wire(dev, mlx4_master_func_num(dev->dev),
 				    ctx->port, IB_QPT_GSI, 0, 1, IB_QP1_QKEY,
-				    &ah_attr, NULL, mad);
+				    &ah_attr, NULL, 0xffff, mad);
 }
 
 static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 1e7b23b..331351d 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -813,7 +813,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index, u32 remote_qpn,
 			 u32 qkey, struct ib_ah_attr *attr, u8 *s_mac,
-			 struct ib_mad *mad);
+			 u16 vlan_id, struct ib_mad *mad);
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx);
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index bd3da49..71a4176 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1391,11 +1391,12 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_qp_attr *qp,
 			 enum ib_qp_attr_mask qp_attr_mask,
 			 struct mlx4_ib_qp *mqp,
-			 struct mlx4_qp_path *path, u8 port)
+			 struct mlx4_qp_path *path, u8 port,
+			 u16 vlan_id, u8 *smac)
 {
 	return _mlx4_set_path(dev, &qp->ah_attr,
-			      mlx4_mac_to_u64((u8 *)qp->smac),
-			      (qp_attr_mask & IB_QP_VID) ? qp->vlan_id : 0xffff,
+			      mlx4_mac_to_u64(smac),
+			      vlan_id,
 			      path, &mqp->pri, port);
 }
 
@@ -1406,9 +1407,8 @@ static int mlx4_set_alt_path(struct mlx4_ib_dev *dev,
 			     struct mlx4_qp_path *path, u8 port)
 {
 	return _mlx4_set_path(dev, &qp->alt_ah_attr,
-			      mlx4_mac_to_u64((u8 *)qp->alt_smac),
-			      (qp_attr_mask & IB_QP_ALT_VID) ?
-			      qp->alt_vlan_id : 0xffff,
+			      0,
+			      0xffff,
 			      path, &mqp->alt, port);
 }
 
@@ -1424,7 +1424,8 @@ static void update_mcg_macs(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp)
 	}
 }
 
-static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev, struct mlx4_ib_qp *qp, u8 *smac,
+static int handle_eth_ud_smac_index(struct mlx4_ib_dev *dev,
+				    struct mlx4_ib_qp *qp,
 				    struct mlx4_qp_context *context)
 {
 	u64 u64_mac;
@@ -1565,9 +1566,33 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 	}
 
 	if (attr_mask & IB_QP_AV) {
+		u8 port_num = mlx4_is_bonded(to_mdev(ibqp->device)->dev) ? 1 :
+			attr_mask & IB_QP_PORT ? attr->port_num : qp->port;
+		union ib_gid gid;
+		struct ib_gid_attr gid_attr;
+		u16 vlan = 0xffff;
+		u8 smac[ETH_ALEN];
+		int status = 0;
+
+		if (rdma_cap_eth_ah(&dev->ib_dev, port_num) &&
+		    attr->ah_attr.ah_flags & IB_AH_GRH) {
+			int index = attr->ah_attr.grh.sgid_index;
+
+			status = ib_get_cached_gid(ibqp->device, port_num,
+						   index, &gid, &gid_attr);
+			if (!status && !memcmp(&gid, &zgid, sizeof(gid)))
+				status = -ENOENT;
+			if (!status && gid_attr.ndev) {
+				vlan = rdma_vlan_dev_vlan_id(gid_attr.ndev);
+				memcpy(smac, gid_attr.ndev->dev_addr, ETH_ALEN);
+				dev_put(gid_attr.ndev);
+			}
+		}
+		if (status)
+			goto out;
+
 		if (mlx4_set_path(dev, attr, attr_mask, qp, &context->pri_path,
-				  attr_mask & IB_QP_PORT ?
-				  attr->port_num : qp->port))
+				  port_num, vlan, smac))
 			goto out;
 
 		optpar |= (MLX4_QP_OPTPAR_PRIMARY_ADDR_PATH |
@@ -1704,7 +1729,7 @@ static int __mlx4_ib_modify_qp(struct ib_qp *ibqp,
 			if (qp->mlx4_ib_qp_type == MLX4_IB_QPT_UD ||
 			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_PROXY_GSI ||
 			    qp->mlx4_ib_qp_type == MLX4_IB_QPT_TUN_GSI) {
-				err = handle_eth_ud_smac_index(dev, qp, (u8 *)attr->smac, context);
+				err = handle_eth_ud_smac_index(dev, qp, context);
 				if (err) {
 					err = -EINVAL;
 					goto out;
@@ -2199,6 +2224,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 						be32_to_cpu(ah->av.ib.port_pd) >> 24,
 						ah->av.ib.gid_index, &sgid,
 						NULL);
+			if (!err && !memcmp(&sgid, &zgid, sizeof(sgid)))
+				err = -ENOENT;
 			if (err)
 				return err;
 		}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 44766fe..9820074 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -45,6 +45,7 @@
 
 #include <rdma/ib_addr.h>
 #include <rdma/ib_mad.h>
+#include <rdma/ib_cache.h>
 
 #include "ocrdma.h"
 #include "ocrdma_verbs.h"
@@ -56,10 +57,9 @@
 
 static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 			struct ib_ah_attr *attr, union ib_gid *sgid,
-			int pdid, bool *isvlan)
+			int pdid, bool *isvlan, u16 vlan_tag)
 {
 	int status = 0;
-	u16 vlan_tag;
 	struct ocrdma_eth_vlan eth;
 	struct ocrdma_grh grh;
 	int eth_sz;
@@ -68,7 +68,6 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	memset(&grh, 0, sizeof(grh));
 
 	/* VLAN */
-	vlan_tag = attr->vlan_id;
 	if (!vlan_tag || (vlan_tag > 0xFFF))
 		vlan_tag = dev->pvid;
 	if (vlan_tag || dev->pfc_state) {
@@ -115,9 +114,11 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 {
 	u32 *ahid_addr;
-	bool isvlan = false;
 	int status;
 	struct ocrdma_ah *ah;
+	bool isvlan = false;
+	u16 vlan_tag = 0xffff;
+	struct ib_gid_attr sgid_attr;
 	struct ocrdma_pd *pd = get_ocrdma_pd(ibpd);
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibpd->device);
 	union ib_gid sgid;
@@ -135,18 +136,25 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 	if (status)
 		goto av_err;
 
-	status = ocrdma_query_gid(&dev->ibdev, 1, attr->grh.sgid_index, &sgid);
+	status = ib_get_cached_gid(&dev->ibdev, 1, attr->grh.sgid_index, &sgid,
+				   &sgid_attr);
 	if (status) {
 		pr_err("%s(): Failed to query sgid, status = %d\n",
 		      __func__, status);
 		goto av_conf_err;
 	}
+	if (sgid_attr.ndev) {
+		if (is_vlan_dev(sgid_attr.ndev))
+			vlan_tag = vlan_dev_vlan_id(sgid_attr.ndev);
+		dev_put(sgid_attr.ndev);
+	}
 
 	if ((pd->uctx) &&
 	    (!rdma_is_multicast_addr((struct in6_addr *)attr->grh.dgid.raw)) &&
 	    (!rdma_link_local_addr((struct in6_addr *)attr->grh.dgid.raw))) {
 		status = rdma_addr_find_dmac_by_grh(&sgid, &attr->grh.dgid,
-                                        attr->dmac, &attr->vlan_id);
+						    attr->dmac, &vlan_tag,
+						    sgid_attr.ndev->ifindex);
 		if (status) {
 			pr_err("%s(): Failed to resolve dmac from gid." 
 				"status = %d\n", __func__, status);
@@ -154,7 +162,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 		}
 	}
 
-	status = set_av_attr(dev, ah, attr, &sgid, pd->id, &isvlan);
+	status = set_av_attr(dev, ah, attr, &sgid, pd->id, &isvlan, vlan_tag);
 	if (status)
 		goto av_conf_err;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aab391a..a7890b1 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -47,6 +47,7 @@
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_cache.h>
 
 #include "ocrdma.h"
 #include "ocrdma_hw.h"
@@ -2448,6 +2449,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	int status;
 	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
 	union ib_gid sgid, zgid;
+	struct ib_gid_attr sgid_attr;
 	u32 vlan_id = 0xFFFF;
 	u8 mac_addr[6];
 	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
@@ -2466,10 +2468,14 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	cmd->flags |= OCRDMA_QP_PARA_FLOW_LBL_VALID;
 	memcpy(&cmd->params.dgid[0], &ah_attr->grh.dgid.raw[0],
 	       sizeof(cmd->params.dgid));
-	status = ocrdma_query_gid(&dev->ibdev, 1,
-			ah_attr->grh.sgid_index, &sgid);
-	if (status)
-		return status;
+
+	status = ib_get_cached_gid(&dev->ibdev, 1, ah_attr->grh.sgid_index,
+				   &sgid, &sgid_attr);
+	if (!status && sgid_attr.ndev) {
+		vlan_id = rdma_vlan_dev_vlan_id(sgid_attr.ndev);
+		memcpy(mac_addr, sgid_attr.ndev->dev_addr, ETH_ALEN);
+		dev_put(sgid_attr.ndev);
+	}
 
 	memset(&zgid, 0, sizeof(zgid));
 	if (!memcmp(&sgid, &zgid, sizeof(zgid)))
@@ -2486,17 +2492,15 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 	ocrdma_cpu_to_le32(&cmd->params.dgid[0], sizeof(cmd->params.dgid));
 	ocrdma_cpu_to_le32(&cmd->params.sgid[0], sizeof(cmd->params.sgid));
 	cmd->params.vlan_dmac_b4_to_b5 = mac_addr[4] | (mac_addr[5] << 8);
-	if (attr_mask & IB_QP_VID) {
-		vlan_id = attrs->vlan_id;
-	} else if (dev->pfc_state) {
-		vlan_id = 0;
-		pr_err("ocrdma%d:Using VLAN with PFC is recommended\n",
-			dev->id);
-		pr_err("ocrdma%d:Using VLAN 0 for this connection\n",
-			dev->id);
-	}
 
 	if (vlan_id < 0x1000) {
+		if (dev->pfc_state) {
+			vlan_id = 0;
+			pr_err("ocrdma%d:Using VLAN with PFC is recommended\n",
+			       dev->id);
+			pr_err("ocrdma%d:Using VLAN 0 for this connection\n",
+			       dev->id);
+		}
 		cmd->params.vlan_dmac_b4_to_b5 |=
 		    vlan_id << OCRDMA_QP_PARAMS_VLAN_SHIFT;
 		cmd->flags |= OCRDMA_QP_PARA_VLAN_EN_VALID;
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index fde33ac..17e4a8b 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -112,7 +112,7 @@ int rdma_addr_size(struct sockaddr *addr);
 
 int rdma_addr_find_smac_by_sgid(union ib_gid *sgid, u8 *smac, u16 *vlan_id);
 int rdma_addr_find_dmac_by_grh(const union ib_gid *sgid, const union ib_gid *dgid,
-			       u8 *smac, u16 *vlan_id);
+			       u8 *smac, u16 *vlan_id, int if_index);
 
 static inline u16 ib_addr_get_pkey(struct rdma_dev_addr *dev_addr)
 {
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
