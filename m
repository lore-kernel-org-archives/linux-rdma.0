From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/5] xprtrdma: Shrink send SGEs array
Date: Mon, 23 Jan 2017 15:53:19 -0500
Message-ID: <20170123205319.21699.50374.stgit@manet.1015granger.net>
References: <20170123205159.21699.47373.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170123205159.21699.47373.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We no longer need to accommodate an xdr_buf whose pages start at an
offset and cross extra page boundaries. If there are more partial or
whole pages to send than there are available SGEs, the marshaling
logic is now smart enough to use a Read chunk instead of failing.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/xprt_rdma.h |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 3d7e9c9..852dd0a 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -305,16 +305,19 @@ struct rpcrdma_mr_seg {		/* chunk descriptors */
 	char		*mr_offset;	/* kva if no page, else offset */
 };
 
-/* Reserve enough Send SGEs to send a maximum size inline request:
+/* The Send SGE array is provisioned to send a maximum size
+ * inline request:
  * - RPC-over-RDMA header
  * - xdr_buf head iovec
- * - RPCRDMA_MAX_INLINE bytes, possibly unaligned, in pages
+ * - RPCRDMA_MAX_INLINE bytes, in pages
  * - xdr_buf tail iovec
+ *
+ * The actual number of array elements consumed by each RPC
+ * depends on the device's max_sge limit.
  */
 enum {
 	RPCRDMA_MIN_SEND_SGES = 3,
-	RPCRDMA_MAX_SEND_PAGES = PAGE_SIZE + RPCRDMA_MAX_INLINE - 1,
-	RPCRDMA_MAX_PAGE_SGES = (RPCRDMA_MAX_SEND_PAGES >> PAGE_SHIFT) + 1,
+	RPCRDMA_MAX_PAGE_SGES = RPCRDMA_MAX_INLINE >> PAGE_SHIFT,
 	RPCRDMA_MAX_SEND_SGES = 1 + 1 + RPCRDMA_MAX_PAGE_SGES + 1,
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
