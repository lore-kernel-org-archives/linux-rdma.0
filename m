From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/2] svcrdma: Add zero padding if the client doesn't send it
Date: Tue, 15 Jul 2014 13:55:08 -0400
Message-ID: <20140715175508.3448.95150.stgit@klimt.1015granger.net>
References: <20140715175144.3448.48674.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715175144.3448.48674.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

See RFC 5666 section 3.7: clients don't have to send zero XDR
padding.

BugLink: https://bugzilla.linux-nfs.org/show_bug.cgi?id=246
Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 8f92a61..3a45bf4 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -43,6 +43,7 @@
 #include <linux/sunrpc/debug.h>
 #include <linux/sunrpc/rpc_rdma.h>
 #include <linux/spinlock.h>
+#include <linux/highmem.h>
 #include <asm/unaligned.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
@@ -435,6 +436,32 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	return ret;
 }
 
+/*
+ * To avoid a separate RDMA READ just for a handful of zero bytes,
+ * RFC 5666 section 3.7 allows the client to omit the XDR zero pad
+ * in chunk lists.
+ */
+static void
+rdma_fix_xdr_pad(struct xdr_buf *buf)
+{
+	unsigned int page_len = buf->page_len;
+	unsigned int size = (XDR_QUADLEN(page_len) << 2) - page_len;
+ 	unsigned int offset, pg_no;
+	char *p;
+
+	if (size == 0)
+		return;
+
+	pg_no = page_len >> PAGE_SHIFT;
+	offset = page_len & ~PAGE_MASK;
+	p = page_address(buf->pages[pg_no]);
+	memset(p + offset, 0, size);
+
+	buf->page_len += size;
+	buf->buflen += size;
+	buf->len += size;
+}
+
 static int rdma_read_complete(struct svc_rqst *rqstp,
 			      struct svc_rdma_op_ctxt *head)
 {
@@ -449,6 +476,7 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
 		rqstp->rq_pages[page_no] = head->pages[page_no];
 	}
 	/* Point rq_arg.pages past header */
+	rdma_fix_xdr_pad(&head->arg);
 	rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];
 	rqstp->rq_arg.page_len = head->arg.page_len;
 	rqstp->rq_arg.page_base = head->arg.page_base;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
