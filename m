From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/hfi1: Remove atomic SDMA_REQ_SEND_DONE bit
 operation
Date: Fri, 26 May 2017 05:35:44 -0700
Message-ID: <20170526123542.8158.14590.stgit@scvm10.sc.intel.com>
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

The atomic SDMA_REQ_SEND_DONE bit is set by the
process-level code, and then the same process-level
code uses the bit to test that all packets have been
submitted incurring a costly atomic read.

Use a bool type with a READ_ONCE/WRITE_ONCE
pairing for this bit, and use the same condition that
is used to set the bit to test that all packets have
been submitted.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 92517ce..6fb70f0 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -154,10 +154,8 @@
 #define TXREQ_FLAGS_REQ_DISABLE_SH BIT(1) /* Disable header suppression */
 
 /* SDMA request flag bits */
-#define SDMA_REQ_FOR_THREAD 1
-#define SDMA_REQ_SEND_DONE  2
-#define SDMA_REQ_HAS_ERROR  3
-#define SDMA_REQ_DONE_ERROR 4
+#define SDMA_REQ_HAS_ERROR  1
+#define SDMA_REQ_DONE_ERROR 2
 
 #define SDMA_PKT_Q_INACTIVE BIT(0)
 #define SDMA_PKT_Q_ACTIVE   BIT(1)
@@ -258,6 +256,7 @@ struct user_sdma_request {
 	u16 tididx;
 	/* progress index moving along the iovs array */
 	u8 iov_idx;
+	u8 done;
 
 	struct user_sdma_iovec iovs[MAX_VECTORS_PER_REQ];
 } ____cacheline_aligned_in_smp;
@@ -628,6 +627,7 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	req->seqsubmitted = 0;
 	req->flags = 0;
 	req->tids = NULL;
+	req->done = 0;
 	INIT_LIST_HEAD(&req->txps);
 
 	memcpy(&req->info, &info, sizeof(info));
@@ -809,7 +809,7 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	 * request have been submitted to the SDMA engine. However, it
 	 * will not wait for send completions.
 	 */
-	while (!test_bit(SDMA_REQ_SEND_DONE, &req->flags)) {
+	while (req->seqsubmitted != req->info.npkts) {
 		ret = user_sdma_send_pkts(req, pcount);
 		if (ret < 0) {
 			if (ret != -EBUSY) {
@@ -1118,7 +1118,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 	ret = sdma_send_txlist(req->sde, &pq->busy, &req->txps, &count);
 	req->seqsubmitted += count;
 	if (req->seqsubmitted == req->info.npkts) {
-		set_bit(SDMA_REQ_SEND_DONE, &req->flags);
+		WRITE_ONCE(req->done, 1);
 		/*
 		 * The txreq has already been submitted to the HW queue
 		 * so we can free the AHG entry now. Corruption will not
@@ -1585,7 +1585,7 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status)
 		if (status != SDMA_TXREQ_S_OK)
 			req->status = status;
 		if (req->seqcomp == (ACCESS_ONCE(req->seqsubmitted) - 1) &&
-		    (test_bit(SDMA_REQ_SEND_DONE, &req->flags) ||
+		    (READ_ONCE(req->done) ||
 		     test_bit(SDMA_REQ_DONE_ERROR, &req->flags))) {
 			user_sdma_free_request(req, false);
 			pq_update(pq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
