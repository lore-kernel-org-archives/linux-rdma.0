From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/6] xprtrdma: Fix "bytes registered" accounting
Date: Wed, 03 Jan 2018 15:38:09 -0500
Message-ID: <20180103203809.29209.43874.stgit@manet.1015granger.net>
References: <20180103203540.29209.4620.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103203540.29209.4620.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The contents of seg->mr_len changed when ->ro_map stopped returning
the full chunk length in the first segment. Count the full length of
each Write chunk, not the length of the first segment (which now can
only be as large as a page).

Fixes: 9d6b04097882 ("xprtrdma: Place registered MWs on a ... ")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 1ae9b41..162e5dd 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -431,7 +431,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 
 		trace_xprtrdma_write_chunk(rqst->rq_task, mr, nsegs);
 		r_xprt->rx_stats.write_chunk_count++;
-		r_xprt->rx_stats.total_rdma_request += seg->mr_len;
+		r_xprt->rx_stats.total_rdma_request += mr->mr_length;
 		nchunks++;
 		nsegs -= mr->mr_nents;
 	} while (nsegs);
@@ -489,7 +489,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 
 		trace_xprtrdma_reply_chunk(rqst->rq_task, mr, nsegs);
 		r_xprt->rx_stats.reply_chunk_count++;
-		r_xprt->rx_stats.total_rdma_request += seg->mr_len;
+		r_xprt->rx_stats.total_rdma_request += mr->mr_length;
 		nchunks++;
 		nsegs -= mr->mr_nents;
 	} while (nsegs);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
