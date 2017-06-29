From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 5/5] providers: Add support for uninit_device for all providers
Date: Thu, 29 Jun 2017 17:00:16 +0300
Message-ID: <1498744816-23354-6-git-send-email-yishaih@mellanox.com>
References: <1498744816-23354-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498744816-23354-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When libibvers calls to verbs_init_func of the provider,
then the provider allocates the verbs_device.

Add to all providers a function to free this memory once it's
called.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/cxgb3/iwch.c             | 10 +++++++++-
 providers/cxgb4/dev.c              | 10 +++++++++-
 providers/hfi1verbs/hfiverbs.c     | 10 +++++++++-
 providers/hns/hns_roce_u.c         | 10 +++++++++-
 providers/i40iw/i40iw_umain.c      | 10 +++++++++-
 providers/ipathverbs/ipathverbs.c  | 10 +++++++++-
 providers/mlx4/mlx4.c              |  8 ++++++++
 providers/mlx5/mlx5.c              |  8 ++++++++
 providers/mthca/mthca.c            | 10 +++++++++-
 providers/nes/nes_umain.c          |  9 ++++++++-
 providers/ocrdma/ocrdma_main.c     | 10 +++++++++-
 providers/qedr/qelr_main.c         | 10 +++++++++-
 providers/rxe/rxe.c                |  8 ++++++++
 providers/vmw_pvrdma/pvrdma_main.c | 10 +++++++++-
 14 files changed, 122 insertions(+), 11 deletions(-)

diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index be3905c..26cc7bb 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -166,9 +166,17 @@ static void iwch_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void iwch_uninit_device(struct verbs_device *verbs_device)
+{
+	struct iwch_device *dev = to_iwch_dev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops iwch_dev_ops = {
 	.alloc_context = iwch_alloc_context,
-	.free_context = iwch_free_context
+	.free_context = iwch_free_context,
+	.uninit_device = iwch_uninit_device
 };
 
 static struct verbs_device *cxgb3_driver_init(const char *uverbs_sys_path,
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 1474378..30182cb 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -220,9 +220,17 @@ static void c4iw_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void c4iw_uninit_device(struct verbs_device *verbs_device)
+{
+	struct c4iw_dev *dev = to_c4iw_dev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops c4iw_dev_ops = {
 	.alloc_context = c4iw_alloc_context,
-	.free_context = c4iw_free_context
+	.free_context = c4iw_free_context,
+	.uninit_device = c4iw_uninit_device
 };
 
 #ifdef STALL_DETECTION
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index b27df3d..b5d0099 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -173,9 +173,17 @@ static void hfi1_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void hf11_uninit_device(struct verbs_device *verbs_device)
+{
+	struct hfi1_device *dev = to_idev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops hfi1_dev_ops = {
 	.alloc_context	= hfi1_alloc_context,
-	.free_context	= hfi1_free_context
+	.free_context	= hfi1_free_context,
+	.uninit_device  = hf11_uninit_device
 };
 
 static struct verbs_device *hfi1_driver_init(const char *uverbs_sys_path,
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index a080ca6..7dae5fd 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -173,9 +173,17 @@ static void hns_roce_free_context(struct ibv_context *ibctx)
 	context = NULL;
 }
 
+static void hns_uninit_device(struct verbs_device *verbs_device)
+{
+	struct hns_roce_device *dev = to_hr_dev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops hns_roce_dev_ops = {
 	.alloc_context = hns_roce_alloc_context,
-	.free_context	= hns_roce_free_context
+	.free_context	= hns_roce_free_context,
+	.uninit_device = hns_uninit_device
 };
 
 static struct verbs_device *hns_roce_driver_init(const char *uverbs_sys_path,
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 5946b7c..3b7aebb 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -208,9 +208,17 @@ static void i40iw_ufree_context(struct ibv_context *ibctx)
 	free(iwvctx);
 }
 
+static void i40iw_uninit_device(struct verbs_device *verbs_device)
+{
+	struct i40iw_udevice *dev = to_i40iw_udev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops i40iw_udev_ops = {
 	.alloc_context	= i40iw_ualloc_context,
-	.free_context	= i40iw_ufree_context
+	.free_context	= i40iw_ufree_context,
+	.uninit_device  = i40iw_uninit_device
 };
 
 /**
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 0cb6abf..96bc4d7 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -172,9 +172,17 @@ static void ipath_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void ipath_uninit_device(struct verbs_device *verbs_device)
+{
+	struct ipath_device *dev = to_idev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops ipath_dev_ops = {
 	.alloc_context	= ipath_alloc_context,
-	.free_context	= ipath_free_context
+	.free_context	= ipath_free_context,
+	.uninit_device  = ipath_uninit_device
 };
 
 static struct verbs_device *ipath_driver_init(const char *uverbs_sys_path,
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index b798b37..d711df3 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -262,9 +262,17 @@ static void mlx4_uninit_context(struct verbs_device *v_device,
 		       to_mdev(&v_device->device)->page_size);
 }
 
+static void mlx4_uninit_device(struct verbs_device *verbs_device)
+{
+	struct mlx4_device *dev = to_mdev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops mlx4_dev_ops = {
 	.init_context = mlx4_init_context,
 	.uninit_context = mlx4_uninit_context,
+	.uninit_device = mlx4_uninit_device
 };
 
 static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 99ca1ae..ede91cb 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -965,9 +965,17 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	close_debug_file(context);
 }
 
+static void mlx5_uninit_device(struct verbs_device *verbs_device)
+{
+	struct mlx5_device *dev = to_mdev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops mlx5_dev_ops = {
 	.init_context = mlx5_init_context,
 	.uninit_context = mlx5_cleanup_context,
+	.uninit_device = mlx5_uninit_device
 };
 
 static struct verbs_device *mlx5_driver_init(const char *uverbs_sys_path,
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 96e7944..62c912a 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -209,9 +209,17 @@ static void mthca_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void mthca_uninit_device(struct verbs_device *verbs_device)
+{
+	struct mthca_device *dev = to_mdev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops mthca_dev_ops = {
 	.alloc_context = mthca_alloc_context,
-	.free_context  = mthca_free_context
+	.free_context  = mthca_free_context,
+	.uninit_device = mthca_uninit_device
 };
 
 static struct verbs_device *mthca_driver_init(const char *uverbs_sys_path,
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index 20ddc8d..c9ce700 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -184,10 +184,17 @@ static void nes_ufree_context(struct ibv_context *ibctx)
 	free(nesvctx);
 }
 
+static void nes_uninit_device(struct verbs_device *verbs_device)
+{
+	struct nes_udevice *dev = to_nes_udev(&verbs_device->device);
+
+	free(dev);
+}
 
 static struct verbs_device_ops nes_udev_ops = {
 	.alloc_context = nes_ualloc_context,
-	.free_context = nes_ufree_context
+	.free_context = nes_ufree_context,
+	.uninit_device = nes_uninit_device
 };
 
 
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 2f22e8f..5916306 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -103,9 +103,17 @@ static struct ibv_context_ops ocrdma_ctx_ops = {
 	.detach_mcast = ocrdma_detach_mcast
 };
 
+static void ocrdma_uninit_device(struct verbs_device *verbs_device)
+{
+	struct ocrdma_device *dev = get_ocrdma_dev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops ocrdma_dev_ops = {
 	.alloc_context = ocrdma_alloc_context,
-	.free_context = ocrdma_free_context
+	.free_context = ocrdma_free_context,
+	.uninit_device = ocrdma_uninit_device
 };
 
 /*
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 9f3feda..4d4390b 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -108,9 +108,17 @@ static struct ibv_context_ops qelr_ctx_ops = {
 	.async_event = qelr_async_event,
 };
 
+static void qelr_uninit_device(struct verbs_device *verbs_device)
+{
+	struct qelr_device *dev = get_qelr_dev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops qelr_dev_ops = {
 	.alloc_context = qelr_alloc_context,
-	.free_context = qelr_free_context
+	.free_context = qelr_free_context,
+	.uninit_device = qelr_uninit_device
 };
 
 static void qelr_open_debug_file(struct qelr_devctx *ctx)
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 775caf0..21820f9 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -886,9 +886,17 @@ static void rxe_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void rxe_uninit_device(struct verbs_device *verbs_device)
+{
+	struct rxe_device *dev = to_rdev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops rxe_dev_ops = {
 	.alloc_context = rxe_alloc_context,
 	.free_context = rxe_free_context,
+	.uninit_device = rxe_uninit_device
 };
 
 static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 047f492..d388663 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -162,9 +162,17 @@ static void pvrdma_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
+static void pvrdma_uninit_device(struct verbs_device *verbs_device)
+{
+	struct pvrdma_device *dev = to_vdev(&verbs_device->device);
+
+	free(dev);
+}
+
 static struct verbs_device_ops pvrdma_dev_ops = {
 	.alloc_context = pvrdma_alloc_context,
-	.free_context  = pvrdma_free_context
+	.free_context  = pvrdma_free_context,
+	.uninit_device = pvrdma_uninit_device
 };
 
 static struct pvrdma_device *pvrdma_driver_init_shared(
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
