From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/10] IB/qib: Use address handle in rdmavt and remove from
 qib
Date: Mon, 07 Dec 2015 15:49:30 -0500
Message-ID: <20151207204929.11219.5568.stgit@phlsvslse11.ph.intel.com>
References: <20151207204735.11219.68688.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204735.11219.68688.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Original patch from Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, split
apart from original.

Remove AH from qib and use rdmavt version.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    2 
 drivers/infiniband/hw/qib/qib_mad.c     |    2 
 drivers/infiniband/hw/qib/qib_qp.c      |    6 +
 drivers/infiniband/hw/qib/qib_ruc.c     |    2 
 drivers/infiniband/hw/qib/qib_ud.c      |    4 -
 drivers/infiniband/hw/qib/qib_verbs.c   |  126 ++-----------------------------
 drivers/infiniband/hw/qib/qib_verbs.h   |   20 -----
 7 files changed, 19 insertions(+), 143 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 6c8ff10..1fbe308 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5515,7 +5515,7 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 			ret = PTR_ERR(ah);
 		else {
 			send_buf->ah = ah;
-			ibp->smi_ah = to_iah(ah);
+			ibp->smi_ah = ibah_to_rvtah(ah);
 			ret = 0;
 		}
 	} else {
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 70fc1b2..43f8c49 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -109,7 +109,7 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
 				ret = PTR_ERR(ah);
 			else {
 				send_buf->ah = ah;
-				ibp->sm_ah = to_iah(ah);
+				ibp->sm_ah = ibah_to_rvtah(ah);
 				ret = 0;
 			}
 		} else
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 143924d..f3964ef 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -438,7 +438,7 @@ static void clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 			if (qp->ibqp.qp_type == IB_QPT_UD ||
 			    qp->ibqp.qp_type == IB_QPT_SMI ||
 			    qp->ibqp.qp_type == IB_QPT_GSI)
-				atomic_dec(&to_iah(wqe->ud_wr.ah)->refcount);
+				atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 			if (++qp->s_last >= qp->s_size)
 				qp->s_last = 0;
 		}
@@ -595,7 +595,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_AV) {
 		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
-		if (qib_check_ah(qp->ibqp.device, &attr->ah_attr))
+		if (rvt_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
 	}
 
@@ -603,7 +603,7 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		if (attr->alt_ah_attr.dlid >=
 		    be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
-		if (qib_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
+		if (rvt_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
 		if (attr->alt_pkey_index >= qib_get_npkeys(dd_from_dev(dev)))
 			goto inval;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 0e1dba1..a9c0b58 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -789,7 +789,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)
-		atomic_dec(&to_iah(wqe->ud_wr.ah)->refcount);
+		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	/* See ch. 11.2.4.1 and 10.7.3.1 */
 	if (!(qp->s_flags & QIB_S_SIGNAL_REQ_WR) ||
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 1d9d037..6dc20ca 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -77,7 +77,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 		goto drop;
 	}
 
-	ah_attr = &to_iah(swqe->ud_wr.ah)->attr;
+	ah_attr = &ibah_to_rvtah(swqe->ud_wr.ah)->attr;
 	ppd = ppd_from_ibp(ibp);
 
 	if (qp->ibqp.qp_num > 1) {
@@ -279,7 +279,7 @@ int qib_make_ud_req(struct rvt_qp *qp)
 	/* Construct the header. */
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ppd = ppd_from_ibp(ibp);
-	ah_attr = &to_iah(wqe->ud_wr.ah)->attr;
+	ah_attr = &ibah_to_rvtah(wqe->ud_wr.ah)->attr;
 	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		if (ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE))
 			this_cpu_inc(ibp->pmastats->n_multicast_xmit);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 71cf82d..8aa035a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -443,7 +443,7 @@ static int qib_post_one_send(struct rvt_qp *qp, struct ib_send_wr *wr,
 				  qp->port_num - 1)->ibmtu)
 		goto bail_inval_free;
 	else
-		atomic_inc(&to_iah(ud_wr(wr)->ah)->refcount);
+		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
 	wqe->ssn = qp->s_ssn++;
 	qp->s_head = next;
 
@@ -1769,74 +1769,10 @@ static int qib_query_gid(struct ib_device *ibdev, u8 port,
 
 int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 {
-	/* A multicast address requires a GRH (see ch. 8.4.1). */
-	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
-	    ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) &&
-	    !(ah_attr->ah_flags & IB_AH_GRH))
-		goto bail;
-	if ((ah_attr->ah_flags & IB_AH_GRH) &&
-	    ah_attr->grh.sgid_index >= QIB_GUIDS_PER_PORT)
-		goto bail;
-	if (ah_attr->dlid == 0)
-		goto bail;
-	if (ah_attr->port_num < 1 ||
-	    ah_attr->port_num > ibdev->phys_port_cnt)
-		goto bail;
-	if (ah_attr->static_rate != IB_RATE_PORT_CURRENT &&
-	    ib_rate_to_mult(ah_attr->static_rate) < 0)
-		goto bail;
 	if (ah_attr->sl > 15)
-		goto bail;
-	return 0;
-bail:
-	return -EINVAL;
-}
-
-/**
- * qib_create_ah - create an address handle
- * @pd: the protection domain
- * @ah_attr: the attributes of the AH
- *
- * This may be called from interrupt context.
- */
-static struct ib_ah *qib_create_ah(struct ib_pd *pd,
-				   struct ib_ah_attr *ah_attr)
-{
-	struct qib_ah *ah;
-	struct ib_ah *ret;
-	struct qib_ibdev *dev = to_idev(pd->device);
-	unsigned long flags;
-
-	if (qib_check_ah(pd->device, ah_attr)) {
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
-	if (dev->n_ahs_allocated == ib_qib_max_ahs) {
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
+		return -EINVAL;
 
-bail:
-	return ret;
+	return 0;
 }
 
 struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
@@ -1857,51 +1793,6 @@ struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 }
 
 /**
- * qib_destroy_ah - destroy an address handle
- * @ibah: the AH to destroy
- *
- * This may be called from interrupt context.
- */
-static int qib_destroy_ah(struct ib_ah *ibah)
-{
-	struct qib_ibdev *dev = to_idev(ibah->device);
-	struct qib_ah *ah = to_iah(ibah);
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
-static int qib_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
-{
-	struct qib_ah *ah = to_iah(ibah);
-
-	if (qib_check_ah(ibah->device, ah_attr))
-		return -EINVAL;
-
-	ah->attr = *ah_attr;
-
-	return 0;
-}
-
-static int qib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
-{
-	struct qib_ah *ah = to_iah(ibah);
-
-	*ah_attr = ah->attr;
-
-	return 0;
-}
-
-/**
  * qib_get_npkeys - return the size of the PKEY table for context 0
  * @dd: the qlogic_ib device
  */
@@ -2071,7 +1962,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 
 	/* Only need to initialize non-zero fields. */
 	spin_lock_init(&dev->qpt_lock);
-	spin_lock_init(&dev->n_ahs_lock);
 	spin_lock_init(&dev->n_cqs_lock);
 	spin_lock_init(&dev->n_qps_lock);
 	spin_lock_init(&dev->n_srqs_lock);
@@ -2173,10 +2063,10 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->dealloc_ucontext = qib_dealloc_ucontext;
 	ibdev->alloc_pd = NULL;
 	ibdev->dealloc_pd = NULL;
-	ibdev->create_ah = qib_create_ah;
-	ibdev->destroy_ah = qib_destroy_ah;
-	ibdev->modify_ah = qib_modify_ah;
-	ibdev->query_ah = qib_query_ah;
+	ibdev->create_ah = NULL;
+	ibdev->destroy_ah = NULL;
+	ibdev->modify_ah = NULL;
+	ibdev->query_ah = NULL;
 	ibdev->create_srq = qib_create_srq;
 	ibdev->modify_srq = qib_modify_srq;
 	ibdev->query_srq = qib_query_srq;
@@ -2219,7 +2109,9 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	dd->verbs_dev.rdi.driver_f.port_callback = qib_create_port_files;
 	dd->verbs_dev.rdi.driver_f.get_card_name = qib_get_card_name;
 	dd->verbs_dev.rdi.driver_f.get_pci_dev = qib_get_pci_dev;
+	dd->verbs_dev.rdi.driver_f.check_ah = qib_check_ah;
 	dd->verbs_dev.rdi.dparms.props.max_pd = ib_qib_max_pds;
+	dd->verbs_dev.rdi.dparms.props.max_ah = ib_qib_max_ahs;
 	dd->verbs_dev.rdi.flags = (RVT_FLAG_QP_INIT_DRIVER |
 				   RVT_FLAG_CQ_INIT_DRIVER);
 	dd->verbs_dev.rdi.dparms.lkey_table_size = qib_lkey_table_size;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index c7399ff..a9d7f0a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -222,13 +222,6 @@ struct qib_mcast {
 	int n_attached;
 };
 
-/* Address Handle */
-struct qib_ah {
-	struct ib_ah ibah;
-	struct ib_ah_attr attr;
-	atomic_t refcount;
-};
-
 /*
  * This structure is used to contain the head pointer, tail pointer,
  * and completion queue entries as a single memory allocation so
@@ -419,8 +412,8 @@ struct qib_ibport {
 	struct rvt_qp __rcu *qp0;
 	struct rvt_qp __rcu *qp1;
 	struct ib_mad_agent *send_agent;	/* agent for SMI (traps) */
-	struct qib_ah *sm_ah;
-	struct qib_ah *smi_ah;
+	struct rvt_ah *sm_ah;
+	struct rvt_ah *smi_ah;
 	struct rb_root mcast_tree;
 	spinlock_t lock;		/* protect changes in this struct */
 
@@ -511,10 +504,6 @@ struct qib_ibdev {
 	u32 n_piowait;
 	u32 n_txwait;
 
-	u32 n_pds_allocated;    /* number of PDs allocated for device */
-	spinlock_t n_pds_lock;
-	u32 n_ahs_allocated;    /* number of AHs allocated for device */
-	spinlock_t n_ahs_lock;
 	u32 n_cqs_allocated;    /* number of CQs allocated for device */
 	spinlock_t n_cqs_lock;
 	u32 n_qps_allocated;    /* number of QPs allocated for device */
@@ -545,11 +534,6 @@ struct qib_verbs_counters {
 	u32 vl15_dropped;
 };
 
-static inline struct qib_ah *to_iah(struct ib_ah *ibah)
-{
-	return container_of(ibah, struct qib_ah, ibah);
-}
-
 static inline struct qib_cq *to_icq(struct ib_cq *ibcq)
 {
 	return container_of(ibcq, struct qib_cq, ibcq);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
