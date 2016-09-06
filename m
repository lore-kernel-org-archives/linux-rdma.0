From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/13] IB/hfi1: Fix the count of user packets
 submitted to an SDMA engine
Date: Tue, 06 Sep 2016 04:35:37 -0700
Message-ID: <20160906113525.27413.42835.stgit@scvm10.sc.intel.com>
References: <20160906112758.27413.46860.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160906112758.27413.46860.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Each user SDMA request coming into the driver may contain multiple packets.
Each user packet may use multiple SDMA descriptors to fill the send buffer.
The field seqsubmitted in struct user_sdma_request counts the number of
user packets submitted to an SDMA engine. Sometimes, the intermediate count
may not be updated properly. However, once all the packets' descriptors
are successfully submitted to the SDMA engine, the final count is updated
correctly. But, if only some of the packets are submitted to the engine due
to an error, the intermediate count doesn't reflect the partial number of
packets submitted to the SDMA engine. This can cause a hang later in the
code as the count of packets submitted to the SDMA engine doesn't match the
the count of packets processed by the SDMA engine.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/sdma.c      |   24 +++++++++++++++---------
 drivers/infiniband/hw/hfi1/sdma.h      |    3 ++-
 drivers/infiniband/hw/hfi1/user_sdma.c |   31 +++++++++++++------------------
 3 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index f9befc0..0990fba 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -2086,6 +2086,11 @@ nodesc:
  * @sde: sdma engine to use
  * @wait: wait structure to use when full (may be NULL)
  * @tx_list: list of sdma_txreqs to submit
+ * @count: pointer to a u32 which, after return will contain the total number of
+ *         sdma_txreqs removed from the tx_list. This will include sdma_txreqs
+ *         whose SDMA descriptors are submitted to the ring and the sdma_txreqs
+ *         which are added to SDMA engine flush list if the SDMA engine state is
+ *         not running.
  *
  * The call submits the list into the ring.
  *
@@ -2100,18 +2105,18 @@ nodesc:
  * side locking.
  *
  * Return:
- * > 0 - Success (value is number of sdma_txreq's submitted),
+ * 0 - Success,
  * -EINVAL - sdma_txreq incomplete, -EBUSY - no space in ring (wait == NULL)
  * -EIOCBQUEUED - tx queued to iowait, -ECOMM bad sdma state
  */
 int sdma_send_txlist(struct sdma_engine *sde, struct iowait *wait,
-		     struct list_head *tx_list)
+		     struct list_head *tx_list, u32 *count_out)
 {
 	struct sdma_txreq *tx, *tx_next;
 	int ret = 0;
 	unsigned long flags;
 	u16 tail = INVALID_TAIL;
-	int count = 0;
+	u32 submit_count = 0, flush_count = 0, total_count;
 
 	spin_lock_irqsave(&sde->tail_lock, flags);
 retry:
@@ -2127,33 +2132,34 @@ retry:
 		}
 		list_del_init(&tx->list);
 		tail = submit_tx(sde, tx);
-		count++;
+		submit_count++;
 		if (tail != INVALID_TAIL &&
-		    (count & SDMA_TAIL_UPDATE_THRESH) == 0) {
+		    (submit_count & SDMA_TAIL_UPDATE_THRESH) == 0) {
 			sdma_update_tail(sde, tail);
 			tail = INVALID_TAIL;
 		}
 	}
 update_tail:
+	total_count = submit_count + flush_count;
 	if (wait)
-		iowait_sdma_add(wait, count);
+		iowait_sdma_add(wait, total_count);
 	if (tail != INVALID_TAIL)
 		sdma_update_tail(sde, tail);
 	spin_unlock_irqrestore(&sde->tail_lock, flags);
-	return ret == 0 ? count : ret;
+	*count_out = total_count;
+	return ret;
 unlock_noconn:
 	spin_lock(&sde->flushlist_lock);
 	list_for_each_entry_safe(tx, tx_next, tx_list, list) {
 		tx->wait = wait;
 		list_del_init(&tx->list);
-		if (wait)
-			iowait_sdma_inc(wait);
 		tx->next_descq_idx = 0;
 #ifdef CONFIG_HFI1_DEBUG_SDMA_ORDER
 		tx->sn = sde->tail_sn++;
 		trace_hfi1_sdma_in_sn(sde, tx->sn);
 #endif
 		list_add_tail(&tx->list, &sde->flushlist);
+		flush_count++;
 		if (wait) {
 			wait->tx_count++;
 			wait->count += tx->num_desc;
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index 8f50c99..b333afa 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -847,7 +847,8 @@ int sdma_send_txreq(struct sdma_engine *sde,
 		    struct sdma_txreq *tx);
 int sdma_send_txlist(struct sdma_engine *sde,
 		     struct iowait *wait,
-		     struct list_head *tx_list);
+		     struct list_head *tx_list,
+		     u32 *count);
 
 int sdma_ahg_alloc(struct sdma_engine *sde);
 void sdma_ahg_free(struct sdma_engine *sde, int ahg_index);
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 1694037..bc7e5c1 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -894,7 +894,7 @@ static inline u32 get_lrh_len(struct hfi1_pkt_header hdr, u32 len)
 
 static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 {
-	int ret = 0;
+	int ret = 0, count;
 	unsigned npkts = 0;
 	struct user_sdma_txreq *tx = NULL;
 	struct hfi1_user_sdma_pkt_q *pq = NULL;
@@ -1090,23 +1090,18 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		npkts++;
 	}
 dosend:
-	ret = sdma_send_txlist(req->sde, &pq->busy, &req->txps);
-	if (list_empty(&req->txps)) {
-		req->seqsubmitted = req->seqnum;
-		if (req->seqnum == req->info.npkts) {
-			set_bit(SDMA_REQ_SEND_DONE, &req->flags);
-			/*
-			 * The txreq has already been submitted to the HW queue
-			 * so we can free the AHG entry now. Corruption will not
-			 * happen due to the sequential manner in which
-			 * descriptors are processed.
-			 */
-			if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags))
-				sdma_ahg_free(req->sde, req->ahg_idx);
-		}
-	} else if (ret > 0) {
-		req->seqsubmitted += ret;
-		ret = 0;
+	ret = sdma_send_txlist(req->sde, &pq->busy, &req->txps, &count);
+	req->seqsubmitted += count;
+	if (req->seqsubmitted == req->info.npkts) {
+		set_bit(SDMA_REQ_SEND_DONE, &req->flags);
+		/*
+		 * The txreq has already been submitted to the HW queue
+		 * so we can free the AHG entry now. Corruption will not
+		 * happen due to the sequential manner in which
+		 * descriptors are processed.
+		 */
+		if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags))
+			sdma_ahg_free(req->sde, req->ahg_idx);
 	}
 	return ret;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
