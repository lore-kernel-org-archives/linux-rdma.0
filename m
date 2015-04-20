From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v5 18/27] IB/Verbs: Use management helper cap_ib_cm()
Date: Mon, 20 Apr 2015 10:40:04 +0200
Message-ID: <5534BB64.10402@profitbricks.com>
References: <5534B8C9.506@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5534B8C9.506@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, hal@dev.mellanox.co.il
Cc: Michael Wang <yun.wang@profitbricks.com>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org


Introduce helper cap_ib_cm() to help us check if the port of an
IB device support Infiniband Communication Manager.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cm.c  |  6 +++---
 drivers/infiniband/core/cma.c | 19 +++++++++----------
 drivers/infiniband/core/ucm.c |  2 +-
 include/rdma/ib_verbs.h       | 15 +++++++++++++++
 4 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3c10b75..eae4c9f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3781,7 +3781,7 @@ static void cm_add_one(struct ib_device *ib_device)
 
 	set_bit(IB_MGMT_METHOD_SEND, reg_req.method_mask);
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!cap_ib_cm(ib_device, i))
 			continue;
 
 		port = kzalloc(sizeof *port, GFP_KERNEL);
@@ -3832,7 +3832,7 @@ error1:
 	port_modify.set_port_cap_mask = 0;
 	port_modify.clr_port_cap_mask = IB_PORT_CM_SUP;
 	while (--i) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!cap_ib_cm(ib_device, i))
 			continue;
 
 		port = cm_dev->port[i-1];
@@ -3864,7 +3864,7 @@ static void cm_remove_one(struct ib_device *ib_device)
 	write_unlock_irqrestore(&cm.device_lock, flags);
 
 	for (i = 1; i <= ib_device->phys_port_cnt; i++) {
-		if (!rdma_ib_or_iboe(ib_device, i))
+		if (!cap_ib_cm(ib_device, i))
 			continue;
 
 		port = cm_dev->port[i-1];
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ec64b97..ff59dbc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -766,7 +766,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 	int ret = 0;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (cap_ib_cm(id->device, id->port_num)) {
 		if (!id_priv->cm_id.ib || (id_priv->id.qp_type == IB_QPT_UD))
 			ret = cma_ib_init_qp_attr(id_priv, qp_attr, qp_attr_mask);
 		else
@@ -1054,7 +1054,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	mutex_unlock(&id_priv->handler_mutex);
 
 	if (id_priv->cma_dev) {
-		if (rdma_ib_or_iboe(id_priv->id.device, 1)) {
+		if (cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
 		} else if (rdma_tech_iwarp(id_priv->id.device, 1)) {
@@ -1637,8 +1637,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	struct rdma_cm_id *id;
 	int ret;
 
-	if (cma_family(id_priv) == AF_IB &&
-	    !rdma_ib_or_iboe(cma_dev->device, 1))
+	if (cma_family(id_priv) == AF_IB && !cap_ib_cm(cma_dev->device, 1))
 		return;
 
 	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
@@ -2029,7 +2028,7 @@ static int cma_bind_loopback(struct rdma_id_private *id_priv)
 	mutex_lock(&lock);
 	list_for_each_entry(cur_dev, &dev_list, list) {
 		if (cma_family(id_priv) == AF_IB &&
-		    !rdma_ib_or_iboe(cur_dev->device, 1))
+		    !cap_ib_cm(cur_dev->device, 1))
 			continue;
 
 		if (!cma_dev)
@@ -2538,7 +2537,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 
 	id_priv->backlog = backlog;
 	if (id->device) {
-		if (rdma_ib_or_iboe(id->device, 1)) {
+		if (cap_ib_cm(id->device, 1)) {
 			ret = cma_ib_listen(id_priv);
 			if (ret)
 				goto err;
@@ -2882,7 +2881,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_resolve_ib_udp(id_priv, conn_param);
 		else
@@ -2993,7 +2992,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->srq = conn_param->srq;
 	}
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD) {
 			if (conn_param)
 				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
@@ -3056,7 +3055,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (cap_ib_cm(id->device, id->port_num)) {
 		if (id->qp_type == IB_QPT_UD)
 			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
 						private_data, private_data_len);
@@ -3083,7 +3082,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
-	if (rdma_ib_or_iboe(id->device, id->port_num)) {
+	if (cap_ib_cm(id->device, id->port_num)) {
 		ret = cma_modify_qp_err(id_priv);
 		if (ret)
 			goto out;
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 70e0ccb..f7290c8 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1253,7 +1253,7 @@ static void ib_ucm_add_one(struct ib_device *device)
 	dev_t base;
 	struct ib_ucm_device *ucm_dev;
 
-	if (!device->alloc_ucontext || !rdma_ib_or_iboe(device, 1))
+	if (!device->alloc_ucontext || !cap_ib_cm(device, 1))
 		return;
 
 	ucm_dev = kzalloc(sizeof *ucm_dev, GFP_KERNEL);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 873b9a6..6805e3e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1803,6 +1803,21 @@ static inline int cap_ib_smi(struct ib_device *device, u8 port_num)
 	return rdma_tech_ib(device, port_num);
 }
 
+/**
+ * cap_ib_cm - Check if the port of device has the capability Infiniband
+ * Communication Manager.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support Infiniband
+ * Communication Manager.
+ */
+static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
+{
+	return rdma_ib_or_iboe(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0
