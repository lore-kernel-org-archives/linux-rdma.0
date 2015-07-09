From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 12/12] xprtrdma: Count RDMA_NOMSG type calls
Date: Thu, 09 Jul 2015 16:43:34 -0400
Message-ID: <20150709204334.26247.11629.stgit@manet.1015granger.net>
References: <20150709203242.26247.4848.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150709203242.26247.4848.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

RDMA_NOMSG type calls are less efficient than RDMA_MSG. Count NOMSG
calls so administrators can tell if they happen to be used more than
expected.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c  |    1 +
 net/sunrpc/xprtrdma/transport.c |    5 +++--
 net/sunrpc/xprtrdma/xprt_rdma.h |    1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 64fc4b4..7c8808d 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -498,6 +498,7 @@ rpcrdma_marshal_req(struct rpc_rqst *rqst)
 	} else if (rqst->rq_snd_buf.flags & XDRBUF_WRITE) {
 		rtype = rpcrdma_readch;
 	} else {
+		r_xprt->rx_stats.nomsg_call_count++;
 		headerp->rm_type = htonl(RDMA_NOMSG);
 		rtype = rpcrdma_areadch;
 		rpclen = 0;
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 0985b2b..64443eb 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -659,7 +659,7 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 		   xprt->stat.bad_xids,
 		   xprt->stat.req_u,
 		   xprt->stat.bklog_u);
-	seq_printf(seq, "%lu %lu %lu %llu %llu %llu %llu %lu %lu %lu\n",
+	seq_printf(seq, "%lu %lu %lu %llu %llu %llu %llu %lu %lu %lu %lu\n",
 		   r_xprt->rx_stats.read_chunk_count,
 		   r_xprt->rx_stats.write_chunk_count,
 		   r_xprt->rx_stats.reply_chunk_count,
@@ -669,7 +669,8 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 		   r_xprt->rx_stats.fixup_copy_count,
 		   r_xprt->rx_stats.hardway_register_count,
 		   r_xprt->rx_stats.failed_marshal_count,
-		   r_xprt->rx_stats.bad_reply_count);
+		   r_xprt->rx_stats.bad_reply_count,
+		   r_xprt->rx_stats.nomsg_call_count);
 }
 
 static int
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 90da480..566c60b 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -342,6 +342,7 @@ struct rpcrdma_stats {
 	unsigned long		hardway_register_count;
 	unsigned long		failed_marshal_count;
 	unsigned long		bad_reply_count;
+	unsigned long		nomsg_call_count;
 };
 
 /*

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
