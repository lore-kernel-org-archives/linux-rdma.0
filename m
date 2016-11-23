From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 3/5] IB/core: Let the verb create_ah return extended response to user
Date: Wed, 23 Nov 2016 08:23:24 +0200
Message-ID: <1479882206-31212-4-git-send-email-leon@kernel.org>
References: <1479882206-31212-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479882206-31212-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add struct ib_udata to the signature of create_ah callback that is
implemented by IB device drivers. This allows HW drivers to return extra
data to the userspace library.
This patch prepares the ground for mlx5 driver to resolve destination
mac address for a given GID and return it to userspace.
This patch was previously submitted by Knut Omang as a part of the
patch set to support Oracle's Infiniband HCA (SIF).

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         | 11 ++++++++++-
 drivers/infiniband/core/verbs.c              |  2 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  3 ++-
 drivers/infiniband/hw/cxgb4/provider.c       |  4 +++-
 drivers/infiniband/hw/hns/hns_roce_ah.c      |  3 ++-
 drivers/infiniband/hw/hns/hns_roce_device.h  |  3 ++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  4 +++-
 drivers/infiniband/hw/mlx4/ah.c              |  4 +++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 ++-
 drivers/infiniband/hw/mlx5/ah.c              |  4 +++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 ++-
 drivers/infiniband/hw/mthca/mthca_provider.c |  4 +++-
 drivers/infiniband/hw/nes/nes_verbs.c        |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  4 +++-
 drivers/infiniband/hw/qedr/verbs.c           |  3 ++-
 drivers/infiniband/hw/qedr/verbs.h           |  3 ++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  4 +++-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  4 +++-
 drivers/infiniband/sw/rxe/rxe_verbs.c        |  4 +++-
 include/rdma/ib_verbs.h                      |  3 ++-
 21 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 790af84..1bebc66 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2877,6 +2877,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_ah			*ah;
 	struct ib_ah_attr		attr;
 	int ret;
+	struct ib_udata                   udata;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -2884,6 +2885,10 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	INIT_UDATA(&udata, buf + sizeof(cmd),
+		   (unsigned long)cmd.response + sizeof(resp),
+		   in_len - sizeof(cmd), out_len - sizeof(resp));
+
 	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
 	if (!uobj)
 		return -ENOMEM;
@@ -2910,12 +2915,16 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	memset(&attr.dmac, 0, sizeof(attr.dmac));
 	memcpy(attr.grh.dgid.raw, cmd.attr.grh.dgid, 16);
 
-	ah = ib_create_ah(pd, &attr);
+	ah = pd->device->create_ah(pd, &attr, &udata);
+
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_put;
 	}
 
+	ah->device  = pd->device;
+	ah->pd      = pd;
+	atomic_inc(&pd->usecnt);
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 83d01ef..650ce27 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -315,7 +315,7 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 {
 	struct ib_ah *ah;
 
-	ah = pd->device->create_ah(pd, ah_attr);
+	ah = pd->device->create_ah(pd, ah_attr, NULL);
 
 	if (!IS_ERR(ah)) {
 		ah->device  = pd->device;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index cba57bb..9d5fe18 100644
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
index 645e606..49b51b7 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -59,7 +59,9 @@ module_param(fastreg_support, int, 0644);
 MODULE_PARM_DESC(fastreg_support, "Advertise fastreg support (default=1)");
 
 static struct ib_ah *c4iw_ah_create(struct ib_pd *pd,
-				    struct ib_ah_attr *ah_attr)
+				    struct ib_ah_attr *ah_attr,
+				    struct ib_udata *udata)
+
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 24f79ee..0ac294d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -39,7 +39,8 @@
 #define HNS_ROCE_VLAN_SL_BIT_MASK	7
 #define HNS_ROCE_VLAN_SL_SHIFT		13
 
-struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *ah_attr)
+struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *ah_attr,
+				 struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibpd->device);
 	struct device *dev = &hr_dev->pdev->dev;
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 3417315..470615f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -667,7 +667,8 @@ int hns_roce_bitmap_alloc_range(struct hns_roce_bitmap *bitmap, int cnt,
 void hns_roce_bitmap_free_range(struct hns_roce_bitmap *bitmap,
 				unsigned long obj, int cnt);
 
-struct ib_ah *hns_roce_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+struct ib_ah *hns_roce_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				 struct ib_udata *udata);
 int hns_roce_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
 int hns_roce_destroy_ah(struct ib_ah *ah);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 6329c97..f03fc15 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2562,7 +2562,9 @@ static int i40iw_query_pkey(struct ib_device *ibdev,
  * @ah_attr: address handle attributes
  */
 static struct ib_ah *i40iw_create_ah(struct ib_pd *ibpd,
-				     struct ib_ah_attr *attr)
+				     struct ib_ah_attr *attr,
+				     struct ib_udata *udata)
+
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 5fc6233..0b288a7 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -124,7 +124,9 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
+
 {
 	struct mlx4_ib_ah *ah;
 	struct ib_ah *ret;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 35141f4..7f3d976 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -742,7 +742,8 @@ int mlx4_ib_arm_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
 void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata);
 int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
 int mlx4_ib_destroy_ah(struct ib_ah *ah);
 
diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 745efa4..ecac9ea 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -64,7 +64,9 @@ static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				struct ib_udata *udata)
+
 {
 	struct mlx5_ib_ah *ah;
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index d5d0077..b67eaf0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -737,7 +737,8 @@ void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
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
index 358930a4..d317087 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -410,7 +410,9 @@ static int mthca_dealloc_pd(struct ib_pd *pd)
 }
 
 static struct ib_ah *mthca_ah_create(struct ib_pd *pd,
-				     struct ib_ah_attr *ah_attr)
+				     struct ib_ah_attr *ah_attr,
+				     struct ib_udata *udata)
+
 {
 	int err;
 	struct mthca_ah *ah;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index bd69125..0bb857c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -771,7 +771,8 @@ static int nes_dealloc_pd(struct ib_pd *ibpd)
 /**
  * nes_create_ah
  */
-static struct ib_ah *nes_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+static struct ib_ah *nes_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+				   struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 797362a..14d33b0 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -154,7 +154,8 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	return status;
 }
 
-struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+			       struct ib_udata *udata)
 {
 	u32 *ahid_addr;
 	int status;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 3856dd4..0704a24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -50,7 +50,9 @@ enum {
 	OCRDMA_AH_L3_TYPE_MASK		= 0x03,
 	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
-struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *);
+
+struct ib_ah *ocrdma_create_ah(struct ib_pd *, struct ib_ah_attr *,
+			       struct ib_udata *);
 int ocrdma_destroy_ah(struct ib_ah *);
 int ocrdma_query_ah(struct ib_ah *, struct ib_ah_attr *);
 int ocrdma_modify_ah(struct ib_ah *, struct ib_ah_attr *);
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a615142..ccff6c6 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2094,7 +2094,8 @@ int qedr_destroy_qp(struct ib_qp *ibqp)
 	return rc;
 }
 
-struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+			     struct ib_udata *udata)
 {
 	struct qedr_ah *ah;
 
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index a9b5e67..070677c 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -70,7 +70,8 @@ int qedr_query_qp(struct ib_qp *, struct ib_qp_attr *qp_attr,
 		  int qp_attr_mask, struct ib_qp_init_attr *);
 int qedr_destroy_qp(struct ib_qp *ibqp);
 
-struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr);
+struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+			     struct ib_udata *udata);
 int qedr_destroy_ah(struct ib_ah *ibah);
 
 int qedr_dereg_mr(struct ib_mr *);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index a5bfbba..fd2a50e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -738,7 +738,9 @@ int usnic_ib_mmap(struct ib_ucontext *context,
 
 /* In ib callbacks section -  Start of stub funcs */
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-					struct ib_ah_attr *ah_attr)
+				 struct ib_ah_attr *ah_attr,
+				 struct ib_udata *udata)
+
 {
 	usnic_dbg("\n");
 	return ERR_PTR(-EPERM);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 0d9d2e6a..0ed8e07 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -75,7 +75,9 @@ int usnic_ib_dealloc_ucontext(struct ib_ucontext *ibcontext);
 int usnic_ib_mmap(struct ib_ucontext *context,
 			struct vm_area_struct *vma);
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-					struct ib_ah_attr *ah_attr);
+				 struct ib_ah_attr *ah_attr,
+				 struct ib_udata *udata);
+
 int usnic_ib_destroy_ah(struct ib_ah *ah);
 int usnic_ib_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 			struct ib_send_wr **bad_wr);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 19841c8..187d85c 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -316,7 +316,9 @@ static int rxe_init_av(struct rxe_dev *rxe, struct ib_ah_attr *attr,
 	return err;
 }
 
-static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
+static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+				   struct ib_udata *udata)
+
 {
 	int err;
 	struct rxe_dev *rxe = to_rdev(ibpd->device);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a2f21e0..9bc3812 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1933,7 +1933,8 @@ struct ib_device {
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
