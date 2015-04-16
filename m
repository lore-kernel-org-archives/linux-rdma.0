From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH v4 19/27] IB/Verbs: Use management helper cap_iw_cm()
Date: Thu, 16 Apr 2015 10:12:26 +0200
Message-ID: <552F6EEA.4090100@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552F6CF2.4000606-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Introduce helper cap_iw_cm() to help us check if the port of an
IB device support IWARP Communication Manager.

Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 14 +++++++-------
 include/rdma/ib_verbs.h       | 15 +++++++++++++++
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7415078..a6f1526 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -776,7 +776,7 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
 
 		if (qp_attr->qp_state == IB_QPS_RTR)
 			qp_attr->rq_psn = id_priv->seq_num;
-	} else if (rdma_tech_iwarp(id_priv->id.device, 1)) {
+	} else if (cap_iw_cm(id_priv->id.device, 1)) {
 		if (!id_priv->cm_id.iw) {
 			qp_attr->qp_access_flags = 0;
 			*qp_attr_mask = IB_QP_STATE | IB_QP_ACCESS_FLAGS;
@@ -1058,7 +1058,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 		if (cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
-		} else if (rdma_tech_iwarp(id_priv->id.device, 1)) {
+		} else if (cap_iw_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.iw)
 				iw_destroy_cm_id(id_priv->cm_id.iw);
 		}
@@ -2542,7 +2542,7 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 			ret = cma_ib_listen(id_priv);
 			if (ret)
 				goto err;
-		} else if (rdma_tech_iwarp(id->device, 1)) {
+		} else if (cap_iw_cm(id->device, 1)) {
 			ret = cma_iw_listen(id_priv, backlog);
 			if (ret)
 				goto err;
@@ -2887,7 +2887,7 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			ret = cma_resolve_ib_udp(id_priv, conn_param);
 		else
 			ret = cma_connect_ib(id_priv, conn_param);
-	} else if (rdma_tech_iwarp(id->device, 1))
+	} else if (cap_iw_cm(id->device, 1))
 		ret = cma_connect_iw(id_priv, conn_param);
 	else
 		ret = -ENOSYS;
@@ -3009,7 +3009,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			else
 				ret = cma_rep_recv(id_priv);
 		}
-	} else if (rdma_tech_iwarp(id->device, 1))
+	} else if (cap_iw_cm(id->device, 1))
 		ret = cma_accept_iw(id_priv, conn_param);
 	else
 		ret = -ENOSYS;
@@ -3064,7 +3064,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 			ret = ib_send_cm_rej(id_priv->cm_id.ib,
 					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
 					     0, private_data, private_data_len);
-	} else if (rdma_tech_iwarp(id->device, 1)) {
+	} else if (cap_iw_cm(id->device, 1)) {
 		ret = iw_cm_reject(id_priv->cm_id.iw,
 				   private_data, private_data_len);
 	} else
@@ -3090,7 +3090,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 		/* Initiate or respond to a disconnect. */
 		if (ib_send_cm_dreq(id_priv->cm_id.ib, NULL, 0))
 			ib_send_cm_drep(id_priv->cm_id.ib, NULL, 0);
-	} else if (rdma_tech_iwarp(id->device, 1)) {
+	} else if (cap_iw_cm(id->device, 1)) {
 		ret = iw_cm_disconnect(id_priv->cm_id.iw, 0);
 	} else
 		ret = -EINVAL;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6805e3e..e4999f6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1818,6 +1818,21 @@ static inline int cap_ib_cm(struct ib_device *device, u8 port_num)
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
+	return rdma_tech_iwarp(device, port_num);
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
