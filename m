From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/5] xprtrdma: Fix Read chunk padding
Date: Mon, 23 Jan 2017 15:52:46 -0500
Message-ID: <20170123205246.21699.14602.stgit@manet.1015granger.net>
References: <20170123205159.21699.47373.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170123205159.21699.47373.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When pad optimization is disabled, rpcrdma_convert_iovs still
does not add explicit XDR round-up padding to a Read chunk.

Commit 677eb17e94ed ("xprtrdma: Fix XDR tail buffer marshalling")
incorrectly short-circuited the test for whether round-up padding
is needed that appears later in rpcrdma_convert_iovs.

However, if this is indeed a Read chunk (and not a Position-Zero
Read chunk), the tail iovec _always_ contains the chunk's padding,
and never anything else.

So, it's easy to just skip the tail when padding optimization is
enabled, and add the tail in a subsequent Read chunk segment, if
disabled.

Fixes: 677eb17e94ed ("xprtrdma: Fix XDR tail buffer marshalling")
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index c52e0f2..a524d3c 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -226,8 +226,10 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	if (len && n == RPCRDMA_MAX_SEGS)
 		goto out_overflow;
 
-	/* When encoding the read list, the tail is always sent inline */
-	if (type == rpcrdma_readch)
+	/* When encoding a Read chunk, the tail iovec contains an
+	 * XDR pad and may be omitted.
+	 */
+	if (type == rpcrdma_readch && xprt_rdma_pad_optimize)
 		return n;
 
 	/* When encoding the Write list, some servers need to see an extra
@@ -238,10 +240,6 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 		return n;
 
 	if (xdrbuf->tail[0].iov_len) {
-		/* the rpcrdma protocol allows us to omit any trailing
-		 * xdr pad bytes, saving the server an RDMA operation. */
-		if (xdrbuf->tail[0].iov_len < 4 && xprt_rdma_pad_optimize)
-			return n;
 		n = rpcrdma_convert_kvec(&xdrbuf->tail[0], seg, n);
 		if (n == RPCRDMA_MAX_SEGS)
 			goto out_overflow;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
