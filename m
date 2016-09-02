From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/9] ib: Add udata argument to create_ah
Date: Fri,  2 Sep 2016 02:09:24 +0200
Message-ID: <1472774969-18997-5-git-send-email-knut.omang@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472774969-18997-1-git-send-email-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Most of the ib device driver entry points supports optional
device specific parameter transfer between user space and kernel space
via the udata argument - add a similar argument for ib_create_ah.

Update all infiniband drivers to include this agument
in their driver entry point implementation.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         | 10 +++++++++-
 drivers/infiniband/core/verbs.c              |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  3 ++-
 drivers/infiniband/hw/cxgb4/provider.c       |  3 ++-
 drivers/infiniband/hw/mlx4/ah.c              |  3 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 ++-
 drivers/infiniband/hw/mlx5/ah.c              |  3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 ++-
 drivers/infiniband/hw/mthca/mthca_provider.c |  3 ++-
 drivers/infiniband/hw/nes/nes_verbs.c        |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  5 +++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  3 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  3 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  3 ++-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  3 ++-
 include/rdma/ib_verbs.h                      |  3 ++-
 16 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f664731..dbc5885 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2874,6 +2874,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
 	struct ib_ah_attr		attr;
+	struct ib_udata                 udata;
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -2882,6 +2883,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		(unsigned long) cmd.response + sizeof resp,
+		in_len - sizeof cmd, out_len - sizeof resp);
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -2908,14 +2913,17 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
-	ah = ib_create_ah(pd, &attr);
+	ah = pd->device->create_ah(pd, &attr, &udata);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_put;
 	}
 
+	ah->device  = pd->device;
+	ah->pd      = pd;
 	ah->uobject  = uobj;
 	uobj->object = ah;
+	atomic_inc(&pd->usecnt);
 
 	ret = idr_add_uobj(&ib_uverbs_ah_idr, uobj);
 	if (ret)
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f2b776e..6efe23d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -293,7 +293,7 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
 	struct ib_ah *ah;
 
-	ah = pd->device->create_ah(pd, ah_attr);
+	ah = pd->device->create_ah(pd, ah_attr, NULL);
 
 	if (!IS_ERR(ah)) {
 		ah->device  = pd->device;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 4225479..ffdf530 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -62,7 +62,8 @@
 #include "common.h"
 
 static struct ib_ah *iwch_ah_create(struct ib_pd *pd,
-				    struct ib_ah_attr *ah_attr)
+				    struct ib_ah_attr *ah_attr,
+				    struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index df127ce..b476df0 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -59,7 +59,8 @@ module_param(fastreg_support, int, 0644);
 MODULE_PARM_DESC(fastreg_support, "Advertise fastreg support (default=1)");
 
 static struct ib_ah *c4iw_ah_create(struct ib_pd *pd,
-				    struct ib_ah_attr *ah_attr)
+				    struct ib_ah_attr *ah_attr,
+				    struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 5fc6233..1ea2ba3 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -124,7 +124,8 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
 {
 	struct mlx4_ib_ah *ah;
 	struct ib_ah *ret;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 7c5832e..c3812e3 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -740,7 +740,8 @@ int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata);
 int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
 int mlx4_ib_destroy_ah(struct ib_ah *ah);
 
diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 745efa4..b5d0f9a 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -64,7 +64,8 @@ static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
 {
 	struct mlx5_ib_ah *ah;
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index a59034a..82a1ccd 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -726,7 +726,8 @@ void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		 const void *in_mad, void *response_mad);
-struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata);
 int mlx5_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
 int mlx5_ib_destroy_ah(struct ib_ah *ah);
 struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 86c60dc..9618e32 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -409,7 +409,8 @@ static int mthca_dealloc_pd(struct ib_pd *pd)
 }
 
 static struct ib_ah *mthca_ah_create(struct ib_pd *pd,
-				     struct ib_ah_attr *ah_attr)
+				     struct ib_ah_attr *ah_attr,
+				     struct ib_udata *udata)
 {
 	int err;
 	struct mthca_ah *ah;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f417e1d..76862c9 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -771,7 +771,8 @@ static int nes_dealloc_pd(struct ib_pd *ibpd)
 /**
  * nes_create_ah
  */
-static struct ib_ah *nes_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+static struct ib_ah *nes_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 797362a..c65ac291 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -154,7 +154,8 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	return status;
 }
 
-struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+			struct ib_udata *udata)
 {
 	u32 *ahid_addr;
 	int status;
@@ -203,7 +204,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 						      &sgid_attr.ndev->ifindex,
 						      NULL);
 		if (status) {
-			pr_err("%s(): Failed to resolve dmac from gid." 
+			pr_err("%s(): Failed to resolve dmac from gid."
 				"status = %d\n", __func__, status);
 			goto av_conf_err;
 		}
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 3856dd4..327b888a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -50,7 +50,8 @@ enum {
 	OCRDMA_AH_L3_TYPE_MASK		= 0x03,
 	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
-struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *);
+struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *,
+			struct ib_udata *);
 int ocrdma_destroy_ah(struct ib_ah *);
 int ocrdma_query_ah(struct ib_ah *, struct ib_ah_attr *);
 int ocrdma_modify_ah(struct ib_ah *, struct ib_ah_attr *);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index a5bfbba..9051193 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -738,7 +738,8 @@ int usnic_ib_mmap(struct ib_ucontext *context,
 
 /* In ib callbacks section -  Start of stub funcs */
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-					struct ib_ah_attr *ah_attr)
+				struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
 {
 	usnic_dbg("\n");
 	return ERR_PTR(-EPERM);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 0d9d2e6a..1eecd8e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -75,7 +75,8 @@ int usnic_ib_dealloc_ucontext(struct ib_ucontext *ibcontext);
 int usnic_ib_mmap(struct ib_ucontext *context,
 			struct vm_area_struct *vma);
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-					struct ib_ah_attr *ah_attr);
+				struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata);
 int usnic_ib_destroy_ah(struct ib_ah *ah);
 int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			struct ib_send_wr **bad_wr);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 4552be9..64ade0b 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -314,7 +314,8 @@ static int rxe_init_av(struct rxe_dev *rxe, struct ib_ah_attr *attr,
 	return err;
 }
 
-static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+				struct ib_udata *udata)
 {
 	int err;
 	struct rxe_dev *rxe = to_rdev(ibpd->device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8e90dd2..192d591 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1879,7 +1879,8 @@ struct ib_device {
 					       struct ib_udata *udata);
 	int                        (*dealloc_pd)(struct ib_pd *pd);
 	struct ib_ah *             (*create_ah)(struct ib_pd *pd,
-						struct ib_ah_attr *ah_attr);
+						struct ib_ah_attr *ah_attr,
+						struct ib_udata *udata);
 	int                        (*modify_ah)(struct ib_ah *ah,
 						struct ib_ah_attr *ah_attr);
 	int                        (*query_ah)(struct ib_ah *ah,
-- 
2.5.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
