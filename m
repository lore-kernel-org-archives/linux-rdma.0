From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IPoIB: Modify QP to error only if not in reset
Date: Thu, 17 Mar 2011 14:13:42 +0200
Message-ID: <20110317121341.GA7985@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ronniz-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

An ipoib interface may be moved UP but its QP may still not be modified to a
state higher than IB_QPS_RESET since it did not find the pkey assigned to it in
the port. When we later call ipoib_ib_dev_stop() the modification to IB_QPS_ERR
will fail and warning message printed. The problem can be reproduced easily in
the following stpes:
- Create a child interface using a pkey that does not exist in the port's table
- Confiugre an IP address for the child interface
- delete the child interface

This patch queries the QP before attempting to modify it.

Found by: Ronni Zimmermann  <ronniz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 806d029..ceff2bc 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -806,6 +806,8 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	unsigned long begin;
 	struct ipoib_tx_buf *tx_req;
 	int i;
+	struct ib_qp_init_attr qp_init_attr;
+	int err;
 
 	if (test_and_clear_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
 		napi_disable(&priv->napi);
@@ -813,12 +815,24 @@ int ipoib_ib_dev_stop(struct net_device *dev, int flush)
 	ipoib_cm_dev_stop(dev);
 
 	/*
+	 * if we fail to query the QP we continue as if it was in
+	 * a state different than RESET so we carry any cleanup possible
+	 */
+	err = ib_query_qp(priv->qp, &qp_attr, IB_QP_CUR_STATE, &qp_init_attr);
+	if (err) {
+		ipoib_warn(priv, "Failed to query QP state, err %d\n", err);
+		qp_attr.cur_qp_state = IB_QPS_INIT;
+	}
+
+	/*
 	 * Move our QP to the error state and then reinitialize in
 	 * when all work requests have completed or have been flushed.
 	 */
-	qp_attr.qp_state = IB_QPS_ERR;
-	if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
-		ipoib_warn(priv, "Failed to modify QP to ERROR state\n");
+	if (qp_attr.cur_qp_state != IB_QPS_RESET) {
+		qp_attr.qp_state = IB_QPS_ERR;
+		if (ib_modify_qp(priv->qp, &qp_attr, IB_QP_STATE))
+			ipoib_warn(priv, "Failed to modify QP to ERROR state\n");
+	}
 
 	/* Wait for all sends and receives to complete */
 	begin = jiffies;
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
