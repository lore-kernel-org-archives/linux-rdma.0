From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 38/43] iser-target: Port to new memory registration API
Date: Wed, 22 Jul 2015 09:55:38 +0300
Message-ID: <1437548143-24893-39-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 116 ++++++--------------------------
 drivers/infiniband/ulp/isert/ib_isert.h |   2 -
 2 files changed, 19 insertions(+), 99 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 94395ce..af1c01d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -486,10 +486,8 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 	list_for_each_entry_safe(fr_desc, tmp,
 				 &isert_conn->fr_pool, list) {
 		list_del(&fr_desc->list);
-		ib_free_fast_reg_page_list(fr_desc->data_frpl);
 		ib_dereg_mr(fr_desc->data_mr);
 		if (fr_desc->pi_ctx) {
-			ib_free_fast_reg_page_list(fr_desc->pi_ctx->prot_frpl);
 			ib_dereg_mr(fr_desc->pi_ctx->prot_mr);
 			ib_dereg_mr(fr_desc->pi_ctx->sig_mr);
 			kfree(fr_desc->pi_ctx);
@@ -517,22 +515,13 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
 		return -ENOMEM;
 	}
 
-	pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(device,
-					    ISCSI_ISER_SG_TABLESIZE);
-	if (IS_ERR(pi_ctx->prot_frpl)) {
-		isert_err("Failed to allocate prot frpl err=%ld\n",
-			  PTR_ERR(pi_ctx->prot_frpl));
-		ret = PTR_ERR(pi_ctx->prot_frpl);
-		goto err_pi_ctx;
-	}
-
 	pi_ctx->prot_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG,
 				      ISCSI_ISER_SG_TABLESIZE, 0);
 	if (IS_ERR(pi_ctx->prot_mr)) {
 		isert_err("Failed to allocate prot frmr err=%ld\n",
 			  PTR_ERR(pi_ctx->prot_mr));
 		ret = PTR_ERR(pi_ctx->prot_mr);
-		goto err_prot_frpl;
+		goto err_pi_ctx;
 	}
 	desc->ind |= ISERT_PROT_KEY_VALID;
 
@@ -552,8 +541,6 @@ isert_create_pi_ctx(struct fast_reg_descriptor *desc,
 
 err_prot_mr:
 	ib_dereg_mr(pi_ctx->prot_mr);
-err_prot_frpl:
-	ib_free_fast_reg_page_list(pi_ctx->prot_frpl);
 err_pi_ctx:
 	kfree(pi_ctx);
 
@@ -564,34 +551,18 @@ static int
 isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
 		     struct fast_reg_descriptor *fr_desc)
 {
-	int ret;
-
-	fr_desc->data_frpl = ib_alloc_fast_reg_page_list(ib_device,
-							 ISCSI_ISER_SG_TABLESIZE);
-	if (IS_ERR(fr_desc->data_frpl)) {
-		isert_err("Failed to allocate data frpl err=%ld\n",
-			  PTR_ERR(fr_desc->data_frpl));
-		return PTR_ERR(fr_desc->data_frpl);
-	}
-
 	fr_desc->data_mr = ib_alloc_mr(pd, IB_MR_TYPE_FAST_REG,
 				       ISCSI_ISER_SG_TABLESIZE, 0);
 	if (IS_ERR(fr_desc->data_mr)) {
 		isert_err("Failed to allocate data frmr err=%ld\n",
 			  PTR_ERR(fr_desc->data_mr));
-		ret = PTR_ERR(fr_desc->data_mr);
-		goto err_data_frpl;
+		return PTR_ERR(fr_desc->data_mr);
 	}
 	fr_desc->ind |= ISERT_DATA_KEY_VALID;
 
 	isert_dbg("Created fr_desc %p\n", fr_desc);
 
 	return 0;
-
-err_data_frpl:
-	ib_free_fast_reg_page_list(fr_desc->data_frpl);
-
-	return ret;
 }
 
 static int
@@ -2521,45 +2492,6 @@ unmap_cmd:
 	return ret;
 }
 
-static int
-isert_map_fr_pagelist(struct ib_device *ib_dev,
-		      struct scatterlist *sg_start, int sg_nents, u64 *fr_pl)
-{
-	u64 start_addr, end_addr, page, chunk_start = 0;
-	struct scatterlist *tmp_sg;
-	int i = 0, new_chunk, last_ent, n_pages;
-
-	n_pages = 0;
-	new_chunk = 1;
-	last_ent = sg_nents - 1;
-	for_each_sg(sg_start, tmp_sg, sg_nents, i) {
-		start_addr = ib_sg_dma_address(ib_dev, tmp_sg);
-		if (new_chunk)
-			chunk_start = start_addr;
-		end_addr = start_addr + ib_sg_dma_len(ib_dev, tmp_sg);
-
-		isert_dbg("SGL[%d] dma_addr: 0x%llx len: %u\n",
-			  i, (unsigned long long)tmp_sg->dma_address,
-			  tmp_sg->length);
-
-		if ((end_addr & ~PAGE_MASK) && i < last_ent) {
-			new_chunk = 0;
-			continue;
-		}
-		new_chunk = 1;
-
-		page = chunk_start & PAGE_MASK;
-		do {
-			fr_pl[n_pages++] = page;
-			isert_dbg("Mapped page_list[%d] page_addr: 0x%llx\n",
-				  n_pages - 1, page);
-			page += PAGE_SIZE;
-		} while (page < end_addr);
-	}
-
-	return n_pages;
-}
-
 static inline void
 isert_inv_rkey(struct ib_send_wr *inv_wr, struct ib_mr *mr)
 {
@@ -2585,11 +2517,9 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	struct isert_device *device = isert_conn->device;
 	struct ib_device *ib_dev = device->ib_device;
 	struct ib_mr *mr;
-	struct ib_fast_reg_page_list *frpl;
 	struct ib_send_wr fr_wr, inv_wr;
 	struct ib_send_wr *bad_wr, *wr = NULL;
-	int ret, pagelist_len;
-	u32 page_off;
+	int ret;
 
 	if (mem->dma_nents == 1) {
 		sge->lkey = device->mr->lkey;
@@ -2600,40 +2530,32 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		return 0;
 	}
 
-	if (ind == ISERT_DATA_KEY_VALID) {
+	if (ind == ISERT_DATA_KEY_VALID)
 		/* Registering data buffer */
 		mr = fr_desc->data_mr;
-		frpl = fr_desc->data_frpl;
-	} else {
+	else
 		/* Registering protection buffer */
 		mr = fr_desc->pi_ctx->prot_mr;
-		frpl = fr_desc->pi_ctx->prot_frpl;
-	}
-
-	page_off = mem->offset % PAGE_SIZE;
-
-	isert_dbg("Use fr_desc %p sg_nents %d offset %u\n",
-		  fr_desc, mem->nents, mem->offset);
-
-	pagelist_len = isert_map_fr_pagelist(ib_dev, mem->sg, mem->nents,
-					     &frpl->page_list[0]);
 
 	if (!(fr_desc->ind & ind)) {
 		isert_inv_rkey(&inv_wr, mr);
 		wr = &inv_wr;
 	}
 
+	ret = ib_map_mr_sg(mr, mem->sg, mem->nents, IB_ACCESS_LOCAL_WRITE);
+	if (ret) {
+		isert_err("failed to map sg %p with %d entries\n",
+			 mem->sg, mem->dma_nents);
+		return ret;
+	}
+
+	isert_dbg("Use fr_desc %p sg_nents %d offset %u\n",
+		  fr_desc, mem->nents, mem->offset);
+
 	/* Prepare FASTREG WR */
 	memset(&fr_wr, 0, sizeof(fr_wr));
-	fr_wr.wr_id = ISER_FASTREG_LI_WRID;
-	fr_wr.opcode = IB_WR_FAST_REG_MR;
-	fr_wr.wr.fast_reg.iova_start = frpl->page_list[0] + page_off;
-	fr_wr.wr.fast_reg.page_list = frpl;
-	fr_wr.wr.fast_reg.page_list_len = pagelist_len;
-	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
-	fr_wr.wr.fast_reg.length = mem->len;
-	fr_wr.wr.fast_reg.rkey = mr->rkey;
-	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
+	ib_set_fastreg_wr(mr, mr->lkey, ISER_FASTREG_LI_WRID,
+			  false, &fr_wr);
 
 	if (!wr)
 		wr = &fr_wr;
@@ -2648,8 +2570,8 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	fr_desc->ind &= ~ind;
 
 	sge->lkey = mr->lkey;
-	sge->addr = frpl->page_list[0] + page_off;
-	sge->length = mem->len;
+	sge->addr = mr->iova;
+	sge->length = mr->length;
 
 	isert_dbg("sge: addr: 0x%llx  length: %u lkey: %x\n",
 		  sge->addr, sge->length, sge->lkey);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 9ec23a78..a63fc6a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -84,14 +84,12 @@ enum isert_indicator {
 
 struct pi_context {
 	struct ib_mr		       *prot_mr;
-	struct ib_fast_reg_page_list   *prot_frpl;
 	struct ib_mr		       *sig_mr;
 };
 
 struct fast_reg_descriptor {
 	struct list_head		list;
 	struct ib_mr		       *data_mr;
-	struct ib_fast_reg_page_list   *data_frpl;
 	u8				ind;
 	struct pi_context	       *pi_ctx;
 };
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
