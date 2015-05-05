From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v8 17/23] IB/Verbs: Use management helper rdma_cap_ib_cm()
Date: Tue,  5 May 2015 14:50:34 +0200
Message-ID: <1430830240-32389-18-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduce helper rdma_cap_ib_cm() to help us check if the port of an
IB device support Infiniband Communication Manager.

Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cm.c  |  6 +++---
 drivers/infiniband/core/cma.c | 19 +++++++++----------
 drivers/infiniband/core/ucm.c |  2 +-
 include/rdma/ib_verbs.h       | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index add5e484..7073f98 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3781,7 +3781,7 @@ static void cm_add_one(struct ib_device *ib_device)
 
 	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
 		port = kzalloc(sizeof *port, GFP_KERNEL);
@@ -3832,7 +3832,7 @@ error1:
 	port_modify.set_port_cap_mask = 0;
 	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
 	while (--i) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
 		port = cm_dev->port[i-1];
@@ -3864,7 +3864,7 @@ static void cm_remove_one(struct ib_device *ib_device)
 	write_unlock_irqrestore(&cm.device_lock, flags);
 
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!rdma_cap_ib_cm(ib_device, i))
 			continue;
 
 		port = cm_dev->port[i-1];
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d43f492f..71a3668 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -745,7 +745,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 	int ret = 0;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (rdma_cap_ib_cm(id->device, id->port_num)) {
 		if (!id_priv->cm_id.ib || (id_priv->id.qp_type == IB_QPT_UD))
 			ret = cma_ib_init_qp_attr(id_priv, qp_attr, qp_attr_mask);
 		else
@@ -1033,7 +1033,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	mutex_unlock(&id_priv->handler_mutex);
 
 	if (id_priv->cma_dev) {
-		if (rdma_ib_or_iboe(id_priv->id.device, 1)) {
+		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
 		} else if (rdma_protocol_iwarp(id_priv->id.device, 1)) {
@@ -1616,8 +1616,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	struct rdma_cm_id *id;
 	int ret;
 
-	if (cma_family(id_priv) == AF_IB &&
-	    !rdma_ib_or_iboe(cma_dev->device, 1))
+	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
 		return;
 
 	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
@@ -2008,7 +2007,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	mutex_lock(&lock);
 	list_for_each_entry(cur_dev, &dev_list, list) {
 		if (cma_family(id_priv) == AF_IB &&
-		    !rdma_ib_or_iboe(cur_dev->device, 1))
+		    !rdma_cap_ib_cm(cur_dev->device, 1))
 			continue;
 
 		if (!cma_dev)
@@ -2517,7 +2516,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 
 	id_priv->backlog = backlog;
 	if (id->device) {
-		if (rdma_ib_or_iboe(id->device, 1)) {
+		if (rdma_cap_ib_cm(id->device, 1)) {
 			ret = cma_ib_listen(id_priv);
 			if (ret)
 				goto err;
@@ -2861,7 +2860,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (rdma_cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_resolve_ib_udp(id_priv, conn_param);
 		else
@@ -2972,7 +2971,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (rdma_cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD) {
 			if (conn_param)
 				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
@@ -3035,7 +3034,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (rdma_cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
 						private_data, private_data_len);
@@ -3062,7 +3061,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (rdma_cap_ib_cm(id->device, id->port_num)) {
 		ret = cma_modify_qp_err(id_priv);
 		if (ret)
 			goto out;
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 70e0ccb..62c24b1 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1253,7 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	dev_t base;
 	struct ib_ucm_device *ucm_dev;
 
-	if (!device->alloc_ucontext || !rdma_ib_or_iboe(device, 1))
+	if (!device->alloc_ucontext || !rdma_cap_ib_cm(device, 1))
 		return;
 
 	ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index e983e33..e349596 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1804,6 +1804,21 @@ static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
 	return rdma_protocol_ib(device, port_num);
 }
 
+/**
+ * rdma_cap_ib_cm - Check if the port of device has the capability Infiniband
+ * Communication Manager.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return false when port of the device don't support Infiniband
+ * Communication Manager.
+ */
+static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
+{
+	return rdma_ib_or_iboe(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
