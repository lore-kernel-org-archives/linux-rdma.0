From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 05/15] IB/usnic: Change BUG_ON to lockdep_assert_held
Date: Thu,  9 Jan 2014 14:47:33 -0800
Message-ID: <1389307663-11296-6-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC calls BUG_ON(spin_is_locked..) at few places.  In some of these
instances, the call is made while holding a spinlock.  Change
all BUG_ON(spin_is_locked...) calls in usNIC to
lockdep_assert_held to make it fool-proof bc the latter can be
called while holding a spinlock and unlike spin_is_locked,
lockdep_assert_held also works correctly on UP.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 16 ++++++++--------
 drivers/infiniband/hw/usnic/usnic_uiom.c      |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index f647b6b..5165be6 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -82,7 +82,7 @@ static int add_fwd_filter(struct usnic_ib_qp_grp *qp_grp,
 	struct usnic_vnic_res_chunk *chunk;
 	int rq_idx;

-	BUG_ON(!spin_is_locked(&qp_grp->lock));
+	lockdep_assert_held(&qp_grp->lock);

 	chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
 	if (IS_ERR_OR_NULL(chunk) || chunk->cnt < 1) {
@@ -119,7 +119,7 @@ static int del_all_filters(struct usnic_ib_qp_grp *qp_grp)
 	int err, status;
 	struct usnic_fwd_filter_hndl *filter_hndl, *tmp;

-	BUG_ON(!spin_is_locked(&qp_grp->lock));
+	lockdep_assert_held(&qp_grp->lock);

 	status = 0;

@@ -145,7 +145,7 @@ static int enable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
 	struct usnic_vnic_res_chunk *res_chunk;
 	struct usnic_vnic_res *res;

-	BUG_ON(!spin_is_locked(&qp_grp->lock));
+	lockdep_assert_held(&qp_grp->lock);

 	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);

@@ -189,7 +189,7 @@ static int disable_qp_grp(struct usnic_ib_qp_grp *qp_grp)
 	struct usnic_vnic_res *res;
 	int status = 0;

-	BUG_ON(!spin_is_locked(&qp_grp->lock));
+	lockdep_assert_held(&qp_grp->lock);
 	vnic_idx = usnic_vnic_get_index(qp_grp->vf->vnic);

 	res_chunk = usnic_ib_qp_grp_get_chunk(qp_grp, USNIC_VNIC_RES_TYPE_RQ);
@@ -392,7 +392,7 @@ static int qp_grp_and_vf_bind(struct usnic_ib_vf *vf,
 	int err;
 	struct pci_dev *pdev;

-	BUG_ON(!spin_is_locked(&vf->lock));
+	lockdep_assert_held(&vf->lock);

 	pdev = usnic_vnic_get_pdev(vf->vnic);
 	if (vf->qp_grp_ref_cnt++ == 0) {
@@ -416,7 +416,7 @@ static void qp_grp_and_vf_unbind(struct usnic_ib_qp_grp *qp_grp)
 	struct pci_dev *pdev;
 	struct usnic_ib_pd *pd;

-	BUG_ON(!spin_is_locked(&qp_grp->vf->lock));
+	lockdep_assert_held(&qp_grp->vf->lock);

 	pd = qp_grp->vf->pd;
 	pdev = usnic_vnic_get_pdev(qp_grp->vf->vnic);
@@ -446,7 +446,7 @@ struct usnic_ib_qp_grp *usnic_ib_qp_grp_create(struct usnic_fwd_dev *ufdev,
 	u16 port_num;
 	int err;

-	BUG_ON(!spin_is_locked(&vf->lock));
+	lockdep_assert_held(&vf->lock);

 	err = usnic_vnic_res_spec_satisfied(&min_transport_spec[transport],
 						res_spec);
@@ -514,7 +514,7 @@ void usnic_ib_qp_grp_destroy(struct usnic_ib_qp_grp *qp_grp)
 	enum usnic_transport_type transport;

 	WARN_ON(qp_grp->state != IB_QPS_RESET);
-	BUG_ON(!spin_is_locked(&qp_grp->vf->lock));
+	lockdep_assert_held(&qp_grp->vf->lock);

 	transport = qp_grp->filters[DFLT_FILTER_IDX].transport;
 	default_port_num = qp_grp->filters[DFLT_FILTER_IDX].port_num;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c44acbc..359897d 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -270,7 +270,7 @@ iter_chunk:
 				pa_end = pa;
 			}

-			BUG_ON(va_start == -EINVAL);
+			WARN_ON(va_start == -EINVAL);

 			if ((pa_end + PAGE_SIZE != pa) &&
 					(pa != pa_start)) {
--
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
