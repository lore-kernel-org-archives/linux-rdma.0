From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 18/25] xprtrdma: rpcrdma_inline_fixup() overruns the
 receive page list
Date: Mon, 20 Jun 2016 12:11:02 -0400
Message-ID: <20160620161102.10809.4770.stgit@manet.1015granger.net>
References: <20160620155751.10809.22262.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160620155751.10809.22262.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the remaining length of an incoming reply is longer than the
XDR buf's page_len, switch over to the tail iovec instead of
copying more than page_len bytes into the page list.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index f60d229..e3560c2 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -773,12 +773,17 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 	page_base &= ~PAGE_MASK;
 
 	if (copy_len && rqst->rq_rcv_buf.page_len) {
-		npages = PAGE_ALIGN(page_base +
-			rqst->rq_rcv_buf.page_len) >> PAGE_SHIFT;
+		int pagelist_len;
+
+		pagelist_len = rqst->rq_rcv_buf.page_len;
+		if (pagelist_len > copy_len)
+			pagelist_len = copy_len;
+		npages = PAGE_ALIGN(page_base + pagelist_len) >> PAGE_SHIFT;
 		for (; i < npages; i++) {
 			curlen = PAGE_SIZE - page_base;
-			if (curlen > copy_len)
-				curlen = copy_len;
+			if (curlen > pagelist_len)
+				curlen = pagelist_len;
+
 			dprintk("RPC:       %s: page %d"
 				" srcp 0x%p len %d curlen %d\n",
 				__func__, i, srcp, copy_len, curlen);
@@ -788,7 +793,8 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 			kunmap_atomic(destp);
 			srcp += curlen;
 			copy_len -= curlen;
-			if (copy_len == 0)
+			pagelist_len -= curlen;
+			if (!pagelist_len)
 				break;
 			page_base = 0;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
