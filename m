From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 2/2] IB/rxe: Remove FMR support
Date: Tue,  5 Jul 2016 19:05:50 +0300
Message-ID: <1467734750-20298-3-git-send-email-monis@mellanox.com>
References: <1467734750-20298-1-git-send-email-monis@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467734750-20298-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fast memory registration via the send queue is the preferred method for
memory registration inside the kernel. FMR interface is considered
obsolete and shouldn't be supported with in modern drivers.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/rxe/rxe.c       | 18 +++------
 drivers/infiniband/hw/rxe/rxe_loc.h   |  3 --
 drivers/infiniband/hw/rxe/rxe_mr.c    | 41 +------------------
 drivers/infiniband/hw/rxe/rxe_param.h |  8 ++--
 drivers/infiniband/hw/rxe/rxe_pool.c  | 10 +----
 drivers/infiniband/hw/rxe/rxe_pool.h  |  1 -
 drivers/infiniband/hw/rxe/rxe_verbs.c | 74 -----------------------------------
 drivers/infiniband/hw/rxe/rxe_verbs.h |  7 ----
 8 files changed, 10 insertions(+), 152 deletions(-)

diff --git a/drivers/infiniband/hw/rxe/rxe.c b/drivers/infiniband/hw/rxe/rxe.c
index d49418b..55f0e8f 100644
--- a/drivers/infiniband/hw/rxe/rxe.c
+++ b/drivers/infiniband/hw/rxe/rxe.c
@@ -59,7 +59,6 @@ static void rxe_cleanup(struct rxe_dev *rxe)
 	rxe_pool_cleanup(&rxe->qp_pool);
 	rxe_pool_cleanup(&rxe->cq_pool);
 	rxe_pool_cleanup(&rxe->mr_pool);
-	rxe_pool_cleanup(&rxe->fmr_pool);
 	rxe_pool_cleanup(&rxe->mw_pool);
 	rxe_pool_cleanup(&rxe->mc_grp_pool);
 	rxe_pool_cleanup(&rxe->mc_elem_pool);
@@ -226,34 +225,27 @@ static int rxe_init_pools(struct rxe_dev *rxe)
 	if (err)
 		goto err7;
 
-	err = rxe_pool_init(rxe, &rxe->fmr_pool, RXE_TYPE_FMR,
-			    rxe->attr.max_fmr);
-	if (err)
-		goto err8;
-
 	err = rxe_pool_init(rxe, &rxe->mw_pool, RXE_TYPE_MW,
 			    rxe->attr.max_mw);
 	if (err)
-		goto err9;
+		goto err8;
 
 	err = rxe_pool_init(rxe, &rxe->mc_grp_pool, RXE_TYPE_MC_GRP,
 			    rxe->attr.max_mcast_grp);
 	if (err)
-		goto err10;
+		goto err9;
 
 	err = rxe_pool_init(rxe, &rxe->mc_elem_pool, RXE_TYPE_MC_ELEM,
 			    rxe->attr.max_total_mcast_qp_attach);
 	if (err)
-		goto err11;
+		goto err10;
 
 	return 0;
 
-err11:
-	rxe_pool_cleanup(&rxe->mc_grp_pool);
 err10:
-	rxe_pool_cleanup(&rxe->mw_pool);
+	rxe_pool_cleanup(&rxe->mc_grp_pool);
 err9:
-	rxe_pool_cleanup(&rxe->fmr_pool);
+	rxe_pool_cleanup(&rxe->mw_pool);
 err8:
 	rxe_pool_cleanup(&rxe->mr_pool);
 err7:
diff --git a/drivers/infiniband/hw/rxe/rxe_loc.h b/drivers/infiniband/hw/rxe/rxe_loc.h
index 34ac568..4a5484e 100644
--- a/drivers/infiniband/hw/rxe/rxe_loc.h
+++ b/drivers/infiniband/hw/rxe/rxe_loc.h
@@ -115,9 +115,6 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 int rxe_mem_init_fast(struct rxe_dev *rxe, struct rxe_pd *pd,
 		      int max_pages, struct rxe_mem *mem);
 
-int rxe_mem_init_fmr(struct rxe_dev *rxe, struct rxe_pd *pd, int access,
-		     struct ib_fmr_attr *attr, struct rxe_mem *fmr);
-
 int rxe_mem_copy(struct rxe_mem *mem, u64 iova, void *addr,
 		 int length, enum copy_direction dir, u32 *crcp);
 
diff --git a/drivers/infiniband/hw/rxe/rxe_mr.c b/drivers/infiniband/hw/rxe/rxe_mr.c
index 6f9bf13..f3dab65 100644
--- a/drivers/infiniband/hw/rxe/rxe_mr.c
+++ b/drivers/infiniband/hw/rxe/rxe_mr.c
@@ -80,9 +80,6 @@ static void rxe_mem_init(int access, struct rxe_mem *mem)
 	if (mem->pelem.pool->type == RXE_TYPE_MR) {
 		mem->ibmr.lkey		= lkey;
 		mem->ibmr.rkey		= rkey;
-	} else {
-		mem->ibfmr.lkey		= lkey;
-		mem->ibfmr.rkey		= rkey;
 	}
 
 	mem->lkey		= lkey;
@@ -264,38 +261,6 @@ err1:
 	return err;
 }
 
-int rxe_mem_init_fmr(struct rxe_dev *rxe, struct rxe_pd *pd, int access,
-		     struct ib_fmr_attr *attr, struct rxe_mem *mem)
-{
-	int err;
-
-	if (attr->max_maps > rxe->attr.max_map_per_fmr) {
-		pr_warn("max_mmaps = %d too big, max_map_per_fmr = %d\n",
-			attr->max_maps, rxe->attr.max_map_per_fmr);
-		err = -EINVAL;
-		goto err1;
-	}
-
-	rxe_mem_init(access, mem);
-
-	err = rxe_mem_alloc(rxe, mem, attr->max_pages);
-	if (err)
-		goto err1;
-
-	mem->pd			= pd;
-	mem->access		= access;
-	mem->page_shift		 = attr->page_shift;
-	mem->page_mask		= (1 << attr->page_shift) - 1;
-	mem->max_buf		= attr->max_pages;
-	mem->state		= RXE_MEM_STATE_FREE;
-	mem->type		= RXE_MEM_TYPE_FMR;
-
-	return 0;
-
-err1:
-	return err;
-}
-
 static void lookup_iova(
 	struct rxe_mem	*mem,
 	u64			iova,
@@ -591,7 +556,7 @@ int advance_dma_data(struct rxe_dma_info *dma, unsigned int length)
 	return 0;
 }
 
-/* (1) find the mem (mr, fmr or mw) corresponding to lkey/rkey
+/* (1) find the mem (mr or mw) corresponding to lkey/rkey
  *     depending on lookup_type
  * (2) verify that the (qp) pd matches the mem pd
  * (3) verify that the mem can support the requested access
@@ -608,10 +573,6 @@ struct rxe_mem *lookup_mem(struct rxe_pd *pd, int access, u32 key,
 		mem = rxe_pool_get_index(&rxe->mr_pool, index);
 		if (!mem)
 			goto err1;
-	} else if (index >= RXE_MIN_FMR_INDEX && index <= RXE_MAX_FMR_INDEX) {
-		mem = rxe_pool_get_index(&rxe->fmr_pool, index);
-		if (!mem)
-			goto err1;
 	} else {
 		goto err1;
 	}
diff --git a/drivers/infiniband/hw/rxe/rxe_param.h b/drivers/infiniband/hw/rxe/rxe_param.h
index 27ac76c..f459c43 100644
--- a/drivers/infiniband/hw/rxe/rxe_param.h
+++ b/drivers/infiniband/hw/rxe/rxe_param.h
@@ -100,8 +100,8 @@ enum rxe_device_param {
 	RXE_MAX_MCAST_QP_ATTACH		= 56,
 	RXE_MAX_TOT_MCAST_QP_ATTACH	= 0x70000,
 	RXE_MAX_AH			= 100,
-	RXE_MAX_FMR			= 2 * 1024,
-	RXE_MAX_MAP_PER_FMR		= 100,
+	RXE_MAX_FMR			= 0,
+	RXE_MAX_MAP_PER_FMR		= 0,
 	RXE_MAX_SRQ			= 960,
 	RXE_MAX_SRQ_WR			= 0x4000,
 	RXE_MIN_SRQ_WR			= 1,
@@ -123,9 +123,7 @@ enum rxe_device_param {
 	RXE_MAX_SRQ_INDEX		= 0x00040000,
 
 	RXE_MIN_MR_INDEX		= 0x00000001,
-	RXE_MAX_MR_INDEX		= 0x00020000,
-	RXE_MIN_FMR_INDEX		= 0x00020001,
-	RXE_MAX_FMR_INDEX		= 0x00040000,
+	RXE_MAX_MR_INDEX		= 0x00040000,
 	RXE_MIN_MW_INDEX		= 0x00040001,
 	RXE_MAX_MW_INDEX		= 0x00060000,
 	RXE_MAX_PKT_PER_ACK		= 64,
diff --git a/drivers/infiniband/hw/rxe/rxe_pool.c b/drivers/infiniband/hw/rxe/rxe_pool.c
index cd37d4f..6bac071 100644
--- a/drivers/infiniband/hw/rxe/rxe_pool.c
+++ b/drivers/infiniband/hw/rxe/rxe_pool.c
@@ -35,7 +35,7 @@
 #include "rxe_loc.h"
 
 /* info about object pools
- * note that mr, fmr and mw share a single index space
+ * note that mr and mw share a single index space
  * so that one can map an lkey to the correct type of object
  */
 struct rxe_type_info rxe_type_info[RXE_NUM_TYPES] = {
@@ -80,14 +80,6 @@ struct rxe_type_info rxe_type_info[RXE_NUM_TYPES] = {
 		.max_index	= RXE_MAX_MR_INDEX,
 		.min_index	= RXE_MIN_MR_INDEX,
 	},
-	[RXE_TYPE_FMR] = {
-		.name		= "rxe-fmr",
-		.size		= sizeof(struct rxe_mem),
-		.cleanup	= rxe_mem_cleanup,
-		.flags		= RXE_POOL_INDEX,
-		.max_index	= RXE_MAX_FMR_INDEX,
-		.min_index	= RXE_MIN_FMR_INDEX,
-	},
 	[RXE_TYPE_MW] = {
 		.name		= "rxe-mw",
 		.size		= sizeof(struct rxe_mem),
diff --git a/drivers/infiniband/hw/rxe/rxe_pool.h b/drivers/infiniband/hw/rxe/rxe_pool.h
index 43476b5..4d04830 100644
--- a/drivers/infiniband/hw/rxe/rxe_pool.h
+++ b/drivers/infiniband/hw/rxe/rxe_pool.h
@@ -52,7 +52,6 @@ enum rxe_elem_type {
 	RXE_TYPE_CQ,
 	RXE_TYPE_MR,
 	RXE_TYPE_MW,
-	RXE_TYPE_FMR,
 	RXE_TYPE_MC_GRP,
 	RXE_TYPE_MC_ELEM,
 	RXE_NUM_TYPES,		/* keep me last */
diff --git a/drivers/infiniband/hw/rxe/rxe_verbs.c b/drivers/infiniband/hw/rxe/rxe_verbs.c
index c5d48c4..4552be9 100644
--- a/drivers/infiniband/hw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/hw/rxe/rxe_verbs.c
@@ -1153,76 +1153,6 @@ static int rxe_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nent
 	return n;
 }
 
-static struct ib_fmr *rxe_alloc_fmr(struct ib_pd *ibpd,
-				    int access, struct ib_fmr_attr *attr)
-{
-	struct rxe_dev *rxe = to_rdev(ibpd->device);
-	struct rxe_pd *pd = to_rpd(ibpd);
-	struct rxe_mem *fmr;
-	int err;
-
-	fmr = rxe_alloc(&rxe->fmr_pool);
-	if (!fmr) {
-		err = -ENOMEM;
-		goto err1;
-	}
-
-	rxe_add_index(fmr);
-
-	rxe_add_ref(pd);
-
-	err = rxe_mem_init_fmr(rxe, pd, access, attr, fmr);
-	if (err)
-		goto err2;
-
-	return &fmr->ibfmr;
-
-err2:
-	rxe_drop_ref(pd);
-	rxe_drop_index(fmr);
-	rxe_drop_ref(fmr);
-err1:
-	return ERR_PTR(err);
-}
-
-static int rxe_map_phys_fmr(struct ib_fmr *ibfmr,
-			    u64 *page_list, int list_length, u64 iova)
-{
-	struct rxe_mem *fmr = to_rfmr(ibfmr);
-	struct rxe_dev *rxe = to_rdev(ibfmr->device);
-
-	return rxe_mem_map_pages(rxe, fmr, page_list, list_length, iova);
-}
-
-static int rxe_unmap_fmr(struct list_head *fmr_list)
-{
-	struct rxe_mem *fmr;
-
-	list_for_each_entry(fmr, fmr_list, ibfmr.list) {
-		if (fmr->state != RXE_MEM_STATE_VALID)
-			continue;
-
-		fmr->va = 0;
-		fmr->iova = 0;
-		fmr->length = 0;
-		fmr->num_buf = 0;
-		fmr->state = RXE_MEM_STATE_FREE;
-	}
-
-	return 0;
-}
-
-static int rxe_dealloc_fmr(struct ib_fmr *ibfmr)
-{
-	struct rxe_mem *fmr = to_rfmr(ibfmr);
-
-	fmr->state = RXE_MEM_STATE_ZOMBIE;
-	rxe_drop_ref(fmr->pd);
-	rxe_drop_index(fmr);
-	rxe_drop_ref(fmr);
-	return 0;
-}
-
 static int rxe_attach_mcast(struct ib_qp *ibqp, union ib_gid *mgid, u16 mlid)
 {
 	int err;
@@ -1360,10 +1290,6 @@ int rxe_register_device(struct rxe_dev *rxe)
 	dev->dereg_mr = rxe_dereg_mr;
 	dev->alloc_mr = rxe_alloc_mr;
 	dev->map_mr_sg = rxe_map_mr_sg;
-	dev->alloc_fmr = rxe_alloc_fmr;
-	dev->map_phys_fmr = rxe_map_phys_fmr;
-	dev->unmap_fmr = rxe_unmap_fmr;
-	dev->dealloc_fmr = rxe_dealloc_fmr;
 	dev->attach_mcast = rxe_attach_mcast;
 	dev->detach_mcast = rxe_detach_mcast;
 
diff --git a/drivers/infiniband/hw/rxe/rxe_verbs.h b/drivers/infiniband/hw/rxe/rxe_verbs.h
index d34c056..feeb41e 100644
--- a/drivers/infiniband/hw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/hw/rxe/rxe_verbs.h
@@ -310,7 +310,6 @@ struct rxe_mem {
 	struct rxe_pool_entry	pelem;
 	union {
 		struct ib_mr		ibmr;
-		struct ib_fmr		ibfmr;
 		struct ib_mw		ibmw;
 	};
 
@@ -415,7 +414,6 @@ struct rxe_dev {
 	struct rxe_pool		cq_pool;
 	struct rxe_pool		mr_pool;
 	struct rxe_pool		mw_pool;
-	struct rxe_pool		fmr_pool;
 	struct rxe_pool		mc_grp_pool;
 	struct rxe_pool		mc_elem_pool;
 
@@ -469,11 +467,6 @@ static inline struct rxe_mem *to_rmr(struct ib_mr *mr)
 	return mr ? container_of(mr, struct rxe_mem, ibmr) : NULL;
 }
 
-static inline struct rxe_mem *to_rfmr(struct ib_fmr *fmr)
-{
-	return fmr ? container_of(fmr, struct rxe_mem, ibfmr) : NULL;
-}
-
 static inline struct rxe_mem *to_rmw(struct ib_mw *mw)
 {
 	return mw ? container_of(mw, struct rxe_mem, ibmw) : NULL;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
