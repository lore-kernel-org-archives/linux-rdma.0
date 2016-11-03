From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 11/17] IB/nes: Remove debug prints after allocation failure
Date: Thu,  3 Nov 2016 16:44:19 +0200
Message-ID: <1478184265-9620-12-git-send-email-leon@kernel.org>
References: <1478184265-9620-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478184265-9620-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The prints after [k|v][m|z|c]alloc() functions are not needed,
because in case of failure, allocator will print their internal
error prints anyway.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c       |  1 -
 drivers/infiniband/hw/nes/nes_cm.c    |  4 +---
 drivers/infiniband/hw/nes/nes_hw.c    |  6 ++----
 drivers/infiniband/hw/nes/nes_mgt.c   | 10 +++-------
 drivers/infiniband/hw/nes/nes_verbs.c |  4 ----
 5 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 35cbb17..9badd02 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -516,7 +516,6 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
 	/* Allocate hardware structure */
 	nesdev = kzalloc(sizeof(struct nes_device), GFP_KERNEL);
 	if (!nesdev) {
-		printk(KERN_ERR PFX "%s: Unable to alloc hardware struct\n", pci_name(pcidev));
 		ret = -ENOMEM;
 		goto bail2;
 	}
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 57db9b3..8e70347 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -2282,10 +2282,8 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 	if (!listener) {
 		/* create a CM listen node (1/2 node to compare incoming traffic to) */
 		listener = kzalloc(sizeof(*listener), GFP_ATOMIC);
-		if (!listener) {
-			nes_debug(NES_DBG_CM, "Not creating listener memory allocation failed\n");
+		if (!listener)
 			return NULL;
-		}
 
 		listener->loc_addr = cm_info->loc_addr;
 		listener->loc_port = cm_info->loc_port;
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index a1c6481..19acd13 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -351,9 +351,8 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 
 	/* allocate a new adapter struct */
 	nesadapter = kzalloc(adapter_size, GFP_KERNEL);
-	if (nesadapter == NULL) {
+	if (!nesadapter)
 		return NULL;
-	}
 
 	nes_debug(NES_DBG_INIT, "Allocating new nesadapter @ %p, size = %u (actual size = %u).\n",
 			nesadapter, (u32)sizeof(struct nes_adapter), adapter_size);
@@ -1007,8 +1006,7 @@ int nes_init_cqp(struct nes_device *nesdev)
 	/* Allocate a twice the number of CQP requests as the SQ size */
 	nesdev->nes_cqp_requests = kzalloc(sizeof(struct nes_cqp_request) *
 			2 * NES_CQP_SQ_SIZE, GFP_KERNEL);
-	if (nesdev->nes_cqp_requests == NULL) {
-		nes_debug(NES_DBG_INIT, "Unable to allocate memory CQP request entries.\n");
+	if (!nesdev->nes_cqp_requests) {
 		pci_free_consistent(nesdev->pcidev, nesdev->cqp_mem_size, nesdev->cqp.sq_vbase,
 				nesdev->cqp.sq_pbase);
 		return -ENOMEM;
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 4166452..33624f1 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -320,8 +320,7 @@ static int get_fpdu_info(struct nes_device *nesdev, struct nes_qp *nesqp,
 
 	/* Found one */
 	fpdu_info = kzalloc(sizeof(*fpdu_info), GFP_ATOMIC);
-	if (fpdu_info == NULL) {
-		nes_debug(NES_DBG_PAU, "Failed to alloc a fpdu_info.\n");
+	if (!fpdu_info) {
 		rc = -ENOMEM;
 		goto out;
 	}
@@ -729,8 +728,7 @@ static int nes_change_quad_hash(struct nes_device *nesdev,
 	}
 
 	qh_chg = kmalloc(sizeof *qh_chg, GFP_ATOMIC);
-	if (qh_chg == NULL) {
-		nes_debug(NES_DBG_PAU, "Failed to get a cqp_request.\n");
+	if (!qh_chg) {
 		ret = -ENOMEM;
 		goto chg_qh_err;
 	}
@@ -880,10 +878,8 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 
 	/* Allocate space the all mgt QPs once */
 	mgtvnic = kzalloc(NES_MGT_QP_COUNT * sizeof(struct nes_vnic_mgt), GFP_KERNEL);
-	if (mgtvnic == NULL) {
-		nes_debug(NES_DBG_INIT, "Unable to allocate memory for mgt structure\n");
+	if (!mgtvnic)
 		return -ENOMEM;
-	}
 
 	/* Allocate fragment, RQ, and CQ; Reuse CEQ based on the PCI function */
 	/* We are not sending from this NIC so sq is not allocated */
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index bd69125..42ab31d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1075,7 +1075,6 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			mem = kzalloc(sizeof(*nesqp)+NES_SW_CONTEXT_ALIGN-1, GFP_KERNEL);
 			if (!mem) {
 				nes_free_resource(nesadapter, nesadapter->allocated_qps, qp_num);
-				nes_debug(NES_DBG_QP, "Unable to allocate QP\n");
 				return ERR_PTR(-ENOMEM);
 			}
 			u64nesqp = (unsigned long)mem;
@@ -1475,7 +1474,6 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 	nescq = kzalloc(sizeof(struct nes_cq), GFP_KERNEL);
 	if (!nescq) {
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, cq_num);
-		nes_debug(NES_DBG_CQ, "Unable to allocate nes_cq struct\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2408,7 +2406,6 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			}
 			nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
 			if (!nespbl) {
-				nes_debug(NES_DBG_MR, "Unable to allocate PBL\n");
 				ib_umem_release(region);
 				return ERR_PTR(-ENOMEM);
 			}
@@ -2416,7 +2413,6 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			if (!nesmr) {
 				ib_umem_release(region);
 				kfree(nespbl);
-				nes_debug(NES_DBG_MR, "Unable to allocate nesmr\n");
 				return ERR_PTR(-ENOMEM);
 			}
 			nesmr->region = region;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
