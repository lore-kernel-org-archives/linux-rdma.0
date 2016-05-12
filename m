From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/7] IB/core: Enhance ib_map_mr_sg()
Date: Thu, 12 May 2016 10:49:15 -0700
Message-ID: <5734C21B.4090908@sandisk.com>
References: <5734C181.2020003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5734C181.2020003-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The SRP initiator allows to set max_sectors to a value that exceeds
the largest amount of data that can be mapped at once with an mlx4
HCA using fast registration and a page size of 4 KB. Hence modify
ib_map_mr_sg() such that it can map partial sg-elements. If an
sg-element has been mapped partially, let the caller know
which fraction has been mapped by adjusting *sg_offset.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/rw.c                |  2 +-
 drivers/infiniband/core/verbs.c             | 26 +++++++++++++++++++++-----
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  2 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |  2 +-
 drivers/infiniband/hw/cxgb4/mem.c           |  2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h        |  2 +-
 drivers/infiniband/hw/mlx4/mr.c             |  2 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h        |  2 +-
 drivers/infiniband/hw/mlx5/mr.c             |  8 ++++++--
 drivers/infiniband/hw/nes/nes_verbs.c       |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |  2 +-
 drivers/infiniband/ulp/iser/iser_memory.c   |  4 ++--
 drivers/infiniband/ulp/srp/ib_srp.c         |  2 +-
 include/rdma/ib_verbs.h                     |  8 ++++----
 net/sunrpc/xprtrdma/frwr_ops.c              |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c     |  2 +-
 18 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 6fc50bf..1eb9b12 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -92,7 +92,7 @@ static int rdma_rw_init_one_mr(struct ib_qp *qp, u8 port_num,
 		reg->inv_wr.next = NULL;
 	}
 
-	ret = ib_map_mr_sg(reg->mr, sg, nents, offset, PAGE_SIZE);
+	ret = ib_map_mr_sg(reg->mr, sg, nents, &offset, PAGE_SIZE);
 	if (ret < nents) {
 		ib_mr_pool_put(qp, &qp->rdma_mrs, reg->mr);
 		return -EINVAL;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3d7b266..1d7d4cf 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1655,7 +1655,7 @@ EXPORT_SYMBOL(ib_set_vf_guid);
  * is ready for registration.
  */
 int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset, unsigned int page_size)
+		 unsigned int *sg_offset, unsigned int page_size)
 {
 	if (unlikely(!mr->device->map_mr_sg))
 		return -ENOSYS;
@@ -1672,7 +1672,10 @@ EXPORT_SYMBOL(ib_map_mr_sg);
  * @mr:            memory region
  * @sgl:           dma mapped scatterlist
  * @sg_nents:      number of entries in sg
- * @sg_offset:     offset in bytes into sg
+ * @sg_offset_p:   IN:  start offset in bytes into sg
+ *                 OUT: offset in bytes for element n of the sg of the first
+ *                      byte that has not been processed where n is the return
+ *                      value of this function.
  * @set_page:      driver page assignment function pointer
  *
  * Core service helper for drivers to convert the largest
@@ -1684,19 +1687,24 @@ EXPORT_SYMBOL(ib_map_mr_sg);
  * a page vector.
  */
 int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
-		unsigned int sg_offset, int (*set_page)(struct ib_mr *, u64))
+		unsigned int *sg_offset_p, int (*set_page)(struct ib_mr *, u64))
 {
 	struct scatterlist *sg;
 	u64 last_end_dma_addr = 0;
+	unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 	unsigned int last_page_off = 0;
 	u64 page_mask = ~((u64)mr->page_size - 1);
 	int i, ret;
 
+	if (unlikely(sg_nents <= 0 || sg_offset > sg_dma_len(&sgl[0])))
+		return -EINVAL;
+
 	mr->iova = sg_dma_address(&sgl[0]) + sg_offset;
 	mr->length = 0;
 
 	for_each_sg(sgl, sg, sg_nents, i) {
 		u64 dma_addr = sg_dma_address(sg) + sg_offset;
+		u64 prev_addr = dma_addr;
 		unsigned int dma_len = sg_dma_len(sg) - sg_offset;
 		u64 end_dma_addr = dma_addr + dma_len;
 		u64 page_addr = dma_addr & page_mask;
@@ -1721,8 +1729,14 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 
 		do {
 			ret = set_page(mr, page_addr);
-			if (unlikely(ret < 0))
-				return i ? : ret;
+			if (unlikely(ret < 0)) {
+				sg_offset = prev_addr - sg_dma_address(sg);
+				mr->length += prev_addr - dma_addr;
+				if (sg_offset_p)
+					*sg_offset_p = sg_offset;
+				return i || sg_offset ? i : ret;
+			}
+			prev_addr = page_addr;
 next_page:
 			page_addr += mr->page_size;
 		} while (page_addr < end_dma_addr);
@@ -1734,6 +1748,8 @@ next_page:
 		sg_offset = 0;
 	}
 
+	if (sg_offset_p)
+		*sg_offset_p = 0;
 	return i;
 }
 EXPORT_SYMBOL(ib_sg_to_pages);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 608aa0c..47cb927 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -784,7 +784,7 @@ static int iwch_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 static int iwch_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
-		int sg_nents, unsigned sg_offset)
+			  int sg_nents, unsigned int *sg_offset)
 {
 	struct iwch_mr *mhp = to_iwch_mr(ibmr);
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 067cb3f..1ff3ba8 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -918,7 +918,7 @@ struct ib_mr *c4iw_alloc_mr(struct ib_pd *pd,
 			    enum ib_mr_type mr_type,
 			    u32 max_num_sg);
 int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset);
+		   unsigned int *sg_offset);
 int c4iw_dealloc_mw(struct ib_mw *mw);
 struct ib_mw *c4iw_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
 			    struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 38afb3d..83960df 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -691,7 +691,7 @@ static int c4iw_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 int c4iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset)
+		   unsigned int *sg_offset)
 {
 	struct c4iw_mr *mhp = to_c4iw_mr(ibmr);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 141eaba..4a740f7 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -1574,7 +1574,7 @@ static int i40iw_set_page(struct ib_mr *ibmr, u64 addr)
  * @sg_nents: number of sg pages
  */
 static int i40iw_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
-		int sg_nents, unsigned int sg_offset)
+			   int sg_nents, unsigned int *sg_offset)
 {
 	struct i40iw_mr *iwmr = to_iwmr(ibmr);
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index ba328177..6c5ac5d 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -718,7 +718,7 @@ struct ib_mr *mlx4_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg);
 int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset);
+		      unsigned int *sg_offset);
 int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
 struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index b04f623..6312721 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -529,7 +529,7 @@ static int mlx4_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 int mlx4_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset)
+		      unsigned int *sg_offset)
 {
 	struct mlx4_ib_mr *mr = to_mmr(ibmr);
 	int rc;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8c835b2..f05cf57 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -713,7 +713,7 @@ struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg);
 int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset);
+		      unsigned int *sg_offset);
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 			const struct ib_mad_hdr *in, size_t in_mad_size,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b678eac..8cf2ce5 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1752,10 +1752,11 @@ static int
 mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
 		   struct scatterlist *sgl,
 		   unsigned short sg_nents,
-		   unsigned int sg_offset)
+		   unsigned int *sg_offset_p)
 {
 	struct scatterlist *sg = sgl;
 	struct mlx5_klm *klms = mr->descs;
+	unsigned int sg_offset = sg_offset_p ? *sg_offset_p : 0;
 	u32 lkey = mr->ibmr.pd->local_dma_lkey;
 	int i;
 
@@ -1774,6 +1775,9 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
 		sg_offset = 0;
 	}
 
+	if (sg_offset_p)
+		*sg_offset_p = sg_offset;
+
 	return i;
 }
 
@@ -1792,7 +1796,7 @@ static int mlx5_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 int mlx5_ib_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset)
+		      unsigned int *sg_offset)
 {
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
 	int n;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 698aab6..4ebea4c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -403,7 +403,7 @@ static int nes_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 static int nes_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
-		int sg_nents, unsigned int sg_offset)
+			 int sg_nents, unsigned int *sg_offset)
 {
 	struct nes_mr *nesmr = to_nesmr(ibmr);
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 9ddd550..b1a3d91 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -3082,7 +3082,7 @@ static int ocrdma_set_page(struct ib_mr *ibmr, u64 addr)
 }
 
 int ocrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset)
+		     unsigned int *sg_offset)
 {
 	struct ocrdma_mr *mr = get_ocrdma_mr(ibmr);
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b290e5d..704ef1e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -123,6 +123,6 @@ struct ib_mr *ocrdma_alloc_mr(struct ib_pd *pd,
 			      enum ib_mr_type mr_type,
 			      u32 max_num_sg);
 int ocrdma_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
-		unsigned sg_offset);
+		     unsigned int *sg_offset);
 
 #endif				/* __OCRDMA_VERBS_H__ */
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 44cc85f..90be568 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -236,7 +236,7 @@ int iser_fast_reg_fmr(struct iscsi_iser_task *iser_task,
 	page_vec->npages = 0;
 	page_vec->fake_mr.page_size = SIZE_4K;
 	plen = ib_sg_to_pages(&page_vec->fake_mr, mem->sg,
-			      mem->size, 0, iser_set_page);
+			      mem->size, NULL, iser_set_page);
 	if (unlikely(plen < mem->size)) {
 		iser_err("page vec too short to hold this SG\n");
 		iser_data_buf_dump(mem, device->ib_device);
@@ -446,7 +446,7 @@ static int iser_fast_reg_mr(struct iscsi_iser_task *iser_task,
 
 	ib_update_fast_reg_key(mr, ib_inc_rkey(mr->rkey));
 
-	n = ib_map_mr_sg(mr, mem->sg, mem->size, 0, SIZE_4K);
+	n = ib_map_mr_sg(mr, mem->sg, mem->size, NULL, SIZE_4K);
 	if (unlikely(n != mem->size)) {
 		iser_err("failed to map sg (%d/%d)\n",
 			 n, mem->size);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index f4dc6f9..6440469 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1329,7 +1329,7 @@ static int srp_map_finish_fr(struct srp_map_state *state,
 	rkey = ib_inc_rkey(desc->mr->rkey);
 	ib_update_fast_reg_key(desc->mr, rkey);
 
-	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, 0, dev->mr_page_size);
+	n = ib_map_mr_sg(desc->mr, state->sg, sg_nents, NULL, dev->mr_page_size);
 	if (unlikely(n < 0)) {
 		srp_fr_pool_put(ch->fr_pool, &desc, 1);
 		pr_debug("%s: ib_map_mr_sg(%d) returned %d.\n",
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 544c55b..56bb0f3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1848,7 +1848,7 @@ struct ib_device {
 	int                        (*map_mr_sg)(struct ib_mr *mr,
 						struct scatterlist *sg,
 						int sg_nents,
-						unsigned sg_offset);
+						unsigned int *sg_offset);
 	struct ib_mw *             (*alloc_mw)(struct ib_pd *pd,
 					       enum ib_mw_type type,
 					       struct ib_udata *udata);
@@ -3145,11 +3145,11 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev, u8 port,
 					    const struct sockaddr *addr);
 
 int ib_map_mr_sg(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset, unsigned int page_size);
+		 unsigned int *sg_offset, unsigned int page_size);
 
 static inline int
 ib_map_mr_sg_zbva(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
-		unsigned int sg_offset, unsigned int page_size)
+		  unsigned int *sg_offset, unsigned int page_size)
 {
 	int n;
 
@@ -3160,7 +3160,7 @@ ib_map_mr_sg_zbva(struct ib_mr *mr, struct scatterlist *sg, int sg_nents,
 }
 
 int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
-		unsigned int sg_offset, int (*set_page)(struct ib_mr *, u64));
+		unsigned int *sg_offset, int (*set_page)(struct ib_mr *, u64));
 
 void ib_drain_rq(struct ib_qp *qp);
 void ib_drain_sq(struct ib_qp *qp);
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 3274a4a..94c3fa9 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -421,7 +421,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 		return -ENOMEM;
 	}
 
-	n = ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, 0, PAGE_SIZE);
+	n = ib_map_mr_sg(mr, frmr->sg, frmr->sg_nents, NULL, PAGE_SIZE);
 	if (unlikely(n != frmr->sg_nents)) {
 		pr_err("RPC:       %s: failed to map mr %p (%u/%u)\n",
 		       __func__, frmr->fr_mr, n, frmr->sg_nents);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 19a74e9..fbe7444 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -281,7 +281,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	}
 	atomic_inc(&xprt->sc_dma_used);
 
-	n = ib_map_mr_sg(frmr->mr, frmr->sg, frmr->sg_nents, 0, PAGE_SIZE);
+	n = ib_map_mr_sg(frmr->mr, frmr->sg, frmr->sg_nents, NULL, PAGE_SIZE);
 	if (unlikely(n != frmr->sg_nents)) {
 		pr_err("svcrdma: failed to map mr %p (%d/%d elements)\n",
 		       frmr->mr, n, frmr->sg_nents);
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
