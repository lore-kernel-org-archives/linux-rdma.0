From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/19] svcrdma: Improve Read chunk sanity checking
Date: Fri, 16 Jun 2017 11:21:01 -0400
Message-ID: <20170616152101.14210.10781.stgit@klimt.1015granger.net>
References: <20170616151535.14210.34926.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170616151535.14210.34926.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Identify malformed transport headers and unsupported chunk
combinations as early as possible.

- Reject RPC-over-RDMA messages that contain more than one Read chunk,
  since this implementation currently does not support more than one
  per RPC transaction.

- Ensure that segment lengths are not crazy.

- Remove the segment count check. With a 1KB inline threshold, the
  largest number of Read segments that can be conveyed is about 40
  (for a RDMA_NOMSG Call message). This is nowhere near
  RPCSVC_MAXPAGES. As far as I can tell, that was just a sanity
  check and does not enforce an implementation limit.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   55 +++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 55ad335..885ad95 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -117,15 +117,47 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 	rqstp->rq_arg.tail[0].iov_len = 0;
 }
 
-static __be32 *xdr_check_read_list(__be32 *p, __be32 *end)
+/* This accommodates the largest possible Position-Zero
+ * Read chunk or Reply chunk, in one segment.
+ */
+#define MAX_BYTES_SPECIAL_SEG	((u32)((RPCSVC_MAXPAGES + 2) << PAGE_SHIFT))
+
+/* Sanity check the Read list.
+ *
+ * Implementation limits:
+ * - This implementation supports only one Read chunk.
+ *
+ * Sanity checks:
+ * - Read list does not overflow buffer.
+ * - Segment size limited by largest NFS data payload.
+ *
+ * The segment count is limited to how many segments can
+ * fit in the transport header without overflowing the
+ * buffer. That's about 40 Read segments for a 1KB inline
+ * threshold.
+ *
+ * Returns pointer to the following Write list.
+ */
+static __be32 *xdr_check_read_list(__be32 *p, const __be32 *end)
 {
-	__be32 *next;
+	u32 position;
+	bool first;
 
+	first = true;
 	while (*p++ != xdr_zero) {
-		next = p + rpcrdma_readchunk_maxsz - 1;
-		if (next > end)
+		if (first) {
+			position = be32_to_cpup(p++);
+			first = false;
+		} else if (be32_to_cpup(p++) != position) {
+			return NULL;
+		}
+		p++;	/* handle */
+		if (be32_to_cpup(p++) > MAX_BYTES_SPECIAL_SEG)
+			return NULL;
+		p += 2;	/* offset */
+
+		if (p > end)
 			return NULL;
-		p = next;
 	}
 	return p;
 }
@@ -478,16 +510,6 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	return ret;
 }
 
-static unsigned int
-rdma_rcl_chunk_count(struct rpcrdma_read_chunk *ch)
-{
-	unsigned int count;
-
-	for (count = 0; ch->rc_discrim != xdr_zero; ch++)
-		count++;
-	return count;
-}
-
 /* If there was additional inline content, append it to the end of arg.pages.
  * Tail copy has to be done after the reader function has determined how many
  * pages are needed for RDMA READ.
@@ -567,9 +589,6 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	if (!ch)
 		return 0;
 
-	if (rdma_rcl_chunk_count(ch) > RPCSVC_MAXPAGES)
-		return -EINVAL;
-
 	/* The request is completed when the RDMA_READs complete. The
 	 * head context keeps all the pages that comprise the
 	 * request.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
