From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/10] nes: simplify nes_reg_phys_mr calling conventions
Date: Fri, 18 Dec 2015 14:55:02 +0100
Message-ID: <1450446906-10336-7-git-send-email-hch@lst.de>
References: <1450446906-10336-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450446906-10336-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just pass and address/size pair instead of an ib_phys_buf array.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> [core]
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c    |  10 +--
 drivers/infiniband/hw/nes/nes_verbs.c | 140 ++++++++--------------------------
 drivers/infiniband/hw/nes/nes_verbs.h |   3 +-
 3 files changed, 37 insertions(+), 116 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 242c87d..bc37adb 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -3232,7 +3232,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	int passive_state;
 	struct nes_ib_device *nesibdev;
 	struct ib_mr *ibmr = NULL;
-	struct ib_phys_buf ibphysbuf;
 	struct nes_pd *nespd;
 	u64 tagged_offset;
 	u8 mpa_frame_offset = 0;
@@ -3316,12 +3315,11 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		u64temp = (unsigned long)nesqp;
 		nesibdev = nesvnic->nesibdev;
 		nespd = nesqp->nespd;
-		ibphysbuf.addr = nesqp->ietf_frame_pbase + mpa_frame_offset;
-		ibphysbuf.size = buff_len;
 		tagged_offset = (u64)(unsigned long)*start_buff;
-		ibmr = nes_reg_phys_mr(&nespd->ibpd, &ibphysbuf, 1,
-					IB_ACCESS_LOCAL_WRITE,
-					&tagged_offset);
+		ibmr = nes_reg_phys_mr(&nespd->ibpd,
+				nesqp->ietf_frame_pbase + mpa_frame_offset,
+				buff_len, IB_ACCESS_LOCAL_WRITE,
+				&tagged_offset);
 		if (!ibmr) {
 			nes_debug(NES_DBG_CM, "Unable to register memory region"
 				  "for lSMM for cm_node = %p \n",
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 640f68f..4e57bf0 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1945,9 +1945,8 @@ static int nes_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 /**
  * nes_reg_phys_mr
  */
-struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
-		struct ib_phys_buf *buffer_list, int num_phys_buf, int acc,
-		u64 * iova_start)
+struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd, u64 addr, u64 size,
+		int acc, u64 *iova_start)
 {
 	u64 region_length;
 	struct nes_pd *nespd = to_nespd(ib_pd);
@@ -1959,13 +1958,10 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 	struct nes_vpbl vpbl;
 	struct nes_root_vpbl root_vpbl;
 	u32 stag;
-	u32 i;
 	unsigned long mask;
 	u32 stag_index = 0;
 	u32 next_stag_index = 0;
 	u32 driver_key = 0;
-	u32 root_pbl_index = 0;
-	u32 cur_pbl_index = 0;
 	int err = 0;
 	int ret = 0;
 	u16 pbl_count = 0;
@@ -1984,11 +1980,8 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 
 	next_stag_index >>= 8;
 	next_stag_index %= nesadapter->max_mr;
-	if (num_phys_buf > (1024*512)) {
-		return ERR_PTR(-E2BIG);
-	}
 
-	if ((buffer_list[0].addr ^ *iova_start) & ~PAGE_MASK)
+	if ((addr ^ *iova_start) & ~PAGE_MASK)
 		return ERR_PTR(-EINVAL);
 
 	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs, nesadapter->max_mr,
@@ -2003,84 +1996,33 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	for (i = 0; i < num_phys_buf; i++) {
+	/* Allocate a 4K buffer for the PBL */
+	vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 4096,
+			&vpbl.pbl_pbase);
+	nes_debug(NES_DBG_MR, "Allocating leaf PBL, va = %p, pa = 0x%016lX\n",
+			vpbl.pbl_vbase, (unsigned long)vpbl.pbl_pbase);
+	if (!vpbl.pbl_vbase) {
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		ibmr = ERR_PTR(-ENOMEM);
+		kfree(nesmr);
+		goto reg_phys_err;
+	}
 
-		if ((i & 0x01FF) == 0) {
-			if (root_pbl_index == 1) {
-				/* Allocate the root PBL */
-				root_vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 8192,
-						&root_vpbl.pbl_pbase);
-				nes_debug(NES_DBG_MR, "Allocating root PBL, va = %p, pa = 0x%08X\n",
-						root_vpbl.pbl_vbase, (unsigned int)root_vpbl.pbl_pbase);
-				if (!root_vpbl.pbl_vbase) {
-					pci_free_consistent(nesdev->pcidev, 4096, vpbl.pbl_vbase,
-							vpbl.pbl_pbase);
-					nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-					kfree(nesmr);
-					return ERR_PTR(-ENOMEM);
-				}
-				root_vpbl.leaf_vpbl = kzalloc(sizeof(*root_vpbl.leaf_vpbl)*1024, GFP_KERNEL);
-				if (!root_vpbl.leaf_vpbl) {
-					pci_free_consistent(nesdev->pcidev, 8192, root_vpbl.pbl_vbase,
-							root_vpbl.pbl_pbase);
-					pci_free_consistent(nesdev->pcidev, 4096, vpbl.pbl_vbase,
-							vpbl.pbl_pbase);
-					nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-					kfree(nesmr);
-					return ERR_PTR(-ENOMEM);
-				}
-				root_vpbl.pbl_vbase[0].pa_low = cpu_to_le32((u32)vpbl.pbl_pbase);
-				root_vpbl.pbl_vbase[0].pa_high =
-						cpu_to_le32((u32)((((u64)vpbl.pbl_pbase) >> 32)));
-				root_vpbl.leaf_vpbl[0] = vpbl;
-			}
-			/* Allocate a 4K buffer for the PBL */
-			vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 4096,
-					&vpbl.pbl_pbase);
-			nes_debug(NES_DBG_MR, "Allocating leaf PBL, va = %p, pa = 0x%016lX\n",
-					vpbl.pbl_vbase, (unsigned long)vpbl.pbl_pbase);
-			if (!vpbl.pbl_vbase) {
-				nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-				ibmr = ERR_PTR(-ENOMEM);
-				kfree(nesmr);
-				goto reg_phys_err;
-			}
-			/* Fill in the root table */
-			if (1 <= root_pbl_index) {
-				root_vpbl.pbl_vbase[root_pbl_index].pa_low =
-						cpu_to_le32((u32)vpbl.pbl_pbase);
-				root_vpbl.pbl_vbase[root_pbl_index].pa_high =
-						cpu_to_le32((u32)((((u64)vpbl.pbl_pbase) >> 32)));
-				root_vpbl.leaf_vpbl[root_pbl_index] = vpbl;
-			}
-			root_pbl_index++;
-			cur_pbl_index = 0;
-		}
 
-		mask = !buffer_list[i].size;
-		if (i != 0)
-			mask |= buffer_list[i].addr;
-		if (i != num_phys_buf - 1)
-			mask |= buffer_list[i].addr + buffer_list[i].size;
-
-		if (mask & ~PAGE_MASK) {
-			nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-			nes_debug(NES_DBG_MR, "Invalid buffer addr or size\n");
-			ibmr = ERR_PTR(-EINVAL);
-			kfree(nesmr);
-			goto reg_phys_err;
-		}
+	mask = !size;
 
-		region_length += buffer_list[i].size;
-		if ((i != 0) && (single_page)) {
-			if ((buffer_list[i-1].addr+PAGE_SIZE) != buffer_list[i].addr)
-				single_page = 0;
-		}
-		vpbl.pbl_vbase[cur_pbl_index].pa_low = cpu_to_le32((u32)buffer_list[i].addr & PAGE_MASK);
-		vpbl.pbl_vbase[cur_pbl_index++].pa_high =
-				cpu_to_le32((u32)((((u64)buffer_list[i].addr) >> 32)));
+	if (mask & ~PAGE_MASK) {
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		nes_debug(NES_DBG_MR, "Invalid buffer addr or size\n");
+		ibmr = ERR_PTR(-EINVAL);
+		kfree(nesmr);
+		goto reg_phys_err;
 	}
 
+	region_length += size;
+	vpbl.pbl_vbase[0].pa_low = cpu_to_le32((u32)addr & PAGE_MASK);
+	vpbl.pbl_vbase[0].pa_high = cpu_to_le32((u32)((((u64)addr) >> 32)));
+
 	stag = stag_index << 8;
 	stag |= driver_key;
 	stag += (u32)stag_key;
@@ -2090,17 +2032,15 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 			stag, (unsigned long)*iova_start, (unsigned long)region_length, stag_index);
 
 	/* Make the leaf PBL the root if only one PBL */
-	if (root_pbl_index == 1) {
-		root_vpbl.pbl_pbase = vpbl.pbl_pbase;
-	}
+	root_vpbl.pbl_pbase = vpbl.pbl_pbase;
 
 	if (single_page) {
 		pbl_count = 0;
 	} else {
-		pbl_count = root_pbl_index;
+		pbl_count = 1;
 	}
 	ret = nes_reg_mr(nesdev, nespd, stag, region_length, &root_vpbl,
-			buffer_list[0].addr, pbl_count, (u16)cur_pbl_index, acc, iova_start,
+			addr, pbl_count, 1, acc, iova_start,
 			&nesmr->pbls_used, &nesmr->pbl_4k);
 
 	if (ret == 0) {
@@ -2113,21 +2053,9 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
 		ibmr = ERR_PTR(-ENOMEM);
 	}
 
-	reg_phys_err:
-	/* free the resources */
-	if (root_pbl_index == 1) {
-		/* single PBL case */
-		pci_free_consistent(nesdev->pcidev, 4096, vpbl.pbl_vbase, vpbl.pbl_pbase);
-	} else {
-		for (i=0; i<root_pbl_index; i++) {
-			pci_free_consistent(nesdev->pcidev, 4096, root_vpbl.leaf_vpbl[i].pbl_vbase,
-					root_vpbl.leaf_vpbl[i].pbl_pbase);
-		}
-		kfree(root_vpbl.leaf_vpbl);
-		pci_free_consistent(nesdev->pcidev, 8192, root_vpbl.pbl_vbase,
-				root_vpbl.pbl_pbase);
-	}
-
+reg_phys_err:
+	/* single PBL case */
+	pci_free_consistent(nesdev->pcidev, 4096, vpbl.pbl_vbase, vpbl.pbl_pbase);
 	return ibmr;
 }
 
@@ -2137,17 +2065,13 @@ struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
  */
 static struct ib_mr *nes_get_dma_mr(struct ib_pd *pd, int acc)
 {
-	struct ib_phys_buf bl;
 	u64 kva = 0;
 
 	nes_debug(NES_DBG_MR, "\n");
 
-	bl.size = (u64)0xffffffffffULL;
-	bl.addr = 0;
-	return nes_reg_phys_mr(pd, &bl, 1, acc, &kva);
+	return nes_reg_phys_mr(pd, 0, 0xffffffffffULL, acc, &kva);
 }
 
-
 /**
  * nes_reg_user_mr
  */
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index 38e38cf..7029088 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -192,7 +192,6 @@ struct nes_qp {
 };
 
 struct ib_mr *nes_reg_phys_mr(struct ib_pd *ib_pd,
-		struct ib_phys_buf *buffer_list, int num_phys_buf, int acc,
-		u64 * iova_start);
+		u64 addr, u64 size, int acc, u64 *iova_start);
 
 #endif			/* NES_VERBS_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
