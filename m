From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 3/3] IB/mlx5: Add memory windows allocation support
Date: Mon, 29 Feb 2016 18:05:30 +0200
Message-ID: <1456761930-11222-4-git-send-email-matanb@mellanox.com>
References: <1456761930-11222-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456761930-11222-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds user-space support for memory windows allocation and
deallocation. It also exposes the supported types via
query_device_caps verb.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 13 ++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 ++++++
 drivers/infiniband/hw/mlx5/mr.c      | 83 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h    |  7 +++
 include/linux/mlx5/mlx5_ifc.h        |  4 +-
 5 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 03c418c..bccd118 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -487,6 +487,11 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		props->device_cap_flags |= IB_DEVICE_AUTO_PATH_MIG;
 	if (MLX5_CAP_GEN(mdev, xrc))
 		props->device_cap_flags |= IB_DEVICE_XRC;
+	if (MLX5_CAP_GEN(mdev, imaicl)) {
+		props->device_cap_flags |= IB_DEVICE_MEM_WINDOW |
+					   IB_DEVICE_MEM_WINDOW_TYPE_2B;
+		props->max_mw = 1 << MLX5_CAP_GEN(mdev, log_max_mkey);
+	}
 	props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	if (MLX5_CAP_GEN(mdev, sho)) {
 		props->device_cap_flags |= IB_DEVICE_SIGNATURE_HANDOVER;
@@ -2269,6 +2274,14 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	mlx5_ib_internal_fill_odp_caps(dev);
 
+	if (MLX5_CAP_GEN(mdev, imaicl)) {
+		dev->ib_dev.alloc_mw		= mlx5_ib_alloc_mw;
+		dev->ib_dev.dealloc_mw		= mlx5_ib_dealloc_mw;
+		dev->ib_dev.uverbs_cmd_mask |=
+			(1ull << IB_USER_VERBS_CMD_ALLOC_MW)	|
+			(1ull << IB_USER_VERBS_CMD_DEALLOC_MW);
+	}
+
 	if (MLX5_CAP_GEN(mdev, xrc)) {
 		dev->ib_dev.alloc_xrcd = mlx5_ib_alloc_xrcd;
 		dev->ib_dev.dealloc_xrcd = mlx5_ib_dealloc_xrcd;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index b1cad93..cfd006d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -43,6 +43,7 @@
 #include <linux/mlx5/srq.h>
 #include <linux/types.h>
 #include <linux/mlx5/transobj.h>
+#include <rdma/ib_user_verbs.h>
 
 #define mlx5_ib_dbg(dev, format, arg...)				\
 pr_debug("%s:%s:%d:(pid %d): " format, (dev)->ib_dev.name, __func__,	\
@@ -427,6 +428,11 @@ struct mlx5_ib_mr {
 	void			*descs_alloc;
 };
 
+struct mlx5_ib_mw {
+	struct ib_mw		ibmw;
+	struct mlx5_core_mkey	mmkey;
+};
+
 struct mlx5_ib_umr_context {
 	enum ib_wc_status	status;
 	struct completion	done;
@@ -588,6 +594,11 @@ static inline struct mlx5_ib_mr *to_mmr(struct ib_mr *ibmr)
 	return container_of(ibmr, struct mlx5_ib_mr, ibmr);
 }
 
+static inline struct mlx5_ib_mw *to_mmw(struct ib_mw *ibmw)
+{
+	return container_of(ibmw, struct mlx5_ib_mw, ibmw);
+}
+
 struct mlx5_ib_ah {
 	struct ib_ah		ibah;
 	struct mlx5_av		av;
@@ -648,6 +659,9 @@ struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc);
 struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 				  u64 virt_addr, int access_flags,
 				  struct ib_udata *udata);
+struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			       struct ib_udata *udata);
+int mlx5_ib_dealloc_mw(struct ib_mw *mw);
 int mlx5_ib_update_mtt(struct mlx5_ib_mr *mr, u64 start_page_index,
 		       int npages, int zap);
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index fbcccc8..4ffb22b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -40,6 +40,7 @@
 #include <rdma/ib_umem_odp.h>
 #include <rdma/ib_verbs.h>
 #include "mlx5_ib.h"
+#include "user.h"
 
 enum {
 	MAX_PENDING_REG_MR = 8,
@@ -1395,6 +1396,88 @@ err_free:
 	return ERR_PTR(err);
 }
 
+struct ib_mw *mlx5_ib_alloc_mw(struct ib_pd *pd, enum ib_mw_type type,
+			       struct ib_udata *udata)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+	struct mlx5_create_mkey_mbox_in *in = NULL;
+	struct mlx5_ib_mw *mw = NULL;
+	int ndescs;
+	int err;
+	struct mlx5_ib_alloc_mw req = {};
+	struct {
+		__u32	comp_mask;
+		__u32	response_length;
+	} resp = {};
+
+	err = ib_copy_from_udata(&req, udata, min(udata->inlen, sizeof(req)));
+	if (err)
+		return ERR_PTR(err);
+
+	if (req.comp_mask || req.reserved1 || req.reserved2)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	if (udata->inlen > sizeof(req) &&
+	    !ib_is_udata_cleared(udata, sizeof(req),
+				 udata->inlen - sizeof(req)))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	ndescs = req.num_klms ? roundup(req.num_klms, 4) : roundup(1, 4);
+
+	mw = kzalloc(sizeof(*mw), GFP_KERNEL);
+	in = kzalloc(sizeof(*in), GFP_KERNEL);
+	if (!mw || !in) {
+		err = -ENOMEM;
+		goto free;
+	}
+
+	in->seg.status = MLX5_MKEY_STATUS_FREE;
+	in->seg.xlt_oct_size = cpu_to_be32(ndescs);
+	in->seg.flags_pd = cpu_to_be32(to_mpd(pd)->pdn);
+	in->seg.flags = MLX5_PERM_UMR_EN | MLX5_ACCESS_MODE_KLM |
+		MLX5_PERM_LOCAL_READ;
+	if (type == IB_MW_TYPE_2)
+		in->seg.flags_pd |= cpu_to_be32(MLX5_MKEY_REMOTE_INVAL);
+	in->seg.qpn_mkey7_0 = cpu_to_be32(0xffffff << 8);
+
+	err = mlx5_core_create_mkey(dev->mdev, &mw->mmkey, in, sizeof(*in),
+				    NULL, NULL, NULL);
+	if (err)
+		goto free;
+
+	mw->ibmw.rkey = mw->mmkey.key;
+
+	resp.response_length = min(offsetof(typeof(resp), response_length) +
+				   sizeof(resp.response_length), udata->outlen);
+	if (resp.response_length) {
+		err = ib_copy_to_udata(udata, &resp, resp.response_length);
+		if (err) {
+			mlx5_core_destroy_mkey(dev->mdev, &mw->mmkey);
+			goto free;
+		}
+	}
+
+	kfree(in);
+	return &mw->ibmw;
+
+free:
+	kfree(mw);
+	kfree(in);
+	return ERR_PTR(err);
+}
+
+int mlx5_ib_dealloc_mw(struct ib_mw *mw)
+{
+	struct mlx5_ib_mw *mmw = to_mmw(mw);
+	int err;
+
+	err =  mlx5_core_destroy_mkey((to_mdev(mw->device))->mdev,
+				      &mmw->mmkey);
+	if (!err)
+		kfree(mmw);
+	return err;
+}
+
 int mlx5_ib_check_mr_status(struct ib_mr *ibmr, u32 check_mask,
 			    struct ib_mr_status *mr_status)
 {
diff --git a/drivers/infiniband/hw/mlx5/user.h b/drivers/infiniband/hw/mlx5/user.h
index b94a554..61bc308 100644
--- a/drivers/infiniband/hw/mlx5/user.h
+++ b/drivers/infiniband/hw/mlx5/user.h
@@ -152,6 +152,13 @@ struct mlx5_ib_create_qp_resp {
 	__u32	uuar_index;
 };
 
+struct mlx5_ib_alloc_mw {
+	__u32	comp_mask;
+	__u8	num_klms;
+	__u8	reserved1;
+	__u16	reserved2;
+};
+
 static inline int get_qp_user_index(struct mlx5_ib_ucontext *ucontext,
 				    struct mlx5_ib_create_qp *ucmd,
 				    int inlen,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 51f1e54..4fe9c6b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -767,7 +767,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         cd[0x1];
 	u8         reserved_at_22c[0x1];
 	u8         apm[0x1];
-	u8         reserved_at_22e[0x7];
+	u8         reserved_at_22e[0x2];
+	u8	   imaicl[0x1];
+	u8         reserved_at_231[0x4];
 	u8         qkv[0x1];
 	u8         pkv[0x1];
 	u8         reserved_at_237[0x4];
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
