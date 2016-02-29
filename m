From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/2] IB/mlx5: Added support for re-registration of MRs
Date: Mon, 29 Feb 2016 16:46:51 +0200
Message-ID: <1456757211-8112-3-git-send-email-matanb@mellanox.com>
References: <1456757211-8112-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456757211-8112-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch adds support for re-registration of memory regions in MLX5.
The functionality is basically the same as deregister followed by
register, but attempts to reuse the existing resources as much as
possible.
Original memory keys are kept if possible, saving the need to
communicate new ones to remote peers.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    |   2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   9 ++
 drivers/infiniband/hw/mlx5/mr.c      | 168 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/qp.c      |  51 ++++++++++-
 4 files changed, 227 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 03c418ccbc98..6da3f0d1d1f8 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2198,6 +2198,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 		(1ull << IB_USER_VERBS_CMD_ALLOC_PD)		|
 		(1ull << IB_USER_VERBS_CMD_DEALLOC_PD)		|
 		(1ull << IB_USER_VERBS_CMD_REG_MR)		|
+		(1ull << IB_USER_VERBS_CMD_REREG_MR)		|
 		(1ull << IB_USER_VERBS_CMD_DEREG_MR)		|
 		(1ull << IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL)	|
 		(1ull << IB_USER_VERBS_CMD_CREATE_CQ)		|
@@ -2258,6 +2259,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.req_notify_cq	= mlx5_ib_arm_cq;
 	dev->ib_dev.get_dma_mr		= mlx5_ib_get_dma_mr;
 	dev->ib_dev.reg_user_mr		= mlx5_ib_reg_user_mr;
+	dev->ib_dev.rereg_user_mr	= mlx5_ib_rereg_user_mr;
 	dev->ib_dev.dereg_mr		= mlx5_ib_dereg_mr;
 	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d2b9737baa36..15be0c44c4c5 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -162,6 +162,11 @@ struct mlx5_ib_flow_db {
 #define MLX5_IB_SEND_UMR_UNREG	IB_SEND_RESERVED_START
 #define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_RESERVED_START << 1)
 #define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
+
+#define MLX5_IB_SEND_UMR_UPDATE_TRANSLATION	(IB_SEND_RESERVED_START << 3)
+#define MLX5_IB_SEND_UMR_UPDATE_PD		(IB_SEND_RESERVED_START << 4)
+#define MLX5_IB_SEND_UMR_UPDATE_ACCESS		IB_SEND_RESERVED_END
+
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
 #define MLX5_IB_WR_UMR		IB_WR_RESERVED1
 
@@ -425,6 +430,7 @@ struct mlx5_ib_mr {
 	struct mlx5_core_sig_ctx    *sig;
 	int			live;
 	void			*descs_alloc;
+	int			access_flags; /* Needed for rereg MR */
 };
 
 struct mlx5_ib_umr_context {
@@ -650,6 +656,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  struct ib_udata *udata);
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
 		       int npages, int zap);
+int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
+			  u64 length, u64 virt_addr, int access_flags,
+			  struct ib_pd *pd, struct ib_udata *udata);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
 struct ib_mr *mlx5_ib_alloc_mr(struct ib_pd *pd,
 			       enum ib_mr_type mr_type,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 9d6dade31b5f..cf26cd1f1fa2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -77,6 +77,12 @@ static int order2idx(struct mlx5_ib_dev *dev, int order)
 		return order - cache->ent[0].order;
 }
 
+static bool use_umr_mtt_update(struct mlx5_ib_mr *mr, u64 start, u64 length)
+{
+	return ((u64)1 << mr->order) * MLX5_ADAPTER_PAGE_SIZE >=
+		length + (start & (MLX5_ADAPTER_PAGE_SIZE - 1));
+}
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 static void update_odp_mr(struct mlx5_ib_mr *mr)
 {
@@ -1127,6 +1133,7 @@ static void set_mr_fileds(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	mr->ibmr.lkey = mr->mmr.key;
 	mr->ibmr.rkey = mr->mmr.key;
 	mr->ibmr.length = length;
+	mr->access_flags = access_flags;
 }
 
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
@@ -1222,6 +1229,167 @@ error:
 	return err;
 }
 
+static int rereg_umr(struct ib_pd *pd, struct mlx5_ib_mr *mr, u64 virt_addr,
+		     u64 length, int npages, int page_shift, int order,
+		     int access_flags, int flags)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct device *ddev = dev->ib_dev.dma_device;
+	struct mlx5_ib_umr_context umr_context;
+	struct ib_send_wr *bad;
+	struct mlx5_umr_wr umrwr = {};
+	struct ib_sge sg;
+	struct umr_common *umrc = &dev->umrc;
+	dma_addr_t dma = 0;
+	__be64 *mr_pas = NULL;
+	int size;
+	int err;
+
+	umrwr.wr.wr_id = (u64)(unsigned long)&umr_context;
+	umrwr.wr.send_flags = MLX5_IB_SEND_UMR_FAIL_IF_FREE;
+
+	if (flags & IB_MR_REREG_TRANS) {
+		err = dma_map_mr_pas(dev, mr->umem, npages, page_shift, &size,
+				     &mr_pas, &dma);
+		if (err)
+			return err;
+
+		umrwr.target.virt_addr = virt_addr;
+		umrwr.length = length;
+		umrwr.wr.send_flags |= MLX5_IB_SEND_UMR_UPDATE_TRANSLATION;
+	}
+
+	prep_umr_wqe_common(pd, &umrwr.wr, &sg, dma, npages, mr->mmr.key,
+			    page_shift);
+
+	if (flags & IB_MR_REREG_PD) {
+		umrwr.pd = pd;
+		umrwr.wr.send_flags |= MLX5_IB_SEND_UMR_UPDATE_PD;
+	}
+
+	if (flags & IB_MR_REREG_ACCESS) {
+		umrwr.access_flags = access_flags;
+		umrwr.wr.send_flags |= MLX5_IB_SEND_UMR_UPDATE_ACCESS;
+	}
+
+	mlx5_ib_init_umr_context(&umr_context);
+
+	/* post send request to UMR QP */
+	down(&umrc->sem);
+	err = ib_post_send(umrc->qp, &umrwr.wr, &bad);
+
+	if (err) {
+		mlx5_ib_warn(dev, "post send failed, err %d\n", err);
+	} else {
+		wait_for_completion(&umr_context.done);
+		if (umr_context.status != IB_WC_SUCCESS) {
+			mlx5_ib_warn(dev, "reg umr failed (%u)\n",
+				     umr_context.status);
+			err = -EFAULT;
+		}
+	}
+
+	up(&umrc->sem);
+	if (flags & IB_MR_REREG_TRANS) {
+		dma_unmap_single(ddev, dma, size, DMA_TO_DEVICE);
+		kfree(mr_pas);
+	}
+	return err;
+}
+
+int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
+			  u64 length, u64 virt_addr, int new_access_flags,
+			  struct ib_pd *new_pd, struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ib_mr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ib_mr);
+	struct ib_pd *pd = (flags & IB_MR_REREG_PD) ? new_pd : ib_mr->pd;
+	int access_flags = flags & IB_MR_REREG_ACCESS ?
+			    new_access_flags :
+			    mr->access_flags;
+	u64 addr = (flags & IB_MR_REREG_TRANS) ? virt_addr : mr->umem->address;
+	u64 len = (flags & IB_MR_REREG_TRANS) ? length : mr->umem->length;
+	int page_shift = 0;
+	int npages = 0;
+	int ncont = 0;
+	int order = 0;
+	int err;
+
+	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
+		    start, virt_addr, length, access_flags);
+
+	if (flags != IB_MR_REREG_PD) {
+		/*
+		 * Replace umem. This needs to be done whether or not UMR is
+		 * used.
+		 */
+		flags |= IB_MR_REREG_TRANS;
+		ib_umem_release(mr->umem);
+		mr->umem = mr_umem_get(pd, addr, len, access_flags, &npages,
+				       &page_shift, &ncont, &order);
+		if (IS_ERR(mr->umem)) {
+			err = PTR_ERR(mr->umem);
+			mr->umem = NULL;
+			return err;
+		}
+	}
+
+	if (flags & IB_MR_REREG_TRANS && !use_umr_mtt_update(mr, addr, len)) {
+		/*
+		 * UMR can't be used - MKey needs to be replaced.
+		 */
+		if (mr->umred) {
+			err = unreg_umr(dev, mr);
+			if (err)
+				mlx5_ib_warn(dev, "Failed to unregister MR\n");
+		} else {
+			err = destroy_mkey(dev, mr);
+			if (err)
+				mlx5_ib_warn(dev, "Failed to destroy MKey\n");
+		}
+		if (err)
+			return err;
+
+		mr = reg_create(ib_mr, pd, addr, len, mr->umem, ncont,
+				page_shift, access_flags);
+
+		if (IS_ERR(mr))
+			return PTR_ERR(mr);
+
+		mr->umred = 0;
+	} else {
+		/*
+		 * Send a UMR WQE
+		 */
+		err = rereg_umr(pd, mr, addr, len, npages, page_shift,
+				order, access_flags, flags);
+		if (err) {
+			mlx5_ib_warn(dev, "Failed to rereg UMR\n");
+			return err;
+		}
+	}
+
+	if (flags & IB_MR_REREG_PD) {
+		ib_mr->pd = pd;
+		mr->mmr.pd = to_mpd(pd)->pdn;
+	}
+
+	if (flags & IB_MR_REREG_ACCESS)
+		mr->access_flags = access_flags;
+
+	if (flags & IB_MR_REREG_TRANS) {
+		atomic_sub(mr->npages, &dev->mdev->priv.reg_pages);
+		set_mr_fileds(dev, mr, npages, len, access_flags);
+		mr->mmr.iova = addr;
+		mr->mmr.size = len;
+	}
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
+	update_odp_mr(mr);
+#endif
+
+	return 0;
+}
+
 static int
 mlx5_alloc_priv_descs(struct ib_device *device,
 		      struct mlx5_ib_mr *mr,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 34cb8e87c7b8..af0c2febcf4b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2558,6 +2558,44 @@ static __be64 get_umr_update_mtt_mask(void)
 	return cpu_to_be64(result);
 }
 
+static __be64 get_umr_update_translation_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_LEN |
+		 MLX5_MKEY_MASK_PAGE_SIZE |
+		 MLX5_MKEY_MASK_START_ADDR |
+		 MLX5_MKEY_MASK_KEY |
+		 MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
+static __be64 get_umr_update_access_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_LW |
+		 MLX5_MKEY_MASK_RR |
+		 MLX5_MKEY_MASK_RW |
+		 MLX5_MKEY_MASK_A |
+		 MLX5_MKEY_MASK_KEY |
+		 MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
+static __be64 get_umr_update_pd_mask(void)
+{
+	u64 result;
+
+	result = MLX5_MKEY_MASK_PD |
+		 MLX5_MKEY_MASK_KEY |
+		 MLX5_MKEY_MASK_FREE;
+
+	return cpu_to_be64(result);
+}
+
 static void set_reg_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 				struct ib_send_wr *wr)
 {
@@ -2576,9 +2614,15 @@ static void set_reg_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
 			umr->mkey_mask = get_umr_update_mtt_mask();
 			umr->bsf_octowords = get_klm_octo(umrwr->target.offset);
 			umr->flags |= MLX5_UMR_TRANSLATION_OFFSET_EN;
-		} else {
-			umr->mkey_mask = get_umr_reg_mr_mask();
 		}
+		if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_TRANSLATION)
+			umr->mkey_mask |= get_umr_update_translation_mask();
+		if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_ACCESS)
+			umr->mkey_mask |= get_umr_update_access_mask();
+		if (wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_PD)
+			umr->mkey_mask |= get_umr_update_pd_mask();
+		if (!umr->mkey_mask)
+			umr->mkey_mask = get_umr_reg_mr_mask();
 	} else {
 		umr->mkey_mask = get_umr_unreg_mr_mask();
 	}
@@ -2630,7 +2674,8 @@ static void set_reg_mkey_segment(struct mlx5_mkey_seg *seg, struct ib_send_wr *w
 
 	seg->flags = convert_access(umrwr->access_flags);
 	if (!(wr->send_flags & MLX5_IB_SEND_UMR_UPDATE_MTT)) {
-		seg->flags_pd = cpu_to_be32(to_mpd(umrwr->pd)->pdn);
+		if (umrwr->pd)
+			seg->flags_pd = cpu_to_be32(to_mpd(umrwr->pd)->pdn);
 		seg->start_addr = cpu_to_be64(umrwr->target.virt_addr);
 	}
 	seg->len = cpu_to_be64(umrwr->length);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
