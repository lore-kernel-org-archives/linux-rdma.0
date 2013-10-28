From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC v1 03/10] IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
Date: Mon, 28 Oct 2013 16:26:09 +0200
Message-ID: <1382970376-13776-4-git-send-email-sagig@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382970376-13776-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Support create_mr and destroy_mr verbs.
The user may request signature enable memory region attribute
where in this case the memory region shall be indirect MR
and shall be attached to with signature attributes (BSF, PSVs).
Otherwise, the create_mr routine is equivalent to alloc_fast_reg_mr.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c            |    2 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |    4 +
 drivers/infiniband/hw/mlx5/mr.c              |  109 ++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |   64 +++++++++++++++
 include/linux/mlx5/device.h                  |   25 ++++++
 include/linux/mlx5/driver.h                  |   19 +++++
 6 files changed, 223 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3f831de..2e67a37 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1401,9 +1401,11 @@ static int init_one(struct pci_dev *pdev,
 	dev->ib_dev.get_dma_mr		= mlx5_ib_get_dma_mr;
 	dev->ib_dev.reg_user_mr		= mlx5_ib_reg_user_mr;
 	dev->ib_dev.dereg_mr		= mlx5_ib_dereg_mr;
+	dev->ib_dev.destroy_mr		= mlx5_ib_destroy_mr;
 	dev->ib_dev.attach_mcast	= mlx5_ib_mcg_attach;
 	dev->ib_dev.detach_mcast	= mlx5_ib_mcg_detach;
 	dev->ib_dev.process_mad		= mlx5_ib_process_mad;
+	dev->ib_dev.create_mr		= mlx5_ib_create_mr;
 	dev->ib_dev.alloc_fast_reg_mr	= mlx5_ib_alloc_fast_reg_mr;
 	dev->ib_dev.alloc_fast_reg_page_list = mlx5_ib_alloc_fast_reg_page_list;
 	dev->ib_dev.free_fast_reg_page_list  = mlx5_ib_free_fast_reg_page_list;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 836be91..45d7424 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -262,6 +262,7 @@ struct mlx5_ib_mr {
 	int			npages;
 	struct completion	done;
 	enum ib_wc_status	status;
+	struct mlx5_core_sig_ctx    *sig;
 };
 
 struct mlx5_ib_fast_reg_page_list {
@@ -489,6 +490,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
+int mlx5_ib_destroy_mr(struct ib_mr *ibmr);
+struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
+				struct ib_mr_init_attr *mr_init_attr);
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len);
 struct ib_fast_reg_page_list *mlx5_ib_alloc_fast_reg_page_list(struct ib_device *ibdev,
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index bd41df9..44f7e46 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -921,6 +921,115 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr)
 	return 0;
 }
 
+struct ib_mr *mlx5_ib_create_mr(struct ib_pd *pd,
+				struct ib_mr_init_attr *mr_init_attr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_create_mkey_mbox_in *in;
+	struct mlx5_ib_mr *mr;
+	int access_mode, err;
+	int ndescs = roundup(mr_init_attr->max_reg_descriptors, 4);
+
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
+	in = kzalloc(sizeof(*in), GFP_KERNEL);
+	if (!in) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	in->seg.status = 1 << 6; /* free */
+	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
+	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
+	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
+	access_mode = MLX5_ACCESS_MODE_MTT;
+
+	if (mr_init_attr->flags & IB_MR_SIGNATURE_EN) {
+		u32 psv_index[2];
+
+		in->seg.flags_pd = cpu_to_be32(be32_to_cpu(in->seg.flags_pd) |
+							   MLX5_MKEY_BSF_EN);
+		in->seg.bsfs_octo_size = cpu_to_be32(MLX5_MKEY_BSF_OCTO_SIZE);
+		mr->sig = kzalloc(sizeof(*mr->sig), GFP_KERNEL);
+		if (!mr->sig) {
+			err = -ENOMEM;
+			goto err_free;
+		}
+
+		/* create mem & wire PSVs */
+		err = mlx5_core_create_psv(&dev->mdev, to_mpd(pd)->pdn,
+					   2, psv_index);
+		if (err)
+			goto err_free_sig;
+
+		access_mode = MLX5_ACCESS_MODE_KLM;
+		mr->sig->psv_memory.psv_idx = psv_index[0];
+		mr->sig->psv_wire.psv_idx = psv_index[1];
+	}
+
+	in->seg.flags = MLX5_PERM_UMR_EN | access_mode;
+	err = mlx5_core_create_mkey(&dev->mdev, &mr->mmr, in, sizeof(*in));
+	kfree(in);
+	if (err)
+		goto err_destroy_psv;
+
+	mr->ibmr.lkey = mr->mmr.key;
+	mr->ibmr.rkey = mr->mmr.key;
+	mr->umem = NULL;
+
+	return &mr->ibmr;
+
+err_destroy_psv:
+	if (mr->sig) {
+		if (mlx5_core_destroy_psv(&dev->mdev,
+					  mr->sig->psv_memory.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
+				     mr->sig->psv_memory.psv_idx);
+		if (mlx5_core_destroy_psv(&dev->mdev,
+					  mr->sig->psv_wire.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
+				     mr->sig->psv_wire.psv_idx);
+	}
+err_free_sig:
+	if (mr->sig)
+		kfree(mr->sig);
+err_free:
+	kfree(mr);
+	return ERR_PTR(err);
+}
+
+int mlx5_ib_destroy_mr(struct ib_mr *ibmr)
+{
+	struct mlx5_ib_dev *dev = to_mdev(ibmr->device);
+	struct mlx5_ib_mr *mr = to_mmr(ibmr);
+	int err;
+
+	if (mr->sig) {
+		if (mlx5_core_destroy_psv(&dev->mdev,
+					  mr->sig->psv_memory.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy mem psv %d\n",
+				     mr->sig->psv_memory.psv_idx);
+		if (mlx5_core_destroy_psv(&dev->mdev,
+					  mr->sig->psv_wire.psv_idx))
+			mlx5_ib_warn(dev, "failed to destroy wire psv %d\n",
+				     mr->sig->psv_wire.psv_idx);
+		kfree(mr->sig);
+	}
+
+	err = mlx5_core_destroy_mkey(&dev->mdev, &mr->mmr);
+	if (err) {
+		mlx5_ib_warn(dev, "failed to destroy mkey 0x%x (%d)\n",
+			     mr->mmr.key, err);
+		return err;
+	}
+
+	kfree(mr);
+
+	return err;
+}
+
 struct ib_mr *mlx5_ib_alloc_fast_reg_mr(struct ib_pd *pd,
 					int max_page_list_len)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 5b44e2e..2ade604 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -134,3 +134,67 @@ int mlx5_core_dump_fill_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 	return err;
 }
 EXPORT_SYMBOL(mlx5_core_dump_fill_mkey);
+
+int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
+			 int npsvs, u32 *sig_index)
+{
+	struct mlx5_allocate_psv_in in;
+	struct mlx5_allocate_psv_out out;
+	int i, err;
+
+	if (npsvs > MLX5_MAX_PSVS) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+
+	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_CREATE_PSV);
+	in.npsv_pd = cpu_to_be32((npsvs << 28) | pdn);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		mlx5_core_err(dev, "cmd exec failed %d\n", err);
+		return err;
+	}
+
+	if (out.hdr.status) {
+		mlx5_core_err(dev, "create_psv bad status %d\n", out.hdr.status);
+		return mlx5_cmd_status_to_err(&out.hdr);
+	}
+
+	for (i = 0; i < npsvs; i++)
+		sig_index[i] = be32_to_cpu(out.psv_idx[i]) & 0xffffff;
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(mlx5_core_create_psv);
+
+int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num)
+{
+	struct mlx5_destroy_psv_in in;
+	struct mlx5_destroy_psv_out out;
+	int err;
+
+	memset(&in, 0, sizeof(in));
+	memset(&out, 0, sizeof(out));
+
+	in.psv_number = cpu_to_be32(psv_num);
+	in.hdr.opcode = cpu_to_be16(MLX5_CMD_OP_DESTROY_PSV);
+	err = mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
+	if (err) {
+		mlx5_core_err(dev, "destroy_psv cmd exec failed %d\n", err);
+		goto out;
+	}
+
+	if (out.hdr.status) {
+		mlx5_core_err(dev, "destroy_psv bad status %d\n", out.hdr.status);
+		err = mlx5_cmd_status_to_err(&out.hdr);
+		goto out;
+	}
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(mlx5_core_destroy_psv);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 68029b3..aef7eed 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -48,6 +48,8 @@ enum {
 	MLX5_MAX_COMMANDS		= 32,
 	MLX5_CMD_DATA_BLOCK_SIZE	= 512,
 	MLX5_PCI_CMD_XPORT		= 7,
+	MLX5_MKEY_BSF_OCTO_SIZE		= 4,
+	MLX5_MAX_PSVS			= 4,
 };
 
 enum {
@@ -908,4 +910,27 @@ enum {
 	MLX_EXT_PORT_CAP_FLAG_EXTENDED_PORT_INFO	= 1 <<  0
 };
 
+struct mlx5_allocate_psv_in {
+	struct mlx5_inbox_hdr   hdr;
+	__be32			npsv_pd;
+	__be32			rsvd_psv0;
+};
+
+struct mlx5_allocate_psv_out {
+	struct mlx5_outbox_hdr  hdr;
+	u8			rsvd[8];
+	__be32			psv_idx[4];
+};
+
+struct mlx5_destroy_psv_in {
+	struct mlx5_inbox_hdr	hdr;
+	__be32                  psv_number;
+	u8                      rsvd[4];
+};
+
+struct mlx5_destroy_psv_out {
+	struct mlx5_outbox_hdr  hdr;
+	u8                      rsvd[8];
+};
+
 #endif /* MLX5_DEVICE_H */
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 8888381..7c33487 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -398,6 +398,22 @@ struct mlx5_eq {
 	struct mlx5_rsc_debug	*dbg;
 };
 
+struct mlx5_core_psv {
+	u32	psv_idx;
+	struct psv_layout {
+		u32	pd;
+		u16	syndrome;
+		u16	reserved;
+		u16	bg;
+		u16	app_tag;
+		u32	ref_tag;
+	} psv;
+};
+
+struct mlx5_core_sig_ctx {
+	struct mlx5_core_psv	psv_memory;
+	struct mlx5_core_psv	psv_wire;
+};
 
 struct mlx5_core_mr {
 	u64			iova;
@@ -734,6 +750,9 @@ void mlx5_db_free(struct mlx5_core_dev *dev, struct mlx5_db *db);
 const char *mlx5_command_str(int command);
 int mlx5_cmdif_debugfs_init(struct mlx5_core_dev *dev);
 void mlx5_cmdif_debugfs_cleanup(struct mlx5_core_dev *dev);
+int mlx5_core_create_psv(struct mlx5_core_dev *dev, u32 pdn,
+			 int npsvs, u32 *sig_index);
+int mlx5_core_destroy_psv(struct mlx5_core_dev *dev, int psv_num);
 
 static inline u32 mlx5_mkey_to_idx(u32 mkey)
 {
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
