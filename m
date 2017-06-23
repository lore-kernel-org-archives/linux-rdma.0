From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 07/18] svcrdma: Improve Reply chunk sanity checking
Date: Fri, 23 Jun 2017 17:18:00 -0400
Message-ID: <20170623211800.5162.79794.stgit@klimt.1015granger.net>
References: <20170623211150.5162.59075.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623211150.5162.59075.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Identify malformed transport headers and unsupported chunk
combinations as early as possible.

- Ensure that segment lengths are not crazy.

- Ensure that the Reply chunk's segment count is not crazy.

With a 1KB inline threshold, the largest number of Write segments
that can be conveyed is about 60 (for a RDMA_NOMSG Reply message).

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index cf8be18..b480893 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -217,15 +217,20 @@ static __be32 *xdr_check_write_list(__be32 *p, const __be32 *end)
 	return p;
 }
 
-static __be32 *xdr_check_reply_chunk(__be32 *p, __be32 *end)
+/* Sanity check the Reply chunk.
+ *
+ * Sanity checks:
+ * - Reply chunk does not overflow buffer.
+ * - Segment size limited by largest NFS data payload.
+ *
+ * Returns pointer to the following RPC header.
+ */
+static __be32 *xdr_check_reply_chunk(__be32 *p, const __be32 *end)
 {
-	__be32 *next;
-
 	if (*p++ != xdr_zero) {
-		next = p + 1 + be32_to_cpup(p) * rpcrdma_segment_maxsz;
-		if (next > end)
+		p = xdr_check_write_chunk(p, end, MAX_BYTES_SPECIAL_SEG);
+		if (!p)
 			return NULL;
-		p = next;
 	}
 	return p;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
