From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 07/13] xprtrdma: Refactor rpcrdma_ep_connect
Date: Mon, 27 Mar 2017 10:06:31 -0400
Message-ID: <20170327140631.20813.34587.stgit@manet.1015granger.net>
References: <20170327134847.20813.52412.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170327134847.20813.52412.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm about to add another arm to

    if (ep->rep_connected != 0)

It will be cleaner to use a switch statement here. We'll be looking
for a couple of specific errnos, or "anything else," basically to
sort out the difference between a normal reconnect and recovery from
device removal.

This is a refactoring change only.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c |  109 +++++++++++++++++++++++++------------------
 1 file changed, 63 insertions(+), 46 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 938fd9e..6479ad3 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -711,6 +711,57 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 	ib_free_cq(ep->rep_attr.send_cq);
 }
 
+static int
+rpcrdma_ep_reconnect(struct rpcrdma_xprt *r_xprt, struct rpcrdma_ep *ep,
+		     struct rpcrdma_ia *ia)
+{
+	struct sockaddr *sap = (struct sockaddr *)&r_xprt->rx_data.addr;
+	struct rdma_cm_id *id, *old;
+	int err, rc;
+
+	dprintk("RPC:       %s: reconnecting...\n", __func__);
+
+	rpcrdma_ep_disconnect(ep, ia);
+
+	rc = -EHOSTUNREACH;
+	id = rpcrdma_create_id(r_xprt, ia, sap);
+	if (IS_ERR(id))
+		goto out;
+
+	/* As long as the new ID points to the same device as the
+	 * old ID, we can reuse the transport's existing PD and all
+	 * previously allocated MRs. Also, the same device means
+	 * the transport's previous DMA mappings are still valid.
+	 *
+	 * This is a sanity check only. There should be no way these
+	 * point to two different devices here.
+	 */
+	old = id;
+	rc = -ENETUNREACH;
+	if (ia->ri_device != id->device) {
+		pr_err("rpcrdma: can't reconnect on different device!\n");
+		goto out_destroy;
+	}
+
+	err = rdma_create_qp(id, ia->ri_pd, &ep->rep_attr);
+	if (err) {
+		dprintk("RPC:       %s: rdma_create_qp returned %d\n",
+			__func__, err);
+		goto out_destroy;
+	}
+
+	/* Atomically replace the transport's ID and QP. */
+	rc = 0;
+	old = ia->ri_id;
+	ia->ri_id = id;
+	rdma_destroy_qp(old);
+
+out_destroy:
+	rpcrdma_destroy_id(old);
+out:
+	return rc;
+}
+
 /*
  * Connect unconnected endpoint.
  */
@@ -719,61 +770,25 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 {
 	struct rpcrdma_xprt *r_xprt = container_of(ia, struct rpcrdma_xprt,
 						   rx_ia);
-	struct rdma_cm_id *id, *old;
-	struct sockaddr *sap;
 	unsigned int extras;
-	int rc = 0;
+	int rc;
 
-	if (ep->rep_connected != 0) {
 retry:
-		dprintk("RPC:       %s: reconnecting...\n", __func__);
-
-		rpcrdma_ep_disconnect(ep, ia);
-
-		sap = (struct sockaddr *)&r_xprt->rx_data.addr;
-		id = rpcrdma_create_id(r_xprt, ia, sap);
-		if (IS_ERR(id)) {
-			rc = -EHOSTUNREACH;
-			goto out;
-		}
-		/* TEMP TEMP TEMP - fail if new device:
-		 * Deregister/remarshal *all* requests!
-		 * Close and recreate adapter, pd, etc!
-		 * Re-determine all attributes still sane!
-		 * More stuff I haven't thought of!
-		 * Rrrgh!
-		 */
-		if (ia->ri_device != id->device) {
-			printk("RPC:       %s: can't reconnect on "
-				"different device!\n", __func__);
-			rpcrdma_destroy_id(id);
-			rc = -ENETUNREACH;
-			goto out;
-		}
-		/* END TEMP */
-		rc = rdma_create_qp(id, ia->ri_pd, &ep->rep_attr);
-		if (rc) {
-			dprintk("RPC:       %s: rdma_create_qp failed %i\n",
-				__func__, rc);
-			rpcrdma_destroy_id(id);
-			rc = -ENETUNREACH;
-			goto out;
-		}
-
-		old = ia->ri_id;
-		ia->ri_id = id;
-
-		rdma_destroy_qp(old);
-		rpcrdma_destroy_id(old);
-	} else {
+	switch (ep->rep_connected) {
+	case 0:
 		dprintk("RPC:       %s: connecting...\n", __func__);
 		rc = rdma_create_qp(ia->ri_id, ia->ri_pd, &ep->rep_attr);
 		if (rc) {
 			dprintk("RPC:       %s: rdma_create_qp failed %i\n",
 				__func__, rc);
-			/* do not update ep->rep_connected */
-			return -ENETUNREACH;
+			rc = -ENETUNREACH;
+			goto out_noupdate;
 		}
+		break;
+	default:
+		rc = rpcrdma_ep_reconnect(r_xprt, ep, ia);
+		if (rc)
+			goto out;
 	}
 
 	ep->rep_connected = 0;
@@ -801,6 +816,8 @@ static void rpcrdma_destroy_id(struct rdma_cm_id *id)
 out:
 	if (rc)
 		ep->rep_connected = rc;
+
+out_noupdate:
 	return rc;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
