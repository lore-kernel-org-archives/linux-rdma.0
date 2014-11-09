From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 03/10] xprtrdma: unmap all FMRs during transport
 disconnect
Date: Sat, 08 Nov 2014 20:14:29 -0500
Message-ID: <20141109011429.8806.34346.stgit@manet.1015granger.net>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109010328.8806.5861.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When using RPCRDMA_MTHCAFMR memory registration, after a few
transport disconnect / reconnect cycles, ib_map_phys_fmr() starts to
return EINVAL because the provider has exhausted its map pool.

Make sure that all FMRs are unmapped during transport disconnect,
and that ->send_request remarshals them during an RPC retransmit.
This resets the transport's MRs to ensure that none are leaked
during a disconnect.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |    2 +-
 net/sunrpc/xprtrdma/verbs.c     |   42 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 6a4615d..cfe9a81 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -599,7 +599,7 @@ xprt_rdma_send_request(struct rpc_task *task)
 
 	if (req->rl_niovs == 0)
 		rc = rpcrdma_marshal_req(rqst);
-	else if (r_xprt->rx_ia.ri_memreg_strategy == RPCRDMA_FRMR)
+	else if (r_xprt->rx_ia.ri_memreg_strategy != RPCRDMA_ALLPHYSICAL)
 		rc = rpcrdma_marshal_chunks(rqst, 0);
 	if (rc < 0)
 		goto failed_marshal;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index af45cf3..3c88276 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -62,6 +62,7 @@
 #endif
 
 static void rpcrdma_reset_frmrs(struct rpcrdma_ia *);
+static void rpcrdma_reset_fmrs(struct rpcrdma_ia *);
 
 /*
  * internal functions
@@ -868,8 +869,19 @@ retry:
 		rpcrdma_ep_disconnect(ep, ia);
 		rpcrdma_flush_cqs(ep);
 
-		if (ia->ri_memreg_strategy == RPCRDMA_FRMR)
+		switch (ia->ri_memreg_strategy) {
+		case RPCRDMA_FRMR:
 			rpcrdma_reset_frmrs(ia);
+			break;
+		case RPCRDMA_MTHCAFMR:
+			rpcrdma_reset_fmrs(ia);
+			break;
+		case RPCRDMA_ALLPHYSICAL:
+			break;
+		default:
+			rc = -EIO;
+			goto out;
+		}
 
 		xprt = container_of(ia, struct rpcrdma_xprt, rx_ia);
 		id = rpcrdma_create_id(xprt, ia,
@@ -1289,6 +1301,34 @@ rpcrdma_buffer_destroy(struct rpcrdma_buffer *buf)
 	kfree(buf->rb_pool);
 }
 
+/* After a disconnect, unmap all FMRs.
+ *
+ * This is invoked only in the transport connect worker in order
+ * to serialize with rpcrdma_register_fmr_external().
+ */
+static void
+rpcrdma_reset_fmrs(struct rpcrdma_ia *ia)
+{
+	struct rpcrdma_xprt *r_xprt =
+				container_of(ia, struct rpcrdma_xprt, rx_ia);
+	struct rpcrdma_buffer *buf = &r_xprt->rx_buf;
+	struct list_head *pos;
+	struct rpcrdma_mw *r;
+	LIST_HEAD(l);
+	int rc;
+
+	list_for_each(pos, &buf->rb_all) {
+		r = list_entry(pos, struct rpcrdma_mw, mw_all);
+
+		INIT_LIST_HEAD(&l);
+		list_add(&r->r.fmr->list, &l);
+		rc = ib_unmap_fmr(&l);
+		if (rc)
+			dprintk("RPC:       %s: ib_unmap_fmr failed %i\n",
+				__func__, rc);
+	}
+}
+
 /* After a disconnect, a flushed FAST_REG_MR can leave an FRMR in
  * an unusable state. Find FRMRs in this state and dereg / reg
  * each.  FRMRs that are VALID and attached to an rpcrdma_req are

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
