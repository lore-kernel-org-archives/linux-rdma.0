From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/24] IB/qib: change rcv queue/qpn selection
Date: Tue, 28 Dec 2010 10:28:19 -0500
Message-ID: <20101228152818.19960.95045.stgit@kop-dev-sles11-04.qlogic.org>
References: <20101228152648.19960.84006.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101228152648.19960.84006.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The basic idea is that on SusieQ, the difficult part of mapping QPN to context
is handled by the mapping registers so the generic QPN allocation doesn't need
to worry about chip specifics. For Monty and Linda, there is no mapping table
so the qpt->mask (same as dd->qpn_mask), is used to see if the QPN to context
falls within [zero..dd->n_krcv_queues).

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7220.c |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c |    8 ++------
 drivers/infiniband/hw/qib/qib_qp.c      |   26 ++++++++++----------------
 drivers/infiniband/hw/qib/qib_verbs.h   |   10 ++--------
 4 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7220.c b/drivers/infiniband/hw/qib/qib_iba7220.c
index df49e8e..127a0d5 100644
--- a/drivers/infiniband/hw/qib/qib_iba7220.c
+++ b/drivers/infiniband/hw/qib/qib_iba7220.c
@@ -2297,7 +2297,7 @@ static void qib_7220_config_ctxts(struct qib_devdata *dd)
 	nchipctxts = qib_read_kreg32(dd, kr_portcnt);
 	dd->cspec->numctxts = nchipctxts;
 	if (qib_n_krcv_queues > 1) {
-		dd->qpn_mask = 0x3f;
+		dd->qpn_mask = 0x3e;
 		dd->first_user_ctxt = qib_n_krcv_queues * dd->num_pports;
 		if (dd->first_user_ctxt > nchipctxts)
 			dd->first_user_ctxt = nchipctxts;
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 9bc6d08..d3b4938 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3515,11 +3515,6 @@ static void qib_7322_config_ctxts(struct qib_devdata *dd)
 	nchipctxts = qib_read_kreg32(dd, kr_contextcnt);
 	dd->cspec->numctxts = nchipctxts;
 	if (qib_n_krcv_queues > 1 && dd->num_pports) {
-		/*
-		 * Set the mask for which bits from the QPN are used
-		 * to select a context number.
-		 */
-		dd->qpn_mask = 0x3f;
 		dd->first_user_ctxt = NUM_IB_PORTS +
 			(qib_n_krcv_queues - 1) * dd->num_pports;
 		if (dd->first_user_ctxt > nchipctxts)
@@ -5865,7 +5860,8 @@ static void write_7322_initregs(struct qib_devdata *dd)
 		unsigned n, regno;
 		unsigned long flags;
 
-		if (!dd->qpn_mask || !dd->pport[pidx].link_speed_supported)
+		if (dd->n_krcv_queues < 2 ||
+			!dd->pport[pidx].link_speed_supported)
 			continue;
 
 		ppd = &dd->pport[pidx];
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 32dacd4..eaab008 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -48,13 +48,12 @@ static inline unsigned mk_qpn(struct qib_qpn_table *qpt,
 
 static inline unsigned find_next_offset(struct qib_qpn_table *qpt,
 					struct qpn_map *map, unsigned off,
-					unsigned r)
+					unsigned n)
 {
 	if (qpt->mask) {
 		off++;
-		if ((off & qpt->mask) >> 1 != r)
-			off = ((off & qpt->mask) ?
-				(off | qpt->mask) + 1 : off) | (r << 1);
+		if (((off & qpt->mask) >> 1) >= n)
+			off = (off | qpt->mask) + 2;
 	} else
 		off = find_next_zero_bit(map->page, BITS_PER_PAGE, off);
 	return off;
@@ -123,7 +122,6 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 	u32 i, offset, max_scan, qpn;
 	struct qpn_map *map;
 	u32 ret;
-	int r;
 
 	if (type == IB_QPT_SMI || type == IB_QPT_GSI) {
 		unsigned n;
@@ -139,15 +137,11 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 		goto bail;
 	}
 
-	r = smp_processor_id();
-	if (r >= dd->n_krcv_queues)
-		r %= dd->n_krcv_queues;
 	qpn = qpt->last + 1;
 	if (qpn >= QPN_MAX)
 		qpn = 2;
-	if (qpt->mask && ((qpn & qpt->mask) >> 1) != r)
-		qpn = ((qpn & qpt->mask) ? (qpn | qpt->mask) + 1 : qpn) |
-			(r << 1);
+	if (qpt->mask && ((qpn & qpt->mask) >> 1) >= dd->n_krcv_queues)
+		qpn = (qpn | qpt->mask) + 2;
 	offset = qpn & BITS_PER_PAGE_MASK;
 	map = &qpt->map[qpn / BITS_PER_PAGE];
 	max_scan = qpt->nmaps - !offset;
@@ -163,7 +157,8 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 				ret = qpn;
 				goto bail;
 			}
-			offset = find_next_offset(qpt, map, offset, r);
+			offset = find_next_offset(qpt, map, offset,
+				dd->n_krcv_queues);
 			qpn = mk_qpn(qpt, map, offset);
 			/*
 			 * This test differs from alloc_pidmap().
@@ -183,13 +178,13 @@ static int alloc_qpn(struct qib_devdata *dd, struct qib_qpn_table *qpt,
 			if (qpt->nmaps == QPNMAP_ENTRIES)
 				break;
 			map = &qpt->map[qpt->nmaps++];
-			offset = qpt->mask ? (r << 1) : 0;
+			offset = 0;
 		} else if (map < &qpt->map[qpt->nmaps]) {
 			++map;
-			offset = qpt->mask ? (r << 1) : 0;
+			offset = 0;
 		} else {
 			map = &qpt->map[0];
-			offset = qpt->mask ? (r << 1) : 2;
+			offset = 2;
 		}
 		qpn = mk_qpn(qpt, map, offset);
 	}
@@ -1065,7 +1060,6 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		}
 		qp->ibqp.qp_num = err;
 		qp->port_num = init_attr->port_num;
-		qp->processor_id = smp_processor_id();
 		qib_reset_qp(qp, init_attr->qp_type);
 		break;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bd57c12..a08ceab 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -435,7 +435,6 @@ struct qib_qp {
 	spinlock_t r_lock;      /* used for APM */
 	spinlock_t s_lock;
 	atomic_t s_dma_busy;
-	unsigned processor_id;	/* Processor ID QP is bound to */
 	u32 s_flags;
 	u32 s_cur_size;         /* size of send packet in bytes */
 	u32 s_len;              /* total length of s_sge */
@@ -813,13 +812,8 @@ extern struct workqueue_struct *qib_cq_wq;
  */
 static inline void qib_schedule_send(struct qib_qp *qp)
 {
-	if (qib_send_ok(qp)) {
-		if (qp->processor_id == smp_processor_id())
-			queue_work(qib_wq, &qp->s_work);
-		else
-			queue_work_on(qp->processor_id,
-				      qib_wq, &qp->s_work);
-	}
+	if (qib_send_ok(qp))
+		queue_work(qib_wq, &qp->s_work);
 }
 
 static inline int qib_pkey_ok(u16 pkey1, u16 pkey2)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
