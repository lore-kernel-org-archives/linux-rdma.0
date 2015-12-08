From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 3/5] staging/rdma/hfi1: Clean-up unnecessary goto statements
Date: Tue,  8 Dec 2015 17:10:11 -0500
Message-ID: <1449612613-6616-4-git-send-email-ira.weiny@intel.com>
References: <1449612613-6616-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449612613-6616-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Clean-up unnecessary goto statements based on feedback from the
mailing list on previous patch submissions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c | 37 +++++++++++++----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 41408f82afe8..060c2200757d 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -505,15 +505,13 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		   "[%u:%u:%u] First vector not big enough for header %lu/%lu",
 		   dd->unit, uctxt->ctxt, fd->subctxt,
 		   iovec[idx].iov_len, sizeof(info) + sizeof(req->hdr));
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 	ret = copy_from_user(&info, iovec[idx].iov_base, sizeof(info));
 	if (ret) {
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Failed to copy info QW (%d)",
 			  dd->unit, uctxt->ctxt, fd->subctxt, ret);
-		ret = -EFAULT;
-		goto done;
+		return -EFAULT;
 	}
 	trace_hfi1_sdma_user_reqinfo(dd, uctxt->ctxt, fd->subctxt,
 				     (u16 *)&info);
@@ -521,15 +519,13 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
 			  dd->unit, uctxt->ctxt, fd->subctxt,
 			  info.comp_idx);
-		ret = -EBADSLT;
-		goto done;
+		return -EBADSLT;
 	}
 	if (!info.fragsize) {
 		hfi1_cdbg(SDMA,
 			  "[%u:%u:%u:%u] Request does not specify fragsize",
 			  dd->unit, uctxt->ctxt, fd->subctxt, info.comp_idx);
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 	/*
 	 * We've done all the safety checks that we can up to this point,
@@ -554,8 +550,7 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 	if (!info.npkts || req->data_iovs > MAX_VECTORS_PER_REQ) {
 		SDMA_DBG(req, "Too many vectors (%u/%u)", req->data_iovs,
 			 MAX_VECTORS_PER_REQ);
-		ret = -EINVAL;
-		goto done;
+		return -EINVAL;
 	}
 	/* Copy the header from the user buffer */
 	ret = copy_from_user(&req->hdr, iovec[idx].iov_base + sizeof(info),
@@ -782,10 +777,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 	struct hfi1_user_sdma_pkt_q *pq = NULL;
 	struct user_sdma_iovec *iovec = NULL;
 
-	if (!req->pq) {
-		ret = -EINVAL;
-		goto done;
-	}
+	if (!req->pq)
+		return -EINVAL;
 
 	pq = req->pq;
 
@@ -795,7 +788,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 	if (unlikely(req->seqnum == req->info.npkts)) {
 		if (!list_empty(&req->txps))
 			goto dosend;
-		goto done;
+		return ret;
 	}
 
 	if (!maxpkts || maxpkts > req->info.npkts - req->seqnum)
@@ -812,15 +805,13 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		 */
 		if (test_bit(SDMA_REQ_HAS_ERROR, &req->flags)) {
 			set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
-			ret = -EFAULT;
-			goto done;
+			return -EFAULT;
 		}
 
 		tx = kmem_cache_alloc(pq->txreq_cache, GFP_KERNEL);
-		if (!tx) {
-			ret = -ENOMEM;
-			goto done;
-		}
+		if (!tx)
+			return -ENOMEM;
+
 		tx->flags = 0;
 		tx->req = req;
 		tx->busycount = 0;
@@ -1021,12 +1012,12 @@ dosend:
 			if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags))
 				sdma_ahg_free(req->sde, req->ahg_idx);
 		}
-	goto done;
+	return ret;
+
 free_txreq:
 	sdma_txclean(pq->dd, &tx->txreq);
 free_tx:
 	kmem_cache_free(pq->txreq_cache, tx);
-done:
 	return ret;
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
