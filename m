From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 08/10] svcrdma: Support RDMA_NOMSG requests
Date: Fri, 09 Jan 2015 14:23:02 -0500
Message-ID: <20150109192302.4901.76354.stgit@klimt.1015granger.net>
References: <20150109191910.4901.29548.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150109191910.4901.29548.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Currently the Linux server can not decode RDMA_NOMSG type requests.
The client sends the RPC/RDMA header via RDMA SEND. The header has
a read chunk list that conveys the RPC and NFS headers and the NFS
payload (if any).

Large operations like NFSv4 CREATE(NF4LNK) will by conveyed via
RDMA_NOMSG, so add this support.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---

 include/linux/sunrpc/svc_rdma.h         |    1 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |   39 +++++++++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index f161e30..c343a94 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -79,6 +79,7 @@ struct svc_rdma_op_ctxt {
 	enum ib_wr_opcode wr_op;
 	enum ib_wc_status wc_status;
 	u32 byte_len;
+	u32 position;
 	struct svcxprt_rdma *xprt;
 	unsigned long flags;
 	enum dma_data_direction direction;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index a67dd1a..36cf51a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -60,6 +60,7 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 			       struct svc_rdma_op_ctxt *ctxt,
 			       u32 byte_count)
 {
+	struct rpcrdma_msg *rmsgp;
 	struct page *page;
 	u32 bc;
 	int sge_no;
@@ -82,7 +83,14 @@ static void rdma_build_arg_xdr(struct svc_rqst *rqstp,
 	/* If data remains, store it in the pagelist */
 	rqstp->rq_arg.page_len = bc;
 	rqstp->rq_arg.page_base = 0;
-	rqstp->rq_arg.pages = &rqstp->rq_pages[1];
+
+	/* RDMA_NOMSG: RDMA READ data should land just after RDMA RECV data */
+	rmsgp = (struct rpcrdma_msg *)rqstp->rq_arg.head[0].iov_base;
+	if (be32_to_cpu(rmsgp->rm_type) == RDMA_NOMSG)
+		rqstp->rq_arg.pages = &rqstp->rq_pages[0];
+	else
+		rqstp->rq_arg.pages = &rqstp->rq_pages[1];
+
 	sge_no = 1;
 	while (bc && sge_no < ctxt->count) {
 		page = ctxt->pages[sge_no];
@@ -383,7 +391,6 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	 */
 	head->arg.head[0] = rqstp->rq_arg.head[0];
 	head->arg.tail[0] = rqstp->rq_arg.tail[0];
-	head->arg.pages = &head->pages[head->count];
 	head->hdr_count = head->count;
 	head->arg.page_base = 0;
 	head->arg.page_len = 0;
@@ -393,9 +400,17 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 	ch = (struct rpcrdma_read_chunk *)&rmsgp->rm_body.rm_chunks[0];
 	position = be32_to_cpu(ch->rc_position);
 
+	/* RDMA_NOMSG: RDMA READ data should land just after RDMA RECV data */
+	if (position == 0) {
+		head->arg.pages = &head->pages[0];
+		page_offset = head->byte_len;
+	} else {
+		head->arg.pages = &head->pages[head->count];
+		page_offset = 0;
+	}
+
 	ret = 0;
 	page_no = 0;
-	page_offset = 0;
 	for (; ch->rc_discrim != xdr_zero; ch++) {
 		if (be32_to_cpu(ch->rc_position) != position)
 			goto err;
@@ -418,7 +433,10 @@ static int rdma_read_chunks(struct svcxprt_rdma *xprt,
 			head->arg.buflen += ret;
 		}
 	}
+
 	ret = 1;
+	head->position = position;
+
  err:
 	/* Detach arg pages. svc_recv will replenish them */
 	for (page_no = 0;
@@ -465,6 +483,21 @@ static int rdma_read_complete(struct svc_rqst *rqstp,
 		put_page(rqstp->rq_pages[page_no]);
 		rqstp->rq_pages[page_no] = head->pages[page_no];
 	}
+
+	/* Adjustments made for RDMA_NOMSG type requests */
+	if (head->position == 0) {
+		if (head->arg.len <= head->sge[0].length) {
+			head->arg.head[0].iov_len = head->arg.len -
+							head->byte_len;
+			head->arg.page_len = 0;
+		} else {
+			head->arg.head[0].iov_len = head->sge[0].length -
+								head->byte_len;
+			head->arg.page_len = head->arg.len -
+						head->sge[0].length;
+		}
+	}
+
 	/* Point rq_arg.pages past header */
 	rdma_fix_xdr_pad(&head->arg);
 	rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
