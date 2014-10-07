From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 2/2] IB/mlx5: Implement Fast Indirect Memory Registration Feature
Date: Tue,  7 Oct 2014 17:48:01 +0300
Message-ID: <1412693281-6161-3-git-send-email-sagig@mellanox.com>
References: <1412693281-6161-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412693281-6161-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: bvanassche-HInyCGIudOg@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch implements:
- ib_alloc/free_indir_reg_list() routines
- ib_create_mr() extension for IB_MR_INDIRECT_REG
- ib_post_send() extension for IB_WR_REG_INDIR_MR
  and work completion of IB_WC_REG_INDIR_MR
- Expose mlx5 indirect registration device capabilities

* Nit change in mr_align() static routine to handle void*
instead of __be64.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/cq.c      |    2 +
 drivers/infiniband/hw/mlx5/main.c    |    4 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   20 +++++++
 drivers/infiniband/hw/mlx5/mr.c      |   70 ++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/qp.c      |  104 ++++++++++++++++++++++++++++++++++
 5 files changed, 198 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index e405627..7ca730c 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -111,6 +111,8 @@ static enum ib_wc_opcode get_umr_comp(struct mlx5_ib_wq *wq, int idx)
 	case IB_WR_FAST_REG_MR:
 		return IB_WC_FAST_REG_MR;
 
+	case IB_WR_REG_INDIR_MR:
+		return IB_WC_REG_INDIR_MR;
 	default:
 		pr_warn("unknown completion status\n");
 		return 0;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d8907b2..d834b77 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -194,6 +194,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	if (flags & MLX5_DEV_CAP_FLAG_XRC)
 		props->device_cap_flags |= IB_DEVICE_XRC;
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
+	props->device_cap_flags |= IB_DEVICE_INDIR_REGISTRATION;
 	if (flags & MLX5_DEV_CAP_FLAG_SIG_HAND_OVER) {
 		props->device_cap_flags |= IB_DEVICE_SIGNATURE_HANDOVER;
 		/* At this stage no support for signature handover */
@@ -231,6 +232,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_srq_wr	   = dev->mdev->caps.max_srq_wqes - 1;
 	props->max_srq_sge	   = max_rq_sg - 1;
 	props->max_fast_reg_page_list_len = (unsigned int)-1;
+	props->max_indir_reg_mr_list_len = (unsigned int)-1;
 	props->local_ca_ack_delay  = dev->mdev->caps.local_ca_ack_delay;
 	props->atomic_cap	   = IB_ATOMIC_NONE;
 	props->masked_atomic_cap   = IB_ATOMIC_NONE;
@@ -1354,6 +1356,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
+	dev->ib_dev.alloc_indir_reg_list = mlx5_ib_alloc_indir_reg_list;
+	dev->ib_dev.free_indir_reg_list  = mlx5_ib_free_indir_reg_list;
 
 	if (mdev->caps.flags & MLX5_DEV_CAP_FLAG_XRC) {
 		dev->ib_dev.alloc_xrcd = mlx5_ib_alloc_xrcd;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 386780f..3b6ed0f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -275,6 +275,13 @@ struct mlx5_ib_fast_reg_page_list {
 	dma_addr_t			map;
 };
 
+struct mlx5_ib_indir_reg_list {
+	struct ib_indir_reg_list        ib_irl;
+	void                           *mapped_ilist;
+	struct mlx5_klm                *klms;
+	dma_addr_t                      map;
+};
+
 struct mlx5_ib_umr_context {
 	enum ib_wc_status	status;
 	struct completion	done;
@@ -444,6 +451,12 @@ static inline struct mlx5_ib_fast_reg_page_list *to_mfrpl(struct ib_fast_reg_pag
 	return container_of(ibfrpl, struct mlx5_ib_fast_reg_page_list, ibfrpl);
 }
 
+static inline struct mlx5_ib_indir_reg_list *
+to_mindir_list(struct ib_indir_reg_list *ib_irl)
+{
+	return container_of(ib_irl, struct mlx5_ib_indir_reg_list, ib_irl);
+}
+
 struct mlx5_ib_ah {
 	struct ib_ah		ibah;
 	struct mlx5_av		av;
@@ -511,6 +524,13 @@ struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
 							       int page_list_len);
 void mlx5_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
+
+struct ib_indir_reg_list *
+mlx5_ib_alloc_indir_reg_list(struct ib_device *device,
+			     unsigned int max_indir_list_len);
+void mlx5_ib_free_indir_reg_list(struct ib_device *device,
+				 struct ib_indir_reg_list *indir_list);
+
 struct ib_fmr *mlx5_ib_fmr_alloc(struct ib_pd *pd, int acc,
 				 struct ib_fmr_attr *fmr_attr);
 int mlx5_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 80b3c63..6fb7cc3 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -47,11 +47,11 @@ enum {
 	MLX5_UMR_ALIGN	= 2048
 };
 
-static __be64 *mr_align(__be64 *ptr, int align)
+static void *mr_align(void *ptr, int align)
 {
 	unsigned long mask = align - 1;
 
-	return (__be64 *)(((unsigned long)ptr + mask) & ~mask);
+	return (void *)(((unsigned long)ptr + mask) & ~mask);
 }
 
 static int order2idx(struct mlx5_ib_dev *dev, int order)
@@ -1059,6 +1059,9 @@ struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
 		++mr->sig->sigerr_count;
 	}
 
+	if (mr_init_attr->flags & IB_MR_INDIRECT_REG)
+		access_mode = MLX5_ACCESS_MODE_KLM;
+
 	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
 	err = mlx5_core_create_mkey(dev->mdev, &mr->mmr, in, sizeof(*in),
 				    NULL, NULL, NULL);
@@ -1248,3 +1251,66 @@ int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 done:
 	return ret;
 }
+
+struct ib_indir_reg_list *
+mlx5_ib_alloc_indir_reg_list(struct ib_device *device,
+			     unsigned int max_indir_list_len)
+{
+	struct device *ddev = device->dma_device;
+	struct mlx5_ib_indir_reg_list *mirl = NULL;
+	int dsize;
+	int err;
+
+	mirl = kzalloc(sizeof(*mirl), GFP_KERNEL);
+	if (!mirl)
+		return ERR_PTR(-ENOMEM);
+
+	mirl->ib_irl.sg_list = kcalloc(max_indir_list_len,
+				       sizeof(*mirl->ib_irl.sg_list),
+				       GFP_KERNEL);
+	if (!mirl->ib_irl.sg_list) {
+		err = -ENOMEM;
+		goto err_sg_list;
+	}
+
+	dsize = sizeof(*mirl->klms) * max_indir_list_len;
+	mirl->mapped_ilist = kzalloc(dsize + MLX5_UMR_ALIGN - 1,
+				      GFP_KERNEL);
+	if (!mirl->mapped_ilist) {
+		err = -ENOMEM;
+		goto err_mapped_list;
+	}
+
+	mirl->klms = mr_align(mirl->mapped_ilist, MLX5_UMR_ALIGN);
+	mirl->map = dma_map_single(ddev, mirl->klms,
+				   dsize, DMA_TO_DEVICE);
+	if (dma_mapping_error(ddev, mirl->map)) {
+		err = -ENOMEM;
+		goto err_dma_map;
+	}
+
+	return &mirl->ib_irl;
+err_dma_map:
+	kfree(mirl->mapped_ilist);
+err_mapped_list:
+	kfree(mirl->ib_irl.sg_list);
+err_sg_list:
+	kfree(mirl);
+
+	return ERR_PTR(err);
+}
+
+void
+mlx5_ib_free_indir_reg_list(struct ib_device *device,
+			    struct ib_indir_reg_list *indir_list)
+{
+	struct mlx5_ib_indir_reg_list *mirl = to_mindir_list(indir_list);
+	struct device *ddev = device->dma_device;
+	int dsize;
+
+	dsize = sizeof(*mirl->klms) * indir_list->max_indir_list_len;
+	dma_unmap_single(ddev, mirl->map, dsize, DMA_TO_DEVICE);
+	kfree(mirl->mapped_ilist);
+	kfree(mirl->ib_irl.sg_list);
+	kfree(mirl);
+}
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index d7f35e9..a9c74e6 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -65,6 +65,7 @@ static const u32 mlx5_ib_opcode[] = {
 	[IB_WR_SEND_WITH_INV]			= MLX5_OPCODE_SEND_INVAL,
 	[IB_WR_LOCAL_INV]			= MLX5_OPCODE_UMR,
 	[IB_WR_FAST_REG_MR]			= MLX5_OPCODE_UMR,
+	[IB_WR_REG_INDIR_MR]			= MLX5_OPCODE_UMR,
 	[IB_WR_MASKED_ATOMIC_CMP_AND_SWP]	= MLX5_OPCODE_ATOMIC_MASKED_CS,
 	[IB_WR_MASKED_ATOMIC_FETCH_AND_ADD]	= MLX5_OPCODE_ATOMIC_MASKED_FA,
 	[MLX5_IB_WR_UMR]			= MLX5_OPCODE_UMR,
@@ -2346,6 +2347,96 @@ static int set_frwr_li_wr(void **seg, struct ib_send_wr *wr, int *size,
 	return 0;
 }
 
+static void set_indir_mkey_segment(struct mlx5_mkey_seg *seg,
+				   struct ib_send_wr *wr, u32 pdn)
+{
+	u32 list_len = wr->wr.indir_reg.indir_list_len;
+
+	memset(seg, 0, sizeof(*seg));
+
+	seg->flags = get_umr_flags(wr->wr.indir_reg.access_flags) |
+				   MLX5_ACCESS_MODE_KLM;
+	seg->qpn_mkey7_0 = cpu_to_be32(0xffffff00 |
+			   mlx5_mkey_variant(wr->wr.indir_reg.mkey));
+	seg->flags_pd = cpu_to_be32(MLX5_MKEY_REMOTE_INVAL | pdn);
+	seg->len = cpu_to_be64(wr->wr.indir_reg.length);
+	seg->start_addr = cpu_to_be64(wr->wr.indir_reg.iova_start);
+	seg->xlt_oct_size = cpu_to_be32(be16_to_cpu(get_klm_octo(list_len * 2)));
+}
+
+static void set_indir_data_seg(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
+			       u32 pa_key, void **seg, int *size)
+{
+	struct mlx5_wqe_data_seg *data = *seg;
+	struct mlx5_ib_indir_reg_list *mirl;
+	struct ib_sge *sg_list = wr->wr.indir_reg.indir_list->sg_list;
+	u32 list_len = wr->wr.indir_reg.indir_list_len;
+	int i;
+
+	mirl = to_mindir_list(wr->wr.indir_reg.indir_list);
+	for (i = 0; i < list_len; i++) {
+		mirl->klms[i].va = cpu_to_be64(sg_list[i].addr);
+		mirl->klms[i].key = cpu_to_be32(sg_list[i].lkey);
+		mirl->klms[i].bcount = cpu_to_be32(sg_list[i].length);
+	}
+
+	data->byte_count = cpu_to_be32(ALIGN(sizeof(struct mlx5_klm) *
+				       list_len, 64));
+	data->lkey = cpu_to_be32(pa_key);
+	data->addr = cpu_to_be64(mirl->map);
+	*seg += sizeof(*data);
+	*size += sizeof(*data) / 16;
+}
+
+static void set_indir_umr_segment(struct mlx5_wqe_umr_ctrl_seg *umr,
+				  struct ib_send_wr *wr)
+{
+	u64 mask;
+	u32 list_len = wr->wr.indir_reg.indir_list_len;
+
+	memset(umr, 0, sizeof(*umr));
+
+	umr->klm_octowords = get_klm_octo(list_len * 2);
+	mask = MLX5_MKEY_MASK_LEN		|
+		MLX5_MKEY_MASK_PAGE_SIZE	|
+		MLX5_MKEY_MASK_START_ADDR	|
+		MLX5_MKEY_MASK_EN_RINVAL	|
+		MLX5_MKEY_MASK_KEY		|
+		MLX5_MKEY_MASK_LR		|
+		MLX5_MKEY_MASK_LW		|
+		MLX5_MKEY_MASK_RR		|
+		MLX5_MKEY_MASK_RW		|
+		MLX5_MKEY_MASK_A		|
+		MLX5_MKEY_MASK_FREE;
+
+	umr->mkey_mask = cpu_to_be64(mask);
+}
+
+static int set_indir_reg_wr(struct ib_send_wr *wr, struct mlx5_ib_qp *qp,
+			    void **seg, int *size)
+{
+	struct mlx5_ib_pd *pd = get_pd(qp);
+
+	if (unlikely(wr->send_flags & IB_SEND_INLINE))
+		return -EINVAL;
+
+	set_indir_umr_segment(*seg, wr);
+	*seg += sizeof(struct mlx5_wqe_umr_ctrl_seg);
+	*size += sizeof(struct mlx5_wqe_umr_ctrl_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	set_indir_mkey_segment(*seg, wr, pd->pdn);
+	*seg += sizeof(struct mlx5_mkey_seg);
+	*size += sizeof(struct mlx5_mkey_seg) / 16;
+	if (unlikely((*seg == qp->sq.qend)))
+		*seg = mlx5_get_send_wqe(qp, 0);
+
+	set_indir_data_seg(wr, qp, pd->pa_lkey, seg, size);
+
+	return 0;
+}
+
 static void dump_wqe(struct mlx5_ib_qp *qp, int idx, int size_16)
 {
 	__be32 *p = NULL;
@@ -2557,6 +2648,19 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 				num_sge = 0;
 				break;
 
+			case IB_WR_REG_INDIR_MR:
+				next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
+				qp->sq.wr_data[idx] = IB_WR_REG_INDIR_MR;
+				ctrl->imm = cpu_to_be32(wr->wr.indir_reg.mkey);
+				err = set_indir_reg_wr(wr, qp, &seg, &size);
+				if (err) {
+					mlx5_ib_warn(dev, "\n");
+					*bad_wr = wr;
+					goto out;
+				}
+				num_sge = 0;
+				break;
+
 			case IB_WR_REG_SIG_MR:
 				qp->sq.wr_data[idx] = IB_WR_REG_SIG_MR;
 				mr = to_mmr(wr->wr.sig_handover.sig_mr);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
