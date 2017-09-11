From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 6/7] xprtrdma: RPC completion should wait for Send
 completion
Date: Mon, 11 Sep 2017 11:19:09 -0400
Message-ID: <150514314437.1307.10484802178999487640.stgit@lebasque.1015granger.net>
References: <150514269466.1307.1991885208569456320.stgit@lebasque.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <150514269466.1307.1991885208569456320.stgit-NCCkF8GxsaM6WJ89mGctdJimSvn7F7xT@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When an RPC Call includes a file data payload, that payload can come
from pages in the page cache, or a user buffer (for direct I/O).

If the payload can fit inline, xprtrdma includes it in the Send
using a scatter-gather technique. xprtrdma mustn't allow the RPC
consumer to re-use the memory where that payload resides before the
Send completes. Otherwise, the new contents of that memory would be
exposed by an HCA retransmit of the Send operation.

So, block RPC completion on Send completion, but only in the case
where a separate file data payload is part of the Send. This
prevents the reuse of that memory while it is still part of a Send
operation without an undue cost to other cases.

Typically, waiting is avoided anyway, because typically the Send
will have completed long before the RPC Reply arrives.

These days, an RPC timeout will trigger a disconnect, which tears
down the QP. The disconnect flushes all waiting Sends. This bounds
the amount of time the reply handler has to wait for a Send
completion.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |   15 +++++++++++++++
 net/sunrpc/xprtrdma/transport.c |    5 +++--
 net/sunrpc/xprtrdma/verbs.c     |    3 ++-
 net/sunrpc/xprtrdma/xprt_rdma.h |    2 ++
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 8e71d03..9624171 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -641,6 +641,7 @@ rpcrdma_prepare_msg_sges(struct rpcrdma_ia *ia, struct rpcrdma_req *req,
 out:
 	sc->sc_wr.num_sge += sge_no;
 	sc->sc_unmap_count = sge_no - 1;
+	reinit_completion(&sc->sc_done);
 	sc->sc_device = device;
 	return true;
 
@@ -707,6 +708,7 @@ __rpcrdma_unmap_send_sges(struct rpcrdma_sendctx *sc)
 	for (count = sc->sc_unmap_count; count; ++sge, --count)
 		ib_dma_unmap_page(sc->sc_device, sge->addr, sge->length,
 				  DMA_TO_DEVICE);
+	complete(&sc->sc_done);
 }
 
 /**
@@ -1310,6 +1312,19 @@ rpcrdma_reply_handler(struct work_struct *work)
 	if (!list_empty(&mws))
 		r_xprt->rx_ia.ri_ops->ro_unmap_sync(r_xprt, &mws);
 
+	/* Ensure that any DMA mapped pages associated with
+	 * the Send of the RPC Call have been unmapped before
+	 * allowing the RPC to complete. This protects argument
+	 * memory not controlled by the RPC client from being
+	 * re-used before we're done with it.
+	 *
+	 * Waiting here will be exceptionally infrequent.
+	 */
+	if (unlikely(req->rl_sendctx->sc_unmap_count)) {
+		wait_for_completion(&req->rl_sendctx->sc_done);
+		r_xprt->rx_stats.reply_waits_for_send++;
+	}
+
 	/* Perform XID lookup, reconstruction of the RPC reply, and
 	 * RPC completion while holding the transport lock to ensure
 	 * the rep, rqst, and rq_task pointers remain stable.
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 4cca4a7..3a285ea 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -789,12 +789,13 @@ void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 		   r_xprt->rx_stats.failed_marshal_count,
 		   r_xprt->rx_stats.bad_reply_count,
 		   r_xprt->rx_stats.nomsg_call_count);
-	seq_printf(seq, "%lu %lu %lu %lu %lu\n",
+	seq_printf(seq, "%lu %lu %lu %lu %lu %lu\n",
 		   r_xprt->rx_stats.mrs_recovered,
 		   r_xprt->rx_stats.mrs_orphaned,
 		   r_xprt->rx_stats.mrs_allocated,
 		   r_xprt->rx_stats.local_inv_needed,
-		   r_xprt->rx_stats.empty_sendctx_q);
+		   r_xprt->rx_stats.empty_sendctx_q,
+		   r_xprt->rx_stats.reply_waits_for_send);
 }
 
 static int
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 3409de8..de26ecf 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -893,6 +893,7 @@ static struct rpcrdma_sendctx *rpcrdma_sendctx_create(unsigned int max_sges)
 	sc->sc_wr.sg_list = sc->sc_sges;
 	sc->sc_wr.opcode = IB_WR_SEND;
 	sc->sc_cqe.done = rpcrdma_wc_send;
+	init_completion(&sc->sc_done);
 	return sc;
 }
 
@@ -1548,7 +1549,7 @@ rpcrdma_ep_post(struct rpcrdma_ia *ia,
 	dprintk("RPC:       %s: posting %d s/g entries\n",
 		__func__, send_wr->num_sge);
 
-	if (!ep->rep_send_count) {
+	if (!ep->rep_send_count || sc->sc_unmap_count) {
 		send_wr->send_flags |= IB_SEND_SIGNALED;
 		ep->rep_send_count = ep->rep_send_batch;
 	} else {
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 64cfc11..6bb7054 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -241,6 +241,7 @@ struct rpcrdma_sendctx {
 	struct rpcrdma_buffer		*sc_buffers;
 
 	unsigned int			sc_unmap_count;
+	struct completion		sc_done;
 	struct ib_device		*sc_device;
 	struct ib_sge			sc_sges[];
 };
@@ -488,6 +489,7 @@ struct rpcrdma_stats {
 	/* accessed when receiving a reply */
 	unsigned long long	total_rdma_reply;
 	unsigned long long	fixup_copy_count;
+	unsigned long		reply_waits_for_send;
 	unsigned long		local_inv_needed;
 	unsigned long		nomsg_call_count;
 	unsigned long		bcall_count;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
