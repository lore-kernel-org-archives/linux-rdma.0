From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 14/22] xprtrdma: Move recv_wr to struct rpcrdma_rep
Date: Thu, 15 Sep 2016 10:56:51 -0400
Message-ID: <20160915145651.11080.57786.stgit@manet.1015granger.net>
References: <20160915143440.11080.89241.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915143440.11080.89241.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: The fields in the recv_wr do not vary. There is no need to
initialize them before each ib_post_recv(). This removes a large-ish
data structure from the stack.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/verbs.c     |   13 ++++++-------
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 79a6346..a49c788 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -880,6 +880,10 @@ rpcrdma_create_rep(struct rpcrdma_xprt *r_xprt)
 	rep->rr_cqe.done = rpcrdma_receive_wc;
 	rep->rr_rxprt = r_xprt;
 	INIT_WORK(&rep->rr_work, rpcrdma_receive_worker);
+	rep->rr_recv_wr.next = NULL;
+	rep->rr_recv_wr.wr_cqe = &rep->rr_cqe;
+	rep->rr_recv_wr.sg_list = &rep->rr_rdmabuf->rg_iov;
+	rep->rr_recv_wr.num_sge = 1;
 	return rep;
 
 out_free:
@@ -1302,17 +1306,12 @@ int
 rpcrdma_ep_post_recv(struct rpcrdma_ia *ia,
 		     struct rpcrdma_rep *rep)
 {
-	struct ib_recv_wr recv_wr, *recv_wr_fail;
+	struct ib_recv_wr *recv_wr_fail;
 	int rc;
 
-	recv_wr.next = NULL;
-	recv_wr.wr_cqe = &rep->rr_cqe;
-	recv_wr.sg_list = &rep->rr_rdmabuf->rg_iov;
-	recv_wr.num_sge = 1;
-
 	if (!rpcrdma_dma_map_regbuf(ia, rep->rr_rdmabuf))
 		goto out_map;
-	rc = ib_post_recv(ia->ri_id->qp, &recv_wr, &recv_wr_fail);
+	rc = ib_post_recv(ia->ri_id->qp, &rep->rr_recv_wr, &recv_wr_fail);
 	if (rc)
 		goto out_postrecv;
 	return 0;
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 3c5a89a..9aabca6 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -189,6 +189,7 @@ struct rpcrdma_rep {
 	struct rpcrdma_xprt	*rr_rxprt;
 	struct work_struct	rr_work;
 	struct list_head	rr_list;
+	struct ib_recv_wr	rr_recv_wr;
 	struct rpcrdma_regbuf	*rr_rdmabuf;
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
