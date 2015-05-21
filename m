From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 01/11] IB/core: Change provider's API of create_cq to be extendible
Date: Thu, 21 May 2015 17:56:32 +0300
Message-ID: <1432220202-9834-2-git-send-email-ogerlitz@mellanox.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a new ib_cq_init_attr structure which contains the
previous cqe (minimum number of CQ entries) and comp_vector
(completion vector) in addition to a new flags field.
All vendors' create_cq callbacks are changed in order
to work with the new API.

This commit does not change any functionality.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         |    6 ++++--
 drivers/infiniband/core/verbs.c              |    3 ++-
 drivers/infiniband/hw/amso1100/c2_provider.c |    7 ++++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |   11 ++++++++---
 drivers/infiniband/hw/cxgb4/cq.c             |    9 +++++++--
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h       |    8 ++++----
 drivers/infiniband/hw/ehca/ehca_cq.c         |    7 ++++++-
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |    3 ++-
 drivers/infiniband/hw/ipath/ipath_cq.c       |    9 +++++++--
 drivers/infiniband/hw/ipath/ipath_verbs.h    |    3 ++-
 drivers/infiniband/hw/mlx4/cq.c              |    8 +++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |    3 ++-
 drivers/infiniband/hw/mlx5/cq.c              |   10 ++++++++--
 drivers/infiniband/hw/mlx5/main.c            |    3 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |    5 +++--
 drivers/infiniband/hw/mthca/mthca_provider.c |    8 ++++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |   11 ++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    7 ++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |    6 ++++--
 drivers/infiniband/hw/qib/qib_cq.c           |   11 ++++++++---
 drivers/infiniband/hw/qib/qib_verbs.h        |    5 +++--
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |   10 +++++++---
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |    7 ++++---
 include/rdma/ib_verbs.h                      |   10 ++++++++--
 24 files changed, 124 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a9f0489..1954ebb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1341,6 +1341,7 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_event_file    *ev_file = NULL;
 	struct ib_cq                   *cq;
 	int                             ret;
+	struct ib_cq_init_attr attr = {};
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -1376,8 +1377,9 @@ ssize_t ib_uverbs_create_cq(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&obj->comp_list);
 	INIT_LIST_HEAD(&obj->async_list);
 
-	cq = file->device->ib_dev->create_cq(file->device->ib_dev, cmd.cqe,
-					     cmd.comp_vector,
+	attr.cqe = cmd.cqe;
+	attr.comp_vector = cmd.comp_vector;
+	cq = file->device->ib_dev->create_cq(file->device->ib_dev, &attr,
 					     file->ucontext, &udata);
 	if (IS_ERR(cq)) {
 		ret = PTR_ERR(cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f93eb8d..0c49163 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1015,8 +1015,9 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 			   void *cq_context, int cqe, int comp_vector)
 {
 	struct ib_cq *cq;
+	struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector};
 
-	cq = device->create_cq(device, cqe, comp_vector, NULL, NULL);
+	cq = device->create_cq(device, &attr, NULL, NULL);
 
 	if (!IS_ERR(cq)) {
 		cq->device        = device;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index bdf3507..8e53d05 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -286,13 +286,18 @@ static int c2_destroy_qp(struct ib_qp *ib_qp)
 	return 0;
 }
 
-static struct ib_cq *c2_create_cq(struct ib_device *ibdev, int entries, int vector,
+static struct ib_cq *c2_create_cq(struct ib_device *ibdev,
+				  const struct ib_cq_init_attr *attr,
 				  struct ib_ucontext *context,
 				  struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct c2_cq *cq;
 	int err;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	cq = kmalloc(sizeof(*cq), GFP_KERNEL);
 	if (!cq) {
 		pr_debug("%s: Unable to allocate CQ\n", __func__);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 811b24a..eb74c4d 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -138,10 +138,12 @@ static int iwch_destroy_cq(struct ib_cq *ib_cq)
 	return 0;
 }
 
-static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int vector,
-			     struct ib_ucontext *ib_context,
-			     struct ib_udata *udata)
+static struct ib_cq *iwch_create_cq(struct ib_device *ibdev,
+				    const struct ib_cq_init_attr *attr,
+				    struct ib_ucontext *ib_context,
+				    struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct iwch_dev *rhp;
 	struct iwch_cq *chp;
 	struct iwch_create_cq_resp uresp;
@@ -151,6 +153,9 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev, int entries, int ve
 	size_t resplen;
 
 	PDBG("%s ib_dev %p entries %d\n", __func__, ibdev, entries);
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	rhp = to_iwch_dev(ibdev);
 	chp = kzalloc(sizeof(*chp), GFP_KERNEL);
 	if (!chp)
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 68ddb37..9a2c01c 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -866,10 +866,13 @@ int c4iw_destroy_cq(struct ib_cq *ib_cq)
 	return 0;
 }
 
-struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
-			     int vector, struct ib_ucontext *ib_context,
+struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
+			     const struct ib_cq_init_attr *attr,
+			     struct ib_ucontext *ib_context,
 			     struct ib_udata *udata)
 {
+	int entries = attr->cqe;
+	int vector = attr->comp_vector;
 	struct c4iw_dev *rhp;
 	struct c4iw_cq *chp;
 	struct c4iw_create_cq_resp uresp;
@@ -879,6 +882,8 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
 	struct c4iw_mm_entry *mm, *mm2;
 
 	PDBG("%s ib_dev %p entries %d\n", __func__, ibdev, entries);
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
 
 	rhp = to_c4iw_dev(ibdev);
 
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 97bb555..540ed02 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -992,10 +992,10 @@ int c4iw_reregister_phys_mem(struct ib_mr *mr,
 				     int acc, u64 *iova_start);
 int c4iw_dereg_mr(struct ib_mr *ib_mr);
 int c4iw_destroy_cq(struct ib_cq *ib_cq);
-struct ib_cq *c4iw_create_cq(struct ib_device *ibdev, int entries,
-					int vector,
-					struct ib_ucontext *ib_context,
-					struct ib_udata *udata);
+struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
+			     const struct ib_cq_init_attr *attr,
+			     struct ib_ucontext *ib_context,
+			     struct ib_udata *udata);
 int c4iw_resize_cq(struct ib_cq *cq, int cqe, struct ib_udata *udata);
 int c4iw_arm_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags);
 int c4iw_destroy_qp(struct ib_qp *ib_qp);
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 8cc8375..9b68b17 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -113,10 +113,12 @@ struct ehca_qp *ehca_cq_get_qp(struct ehca_cq *cq, int real_qp_num)
 	return ret;
 }
 
-struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
+struct ib_cq *ehca_create_cq(struct ib_device *device,
+			     const struct ib_cq_init_attr *attr,
 			     struct ib_ucontext *context,
 			     struct ib_udata *udata)
 {
+	int cqe = attr->cqe;
 	static const u32 additional_cqe = 20;
 	struct ib_cq *cq;
 	struct ehca_cq *my_cq;
@@ -131,6 +133,9 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	int ipz_rc, i;
 	unsigned long flags;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 22f79af..e47581a 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -126,7 +126,8 @@ int ehca_destroy_eq(struct ehca_shca *shca, struct ehca_eq *eq);
 void *ehca_poll_eq(struct ehca_shca *shca, struct ehca_eq *eq);
 
 
-struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
+struct ib_cq *ehca_create_cq(struct ib_device *device,
+			     const struct ib_cq_init_attr *attr,
 			     struct ib_ucontext *context,
 			     struct ib_udata *udata);
 
diff --git a/drivers/infiniband/hw/ipath/ipath_cq.c b/drivers/infiniband/hw/ipath/ipath_cq.c
index 0416c6c..e9dd911 100644
--- a/drivers/infiniband/hw/ipath/ipath_cq.c
+++ b/drivers/infiniband/hw/ipath/ipath_cq.c
@@ -188,7 +188,7 @@ static void send_complete(unsigned long data)
 /**
  * ipath_create_cq - create a completion queue
  * @ibdev: the device this completion queue is attached to
- * @entries: the minimum size of the completion queue
+ * @attr: creation attributes
  * @context: unused by the InfiniPath driver
  * @udata: unused by the InfiniPath driver
  *
@@ -197,16 +197,21 @@ static void send_complete(unsigned long data)
  *
  * Called by ib_create_cq() in the generic verbs code.
  */
-struct ib_cq *ipath_create_cq(struct ib_device *ibdev, int entries, int comp_vector,
+struct ib_cq *ipath_create_cq(struct ib_device *ibdev,
+			      const struct ib_cq_init_attr *attr,
 			      struct ib_ucontext *context,
 			      struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct ipath_ibdev *dev = to_idev(ibdev);
 	struct ipath_cq *cq;
 	struct ipath_cq_wc *wc;
 	struct ib_cq *ret;
 	u32 sz;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries < 1 || entries > ib_ipath_max_cqes) {
 		ret = ERR_PTR(-EINVAL);
 		goto done;
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index ae6cff4..c4e4e81 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -807,7 +807,8 @@ void ipath_cq_enter(struct ipath_cq *cq, struct ib_wc *entry, int sig);
 
 int ipath_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
 
-struct ib_cq *ipath_create_cq(struct ib_device *ibdev, int entries, int comp_vector,
+struct ib_cq *ipath_create_cq(struct ib_device *ibdev,
+			      const struct ib_cq_init_attr *attr,
 			      struct ib_ucontext *context,
 			      struct ib_udata *udata);
 
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 0176caa..8e44aaa 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -166,15 +166,21 @@ err_buf:
 	return err;
 }
 
-struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector,
+struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
+				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
 				struct ib_udata *udata)
 {
+	int entries = attr->cqe;
+	int vector = attr->comp_vector;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct mlx4_ib_cq *cq;
 	struct mlx4_uar *uar;
 	int err;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries < 1 || entries > dev->dev->caps.max_cqes)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index fce3934..f127efc 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -668,7 +668,8 @@ void mlx4_ib_free_fast_reg_page_list(struct ib_fast_reg_page_list *page_list);
 
 int mlx4_ib_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period);
 int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata);
-struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector,
+struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
+				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
 				struct ib_udata *udata);
 int mlx4_ib_destroy_cq(struct ib_cq *cq);
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 2ee6b10..09fbae6 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -736,10 +736,13 @@ static void destroy_cq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq)
 	mlx5_db_free(dev->mdev, &cq->db);
 }
 
-struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev, int entries,
-				int vector, struct ib_ucontext *context,
+struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
+				const struct ib_cq_init_attr *attr,
+				struct ib_ucontext *context,
 				struct ib_udata *udata)
 {
+	int entries = attr->cqe;
+	int vector = attr->comp_vector;
 	struct mlx5_create_cq_mbox_in *cqb = NULL;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_ib_cq *cq;
@@ -750,6 +753,9 @@ struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev, int entries,
 	int eqn;
 	int err;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries < 0)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 57c9809..1af3529 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1087,6 +1087,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 {
 	struct ib_srq_init_attr attr;
 	struct mlx5_ib_dev *dev;
+	struct ib_cq_init_attr cq_attr = {.cqe = 1};
 	int ret = 0;
 
 	dev = container_of(devr, struct mlx5_ib_dev, devr);
@@ -1100,7 +1101,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->p0->uobject = NULL;
 	atomic_set(&devr->p0->usecnt, 0);
 
-	devr->c0 = mlx5_ib_create_cq(&dev->ib_dev, 1, 0, NULL, NULL);
+	devr->c0 = mlx5_ib_create_cq(&dev->ib_dev, &cq_attr, NULL, NULL);
 	if (IS_ERR(devr->c0)) {
 		ret = PTR_ERR(devr->c0);
 		goto error1;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dff1cfc..b086162 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -556,8 +556,9 @@ int mlx5_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 void *mlx5_get_send_wqe(struct mlx5_ib_qp *qp, int n);
 int mlx5_ib_read_user_wqe(struct mlx5_ib_qp *qp, int send, int wqe_index,
 			  void *buffer, u32 length);
-struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev, int entries,
-				int vector, struct ib_ucontext *context,
+struct ib_cq *mlx5_ib_create_cq(struct ib_device *ibdev,
+				const struct ib_cq_init_attr *attr,
+				struct ib_ucontext *context,
 				struct ib_udata *udata);
 int mlx5_ib_destroy_cq(struct ib_cq *cq);
 int mlx5_ib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1..dbed91e 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -641,16 +641,20 @@ static int mthca_destroy_qp(struct ib_qp *qp)
 	return 0;
 }
 
-static struct ib_cq *mthca_create_cq(struct ib_device *ibdev, int entries,
-				     int comp_vector,
+static struct ib_cq *mthca_create_cq(struct ib_device *ibdev,
+				     const struct ib_cq_init_attr *attr,
 				     struct ib_ucontext *context,
 				     struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct mthca_create_cq ucmd;
 	struct mthca_cq *cq;
 	int nent;
 	int err;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries < 1 || entries > to_mdev(ibdev)->limits.max_cqes)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c0d0296..e6e6f53 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1527,10 +1527,12 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 /**
  * nes_create_cq
  */
-static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
-		int comp_vector,
-		struct ib_ucontext *context, struct ib_udata *udata)
+static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
+				   const struct ib_cq_init_attr *attr,
+				   struct ib_ucontext *context,
+				   struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	u64 u64temp;
 	struct nes_vnic *nesvnic = to_nesvnic(ibdev);
 	struct nes_device *nesdev = nesvnic->nesdev;
@@ -1550,6 +1552,9 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 	unsigned long flags;
 	int ret;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries > nesadapter->max_cqe)
 		return ERR_PTR(-EINVAL);
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8771755..f441df6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1000,10 +1000,12 @@ err:
 	return status;
 }
 
-struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
+struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev,
+			       const struct ib_cq_init_attr *attr,
 			       struct ib_ucontext *ib_ctx,
 			       struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct ocrdma_cq *cq;
 	struct ocrdma_dev *dev = get_ocrdma_dev(ibdev);
 	struct ocrdma_ucontext *uctx = NULL;
@@ -1011,6 +1013,9 @@ struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev, int entries, int vector,
 	int status;
 	struct ocrdma_create_cq_ureq ureq;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (udata) {
 		if (ib_copy_from_udata(&ureq, udata, sizeof(ureq)))
 			return ERR_PTR(-EFAULT);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b8f7853..b6de5f9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -56,8 +56,10 @@ struct ib_pd *ocrdma_alloc_pd(struct ib_device *,
 			      struct ib_ucontext *, struct ib_udata *);
 int ocrdma_dealloc_pd(struct ib_pd *pd);
 
-struct ib_cq *ocrdma_create_cq(struct ib_device *, int entries, int vector,
-			       struct ib_ucontext *, struct ib_udata *);
+struct ib_cq *ocrdma_create_cq(struct ib_device *ibdev,
+			       const struct ib_cq_init_attr *attr,
+			       struct ib_ucontext *ib_ctx,
+			       struct ib_udata *udata);
 int ocrdma_resize_cq(struct ib_cq *, int cqe, struct ib_udata *);
 int ocrdma_destroy_cq(struct ib_cq *);
 
diff --git a/drivers/infiniband/hw/qib/qib_cq.c b/drivers/infiniband/hw/qib/qib_cq.c
index ab4e11c..2b45d0b 100644
--- a/drivers/infiniband/hw/qib/qib_cq.c
+++ b/drivers/infiniband/hw/qib/qib_cq.c
@@ -203,7 +203,7 @@ static void send_complete(struct kthread_work *work)
 /**
  * qib_create_cq - create a completion queue
  * @ibdev: the device this completion queue is attached to
- * @entries: the minimum size of the completion queue
+ * @attr: creation attributes
  * @context: unused by the QLogic_IB driver
  * @udata: user data for libibverbs.so
  *
@@ -212,16 +212,21 @@ static void send_complete(struct kthread_work *work)
  *
  * Called by ib_create_cq() in the generic verbs code.
  */
-struct ib_cq *qib_create_cq(struct ib_device *ibdev, int entries,
-			    int comp_vector, struct ib_ucontext *context,
+struct ib_cq *qib_create_cq(struct ib_device *ibdev,
+			    const struct ib_cq_init_attr *attr,
+			    struct ib_ucontext *context,
 			    struct ib_udata *udata)
 {
+	int entries = attr->cqe;
 	struct qib_ibdev *dev = to_idev(ibdev);
 	struct qib_cq *cq;
 	struct qib_cq_wc *wc;
 	struct ib_cq *ret;
 	u32 sz;
 
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	if (entries < 1 || entries > ib_qib_max_cqes) {
 		ret = ERR_PTR(-EINVAL);
 		goto done;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bfc8948..e9b26a4 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -1007,8 +1007,9 @@ void qib_cq_enter(struct qib_cq *cq, struct ib_wc *entry, int sig);
 
 int qib_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry);
 
-struct ib_cq *qib_create_cq(struct ib_device *ibdev, int entries,
-			    int comp_vector, struct ib_ucontext *context,
+struct ib_cq *qib_create_cq(struct ib_device *ibdev,
+			    const struct ib_cq_init_attr *attr,
+			    struct ib_ucontext *context,
 			    struct ib_udata *udata);
 
 int qib_destroy_cq(struct ib_cq *ibcq);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 53bd6a2..2b3f7e3 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -570,13 +570,17 @@ int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	return status;
 }
 
-struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev, int entries,
-					int vector, struct ib_ucontext *context,
-					struct ib_udata *udata)
+struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev,
+				 const struct ib_cq_init_attr *attr,
+				 struct ib_ucontext *context,
+				 struct ib_udata *udata)
 {
 	struct ib_cq *cq;
 
 	usnic_dbg("\n");
+	if (attr->flags)
+		return ERR_PTR(-EINVAL);
+
 	cq = kzalloc(sizeof(*cq), GFP_KERNEL);
 	if (!cq)
 		return ERR_PTR(-EBUSY);
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index bb864f5..38eb9f5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -44,9 +44,10 @@ struct ib_qp *usnic_ib_create_qp(struct ib_pd *pd,
 int usnic_ib_destroy_qp(struct ib_qp *qp);
 int usnic_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 				int attr_mask, struct ib_udata *udata);
-struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev, int entries,
-					int vector, struct ib_ucontext *context,
-					struct ib_udata *udata);
+struct ib_cq *usnic_ib_create_cq(struct ib_device *ibdev,
+				 const struct ib_cq_init_attr *attr,
+				 struct ib_ucontext *context,
+				 struct ib_udata *udata);
 int usnic_ib_destroy_cq(struct ib_cq *cq);
 struct ib_mr *usnic_ib_reg_mr(struct ib_pd *pd, u64 start, u64 length,
 				u64 virt_addr, int access_flags,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..20aab36 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -166,6 +166,12 @@ struct ib_odp_caps {
 	} per_transport_caps;
 };
 
+struct ib_cq_init_attr {
+	unsigned int	cqe;
+	int		comp_vector;
+	u32		flags;
+};
+
 struct ib_device_attr {
 	u64			fw_ver;
 	__be64			sys_image_guid;
@@ -1561,8 +1567,8 @@ struct ib_device {
 	int                        (*post_recv)(struct ib_qp *qp,
 						struct ib_recv_wr *recv_wr,
 						struct ib_recv_wr **bad_recv_wr);
-	struct ib_cq *             (*create_cq)(struct ib_device *device, int cqe,
-						int comp_vector,
+	struct ib_cq *             (*create_cq)(struct ib_device *device,
+						const struct ib_cq_init_attr *attr,
 						struct ib_ucontext *context,
 						struct ib_udata *udata);
 	int                        (*modify_cq)(struct ib_cq *cq, u16 cq_count,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
