From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/12] staging/rdma/hfi1: Put QPs into error state after
 SL->SC table changes
Date: Sun, 14 Feb 2016 12:10:20 -0800
Message-ID: <20160214201017.1410.92615.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

If an SL->SC mapping table change occurs after an RC/UC QP is created,
there is no mechanism to change the SC nor the VL for that QP. The fix
is to place the QP into error state so that ULP can recreate the QP with
the new SL->SC mapping.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   13 ++++++++--
 drivers/staging/rdma/hfi1/qp.c  |   52 +++++++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/qp.h  |    1 +
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 2fcc9f3..d9efe22 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -55,6 +55,7 @@
 #include "hfi.h"
 #include "mad.h"
 #include "trace.h"
+#include "qp.h"
 
 /* the reset value from the FM is supposed to be 0xffff, handle both */
 #define OPA_LINK_WIDTH_RESET_OLD 0x0fff
@@ -1517,14 +1518,22 @@ static int __subn_set_opa_sl_to_sc(struct opa_smp *smp, u32 am, u8 *data,
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
 	u8 *p = data;
 	int i;
+	u8 sc;
 
 	if (am) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	for (i = 0; i <  ARRAY_SIZE(ibp->sl_to_sc); i++)
-		ibp->sl_to_sc[i] = *p++;
+	for (i = 0; i <  ARRAY_SIZE(ibp->sl_to_sc); i++) {
+		sc = *p++;
+		if (ibp->sl_to_sc[i] != sc) {
+			ibp->sl_to_sc[i] = sc;
+
+			/* Put all stale qps into error state */
+			hfi1_error_port_qps(ibp, i);
+		}
+	}
 
 	return __subn_get_opa_sl_to_sc(smp, am, data, ibdev, port, resp_len);
 }
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 1f6b55e..11f3393 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -841,3 +841,55 @@ void notify_error_qp(struct rvt_qp *qp)
 	}
 }
 
+/**
+ * hfi1_error_port_qps - put a port's RC/UC qps into error state
+ * @ibp: the ibport.
+ * @sl: the service level.
+ *
+ * This function places all RC/UC qps with a given service level into error
+ * state. It is generally called to force upper lay apps to abandon stale qps
+ * after an sl->sc mapping change.
+ */
+void hfi1_error_port_qps(struct hfi1_ibport *ibp, u8 sl)
+{
+	struct rvt_qp *qp = NULL;
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct hfi1_ibdev *dev = &ppd->dd->verbs_dev;
+	int n;
+	int lastwqe;
+	struct ib_event ev;
+
+	rcu_read_lock();
+
+	/* Deal only with RC/UC qps that use the given SL. */
+	for (n = 0; n < dev->rdi.qp_dev->qp_table_size; n++) {
+		for (qp = rcu_dereference(dev->rdi.qp_dev->qp_table[n]); qp;
+			qp = rcu_dereference(qp->next)) {
+			if (qp->port_num == ppd->port &&
+			    (qp->ibqp.qp_type == IB_QPT_UC ||
+			     qp->ibqp.qp_type == IB_QPT_RC) &&
+			    qp->remote_ah_attr.sl == sl &&
+			    (ib_rvt_state_ops[qp->state] &
+			     RVT_POST_SEND_OK)) {
+				spin_lock_irq(&qp->r_lock);
+				spin_lock(&qp->s_hlock);
+				spin_lock(&qp->s_lock);
+				lastwqe = rvt_error_qp(qp,
+						       IB_WC_WR_FLUSH_ERR);
+				spin_unlock(&qp->s_lock);
+				spin_unlock(&qp->s_hlock);
+				spin_unlock_irq(&qp->r_lock);
+				if (lastwqe) {
+					ev.device = qp->ibqp.device;
+					ev.element.qp = &qp->ibqp;
+					ev.event =
+						IB_EVENT_QP_LAST_WQE_REACHED;
+					qp->ibqp.event_handler(&ev,
+						qp->ibqp.qp_context);
+				}
+			}
+		}
+	}
+
+	rcu_read_unlock();
+}
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 98827b5..afc2b4d 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -158,4 +158,5 @@ void stop_send_queue(struct rvt_qp *qp);
 void quiesce_qp(struct rvt_qp *qp);
 u32 mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu);
 int mtu_to_path_mtu(u32 mtu);
+void hfi1_error_port_qps(struct hfi1_ibport *ibp, u8 sl);
 #endif /* _QP_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
