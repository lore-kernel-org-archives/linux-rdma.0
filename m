From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] [for-3.2] rdma/cm: Check for NULL conn_param in
 rdma_accept
Date: Wed, 7 Sep 2011 23:26:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E5A0AE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check that conn_param is not null before dereferencing it
when processing rdma_accept().  This is necessary to prevent
a possible system crash, which can be invoked by user space.

Problem found by code inspection.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   38 +++++++++++++++++++++++---------------
 1 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..dc617cb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2612,14 +2612,16 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 	if (ret)
 		goto out;
 
-	iw_param.ord = conn_param->initiator_depth;
-	iw_param.ird = conn_param->responder_resources;
-	iw_param.private_data = conn_param->private_data;
-	iw_param.private_data_len = conn_param->private_data_len;
-	if (id_priv->id.qp)
+	if (conn_param) {
+		iw_param.ord = conn_param->initiator_depth;
+		iw_param.ird = conn_param->responder_resources;
+		iw_param.private_data = conn_param->private_data;
+		iw_param.private_data_len = conn_param->private_data_len;
+		iw_param.qpn = id_priv->id.qp ? id_priv->qp_num : conn_param->qp_num;
+	} else {
+		memset(&iw_param, 0, sizeof iw_param);
 		iw_param.qpn = id_priv->qp_num;
-	else
-		iw_param.qpn = conn_param->qp_num;
+	}
 	ret = iw_cm_connect(cm_id, &iw_param);
 out:
 	if (ret && !IS_ERR(cm_id)) {
@@ -2761,14 +2763,20 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 	switch (rdma_node_get_transport(id->device->node_type)) {
 	case RDMA_TRANSPORT_IB:
-		if (id->qp_type == IB_QPT_UD)
-			ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
-						conn_param->private_data,
-						conn_param->private_data_len);
-		else if (conn_param)
-			ret = cma_accept_ib(id_priv, conn_param);
-		else
-			ret = cma_rep_recv(id_priv);
+		if (id->qp_type == IB_QPT_UD) {
+			if (conn_param)
+				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
+							conn_param->private_data,
+							conn_param->private_data_len);
+			else
+				ret = cma_send_sidr_rep(id_priv, IB_SIDR_SUCCESS,
+							NULL, 0);
+		} else {
+			if (conn_param)
+				ret = cma_accept_ib(id_priv, conn_param);
+			else
+				ret = cma_rep_recv(id_priv);
+		}
 		break;
 	case RDMA_TRANSPORT_IWARP:
 		ret = cma_accept_iw(id_priv, conn_param);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
