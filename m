From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 01/10] IB/core: Add netdev and gid attributes paramteres to cache
Date: Fri,  7 Aug 2015 16:00:54 +0300
Message-ID: <1438952463-23707-2-git-send-email-matanb@mellanox.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438952463-23707-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding an ability to query the IB cache by a netdev and get the
attributes of a GID. These parameters are necessary in order to
successfully resolve the required GID (when the netdevice is known)
and get the Ethernet L2 attributes from a GID.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cache.c                | 10 ++++++----
 drivers/infiniband/core/cm.c                   |  5 +++--
 drivers/infiniband/core/cma.c                  | 10 ++++++----
 drivers/infiniband/core/device.c               | 17 ++++++++++++-----
 drivers/infiniband/core/mad.c                  |  2 +-
 drivers/infiniband/core/multicast.c            |  3 ++-
 drivers/infiniband/core/sa_query.c             |  2 +-
 drivers/infiniband/core/sysfs.c                |  2 +-
 drivers/infiniband/core/verbs.c                |  7 ++++---
 drivers/infiniband/hw/mlx4/main.c              |  4 ++--
 drivers/infiniband/hw/mlx4/qp.c                |  5 +++--
 drivers/infiniband/hw/mthca/mthca_av.c         |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |  3 ++-
 include/rdma/ib_cache.h                        | 13 +++++++++----
 include/rdma/ib_verbs.h                        |  5 +++--
 19 files changed, 60 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index ba3720c..78fe196 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -647,21 +647,23 @@ static int gid_table_setup_one(struct ib_device *ib_dev)
 int ib_get_cached_gid(struct ib_device *device,
 		      u8                port_num,
 		      int               index,
-		      union ib_gid     *gid)
+		      union ib_gid     *gid,
+		      struct ib_gid_attr *gid_attr)
 {
 	if (port_num < rdma_start_port(device) || port_num > rdma_end_port(device))
 		return -EINVAL;
 
-	return __ib_cache_gid_get(device, port_num, index, gid, NULL);
+	return __ib_cache_gid_get(device, port_num, index, gid, gid_attr);
 }
 EXPORT_SYMBOL(ib_get_cached_gid);
 
 int ib_find_cached_gid(struct ib_device *device,
 		       const union ib_gid *gid,
+		       struct net_device *ndev,
 		       u8               *port_num,
 		       u16              *index)
 {
-	return ib_cache_gid_find(device, gid, NULL, port_num, index);
+	return ib_cache_gid_find(device, gid, ndev, port_num, index);
 }
 EXPORT_SYMBOL(ib_find_cached_gid);
 
@@ -843,7 +845,7 @@ static void ib_cache_update(struct ib_device *device,
 	if (!use_roce_gid_table) {
 		for (i = 0;  i < gid_cache->table_len; ++i) {
 			ret = ib_query_gid(device, port, i,
-					   gid_cache->table + i);
+					   gid_cache->table + i, NULL);
 			if (ret) {
 				printk(KERN_WARNING "ib_query_gid failed (%d) for %s (index %d)\n",
 				       ret, device->name, i);
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3a972eb..5fdbc55 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -363,7 +363,7 @@ static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 	read_lock_irqsave(&cm.device_lock, flags);
 	list_for_each_entry(cm_dev, &cm.device_list, list) {
 		if (!ib_find_cached_gid(cm_dev->ib_device, &path->sgid,
-					&p, NULL)) {
+					NULL, &p, NULL)) {
 			port = cm_dev->port[p-1];
 			break;
 		}
@@ -1579,7 +1579,8 @@ static int cm_req_handler(struct cm_work *work)
 	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
 	if (ret) {
 		ib_get_cached_gid(work->port->cm_dev->ib_device,
-				  work->port->port_num, 0, &work->path[0].sgid);
+				  work->port->port_num, 0, &work->path[0].sgid,
+				  NULL);
 		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
 			       &work->path[0].sgid, sizeof work->path[0].sgid,
 			       NULL, 0);
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 143ded2..131f658 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -389,7 +389,7 @@ static inline int cma_validate_port(struct ib_device *device, u8 port,
 	if ((dev_type != ARPHRD_INFINIBAND) && rdma_protocol_ib(device, port))
 		return ret;
 
-	ret = ib_find_cached_gid(device, gid, &found_port, NULL);
+	ret = ib_find_cached_gid(device, gid, NULL, &found_port, NULL);
 	if (port != found_port)
 		return -ENODEV;
 
@@ -482,7 +482,9 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 			if (ib_find_cached_pkey(cur_dev->device, p, pkey, &index))
 				continue;
 
-			for (i = 0; !ib_get_cached_gid(cur_dev->device, p, i, &gid); i++) {
+			for (i = 0; !ib_get_cached_gid(cur_dev->device, p, i,
+						       &gid, NULL);
+			     i++) {
 				if (!memcmp(&gid, dgid, sizeof(gid))) {
 					cma_dev = cur_dev;
 					sgid = gid;
@@ -669,7 +671,7 @@ static int cma_modify_qp_rtr(struct rdma_id_private *id_priv,
 		goto out;
 
 	ret = ib_query_gid(id_priv->id.device, id_priv->id.port_num,
-			   qp_attr.ah_attr.grh.sgid_index, &sgid);
+			   qp_attr.ah_attr.grh.sgid_index, &sgid, NULL);
 	if (ret)
 		goto out;
 
@@ -2076,7 +2078,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	p = 1;
 
 port_found:
-	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid);
+	ret = ib_get_cached_gid(cma_dev->device, p, 0, &gid, NULL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 853e3d2..6fe360a 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -640,14 +640,20 @@ EXPORT_SYMBOL(ib_query_port);
  * @port_num:Port number to query
  * @index:GID table index to query
  * @gid:Returned GID
+ * @attr: Returned GID attributes related to this GID index (only in RoCE).
+ *   NULL means ignore.
  *
  * ib_query_gid() fetches the specified GID table entry.
  */
 int ib_query_gid(struct ib_device *device,
-		 u8 port_num, int index, union ib_gid *gid)
+		 u8 port_num, int index, union ib_gid *gid,
+		 struct ib_gid_attr *attr)
 {
 	if (rdma_cap_roce_gid_table(device, port_num))
-		return ib_get_cached_gid(device, port_num, index, gid);
+		return ib_get_cached_gid(device, port_num, index, gid, attr);
+
+	if (attr)
+		return -EINVAL;
 
 	return device->query_gid(device, port_num, index, gid);
 }
@@ -787,12 +793,13 @@ EXPORT_SYMBOL(ib_modify_port);
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @ndev: The ndev related to the GID to search for.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the GID table where the GID was found.  This
  *   parameter may be NULL.
  */
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index)
+		struct net_device *ndev, u8 *port_num, u16 *index)
 {
 	union ib_gid tmp_gid;
 	int ret, port, i;
@@ -800,13 +807,13 @@ int ib_find_gid(struct ib_device *device, union ib_gid *gid,
 	for (port = rdma_start_port(device); port <= rdma_end_port(device); ++port) {
 		if (rdma_cap_roce_gid_table(device, port)) {
 			if (!ib_cache_gid_find_by_port(device, gid, port,
-						       NULL, index))
+						       ndev, index))
 				*port_num = port;
 				return 0;
 		}
 
 		for (i = 0; i < device->port_immutable[port].gid_tbl_len; ++i) {
-			ret = ib_query_gid(device, port, i, &tmp_gid);
+			ret = ib_query_gid(device, port, i, &tmp_gid, NULL);
 			if (ret)
 				return ret;
 			if (!memcmp(&tmp_gid, gid, sizeof *gid)) {
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 786fc51..07f3022 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1887,7 +1887,7 @@ static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_
 					  ((1 << lmc) - 1)));
 		} else {
 			if (ib_get_cached_gid(device, port_num,
-					      attr.grh.sgid_index, &sgid))
+					      attr.grh.sgid_index, &sgid, NULL))
 				return 0;
 			return !memcmp(sgid.raw, rwc->recv_buf.grh->dgid.raw,
 				       16);
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 2cb865c..dc611fe 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -729,7 +729,8 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 	u16 gid_index;
 	u8 p;
 
-	ret = ib_find_cached_gid(device, &rec->port_gid, &p, &gid_index);
+	ret = ib_find_cached_gid(device, &rec->port_gid,
+				 NULL, &p, &gid_index);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 9ded4f4..2e46e38 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -974,7 +974,7 @@ int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = rec->dgid;
 
-		ret = ib_find_cached_gid(device, &rec->sgid, &port_num,
+		ret = ib_find_cached_gid(device, &rec->sgid, NULL, &port_num,
 					 &gid_index);
 		if (ret)
 			return ret;
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 34cdd74..b1f37d4 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -289,7 +289,7 @@ static ssize_t show_port_gid(struct ib_port *p, struct port_attribute *attr,
 	union ib_gid gid;
 	ssize_t ret;
 
-	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid);
+	ret = ib_query_gid(p->ibdev, p->port_num, tab_attr->index, &gid, NULL);
 	if (ret)
 		return ret;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index bac3fb4..49162cf 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -293,8 +293,8 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		ah_attr->ah_flags = IB_AH_GRH;
 		ah_attr->grh.dgid = grh->sgid;
 
-		ret = ib_find_cached_gid(device, &grh->dgid, &port_num,
-					 &gid_index);
+		ret = ib_find_cached_gid(device, &grh->dgid,
+					 NULL, &port_num, &gid_index);
 		if (ret)
 			return ret;
 
@@ -937,7 +937,8 @@ int ib_resolve_eth_l2_attrs(struct ib_qp *qp,
 	if ((*qp_attr_mask & IB_QP_AV)  &&
 	    (rdma_cap_eth_ah(qp->device, qp_attr->ah_attr.port_num))) {
 		ret = ib_query_gid(qp->device, qp_attr->ah_attr.port_num,
-				   qp_attr->ah_attr.grh.sgid_index, &sgid);
+				   qp_attr->ah_attr.grh.sgid_index, &sgid,
+				   NULL);
 		if (ret)
 			goto out;
 		if (rdma_link_local_addr((struct in6_addr *)qp_attr->ah_attr.grh.dgid.raw)) {
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 35a6f85..c94b63b 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -335,7 +335,7 @@ int mlx4_ib_gid_index_to_real_index(struct mlx4_ib_dev *ibdev,
 	if (!rdma_cap_roce_gid_table(&ibdev->ib_dev, port_num))
 		return index;
 
-	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid);
+	ret = ib_get_cached_gid(&ibdev->ib_dev, port_num, index, &gid, NULL);
 	if (ret)
 		return ret;
 
@@ -754,7 +754,7 @@ static int mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 	if (!rdma_cap_roce_gid_table(ibdev, port))
 		return -ENODEV;
 
-	ret = ib_get_cached_gid(ibdev, port, index, gid);
+	ret = ib_get_cached_gid(ibdev, port, index, gid, NULL);
 	if (ret == -EAGAIN) {
 		memcpy(gid, &zgid, sizeof(*gid));
 		return 0;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 4ad9be3..bd3da49 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -2197,7 +2197,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		} else  {
 			err = ib_get_cached_gid(ib_dev,
 						be32_to_cpu(ah->av.ib.port_pd) >> 24,
-						ah->av.ib.gid_index, &sgid);
+						ah->av.ib.gid_index, &sgid,
+						NULL);
 			if (err)
 				return err;
 		}
@@ -2239,7 +2240,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 			ib_get_cached_gid(ib_dev,
 					  be32_to_cpu(ah->av.ib.port_pd) >> 24,
 					  ah->av.ib.gid_index,
-					  &sqp->ud_header.grh.source_gid);
+					  &sqp->ud_header.grh.source_gid, NULL);
 		}
 		memcpy(sqp->ud_header.grh.destination_gid.raw,
 		       ah->av.ib.dgid, 16);
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index 32f6c63..bcac294 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -281,7 +281,7 @@ int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 		ib_get_cached_gid(&dev->ib_dev,
 				  be32_to_cpu(ah->av->port_pd) >> 24,
 				  ah->av->gid_index % dev->limits.gid_table_len,
-				  &header->grh.source_gid);
+				  &header->grh.source_gid, NULL);
 		memcpy(header->grh.destination_gid.raw,
 		       ah->av->dgid, 16);
 	}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 4b05333..df9cd5e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -58,7 +58,7 @@ int ocrdma_query_gid(struct ib_device *ibdev, u8 port,
 	if (index >= OCRDMA_MAX_SGID)
 		return -EINVAL;
 
-	ret = ib_get_cached_gid(ibdev, port, index, sgid);
+	ret = ib_get_cached_gid(ibdev, port, index, sgid, NULL);
 	if (ret == -EAGAIN) {
 		memcpy(sgid, &zgid, sizeof(*sgid));
 		return 0;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b2943c8..8993519 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1613,7 +1613,7 @@ static struct net_device *ipoib_add_port(const char *format,
 	priv->dev->broadcast[8] = priv->pkey >> 8;
 	priv->dev->broadcast[9] = priv->pkey & 0xff;
 
-	result = ib_query_gid(hca, port, 0, &priv->local_gid);
+	result = ib_query_gid(hca, port, 0, &priv->local_gid, NULL);
 	if (result) {
 		printk(KERN_WARNING "%s: ib_query_gid port %d failed (ret = %d)\n",
 		       hca->name, port, result);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 0d23e05..0323c2f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -530,7 +530,7 @@ void ipoib_mcast_join_task(struct work_struct *work)
 	}
 	priv->local_lid = port_attr.lid;
 
-	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid))
+	if (ib_query_gid(priv->ca, priv->port, 0, &priv->local_gid, NULL))
 		ipoib_warn(priv, "ib_query_gid() failed\n");
 	else
 		memcpy(priv->dev->dev_addr + 4, priv->local_gid.raw, sizeof (union ib_gid));
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 31a20b4..41a7b2c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3198,7 +3198,7 @@ static ssize_t srp_create_target(struct device *dev,
 	INIT_WORK(&target->tl_err_work, srp_tl_err_work);
 	INIT_WORK(&target->remove_work, srp_remove_work);
 	spin_lock_init(&target->lock);
-	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid);
+	ret = ib_query_gid(ibdev, host->port, 0, &target->sgid, NULL);
 	if (ret)
 		goto out;
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 60ff0a2..731a592 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -546,7 +546,8 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	sport->sm_lid = port_attr.sm_lid;
 	sport->lid = port_attr.lid;
 
-	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid);
+	ret = ib_query_gid(sport->sdev->device, sport->port, 0, &sport->gid,
+			   NULL);
 	if (ret)
 		goto err_query_port;
 
diff --git a/include/rdma/ib_cache.h b/include/rdma/ib_cache.h
index bd92130..dcc9bed 100644
--- a/include/rdma/ib_cache.h
+++ b/include/rdma/ib_cache.h
@@ -43,6 +43,8 @@
  * @port_num: The port number of the device to query.
  * @index: The index into the cached GID table to query.
  * @gid: The GID value found at the specified index.
+ * @attr: The GID attribute found at the specified index (only in RoCE).
+ *   NULL means ignore (output parameter).
  *
  * ib_get_cached_gid() fetches the specified GID table entry stored in
  * the local software cache.
@@ -50,13 +52,15 @@
 int ib_get_cached_gid(struct ib_device    *device,
 		      u8                   port_num,
 		      int                  index,
-		      union ib_gid        *gid);
+		      union ib_gid        *gid,
+		      struct ib_gid_attr  *attr);
 
 /**
  * ib_find_cached_gid - Returns the port number and GID table index where
  *   a specified GID value occurs.
  * @device: The device to query.
  * @gid: The GID value to search for.
+ * @ndev: In RoCE, the net device of the device. NULL means ignore.
  * @port_num: The port number of the device where the GID value was found.
  * @index: The index into the cached GID table where the GID was found.  This
  *   parameter may be NULL.
@@ -64,10 +68,11 @@ int ib_get_cached_gid(struct ib_device    *device,
  * ib_find_cached_gid() searches for the specified GID value in
  * the local software cache.
  */
-int ib_find_cached_gid(struct ib_device   *device,
+int ib_find_cached_gid(struct ib_device *device,
 		       const union ib_gid *gid,
-		       u8                 *port_num,
-		       u16                *index);
+		       struct net_device *ndev,
+		       u8               *port_num,
+		       u16              *index);
 
 /**
  * ib_get_cached_pkey - Returns a cached PKey table entry
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c856276..d821014 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2153,7 +2153,8 @@ static inline bool rdma_cap_roce_gid_table(const struct ib_device *device,
 }
 
 int ib_query_gid(struct ib_device *device,
-		 u8 port_num, int index, union ib_gid *gid);
+		 u8 port_num, int index, union ib_gid *gid,
+		 struct ib_gid_attr *attr);
 
 int ib_query_pkey(struct ib_device *device,
 		  u8 port_num, u16 index, u16 *pkey);
@@ -2167,7 +2168,7 @@ int ib_modify_port(struct ib_device *device,
 		   struct ib_port_modify *port_modify);
 
 int ib_find_gid(struct ib_device *device, union ib_gid *gid,
-		u8 *port_num, u16 *index);
+		struct net_device *ndev, u8 *port_num, u16 *index);
 
 int ib_find_pkey(struct ib_device *device,
 		 u8 port_num, u16 pkey, u16 *index);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
