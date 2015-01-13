From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 09/10] svcrdma: Move read list XDR round-up logic
Date: Tue, 13 Jan 2015 11:03:45 -0500
Message-ID: <20150113160345.8118.69576.stgit@klimt.1015granger.net>
References: <20150113155904.8118.57718.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150113155904.8118.57718.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a pre-requisite for a subsequent patch.

Read list XDR round-up needs to be done _before_ additional inline
content is copied to the end of the XDR buffer's page list. Move
the logic added by commit e560e3b510d2 ("svcrdma: Add zero padding
if the client doesn't send it").

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   37 ++++++++-----------------------
 1 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 36cf51a..a345cad 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -43,7 +43,6 @@
 #include <linux/sunrpc/debug.h>
 #include <linux/sunrpc/rpc_rdma.h>
 #include <linux/spinlock.h>
-#include <linux/highmem.h>
 #include <asm/unaligned.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
@@ -434,6 +433,15 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 		}
 	}
 
+	/* Read list may need XDR round-up (see RFC 5666, s. 3.7) */
+	if (page_offset & 3) {
+		u32 pad = 4 - (page_offset & 3);
+
+		head->arg.page_len += pad;
+		head->arg.len += pad;
+		head->arg.buflen += pad;
+	}
+
 	ret = 1;
 	head->position = position;
 
@@ -446,32 +454,6 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	return ret;
 }
 
-/*
- * To avoid a separate RDMA READ just for a handful of zero bytes,
- * RFC 5666 section 3.7 allows the client to omit the XDR zero pad
- * in chunk lists.
- */
-static void
-rdma_fix_xdr_pad(struct xdr_buf *buf)
-{
-	unsigned int page_len = buf->page_len;
-	unsigned int size = (XDR_QUADLEN(page_len) << 2) - page_len;
-	unsigned int offset, pg_no;
-	char *p;
-
-	if (size == 0)
-		return;
-
-	pg_no = page_len >> PAGE_SHIFT;
-	offset = page_len & ~PAGE_MASK;
-	p = page_address(buf->pages[pg_no]);
-	memset(p + offset, 0, size);
-
-	buf->page_len += size;
-	buf->buflen += size;
-	buf->len += size;
-}
-
 static int rdma_read_complete(struct svc_rqst *rqstp,
 			      struct svc_rdma_op_ctxt *head)
 {
@@ -499,7 +481,6 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
 	}
 
 	/* Point rq_arg.pages past header */
-	rdma_fix_xdr_pad(&head->arg);
 	rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];
 	rqstp->rq_arg.page_len = head->arg.page_len;
 	rqstp->rq_arg.page_base = head->arg.page_base;

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
