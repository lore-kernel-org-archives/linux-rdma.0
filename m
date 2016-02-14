From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/12] IB/qib: Rename several functions by adding a "qib_"
 prefix
Date: Sun, 14 Feb 2016 12:09:55 -0800
Message-ID: <20160214200950.1410.66763.stgit@scvm10.sc.intel.com>
References: <20160214200613.1410.63195.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214200613.1410.63195.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This would avoid conflict with the functions in hfi1 that have similar
names when both qib and hfi1 drivers are configured to be built into
the kernel. This issue came up in the 0-day build report.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib.h       |   16 ++++++++--------
 drivers/infiniband/hw/qib/qib_qp.c    |   26 +++++++++++++-------------
 drivers/infiniband/hw/qib/qib_verbs.c |   26 +++++++++++++-------------
 drivers/infiniband/hw/qib/qib_verbs.h |   10 +++++-----
 4 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 5ba073e..bbf0a16 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -1540,13 +1540,13 @@ void qib_format_hwerrors(u64 hwerrs,
 			 const struct qib_hwerror_msgs *hwerrmsgs,
 			 size_t nhwerrmsgs, char *msg, size_t lmsg);
 
-void stop_send_queue(struct rvt_qp *qp);
-void quiesce_qp(struct rvt_qp *qp);
-void flush_qp_waiters(struct rvt_qp *qp);
-int mtu_to_path_mtu(u32 mtu);
-u32 mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu);
-void notify_error_qp(struct rvt_qp *qp);
-int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-		       struct ib_qp_attr *attr);
+void qib_stop_send_queue(struct rvt_qp *qp);
+void qib_quiesce_qp(struct rvt_qp *qp);
+void qib_flush_qp_waiters(struct rvt_qp *qp);
+int qib_mtu_to_path_mtu(u32 mtu);
+u32 qib_mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu);
+void qib_notify_error_qp(struct rvt_qp *qp);
+int qib_get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			   struct ib_qp_attr *attr);
 
 #endif                          /* _QIB_KERNEL_H */
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 787116f..01d49dc 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -127,8 +127,8 @@ static void get_map_page(struct rvt_qpn_table *qpt, struct rvt_qpn_map *map,
  * Allocate the next available QPN or
  * zero/one for QP type IB_QPT_SMI/IB_QPT_GSI.
  */
-int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-	      enum ib_qp_type type, u8 port, gfp_t gfp)
+int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+		  enum ib_qp_type type, u8 port, gfp_t gfp)
 {
 	u32 i, offset, max_scan, qpn;
 	struct rvt_qpn_map *map;
@@ -232,14 +232,14 @@ unsigned qib_free_all_qps(struct rvt_dev_info *rdi)
 	return qp_inuse;
 }
 
-void notify_qp_reset(struct rvt_qp *qp)
+void qib_notify_qp_reset(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 
 	atomic_set(&priv->s_dma_busy, 0);
 }
 
-void notify_error_qp(struct rvt_qp *qp)
+void qib_notify_error_qp(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
@@ -290,8 +290,8 @@ static int mtu_to_enum(u32 mtu)
 	return enum_mtu;
 }
 
-int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
-		       struct ib_qp_attr *attr)
+int qib_get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
+			   struct ib_qp_attr *attr)
 {
 	int mtu, pmtu, pidx = qp->port_num - 1;
 	struct qib_ibdev *verbs_dev = container_of(rdi, struct qib_ibdev, rdi);
@@ -308,12 +308,12 @@ int get_pmtu_from_attr(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 	return pmtu;
 }
 
-int mtu_to_path_mtu(u32 mtu)
+int qib_mtu_to_path_mtu(u32 mtu)
 {
 	return mtu_to_enum(mtu);
 }
 
-u32 mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu)
+u32 qib_mtu_from_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp, u32 pmtu)
 {
 	return ib_mtu_enum_to_int(pmtu);
 }
@@ -378,7 +378,7 @@ __be32 qib_compute_aeth(struct rvt_qp *qp)
 	return cpu_to_be32(aeth);
 }
 
-void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
+void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
 {
 	struct qib_qp_priv *priv;
 
@@ -399,7 +399,7 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp)
 	return priv;
 }
 
-void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
+void qib_qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 
@@ -407,7 +407,7 @@ void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp)
 	kfree(priv);
 }
 
-void stop_send_queue(struct rvt_qp *qp)
+void qib_stop_send_queue(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 
@@ -415,7 +415,7 @@ void stop_send_queue(struct rvt_qp *qp)
 	del_timer_sync(&qp->s_timer);
 }
 
-void quiesce_qp(struct rvt_qp *qp)
+void qib_quiesce_qp(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 
@@ -426,7 +426,7 @@ void quiesce_qp(struct rvt_qp *qp)
 	}
 }
 
-void flush_qp_waiters(struct rvt_qp *qp)
+void qib_flush_qp_waiters(struct rvt_qp *qp)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct qib_ibdev *dev = to_idev(qp->ibqp.device);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 2abe31d..fa94f78 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1394,7 +1394,7 @@ bail:
 	return ret;
 }
 
-static int shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
+static int qib_shut_down_port(struct rvt_dev_info *rdi, u8 port_num)
 {
 	struct qib_ibdev *ibdev = container_of(rdi, struct qib_ibdev, rdi);
 	struct qib_devdata *dd = dd_from_dev(ibdev);
@@ -1663,22 +1663,22 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
 	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
 	dd->verbs_dev.rdi.driver_f.notify_new_ah = qib_notify_new_ah;
-	dd->verbs_dev.rdi.driver_f.alloc_qpn = alloc_qpn;
-	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qp_priv_alloc;
-	dd->verbs_dev.rdi.driver_f.qp_priv_free = qp_priv_free;
+	dd->verbs_dev.rdi.driver_f.alloc_qpn = qib_alloc_qpn;
+	dd->verbs_dev.rdi.driver_f.qp_priv_alloc = qib_qp_priv_alloc;
+	dd->verbs_dev.rdi.driver_f.qp_priv_free = qib_qp_priv_free;
 	dd->verbs_dev.rdi.driver_f.free_all_qps = qib_free_all_qps;
-	dd->verbs_dev.rdi.driver_f.notify_qp_reset = notify_qp_reset;
+	dd->verbs_dev.rdi.driver_f.notify_qp_reset = qib_notify_qp_reset;
 	dd->verbs_dev.rdi.driver_f.do_send = qib_do_send;
 	dd->verbs_dev.rdi.driver_f.schedule_send = qib_schedule_send;
-	dd->verbs_dev.rdi.driver_f.quiesce_qp = quiesce_qp;
-	dd->verbs_dev.rdi.driver_f.stop_send_queue = stop_send_queue;
-	dd->verbs_dev.rdi.driver_f.flush_qp_waiters = flush_qp_waiters;
-	dd->verbs_dev.rdi.driver_f.notify_error_qp = notify_error_qp;
-	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = mtu_to_path_mtu;
-	dd->verbs_dev.rdi.driver_f.mtu_from_qp = mtu_from_qp;
-	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = get_pmtu_from_attr;
+	dd->verbs_dev.rdi.driver_f.quiesce_qp = qib_quiesce_qp;
+	dd->verbs_dev.rdi.driver_f.stop_send_queue = qib_stop_send_queue;
+	dd->verbs_dev.rdi.driver_f.flush_qp_waiters = qib_flush_qp_waiters;
+	dd->verbs_dev.rdi.driver_f.notify_error_qp = qib_notify_error_qp;
+	dd->verbs_dev.rdi.driver_f.mtu_to_path_mtu = qib_mtu_to_path_mtu;
+	dd->verbs_dev.rdi.driver_f.mtu_from_qp = qib_mtu_from_qp;
+	dd->verbs_dev.rdi.driver_f.get_pmtu_from_attr = qib_get_pmtu_from_attr;
 	dd->verbs_dev.rdi.driver_f.query_port_state = qib_query_port;
-	dd->verbs_dev.rdi.driver_f.shut_down_port = shut_down_port;
+	dd->verbs_dev.rdi.driver_f.shut_down_port = qib_shut_down_port;
 	dd->verbs_dev.rdi.driver_f.cap_mask_chg = qib_cap_mask_chg;
 
 	dd->verbs_dev.rdi.dparms.max_rdma_atomic = QIB_MAX_RDMA_ATOMIC;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index cd73a97..b88e027 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -350,11 +350,11 @@ __be32 qib_compute_aeth(struct rvt_qp *qp);
  * Functions provided by qib driver for rdmavt to use
  */
 unsigned qib_free_all_qps(struct rvt_dev_info *rdi);
-void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp);
-void qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
-void notify_qp_reset(struct rvt_qp *qp);
-int alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
-	      enum ib_qp_type type, u8 port, gfp_t gfp);
+void *qib_qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp, gfp_t gfp);
+void qib_qp_priv_free(struct rvt_dev_info *rdi, struct rvt_qp *qp);
+void qib_notify_qp_reset(struct rvt_qp *qp);
+int qib_alloc_qpn(struct rvt_dev_info *rdi, struct rvt_qpn_table *qpt,
+		  enum ib_qp_type type, u8 port, gfp_t gfp);
 
 #ifdef CONFIG_DEBUG_FS
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
