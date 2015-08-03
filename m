From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 13/16] xprtrdma: Clean up xprt_rdma_print_stats()
Date: Mon, 03 Aug 2015 13:04:36 -0400
Message-ID: <20150803170436.9115.185.stgit@manet.1015granger.net>
References: <20150803165807.9115.23842.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150803165807.9115.23842.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

checkpatch.pl complained about the seq_printf() format string split
across lines and the use of %Lu.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Tested-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 net/sunrpc/xprtrdma/transport.c |   48 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index d737300..0985b2b 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -647,31 +647,29 @@ static void xprt_rdma_print_stats(struct rpc_xprt *xprt, struct seq_file *seq)
 	if (xprt_connected(xprt))
 		idle_time = (long)(jiffies - xprt->last_used) / HZ;
 
-	seq_printf(seq,
-	  "\txprt:\trdma %u %lu %lu %lu %ld %lu %lu %lu %Lu %Lu "
-	  "%lu %lu %lu %Lu %Lu %Lu %Lu %lu %lu %lu\n",
-
-	   0,	/* need a local port? */
-	   xprt->stat.bind_count,
-	   xprt->stat.connect_count,
-	   xprt->stat.connect_time,
-	   idle_time,
-	   xprt->stat.sends,
-	   xprt->stat.recvs,
-	   xprt->stat.bad_xids,
-	   xprt->stat.req_u,
-	   xprt->stat.bklog_u,
-
-	   r_xprt->rx_stats.read_chunk_count,
-	   r_xprt->rx_stats.write_chunk_count,
-	   r_xprt->rx_stats.reply_chunk_count,
-	   r_xprt->rx_stats.total_rdma_request,
-	   r_xprt->rx_stats.total_rdma_reply,
-	   r_xprt->rx_stats.pullup_copy_count,
-	   r_xprt->rx_stats.fixup_copy_count,
-	   r_xprt->rx_stats.hardway_register_count,
-	   r_xprt->rx_stats.failed_marshal_count,
-	   r_xprt->rx_stats.bad_reply_count);
+	seq_puts(seq, "\txprt:\trdma ");
+	seq_printf(seq, "%u %lu %lu %lu %ld %lu %lu %lu %llu %llu ",
+		   0,	/* need a local port? */
+		   xprt->stat.bind_count,
+		   xprt->stat.connect_count,
+		   xprt->stat.connect_time,
+		   idle_time,
+		   xprt->stat.sends,
+		   xprt->stat.recvs,
+		   xprt->stat.bad_xids,
+		   xprt->stat.req_u,
+		   xprt->stat.bklog_u);
+	seq_printf(seq, "%lu %lu %lu %llu %llu %llu %llu %lu %lu %lu\n",
+		   r_xprt->rx_stats.read_chunk_count,
+		   r_xprt->rx_stats.write_chunk_count,
+		   r_xprt->rx_stats.reply_chunk_count,
+		   r_xprt->rx_stats.total_rdma_request,
+		   r_xprt->rx_stats.total_rdma_reply,
+		   r_xprt->rx_stats.pullup_copy_count,
+		   r_xprt->rx_stats.fixup_copy_count,
+		   r_xprt->rx_stats.hardway_register_count,
+		   r_xprt->rx_stats.failed_marshal_count,
+		   r_xprt->rx_stats.bad_reply_count);
 }
 
 static int

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
