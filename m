From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 11/12] xprtrdma: Replace PAGE_MASK with offset_in_page()
Date: Tue, 23 May 2017 10:55:07 -0400
Message-ID: <20170523145507.961.11175.stgit@manet.1015granger.net>
References: <20170523142629.961.81233.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170523142629.961.81233.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up.

Reported by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index b6584ae..ca4d6e4 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -141,7 +141,7 @@ static bool rpcrdma_args_inline(struct rpcrdma_xprt *r_xprt,
 
 	if (xdr->page_len) {
 		remaining = xdr->page_len;
-		offset = xdr->page_base & ~PAGE_MASK;
+		offset = offset_in_page(xdr->page_base);
 		count = 0;
 		while (remaining) {
 			remaining -= min_t(unsigned int,
@@ -222,7 +222,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 
 	len = xdrbuf->page_len;
 	ppages = xdrbuf->pages + (xdrbuf->page_base >> PAGE_SHIFT);
-	page_base = xdrbuf->page_base & ~PAGE_MASK;
+	page_base = offset_in_page(xdrbuf->page_base);
 	p = 0;
 	while (len && n < RPCRDMA_MAX_SEGS) {
 		if (!ppages[p]) {
@@ -540,7 +540,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 			goto out;
 
 		page = virt_to_page(xdr->tail[0].iov_base);
-		page_base = (unsigned long)xdr->tail[0].iov_base & ~PAGE_MASK;
+		page_base = offset_in_page(xdr->tail[0].iov_base);
 
 		/* If the content in the page list is an odd length,
 		 * xdr_write_pages() has added a pad at the beginning
@@ -557,7 +557,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	 */
 	if (xdr->page_len) {
 		ppages = xdr->pages + (xdr->page_base >> PAGE_SHIFT);
-		page_base = xdr->page_base & ~PAGE_MASK;
+		page_base = offset_in_page(xdr->page_base);
 		remaining = xdr->page_len;
 		while (remaining) {
 			sge_no++;
@@ -587,7 +587,7 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	 */
 	if (xdr->tail[0].iov_len) {
 		page = virt_to_page(xdr->tail[0].iov_base);
-		page_base = (unsigned long)xdr->tail[0].iov_base & ~PAGE_MASK;
+		page_base = offset_in_page(xdr->tail[0].iov_base);
 		len = xdr->tail[0].iov_len;
 
 map_tail:
@@ -878,9 +878,9 @@ static bool rpcrdma_results_inline(struct rpcrdma_xprt *r_xprt,
 	srcp += curlen;
 	copy_len -= curlen;
 
-	page_base = rqst->rq_rcv_buf.page_base;
-	ppages = rqst->rq_rcv_buf.pages + (page_base >> PAGE_SHIFT);
-	page_base &= ~PAGE_MASK;
+	ppages = rqst->rq_rcv_buf.pages +
+		(rqst->rq_rcv_buf.page_base >> PAGE_SHIFT);
+	page_base = offset_in_page(rqst->rq_rcv_buf.page_base);
 	fixup_copy_count = 0;
 	if (copy_len && rqst->rq_rcv_buf.page_len) {
 		int pagelist_len;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
