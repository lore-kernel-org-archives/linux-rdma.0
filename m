From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: [PATCH for-rc 2/3] IB/hfi1: Close PSM sdma_progress sleep window
Date: Fri, 07 Jun 2019 08:25:31 -0400
Message-ID: <20190607122531.158478.35392.stgit@awfm-01.aw.intel.com>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, Gary Leshner <Gary.S.Leshner@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

The call to sdma_progress() is called outside the wait lock.

In this case, there is a race condition where sdma_progress() can return
false and the sdma_engine can idle.  If that happens, there will be no
more sdma interrupts to cause the wakeup and the user_sdma xmit will hang.

Fix by moving the lock to enclose the sdma_progress() call.

Also, delete busycount. The need for this was removed by:
commit bcad29137a97 ("IB/hfi1: Serve the most starved iowait entry first")

Cc: <stable@vger.kernel.org>
Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Gary Leshner <Gary.S.Leshner@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   12 ++++--------
 drivers/infiniband/hw/hfi1/user_sdma.h |    1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 8bfbc6d..fd754a1 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -130,20 +130,16 @@ static int defer_packet_queue(
 {
 	struct hfi1_user_sdma_pkt_q *pq =
 		container_of(wait->iow, struct hfi1_user_sdma_pkt_q, busy);
-	struct user_sdma_txreq *tx =
-		container_of(txreq, struct user_sdma_txreq, txreq);
 
-	if (sdma_progress(sde, seq, txreq)) {
-		if (tx->busycount++ < MAX_DEFER_RETRY_COUNT)
-			goto eagain;
-	}
+	write_seqlock(&sde->waitlock);
+	if (sdma_progress(sde, seq, txreq))
+		goto eagain;
 	/*
 	 * We are assuming that if the list is enqueued somewhere, it
 	 * is to the dmawait list since that is the only place where
 	 * it is supposed to be enqueued.
 	 */
 	xchg(&pq->state, SDMA_PKT_Q_DEFERRED);
-	write_seqlock(&sde->waitlock);
 	if (list_empty(&pq->busy.list)) {
 		iowait_get_priority(&pq->busy);
 		iowait_queue(pkts_sent, &pq->busy, &sde->dmawait);
@@ -151,6 +147,7 @@ static int defer_packet_queue(
 	write_sequnlock(&sde->waitlock);
 	return -EBUSY;
 eagain:
+	write_sequnlock(&sde->waitlock);
 	return -EAGAIN;
 }
 
@@ -804,7 +801,6 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, u16 maxpkts)
 
 		tx->flags = 0;
 		tx->req = req;
-		tx->busycount = 0;
 		INIT_LIST_HEAD(&tx->list);
 
 		/*
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.h b/drivers/infiniband/hw/hfi1/user_sdma.h
index 14dfd75..4d8510b0 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.h
+++ b/drivers/infiniband/hw/hfi1/user_sdma.h
@@ -245,7 +245,6 @@ struct user_sdma_txreq {
 	struct list_head list;
 	struct user_sdma_request *req;
 	u16 flags;
-	unsigned int busycount;
 	u16 seqnum;
 };
 
