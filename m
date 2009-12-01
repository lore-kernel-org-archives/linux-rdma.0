From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/9] RDMA/nes: Correct fast memory registration implementation
Date: Tue, 1 Dec 2009 16:19:51 -0600
Message-ID: <20091201221951.GA7840@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Replace alloc_fmr, unmap_fmr, dealloc_fmr and map_phys_fmr with
alloc_fast_reg_mr, alloc_fast_reg_page_list, free_fast_reg_page_list.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_hw.c    |    5 +-
 drivers/infiniband/hw/nes/nes_hw.h    |   27 ++-
 drivers/infiniband/hw/nes/nes_user.h  |    1 +
 drivers/infiniband/hw/nes/nes_verbs.c |  557 ++++++++++++++++-----------------
 4 files changed, 299 insertions(+), 291 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 3512d6d..3d9bbff 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -424,8 +424,9 @@ struct nes_adapter *nes_init_adapter(struct nes_device *nesdev, u8 hw_rev) {
 
 	nesadapter->base_pd = 1;
 
-	nesadapter->device_cap_flags =
-		IB_DEVICE_LOCAL_DMA_LKEY | IB_DEVICE_MEM_WINDOW;
+	nesadapter->device_cap_flags = IB_DEVICE_LOCAL_DMA_LKEY |
+				       IB_DEVICE_MEM_WINDOW |
+				       IB_DEVICE_MEM_MGT_EXTENSIONS;
 
 	nesadapter->allocated_qps = (unsigned long *)&(((unsigned char *)nesadapter)
 			[(sizeof(struct nes_adapter)+(sizeof(unsigned long)-1))&(~(sizeof(unsigned long)-1))]);
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index f28a41b..8a4c738 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -546,11 +546,23 @@ enum nes_iwarp_sq_fmr_wqe_word_idx {
 	NES_IWARP_SQ_FMR_WQE_PBL_LENGTH_IDX = 14,
 };
 
+enum nes_iwarp_sq_fmr_opcodes {
+	NES_IWARP_SQ_FMR_WQE_ZERO_BASED			= (1<<6),
+	NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_4K		= (0<<7),
+	NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_2M		= (1<<7),
+	NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_READ	= (1<<16),
+	NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_WRITE 	= (1<<17),
+	NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_READ 	= (1<<18),
+	NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_WRITE = (1<<19),
+	NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_WINDOW_BIND 	= (1<<20),
+};
+
+#define NES_IWARP_SQ_FMR_WQE_MR_LENGTH_HIGH_MASK	0xFF;
+
 enum nes_iwarp_sq_locinv_wqe_word_idx {
 	NES_IWARP_SQ_LOCINV_WQE_INV_STAG_IDX = 6,
 };
 
-
 enum nes_iwarp_rq_wqe_word_idx {
 	NES_IWARP_RQ_WQE_TOTAL_PAYLOAD_IDX = 1,
 	NES_IWARP_RQ_WQE_COMP_CTX_LOW_IDX = 2,
@@ -1153,6 +1165,19 @@ struct nes_pbl {
 	/* TODO: need to add list for two level tables */
 };
 
+#define NES_4K_PBL_CHUNK_SIZE	4096
+
+struct nes_fast_mr_wqe_pbl {
+	u64		*kva;
+	dma_addr_t	paddr;
+};
+
+struct nes_ib_fast_reg_page_list {
+	struct ib_fast_reg_page_list	ibfrpl;
+	struct nes_fast_mr_wqe_pbl 	nes_wqe_pbl;
+	u64 				pbl;
+};
+
 struct nes_listener {
 	struct work_struct      work;
 	struct workqueue_struct *wq;
diff --git a/drivers/infiniband/hw/nes/nes_user.h b/drivers/infiniband/hw/nes/nes_user.h
index cc90c14..ce62f3c 100644
--- a/drivers/infiniband/hw/nes/nes_user.h
+++ b/drivers/infiniband/hw/nes/nes_user.h
@@ -86,6 +86,7 @@ enum iwnes_memreg_type {
 	IWNES_MEMREG_TYPE_CQ = 0x0002,
 	IWNES_MEMREG_TYPE_MW = 0x0003,
 	IWNES_MEMREG_TYPE_FMR = 0x0004,
+	IWNES_MEMREG_TYPE_FMEM = 0x0005,
 };
 
 struct nes_mem_reg_req {
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 499dd78..42ec5d0 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -275,342 +275,236 @@ static int nes_bind_mw(struct ib_qp *ibqp, struct ib_mw *ibmw,
 }
 
 
-/**
- * nes_alloc_fmr
+/*
+ * nes_alloc_fast_mr
  */
-static struct ib_fmr *nes_alloc_fmr(struct ib_pd *ibpd,
-		int ibmr_access_flags,
-		struct ib_fmr_attr *ibfmr_attr)
+static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
+			     u32 stag, u32 page_count)
 {
-	unsigned long flags;
-	struct nes_pd *nespd = to_nespd(ibpd);
-	struct nes_vnic *nesvnic = to_nesvnic(ibpd->device);
-	struct nes_device *nesdev = nesvnic->nesdev;
-	struct nes_adapter *nesadapter = nesdev->nesadapter;
-	struct nes_fmr *nesfmr;
-	struct nes_cqp_request *cqp_request;
 	struct nes_hw_cqp_wqe *cqp_wqe;
+	struct nes_cqp_request *cqp_request;
+	unsigned long flags;
 	int ret;
-	u32 stag;
-	u32 stag_index = 0;
-	u32 next_stag_index = 0;
-	u32 driver_key = 0;
+	struct nes_adapter *nesadapter = nesdev->nesadapter;
 	u32 opcode = 0;
-	u8 stag_key = 0;
-	int i=0;
-	struct nes_vpbl vpbl;
-
-	get_random_bytes(&next_stag_index, sizeof(next_stag_index));
-	stag_key = (u8)next_stag_index;
-
-	driver_key = 0;
-
-	next_stag_index >>= 8;
-	next_stag_index %= nesadapter->max_mr;
-
-	ret = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
-			nesadapter->max_mr, &stag_index, &next_stag_index);
-	if (ret) {
-		goto failed_resource_alloc;
-	}
-
-	nesfmr = kzalloc(sizeof(*nesfmr), GFP_KERNEL);
-	if (!nesfmr) {
-		ret = -ENOMEM;
-		goto failed_fmr_alloc;
-	}
-
-	nesfmr->nesmr.mode = IWNES_MEMREG_TYPE_FMR;
-	if (ibfmr_attr->max_pages == 1) {
-		/* use zero length PBL */
-		nesfmr->nesmr.pbl_4k = 0;
-		nesfmr->nesmr.pbls_used = 0;
-	} else if (ibfmr_attr->max_pages <= 32) {
-		/* use PBL 256 */
-		nesfmr->nesmr.pbl_4k = 0;
-		nesfmr->nesmr.pbls_used = 1;
-	} else if (ibfmr_attr->max_pages <= 512) {
-		/* use 4K PBLs */
-		nesfmr->nesmr.pbl_4k = 1;
-		nesfmr->nesmr.pbls_used = 1;
-	} else {
-		/* use two level 4K PBLs */
-		/* add support for two level 256B PBLs */
-		nesfmr->nesmr.pbl_4k = 1;
-		nesfmr->nesmr.pbls_used = 1 + (ibfmr_attr->max_pages >> 9) +
-				((ibfmr_attr->max_pages & 511) ? 1 : 0);
-	}
-	/* Register the region with the adapter */
-	spin_lock_irqsave(&nesadapter->pbl_lock, flags);
-
-	/* track PBL resources */
-	if (nesfmr->nesmr.pbls_used != 0) {
-		if (nesfmr->nesmr.pbl_4k) {
-			if (nesfmr->nesmr.pbls_used > nesadapter->free_4kpbl) {
-				spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-				ret = -ENOMEM;
-				goto failed_vpbl_avail;
-			} else {
-				nesadapter->free_4kpbl -= nesfmr->nesmr.pbls_used;
-			}
-		} else {
-			if (nesfmr->nesmr.pbls_used > nesadapter->free_256pbl) {
-				spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-				ret = -ENOMEM;
-				goto failed_vpbl_avail;
-			} else {
-				nesadapter->free_256pbl -= nesfmr->nesmr.pbls_used;
-			}
-		}
-	}
-
-	/* one level pbl */
-	if (nesfmr->nesmr.pbls_used == 0) {
-		nesfmr->root_vpbl.pbl_vbase = NULL;
-		nes_debug(NES_DBG_MR,  "zero level pbl \n");
-	} else if (nesfmr->nesmr.pbls_used == 1) {
-		/* can change it to kmalloc & dma_map_single */
-		nesfmr->root_vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 4096,
-				&nesfmr->root_vpbl.pbl_pbase);
-		if (!nesfmr->root_vpbl.pbl_vbase) {
-			spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-			ret = -ENOMEM;
-			goto failed_vpbl_alloc;
-		}
-		nesfmr->leaf_pbl_cnt = 0;
-		nes_debug(NES_DBG_MR, "one level pbl, root_vpbl.pbl_vbase=%p \n",
-				nesfmr->root_vpbl.pbl_vbase);
-	}
-	/* two level pbl */
-	else {
-		nesfmr->root_vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 8192,
-				&nesfmr->root_vpbl.pbl_pbase);
-		if (!nesfmr->root_vpbl.pbl_vbase) {
-			spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-			ret = -ENOMEM;
-			goto failed_vpbl_alloc;
-		}
-
-		nesfmr->leaf_pbl_cnt = nesfmr->nesmr.pbls_used-1;
-		nesfmr->root_vpbl.leaf_vpbl = kzalloc(sizeof(*nesfmr->root_vpbl.leaf_vpbl)*1024, GFP_ATOMIC);
-		if (!nesfmr->root_vpbl.leaf_vpbl) {
-			spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-			ret = -ENOMEM;
-			goto failed_leaf_vpbl_alloc;
-		}
-
-		nes_debug(NES_DBG_MR, "two level pbl, root_vpbl.pbl_vbase=%p"
-				" leaf_pbl_cnt=%d root_vpbl.leaf_vpbl=%p\n",
-				nesfmr->root_vpbl.pbl_vbase, nesfmr->leaf_pbl_cnt, nesfmr->root_vpbl.leaf_vpbl);
-
-		for (i=0; i<nesfmr->leaf_pbl_cnt; i++)
-			nesfmr->root_vpbl.leaf_vpbl[i].pbl_vbase = NULL;
-
-		for (i=0; i<nesfmr->leaf_pbl_cnt; i++) {
-			vpbl.pbl_vbase = pci_alloc_consistent(nesdev->pcidev, 4096,
-					&vpbl.pbl_pbase);
-
-			if (!vpbl.pbl_vbase) {
-				ret = -ENOMEM;
-				spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
-				goto failed_leaf_vpbl_pages_alloc;
-			}
-
-			nesfmr->root_vpbl.pbl_vbase[i].pa_low = cpu_to_le32((u32)vpbl.pbl_pbase);
-			nesfmr->root_vpbl.pbl_vbase[i].pa_high = cpu_to_le32((u32)((((u64)vpbl.pbl_pbase)>>32)));
-			nesfmr->root_vpbl.leaf_vpbl[i] = vpbl;
-
-			nes_debug(NES_DBG_MR, "pbase_low=0x%x, pbase_high=0x%x, vpbl=%p\n",
-					nesfmr->root_vpbl.pbl_vbase[i].pa_low,
-					nesfmr->root_vpbl.pbl_vbase[i].pa_high,
-					&nesfmr->root_vpbl.leaf_vpbl[i]);
-		}
-	}
-	nesfmr->ib_qp = NULL;
-	nesfmr->access_rights =0;
+	u16 major_code;
+	u64 region_length = page_count * PAGE_SIZE;
 
-	stag = stag_index << 8;
-	stag |= driver_key;
-	stag += (u32)stag_key;
 
-	spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 	cqp_request = nes_get_cqp_request(nesdev);
 	if (cqp_request == NULL) {
 		nes_debug(NES_DBG_MR, "Failed to get a cqp_request.\n");
-		ret = -ENOMEM;
-		goto failed_leaf_vpbl_pages_alloc;
+		return -ENOMEM;
 	}
+	nes_debug(NES_DBG_MR, "alloc_fast_reg_mr: page_count = %d, "
+			      "region_length = %llu\n",
+			      page_count, region_length);
 	cqp_request->waiting = 1;
 	cqp_wqe = &cqp_request->cqp_wqe;
 
-	nes_debug(NES_DBG_MR, "Registering STag 0x%08X, index = 0x%08X\n",
-			stag, stag_index);
-
-	opcode = NES_CQP_ALLOCATE_STAG | NES_CQP_STAG_VA_TO | NES_CQP_STAG_MR;
-
-	if (nesfmr->nesmr.pbl_4k == 1)
-		opcode |= NES_CQP_STAG_PBL_BLK_SIZE;
-
-	if (ibmr_access_flags & IB_ACCESS_REMOTE_WRITE) {
-		opcode |= NES_CQP_STAG_RIGHTS_REMOTE_WRITE |
-				NES_CQP_STAG_RIGHTS_LOCAL_WRITE | NES_CQP_STAG_REM_ACC_EN;
-		nesfmr->access_rights |=
-				NES_CQP_STAG_RIGHTS_REMOTE_WRITE | NES_CQP_STAG_RIGHTS_LOCAL_WRITE |
-				NES_CQP_STAG_REM_ACC_EN;
+	spin_lock_irqsave(&nesadapter->pbl_lock, flags);
+	if (nesadapter->free_4kpbl > 0) {
+		nesadapter->free_4kpbl--;
+		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
+	} else {
+		/* No 4kpbl's available: */
+		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
+		nes_debug(NES_DBG_MR, "Out of Pbls\n");
+		nes_free_cqp_request(nesdev, cqp_request);
+		return -ENOMEM;
 	}
 
-	if (ibmr_access_flags & IB_ACCESS_REMOTE_READ) {
-		opcode |= NES_CQP_STAG_RIGHTS_REMOTE_READ |
-				NES_CQP_STAG_RIGHTS_LOCAL_READ | NES_CQP_STAG_REM_ACC_EN;
-		nesfmr->access_rights |=
-				NES_CQP_STAG_RIGHTS_REMOTE_READ | NES_CQP_STAG_RIGHTS_LOCAL_READ |
-				NES_CQP_STAG_REM_ACC_EN;
-	}
+	opcode = NES_CQP_ALLOCATE_STAG | NES_CQP_STAG_MR |
+		 NES_CQP_STAG_PBL_BLK_SIZE | NES_CQP_STAG_VA_TO |
+		 NES_CQP_STAG_REM_ACC_EN;
+	/*
+	 * The current OFED API does not support the zero based TO option.
+	 * If added then need to changed the NES_CQP_STAG_VA* option.  Also,
+	 * the API does not support that ability to have the MR set for local
+	 * access only when created and not allow the SQ op to override. Given
+	 * this the remote enable must be set here.
+	 */
 
 	nes_fill_init_cqp_wqe(cqp_wqe, nesdev);
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX, opcode);
-	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX, (nespd->pd_id & 0x00007fff));
-	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, stag);
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_PBL_BLK_COUNT_IDX, 1);
 
-	cqp_wqe->wqe_words[NES_CQP_STAG_WQE_PBL_BLK_COUNT_IDX] =
-			cpu_to_le32((nesfmr->nesmr.pbls_used>1) ?
-			(nesfmr->nesmr.pbls_used-1) : nesfmr->nesmr.pbls_used);
+	cqp_wqe->wqe_words[NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX] =
+			cpu_to_le32((u32)(region_length >> 8) & 0xff000000);
+	cqp_wqe->wqe_words[NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX] |=
+			cpu_to_le32(nespd->pd_id & 0x00007fff);
+
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, stag);
+	set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_VA_LOW_IDX, 0);
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_LEN_LOW_IDX, 0);
+	set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_PA_LOW_IDX, 0);
+	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_PBL_LEN_IDX, (page_count * 8));
+	cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX] |= cpu_to_le32(NES_CQP_STAG_PBL_BLK_SIZE);
+	barrier();
 
 	atomic_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
-	ret = wait_event_timeout(cqp_request->waitq, (cqp_request->request_done != 0),
-			NES_EVENT_TIMEOUT);
-	nes_debug(NES_DBG_MR, "Register STag 0x%08X completed, wait_event_timeout ret = %u,"
-			" CQP Major:Minor codes = 0x%04X:0x%04X.\n",
-			stag, ret, cqp_request->major_code, cqp_request->minor_code);
-
-	if ((!ret) || (cqp_request->major_code)) {
-		nes_put_cqp_request(nesdev, cqp_request);
-		ret = (!ret) ? -ETIME : -EIO;
-		goto failed_leaf_vpbl_pages_alloc;
-	}
+	ret = wait_event_timeout(cqp_request->waitq,
+				 (0 != cqp_request->request_done),
+				 NES_EVENT_TIMEOUT);
+
+	nes_debug(NES_DBG_MR, "Allocate STag 0x%08X completed, "
+		  "wait_event_timeout ret = %u, CQP Major:Minor codes = "
+		  "0x%04X:0x%04X.\n", stag, ret, cqp_request->major_code,
+		  cqp_request->minor_code);
+	major_code = cqp_request->major_code;
 	nes_put_cqp_request(nesdev, cqp_request);
-	nesfmr->nesmr.ibfmr.lkey = stag;
-	nesfmr->nesmr.ibfmr.rkey = stag;
-	nesfmr->attr = *ibfmr_attr;
-
-	return &nesfmr->nesmr.ibfmr;
-
-	failed_leaf_vpbl_pages_alloc:
-	/* unroll all allocated pages */
-	for (i=0; i<nesfmr->leaf_pbl_cnt; i++) {
-		if (nesfmr->root_vpbl.leaf_vpbl[i].pbl_vbase) {
-			pci_free_consistent(nesdev->pcidev, 4096, nesfmr->root_vpbl.leaf_vpbl[i].pbl_vbase,
-					nesfmr->root_vpbl.leaf_vpbl[i].pbl_pbase);
-		}
-	}
-	if (nesfmr->root_vpbl.leaf_vpbl)
-		kfree(nesfmr->root_vpbl.leaf_vpbl);
-
-	failed_leaf_vpbl_alloc:
-	if (nesfmr->leaf_pbl_cnt == 0) {
-		if (nesfmr->root_vpbl.pbl_vbase)
-			pci_free_consistent(nesdev->pcidev, 4096, nesfmr->root_vpbl.pbl_vbase,
-					nesfmr->root_vpbl.pbl_pbase);
-	} else
-		pci_free_consistent(nesdev->pcidev, 8192, nesfmr->root_vpbl.pbl_vbase,
-				nesfmr->root_vpbl.pbl_pbase);
 
-	failed_vpbl_alloc:
-	if (nesfmr->nesmr.pbls_used != 0) {
+	if (!ret || major_code) {
 		spin_lock_irqsave(&nesadapter->pbl_lock, flags);
-		if (nesfmr->nesmr.pbl_4k)
-			nesadapter->free_4kpbl += nesfmr->nesmr.pbls_used;
-		else
-			nesadapter->free_256pbl += nesfmr->nesmr.pbls_used;
+		nesadapter->free_4kpbl++;
 		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
 	}
 
-failed_vpbl_avail:
-	kfree(nesfmr);
-
-	failed_fmr_alloc:
-	nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
-
-	failed_resource_alloc:
-	return ERR_PTR(ret);
+	if (!ret)
+		return -ETIME;
+	else if (major_code)
+		return -EIO;
+	return 0;
 }
 
-
-/**
- * nes_dealloc_fmr
+/*
+ * nes_alloc_fast_reg_mr
  */
-static int nes_dealloc_fmr(struct ib_fmr *ibfmr)
+struct ib_mr *nes_alloc_fast_reg_mr(struct ib_pd *ibpd, int max_page_list_len)
 {
-	unsigned long flags;
-	struct nes_mr *nesmr = to_nesmr_from_ibfmr(ibfmr);
-	struct nes_fmr *nesfmr = to_nesfmr(nesmr);
-	struct nes_vnic *nesvnic = to_nesvnic(ibfmr->device);
+	struct nes_pd *nespd = to_nespd(ibpd);
+	struct nes_vnic *nesvnic = to_nesvnic(ibpd->device);
 	struct nes_device *nesdev = nesvnic->nesdev;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
-	int i = 0;
-	int rc;
 
-	/* free the resources */
-	if (nesfmr->leaf_pbl_cnt == 0) {
-		/* single PBL case */
-		if (nesfmr->root_vpbl.pbl_vbase)
-			pci_free_consistent(nesdev->pcidev, 4096, nesfmr->root_vpbl.pbl_vbase,
-					nesfmr->root_vpbl.pbl_pbase);
-	} else {
-		for (i = 0; i < nesfmr->leaf_pbl_cnt; i++) {
-			pci_free_consistent(nesdev->pcidev, 4096, nesfmr->root_vpbl.leaf_vpbl[i].pbl_vbase,
-					nesfmr->root_vpbl.leaf_vpbl[i].pbl_pbase);
-		}
-		kfree(nesfmr->root_vpbl.leaf_vpbl);
-		pci_free_consistent(nesdev->pcidev, 8192, nesfmr->root_vpbl.pbl_vbase,
-				nesfmr->root_vpbl.pbl_pbase);
-	}
-	nesmr->ibmw.device = ibfmr->device;
-	nesmr->ibmw.pd = ibfmr->pd;
-	nesmr->ibmw.rkey = ibfmr->rkey;
-	nesmr->ibmw.uobject = NULL;
+	u32 next_stag_index;
+	u8 stag_key = 0;
+	u32 driver_key = 0;
+	int err = 0;
+	u32 stag_index = 0;
+	struct nes_mr *nesmr;
+	u32 stag;
+	int ret;
+	struct ib_mr *ibmr;
+/*
+ * Note:  Set to always use a fixed length single page entry PBL.  This is to allow
+ *	 for the fast_reg_mr operation to always know the size of the PBL.
+ */
+	if (max_page_list_len > (NES_4K_PBL_CHUNK_SIZE / sizeof(u64)))
+		return ERR_PTR(-E2BIG);
 
-	rc = nes_dealloc_mw(&nesmr->ibmw);
+	get_random_bytes(&next_stag_index, sizeof(next_stag_index));
+	stag_key = (u8)next_stag_index;
+	next_stag_index >>= 8;
+	next_stag_index %= nesadapter->max_mr;
 
-	if ((rc == 0) && (nesfmr->nesmr.pbls_used != 0)) {
-		spin_lock_irqsave(&nesadapter->pbl_lock, flags);
-		if (nesfmr->nesmr.pbl_4k) {
-			nesadapter->free_4kpbl += nesfmr->nesmr.pbls_used;
-			WARN_ON(nesadapter->free_4kpbl > nesadapter->max_4kpbl);
-		} else {
-			nesadapter->free_256pbl += nesfmr->nesmr.pbls_used;
-			WARN_ON(nesadapter->free_256pbl > nesadapter->max_256pbl);
-		}
-		spin_unlock_irqrestore(&nesadapter->pbl_lock, flags);
+	err = nes_alloc_resource(nesadapter, nesadapter->allocated_mrs,
+				 nesadapter->max_mr, &stag_index,
+				 &next_stag_index);
+	if (err)
+		return ERR_PTR(err);
+
+	nesmr = kzalloc(sizeof(*nesmr), GFP_KERNEL);
+	if (!nesmr) {
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		return ERR_PTR(-ENOMEM);
 	}
 
-	return rc;
-}
+	stag = stag_index << 8;
+	stag |= driver_key;
+	stag += (u32)stag_key;
 
+	nes_debug(NES_DBG_MR, "Allocating STag 0x%08X index = 0x%08X\n",
+		  stag, stag_index);
 
-/**
- * nes_map_phys_fmr
+	ret = alloc_fast_reg_mr(nesdev, nespd, stag, max_page_list_len);
+
+	if (ret == 0) {
+		nesmr->ibmr.rkey = stag;
+		nesmr->ibmr.lkey = stag;
+		nesmr->mode = IWNES_MEMREG_TYPE_FMEM;
+		ibmr = &nesmr->ibmr;
+	} else {
+		kfree(nesmr);
+		nes_free_resource(nesadapter, nesadapter->allocated_mrs, stag_index);
+		ibmr = ERR_PTR(-ENOMEM);
+	}
+	return ibmr;
+}
+
+/*
+ * nes_alloc_fast_reg_page_list
  */
-static int nes_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
-		int list_len, u64 iova)
+static struct ib_fast_reg_page_list *nes_alloc_fast_reg_page_list(
+							struct ib_device *ibdev,
+							int page_list_len)
 {
-	return 0;
-}
+	struct nes_vnic *nesvnic = to_nesvnic(ibdev);
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct ib_fast_reg_page_list *pifrpl;
+	struct nes_ib_fast_reg_page_list *pnesfrpl;
 
+	if (page_list_len > (NES_4K_PBL_CHUNK_SIZE / sizeof(u64)))
+		return ERR_PTR(-E2BIG);
+	/*
+	 * Allocate the ib_fast_reg_page_list structure, the
+	 * nes_fast_bpl structure, and the PLB table.
+	 */
+	pnesfrpl = kmalloc(sizeof(struct nes_ib_fast_reg_page_list) +
+			   page_list_len * sizeof(u64), GFP_KERNEL);
+
+	if (!pnesfrpl)
+		return ERR_PTR(-ENOMEM);
 
-/**
- * nes_unmap_frm
+	pifrpl = &pnesfrpl->ibfrpl;
+	pifrpl->page_list = &pnesfrpl->pbl;
+	pifrpl->max_page_list_len = page_list_len;
+	/*
+	 * Allocate the WQE PBL
+	 */
+	pnesfrpl->nes_wqe_pbl.kva = pci_alloc_consistent(nesdev->pcidev,
+							 page_list_len * sizeof(u64),
+							 &pnesfrpl->nes_wqe_pbl.paddr);
+
+	if (!pnesfrpl->nes_wqe_pbl.kva) {
+		kfree(pnesfrpl);
+		return ERR_PTR(-ENOMEM);
+	}
+	nes_debug(NES_DBG_MR, "nes_alloc_fast_reg_pbl: nes_frpl = %p, "
+		  "ibfrpl = %p, ibfrpl.page_list = %p, pbl.kva = %p, "
+		  "pbl.paddr= %p\n", pnesfrpl, &pnesfrpl->ibfrpl,
+		  pnesfrpl->ibfrpl.page_list, pnesfrpl->nes_wqe_pbl.kva,
+		  (void *)pnesfrpl->nes_wqe_pbl.paddr);
+
+	return pifrpl;
+}
+
+/*
+ * nes_free_fast_reg_page_list
  */
-static int nes_unmap_fmr(struct list_head *ibfmr_list)
+static void nes_free_fast_reg_page_list(struct ib_fast_reg_page_list *pifrpl)
 {
-	return 0;
+	struct nes_vnic *nesvnic = to_nesvnic(pifrpl->device);
+	struct nes_device *nesdev = nesvnic->nesdev;
+	struct nes_ib_fast_reg_page_list *pnesfrpl;
+
+	pnesfrpl = container_of(pifrpl, struct nes_ib_fast_reg_page_list, ibfrpl);
+	/*
+	 * Free the WQE PBL.
+	 */
+	pci_free_consistent(nesdev->pcidev,
+			    pifrpl->max_page_list_len * sizeof(u64),
+			    pnesfrpl->nes_wqe_pbl.kva,
+			    pnesfrpl->nes_wqe_pbl.paddr);
+	/*
+	 * Free the PBL structure
+	 */
+	kfree(pnesfrpl);
 }
 
-
-
 /**
  * nes_query_device
  */
@@ -3514,6 +3408,91 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					    NES_IWARP_SQ_LOCINV_WQE_INV_STAG_IDX,
 					    ib_wr->ex.invalidate_rkey);
 			break;
+		case IB_WR_FAST_REG_MR:
+		{
+			int i;
+			int flags = ib_wr->wr.fast_reg.access_flags;
+			struct nes_ib_fast_reg_page_list *pnesfrpl =
+				container_of(ib_wr->wr.fast_reg.page_list,
+					     struct nes_ib_fast_reg_page_list,
+					     ibfrpl);
+			u64 *src_page_list = pnesfrpl->ibfrpl.page_list;
+			u64 *dst_page_list = pnesfrpl->nes_wqe_pbl.kva;
+
+			if (ib_wr->wr.fast_reg.page_list_len >
+			    (NES_4K_PBL_CHUNK_SIZE / sizeof(u64))) {
+				nes_debug(NES_DBG_IW_TX, "SQ_FMR: bad page_list_len\n");
+				err = -EINVAL;
+				break;
+			}
+			wqe_misc = NES_IWARP_SQ_OP_FAST_REG;
+			set_wqe_64bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_VA_FBO_LOW_IDX,
+					    ib_wr->wr.fast_reg.iova_start);
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_LENGTH_LOW_IDX,
+					    ib_wr->wr.fast_reg.length);
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_MR_STAG_IDX,
+					    ib_wr->wr.fast_reg.rkey);
+			/* Set page size: */
+			if (ib_wr->wr.fast_reg.page_shift == 12) {
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_4K;
+			} else if (ib_wr->wr.fast_reg.page_shift == 21) {
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_PAGE_SIZE_2M;
+			} else {
+				nes_debug(NES_DBG_IW_TX, "Invalid page shift,"
+					  " ib_wr=%u, max=1\n", ib_wr->num_sge);
+				err = -EINVAL;
+				break;
+			}
+			/* Set access_flags */
+			wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_READ;
+			if (flags & IB_ACCESS_LOCAL_WRITE)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_LOCAL_WRITE;
+
+			if (flags & IB_ACCESS_REMOTE_WRITE)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_WRITE;
+
+			if (flags & IB_ACCESS_REMOTE_READ)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_REMOTE_READ;
+
+			if (flags & IB_ACCESS_MW_BIND)
+				wqe_misc |= NES_IWARP_SQ_FMR_WQE_RIGHTS_ENABLE_WINDOW_BIND;
+
+			/* Fill in PBL info: */
+			if (ib_wr->wr.fast_reg.page_list_len >
+			    pnesfrpl->ibfrpl.max_page_list_len) {
+				nes_debug(NES_DBG_IW_TX, "Invalid page list length,"
+					  " ib_wr=%p, value=%u, max=%u\n",
+					  ib_wr, ib_wr->wr.fast_reg.page_list_len,
+					  pnesfrpl->ibfrpl.max_page_list_len);
+				err = -EINVAL;
+				break;
+			}
+
+			set_wqe_64bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_PBL_ADDR_LOW_IDX,
+					    pnesfrpl->nes_wqe_pbl.paddr);
+
+			set_wqe_32bit_value(wqe->wqe_words,
+					    NES_IWARP_SQ_FMR_WQE_PBL_LENGTH_IDX,
+					    ib_wr->wr.fast_reg.page_list_len * 8);
+
+			for (i = 0; i < ib_wr->wr.fast_reg.page_list_len; i++)
+				dst_page_list[i] = cpu_to_le64(src_page_list[i]);
+
+			nes_debug(NES_DBG_IW_TX, "SQ_FMR: iova_start: %p, "
+				  "length: %d, rkey: %0x, pgl_paddr: %p, "
+				  "page_list_len: %u\n",
+				  (void *)ib_wr->wr.fast_reg.iova_start,
+				  ib_wr->wr.fast_reg.length,
+				  ib_wr->wr.fast_reg.rkey,
+				  (void *)pnesfrpl->nes_wqe_pbl.paddr,
+				  ib_wr->wr.fast_reg.page_list_len,
+				  wqe_misc);
+			break;
+		}
 		default:
 			/* error */
 			err = -EINVAL;
@@ -3752,6 +3731,9 @@ static int nes_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
 					case NES_IWARP_SQ_OP_LOCINV:
 						entry->opcode = IB_WR_LOCAL_INV;
 						break;
+					case NES_IWARP_SQ_OP_FAST_REG:
+						entry->opcode = IB_WC_FAST_REG_MR;
+						break;
 				}
 
 				nesqp->hwqp.sq_tail = (wqe_index+1)&(nesqp->hwqp.sq_size - 1);
@@ -3922,10 +3904,9 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.dealloc_mw = nes_dealloc_mw;
 	nesibdev->ibdev.bind_mw = nes_bind_mw;
 
-	nesibdev->ibdev.alloc_fmr = nes_alloc_fmr;
-	nesibdev->ibdev.unmap_fmr = nes_unmap_fmr;
-	nesibdev->ibdev.dealloc_fmr = nes_dealloc_fmr;
-	nesibdev->ibdev.map_phys_fmr = nes_map_phys_fmr;
+	nesibdev->ibdev.alloc_fast_reg_mr = nes_alloc_fast_reg_mr;
+	nesibdev->ibdev.alloc_fast_reg_page_list = nes_alloc_fast_reg_page_list;
+	nesibdev->ibdev.free_fast_reg_page_list = nes_free_fast_reg_page_list;
 
 	nesibdev->ibdev.attach_mcast = nes_multicast_attach;
 	nesibdev->ibdev.detach_mcast = nes_multicast_detach;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
