From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 22/22] xprtrdma: Eliminate rpcrdma_receive_worker()
Date: Mon, 15 Aug 2016 16:53:13 -0400
Message-ID: <20160815205313.11652.36247.stgit@manet.1015granger.net>
References: <20160815195649.11652.32252.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160815195649.11652.32252.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: the extra layer of indirection doesn't add value.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |    4 +++-
 net/sunrpc/xprtrdma/verbs.c     |   11 +----------
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 +-
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index e125a86..40bd4b4 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1045,8 +1045,10 @@ rpcrdma_conn_func(struct rpcrdma_ep *ep)
  * allowed to timeout, to discover the errors at that time.
  */
 void
-rpcrdma_reply_handler(struct rpcrdma_rep *rep)
+rpcrdma_reply_handler(struct work_struct *work)
 {
+	struct rpcrdma_rep *rep =
+			container_of(work, struct rpcrdma_rep, rr_work);
 	struct rpcrdma_msg *headerp;
 	struct rpcrdma_req *req;
 	struct rpc_rqst *rqst;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index ef7177a..c2dc0f7 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -128,15 +128,6 @@ rpcrdma_wc_send(struct ib_cq *cq, struct ib_wc *wc)
 		       wc->status, wc->vendor_err);
 }
 
-static void
-rpcrdma_receive_worker(struct work_struct *work)
-{
-	struct rpcrdma_rep *rep =
-			container_of(work, struct rpcrdma_rep, rr_work);
-
-	rpcrdma_reply_handler(rep);
-}
-
 /* Perform basic sanity checking to avoid using garbage
  * to update the credit grant value.
  */
@@ -919,7 +910,7 @@ rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt)
 	rep->rr_device = ia->ri_device;
 	rep->rr_cqe.done = rpcrdma_wc_receive;
 	rep->rr_rxprt = r_xprt;
-	INIT_WORK(&rep->rr_work, rpcrdma_receive_worker);
+	INIT_WORK(&rep->rr_work, rpcrdma_reply_handler);
 	rep->rr_recv_wr.next = NULL;
 	rep->rr_recv_wr.wr_cqe = &rep->rr_cqe;
 	rep->rr_recv_wr.sg_list = &rep->rr_rdmabuf->rg_iov;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index f90da22..f062f7d 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -534,7 +534,7 @@ rpcrdma_data_dir(bool writing)
  */
 void rpcrdma_connect_worker(struct work_struct *);
 void rpcrdma_conn_func(struct rpcrdma_ep *);
-void rpcrdma_reply_handler(struct rpcrdma_rep *);
+void rpcrdma_reply_handler(struct work_struct *);
 
 /*
  * RPC/RDMA protocol calls - xprtrdma/rpc_rdma.c

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
