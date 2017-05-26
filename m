From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 7/9] IB/hfi1: Remove atomic SDMA_REQ_HAS_ERROR bit
 operation
Date: Fri, 26 May 2017 05:35:50 -0700
Message-ID: <20170526123549.8158.88663.stgit@scvm10.sc.intel.com>
References: <20170526123257.8158.23943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526123257.8158.23943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Atomic bit tests are used to single errors and the
completion of request submissions. These operations
don't need to be atomic and show to be expensive on
the profile.

Replace each atomic bit operation with a bool type
and a READ_ONCE/WRITE_ONCE pairing.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 6fb70f0..fcadbb9 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -153,10 +153,6 @@
 #define TXREQ_FLAGS_REQ_ACK   BIT(0)      /* Set the ACK bit in the header */
 #define TXREQ_FLAGS_REQ_DISABLE_SH BIT(1) /* Disable header suppression */
 
-/* SDMA request flag bits */
-#define SDMA_REQ_HAS_ERROR  1
-#define SDMA_REQ_DONE_ERROR 2
-
 #define SDMA_PKT_Q_INACTIVE BIT(0)
 #define SDMA_PKT_Q_ACTIVE   BIT(1)
 #define SDMA_PKT_Q_DEFERRED BIT(2)
@@ -232,7 +228,6 @@ struct user_sdma_request {
 	/* Writeable fields shared with interrupt */
 	u64 seqcomp ____cacheline_aligned_in_smp;
 	u64 seqsubmitted;
-	unsigned long flags;
 	/* status of the last txreq completed */
 	int status;
 
@@ -257,6 +252,7 @@ struct user_sdma_request {
 	/* progress index moving along the iovs array */
 	u8 iov_idx;
 	u8 done;
+	u8 has_error;
 
 	struct user_sdma_iovec iovs[MAX_VECTORS_PER_REQ];
 } ____cacheline_aligned_in_smp;
@@ -625,9 +621,9 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	req->seqnum = 0;
 	req->seqcomp = 0;
 	req->seqsubmitted = 0;
-	req->flags = 0;
 	req->tids = NULL;
 	req->done = 0;
+	req->has_error = 0;
 	INIT_LIST_HEAD(&req->txps);
 
 	memcpy(&req->info, &info, sizeof(info));
@@ -814,7 +810,7 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 		if (ret < 0) {
 			if (ret != -EBUSY) {
 				req->status = ret;
-				set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+				WRITE_ONCE(req->has_error, 1);
 				if (ACCESS_ONCE(req->seqcomp) ==
 				    req->seqsubmitted - 1)
 					goto free_req;
@@ -916,10 +912,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 	pq = req->pq;
 
 	/* If tx completion has reported an error, we are done. */
-	if (test_bit(SDMA_REQ_HAS_ERROR, &req->flags)) {
-		set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+	if (READ_ONCE(req->has_error))
 		return -EFAULT;
-	}
 
 	/*
 	 * Check if we might have sent the entire request already
@@ -942,10 +936,8 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		 * with errors. If so, we are not going to process any
 		 * more packets from this request.
 		 */
-		if (test_bit(SDMA_REQ_HAS_ERROR, &req->flags)) {
-			set_bit(SDMA_REQ_DONE_ERROR, &req->flags);
+		if (READ_ONCE(req->has_error))
 			return -EFAULT;
-		}
 
 		tx = kmem_cache_alloc(pq->txreq_cache, GFP_KERNEL);
 		if (!tx)
@@ -1566,7 +1558,7 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 	if (status != SDMA_TXREQ_S_OK) {
 		SDMA_DBG(req, "SDMA completion with error %d",
 			 status);
-		set_bit(SDMA_REQ_HAS_ERROR, &req->flags);
+		WRITE_ONCE(req->has_error, 1);
 	}
 
 	req->seqcomp = tx->seqnum;
@@ -1586,7 +1578,7 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 			req->status = status;
 		if (req->seqcomp == (ACCESS_ONCE(req->seqsubmitted) - 1) &&
 		    (READ_ONCE(req->done) ||
-		     test_bit(SDMA_REQ_DONE_ERROR, &req->flags))) {
+		     READ_ONCE(req->has_error))) {
 			user_sdma_free_request(req, false);
 			pq_update(pq);
 			set_comp_state(pq, cq, idx, ERROR, req->status);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
