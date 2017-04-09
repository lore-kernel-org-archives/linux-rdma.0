From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 04/14] svcrdma: Add helper to save pages under I/O
Date: Sun, 09 Apr 2017 13:06:00 -0400
Message-ID: <20170409170600.15073.62156.stgit@klimt.1015granger.net>
References: <20170409163820.15073.43257.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409163820.15073.43257.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean up: extract the logic to save pages under I/O into a helper to
add a big documenting comment without adding clutter in the send
path.

This is a refactoring change only.

Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index a7dc71d..2798f3e 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -478,6 +478,23 @@ static int send_reply_chunks(struct svcxprt_rdma *xprt,
 	return -EIO;
 }
 
+/* The svc_rqst and all resources it owns are released as soon as
+ * svc_rdma_sendto returns. Transfer pages under I/O to the ctxt
+ * so they are released by the Send completion handler.
+ */
+static void svc_rdma_save_io_pages(struct svc_rqst *rqstp,
+				   struct svc_rdma_op_ctxt *ctxt)
+{
+	int i, pages = rqstp->rq_next_page - rqstp->rq_respages;
+
+	ctxt->count += pages;
+	for (i = 0; i < pages; i++) {
+		ctxt->pages[i + 1] = rqstp->rq_respages[i];
+		rqstp->rq_respages[i] = NULL;
+	}
+	rqstp->rq_next_page = rqstp->rq_respages + 1;
+}
+
 /**
  * svc_rdma_post_send_wr - Set up and post one Send Work Request
  * @rdma: controlling transport
@@ -543,8 +560,6 @@ static int send_reply(struct svcxprt_rdma *rdma,
 	u32 xdr_off;
 	int sge_no;
 	int sge_bytes;
-	int page_no;
-	int pages;
 	int ret = -EIO;
 
 	/* Prepare the context */
@@ -587,17 +602,7 @@ static int send_reply(struct svcxprt_rdma *rdma,
 		goto err;
 	}
 
-	/* Save all respages in the ctxt and remove them from the
-	 * respages array. They are our pages until the I/O
-	 * completes.
-	 */
-	pages = rqstp->rq_next_page - rqstp->rq_respages;
-	for (page_no = 0; page_no < pages; page_no++) {
-		ctxt->pages[page_no+1] = rqstp->rq_respages[page_no];
-		ctxt->count++;
-		rqstp->rq_respages[page_no] = NULL;
-	}
-	rqstp->rq_next_page = rqstp->rq_respages + 1;
+	svc_rdma_save_io_pages(rqstp, ctxt);
 
 	if (sge_no > rdma->sc_max_sge) {
 		pr_err("svcrdma: Too many sges (%d)\n", sge_no);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
