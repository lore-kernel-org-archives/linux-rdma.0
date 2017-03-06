From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/5] IB/nes: Adjust 16 checks for null pointers
Date: Mon, 6 Mar 2017 18:42:44 +0100
Message-ID: <34a4575b-d8fd-755a-9eaa-5ba7bcec994f@users.sourceforge.net>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 6 Mar 2017 16:54:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index a28dfeaa1f45..f79ea50e3ab5 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -106,7 +106,7 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
 
 	/* Register the region with the adapter */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		kfree(nesmr);
 		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
 		return ERR_PTR(-ENOMEM);
@@ -171,7 +171,7 @@ static int nes_dealloc_mw(struct ib_mw *ibmw)
 
 	/* Deallocate the window with the adapter */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -224,7 +224,7 @@ static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 
 
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -627,7 +627,7 @@ static int nes_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 			return -EFAULT;
 		}
 		nesqp = nes_ucontext->mmap_nesqp[index];
-		if (nesqp == NULL) {
+		if (!nesqp) {
 			nes_debug(NES_DBG_MMAP, "wq %lu has a NULL QP base.\n", index);
 			return -EFAULT;
 		}
@@ -1228,7 +1228,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 
 			/* Create the QP */
 			cqp_request = nes_get_cqp_request(nesdev);
-			if (cqp_request == NULL) {
+			if (!cqp_request) {
 				nes_debug(NES_DBG_QP, "Failed to get a cqp_request\n");
 				nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
 				nes_free_qp_mem(nesdev, nesqp,virt_wqs);
@@ -1539,7 +1539,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 
 	/* send CreateCQ request to CQP */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_CQ, "Failed to get a cqp_request.\n");
 		if (!context)
 			pci_free_consistent(nesdev->pcidev, nescq->cq_mem_size, mem,
@@ -1697,7 +1697,7 @@ static int nes_destroy_cq(struct ib_cq *ib_cq)
 	u32 opcode = 0;
 	int ret;
 
-	if (ib_cq == NULL)
+	if (!ib_cq)
 		return 0;
 
 	nescq = to_nescq(ib_cq);
@@ -1709,7 +1709,7 @@ static int nes_destroy_cq(struct ib_cq *ib_cq)
 
 	/* Send DestroyCQ request to CQP */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_CQ, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -1788,8 +1788,7 @@ static u32 root_256(struct nes_device *nesdev,
 	if (pbl_count_4k == 1) {
 		new_root->pbl_vbase = pci_alloc_consistent(nesdev->pcidev,
 						512, &new_root->pbl_pbase);
-
-		if (new_root->pbl_vbase == NULL)
+		if (!new_root->pbl_vbase)
 			return 0;
 
 		leaf_pbl = (u64)root_vpbl->pbl_pbase;
@@ -1847,7 +1846,7 @@ static int nes_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 
 	/* Register the region with the adapter */
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -2509,7 +2508,7 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 	/* Deallocate the region with the adapter */
 
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -2673,7 +2672,7 @@ int nes_hw_modify_qp(struct nes_device *nesdev, struct nes_qp *nesqp,
 			nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount));
 
 	cqp_request = nes_get_cqp_request(nesdev);
-	if (cqp_request == NULL) {
+	if (!cqp_request) {
 		nes_debug(NES_DBG_MOD_QP, "Failed to get a cqp_request.\n");
 		return -ENOMEM;
 	}
@@ -2793,7 +2792,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					spin_unlock_irqrestore(&nesqp->lock, qplockflags);
 					return -EINVAL;
 				}
-				if (nesqp->cm_id == NULL) {
+				if (!nesqp->cm_id) {
 					nes_debug(NES_DBG_MOD_QP, "QP%u: Failing attempt to move QP to RTS without a CM_ID. \n",
 							nesqp->hwqp.qp_id );
 					spin_unlock_irqrestore(&nesqp->lock, qplockflags);
@@ -3696,9 +3695,9 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	struct nes_device *nesdev = nesvnic->nesdev;
 
 	nesibdev = (struct nes_ib_device *)ib_alloc_device(sizeof(struct nes_ib_device));
-	if (nesibdev == NULL) {
+	if (!nesibdev)
 		return NULL;
-	}
+
 	strlcpy(nesibdev->ibdev.name, "nes%d", IB_DEVICE_NAME_MAX);
 	nesibdev->ibdev.owner = THIS_MODULE;
 
@@ -3772,7 +3771,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.drain_rq = nes_drain_rq;
 
 	nesibdev->ibdev.iwcm = kzalloc(sizeof(*nesibdev->ibdev.iwcm), GFP_KERNEL);
-	if (nesibdev->ibdev.iwcm == NULL) {
+	if (!nesibdev->ibdev.iwcm) {
 		ib_dealloc_device(&nesibdev->ibdev);
 		return NULL;
 	}
@@ -3844,7 +3843,7 @@ void  nes_port_ibevent(struct nes_vnic *nesvnic)
  */
 void nes_destroy_ofa_device(struct nes_ib_device *nesibdev)
 {
-	if (nesibdev == NULL)
+	if (!nesibdev)
 		return;
 
 	nes_unregister_ofa_device(nesibdev);
-- 
2.12.0

