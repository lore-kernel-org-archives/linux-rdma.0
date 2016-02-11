From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 7/7] IB/mlx5: Invalidation support for MR over peer memory
Date: Thu, 11 Feb 2016 18:12:57 +0200
Message-ID: <1455207177-11949-8-git-send-email-artemyko@mellanox.com>
References: <1455207177-11949-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455207177-11949-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-Dj0/KMMU01E@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adds the required functionality to work with peer memory
clients which require invalidation support.

It includes:

- module moved to use ib_umem_get_flags.
- umem invalidation callback - once called should free any HW
  resources assigned to that umem, then free peer resources
  corresponding to that umem.
- The MR object relates to that umem is stay alive till dereg_mr is
  called.
- synchronizing support between dereg_mr to invalidate callback.
- advertises the P2P device capability.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c       |  15 ++-
 drivers/infiniband/hw/mlx5/doorbell.c |   6 +-
 drivers/infiniband/hw/mlx5/main.c     |   3 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h  |  12 +++
 drivers/infiniband/hw/mlx5/mr.c       | 166 ++++++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx5/qp.c       |   3 +-
 drivers/infiniband/hw/mlx5/srq.c      |   4 +-
 7 files changed, 163 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 7ddc790..c41913d 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -651,9 +651,11 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 
 	*cqe_size = ucmd.cqe_size;
 
-	cq->buf.umem = ib_umem_get(context, ucmd.buf_addr,
-				   entries * ucmd.cqe_size,
-				   IB_ACCESS_LOCAL_WRITE, 1);
+	cq->buf.umem = ib_umem_get_flags(context, ucmd.buf_addr,
+					 entries * ucmd.cqe_size,
+					 IB_ACCESS_LOCAL_WRITE,
+					 IB_UMEM_DMA_SYNC |
+					 IB_UMEM_PEER_ALLOW);
 	if (IS_ERR(cq->buf.umem)) {
 		err = PTR_ERR(cq->buf.umem);
 		return err;
@@ -991,8 +993,11 @@ static int resize_user(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
 	if (ucmd.reserved0 || ucmd.reserved1)
 		return -EINVAL;
 
-	umem = ib_umem_get(context, ucmd.buf_addr, entries * ucmd.cqe_size,
-			   IB_ACCESS_LOCAL_WRITE, 1);
+	umem = ib_umem_get_flags(context, ucmd.buf_addr,
+				 entries * ucmd.cqe_size,
+				 IB_ACCESS_LOCAL_WRITE,
+				 IB_UMEM_DMA_SYNC |
+				 IB_UMEM_PEER_ALLOW);
 	if (IS_ERR(umem)) {
 		err = PTR_ERR(umem);
 		return err;
diff --git a/drivers/infiniband/hw/mlx5/doorbell.c b/drivers/infiniband/hw/mlx5/doorbell.c
index a0e4e6d..1d76094 100644
--- a/drivers/infiniband/hw/mlx5/doorbell.c
+++ b/drivers/infiniband/hw/mlx5/doorbell.c
@@ -63,8 +63,10 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context, unsigned long virt,
 
 	page->user_virt = (virt & PAGE_MASK);
 	page->refcnt    = 0;
-	page->umem      = ib_umem_get(&context->ibucontext, virt & PAGE_MASK,
-				      PAGE_SIZE, 0, 0);
+	page->umem      = ib_umem_get_flags(&context->ibucontext,
+					    virt & PAGE_MASK,
+					    PAGE_SIZE, 0,
+					    IB_UMEM_PEER_ALLOW);
 	if (IS_ERR(page->umem)) {
 		err = PTR_ERR(page->umem);
 		kfree(page);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a55bf05..f198208 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -475,6 +475,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		IB_DEVICE_PORT_ACTIVE_EVENT		|
 		IB_DEVICE_SYS_IMAGE_GUID		|
 		IB_DEVICE_RC_RNR_NAK_GEN;
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	props->device_cap_flags |= IB_DEVICE_PEER_MEMORY;
+#endif
 
 	if (MLX5_CAP_GEN(mdev, pkv))
 		props->device_cap_flags |= IB_DEVICE_BAD_PKEY_CNTR;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d475f83..12571e0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -376,6 +376,13 @@ enum mlx5_ib_mtt_access_flags {
 
 #define MLX5_IB_MTT_PRESENT (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE)
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+struct mlx5_ib_peer_id {
+	struct completion comp;
+	struct mlx5_ib_mr *mr;
+};
+#endif
+
 struct mlx5_ib_mr {
 	struct ib_mr		ibmr;
 	void			*descs;
@@ -395,6 +402,11 @@ struct mlx5_ib_mr {
 	struct mlx5_core_sig_ctx    *sig;
 	int			live;
 	void			*descs_alloc;
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	struct mlx5_ib_peer_id  *peer_id;
+	atomic_t      invalidated;
+	struct completion invalidation_comp;
+#endif
 };
 
 struct mlx5_ib_umr_context {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6000f7a..d34199c 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1037,6 +1037,73 @@ err_1:
 	return ERR_PTR(err);
 }
 
+static int mlx5_ib_invalidate_mr(struct ib_mr *ibmr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	int npages = mr->npages;
+	struct ib_umem *umem = mr->umem;
+
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	if (umem && umem->odp_data) {
+		/* Prevent new page faults from succeeding */
+		mr->live = 0;
+		/* Wait for all running page-fault handlers to finish. */
+		synchronize_srcu(&dev->mr_srcu);
+		/* Destroy all page mappings */
+		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
+					 ib_umem_end(umem));
+		/*
+		 * We kill the umem before the MR for ODP,
+		 * so that there will not be any invalidations in
+		 * flight, looking at the *mr struct.
+		 */
+		ib_umem_release(umem);
+		atomic_sub(npages, &dev->mdev->priv.reg_pages);
+
+		/* Avoid double-freeing the umem. */
+		umem = NULL;
+	}
+#endif
+
+	clean_mr(mr);
+
+	if (umem) {
+		ib_umem_release(umem);
+		atomic_sub(npages, &dev->mdev->priv.reg_pages);
+	}
+	return 0;
+}
+
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+static void mlx5_invalidate_umem(void *invalidation_cookie,
+				 struct ib_umem *umem,
+				 unsigned long addr, size_t size)
+{
+	struct mlx5_ib_mr *mr;
+	struct mlx5_ib_peer_id *peer_id = invalidation_cookie;
+
+	wait_for_completion(&peer_id->comp);
+	if (peer_id->mr == NULL)
+		return;
+
+	mr = peer_id->mr;
+	/* This function is called under client peer lock
+	 * so its resources are race protected
+	 */
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		umem->invalidation_ctx->inflight_invalidation = 1;
+		return;
+	}
+
+	umem->invalidation_ctx->peer_callback = 1;
+	mlx5_ib_invalidate_mr(&mr->ibmr);
+	complete(&mr->invalidation_comp);
+}
+#endif
+
+
+
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata)
@@ -1049,16 +1116,38 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	int ncont;
 	int order;
 	int err;
-
-	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	struct ib_peer_memory_client *ib_peer_mem;
+	struct mlx5_ib_peer_id *mlx5_ib_peer_id = NULL;
+#endif
+	mlx5_ib_dbg(dev, "%llx virt %llx len %llx access_flags %x\n",
 		    start, virt_addr, length, access_flags);
-	umem = ib_umem_get(pd->uobject->context, start, length, access_flags,
-			   0);
+	umem = ib_umem_get_flags(pd->uobject->context, start, length,
+				 access_flags, IB_UMEM_PEER_ALLOW |
+				 IB_UMEM_PEER_INVAL_SUPP);
 	if (IS_ERR(umem)) {
 		mlx5_ib_dbg(dev, "umem get failed (%ld)\n", PTR_ERR(umem));
 		return (void *)umem;
 	}
 
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	ib_peer_mem = umem->ib_peer_mem;
+	if (ib_peer_mem) {
+		mlx5_ib_peer_id = kzalloc(sizeof(*mlx5_ib_peer_id), GFP_KERNEL);
+		if (!mlx5_ib_peer_id) {
+			err = -ENOMEM;
+			goto error;
+		}
+		init_completion(&mlx5_ib_peer_id->comp);
+		err = ib_umem_activate_invalidation_notifier
+			(umem,
+			 mlx5_invalidate_umem,
+			 mlx5_ib_peer_id);
+		if (err)
+			goto error;
+	}
+#endif
+
 	mlx5_ib_cont_pages(umem, start, &npages, &page_shift, &ncont, &order);
 	if (!npages) {
 		mlx5_ib_warn(dev, "avoid zero region\n");
@@ -1098,6 +1187,15 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	atomic_add(npages, &dev->mdev->priv.reg_pages);
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	atomic_set(&mr->invalidated, 0);
+	if (ib_peer_mem) {
+		init_completion(&mr->invalidation_comp);
+		mlx5_ib_peer_id->mr = mr;
+		mr->peer_id = mlx5_ib_peer_id;
+		complete(&mlx5_ib_peer_id->comp);
+	}
+#endif
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	if (umem->odp_data) {
@@ -1127,6 +1225,12 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	return &mr->ibmr;
 
 error:
+#ifdef CONFIG_INFINIBAND_PEER_MEM
+	if (mlx5_ib_peer_id) {
+		complete(&mlx5_ib_peer_id->comp);
+		kfree(mlx5_ib_peer_id);
+	}
+#endif
 	ib_umem_release(umem);
 	return ERR_PTR(err);
 }
@@ -1245,54 +1349,44 @@ static int clean_mr(struct mlx5_ib_mr *mr)
 			mlx5_ib_warn(dev, "failed unregister\n");
 			return err;
 		}
-		free_cached_mr(dev, mr);
 	}
 
-	if (!umred)
-		kfree(mr);
-
 	return 0;
 }
 
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 {
+#ifdef CONFIG_INFINIBAND_PEER_MEM
 	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
 	struct mlx5_ib_mr *mr = to_mmr(ibmr);
-	int npages = mr->npages;
-	struct ib_umem *umem = mr->umem;
+	int ret = 0;
+	int umred = mr->umred;
 
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	if (umem && umem->odp_data) {
-		/* Prevent new page faults from succeeding */
-		mr->live = 0;
-		/* Wait for all running page-fault handlers to finish. */
-		synchronize_srcu(&dev->mr_srcu);
-		/* Destroy all page mappings */
-		mlx5_ib_invalidate_range(umem, ib_umem_start(umem),
-					 ib_umem_end(umem));
-		/*
-		 * We kill the umem before the MR for ODP,
-		 * so that there will not be any invalidations in
-		 * flight, looking at the *mr struct.
+	if (atomic_inc_return(&mr->invalidated) > 1) {
+		/* In case there is inflight invalidation
+		 * call pending for its termination
 		 */
-		ib_umem_release(umem);
-		atomic_sub(npages, &dev->mdev->priv.reg_pages);
-
-		/* Avoid double-freeing the umem. */
-		umem = NULL;
+		wait_for_completion(&mr->invalidation_comp);
+	} else {
+		ret = mlx5_ib_invalidate_mr(ibmr);
+		if (ret)
+			return ret;
 	}
-#endif
-
-	clean_mr(mr);
-
-	if (umem) {
-		ib_umem_release(umem);
-		atomic_sub(npages, &dev->mdev->priv.reg_pages);
+	kfree(mr->peer_id);
+	mr->peer_id = NULL;
+	if (umred) {
+		atomic_set(&mr->invalidated, 0);
+		free_cached_mr(dev, mr);
+	} else {
+		kfree(mr);
 	}
-
 	return 0;
+#else
+	return mlx5_ib_invalidate_mr(ibmr);
+#endif
 }
 
+
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
 			       u32 max_num_sg)
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 8fb9c27..5e07909 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -611,7 +611,8 @@ static int mlx5_ib_umem_get(struct mlx5_ib_dev *dev,
 {
 	int err;
 
-	*umem = ib_umem_get(pd->uobject->context, addr, size, 0, 0);
+	*umem = ib_umem_get_flags(pd->uobject->context, addr, size,
+				  0, IB_UMEM_PEER_ALLOW);
 	if (IS_ERR(*umem)) {
 		mlx5_ib_dbg(dev, "umem_get failed\n");
 		return PTR_ERR(*umem);
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 4659256..23b8ab4 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -115,8 +115,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
-	srq->umem = ib_umem_get(pd->uobject->context, ucmd.buf_addr, buf_size,
-				0, 0);
+	srq->umem = ib_umem_get_flags(pd->uobject->context, ucmd.buf_addr,
+				      buf_size, 0, IB_UMEM_PEER_ALLOW);
 	if (IS_ERR(srq->umem)) {
 		mlx5_ib_dbg(dev, "failed umem get, size %d\n", buf_size);
 		err = PTR_ERR(srq->umem);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
