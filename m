From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/16] staging/rdma/hfi1: fix panic in send engine
Date: Sun, 14 Feb 2016 12:45:18 -0800
Message-ID: <20160214204514.29247.68393.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The send engine wasn't correctly handling
pre-built packets, and worse, the pointer to
a packet state's txreq wasn't initialized correctly.

To fix:
- all waiters need to save any prebuilt packets
  (smda waits already did)
- the progress routine needs to handle a QPs prebuilt packet
  and initialize the txreq pointer properly

To keep SDMA working, the dma send code needs to see if
a packet has been built already. If not the code will build
it.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/iowait.h      |   20 +++++++
 drivers/staging/rdma/hfi1/rc.c          |    4 +
 drivers/staging/rdma/hfi1/ruc.c         |    2 +
 drivers/staging/rdma/hfi1/sdma_txreq.h  |    5 ++
 drivers/staging/rdma/hfi1/uc.c          |    2 +
 drivers/staging/rdma/hfi1/ud.c          |    6 ++
 drivers/staging/rdma/hfi1/verbs.c       |   85 +++++++++++++++----------------
 drivers/staging/rdma/hfi1/verbs_txreq.h |   17 ++++++
 8 files changed, 95 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/iowait.h b/drivers/staging/rdma/hfi1/iowait.h
index e8ba560..e007eb8 100644
--- a/drivers/staging/rdma/hfi1/iowait.h
+++ b/drivers/staging/rdma/hfi1/iowait.h
@@ -54,6 +54,7 @@
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 
+#include "sdma_txreq.h"
 /*
  * typedef (*restart_t)() - restart callback
  * @work: pointer to work structure
@@ -185,4 +186,23 @@ static inline void iowait_drain_wakeup(struct iowait *wait)
 	wake_up(&wait->wait_dma);
 }
 
+/**
+ * iowait_get_txhead() - get packet off of iowait list
+ *
+ * @wait wait struture
+ */
+static inline struct sdma_txreq *iowait_get_txhead(struct iowait *wait)
+{
+	struct sdma_txreq *tx = NULL;
+
+	if (!list_empty(&wait->tx_head)) {
+		tx = list_first_entry(
+			&wait->tx_head,
+			struct sdma_txreq,
+			list);
+		list_del_init(&tx->list);
+	}
+	return tx;
+}
+
 #endif
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index d54d3ad..2704287 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -348,6 +348,8 @@ normal:
 	}
 	qp->s_rdma_ack_cnt++;
 	qp->s_hdrwords = hwords;
+	/* pbc */
+	ps->s_txreq->hdr_dwords = hwords + 2;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0, bth2, middle, ps);
 	return 1;
@@ -750,6 +752,8 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	}
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
+	/* pbc */
+	ps->s_txreq->hdr_dwords = hwords + 2;
 	qp->s_cur_sge = ss;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 70d1d34..70f42c9 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -879,6 +879,8 @@ void hfi1_do_send(struct rvt_qp *qp)
 	timeout = jiffies + (timeout_int) / 8;
 	cpu = priv->s_sde ? priv->s_sde->cpu :
 			cpumask_first(cpumask_of_node(ps.ppd->dd->node));
+	/* insure a pre-built packet is handled  */
+	ps.s_txreq = get_waiting_verbs_txreq(qp);
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
diff --git a/drivers/staging/rdma/hfi1/sdma_txreq.h b/drivers/staging/rdma/hfi1/sdma_txreq.h
index d0f77a8..2effb35 100644
--- a/drivers/staging/rdma/hfi1/sdma_txreq.h
+++ b/drivers/staging/rdma/hfi1/sdma_txreq.h
@@ -127,4 +127,9 @@ struct sdma_txreq {
 	struct sdma_desc descs[NUM_DESC];
 };
 
+static inline int sdma_txreq_built(struct sdma_txreq *tx)
+{
+	return tx->num_desc;
+}
+
 #endif                          /* HFI1_SDMA_TXREQ_H */
diff --git a/drivers/staging/rdma/hfi1/uc.c b/drivers/staging/rdma/hfi1/uc.c
index 77431b1..3270561 100644
--- a/drivers/staging/rdma/hfi1/uc.c
+++ b/drivers/staging/rdma/hfi1/uc.c
@@ -235,6 +235,8 @@ int hfi1_make_uc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	}
 	qp->s_len -= len;
 	qp->s_hdrwords = hwords;
+	/* pbc */
+	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 	qp->s_cur_sge = &qp->s_sge;
 	qp->s_cur_size = len;
 	hfi1_make_ruc_header(qp, ohdr, bth0 | (qp->s_state << 24),
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 1b4b191..bae5ccd 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -53,8 +53,8 @@
 
 #include "hfi.h"
 #include "mad.h"
-#include "qp.h"
 #include "verbs_txreq.h"
+#include "qp.h"
 
 /**
  * ud_loopback - handle send on loopback QPs
@@ -394,7 +394,9 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 		priv->s_sc = sc5;
 	}
 	priv->s_sde = qp_to_sdma_engine(qp, priv->s_sc);
+	ps->s_txreq->sde = priv->s_sde;
 	priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
+	ps->s_txreq->psc = priv->s_sendcontext;
 	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
 	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(ah_attr->dlid);
 	ps->s_txreq->phdr.hdr.lrh[2] =
@@ -432,6 +434,8 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	priv->s_hdr->ahgidx = 0;
 	priv->s_hdr->tx_flags = 0;
 	priv->s_hdr->sde = NULL;
+	/* pbc */
+	ps->s_txreq->hdr_dwords = qp->s_hdrwords + 2;
 
 	return 1;
 
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index dc8eb6b..229dde5 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -547,7 +547,9 @@ static void verbs_sdma_complete(
 	hfi1_put_txreq(tx);
 }
 
-static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
+static int wait_kmem(struct hfi1_ibdev *dev,
+		     struct rvt_qp *qp,
+		     struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	unsigned long flags;
@@ -556,6 +558,8 @@ static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
+		list_add_tail(&ps->s_txreq->txreq.list,
+			      &priv->s_iowait.tx_head);
 		if (list_empty(&priv->s_iowait.list)) {
 			if (list_empty(&dev->memwait))
 				mod_timer(&dev->mem_timer, jiffies + 1);
@@ -578,7 +582,7 @@ static int wait_kmem(struct hfi1_ibdev *dev, struct rvt_qp *qp)
  *
  * Add failures will revert the sge cursor
  */
-static int build_verbs_ulp_payload(
+static noinline int build_verbs_ulp_payload(
 	struct sdma_engine *sde,
 	struct rvt_sge_state *ss,
 	u32 length,
@@ -690,48 +694,30 @@ int hfi1_verbs_send_dma(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 	struct hfi1_ibdev *dev = ps->dev;
 	struct hfi1_pportdata *ppd = ps->ppd;
 	struct verbs_txreq *tx;
-	struct sdma_txreq *stx;
 	u64 pbc_flags = 0;
 	u8 sc5 = priv->s_sc;
 
 	int ret;
-	struct hfi1_ibdev *tdev;
-
-	if (!list_empty(&priv->s_iowait.tx_head)) {
-		stx = list_first_entry(
-			&priv->s_iowait.tx_head,
-			struct sdma_txreq,
-			list);
-		list_del_init(&stx->list);
-		tx = container_of(stx, struct verbs_txreq, txreq);
-		ret = sdma_send_txreq(tx->sde, &priv->s_iowait, stx);
-		if (unlikely(ret == -ECOMM))
-			goto bail_ecomm;
-		return ret;
-	}
 
 	tx = ps->s_txreq;
-
-	tdev = to_idev(qp->ibqp.device);
-
-	if (IS_ERR(tx))
-		goto bail_tx;
-
-	tx->sde = priv->s_sde;
-
-	if (likely(pbc == 0)) {
-		u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
-		/* No vl15 here */
-		/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
-		pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
-
-		pbc = create_pbc(ppd, pbc_flags, qp->srate_mbps, vl, plen);
+	if (!sdma_txreq_built(&tx->txreq)) {
+		if (likely(pbc == 0)) {
+			u32 vl = sc_to_vlt(dd_from_ibdev(qp->ibqp.device), sc5);
+			/* No vl15 here */
+			/* set PBC_DC_INFO bit (aka SC[4]) in pbc_flags */
+			pbc_flags |= (!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT;
+
+			pbc = create_pbc(ppd,
+					 pbc_flags,
+					 qp->srate_mbps,
+					 vl,
+					 plen);
+		}
+		tx->wqe = qp->s_wqe;
+		ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
+		if (unlikely(ret))
+			goto bail_build;
 	}
-	tx->wqe = qp->s_wqe;
-	tx->hdr_dwords = hdrwords + 2;
-	ret = build_verbs_tx_desc(tx->sde, ss, len, tx, ahdr, pbc);
-	if (unlikely(ret))
-		goto bail_build;
 	trace_output_ibhdr(dd_from_ibdev(qp->ibqp.device),
 			   &ps->s_txreq->phdr.hdr);
 	ret =  sdma_send_txreq(tx->sde, &priv->s_iowait, &tx->txreq);
@@ -743,18 +729,22 @@ bail_ecomm:
 	/* The current one got "sent" */
 	return 0;
 bail_build:
-	/* kmalloc or mapping fail */
-	hfi1_put_txreq(tx);
-	return wait_kmem(dev, qp);
-bail_tx:
-	return PTR_ERR(tx);
+	ret = wait_kmem(dev, qp, ps);
+	if (!ret) {
+		/* free txreq - bad state */
+		hfi1_put_txreq(ps->s_txreq);
+		ps->s_txreq = NULL;
+	}
+	return ret;
 }
 
 /*
  * If we are now in the error state, return zero to flush the
  * send work request.
  */
-static int no_bufs_available(struct rvt_qp *qp, struct send_context *sc)
+static int no_bufs_available(struct rvt_qp *qp,
+			     struct send_context *sc,
+			     struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct hfi1_devdata *dd = sc->dd;
@@ -771,6 +761,8 @@ static int no_bufs_available(struct rvt_qp *qp, struct send_context *sc)
 	spin_lock_irqsave(&qp->s_lock, flags);
 	if (ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK) {
 		write_seqlock(&dev->iowait_lock);
+		list_add_tail(&ps->s_txreq->txreq.list,
+			      &priv->s_iowait.tx_head);
 		if (list_empty(&priv->s_iowait.list)) {
 			struct hfi1_ibdev *dev = &dd->verbs_dev;
 			int was_empty;
@@ -859,8 +851,11 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 			 * so lets continue to queue the request.
 			 */
 			hfi1_cdbg(PIO, "alloc failed. state active, queuing");
-			ret = no_bufs_available(qp, sc);
-			goto bail;
+			ret = no_bufs_available(qp, sc, ps);
+			if (!ret)
+				goto bail;
+			/* tx consumed in wait */
+			return ret;
 		}
 	}
 
diff --git a/drivers/staging/rdma/hfi1/verbs_txreq.h b/drivers/staging/rdma/hfi1/verbs_txreq.h
index d89d29b..f56149e 100644
--- a/drivers/staging/rdma/hfi1/verbs_txreq.h
+++ b/drivers/staging/rdma/hfi1/verbs_txreq.h
@@ -63,6 +63,7 @@ struct verbs_txreq {
 	struct rvt_mregion	*mr;
 	struct rvt_sge_state    *ss;
 	struct sdma_engine     *sde;
+	struct send_context     *psc;
 	u16                     hdr_dwords;
 };
 
@@ -74,6 +75,7 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 					    struct rvt_qp *qp)
 {
 	struct verbs_txreq *tx;
+	struct hfi1_qp_priv *priv = qp->priv;
 
 	tx = kmem_cache_alloc(dev->verbs_txreq_cache, GFP_ATOMIC);
 	if (unlikely(!tx)) {
@@ -84,9 +86,24 @@ static inline struct verbs_txreq *get_txreq(struct hfi1_ibdev *dev,
 	}
 	tx->qp = qp;
 	tx->mr = NULL;
+	tx->sde = priv->s_sde;
+	tx->psc = priv->s_sendcontext;
+	/* so that we can test if the sdma decriptors are there */
+	tx->txreq.num_desc = 0;
 	return tx;
 }
 
+static inline struct verbs_txreq *get_waiting_verbs_txreq(struct rvt_qp *qp)
+{
+	struct sdma_txreq *stx;
+	struct hfi1_qp_priv *priv = qp->priv;
+
+	stx = iowait_get_txhead(&priv->s_iowait);
+	if (stx)
+		return container_of(stx, struct verbs_txreq, txreq);
+	return NULL;
+}
+
 void hfi1_put_txreq(struct verbs_txreq *tx);
 int verbs_txreq_init(struct hfi1_ibdev *dev);
 void verbs_txreq_exit(struct hfi1_ibdev *dev);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
