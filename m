From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/17] rdma/cm: Support XRC QPs
Date: Wed, 15 Jun 2011 06:28:05 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021046@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow users to connect XRC QPs through the rdma_cm.  Because
XRC QPs connect INI -> TGT QPs, we need to convert from the local
qp type to the destination qp type when calling the ib_cm.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d9b18f5..3017888 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2464,6 +2464,14 @@ out:
 	return ret;
 }
 
+static enum ib_qp_type cma_get_dest_qpt(struct rdma_id_private *id_priv)
+{
+	if (id_priv->id.qp_type == IB_QPT_XRC_INI)
+		return IB_QPT_XRC_TGT;
+
+	return id_priv->id.qp_type;
+}
+
 static int cma_connect_ib(struct rdma_id_private *id_priv,
 			  struct rdma_conn_param *conn_param)
 {
@@ -2503,7 +2511,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.service_id = cma_get_service_id(id_priv->id.ps,
 					    (struct sockaddr *) &route->addr.dst_addr);
 	req.qp_num = id_priv->qp_num;
-	req.qp_type = IB_QPT_RC;
+	req.qp_type = cma_get_dest_qpt(id_priv);
 	req.starting_psn = id_priv->seq_num;
 	req.responder_resources = conn_param->responder_resources;
 	req.initiator_depth = conn_param->initiator_depth;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
