From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 09/27] IB/hfi1: Use address handle in rdmavt and remove
 from hfi1
Date: Sat, 09 Jan 2016 07:17:28 -0800
Message-ID: <20160109151727.30800.86827.stgit@scvm10.sc.intel.com>
References: <20160109151020.30800.82395.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160109151020.30800.82395.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Original patch from Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, split
apart from original and modified to accomodate recent changes
in rdmavt.

Remove AH from hfi1 and use rdmavt version.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/common.h |    2 -
 drivers/staging/rdma/hfi1/mad.c    |    2 -
 drivers/staging/rdma/hfi1/qp.c     |    6 +-
 drivers/staging/rdma/hfi1/ruc.c    |    2 -
 drivers/staging/rdma/hfi1/ud.c     |    4 +
 drivers/staging/rdma/hfi1/verbs.c  |  131 ++----------------------------------
 drivers/staging/rdma/hfi1/verbs.h  |   20 +----
 7 files changed, 18 insertions(+), 149 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/common.h b/drivers/staging/rdma/hfi1/common.h
index 5e20323..bae2946 100644
--- a/drivers/staging/rdma/hfi1/common.h
+++ b/drivers/staging/rdma/hfi1/common.h
@@ -340,7 +340,6 @@ struct hfi1_message_header {
 #define FULL_MGMT_P_KEY      0xFFFF
 
 #define DEFAULT_P_KEY LIM_MGMT_P_KEY
-#define HFI1_PERMISSIVE_LID 0xFFFF
 #define HFI1_AETH_CREDIT_SHIFT 24
 #define HFI1_AETH_CREDIT_MASK 0x1F
 #define HFI1_AETH_CREDIT_INVAL 0x1F
@@ -352,7 +351,6 @@ struct hfi1_message_header {
 #define HFI1_BECN_SHIFT 30
 #define HFI1_BECN_MASK 1
 #define HFI1_BECN_SMASK (1 << HFI1_BECN_SHIFT)
-#define HFI1_MULTICAST_LID_BASE 0xC000
 
 static inline __u64 rhf_to_cpu(const __le32 *rbuf)
 {
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 9378fe8..82e3eb8 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -137,7 +137,7 @@ static void send_trap(struct hfi1_ibport *ibp, void *data, unsigned len)
 				ret = PTR_ERR(ah);
 			else {
 				send_buf->ah = ah;
-				ibp->sm_ah = to_iah(ah);
+				ibp->sm_ah = ibah_to_rvtah(ah);
 				ret = 0;
 			}
 		} else
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index fcc2773..83786d2 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -423,7 +423,7 @@ static void clear_mr_refs(struct hfi1_qp *qp, int clr_sends)
 			if (qp->ibqp.qp_type == IB_QPT_UD ||
 			    qp->ibqp.qp_type == IB_QPT_SMI ||
 			    qp->ibqp.qp_type == IB_QPT_GSI)
-				atomic_dec(&to_iah(wqe->ud_wr.ah)->refcount);
+				atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 			if (++qp->s_last >= qp->s_size)
 				qp->s_last = 0;
 		}
@@ -639,7 +639,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_AV) {
 		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
-		if (hfi1_check_ah(qp->ibqp.device, &attr->ah_attr))
+		if (rvt_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
 	}
 
@@ -647,7 +647,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->alt_ah_attr.dlid >=
 		    be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
-		if (hfi1_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
+		if (rvt_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
 		if (attr->alt_pkey_index >= hfi1_get_npkeys(dd_from_dev(dev)))
 			goto inval;
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index b6f72f6..0313c20 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -916,7 +916,7 @@ void hfi1_send_complete(struct hfi1_qp *qp, struct hfi1_swqe *wqe,
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)
-		atomic_dec(&to_iah(wqe->ud_wr.ah)->refcount);
+		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	/* See ch. 11.2.4.1 and 10.7.3.1 */
 	if (!(qp->s_flags & HFI1_S_SIGNAL_REQ_WR) ||
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index 15c5a47..b8a645b 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -98,7 +98,7 @@ static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
 		goto drop;
 	}
 
-	ah_attr = &to_iah(swqe->ud_wr.ah)->attr;
+	ah_attr = &ibah_to_rvtah(swqe->ud_wr.ah)->attr;
 	ppd = ppd_from_ibp(ibp);
 
 	if (qp->ibqp.qp_num > 1) {
@@ -310,7 +310,7 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 	/* Construct the header. */
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ppd = ppd_from_ibp(ibp);
-	ah_attr = &to_iah(wqe->ud_wr.ah)->attr;
+	ah_attr = &ibah_to_rvtah(wqe->ud_wr.ah)->attr;
 	if (ah_attr->dlid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
 	    ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
 		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index a349d86..f66d630 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -453,9 +453,7 @@ static int post_one_send(struct hfi1_qp *qp, struct ib_send_wr *wr)
 		if (wqe->length > 0x80000000U)
 			goto bail_inval_free;
 	} else {
-		struct hfi1_ah *ah = to_iah(ud_wr(wr)->ah);
-
-		atomic_inc(&ah->refcount);
+		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
 	}
 	wqe->ssn = qp->s_ssn++;
 	qp->s_head = next;
@@ -1626,88 +1624,21 @@ u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah)
 	return ibp->sl_to_sc[ah->sl];
 }
 
-int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
+static int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 {
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
 	struct hfi1_devdata *dd;
 	u8 sc5;
 
-	/* A multicast address requires a GRH (see ch. 8.4.1). */
-	if (ah_attr->dlid >= HFI1_MULTICAST_LID_BASE &&
-	    ah_attr->dlid != HFI1_PERMISSIVE_LID &&
-	    !(ah_attr->ah_flags & IB_AH_GRH))
-		goto bail;
-	if ((ah_attr->ah_flags & IB_AH_GRH) &&
-	    ah_attr->grh.sgid_index >= HFI1_GUIDS_PER_PORT)
-		goto bail;
-	if (ah_attr->dlid == 0)
-		goto bail;
-	if (ah_attr->port_num < 1 ||
-	    ah_attr->port_num > ibdev->phys_port_cnt)
-		goto bail;
-	if (ah_attr->static_rate != IB_RATE_PORT_CURRENT &&
-	    ib_rate_to_mbps(ah_attr->static_rate) < 0)
-		goto bail;
-	if (ah_attr->sl >= OPA_MAX_SLS)
-		goto bail;
 	/* test the mapping for validity */
 	ibp = to_iport(ibdev, ah_attr->port_num);
 	ppd = ppd_from_ibp(ibp);
 	sc5 = ibp->sl_to_sc[ah_attr->sl];
 	dd = dd_from_ppd(ppd);
 	if (sc_to_vlt(dd, sc5) > num_vls && sc_to_vlt(dd, sc5) != 0xf)
-		goto bail;
+		return -EINVAL;
 	return 0;
-bail:
-	return -EINVAL;
-}
-
-/**
- * create_ah - create an address handle
- * @pd: the protection domain
- * @ah_attr: the attributes of the AH
- *
- * This may be called from interrupt context.
- */
-static struct ib_ah *create_ah(struct ib_pd *pd,
-			       struct ib_ah_attr *ah_attr)
-{
-	struct hfi1_ah *ah;
-	struct ib_ah *ret;
-	struct hfi1_ibdev *dev = to_idev(pd->device);
-	unsigned long flags;
-
-	if (hfi1_check_ah(pd->device, ah_attr)) {
-		ret = ERR_PTR(-EINVAL);
-		goto bail;
-	}
-
-	ah = kmalloc(sizeof(*ah), GFP_ATOMIC);
-	if (!ah) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	spin_lock_irqsave(&dev->n_ahs_lock, flags);
-	if (dev->n_ahs_allocated == hfi1_max_ahs) {
-		spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
-		kfree(ah);
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	dev->n_ahs_allocated++;
-	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
-
-	/* ib_create_ah() will initialize ah->ibah. */
-	ah->attr = *ah_attr;
-	atomic_set(&ah->refcount, 0);
-
-	ret = &ah->ibah;
-
-bail:
-	return ret;
 }
 
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
@@ -1728,51 +1659,6 @@ struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
 }
 
 /**
- * destroy_ah - destroy an address handle
- * @ibah: the AH to destroy
- *
- * This may be called from interrupt context.
- */
-static int destroy_ah(struct ib_ah *ibah)
-{
-	struct hfi1_ibdev *dev = to_idev(ibah->device);
-	struct hfi1_ah *ah = to_iah(ibah);
-	unsigned long flags;
-
-	if (atomic_read(&ah->refcount) != 0)
-		return -EBUSY;
-
-	spin_lock_irqsave(&dev->n_ahs_lock, flags);
-	dev->n_ahs_allocated--;
-	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
-
-	kfree(ah);
-
-	return 0;
-}
-
-static int modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
-{
-	struct hfi1_ah *ah = to_iah(ibah);
-
-	if (hfi1_check_ah(ibah->device, ah_attr))
-		return -EINVAL;
-
-	ah->attr = *ah_attr;
-
-	return 0;
-}
-
-static int query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
-{
-	struct hfi1_ah *ah = to_iah(ibah);
-
-	*ah_attr = ah->attr;
-
-	return 0;
-}
-
-/**
  * hfi1_get_npkeys - return the size of the PKEY table for context 0
  * @dd: the hfi1_ib device
  */
@@ -1890,7 +1776,6 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 
-	spin_lock_init(&dev->n_ahs_lock);
 	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
@@ -2000,10 +1885,10 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->dealloc_ucontext = dealloc_ucontext;
 	ibdev->alloc_pd = NULL;
 	ibdev->dealloc_pd = NULL;
-	ibdev->create_ah = create_ah;
-	ibdev->destroy_ah = destroy_ah;
-	ibdev->modify_ah = modify_ah;
-	ibdev->query_ah = query_ah;
+	ibdev->create_ah = NULL;
+	ibdev->destroy_ah = NULL;
+	ibdev->modify_ah = NULL;
+	ibdev->query_ah = NULL;
 	ibdev->create_srq = hfi1_create_srq;
 	ibdev->modify_srq = hfi1_modify_srq;
 	ibdev->query_srq = hfi1_query_srq;
@@ -2044,6 +1929,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.port_callback = hfi1_create_port_files;
 	dd->verbs_dev.rdi.driver_f.get_card_name = get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = get_pci_dev;
+	dd->verbs_dev.rdi.driver_f.check_ah = hfi1_check_ah;
+	dd->verbs_dev.rdi.dparms.props.max_ah = hfi1_max_ahs;
 	dd->verbs_dev.rdi.dparms.props.max_pd = hfi1_max_pds;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_MR_INIT_DRIVER |
 				   RVT_FLAG_QP_INIT_DRIVER |
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index b6f3fb0..5116e51 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -234,13 +234,6 @@ struct hfi1_mcast {
 	int n_attached;
 };
 
-/* Address Handle */
-struct hfi1_ah {
-	struct ib_ah ibah;
-	struct ib_ah_attr attr;
-	atomic_t refcount;
-};
-
 /*
  * This structure is used by hfi1_mmap() to validate an offset
  * when an mmap() request is made.  The vm_area_struct then uses
@@ -639,8 +632,8 @@ static inline void inc_opstats(
 struct hfi1_ibport {
 	struct hfi1_qp __rcu *qp[2];
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
-	struct hfi1_ah *sm_ah;
-	struct hfi1_ah *smi_ah;
+	struct rvt_ah *sm_ah;
+	struct rvt_ah *smi_ah;
 	struct rb_root mcast_tree;
 	spinlock_t lock;		/* protect changes in this struct */
 
@@ -722,8 +715,6 @@ struct hfi1_ibdev {
 	u64 n_kmem_wait;
 	u64 n_send_schedule;
 
-	u32 n_ahs_allocated;    /* number of AHs allocated for device */
-	spinlock_t n_ahs_lock;
 	u32 n_cqs_allocated;    /* number of CQs allocated for device */
 	spinlock_t n_cqs_lock;
 	u32 n_qps_allocated;    /* number of QPs allocated for device */
@@ -761,11 +752,6 @@ static inline struct hfi1_mr *to_imr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct hfi1_mr, ibmr);
 }
 
-static inline struct hfi1_ah *to_iah(struct ib_ah *ibah)
-{
-	return container_of(ibah, struct hfi1_ah, ibah);
-}
-
 static inline struct hfi1_cq *to_icq(struct ib_cq *ibcq)
 {
 	return container_of(ibcq, struct hfi1_cq, ibcq);
@@ -914,8 +900,6 @@ void hfi1_rc_hdrerr(
 
 u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 
-int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
-
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
 void hfi1_rc_rnr_retry(unsigned long arg);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
