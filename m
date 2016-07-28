From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/16] IB/hfi1: Fix user SDMA racy user request claim
Date: Thu, 28 Jul 2016 15:21:18 -0400
Message-ID: <1469733687-31738-8-git-send-email-ira.weiny@intel.com>
References: <1469733687-31738-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469733687-31738-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The user SDMA in-use claim bit is in the structure that gets zeroed out
once the claim is made.  Move the request in-use flag into its own bit
array and use that for atomic claims.  This cleans up the claim code and
removes any race possibility.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 32 +++++++++++++++++++-------------
 drivers/infiniband/hw/hfi1/user_sdma.h |  1 +
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 5c1322428065..e88d555389f4 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -145,7 +145,7 @@ MODULE_PARM_DESC(sdma_comp_size, "Size of User SDMA completion ring. Default: 12
 /* Last packet in the request */
 #define TXREQ_FLAGS_REQ_LAST_PKT BIT(0)
 
-#define SDMA_REQ_IN_USE     0
+/* SDMA request flag bits */
 #define SDMA_REQ_FOR_THREAD 1
 #define SDMA_REQ_SEND_DONE  2
 #define SDMA_REQ_HAVE_AHG   3
@@ -397,6 +397,11 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	if (!pq->reqs)
 		goto pq_reqs_nomem;
 
+	memsize = BITS_TO_LONGS(hfi1_sdma_comp_ring_size) * sizeof(long);
+	pq->req_in_use = kzalloc(memsize, GFP_KERNEL);
+	if (!pq->req_in_use)
+		goto pq_reqs_no_in_use;
+
 	INIT_LIST_HEAD(&pq->list);
 	pq->dd = dd;
 	pq->ctxt = uctxt->ctxt;
@@ -453,6 +458,8 @@ cq_comps_nomem:
 cq_nomem:
 	kmem_cache_destroy(pq->txreq_cache);
 pq_txreq_nomem:
+	kfree(pq->req_in_use);
+pq_reqs_no_in_use:
 	kfree(pq->reqs);
 pq_reqs_nomem:
 	kfree(pq);
@@ -484,6 +491,7 @@ int hfi1_user_sdma_free_queues(struct hfi1_filedata *fd)
 			pq->wait,
 			(ACCESS_ONCE(pq->state) == SDMA_PKT_Q_INACTIVE));
 		kfree(pq->reqs);
+		kfree(pq->req_in_use);
 		kmem_cache_destroy(pq->txreq_cache);
 		kfree(pq);
 		fd->pq = NULL;
@@ -572,29 +580,27 @@ int hfi1_user_sdma_process_request(struct file *fp, struct iovec *iovec,
 		return -EINVAL;
 	}
 
-	if (cq->comps[info.comp_idx].status == QUEUED ||
-	    test_bit(SDMA_REQ_IN_USE, &pq->reqs[info.comp_idx].flags)) {
-		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in QUEUED state",
-			  dd->unit, uctxt->ctxt, fd->subctxt,
-			  info.comp_idx);
-		return -EBADSLT;
-	}
 	if (!info.fragsize) {
 		hfi1_cdbg(SDMA,
 			  "[%u:%u:%u:%u] Request does not specify fragsize",
 			  dd->unit, uctxt->ctxt, fd->subctxt, info.comp_idx);
 		return -EINVAL;
 	}
+
+	/* Try to claim the request. */
+	if (test_and_set_bit(info.comp_idx, pq->req_in_use)) {
+		hfi1_cdbg(SDMA, "[%u:%u:%u] Entry %u is in use",
+			  dd->unit, uctxt->ctxt, fd->subctxt,
+			  info.comp_idx);
+		return -EBADSLT;
+	}
 	/*
-	 * We've done all the safety checks that we can up to this point,
-	 * "allocate" the request entry.
+	 * All safety checks have been done and this request has been claimed.
 	 */
 	hfi1_cdbg(SDMA, "[%u:%u:%u] Using req/comp entry %u\n", dd->unit,
 		  uctxt->ctxt, fd->subctxt, info.comp_idx);
 	req = pq->reqs + info.comp_idx;
 	memset(req, 0, sizeof(*req));
-	/* Mark the request as IN_USE before we start filling it in. */
-	set_bit(SDMA_REQ_IN_USE, &req->flags);
 	req->data_iovs = req_iovcnt(info.ctrl) - 1; /* subtract header vector */
 	req->pq = pq;
 	req->cq = cq;
@@ -1612,7 +1618,7 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 		}
 	}
 	kfree(req->tids);
-	clear_bit(SDMA_REQ_IN_USE, &req->flags);
+	clear_bit(req->info.comp_idx, req->pq->req_in_use);
 }
 
 static inline void set_comp_state(struct hfi1_user_sdma_pkt_q *pq,
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index b9240e351161..20ff846f318b 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -63,6 +63,7 @@ struct hfi1_user_sdma_pkt_q {
 	struct hfi1_devdata *dd;
 	struct kmem_cache *txreq_cache;
 	struct user_sdma_request *reqs;
+	unsigned long *req_in_use;
 	struct iowait busy;
 	unsigned state;
 	wait_queue_head_t wait;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
