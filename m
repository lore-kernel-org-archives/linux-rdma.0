From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 1/5] verbs: Don't open code 'container_of' in the providers
Date: Thu, 14 Dec 2017 15:35:39 -0700
Message-ID: <20171214223544.30117-2-jgg@ziepe.ca>
References: <20171214223544.30117-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171214223544.30117-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We have container_of now, so just use it.

There are several places that used container_of wrongly, and the ccan
automatic container_of type checking flags it. None of these cases will
cause bugs.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.h          |  2 +-
 providers/cxgb3/iwch.h            |  7 +++----
 providers/cxgb4/libcxgb4.h        |  5 ++---
 providers/hfi1verbs/hfiverbs.h    |  5 ++---
 providers/hns/hns_roce_u.h        |  2 +-
 providers/i40iw/i40iw_umain.h     |  7 +++----
 providers/ipathverbs/ipathverbs.h |  6 ++----
 providers/mlx4/mlx4.h             |  9 ++++-----
 providers/mlx5/mlx5.h             | 11 +++--------
 providers/mthca/mthca.h           |  6 ++----
 providers/nes/nes_umain.h         |  7 +++----
 providers/ocrdma/ocrdma_main.h    |  7 +++----
 providers/qedr/qelr.h             |  2 +-
 providers/rxe/rxe.h               |  6 ++----
 providers/vmw_pvrdma/pvrdma.h     |  2 +-
 15 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/providers/bnxt_re/main.h b/providers/bnxt_re/main.h
index 82c894844d7f3b..33f531ba6d4b1d 100644
--- a/providers/bnxt_re/main.h
+++ b/providers/bnxt_re/main.h
@@ -161,7 +161,7 @@ void bnxt_re_ring_cq_arm_db(struct bnxt_re_cq *cq, uint8_t aflag);
 /* pointer conversion functions*/
 static inline struct bnxt_re_dev *to_bnxt_re_dev(struct ibv_device *ibvdev)
 {
-	return container_of(ibvdev, struct bnxt_re_dev, vdev);
+	return container_of(ibvdev, struct bnxt_re_dev, vdev.device);
 }
 
 static inline struct bnxt_re_context *to_bnxt_re_context(
diff --git a/providers/cxgb3/iwch.h b/providers/cxgb3/iwch.h
index ba6e610cbca7ac..1b95fec664ef11 100644
--- a/providers/cxgb3/iwch.h
+++ b/providers/cxgb3/iwch.h
@@ -101,13 +101,12 @@ struct iwch_qp {
 	int sq_sig_all;
 };
 
-#define to_iwch_xxx(xxx, type)						\
-	((struct iwch_##type *)						\
-	 ((void *) ib##xxx - offsetof(struct iwch_##type, ibv_##xxx)))
+#define to_iwch_xxx(xxx, type)                                                 \
+	container_of(ib##xxx, struct iwch_##type, ibv_##xxx)
 
 static inline struct iwch_device *to_iwch_dev(struct ibv_device *ibdev)
 {
-	return to_iwch_xxx(dev, device);
+	return container_of(ibdev, struct iwch_device, ibv_dev.device);
 }
 
 static inline struct iwch_context *to_iwch_ctx(struct ibv_context *ibctx)
diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
index e7d13c5ec58f94..a5256f7e081770 100644
--- a/providers/cxgb4/libcxgb4.h
+++ b/providers/cxgb4/libcxgb4.h
@@ -120,12 +120,11 @@ struct c4iw_qp {
 };
 
 #define to_c4iw_xxx(xxx, type)						\
-	((struct c4iw_##type *)						\
-	 ((void *) ib##xxx - offsetof(struct c4iw_##type, ibv_##xxx)))
+	container_of(ib##xxx, struct c4iw_##type, ibv_##xxx)
 
 static inline struct c4iw_dev *to_c4iw_dev(struct ibv_device *ibdev)
 {
-	return to_c4iw_xxx(dev, dev);
+	return container_of(ibdev, struct c4iw_dev, ibv_dev.device);
 }
 
 static inline struct c4iw_context *to_c4iw_context(struct ibv_context *ibctx)
diff --git a/providers/hfi1verbs/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
index 456d36872df8a8..e672dda4982527 100644
--- a/providers/hfi1verbs/hfiverbs.h
+++ b/providers/hfi1verbs/hfiverbs.h
@@ -154,8 +154,7 @@ struct hfi1_srq {
 };
 
 #define to_ixxx(xxx, type)						\
-	((struct hfi1_##type *)					\
-	 ((void *) ib##xxx - offsetof(struct hfi1_##type, ibv_##xxx)))
+	container_of(ib##xxx, struct hfi1_##type, ibv_##xxx)
 
 static inline struct hfi1_context *to_ictx(struct ibv_context *ibctx)
 {
@@ -164,7 +163,7 @@ static inline struct hfi1_context *to_ictx(struct ibv_context *ibctx)
 
 static inline struct hfi1_device *to_idev(struct ibv_device *ibdev)
 {
-	return to_ixxx(dev, device);
+	return container_of(ibdev, struct hfi1_device, ibv_dev.device);
 }
 
 static inline struct hfi1_cq *to_icq(struct ibv_cq *ibcq)
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index 2f4f3dc3d776ed..101320b1f8f3ad 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -216,7 +216,7 @@ static inline unsigned long align(unsigned long val, unsigned long align)
 
 static inline struct hns_roce_device *to_hr_dev(struct ibv_device *ibv_dev)
 {
-	return container_of(ibv_dev, struct hns_roce_device, ibv_dev);
+	return container_of(ibv_dev, struct hns_roce_device, ibv_dev.device);
 }
 
 static inline struct hns_roce_context *to_hr_ctx(struct ibv_context *ibv_ctx)
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index bfca09bbcf4c7b..109aba6bd92ef4 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -127,13 +127,12 @@ struct i40iw_uqp {
 
 };
 
-#define to_i40iw_uxxx(xxx, type)                         \
-	((struct i40iw_u ## type *)                                        \
-	 ((void *)ib ## xxx - offsetof(struct i40iw_u ## type, ibv_ ## xxx)))
+#define to_i40iw_uxxx(xxx, type)                                               \
+	container_of(ib##xxx, struct i40iw_u##type, ibv_##xxx)
 
 static inline struct i40iw_udevice *to_i40iw_udev(struct ibv_device *ibdev)
 {
-	return to_i40iw_uxxx(dev, device);
+	return container_of(ibdev, struct i40iw_udevice, ibv_dev.device);
 }
 
 static inline struct i40iw_uvcontext *to_i40iw_uctx(struct ibv_context *ibctx)
diff --git a/providers/ipathverbs/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
index 13acec2466f607..5f2658e7942c8b 100644
--- a/providers/ipathverbs/ipathverbs.h
+++ b/providers/ipathverbs/ipathverbs.h
@@ -133,9 +133,7 @@ struct ipath_srq {
 	struct ipath_rq		rq;
 };
 
-#define to_ixxx(xxx, type)						\
-	((struct ipath_##type *)					\
-	 ((void *) ib##xxx - offsetof(struct ipath_##type, ibv_##xxx)))
+#define to_ixxx(xxx, type) container_of(ib##xxx, struct ipath_##type, ibv_##xxx)
 
 static inline struct ipath_context *to_ictx(struct ibv_context *ibctx)
 {
@@ -144,7 +142,7 @@ static inline struct ipath_context *to_ictx(struct ibv_context *ibctx)
 
 static inline struct ipath_device *to_idev(struct ibv_device *ibdev)
 {
-	return to_ixxx(dev, device);
+	return container_of(ibdev, struct ipath_device, ibv_dev.device);
 }
 
 static inline struct ipath_cq *to_icq(struct ibv_cq *ibcq)
diff --git a/providers/mlx4/mlx4.h b/providers/mlx4/mlx4.h
index 1d14272127d714..ef0c7cb9c9a733 100644
--- a/providers/mlx4/mlx4.h
+++ b/providers/mlx4/mlx4.h
@@ -247,16 +247,15 @@ static inline unsigned long align(unsigned long val, unsigned long align)
 }
 int align_queue_size(int req);
 
-#define to_mxxx(xxx, type)						\
-	((struct mlx4_##type *)					\
-	 ((void *) ib##xxx - offsetof(struct mlx4_##type, ibv_##xxx)))
+#define to_mxxx(xxx, type)                                                     \
+	container_of(ib##xxx, struct mlx4_##type, ibv_##xxx)
 
 static inline struct mlx4_device *to_mdev(struct ibv_device *ibdev)
 {
 	/* ibv_device is first field of verbs_device
 	 * see try_driver() in libibverbs.
 	 */
-	return container_of(ibdev, struct mlx4_device, verbs_dev);
+	return container_of(ibdev, struct mlx4_device, verbs_dev.device);
 }
 
 static inline struct mlx4_context *to_mctx(struct ibv_context *ibctx)
@@ -271,7 +270,7 @@ static inline struct mlx4_pd *to_mpd(struct ibv_pd *ibpd)
 
 static inline struct mlx4_cq *to_mcq(struct ibv_cq *ibcq)
 {
-	return to_mxxx(cq, cq);
+	return container_of((struct ibv_cq_ex *)ibcq, struct mlx4_cq, ibv_cq);
 }
 
 static inline struct mlx4_srq *to_msrq(struct ibv_srq *ibsrq)
diff --git a/providers/mlx5/mlx5.h b/providers/mlx5/mlx5.h
index 70cac80a7219ec..5a1f7c0a2bbafc 100644
--- a/providers/mlx5/mlx5.h
+++ b/providers/mlx5/mlx5.h
@@ -539,16 +539,11 @@ static inline unsigned long align(unsigned long val, unsigned long align)
 	return (val + align - 1) & ~(align - 1);
 }
 
-#define to_mxxx(xxx, type)						\
-	((struct mlx5_##type *)					\
-	 ((void *) ib##xxx - offsetof(struct mlx5_##type, ibv_##xxx)))
+#define to_mxxx(xxx, type) container_of(ib##xxx, struct mlx5_##type, ibv_##xxx)
 
 static inline struct mlx5_device *to_mdev(struct ibv_device *ibdev)
 {
-	struct mlx5_device *ret;
-
-	ret = (void *)ibdev - offsetof(struct mlx5_device, verbs_dev);
-	return ret;
+	return container_of(ibdev, struct mlx5_device, verbs_dev.device);
 }
 
 static inline struct mlx5_context *to_mctx(struct ibv_context *ibctx)
@@ -563,7 +558,7 @@ static inline struct mlx5_pd *to_mpd(struct ibv_pd *ibpd)
 
 static inline struct mlx5_cq *to_mcq(struct ibv_cq *ibcq)
 {
-	return to_mxxx(cq, cq);
+	return container_of((struct ibv_cq_ex *)ibcq, struct mlx5_cq, ibv_cq);
 }
 
 static inline struct mlx5_srq *to_msrq(struct ibv_srq *ibsrq)
diff --git a/providers/mthca/mthca.h b/providers/mthca/mthca.h
index 68bc5ad73f9b49..a67acf46c7c56d 100644
--- a/providers/mthca/mthca.h
+++ b/providers/mthca/mthca.h
@@ -220,13 +220,11 @@ static inline uintptr_t db_align(__be32 *db)
 	return (uintptr_t) db & ~((uintptr_t) MTHCA_DB_REC_PAGE_SIZE - 1);
 }
 
-#define to_mxxx(xxx, type)						\
-	((struct mthca_##type *)					\
-	 ((void *) ib##xxx - offsetof(struct mthca_##type, ibv_##xxx)))
+#define to_mxxx(xxx, type) container_of(ib##xxx, struct mthca_##type, ibv_##xxx)
 
 static inline struct mthca_device *to_mdev(struct ibv_device *ibdev)
 {
-	return to_mxxx(dev, device);
+	return container_of(ibdev, struct mthca_device, ibv_dev.device);
 }
 
 static inline struct mthca_context *to_mctx(struct ibv_context *ibctx)
diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index 94c81c2fa8ecb4..0a832e7517bea6 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -321,13 +321,12 @@ struct nes_uqp {
 	uint64_t recv_wr_id[512]; /* IMA receive wr_id ring content */
 };
 
-#define to_nes_uxxx(xxx, type)				\
-	((struct nes_u##type *)					\
-	((void *) ib##xxx - offsetof(struct nes_u##type, ibv_##xxx)))
+#define to_nes_uxxx(xxx, type)                                                 \
+	container_of(ib##xxx, struct nes_u##type, ibv_##xxx)
 
 static inline struct nes_udevice *to_nes_udev(struct ibv_device *ibdev)
 {
-	return to_nes_uxxx(dev, device);
+	return container_of(ibdev, struct nes_udevice, ibv_dev.device);
 }
 
 static inline struct nes_uvcontext *to_nes_uctx(struct ibv_context *ibctx)
diff --git a/providers/ocrdma/ocrdma_main.h b/providers/ocrdma/ocrdma_main.h
index 05bb12435fb1cc..e5b2860f9dc45c 100644
--- a/providers/ocrdma/ocrdma_main.h
+++ b/providers/ocrdma/ocrdma_main.h
@@ -226,9 +226,8 @@ struct ocrdma_ah {
 	uint8_t hdr_type;
 };
 
-#define get_ocrdma_xxx(xxx, type)				\
-	((struct ocrdma_##type *)					\
-	((void *) ib##xxx - offsetof(struct ocrdma_##type, ibv_##xxx)))
+#define get_ocrdma_xxx(xxx, type)                                              \
+	container_of(ib##xxx, struct ocrdma_##type, ibv_##xxx)
 
 static inline struct ocrdma_devctx *get_ocrdma_ctx(struct ibv_context *ibctx)
 {
@@ -237,7 +236,7 @@ static inline struct ocrdma_devctx *get_ocrdma_ctx(struct ibv_context *ibctx)
 
 static inline struct ocrdma_device *get_ocrdma_dev(struct ibv_device *ibdev)
 {
-	return get_ocrdma_xxx(dev, device);
+	return container_of(ibdev, struct ocrdma_device, ibv_dev.device);
 }
 
 static inline struct ocrdma_qp *get_ocrdma_qp(struct ibv_qp *ibqp)
diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index 1a5920c664ab38..b3faa0044137d8 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -256,7 +256,7 @@ static inline struct qelr_devctx *get_qelr_ctx(struct ibv_context *ibctx)
 
 static inline struct qelr_device *get_qelr_dev(struct ibv_device *ibdev)
 {
-	return container_of(ibdev, struct qelr_device, ibv_dev);
+	return container_of(ibdev, struct qelr_device, ibv_dev.device);
 }
 
 static inline struct qelr_qp *get_qelr_qp(struct ibv_qp *ibqp)
diff --git a/providers/rxe/rxe.h b/providers/rxe/rxe.h
index 8a25e82af8311d..1f331662b2ba2d 100644
--- a/providers/rxe/rxe.h
+++ b/providers/rxe/rxe.h
@@ -94,9 +94,7 @@ struct rxe_srq {
 	uint32_t		srq_num;
 };
 
-#define to_rxxx(xxx, type)						\
-	((struct rxe_##type *)					      \
-	 ((void *) ib##xxx - offsetof(struct rxe_##type, ibv_##xxx)))
+#define to_rxxx(xxx, type) container_of(ib##xxx, struct rxe_##type, ibv_##xxx)
 
 static inline struct rxe_context *to_rctx(struct ibv_context *ibctx)
 {
@@ -105,7 +103,7 @@ static inline struct rxe_context *to_rctx(struct ibv_context *ibctx)
 
 static inline struct rxe_device *to_rdev(struct ibv_device *ibdev)
 {
-	return to_rxxx(dev, device);
+	return container_of(ibdev, struct rxe_device, ibv_dev.device);
 }
 
 static inline struct rxe_cq *to_rcq(struct ibv_cq *ibcq)
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index 5a7b1713aca287..3bcec1cb71d14d 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -196,7 +196,7 @@ static inline int align_next_power2(int size)
 
 static inline struct pvrdma_device *to_vdev(struct ibv_device *ibdev)
 {
-	return container_of(ibdev, struct pvrdma_device, ibv_dev);
+	return container_of(ibdev, struct pvrdma_device, ibv_dev.device);
 }
 
 static inline struct pvrdma_context *to_vctx(struct ibv_context *ibctx)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
