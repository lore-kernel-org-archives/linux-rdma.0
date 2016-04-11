From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/12] IB/core: allow passing mapping an offset into the SG in ib_map_mr_sg
Date: Mon, 11 Apr 2016 14:32:31 -0700
Message-ID: <1460410360-13104-4-git-send-email-hch@lst.de>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Steve Wise <swise@opengridcomputing.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
---
 drivers/infiniband/core/verbs.c             | 24 ++++++++++++------------
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  7 +++----
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  5 ++---
 drivers/infiniband/hw/cxgb4/mem.c           |  7 +++----
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |  5 ++---
 drivers/infiniband/hw/mlx4/mr.c             |  7 +++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  5 ++---
 drivers/infiniband/hw/mlx5/mr.c             | 21 ++++++++++++---------
 drivers/infiniband/hw/nes/nes_verbs.c       |  7 +++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  7 +++----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |  5 ++---
 drivers/infiniband/ulp/iser/iser_memory.c   |  4 ++--
 drivers/infiniband/ulp/isert/ib_isert.c     |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |  2 +-
 include/rdma/ib_verbs.h                     | 23 +++++++++--------------
 net/rds/ib_frmr.c                           |  2 +-
 net/sunrpc/xprtrdma/frwr_ops.c              |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c     |  2 +-
 18 files changed, 63 insertions(+), 74 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 15b8adb..064dbef 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1597,6 +1597,7 @@ EXPORT_SYMBOL(ib_set_vf_guid);
  * @mr:            memory region
  * @sg:            dma mapped scatterlist
  * @sg_nents:      number of entries in sg
+ * @sg_offset:     offset in bytes into sg
  * @page_size:     page vector desired page size
  *
  * Constraints:
@@ -1615,17 +1616,15 @@ EXPORT_SYMBOL(ib_set_vf_guid);
  * After this completes successfully, the  memory region
  * is ready for registration.
  */
-int ib_map_mr_sg(struct ib_mr *mr,
-		 struct scatterlist *sg,
-		 int sg_nents,
-		 unsigned int page_size)
+int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset, unsigned int page_size)
 {
 	if (unlikely(!mr->device->map_mr_sg))
 		return -ENOSYS;
 
 	mr->page_size = page_size;
 
-	return mr->device->map_mr_sg(mr, sg, sg_nents);
+	return mr->device->map_mr_sg(mr, sg, sg_nents, sg_offset);
 }
 EXPORT_SYMBOL(ib_map_mr_sg);
 
@@ -1635,6 +1634,7 @@ EXPORT_SYMBOL(ib_map_mr_sg);
  * @mr:            memory region
  * @sgl:           dma mapped scatterlist
  * @sg_nents:      number of entries in sg
+ * @sg_offset:     offset in bytes into sg
  * @set_page:      driver page assignment function pointer
  *
  * Core service helper for drivers to convert the largest
@@ -1645,10 +1645,8 @@ EXPORT_SYMBOL(ib_map_mr_sg);
  * Returns the number of sg elements that were assigned to
  * a page vector.
  */
-int ib_sg_to_pages(struct ib_mr *mr,
-		   struct scatterlist *sgl,
-		   int sg_nents,
-		   int (*set_page)(struct ib_mr *, u64))
+int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
+		unsigned int sg_offset, int (*set_page)(struct ib_mr *, u64))
 {
 	struct scatterlist *sg;
 	u64 last_end_dma_addr = 0;
@@ -1656,12 +1654,12 @@ int ib_sg_to_pages(struct ib_mr *mr,
 	u64 page_mask = ~((u64)mr->page_size - 1);
 	int i, ret;
 
-	mr->iova = sg_dma_address(&sgl[0]);
+	mr->iova = sg_dma_address(&sgl[0]) + sg_offset;
 	mr->length = 0;
 
 	for_each_sg(sgl, sg, sg_nents, i) {
-		u64 dma_addr = sg_dma_address(sg);
-		unsigned int dma_len = sg_dma_len(sg);
+		u64 dma_addr = sg_dma_address(sg) + sg_offset;
+		unsigned int dma_len = sg_dma_len(sg) - sg_offset;
 		u64 end_dma_addr = dma_addr + dma_len;
 		u64 page_addr = dma_addr & page_mask;
 
@@ -1694,6 +1692,8 @@ next_page:
 		mr->length += dma_len;
 		last_end_dma_addr = end_dma_addr;
 		last_page_off = end_dma_addr & ~page_mask;
+
+		sg_offset = 0;
 	}
 
 	return i;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 42a7b89..1423538 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -783,15 +783,14 @@ static int iwch_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-static int iwch_map_mr_sg(struct ib_mr *ibmr,
-			  struct scatterlist *sg,
-			  int sg_nents)
+static int iwch_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		int sg_nents, unsigned sg_offset)
 {
 	struct iwch_mr *mhp = to_iwch_mr(ibmr);
 
 	mhp->npages = 0;
 
-	return ib_sg_to_pages(ibmr, sg, sg_nents, iwch_set_page);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, iwch_set_page);
 }
 
 static int iwch_destroy_qp(struct ib_qp *ib_qp)
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index df43f87..067cb3f 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -917,9 +917,8 @@ void c4iw_qp_rem_ref(struct ib_qp *qp);
 struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
 			    u32 max_num_sg);
-int c4iw_map_mr_sg(struct ib_mr *ibmr,
-		   struct scatterlist *sg,
-		   int sg_nents);
+int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset);
 int c4iw_dealloc_mw(struct ib_mw *mw);
 struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 			    struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 008be07..38afb3d 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -690,15 +690,14 @@ static int c4iw_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-int c4iw_map_mr_sg(struct ib_mr *ibmr,
-		   struct scatterlist *sg,
-		   int sg_nents)
+int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset)
 {
 	struct c4iw_mr *mhp = to_c4iw_mr(ibmr);
 
 	mhp->mpl_len = 0;
 
-	return ib_sg_to_pages(ibmr, sg, sg_nents, c4iw_set_page);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, c4iw_set_page);
 }
 
 int c4iw_dereg_mr(struct ib_mr *ib_mr)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 1eca01c..ba32817 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -717,9 +717,8 @@ int mlx4_ib_dealloc_mw(struct ib_mw *mw);
 struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg);
-int mlx4_ib_map_mr_sg(struct ib_mr *ibmr,
-		      struct scatterlist *sg,
-		      int sg_nents);
+int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset);
 int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
 struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index ce0b5aa..b04f623 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -528,9 +528,8 @@ static int mlx4_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-int mlx4_ib_map_mr_sg(struct ib_mr *ibmr,
-		      struct scatterlist *sg,
-		      int sg_nents)
+int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset)
 {
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
 	int rc;
@@ -541,7 +540,7 @@ int mlx4_ib_map_mr_sg(struct ib_mr *ibmr,
 				   sizeof(u64) * mr->max_pages,
 				   DMA_TO_DEVICE);
 
-	rc = ib_sg_to_pages(ibmr, sg, sg_nents, mlx4_set_page);
+	rc = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, mlx4_set_page);
 
 	ib_dma_sync_single_for_device(ibmr->device, mr->page_map,
 				      sizeof(u64) * mr->max_pages,
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b46c255..8c835b2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -712,9 +712,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg);
-int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
-		      struct scatterlist *sg,
-		      int sg_nents);
+int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset);
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad_hdr *in, size_t in_mad_size,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4d5bff1..b678eac 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1751,24 +1751,27 @@ done:
 static int
 mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
 		   struct scatterlist *sgl,
-		   unsigned short sg_nents)
+		   unsigned short sg_nents,
+		   unsigned int sg_offset)
 {
 	struct scatterlist *sg = sgl;
 	struct mlx5_klm *klms = mr->descs;
 	u32 lkey = mr->ibmr.pd->local_dma_lkey;
 	int i;
 
-	mr->ibmr.iova = sg_dma_address(sg);
+	mr->ibmr.iova = sg_dma_address(sg) + sg_offset;
 	mr->ibmr.length = 0;
 	mr->ndescs = sg_nents;
 
 	for_each_sg(sgl, sg, sg_nents, i) {
 		if (unlikely(i > mr->max_descs))
 			break;
-		klms[i].va = cpu_to_be64(sg_dma_address(sg));
-		klms[i].bcount = cpu_to_be32(sg_dma_len(sg));
+		klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
+		klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
 		klms[i].key = cpu_to_be32(lkey);
 		mr->ibmr.length += sg_dma_len(sg);
+
+		sg_offset = 0;
 	}
 
 	return i;
@@ -1788,9 +1791,8 @@ static int mlx5_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
-		      struct scatterlist *sg,
-		      int sg_nents)
+int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 	int n;
@@ -1802,9 +1804,10 @@ int mlx5_ib_map_mr_sg(struct ib_mr *ibmr,
 				   DMA_TO_DEVICE);
 
 	if (mr->access_mode == MLX5_ACCESS_MODE_KLM)
-		n = mlx5_ib_sg_to_klms(mr, sg, sg_nents);
+		n = mlx5_ib_sg_to_klms(mr, sg, sg_nents, sg_offset);
 	else
-		n = ib_sg_to_pages(ibmr, sg, sg_nents, mlx5_set_page);
+		n = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset,
+				mlx5_set_page);
 
 	ib_dma_sync_single_for_device(ibmr->device, mr->desc_map,
 				      mr->desc_size * mr->max_descs,
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fba69a3..698aab6 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -402,15 +402,14 @@ static int nes_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-static int nes_map_mr_sg(struct ib_mr *ibmr,
-			 struct scatterlist *sg,
-			 int sg_nents)
+static int nes_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
+		int sg_nents, unsigned int sg_offset)
 {
 	struct nes_mr *nesmr = to_nesmr(ibmr);
 
 	nesmr->npages = 0;
 
-	return ib_sg_to_pages(ibmr, sg, sg_nents, nes_set_page);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, nes_set_page);
 }
 
 /**
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index a8496a1..9ddd550 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -3081,13 +3081,12 @@ static int ocrdma_set_page(struct ib_mr *ibmr, u64 addr)
 	return 0;
 }
 
-int ocrdma_map_mr_sg(struct ib_mr *ibmr,
-		     struct scatterlist *sg,
-		     int sg_nents)
+int ocrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset)
 {
 	struct ocrdma_mr *mr = get_ocrdma_mr(ibmr);
 
 	mr->npages = 0;
 
-	return ib_sg_to_pages(ibmr, sg, sg_nents, ocrdma_set_page);
+	return ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, ocrdma_set_page);
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index 8b517fd..b290e5d 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -122,8 +122,7 @@ struct ib_mr *ocrdma_reg_user_mr(struct ib_pd *, u64 start, u64 length,
 struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
 			      enum ib_mr_type mr_type,
 			      u32 max_num_sg);
-int ocrdma_map_mr_sg(struct ib_mr *ibmr,
-		     struct scatterlist *sg,
-		     int sg_nents);
+int ocrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
+		unsigned sg_offset);
 
 #endif				/* __OCRDMA_VERBS_H__ */
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9a391cc..44cc85f 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -236,7 +236,7 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 	page_vec->npages = 0;
 	page_vec->fake_mr.page_size = SIZE_4K;
 	plen = ib_sg_to_pages(&page_vec->fake_mr, mem->sg,
-			      mem->size, iser_set_page);
+			      mem->size, 0, iser_set_page);
 	if (unlikely(plen < mem->size)) {
 		iser_err("page vec too short to hold this SG\n");
 		iser_data_buf_dump(mem, device->ib_device);
@@ -446,7 +446,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 
-	n = ib_map_mr_sg(mr, mem->sg, mem->size, SIZE_4K);
+	n = ib_map_mr_sg(mr, mem->sg, mem->size, 0, SIZE_4K);
 	if (unlikely(n != mem->size)) {
 		iser_err("failed to map sg (%d/%d)\n",
 			 n, mem->size);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 411e446..a44a736 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2461,7 +2461,7 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 		wr = &inv_wr;
 	}
 
-	n = ib_map_mr_sg(mr, mem->sg, mem->nents, PAGE_SIZE);
+	n = ib_map_mr_sg(mr, mem->sg, mem->nents, 0, PAGE_SIZE);
 	if (unlikely(n != mem->nents)) {
 		isert_err("failed to map mr sg (%d/%d)\n",
 			 n, mem->nents);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index b6bf204..ca425f2 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1333,7 +1333,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	rkey = ib_inc_rkey(desc->mr->rkey);
 	ib_update_fast_reg_key(desc->mr, rkey);
 
-	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, dev->mr_page_size);
+	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, 0, dev->mr_page_size);
 	if (unlikely(n < 0))
 		return n;
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index fb2cef4..24d0d82 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1827,7 +1827,8 @@ struct ib_device {
 					       u32 max_num_sg);
 	int                        (*map_mr_sg)(struct ib_mr *mr,
 						struct scatterlist *sg,
-						int sg_nents);
+						int sg_nents,
+						unsigned sg_offset);
 	struct ib_mw *             (*alloc_mw)(struct ib_pd *pd,
 					       enum ib_mw_type type,
 					       struct ib_udata *udata);
@@ -3111,29 +3112,23 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u8 port,
 					    u16 pkey, const union ib_gid *gid,
 					    const struct sockaddr *addr);
 
-int ib_map_mr_sg(struct ib_mr *mr,
-		 struct scatterlist *sg,
-		 int sg_nents,
-		 unsigned int page_size);
+int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset, unsigned int page_size);
 
 static inline int
-ib_map_mr_sg_zbva(struct ib_mr *mr,
-		  struct scatterlist *sg,
-		  int sg_nents,
-		  unsigned int page_size)
+ib_map_mr_sg_zbva(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
+		unsigned int sg_offset, unsigned int page_size)
 {
 	int n;
 
-	n = ib_map_mr_sg(mr, sg, sg_nents, page_size);
+	n = ib_map_mr_sg(mr, sg, sg_nents, sg_offset, page_size);
 	mr->iova = 0;
 
 	return n;
 }
 
-int ib_sg_to_pages(struct ib_mr *mr,
-		   struct scatterlist *sgl,
-		   int sg_nents,
-		   int (*set_page)(struct ib_mr *, u64));
+int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
+		unsigned int sg_offset, int (*set_page)(struct ib_mr *, u64));
 
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 93ff038..d921adc 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -111,7 +111,7 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len, PAGE_SIZE);
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len, 0, PAGE_SIZE);
 	if (unlikely(ret != ibmr->sg_len))
 		return ret < 0 ? ret : -EINVAL;
 
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index c250924..3274a4a 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -421,7 +421,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 		return -ENOMEM;
 	}
 
-	n = ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, PAGE_SIZE);
+	n = ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, 0, PAGE_SIZE);
 	if (unlikely(n != frmr->sg_nents)) {
 		pr_err("RPC:       %s: failed to map mr %p (%u/%u)\n",
 		       __func__, frmr->fr_mr, n, frmr->sg_nents);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 3b24a64..19a74e9 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -281,7 +281,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	}
 	atomic_inc(&xprt->sc_dma_used);
 
-	n = ib_map_mr_sg(frmr->mr, frmr->sg, frmr->sg_nents, PAGE_SIZE);
+	n = ib_map_mr_sg(frmr->mr, frmr->sg, frmr->sg_nents, 0, PAGE_SIZE);
 	if (unlikely(n != frmr->sg_nents)) {
 		pr_err("svcrdma: failed to map mr %p (%d/%d elements)\n",
 		       frmr->mr, n, frmr->sg_nents);
-- 
2.1.4
