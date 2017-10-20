From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/9] xprtrdma: Add a field of bit flags to struct rpcrdma_req
Date: Fri, 20 Oct 2017 10:48:20 -0400
Message-ID: <20171020144820.14869.25259.stgit@manet.1015granger.net>
References: <20171020143635.14869.15714.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020143635.14869.15714.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have one boolean flag in rpcrdma_req today. I'd like to add more
flags, so convert that boolean to a bit flag.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/backchannel.c |    2 +-
 net/sunrpc/xprtrdma/transport.c   |    2 +-
 net/sunrpc/xprtrdma/verbs.c       |    1 -
 net/sunrpc/xprtrdma/xprt_rdma.h   |    7 ++++++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/backchannel.c b/net/sunrpc/xprtrdma/backchannel.c
index f0d5998..088c9cc 100644
--- a/net/sunrpc/xprtrdma/backchannel.c
+++ b/net/sunrpc/xprtrdma/backchannel.c
@@ -42,7 +42,7 @@ static int rpcrdma_bc_setup_rqst(struct rpcrdma_xprt *r_xprt,
 	req = rpcrdma_create_req(r_xprt);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-	req->rl_backchannel = true;
+	__set_bit(RPCRDMA_REQ_F_BACKCHANNEL, &req->rl_flags);
 
 	rb = rpcrdma_alloc_regbuf(RPCRDMA_HDRBUF_SIZE,
 				  DMA_TO_DEVICE, GFP_KERNEL);
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index cb764fb..74f3cef 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -680,7 +680,7 @@
 	struct rpcrdma_req *req = rpcr_to_rdmar(rqst);
 	struct rpcrdma_ia *ia = &r_xprt->rx_ia;
 
-	if (req->rl_backchannel)
+	if (test_bit(RPCRDMA_REQ_F_BACKCHANNEL, &req->rl_flags))
 		return;
 
 	dprintk("RPC:       %s: called on 0x%p\n", __func__, req->rl_reply);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 1bf7b1e..bab63ad 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1167,7 +1167,6 @@ struct rpcrdma_rep *
 			rc = PTR_ERR(req);
 			goto out;
 		}
-		req->rl_backchannel = false;
 		list_add(&req->rl_list, &buf->rb_send_bufs);
 	}
 
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 537cfab..4175320 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -377,12 +377,17 @@ struct rpcrdma_req {
 	struct rpcrdma_regbuf	*rl_recvbuf;	/* rq_rcv_buf */
 
 	struct list_head	rl_all;
-	bool			rl_backchannel;
+	unsigned long		rl_flags;
 
 	struct list_head	rl_registered;	/* registered segments */
 	struct rpcrdma_mr_seg	rl_segments[RPCRDMA_MAX_SEGS];
 };
 
+/* rl_flags */
+enum {
+	RPCRDMA_REQ_F_BACKCHANNEL = 0,
+};
+
 static inline void
 rpcrdma_set_xprtdata(struct rpc_rqst *rqst, struct rpcrdma_req *req)
 {

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
