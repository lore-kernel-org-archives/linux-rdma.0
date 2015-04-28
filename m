From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v7 18/23] IB/Verbs: Use management helper cap_iw_cm()
Date: Tue, 28 Apr 2015 17:10:18 +0200
Message-ID: <1430233823-7075-19-git-send-email-yun.wang@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Steve Wise <swise@opengridcomputing.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Ira Weiny <ira.weiny@intel.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Introduce helper cap_iw_cm() to help us check if the port of an
IB device support IWARP Communication Manager.

Cc: Hal Rosenstock <hal@dev.mellanox.co.il>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/cma.c | 14 +++++++-------
 include/rdma/ib_verbs.h       | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ecb0484..7d55296 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -754,7 +754,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 
 		if (qp_attr->qp_state == IB_QPS_RTR)
 			qp_attr->rq_psn = id_priv->seq_num;
-	} else if (rdma_protocol_iwarp(id->device, id->port_num)) {
+	} else if (cap_iw_cm(id->device, id->port_num)) {
 		if (!id_priv->cm_id.iw) {
 			qp_attr->qp_access_flags = 0;
 			*qp_attr_mask = IB_QP_STATE | IB_QP_ACCESS_FLAGS;
@@ -1036,7 +1036,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 		if (cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
-		} else if (rdma_protocol_iwarp(id_priv->id.device, 1)) {
+		} else if (cap_iw_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.iw)
 				iw_destroy_cm_id(id_priv->cm_id.iw);
 		}
@@ -2520,7 +2520,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 			ret = cma_ib_listen(id_priv);
 			if (ret)
 				goto err;
-		} else if (rdma_protocol_iwarp(id->device, 1)) {
+		} else if (cap_iw_cm(id->device, 1)) {
 			ret = cma_iw_listen(id_priv, backlog);
 			if (ret)
 				goto err;
@@ -2865,7 +2865,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			ret = cma_resolve_ib_udp(id_priv, conn_param);
 		else
 			ret = cma_connect_ib(id_priv, conn_param);
-	} else if (rdma_protocol_iwarp(id->device, id->port_num))
+	} else if (cap_iw_cm(id->device, id->port_num))
 		ret = cma_connect_iw(id_priv, conn_param);
 	else
 		ret = -ENOSYS;
@@ -2987,7 +2987,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			else
 				ret = cma_rep_recv(id_priv);
 		}
-	} else if (rdma_protocol_iwarp(id->device, id->port_num))
+	} else if (cap_iw_cm(id->device, id->port_num))
 		ret = cma_accept_iw(id_priv, conn_param);
 	else
 		ret = -ENOSYS;
@@ -3042,7 +3042,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 			ret = ib_send_cm_rej(id_priv->cm_id.ib,
 					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
 					     0, private_data, private_data_len);
-	} else if (rdma_protocol_iwarp(id->device, id->port_num)) {
+	} else if (cap_iw_cm(id->device, id->port_num)) {
 		ret = iw_cm_reject(id_priv->cm_id.iw,
 				   private_data, private_data_len);
 	} else
@@ -3068,7 +3068,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 		/* Initiate or respond to a disconnect. */
 		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0))
 			ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0);
-	} else if (rdma_protocol_iwarp(id->device, id->port_num)) {
+	} else if (cap_iw_cm(id->device, id->port_num)) {
 		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
 	} else
 		ret = -EINVAL;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 87b07f2..d69e467 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1819,6 +1819,21 @@ static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
 	return rdma_ib_or_iboe(device, port_num);
 }
 
+/**
+ * cap_iw_cm - Check if the port of device has the capability IWARP
+ * Communication Manager.
+ *
+ * @device: Device to be checked
+ * @port_num: Port number of the device
+ *
+ * Return 0 when port of the device don't support IWARP
+ * Communication Manager.
+ */
+static inline int cap_iw_cm(struct ib_device *device, u8 port_num)
+{
+	return rdma_protocol_iwarp(device, port_num);
+}
+
 int ib_query_gid(struct ib_device *device,
 		 u8 port_num, int index, union ib_gid *gid);
 
-- 
2.1.0
