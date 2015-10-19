From: ira.weiny@intel.com
Subject: [PATCH 17/23] staging/rdma/hfi1: Add irqsaves in the packet
 processing path
Date: Mon, 19 Oct 2015 12:43:41 -0400
Message-ID: <1445273027-29634-18-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: Dean Luick <dean.luick@intel.com>, linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick@intel.com>

When the receive interrupt is threaded, the packet processing path is no longer
guaranteed to have IRQs disabled.  Add irqsaves where needed on several locks
in the packet processing path.  Anything that did not have an obvious, "close"
irqsave in its caller is a candidate.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/driver.c |  5 +++--
 drivers/staging/rdma/hfi1/init.c   |  5 +++--
 drivers/staging/rdma/hfi1/mad.c    |  4 ++--
 drivers/staging/rdma/hfi1/rc.c     | 19 +++++++++++--------
 drivers/staging/rdma/hfi1/sdma.c   |  9 +++++----
 drivers/staging/rdma/hfi1/verbs.c  |  9 +++++----
 6 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 9f2cf9589b63..484f7c4472b0 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -310,6 +310,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 		qp_num = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
 		if (lid < HFI1_MULTICAST_LID_BASE) {
 			struct hfi1_qp *qp;
+			unsigned long flags;
 
 			rcu_read_lock();
 			qp = hfi1_lookup_qpn(ibp, qp_num);
@@ -322,7 +323,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 			 * Handle only RC QPs - for other QP types drop error
 			 * packet.
 			 */
-			spin_lock(&qp->r_lock);
+			spin_lock_irqsave(&qp->r_lock, flags);
 
 			/* Check for valid receive state. */
 			if (!(ib_hfi1_state_ops[qp->state] &
@@ -343,7 +344,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 				break;
 			}
 
-			spin_unlock(&qp->r_lock);
+			spin_unlock_irqrestore(&qp->r_lock, flags);
 			rcu_read_unlock();
 		} /* Unicast QP */
 	} /* Valid packet with TIDErr */
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 62aa7718b6d6..060ab566856a 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -413,6 +413,7 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 	int sl;
 	u16 ccti, ccti_timer, ccti_min;
 	struct cc_state *cc_state;
+	unsigned long flags;
 
 	cca_timer = container_of(t, struct cca_timer, hrtimer);
 	ppd = cca_timer->ppd;
@@ -436,7 +437,7 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 	ccti_min = cc_state->cong_setting.entries[sl].ccti_min;
 	ccti_timer = cc_state->cong_setting.entries[sl].ccti_timer;
 
-	spin_lock(&ppd->cca_timer_lock);
+	spin_lock_irqsave(&ppd->cca_timer_lock, flags);
 
 	ccti = cca_timer->ccti;
 
@@ -445,7 +446,7 @@ static enum hrtimer_restart cca_timer_fn(struct hrtimer *t)
 		set_link_ipg(ppd);
 	}
 
-	spin_unlock(&ppd->cca_timer_lock);
+	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
 
 	rcu_read_unlock();
 
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index b2c1b72d38ce..51832fb7b29c 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -3257,7 +3257,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	spin_lock(&ppd->cc_log_lock);
+	spin_lock_irq(&ppd->cc_log_lock);
 
 	cong_log->log_type = OPA_CC_LOG_TYPE_HFI;
 	cong_log->congestion_flags = 0;
@@ -3300,7 +3300,7 @@ static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
 	       sizeof(ppd->threshold_cong_event_map));
 	ppd->threshold_event_counter = 0;
 
-	spin_unlock(&ppd->cc_log_lock);
+	spin_unlock_irq(&ppd->cc_log_lock);
 
 	if (resp_len)
 		*resp_len += sizeof(struct opa_hfi1_cong_log);
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 6931ebe99b3b..8e4f421b2b58 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -697,6 +697,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct hfi1_qp *qp,
 	struct pio_buf *pbuf;
 	struct hfi1_ib_header hdr;
 	struct hfi1_other_headers *ohdr;
+	unsigned long flags;
 
 	/* Don't send ACK or NAK if a RDMA read or atomic is pending. */
 	if (qp->s_flags & HFI1_S_RESP_PENDING)
@@ -771,7 +772,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct hfi1_qp *qp,
 
 queue_ack:
 	this_cpu_inc(*ibp->rc_qacks);
-	spin_lock(&qp->s_lock);
+	spin_lock_irqsave(&qp->s_lock, flags);
 	qp->s_flags |= HFI1_S_ACK_PENDING | HFI1_S_RESP_PENDING;
 	qp->s_nak_state = qp->r_nak_state;
 	qp->s_ack_psn = qp->r_ack_psn;
@@ -780,7 +781,7 @@ queue_ack:
 
 	/* Schedule the send tasklet. */
 	hfi1_schedule_send(qp);
-	spin_unlock(&qp->s_lock);
+	spin_unlock_irqrestore(&qp->s_lock, flags);
 }
 
 /**
@@ -1152,7 +1153,7 @@ static struct hfi1_swqe *do_rc_completion(struct hfi1_qp *qp,
  *
  * This is called from rc_rcv_resp() to process an incoming RC ACK
  * for the given QP.
- * Called at interrupt level with the QP s_lock held.
+ * May be called at interrupt level, with the QP s_lock held.
  * Returns 1 if OK, 0 if current operation should be aborted (NAK).
  */
 static int do_rc_ack(struct hfi1_qp *qp, u32 aeth, u32 psn, int opcode,
@@ -1835,11 +1836,12 @@ static void log_cca_event(struct hfi1_pportdata *ppd, u8 sl, u32 rlid,
 			  u32 lqpn, u32 rqpn, u8 svc_type)
 {
 	struct opa_hfi1_cong_log_event_internal *cc_event;
+	unsigned long flags;
 
 	if (sl >= OPA_MAX_SLS)
 		return;
 
-	spin_lock(&ppd->cc_log_lock);
+	spin_lock_irqsave(&ppd->cc_log_lock, flags);
 
 	ppd->threshold_cong_event_map[sl/8] |= 1 << (sl % 8);
 	ppd->threshold_event_counter++;
@@ -1855,7 +1857,7 @@ static void log_cca_event(struct hfi1_pportdata *ppd, u8 sl, u32 rlid,
 	/* keep timestamp in units of 1.024 usec */
 	cc_event->timestamp = ktime_to_ns(ktime_get()) / 1024;
 
-	spin_unlock(&ppd->cc_log_lock);
+	spin_unlock_irqrestore(&ppd->cc_log_lock, flags);
 }
 
 void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
@@ -1865,6 +1867,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 	u16 ccti, ccti_incr, ccti_timer, ccti_limit;
 	u8 trigger_threshold;
 	struct cc_state *cc_state;
+	unsigned long flags;
 
 	if (sl >= OPA_MAX_SLS)
 		return;
@@ -1887,7 +1890,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 	trigger_threshold =
 		cc_state->cong_setting.entries[sl].trigger_threshold;
 
-	spin_lock(&ppd->cca_timer_lock);
+	spin_lock_irqsave(&ppd->cca_timer_lock, flags);
 
 	if (cca_timer->ccti < ccti_limit) {
 		if (cca_timer->ccti + ccti_incr <= ccti_limit)
@@ -1897,7 +1900,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
 		set_link_ipg(ppd);
 	}
 
-	spin_unlock(&ppd->cca_timer_lock);
+	spin_unlock_irqrestore(&ppd->cca_timer_lock, flags);
 
 	ccti = cca_timer->ccti;
 
@@ -1924,7 +1927,7 @@ void process_becn(struct hfi1_pportdata *ppd, u8 sl, u16 rlid, u32 lqpn,
  *
  * This is called from qp_rcv() to process an incoming RC packet
  * for the given QP.
- * Called at interrupt level.
+ * May be called at interrupt level.
  */
 void hfi1_rc_rcv(struct hfi1_packet *packet)
 {
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 452e7edcee7a..54c146afe52f 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -383,16 +383,17 @@ static void sdma_flush(struct sdma_engine *sde)
 {
 	struct sdma_txreq *txp, *txp_next;
 	LIST_HEAD(flushlist);
+	unsigned long flags;
 
 	/* flush from head to tail */
 	sdma_flush_descq(sde);
-	spin_lock(&sde->flushlist_lock);
+	spin_lock_irqsave(&sde->flushlist_lock, flags);
 	/* copy flush list */
 	list_for_each_entry_safe(txp, txp_next, &sde->flushlist, list) {
 		list_del_init(&txp->list);
 		list_add_tail(&txp->list, &flushlist);
 	}
-	spin_unlock(&sde->flushlist_lock);
+	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list) {
 		int drained = 0;
@@ -2095,9 +2096,9 @@ unlock_noconn:
 	tx->sn = sde->tail_sn++;
 	trace_hfi1_sdma_in_sn(sde, tx->sn);
 #endif
-	spin_lock(&sde->flushlist_lock);
+	spin_lock_irqsave(&sde->flushlist_lock, flags);
 	list_add_tail(&tx->list, &sde->flushlist);
-	spin_unlock(&sde->flushlist_lock);
+	spin_unlock_irqrestore(&sde->flushlist_lock, flags);
 	if (wait) {
 		wait->tx_count++;
 		wait->count += tx->num_desc;
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 8456e82b2ab1..a5bcb1036aba 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -597,6 +597,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	u32 tlen = packet->tlen;
 	struct hfi1_pportdata *ppd = rcd->ppd;
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
+	unsigned long flags;
 	u32 qp_num;
 	int lnh;
 	u8 opcode;
@@ -639,10 +640,10 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 			goto drop;
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
-			spin_lock(&packet->qp->r_lock);
+			spin_lock_irqsave(&packet->qp->r_lock, flags);
 			if (likely((qp_ok(opcode, packet))))
 				opcode_handler_tbl[opcode](packet);
-			spin_unlock(&packet->qp->r_lock);
+			spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		}
 		/*
 		 * Notify hfi1_multicast_detach() if it is waiting for us
@@ -657,10 +658,10 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 			rcu_read_unlock();
 			goto drop;
 		}
-		spin_lock(&packet->qp->r_lock);
+		spin_lock_irqsave(&packet->qp->r_lock, flags);
 		if (likely((qp_ok(opcode, packet))))
 			opcode_handler_tbl[opcode](packet);
-		spin_unlock(&packet->qp->r_lock);
+		spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		rcu_read_unlock();
 	}
 	return;
-- 
1.8.2
