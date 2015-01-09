From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 10/10] svcrdma: Handle additional inline content
Date: Fri, 09 Jan 2015 14:23:19 -0500
Message-ID: <20150109192319.4901.89444.stgit@klimt.1015granger.net>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109191910.4901.29548.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Most NFS RPCs place large payload arguments at the end of the RPC
header (eg, NFSv3 WRITE). For NFSv3 WRITE and SYMLINK, RPC/RDMA
sends the complete RPC header inline, and the payload argument in a
read list.

One important case is not like this, however. NFSv4 WRITE compounds
can have an operation after the WRITE operation. The proper way to
convey an NFSv4 WRITE is to place the GETATTR inline, but _after_
the read list position. (Note Linux clients currently do not do
this, but they will be changed to do it in the future).

The receiver could put trailing inline content in the XDR tail
buffer. But the Linux server's NFSv4 compound processing does not
consider the XDR tail buffer.

So, move trailing inline content to the end of the page list. This
presents the incoming compound to upper layers the same way the
socket code does.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   62 +++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index a345cad..f44bf4e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -364,6 +364,63 @@ rdma_rcl_chunk_count(struct rpcrdma_read_chunk *ch)
 	return count;
 }
 
+/* If there was additional inline content, append it to the end of arg.pages.
+ * Tail copy has to be done after the reader function has determined how many
+ * pages are needed for RDMA READ.
+ */
+static int
+rdma_copy_tail(struct svc_rqst *rqstp, struct svc_rdma_op_ctxt *head,
+	       u32 position, u32 byte_count, u32 page_offset, int page_no)
+{
+	char *srcp, *destp;
+	int ret;
+
+	ret = 0;
+	srcp = head->arg.head[0].iov_base + position;
+	byte_count = head->arg.head[0].iov_len - position;
+	if (byte_count > PAGE_SIZE) {
+		dprintk("svcrdma: large tail unsupported\n");
+		goto err;
+	}
+
+	/* Fit as much of the tail on the current page as possible */
+	if (page_offset != PAGE_SIZE) {
+		destp = page_address(rqstp->rq_arg.pages[page_no]);
+		destp += page_offset;
+
+		while (byte_count--) {
+			*destp++ = *srcp++;
+			page_offset++;
+			if (page_offset == PAGE_SIZE)
+				break;
+		}
+
+		goto done;
+	}
+
+	/* Fit the rest on the next page */
+	page_no++;
+	if (!rqstp->rq_arg.pages[page_no]) {
+		dprintk("svcrdma: no more room for tail\n");
+		goto err;
+	}
+	destp = page_address(rqstp->rq_arg.pages[page_no]);
+	rqstp->rq_respages = &rqstp->rq_arg.pages[page_no+1];
+	rqstp->rq_next_page = rqstp->rq_respages + 1;
+	while (byte_count--)
+		*destp++ = *srcp++;
+
+done:
+	ret = 1;
+	byte_count = head->arg.head[0].iov_len - position;
+	head->arg.page_len += byte_count;
+	head->arg.len += byte_count;
+	head->arg.buflen += byte_count;
+
+err:
+	return ret;
+}
+
 static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 			    struct rpcrdma_msg *rmsgp,
 			    struct svc_rqst *rqstp,
@@ -440,9 +497,14 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 		head->arg.page_len += pad;
 		head->arg.len += pad;
 		head->arg.buflen += pad;
+		page_offset += pad;
 	}
 
 	ret = 1;
+	if (position && position < head->arg.head[0].iov_len)
+		ret = rdma_copy_tail(rqstp, head, position,
+				     byte_count, page_offset, page_no);
+	head->arg.head[0].iov_len = position;
 	head->position = position;
 
  err:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
