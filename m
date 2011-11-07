From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 02/11] Get rid of caching function usage
Date: Mon, 7 Nov 2011 14:18:48 +0530
Message-ID: <20111107084844.GA11459@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove all old caching functions.

Note: Since lmc cache could not be removed, in_query_lmc() has been
added which performs a regular query and extracts the lmc and returns
it.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/infiniband/core/cm.c           |    6 +++---
 drivers/infiniband/core/cma.c          |    6 +++---
 drivers/infiniband/core/device.c       |   23 +++++++++++++++++++++++
 drivers/infiniband/core/mad.c          |    4 ++--
 drivers/infiniband/core/multicast.c    |    2 +-
 drivers/infiniband/core/sa_query.c     |    2 +-
 drivers/infiniband/core/verbs.c        |    2 +-
 drivers/infiniband/hw/mlx4/ah.c        |    2 +-
 drivers/infiniband/hw/mlx4/qp.c        |    8 ++++----
 drivers/infiniband/hw/mthca/mthca_av.c |    2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c |    4 ++--
 include/rdma/ib_verbs.h                |    3 +++
 12 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 8b72f39..c7a5358 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -356,7 +356,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
-		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
+		if (!ib_find_gid(cm_dev->ib_device, &path->sgid,
 					&p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
@@ -367,7 +367,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	if (!port)
 		return -EINVAL;
 
-	ret = ib_find_cached_pkey(cm_dev->ib_device, port->port_num,
+	ret = ib_find_pkey(cm_dev->ib_device, port->port_num,
 				  be16_to_cpu(path->pkey), &av->pkey_index);
 	if (ret)
 		return ret;
@@ -1558,7 +1558,7 @@ static int cm_req_handler(struct cm_work *work)
 	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
-		ib_get_cached_gid(work->port->cm_dev->ib_device,
+		ib_query_gid(work->port->cm_dev->ib_device,
 				  work->port->port_num, 0, &work->path[0].sgid);
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 75ff821..bcfa1ca 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -615,7 +615,7 @@ static int cma_ib_init_qp_attr(struct rdma_id_private *id_priv,
 	else
 		pkey = 0xffff;
 
-	ret = ib_find_cached_pkey(id_priv->id.device, id_priv->id.port_num,
+	ret = ib_find_pkey(id_priv->id.device, id_priv->id.port_num,
 				  pkey, &qp_attr->pkey_index);
 	if (ret)
 		return ret;
@@ -1921,11 +1921,11 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	cma_dev = list_entry(dev_list.next, struct cma_device, list);
 
 port_found:
-	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid);
+	ret = ib_query_gid(cma_dev->device, p, 0, &gid);
 	if (ret)
 		goto out;
 
-	ret = ib_get_cached_pkey(cma_dev->device, p, 0, &pkey);
+	ret = ib_query_pkey(cma_dev->device, p, 0, &pkey);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index e711de4..5ea7652 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -582,6 +582,29 @@ int ib_query_port(struct ib_device *device,
 }
 EXPORT_SYMBOL(ib_query_port);
 
+
+/**
+ * ib_query_lmc - Get the lmc
+ * @device:Device to query
+ * @port_num:Port number to query
+ * @lmc: return lmc
+ *
+ * ib_query_gid() fetches the specified GID table entry.
+ */
+int ib_query_lmc(struct ib_device *device,
+		 u8 port_num,
+		 u8 *lmc)
+{
+	struct ib_port_attr	attr;
+	int			ret;
+	ret = ib_query_port(device, port_num, &attr);
+	if (ret)
+		return ret;
+	*lmc = attr.lmc;
+	return 0;
+}
+EXPORT_SYMBOL(ib_query_lmc);
+
 /**
  * ib_query_gid - Get GID table entry
  * @device:Device to query
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 2fe428b..a83ba4c 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1718,13 +1718,13 @@ static inline int rcv_has_same_gid(struct ib_mad_agent_private *mad_agent_priv,
 	if (!send_resp && rcv_resp) {
 		/* is request/response. */
 		if (!(attr.ah_flags & IB_AH_GRH)) {
-			if (ib_get_cached_lmc(device, port_num, &lmc))
+			if (ib_query_lmc(device, port_num, &lmc))
 				return 0;
 			return (!lmc || !((attr.src_path_bits ^
 					   rwc->wc->dlid_path_bits) &
 					  ((1 << lmc) - 1)));
 		} else {
-			if (ib_get_cached_gid(device, port_num,
+			if (ib_query_gid(device, port_num,
 					      attr.grh.sgid_index, &sgid))
 				return 0;
 			return !memcmp(sgid.raw, rwc->recv_buf.grh->dgid.raw,
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index d2360a8..56f50dd 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -724,7 +724,7 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, &p, &gid_index);
+	ret = ib_find_gid(device, &rec->port_gid, &p, &gid_index);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index fbbfa24..0462f2e 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -512,7 +512,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, &port_num,
+		ret = ib_find_gid(device, &rec->sgid, &port_num,
 					 &gid_index);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 602b1bd..9001dc3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -200,7 +200,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num, struct ib_wc *wc,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = grh->sgid;
 
-		ret = ib_find_cached_gid(device, &grh->dgid, &port_num,
+		ret = ib_find_gid(device, &grh->dgid, &port_num,
 					 &gid_index);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 4b8f9c4..cebb3da 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -103,7 +103,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 		return ERR_PTR(err);
 
 	memcpy(ah->av.eth.mac, mac, 6);
-	err = ib_get_cached_gid(pd->device, ah_attr->port_num, ah_attr->grh.sgid_index, &sgid);
+	err = ib_query_gid(pd->device, ah_attr->port_num, ah_attr->grh.sgid_index, &sgid);
 	if (err)
 		return ERR_PTR(err);
 	vlan_tag = rdma_get_vlan_id(&sgid);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index a16f0c8..b2b1939 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1372,7 +1372,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	is_eth = rdma_port_get_link_layer(sqp->qp.ibqp.device, sqp->qp.port) == IB_LINK_LAYER_ETHERNET;
 	is_grh = mlx4_ib_ah_grh_present(ah);
 	if (is_eth) {
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+		ib_query_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
 				  ah->av.ib.gid_index, &sgid);
 		vlan = rdma_get_vlan_id(&sgid);
 		is_vlan = vlan < 0x1000;
@@ -1392,7 +1392,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		sqp->ud_header.grh.flow_label    =
 			ah->av.ib.sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		sqp->ud_header.grh.hop_limit     = ah->av.ib.hop_limit;
-		ib_get_cached_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
+		ib_query_gid(ib_dev, be32_to_cpu(ah->av.ib.port_pd) >> 24,
 				  ah->av.ib.gid_index, &sqp->ud_header.grh.source_gid);
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
@@ -1447,9 +1447,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	}
 	sqp->ud_header.bth.solicited_event = !!(wr->send_flags & IB_SEND_SOLICITED);
 	if (!sqp->qp.ibqp.qp_num)
-		ib_get_cached_pkey(ib_dev, sqp->qp.port, sqp->pkey_index, &pkey);
+		ib_query_pkey(ib_dev, sqp->qp.port, sqp->pkey_index, &pkey);
 	else
-		ib_get_cached_pkey(ib_dev, sqp->qp.port, wr->wr.ud.pkey_index, &pkey);
+		ib_query_pkey(ib_dev, sqp->qp.port, wr->wr.ud.pkey_index, &pkey);
 	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
 	sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->wr.ud.remote_qpn);
 	sqp->ud_header.bth.psn = cpu_to_be32((sqp->send_psn++) & ((1 << 24) - 1));
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 32f6c63..6249b5f 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -278,7 +278,7 @@ int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 		header->grh.flow_label    =
 			ah->av->sl_tclass_flowlabel & cpu_to_be32(0xfffff);
 		header->grh.hop_limit     = ah->av->hop_limit;
-		ib_get_cached_gid(&dev->ib_dev,
+		ib_query_gid(&dev->ib_dev,
 				  be32_to_cpu(ah->av->port_pd) >> 24,
 				  ah->av->gid_index % dev->limits.gid_table_len,
 				  &header->grh.source_gid);
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 9601049..b40429f 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1515,10 +1515,10 @@ static int build_mlx_header(struct mthca_dev *dev, struct mthca_sqp *sqp,
 		sqp->ud_header.lrh.source_lid = IB_LID_PERMISSIVE;
 	sqp->ud_header.bth.solicited_event = !!(wr->send_flags & IB_SEND_SOLICITED);
 	if (!sqp->qp.ibqp.qp_num)
-		ib_get_cached_pkey(&dev->ib_dev, sqp->qp.port,
+		ib_query_pkey(&dev->ib_dev, sqp->qp.port,
 				   sqp->pkey_index, &pkey);
 	else
-		ib_get_cached_pkey(&dev->ib_dev, sqp->qp.port,
+		ib_query_pkey(&dev->ib_dev, sqp->qp.port,
 				   wr->wr.ud.pkey_index, &pkey);
 	sqp->ud_header.bth.pkey = cpu_to_be16(pkey);
 	sqp->ud_header.bth.destination_qpn = cpu_to_be32(wr->wr.ud.remote_qpn);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bf5daaf..a6cf9f4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1308,6 +1308,9 @@ int ib_query_port(struct ib_device *device,
 enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 					       u8 port_num);
 
+int ib_query_lmc(struct ib_device *device,
+		 u8 port_num, u8 *lmc);
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
1.7.6


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
