From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 34/54] staging/rdma/hfi1: Properly determine error status of
 SDMA slots
Date: Wed, 03 Feb 2016 14:35:23 -0800
Message-ID: <20160203223519.5923.88304.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

To ensure correct operation between the driver and PSM
with respect to managing the SDMA request ring, it is
important that the status for a particular request slot
is set at the correct time. Otherwise, PSM can get out
of sync with the driver, which could lead to hangs or
errors on new requests.

Properly determining of when to set the error status of
a SDMA slot depends on knowing exactly when the last txreq
for that request has been completed. This in turn requires
that the driver knows exactly how many requests have been
generated and how many of those requests have been successfully
submitted to the SDMA queue.

The previous implementation of the mid-layer SDMA API did not
provide a way for the caller of sdma_send_txlist() to know how
many of the txreqs in the input list have actually been submitted
without traversing the list and counting. Since sdma_send_txlist()
already traverses the list in order to process it, requiring
such traversal in the caller is completely unnecessary. Therefore,
it is much easier to enhance sdma_send_txlist() to return the
number of successfully submitted txreqs.

This, in turn, allows the caller to accurately determine the
progress of the SDMA request and, therefore, correctly set the
error status at the right time.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/sdma.c      |    6 +++---
 drivers/staging/rdma/hfi1/user_sdma.c |   15 +++++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 52fb22d..ff1d2cd 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2145,8 +2145,8 @@ nodesc:
  * side locking.
  *
  * Return:
- * 0 - Success, -EINVAL - sdma_txreq incomplete, -EBUSY - no space in ring
- * (wait == NULL)
+ * > 0 - Success (value is number of sdma_txreq's submitted),
+ * -EINVAL - sdma_txreq incomplete, -EBUSY - no space in ring (wait == NULL)
  * -EIOCBQUEUED - tx queued to iowait, -ECOMM bad sdma state
  */
 int sdma_send_txlist(struct sdma_engine *sde,
@@ -2186,7 +2186,7 @@ update_tail:
 	if (tail != INVALID_TAIL)
 		sdma_update_tail(sde, tail);
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
-	return ret;
+	return ret == 0 ? count : ret;
 unlock_noconn:
 	spin_lock(&sde->flushlist_lock);
 	list_for_each_entry_safe(tx, tx_next, tx_list, list) {
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 2d238f3..0c32eaf 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -234,6 +234,7 @@ struct user_sdma_request {
 	u32 sent;
 	u64 seqnum;
 	u64 seqcomp;
+	u64 seqsubmitted;
 	struct list_head txps;
 	spinlock_t txcmp_lock;  /* protect txcmp list */
 	struct list_head txcmp;
@@ -1001,18 +1002,19 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 					TXREQ_FLAGS_IOVEC_LAST_PKT;
 		}
 
+		list_add_tail(&tx->txreq.list, &req->txps);
 		/*
 		 * It is important to increment this here as it is used to
 		 * generate the BTH.PSN and, therefore, can't be bulk-updated
 		 * outside of the loop.
 		 */
 		tx->seqnum = req->seqnum++;
-		list_add_tail(&tx->txreq.list, &req->txps);
 		npkts++;
 	}
 dosend:
 	ret = sdma_send_txlist(req->sde, &pq->busy, &req->txps);
-	if (list_empty(&req->txps))
+	if (list_empty(&req->txps)) {
+		req->seqsubmitted = req->seqnum;
 		if (req->seqnum == req->info.npkts) {
 			set_bit(SDMA_REQ_SEND_DONE, &req->flags);
 			/*
@@ -1024,6 +1026,10 @@ dosend:
 			if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags))
 				sdma_ahg_free(req->sde, req->ahg_idx);
 		}
+	} else if (ret > 0) {
+		req->seqsubmitted += ret;
+		ret = 0;
+	}
 	return ret;
 
 free_txreq:
@@ -1406,8 +1412,9 @@ static void user_sdma_txreq_cb(struct sdma_txreq *txreq, int status,
 	} else {
 		if (status != SDMA_TXREQ_S_OK)
 			req->status = status;
-		if (req->seqcomp == ACCESS_ONCE(req->seqnum) &&
-		    test_bit(SDMA_REQ_DONE_ERROR, &req->flags)) {
+		if (req->seqcomp == (ACCESS_ONCE(req->seqsubmitted) - 1) &&
+		    (test_bit(SDMA_REQ_SEND_DONE, &req->flags) ||
+		     test_bit(SDMA_REQ_DONE_ERROR, &req->flags))) {
 			user_sdma_free_request(req, false);
 			pq_update(pq);
 			set_comp_state(pq, cq, idx, ERROR, req->status);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
