From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 3/6] IB/ulps: Avoid calling ib_query_device
Date: Thu, 17 Dec 2015 15:18:57 +0200
Message-ID: <1450358340-19361-4-git-send-email-ogerlitz@mellanox.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450358340-19361-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Instead, use the cached copy of the attributes present on the device.

Based on a patch from Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      | 19 ++++-------
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 14 +++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c    | 21 +------------
 drivers/infiniband/ulp/iser/iscsi_iser.c     |  4 +--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  2 --
 drivers/infiniband/ulp/iser/iser_memory.c    |  9 +++---
 drivers/infiniband/ulp/iser/iser_verbs.c     | 38 ++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.c      | 47 +++++++++-------------------
 drivers/infiniband/ulp/isert/ib_isert.h      |  1 -
 drivers/infiniband/ulp/srp/ib_srp.c          | 32 ++++++-------------
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ++++-----
 drivers/infiniband/ulp/srpt/ib_srpt.h        |  3 --
 12 files changed, 63 insertions(+), 142 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 3ae9726..94d144d 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1522,8 +1522,7 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 int ipoib_cm_dev_init(struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
-	int i, ret;
-	struct ib_device_attr attr;
+	int max_srq_sge, i;
 
 	INIT_LIST_HEAD(&priv->cm.passive_ids);
 	INIT_LIST_HEAD(&priv->cm.reap_list);
@@ -1540,19 +1539,13 @@ int ipoib_cm_dev_init(struct net_device *dev)
 
 	skb_queue_head_init(&priv->cm.skb_queue);
 
-	ret = ib_query_device(priv->ca, &attr);
-	if (ret) {
-		printk(KERN_WARNING "ib_query_device() failed with %d\n", ret);
-		return ret;
-	}
-
-	ipoib_dbg(priv, "max_srq_sge=%d\n", attr.max_srq_sge);
+	ipoib_dbg(priv, "max_srq_sge=%d\n", priv->ca->attrs.max_srq_sge);
 
-	attr.max_srq_sge = min_t(int, IPOIB_CM_RX_SG, attr.max_srq_sge);
-	ipoib_cm_create_srq(dev, attr.max_srq_sge);
+	max_srq_sge = min_t(int, IPOIB_CM_RX_SG, priv->ca->attrs.max_srq_sge);
+	ipoib_cm_create_srq(dev, max_srq_sge);
 	if (ipoib_cm_has_srq(dev)) {
-		priv->cm.max_cm_mtu = attr.max_srq_sge * PAGE_SIZE - 0x10;
-		priv->cm.num_frags  = attr.max_srq_sge;
+		priv->cm.max_cm_mtu = max_srq_sge * PAGE_SIZE - 0x10;
+		priv->cm.num_frags  = max_srq_sge;
 		ipoib_dbg(priv, "max_cm_mtu = 0x%x, num_frags=%d\n",
 			  priv->cm.max_cm_mtu, priv->cm.num_frags);
 	} else {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
index 078cadd..a53fa5f 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
@@ -40,15 +40,11 @@ static void ipoib_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *drvinfo)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(netdev);
-	struct ib_device_attr *attr;
-
-	attr = kmalloc(sizeof(*attr), GFP_KERNEL);
-	if (attr && !ib_query_device(priv->ca, attr))
-		snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
-			 "%d.%d.%d", (int)(attr->fw_ver >> 32),
-			 (int)(attr->fw_ver >> 16) & 0xffff,
-			 (int)attr->fw_ver & 0xffff);
-	kfree(attr);
+
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%d", (int)(priv->ca->attrs.fw_ver >> 32),
+		 (int)(priv->ca->attrs.fw_ver >> 16) & 0xffff,
+		 (int)priv->ca->attrs.fw_ver & 0xffff);
 
 	strlcpy(drvinfo->bus_info, dev_name(priv->ca->dma_device),
 		sizeof(drvinfo->bus_info));
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 7d32818..58732c5 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1777,26 +1777,7 @@ int ipoib_add_pkey_attr(struct net_device *dev)
 
 int ipoib_set_dev_features(struct ipoib_dev_priv *priv, struct ib_device *hca)
 {
-	struct ib_device_attr *device_attr;
-	int result = -ENOMEM;
-
-	device_attr = kmalloc(sizeof *device_attr, GFP_KERNEL);
-	if (!device_attr) {
-		printk(KERN_WARNING "%s: allocation of %zu bytes failed\n",
-		       hca->name, sizeof *device_attr);
-		return result;
-	}
-
-	result = ib_query_device(hca, device_attr);
-	if (result) {
-		printk(KERN_WARNING "%s: ib_query_device failed (ret = %d)\n",
-		       hca->name, result);
-		kfree(device_attr);
-		return result;
-	}
-	priv->hca_caps = device_attr->device_cap_flags;
-
-	kfree(device_attr);
+	priv->hca_caps = hca->attrs.device_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
 		priv->dev->hw_features = NETIF_F_SG |
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9080161..237e3bc 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -644,7 +644,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 
 		ib_conn = &iser_conn->ib_conn;
 		if (ib_conn->pi_support) {
-			u32 sig_caps = ib_conn->device->dev_attr.sig_prot_cap;
+			u32 sig_caps = ib_conn->device->ib_device->attrs.sig_prot_cap;
 
 			scsi_host_set_prot(shost, iser_dif_prot_caps(sig_caps));
 			scsi_host_set_guard(shost, SHOST_DIX_GUARD_IP |
@@ -656,7 +656,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 		 * max fastreg page list length.
 		 */
 		shost->sg_tablesize = min_t(unsigned short, shost->sg_tablesize,
-			ib_conn->device->dev_attr.max_fast_reg_page_list_len);
+			ib_conn->device->ib_device->attrs.max_fast_reg_page_list_len);
 		shost->max_sectors = min_t(unsigned int,
 			1024, (shost->sg_tablesize * PAGE_SIZE) >> 9);
 
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 8a5998e..502063b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -380,7 +380,6 @@ struct iser_reg_ops {
  *
  * @ib_device:     RDMA device
  * @pd:            Protection Domain for this device
- * @dev_attr:      Device attributes container
  * @mr:            Global DMA memory region
  * @event_handler: IB events handle routine
  * @ig_list:	   entry in devices list
@@ -393,7 +392,6 @@ struct iser_reg_ops {
 struct iser_device {
 	struct ib_device             *ib_device;
 	struct ib_pd	             *pd;
-	struct ib_device_attr	     dev_attr;
 	struct ib_mr	             *mr;
 	struct ib_event_handler      event_handler;
 	struct list_head             ig_list;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index ea765fb..47b4761 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -69,15 +69,14 @@ static struct iser_reg_ops fmr_ops = {
 
 int iser_assign_reg_ops(struct iser_device *device)
 {
-	struct ib_device_attr *dev_attr = &device->dev_attr;
+	struct ib_device *ib_dev = device->ib_device;
 
 	/* Assign function handles  - based on FMR support */
-	if (device->ib_device->alloc_fmr && device->ib_device->dealloc_fmr &&
-	    device->ib_device->map_phys_fmr && device->ib_device->unmap_fmr) {
+	if (ib_dev->alloc_fmr && ib_dev->dealloc_fmr &&
+	    ib_dev->map_phys_fmr && ib_dev->unmap_fmr) {
 		iser_info("FMR supported, using FMR for registration\n");
 		device->reg_ops = &fmr_ops;
-	} else
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
+	} else if (ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
 		iser_info("FastReg supported, using FastReg for registration\n");
 		device->reg_ops = &fastreg_ops;
 	} else {
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 42f4da6..84b7b07 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -78,34 +78,28 @@ static void iser_event_handler(struct ib_event_handler *handler,
  */
 static int iser_create_device_ib_res(struct iser_device *device)
 {
-	struct ib_device_attr *dev_attr = &device->dev_attr;
+	struct ib_device *ib_dev = device->ib_device;
 	int ret, i, max_cqe;
 
-	ret = ib_query_device(device->ib_device, dev_attr);
-	if (ret) {
-		pr_warn("Query device failed for %s\n", device->ib_device->name);
-		return ret;
-	}
-
 	ret = iser_assign_reg_ops(device);
 	if (ret)
 		return ret;
 
 	device->comps_used = min_t(int, num_online_cpus(),
-				 device->ib_device->num_comp_vectors);
+				 ib_dev->num_comp_vectors);
 
 	device->comps = kcalloc(device->comps_used, sizeof(*device->comps),
 				GFP_KERNEL);
 	if (!device->comps)
 		goto comps_err;
 
-	max_cqe = min(ISER_MAX_CQ_LEN, dev_attr->max_cqe);
+	max_cqe = min(ISER_MAX_CQ_LEN, ib_dev->attrs.max_cqe);
 
 	iser_info("using %d CQs, device %s supports %d vectors max_cqe %d\n",
-		  device->comps_used, device->ib_device->name,
-		  device->ib_device->num_comp_vectors, max_cqe);
+		  device->comps_used, ib_dev->name,
+		  ib_dev->num_comp_vectors, max_cqe);
 
-	device->pd = ib_alloc_pd(device->ib_device);
+	device->pd = ib_alloc_pd(ib_dev);
 	if (IS_ERR(device->pd))
 		goto pd_err;
 
@@ -116,7 +110,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		comp->device = device;
 		cq_attr.cqe = max_cqe;
 		cq_attr.comp_vector = i;
-		comp->cq = ib_create_cq(device->ib_device,
+		comp->cq = ib_create_cq(ib_dev,
 					iser_cq_callback,
 					iser_cq_event_callback,
 					(void *)comp,
@@ -464,7 +458,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
 						   ib_conn);
 	struct iser_device	*device;
-	struct ib_device_attr *dev_attr;
+	struct ib_device	*ib_dev;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
 	int index, min_index = 0;
@@ -472,7 +466,7 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 	BUG_ON(ib_conn->device == NULL);
 
 	device = ib_conn->device;
-	dev_attr = &device->dev_attr;
+	ib_dev = device->ib_device;
 
 	memset(&init_attr, 0, sizeof init_attr);
 
@@ -503,16 +497,16 @@ static int iser_create_ib_conn_res(struct ib_conn *ib_conn)
 		iser_conn->max_cmds =
 			ISER_GET_MAX_XMIT_CMDS(ISER_QP_SIG_MAX_REQ_DTOS);
 	} else {
-		if (dev_attr->max_qp_wr > ISER_QP_MAX_REQ_DTOS) {
+		if (ib_dev->attrs.max_qp_wr > ISER_QP_MAX_REQ_DTOS) {
 			init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS + 1;
 			iser_conn->max_cmds =
 				ISER_GET_MAX_XMIT_CMDS(ISER_QP_MAX_REQ_DTOS);
 		} else {
-			init_attr.cap.max_send_wr = dev_attr->max_qp_wr;
+			init_attr.cap.max_send_wr = ib_dev->attrs.max_qp_wr;
 			iser_conn->max_cmds =
-				ISER_GET_MAX_XMIT_CMDS(dev_attr->max_qp_wr);
+				ISER_GET_MAX_XMIT_CMDS(ib_dev->attrs.max_qp_wr);
 			iser_dbg("device %s supports max_send_wr %d\n",
-				 device->ib_device->name, dev_attr->max_qp_wr);
+				 device->ib_device->name, ib_dev->attrs.max_qp_wr);
 		}
 	}
 
@@ -756,7 +750,7 @@ iser_calc_scsi_params(struct iser_conn *iser_conn,
 
 	sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
 	sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
-				 device->dev_attr.max_fast_reg_page_list_len);
+				 device->ib_device->attrs.max_fast_reg_page_list_len);
 
 	if (sg_tablesize > sup_sg_tablesize) {
 		sg_tablesize = sup_sg_tablesize;
@@ -799,7 +793,7 @@ static void iser_addr_handler(struct rdma_cm_id *cma_id)
 
 	/* connection T10-PI support */
 	if (iser_pi_enable) {
-		if (!(device->dev_attr.device_cap_flags &
+		if (!(device->ib_device->attrs.device_cap_flags &
 		      IB_DEVICE_SIGNATURE_HANDOVER)) {
 			iser_warn("T10-PI requested but not supported on %s, "
 				  "continue without T10-PI\n",
@@ -841,7 +835,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 		goto failure;
 
 	memset(&conn_param, 0, sizeof conn_param);
-	conn_param.responder_resources = device->dev_attr.max_qp_rd_atom;
+	conn_param.responder_resources = device->ib_device->attrs.max_qp_rd_atom;
 	conn_param.initiator_depth     = 1;
 	conn_param.retry_count	       = 7;
 	conn_param.rnr_retry_count     = 6;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8a51c3b..7468216 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -95,22 +95,6 @@ isert_qp_event_callback(struct ib_event *e, void *context)
 	}
 }
 
-static int
-isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *devattr)
-{
-	int ret;
-
-	ret = ib_query_device(ib_dev, devattr);
-	if (ret) {
-		isert_err("ib_query_device() failed: %d\n", ret);
-		return ret;
-	}
-	isert_dbg("devattr->max_sge: %d\n", devattr->max_sge);
-	isert_dbg("devattr->max_sge_rd: %d\n", devattr->max_sge_rd);
-
-	return 0;
-}
-
 static struct isert_comp *
 isert_comp_get(struct isert_conn *isert_conn)
 {
@@ -157,9 +141,9 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.recv_cq = comp->cq;
 	attr.cap.max_send_wr = ISERT_QP_MAX_REQ_DTOS;
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
-	attr.cap.max_send_sge = device->dev_attr.max_sge;
-	isert_conn->max_sge = min(device->dev_attr.max_sge,
-				  device->dev_attr.max_sge_rd);
+	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
+	isert_conn->max_sge = min(device->ib_device->attrs.max_sge,
+				  device->ib_device->attrs.max_sge_rd);
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
@@ -287,8 +271,7 @@ isert_free_comps(struct isert_device *device)
 }
 
 static int
-isert_alloc_comps(struct isert_device *device,
-		  struct ib_device_attr *attr)
+isert_alloc_comps(struct isert_device *device)
 {
 	int i, max_cqe, ret = 0;
 
@@ -308,7 +291,7 @@ isert_alloc_comps(struct isert_device *device,
 		return -ENOMEM;
 	}
 
-	max_cqe = min(ISER_MAX_CQ_LEN, attr->max_cqe);
+	max_cqe = min(ISER_MAX_CQ_LEN, device->ib_device->attrs.max_cqe);
 
 	for (i = 0; i < device->comps_used; i++) {
 		struct ib_cq_init_attr cq_attr = {};
@@ -344,17 +327,15 @@ out_cq:
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
-	struct ib_device_attr *dev_attr;
+	struct ib_device *ib_dev = device->ib_device;
 	int ret;
 
-	dev_attr = &device->dev_attr;
-	ret = isert_query_device(device->ib_device, dev_attr);
-	if (ret)
-		return ret;
+	isert_dbg("devattr->max_sge: %d\n", ib_dev->attrs.max_sge);
+	isert_dbg("devattr->max_sge_rd: %d\n", ib_dev->attrs.max_sge_rd);
 
 	/* asign function handlers */
-	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
-	    dev_attr->device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
+	if (ib_dev->attrs.device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS &&
+	    ib_dev->attrs.device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER) {
 		device->use_fastreg = 1;
 		device->reg_rdma_mem = isert_reg_rdma;
 		device->unreg_rdma_mem = isert_unreg_rdma;
@@ -364,11 +345,11 @@ isert_create_device_ib_res(struct isert_device *device)
 		device->unreg_rdma_mem = isert_unmap_cmd;
 	}
 
-	ret = isert_alloc_comps(device, dev_attr);
+	ret = isert_alloc_comps(device);
 	if (ret)
 		return ret;
 
-	device->pd = ib_alloc_pd(device->ib_device);
+	device->pd = ib_alloc_pd(ib_dev);
 	if (IS_ERR(device->pd)) {
 		ret = PTR_ERR(device->pd);
 		isert_err("failed to allocate pd, device %p, ret=%d\n",
@@ -377,7 +358,7 @@ isert_create_device_ib_res(struct isert_device *device)
 	}
 
 	/* Check signature cap */
-	device->pi_capable = dev_attr->device_cap_flags &
+	device->pi_capable = ib_dev->attrs.device_cap_flags &
 			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
 
 	return 0;
@@ -714,7 +695,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	/* Set max inflight RDMA READ requests */
 	isert_conn->initiator_depth = min_t(u8,
 				event->param.conn.initiator_depth,
-				device->dev_attr.max_qp_init_rd_atom);
+				device->ib_device->attrs.max_qp_init_rd_atom);
 	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth);
 
 	ret = isert_conn_setup_qp(isert_conn, cma_id);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 3d7fbc4..b41f15a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -207,7 +207,6 @@ struct isert_device {
 	struct isert_comp	*comps;
 	int                     comps_used;
 	struct list_head	dev_node;
-	struct ib_device_attr	dev_attr;
 	int			(*reg_rdma_mem)(struct iscsi_conn *conn,
 						    struct iscsi_cmd *cmd,
 						    struct isert_rdma_wr *wr);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 3db9a65..b34d5c6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3439,27 +3439,17 @@ free_host:
 static void srp_add_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
-	struct ib_device_attr *dev_attr;
 	struct srp_host *host;
 	int mr_page_shift, p;
 	u64 max_pages_per_mr;
 
-	dev_attr = kmalloc(sizeof *dev_attr, GFP_KERNEL);
-	if (!dev_attr)
-		return;
-
-	if (ib_query_device(device, dev_attr)) {
-		pr_warn("Query device failed for %s\n", device->name);
-		goto free_attr;
-	}
-
 	srp_dev = kmalloc(sizeof *srp_dev, GFP_KERNEL);
 	if (!srp_dev)
-		goto free_attr;
+		return;
 
 	srp_dev->has_fmr = (device->alloc_fmr && device->dealloc_fmr &&
 			    device->map_phys_fmr && device->unmap_fmr);
-	srp_dev->has_fr = (dev_attr->device_cap_flags &
+	srp_dev->has_fr = (device->attrs.device_cap_flags &
 			   IB_DEVICE_MEM_MGT_EXTENSIONS);
 	if (!srp_dev->has_fmr && !srp_dev->has_fr)
 		dev_warn(&device->dev, "neither FMR nor FR is supported\n");
@@ -3473,23 +3463,23 @@ static void srp_add_one(struct ib_device *device)
 	 * minimum of 4096 bytes. We're unlikely to build large sglists
 	 * out of smaller entries.
 	 */
-	mr_page_shift		= max(12, ffs(dev_attr->page_size_cap) - 1);
+	mr_page_shift		= max(12, ffs(device->attrs.page_size_cap) - 1);
 	srp_dev->mr_page_size	= 1 << mr_page_shift;
 	srp_dev->mr_page_mask	= ~((u64) srp_dev->mr_page_size - 1);
-	max_pages_per_mr	= dev_attr->max_mr_size;
+	max_pages_per_mr	= device->attrs.max_mr_size;
 	do_div(max_pages_per_mr, srp_dev->mr_page_size);
 	srp_dev->max_pages_per_mr = min_t(u64, SRP_MAX_PAGES_PER_MR,
 					  max_pages_per_mr);
 	if (srp_dev->use_fast_reg) {
 		srp_dev->max_pages_per_mr =
 			min_t(u32, srp_dev->max_pages_per_mr,
-			      dev_attr->max_fast_reg_page_list_len);
+			      device->attrs.max_fast_reg_page_list_len);
 	}
 	srp_dev->mr_max_size	= srp_dev->mr_page_size *
 				   srp_dev->max_pages_per_mr;
-	pr_debug("%s: mr_page_shift = %d, dev_attr->max_mr_size = %#llx, dev_attr->max_fast_reg_page_list_len = %u, max_pages_per_mr = %d, mr_max_size = %#x\n",
-		 device->name, mr_page_shift, dev_attr->max_mr_size,
-		 dev_attr->max_fast_reg_page_list_len,
+	pr_debug("%s: mr_page_shift = %d, device->max_mr_size = %#llx, device->max_fast_reg_page_list_len = %u, max_pages_per_mr = %d, mr_max_size = %#x\n",
+		 device->name, mr_page_shift, device->attrs.max_mr_size,
+		 device->attrs.max_fast_reg_page_list_len,
 		 srp_dev->max_pages_per_mr, srp_dev->mr_max_size);
 
 	INIT_LIST_HEAD(&srp_dev->dev_list);
@@ -3517,17 +3507,13 @@ static void srp_add_one(struct ib_device *device)
 	}
 
 	ib_set_client_data(device, &srp_client, srp_dev);
-
-	goto free_attr;
+	return;
 
 err_pd:
 	ib_dealloc_pd(srp_dev->pd);
 
 free_dev:
 	kfree(srp_dev);
-
-free_attr:
-	kfree(dev_attr);
 }
 
 static void srp_remove_one(struct ib_device *device, void *client_data)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2e2fe81..c1d33ac 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -341,10 +341,10 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 	memset(iocp, 0, sizeof *iocp);
 	strcpy(iocp->id_string, SRPT_ID_STRING);
 	iocp->guid = cpu_to_be64(srpt_service_guid);
-	iocp->vendor_id = cpu_to_be32(sdev->dev_attr.vendor_id);
-	iocp->device_id = cpu_to_be32(sdev->dev_attr.vendor_part_id);
-	iocp->device_version = cpu_to_be16(sdev->dev_attr.hw_ver);
-	iocp->subsys_vendor_id = cpu_to_be32(sdev->dev_attr.vendor_id);
+	iocp->vendor_id = cpu_to_be32(sdev->device->attrs.vendor_id);
+	iocp->device_id = cpu_to_be32(sdev->device->attrs.vendor_part_id);
+	iocp->device_version = cpu_to_be16(sdev->device->attrs.hw_ver);
+	iocp->subsys_vendor_id = cpu_to_be32(sdev->device->attrs.vendor_id);
 	iocp->subsys_device_id = 0x0;
 	iocp->io_class = cpu_to_be16(SRP_REV16A_IB_IO_CLASS);
 	iocp->io_subclass = cpu_to_be16(SRP_IO_SUBCLASS);
@@ -3203,14 +3203,11 @@ static void srpt_add_one(struct ib_device *device)
 	init_waitqueue_head(&sdev->ch_releaseQ);
 	spin_lock_init(&sdev->spinlock);
 
-	if (ib_query_device(device, &sdev->dev_attr))
-		goto free_dev;
-
 	sdev->pd = ib_alloc_pd(device);
 	if (IS_ERR(sdev->pd))
 		goto free_dev;
 
-	sdev->srq_size = min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
+	sdev->srq_size = min(srpt_srq_size, sdev->device->attrs.max_srq_wr);
 
 	srq_attr.event_handler = srpt_srq_event;
 	srq_attr.srq_context = (void *)sdev;
@@ -3224,7 +3221,7 @@ static void srpt_add_one(struct ib_device *device)
 		goto err_pd;
 
 	pr_debug("%s: create SRQ #wr= %d max_allow=%d dev= %s\n",
-		 __func__, sdev->srq_size, sdev->dev_attr.max_srq_wr,
+		 __func__, sdev->srq_size, sdev->device->attrs.max_srq_wr,
 		 device->name);
 
 	if (!srpt_service_guid)
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 5faad8ac..0df7d61 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -379,8 +379,6 @@ struct srpt_port {
  * @mr:            L_Key (local key) with write access to all local memory.
  * @srq:           Per-HCA SRQ (shared receive queue).
  * @cm_id:         Connection identifier.
- * @dev_attr:      Attributes of the InfiniBand device as obtained during the
- *                 ib_client.add() callback.
  * @srq_size:      SRQ size.
  * @ioctx_ring:    Per-HCA SRQ.
  * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.list.
@@ -395,7 +393,6 @@ struct srpt_device {
 	struct ib_pd		*pd;
 	struct ib_srq		*srq;
 	struct ib_cm_id		*cm_id;
-	struct ib_device_attr	dev_attr;
 	int			srq_size;
 	struct srpt_recv_ioctx	**ioctx_ring;
 	struct list_head	rch_list;
-- 
2.3.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
