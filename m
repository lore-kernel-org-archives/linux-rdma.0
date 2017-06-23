From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 06/18] svcrdma: Improve Write chunk sanity checking
Date: Fri, 23 Jun 2017 17:17:52 -0400
Message-ID: <20170623211752.5162.17651.stgit@klimt.1015granger.net>
References: <20170623211150.5162.59075.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170623211150.5162.59075.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Identify malformed transport headers and unsupported chunk
combinations as early as possible.

- Reject RPC-over-RDMA messages that contain more than one Write
chunk, since this implementation does not support more than one per
message.

- Ensure that segment lengths are not crazy.

- Ensure that the chunk's segment count is not crazy.

With a 1KB inline threshold, the largest number of Write segments
that can be conveyed is about 60 (for a RDMA_NOMSG Reply message).

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   52 ++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 885ad95..cf8be18 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -117,6 +117,11 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 	rqstp->rq_arg.tail[0].iov_len = 0;
 }
 
+/* This accommodates the largest possible Write chunk,
+ * in one segment.
+ */
+#define MAX_BYTES_WRITE_SEG	((u32)(RPCSVC_MAXPAGES << PAGE_SHIFT))
+
 /* This accommodates the largest possible Position-Zero
  * Read chunk or Reply chunk, in one segment.
  */
@@ -162,15 +167,52 @@ static __be32 *xdr_check_read_list(__be32 *p, const __be32 *end)
 	return p;
 }
 
-static __be32 *xdr_check_write_list(__be32 *p, __be32 *end)
+/* The segment count is limited to how many segments can
+ * fit in the transport header without overflowing the
+ * buffer. That's about 60 Write segments for a 1KB inline
+ * threshold.
+ */
+static __be32 *xdr_check_write_chunk(__be32 *p, const __be32 *end,
+				     u32 maxlen)
 {
-	__be32 *next;
+	u32 i, segcount;
+
+	segcount = be32_to_cpup(p++);
+	for (i = 0; i < segcount; i++) {
+		p++;	/* handle */
+		if (be32_to_cpup(p++) > maxlen)
+			return NULL;
+		p += 2;	/* offset */
+
+		if (p > end)
+			return NULL;
+	}
+
+	return p;
+}
 
+/* Sanity check the Write list.
+ *
+ * Implementation limits:
+ * - This implementation supports only one Write chunk.
+ *
+ * Sanity checks:
+ * - Write list does not overflow buffer.
+ * - Segment size limited by largest NFS data payload.
+ *
+ * Returns pointer to the following Reply chunk.
+ */
+static __be32 *xdr_check_write_list(__be32 *p, const __be32 *end)
+{
+	u32 chcount;
+
+	chcount = 0;
 	while (*p++ != xdr_zero) {
-		next = p + 1 + be32_to_cpup(p) * rpcrdma_segment_maxsz;
-		if (next > end)
+		p = xdr_check_write_chunk(p, end, MAX_BYTES_WRITE_SEG);
+		if (!p)
+			return NULL;
+		if (chcount++ > 1)
 			return NULL;
-		p = next;
 	}
 	return p;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
