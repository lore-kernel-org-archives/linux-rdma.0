From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/16] IB/qib, staging/rdma/hfi1,
 IB/rdmavt: progress selection changes
Date: Sun, 14 Feb 2016 12:45:44 -0800
Message-ID: <20160214204541.29247.82706.stgit@scvm10.sc.intel.com>
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

The non-rdamvt versions of qib and hfi1 allow for a differing
heuristic to override a schedule progress in favor of a direct
call the the progress routine.

This patch adds that for both drivers and rdmavt.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_qp.c |    7 +++++--
 drivers/infiniband/sw/rdmavt/qp.c  |   10 +++++++---
 drivers/staging/rdma/hfi1/qp.c     |    3 ++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 6ffa022..575b737 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -484,12 +484,13 @@ void qib_get_credit(struct rvt_qp *qp, u32 aeth)
  * the ring but after the wqe has been
  * setup.
  *
- * Returns 0 on success, -EINVAL on failure
+ * Returns 1 to force direct progress, 0 otherwise, -EINVAL on failure
  */
 int qib_check_send_wqe(struct rvt_qp *qp,
 		       struct rvt_swqe *wqe)
 {
 	struct rvt_ah *ah;
+	int ret = 0;
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
@@ -503,11 +504,13 @@ int qib_check_send_wqe(struct rvt_qp *qp,
 		ah = ibah_to_rvtah(wqe->ud_wr.ah);
 		if (wqe->length > (1 << ah->log_pmtu))
 			return -EINVAL;
+		/* progress hint */
+		ret = 1;
 		break;
 	default:
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index dbf124d..ef82abf 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1430,7 +1430,9 @@ static inline u32 qp_get_savail(struct rvt_qp *qp)
  * @qp: the QP to post on
  * @wr: the work request to send
  */
-static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
+static int rvt_post_one_wr(struct rvt_qp *qp,
+			   struct ib_send_wr *wr,
+			   int *call_send)
 {
 	struct rvt_swqe *wqe;
 	u32 next;
@@ -1532,8 +1534,10 @@ static int rvt_post_one_wr(struct rvt_qp *qp, struct ib_send_wr *wr)
 	/* general part of wqe valid - allow for driver checks */
 	if (rdi->driver_f.check_send_wqe) {
 		ret = rdi->driver_f.check_send_wqe(qp, wqe);
-		if (ret)
+		if (ret < 0)
 			goto bail_inval_free;
+		if (ret)
+			*call_send = ret;
 	}
 
 	log_pmtu = qp->log_pmtu;
@@ -1606,7 +1610,7 @@ int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	call_send = qp->s_head == ACCESS_ONCE(qp->s_last) && !wr->next;
 
 	for (; wr; wr = wr->next) {
-		err = rvt_post_one_wr(qp, wr);
+		err = rvt_post_one_wr(qp, wr, &call_send);
 		if (unlikely(err)) {
 			*bad_wr = wr;
 			goto bail;
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 045da1b..e699b6a 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -73,6 +73,7 @@ static int iowait_sleep(
 	struct sdma_txreq *stx,
 	unsigned seq);
 static void iowait_wakeup(struct iowait *wait, int reason);
+static void qp_pio_drain(struct rvt_qp *qp);
 
 static inline unsigned mk_qpn(struct rvt_qpn_table *qpt,
 			      struct rvt_qpn_map *map, unsigned off)
@@ -272,7 +273,7 @@ int hfi1_check_send_wqe(struct rvt_qp *qp,
 	default:
 		break;
 	}
-	return 0;
+	return wqe->length <= piothreshold;
 }
 
 /**

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
