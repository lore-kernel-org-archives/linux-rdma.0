From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 3/4] providers: Move all verbs_device ops into struct verbs_device_ops
Date: Tue, 28 Feb 2017 14:31:36 -0700
Message-ID: <1488317497-538-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1488317497-538-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488317497-538-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This makes the ibv_device->ops stuff unused, so delete those
public names to prevent anyone from using it.

Drivers that use ibv_register_driver just get some simple renames,
drivers that used verbs_register_driver get their ops structure back,
using the new context API pointers.

This makes further extension of the drivers ops really easy and
clear. We can use this simple approach now that the provider
API is private.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/compat-1_0.c            |  2 +-
 libibverbs/device.c                | 12 ++++++------
 libibverbs/driver.h                | 28 ++++++++++++++++++++--------
 libibverbs/init.c                  |  5 +++--
 libibverbs/verbs.h                 |  9 +++++----
 providers/cxgb3/iwch.c             |  4 ++--
 providers/cxgb4/dev.c              |  4 ++--
 providers/hfi1verbs/hfiverbs.c     |  4 ++--
 providers/hns/hns_roce_u.c         |  4 ++--
 providers/i40iw/i40iw_umain.c      |  4 ++--
 providers/ipathverbs/ipathverbs.c  |  4 ++--
 providers/mlx4/mlx4.c              |  9 ++++++---
 providers/mlx5/mlx5.c              |  9 +++++++--
 providers/mthca/mthca.c            |  4 ++--
 providers/nes/nes_umain.c          |  4 ++--
 providers/ocrdma/ocrdma_main.c     |  4 ++--
 providers/qedr/qelr_main.c         |  4 ++--
 providers/rxe/rxe.c                |  4 ++--
 providers/vmw_pvrdma/pvrdma_main.c |  4 ++--
 19 files changed, 72 insertions(+), 50 deletions(-)

diff --git a/libibverbs/compat-1_0.c b/libibverbs/compat-1_0.c
index d9bac536c85ebd..4978b8e9aa45f3 100644
--- a/libibverbs/compat-1_0.c
+++ b/libibverbs/compat-1_0.c
@@ -161,7 +161,7 @@ struct ibv_device_1_0 {
 	void		       *obsolete_sysfs_dev;
 	void		       *obsolete_sysfs_ibdev;
 	struct ibv_device      *real_device; /* was obsolete driver member */
-	struct ibv_device_ops	ops;
+	struct _ibv_device_ops	_ops;
 };
 
 struct ibv_context_ops_1_0 {
diff --git a/libibverbs/device.c b/libibverbs/device.c
index c7f39d57681170..e930a6c94a1e7a 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -173,8 +173,8 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	if (cmd_fd < 0)
 		return NULL;
 
-	if (!verbs_device) {
-		context = device->ops.alloc_context(device, cmd_fd);
+	if (!verbs_device->ops->init_context) {
+		context = verbs_device->ops->alloc_context(device, cmd_fd);
 		if (!context)
 			goto err;
 	} else {
@@ -200,7 +200,7 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 		context_ex->sz = sizeof(*context_ex);
 
 		context = &context_ex->context;
-		ret = verbs_device->init_context(verbs_device, context, cmd_fd);
+		ret = verbs_device->ops->init_context(verbs_device, context, cmd_fd);
 		if (ret)
 			goto verbs_err;
 		/*
@@ -245,15 +245,15 @@ int __ibv_close_device(struct ibv_context *context)
 	int cmd_fd   = context->cmd_fd;
 	int cq_fd    = -1;
 	struct verbs_context *context_ex;
+	struct verbs_device *verbs_device = verbs_get_device(context->device);
 
 	context_ex = verbs_get_ctx(context);
 	if (context_ex) {
-		struct verbs_device *verbs_device = verbs_get_device(context->device);
-		verbs_device->uninit_context(verbs_device, context);
+		verbs_device->ops->uninit_context(verbs_device, context);
 		free(context_ex->priv);
 		free(context_ex);
 	} else {
-		context->device->ops.free_context(context);
+		verbs_device->ops->free_context(context);
 	}
 
 	close(async_fd);
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 9e7f02ca30190c..34820af16e7fe1 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -53,6 +53,8 @@
  */
 #define IBV_DEVICE_LIBRARY_EXTENSION rdmav2
 
+struct verbs_device;
+
 enum verbs_xrcd_mask {
 	VERBS_XRCD_HANDLE	= 1 << 0,
 	VERBS_XRCD_RESERVED	= 1 << 1
@@ -98,21 +100,31 @@ struct verbs_qp {
 };
 
 /* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
+struct verbs_device_ops {
+	/* Old interface, do not use in new code. */
+	struct ibv_context *(*alloc_context)(struct ibv_device *device,
+					     int cmd_fd);
+	void (*free_context)(struct ibv_context *context);
+
+	/* New interface */
+	int (*init_context)(struct verbs_device *device,
+			    struct ibv_context *ctx, int cmd_fd);
+	void (*uninit_context)(struct verbs_device *device,
+			       struct ibv_context *ctx);
+};
+
+/* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
 struct verbs_device {
 	struct ibv_device device; /* Must be first */
+	const struct verbs_device_ops *ops;
 	size_t	sz;
 	size_t	size_of_context;
-	int	(*init_context)(struct verbs_device *device,
-				struct ibv_context *ctx, int cmd_fd);
-	void	(*uninit_context)(struct verbs_device *device,
-				struct ibv_context *ctx);
 };
 
-static inline struct verbs_device *verbs_get_device(
-					const struct ibv_device *dev)
+static inline struct verbs_device *
+verbs_get_device(const struct ibv_device *dev)
 {
-	return (dev->ops.alloc_context) ?
-		NULL : container_of(dev, struct verbs_device, device);
+	return container_of(dev, struct verbs_device, device);
 }
 
 typedef struct verbs_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 11c2a587abf745..8e059546cdb5af 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -45,6 +45,7 @@
 #include <sys/resource.h>
 #include <dirent.h>
 #include <errno.h>
+#include <assert.h>
 
 #include <util/util.h>
 #include "ibverbs.h"
@@ -394,8 +395,8 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 			return NULL;
 
 		dev = &vdev->device;
-		dev->ops.alloc_context = NULL;
-		dev->ops.free_context = NULL;
+		assert(dev->_ops._dummy1 == NULL);
+		assert(dev->_ops._dummy2 == NULL);
 	}
 
 	if (ibv_read_sysfs_file(sysfs_dev->ibdev_path, "node_type", value, sizeof value) < 0) {
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index a6c541b8020685..25f4ededdb6d63 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -1304,9 +1304,10 @@ struct ibv_flow {
 struct ibv_device;
 struct ibv_context;
 
-struct ibv_device_ops {
-	struct ibv_context *	(*alloc_context)(struct ibv_device *device, int cmd_fd);
-	void			(*free_context)(struct ibv_context *context);
+/* Obsolete, never used, do not touch */
+struct _ibv_device_ops {
+	struct ibv_context *	(*_dummy1)(struct ibv_device *device, int cmd_fd);
+	void			(*_dummy2)(struct ibv_context *context);
 };
 
 enum {
@@ -1315,7 +1316,7 @@ enum {
 };
 
 struct ibv_device {
-	struct ibv_device_ops	ops;
+	struct _ibv_device_ops	_ops;
 	enum ibv_node_type	node_type;
 	enum ibv_transport_type	transport_type;
 	/* Name of underlying kernel IB device, eg "mthca0" */
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 6e60949f39dcc1..776c42c444ea36 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -166,7 +166,7 @@ static void iwch_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops iwch_dev_ops = {
+static struct verbs_device_ops iwch_dev_ops = {
 	.alloc_context = iwch_alloc_context,
 	.free_context = iwch_free_context
 };
@@ -251,7 +251,7 @@ found:
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.device.ops = iwch_dev_ops;
+	dev->ibv_dev.ops = &iwch_dev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->abi_version = abi_version;
 
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index ec7fa53de50a89..8488c02830d56f 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -220,7 +220,7 @@ static void c4iw_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops c4iw_dev_ops = {
+static struct verbs_device_ops c4iw_dev_ops = {
 	.alloc_context = c4iw_alloc_context,
 	.free_context = c4iw_free_context
 };
@@ -470,7 +470,7 @@ found:
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.device.ops = c4iw_dev_ops;
+	dev->ibv_dev.ops = &c4iw_dev_ops;
 	dev->chip_version = CHELSIO_CHIP_VERSION(hca_table[i].device >> 8);
 	dev->abi_version = abi_version;
 	list_node_init(&dev->list);
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index e8e777e833d0a3..82c2bd15d995eb 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -173,7 +173,7 @@ static void hfi1_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops hfi1_dev_ops = {
+static struct verbs_device_ops hfi1_dev_ops = {
 	.alloc_context	= hfi1_alloc_context,
 	.free_context	= hfi1_free_context
 };
@@ -211,7 +211,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = hfi1_dev_ops;
+	dev->ibv_dev.ops = &hfi1_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index fe13e3b940e76f..2b2fd19a41a4fe 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -173,7 +173,7 @@ static void hns_roce_free_context(struct ibv_context *ibctx)
 	context = NULL;
 }
 
-static struct ibv_device_ops hns_roce_dev_ops = {
+static struct verbs_device_ops hns_roce_dev_ops = {
 	.alloc_context = hns_roce_alloc_context,
 	.free_context	= hns_roce_free_context
 };
@@ -215,7 +215,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = hns_roce_dev_ops;
+	dev->ibv_dev.ops = &hns_roce_dev_ops;
 	dev->u_hw = (struct hns_roce_u_hw *)u_hw;
 	dev->hw_version = hw_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 69493b56dbbdb1..3d3015b7acdf3a 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -208,7 +208,7 @@ static void i40iw_ufree_context(struct ibv_context *ibctx)
 	free(iwvctx);
 }
 
-static struct ibv_device_ops i40iw_udev_ops = {
+static struct verbs_device_ops i40iw_udev_ops = {
 	.alloc_context	= i40iw_ualloc_context,
 	.free_context	= i40iw_ufree_context
 };
@@ -248,7 +248,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = i40iw_udev_ops;
+	dev->ibv_dev.ops = &i40iw_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = I40IW_HW_PAGE_SIZE;
 	return &dev->ibv_dev;
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index c45675735c10b9..7eef9dfccbcb23 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -172,7 +172,7 @@ static void ipath_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops ipath_dev_ops = {
+static struct verbs_device_ops ipath_dev_ops = {
 	.alloc_context	= ipath_alloc_context,
 	.free_context	= ipath_free_context
 };
@@ -210,7 +210,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = ipath_dev_ops;
+	dev->ibv_dev.ops = &ipath_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 8e1a0dd88b46be..229c2670b5ed85 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -263,6 +263,11 @@ static void mlx4_uninit_context(struct verbs_device *v_device,
 		       to_mdev(&v_device->device)->page_size);
 }
 
+static struct verbs_device_ops mlx4_dev_ops = {
+	.init_context = mlx4_init_context,
+	.uninit_context = mlx4_uninit_context,
+};
+
 static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
 {
 	char			value[8];
@@ -308,12 +313,10 @@ found:
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	dev->abi_version = abi_version;
 
+	dev->verbs_dev.ops = &mlx4_dev_ops;
 	dev->verbs_dev.sz = sizeof(*dev);
 	dev->verbs_dev.size_of_context =
 		sizeof(struct mlx4_context) - sizeof(struct ibv_context);
-	/* mlx4_init_context will initialize provider calls */
-	dev->verbs_dev.init_context = mlx4_init_context;
-	dev->verbs_dev.uninit_context = mlx4_uninit_context;
 
 	return &dev->verbs_dev;
 }
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 980e4dfb7a369f..bd87b4486987e8 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -900,6 +900,11 @@ static void mlx5_cleanup_context(struct verbs_device *device,
 	close_debug_file(context);
 }
 
+static struct verbs_device_ops mlx5_dev_ops = {
+	.init_context = mlx5_init_context,
+	.uninit_context = mlx5_cleanup_context,
+};
+
 static struct verbs_device *mlx5_driver_init(const char *uverbs_sys_path,
 					     int abi_version)
 {
@@ -945,11 +950,11 @@ found:
 
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	dev->driver_abi_ver = abi_version;
+
+	dev->verbs_dev.ops = &mlx5_dev_ops;
 	dev->verbs_dev.sz = sizeof(*dev);
 	dev->verbs_dev.size_of_context = sizeof(struct mlx5_context) -
 		sizeof(struct ibv_context);
-	dev->verbs_dev.init_context = mlx5_init_context;
-	dev->verbs_dev.uninit_context = mlx5_cleanup_context;
 
 	return &dev->verbs_dev;
 }
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 9dbd6610f1e61f..abff1eb707a315 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -209,7 +209,7 @@ static void mthca_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops mthca_dev_ops = {
+static struct verbs_device_ops mthca_dev_ops = {
 	.alloc_context = mthca_alloc_context,
 	.free_context  = mthca_free_context
 };
@@ -253,7 +253,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = mthca_dev_ops;
+	dev->ibv_dev.ops = &mthca_dev_ops;
 	dev->hca_type    = hca_table[i].type;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index b166c0916e4ce9..b9ec9c41a9d5d1 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -185,7 +185,7 @@ static void nes_ufree_context(struct ibv_context *ibctx)
 }
 
 
-static struct ibv_device_ops nes_udev_ops = {
+static struct verbs_device_ops nes_udev_ops = {
 	.alloc_context = nes_ualloc_context,
 	.free_context = nes_ufree_context
 };
@@ -236,7 +236,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = nes_udev_ops;
+	dev->ibv_dev.ops = &nes_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = sysconf(_SC_PAGESIZE);
 
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 8dad5ffe17694d..9e2862843fed68 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -103,7 +103,7 @@ static struct ibv_context_ops ocrdma_ctx_ops = {
 	.detach_mcast = ocrdma_detach_mcast
 };
 
-static struct ibv_device_ops ocrdma_dev_ops = {
+static struct verbs_device_ops ocrdma_dev_ops = {
 	.alloc_context = ocrdma_alloc_context,
 	.free_context = ocrdma_free_context
 };
@@ -220,7 +220,7 @@ found:
 	bzero(dev->qp_tbl, OCRDMA_MAX_QP * sizeof(struct ocrdma_qp *));
 	pthread_mutex_init(&dev->dev_lock, NULL);
 	pthread_spin_init(&dev->flush_q_lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.device.ops = ocrdma_dev_ops;
+	dev->ibv_dev.ops = &ocrdma_dev_ops;
 	list_node_init(&dev->entry);
 	pthread_mutex_lock(&ocrdma_dev_list_lock);
 	list_add_tail(&ocrdma_dev_list, &dev->entry);
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index ef192c533de350..5d14f733eea727 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -114,7 +114,7 @@ static struct ibv_context_ops qelr_ctx_ops = {
 	.async_event = qelr_async_event,
 };
 
-static struct ibv_device_ops qelr_dev_ops = {
+static struct verbs_device_ops qelr_dev_ops = {
 	.alloc_context = qelr_alloc_context,
 	.free_context = qelr_free_context
 };
@@ -272,7 +272,7 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = qelr_dev_ops;
+	dev->ibv_dev.ops = &qelr_dev_ops;
 
 	return &dev->ibv_dev;
 }
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index fba3bc719cd45a..133a1b6ba908e8 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -886,7 +886,7 @@ static void rxe_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops rxe_dev_ops = {
+static struct verbs_device_ops rxe_dev_ops = {
 	.alloc_context = rxe_alloc_context,
 	.free_context = rxe_free_context,
 };
@@ -913,7 +913,7 @@ static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
 		return NULL;
 	}
 
-	dev->ibv_dev.device.ops = rxe_dev_ops;
+	dev->ibv_dev.ops = &rxe_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index a518cacba79da3..7630134eda8e6e 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -162,7 +162,7 @@ static void pvrdma_free_context(struct ibv_context *ibctx)
 	free(context);
 }
 
-static struct ibv_device_ops pvrdma_dev_ops = {
+static struct verbs_device_ops pvrdma_dev_ops = {
 	.alloc_context = pvrdma_alloc_context,
 	.free_context  = pvrdma_free_context
 };
@@ -207,7 +207,7 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 
 	dev->abi_version = abi_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
-	dev->ibv_dev.device.ops = pvrdma_dev_ops;
+	dev->ibv_dev.ops = &pvrdma_dev_ops;
 
 	return dev;
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
