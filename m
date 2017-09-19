From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 01/10] verbs: Change verbs_register_driver to accept the ops struct directly
Date: Tue, 19 Sep 2017 15:18:42 -0600
Message-ID: <1505855931-4956-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER for
        hf1.ko" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER for
        ib_qib.ko" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is analogous to the kernel scheme where code describes a driver
with a static structure and then a helper macro registers that
driver with the core code.

In this case we have an 'ops' that is both the 'driver' and 'device'
ops.

This is preparation to add more steps to the device startup. Rework
all the providers to use this scheme.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h                | 15 ++++++++++++++-
 libibverbs/init.c                  | 20 ++++++++++----------
 providers/bnxt_re/main.c           | 17 +++++++----------
 providers/cxgb3/iwch.c             | 19 ++++++++-----------
 providers/cxgb4/dev.c              | 17 +++++++++--------
 providers/hfi1verbs/hfiverbs.c     | 19 ++++++++-----------
 providers/hns/hns_roce_u.c         | 19 ++++++++-----------
 providers/i40iw/i40iw_umain.c      | 19 ++++++++-----------
 providers/ipathverbs/ipathverbs.c  | 19 ++++++++-----------
 providers/mlx4/mlx4.c              | 19 ++++++++-----------
 providers/mlx5/mlx5.c              | 19 ++++++++-----------
 providers/mthca/mthca.c            | 19 ++++++++-----------
 providers/nes/nes_umain.c          | 26 ++++++++------------------
 providers/ocrdma/ocrdma_main.c     | 23 ++++++++---------------
 providers/qedr/qelr_main.c         | 21 ++++++++-------------
 providers/rxe/rxe.c                | 20 ++++++++------------
 providers/vmw_pvrdma/pvrdma_main.c | 19 ++++++++-----------
 17 files changed, 144 insertions(+), 186 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 887412de6327c3..f9f5cfa2308c2f 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -97,6 +97,8 @@ struct verbs_qp {
 
 /* Must change the PRIVATE IBVERBS_PRIVATE_ symbol if this is changed */
 struct verbs_device_ops {
+	const char *name;
+
 	/* Old interface, do not use in new code. */
 	struct ibv_context *(*alloc_context)(struct ibv_device *device,
 					     int cmd_fd);
@@ -107,6 +109,9 @@ struct verbs_device_ops {
 			    struct ibv_context *ctx, int cmd_fd);
 	void (*uninit_context)(struct verbs_device *device,
 			       struct ibv_context *ctx);
+
+	struct verbs_device *(*init_device)(const char *uverbs_sys_path,
+					    int abi_version);
 	void (*uninit_device)(struct verbs_device *device);
 };
 
@@ -139,7 +144,15 @@ typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_pa
 #define __make_verbs_register_driver(x)  ___make_verbs_register_driver(x)
 #define verbs_register_driver __make_verbs_register_driver(IBVERBS_PABI_VERSION)
 
-void verbs_register_driver(const char *name, verbs_driver_init_func init_func);
+void verbs_register_driver(const struct verbs_device_ops *ops);
+
+/* Macro for providers to use to supply verbs_device_ops to the core code */
+#define PROVIDER_DRIVER(drv)                                                   \
+	static __attribute__((constructor)) void drv##__register_driver(void)  \
+	{                                                                      \
+		verbs_register_driver(&drv);                                   \
+	}
+
 void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
 		       struct ibv_comp_channel *channel,
 		       void *cq_context);
diff --git a/libibverbs/init.c b/libibverbs/init.c
index e94a65b000ac4b..996406e2efa258 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -70,8 +70,7 @@ struct ibv_driver_name {
 
 struct ibv_driver {
 	struct list_node	entry;
-	const char	       *name;
-	verbs_driver_init_func	verbs_init_func;
+	const struct verbs_device_ops *ops;
 };
 
 static LIST_HEAD(driver_name_list);
@@ -164,19 +163,19 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 	return ret;
 }
 
-void verbs_register_driver(const char *name,
-			   verbs_driver_init_func verbs_init_func)
+void verbs_register_driver(const struct verbs_device_ops *ops)
 {
 	struct ibv_driver *driver;
 
 	driver = malloc(sizeof *driver);
 	if (!driver) {
-		fprintf(stderr, PFX "Warning: couldn't allocate driver for %s\n", name);
+		fprintf(stderr,
+			PFX "Warning: couldn't allocate driver for %s\n",
+			ops->name);
 		return;
 	}
 
-	driver->name            = name;
-	driver->verbs_init_func = verbs_init_func;
+	driver->ops = ops;
 
 	list_add_tail(&driver_list, &driver->entry);
 }
@@ -354,16 +353,17 @@ out:
 	closedir(conf_dir);
 }
 
-static struct verbs_device *try_driver(struct ibv_driver *driver,
+static struct verbs_device *try_driver(const struct verbs_device_ops *ops,
 				       struct ibv_sysfs_dev *sysfs_dev)
 {
 	struct verbs_device *vdev;
 	struct ibv_device *dev;
 	char value[16];
 
-	vdev = driver->verbs_init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+	vdev = ops->init_device(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
 	if (!vdev)
 		return NULL;
+	vdev->ops = ops;
 
 	atomic_init(&vdev->refcount, 1);
 	dev = &vdev->device;
@@ -415,7 +415,7 @@ static struct verbs_device *try_drivers(struct ibv_sysfs_dev *sysfs_dev)
 	struct verbs_device *dev;
 
 	list_for_each(&driver_list, driver, entry) {
-		dev = try_driver(driver, sysfs_dev);
+		dev = try_driver(driver->ops, sysfs_dev);
 		if (dev)
 			return dev;
 	}
diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index 3c21bec2ea8608..d2c2a6847e3c71 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -174,11 +174,6 @@ static void bnxt_re_uninit_context(struct verbs_device *vdev,
 	}
 }
 
-static struct verbs_device_ops bnxt_re_dev_ops = {
-	.init_context = bnxt_re_init_context,
-	.uninit_context = bnxt_re_uninit_context,
-};
-
 static struct verbs_device *bnxt_re_driver_init(const char *uverbs_sys_path,
 						int abi_version)
 {
@@ -220,12 +215,14 @@ found:
 	dev->vdev.sz = sizeof(*dev);
 	dev->vdev.size_of_context =
 		sizeof(struct bnxt_re_context) - sizeof(struct ibv_context);
-	dev->vdev.ops = &bnxt_re_dev_ops;
 
 	return &dev->vdev;
 }
 
-static __attribute__((constructor)) void bnxt_re_register_driver(void)
-{
-	verbs_register_driver("bnxt_re", bnxt_re_driver_init);
-}
+static const struct verbs_device_ops bnxt_re_dev_ops = {
+	.name = "bnxt_re",
+	.init_device = bnxt_re_driver_init,
+	.init_context = bnxt_re_init_context,
+	.uninit_context = bnxt_re_uninit_context,
+};
+PROVIDER_DRIVER(bnxt_re_dev_ops);
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 26cc7bbc3b0e64..c2423a7ee2cc32 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -173,12 +173,6 @@ static void iwch_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops iwch_dev_ops = {
-	.alloc_context = iwch_alloc_context,
-	.free_context = iwch_free_context,
-	.uninit_device = iwch_uninit_device
-};
-
 static struct verbs_device *cxgb3_driver_init(const char *uverbs_sys_path,
 					      int abi_version)
 {
@@ -259,7 +253,6 @@ found:
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = &iwch_dev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->abi_version = abi_version;
 
@@ -290,7 +283,11 @@ err1:
 	return NULL;
 }
 
-static __attribute__((constructor)) void cxgb3_register_driver(void)
-{
-	verbs_register_driver("cxgb3", cxgb3_driver_init);
-}
+static const struct verbs_device_ops iwch_dev_ops = {
+	.name = "cxgb3",
+	.init_device = cxgb3_driver_init,
+	.uninit_device = iwch_uninit_device,
+	.alloc_context = iwch_alloc_context,
+	.free_context = iwch_free_context,
+};
+PROVIDER_DRIVER(iwch_dev_ops);
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 30182cb152f83f..fea9b5527072ec 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -227,12 +227,6 @@ static void c4iw_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops c4iw_dev_ops = {
-	.alloc_context = c4iw_alloc_context,
-	.free_context = c4iw_free_context,
-	.uninit_device = c4iw_uninit_device
-};
-
 #ifdef STALL_DETECTION
 
 int stall_to;
@@ -478,7 +472,6 @@ found:
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = &c4iw_dev_ops;
 	dev->chip_version = CHELSIO_CHIP_VERSION(hca_table[i].device >> 8);
 	dev->abi_version = abi_version;
 	list_node_init(&dev->list);
@@ -515,12 +508,20 @@ found:
 	return &dev->ibv_dev;
 }
 
+static const struct verbs_device_ops c4iw_dev_ops = {
+	.name = "cxgb4",
+	.init_device = cxgb4_driver_init,
+	.uninit_device = c4iw_uninit_device,
+	.alloc_context = c4iw_alloc_context,
+	.free_context = c4iw_free_context,
+};
+
 static __attribute__((constructor)) void cxgb4_register_driver(void)
 {
 	c4iw_page_size = sysconf(_SC_PAGESIZE);
 	c4iw_page_shift = long_log2(c4iw_page_size);
 	c4iw_page_mask = ~(c4iw_page_size - 1);
-	verbs_register_driver("cxgb4", cxgb4_driver_init);
+	verbs_register_driver(&c4iw_dev_ops);
 }
 
 #ifdef STATS
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index b5d0099585cd9a..247831eb211804 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -180,12 +180,6 @@ static void hf11_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops hfi1_dev_ops = {
-	.alloc_context	= hfi1_alloc_context,
-	.free_context	= hfi1_free_context,
-	.uninit_device  = hf11_uninit_device
-};
-
 static struct verbs_device *hfi1_driver_init(const char *uverbs_sys_path,
 					     int abi_version)
 {
@@ -219,13 +213,16 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &hfi1_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
 }
 
-static __attribute__((constructor)) void hfi1_register_driver(void)
-{
-	verbs_register_driver("hfi1verbs", hfi1_driver_init);
-}
+static const struct verbs_device_ops hfi1_dev_ops = {
+	.name = "hfi1verbs",
+	.init_device = hfi1_driver_init,
+	.uninit_device  = hf11_uninit_device,
+	.alloc_context = hfi1_alloc_context,
+	.free_context = hfi1_free_context,
+};
+PROVIDER_DRIVER(hfi1_dev_ops);
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 7dae5fdc71e332..fe2d009ebe3737 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -180,12 +180,6 @@ static void hns_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops hns_roce_dev_ops = {
-	.alloc_context = hns_roce_alloc_context,
-	.free_context	= hns_roce_free_context,
-	.uninit_device = hns_uninit_device
-};
-
 static struct verbs_device *hns_roce_driver_init(const char *uverbs_sys_path,
 						 int abi_version)
 {
@@ -223,14 +217,17 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &hns_roce_dev_ops;
 	dev->u_hw = (struct hns_roce_u_hw *)u_hw;
 	dev->hw_version = hw_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	return &dev->ibv_dev;
 }
 
-static __attribute__((constructor)) void hns_roce_register_driver(void)
-{
-	verbs_register_driver("hns", hns_roce_driver_init);
-}
+static const struct verbs_device_ops hns_roce_dev_ops = {
+	.name = "hns",
+	.init_device = hns_roce_driver_init,
+	.uninit_device = hns_uninit_device,
+	.alloc_context = hns_roce_alloc_context,
+	.free_context = hns_roce_free_context,
+};
+PROVIDER_DRIVER(hns_roce_dev_ops);
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 3b7aebba06a4fe..90d37651d1f702 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -215,12 +215,6 @@ static void i40iw_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops i40iw_udev_ops = {
-	.alloc_context	= i40iw_ualloc_context,
-	.free_context	= i40iw_ufree_context,
-	.uninit_device  = i40iw_uninit_device
-};
-
 /**
  * i40iw_driver_init - create device struct and provide callback routines for user context
  * @uverbs_sys_path: sys path
@@ -256,13 +250,16 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &i40iw_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = I40IW_HW_PAGE_SIZE;
 	return &dev->ibv_dev;
 }
 
-static __attribute__ ((constructor)) void i40iw_register_driver(void)
-{
-	verbs_register_driver("i40iw", i40iw_driver_init);
-}
+static const struct verbs_device_ops i40iw_udev_ops = {
+	.name = "i40iw",
+	.init_device = i40iw_driver_init,
+	.uninit_device  = i40iw_uninit_device,
+	.alloc_context = i40iw_ualloc_context,
+	.free_context = i40iw_ufree_context,
+};
+PROVIDER_DRIVER(i40iw_udev_ops);
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 96bc4d7f281a1f..ebdf5b828e1784 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -179,12 +179,6 @@ static void ipath_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops ipath_dev_ops = {
-	.alloc_context	= ipath_alloc_context,
-	.free_context	= ipath_free_context,
-	.uninit_device  = ipath_uninit_device
-};
-
 static struct verbs_device *ipath_driver_init(const char *uverbs_sys_path,
 					      int abi_version)
 {
@@ -218,13 +212,16 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &ipath_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
 }
 
-static __attribute__((constructor)) void ipath_register_driver(void)
-{
-	verbs_register_driver("ipathverbs", ipath_driver_init);
-}
+static const struct verbs_device_ops ipath_dev_ops = {
+	.name = "ipathverbs",
+	.init_device = ipath_driver_init,
+	.uninit_device  = ipath_uninit_device,
+	.alloc_context = ipath_alloc_context,
+	.free_context = ipath_free_context,
+};
+PROVIDER_DRIVER(ipath_dev_ops);
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index 3571234b27578d..0eefa40af16d83 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -286,12 +286,6 @@ static void mlx4_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops mlx4_dev_ops = {
-	.init_context = mlx4_init_context,
-	.uninit_context = mlx4_uninit_context,
-	.uninit_device = mlx4_uninit_device
-};
-
 static struct verbs_device *mlx4_driver_init(const char *uverbs_sys_path, int abi_version)
 {
 	char			value[8];
@@ -337,7 +331,6 @@ found:
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	dev->abi_version = abi_version;
 
-	dev->verbs_dev.ops = &mlx4_dev_ops;
 	dev->verbs_dev.sz = sizeof(*dev);
 	dev->verbs_dev.size_of_context =
 		sizeof(struct mlx4_context) - sizeof(struct ibv_context);
@@ -345,10 +338,14 @@ found:
 	return &dev->verbs_dev;
 }
 
-static __attribute__((constructor)) void mlx4_register_driver(void)
-{
-	verbs_register_driver("mlx4", mlx4_driver_init);
-}
+static const struct verbs_device_ops mlx4_dev_ops = {
+	.name = "mlx4",
+	.init_device = mlx4_driver_init,
+	.uninit_device = mlx4_uninit_device,
+	.init_context = mlx4_init_context,
+	.uninit_context = mlx4_uninit_context,
+};
+PROVIDER_DRIVER(mlx4_dev_ops);
 
 static int mlx4dv_get_qp(struct ibv_qp *qp_in,
 			 struct mlx4dv_qp *qp_out)
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index e7adf1483ccfcd..68cca7cde97ef2 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -1026,12 +1026,6 @@ static void mlx5_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops mlx5_dev_ops = {
-	.init_context = mlx5_init_context,
-	.uninit_context = mlx5_cleanup_context,
-	.uninit_device = mlx5_uninit_device
-};
-
 static struct verbs_device *mlx5_driver_init(const char *uverbs_sys_path,
 					     int abi_version)
 {
@@ -1078,7 +1072,6 @@ found:
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 	dev->driver_abi_ver = abi_version;
 
-	dev->verbs_dev.ops = &mlx5_dev_ops;
 	dev->verbs_dev.sz = sizeof(*dev);
 	dev->verbs_dev.size_of_context = sizeof(struct mlx5_context) -
 		sizeof(struct ibv_context);
@@ -1086,7 +1079,11 @@ found:
 	return &dev->verbs_dev;
 }
 
-static __attribute__((constructor)) void mlx5_register_driver(void)
-{
-	verbs_register_driver("mlx5", mlx5_driver_init);
-}
+static const struct verbs_device_ops mlx5_dev_ops = {
+	.name = "mlx5",
+	.init_device = mlx5_driver_init,
+	.uninit_device = mlx5_uninit_device,
+	.init_context = mlx5_init_context,
+	.uninit_context = mlx5_cleanup_context,
+};
+PROVIDER_DRIVER(mlx5_dev_ops);
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 62c912a312f04f..7194539b2d6ab1 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -216,12 +216,6 @@ static void mthca_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops mthca_dev_ops = {
-	.alloc_context = mthca_alloc_context,
-	.free_context  = mthca_free_context,
-	.uninit_device = mthca_uninit_device
-};
-
 static struct verbs_device *mthca_driver_init(const char *uverbs_sys_path,
 					    int abi_version)
 {
@@ -261,14 +255,17 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &mthca_dev_ops;
 	dev->hca_type    = hca_table[i].type;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 
 	return &dev->ibv_dev;
 }
 
-static __attribute__((constructor)) void mthca_register_driver(void)
-{
-	verbs_register_driver("mthca", mthca_driver_init);
-}
+static const struct verbs_device_ops mthca_dev_ops = {
+	.name = "mthca",
+	.init_device = mthca_driver_init,
+	.uninit_device = mthca_uninit_device,
+	.alloc_context = mthca_alloc_context,
+	.free_context = mthca_free_context,
+};
+PROVIDER_DRIVER(mthca_dev_ops);
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index c9ce700749555d..d02e010d2524a2 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -191,13 +191,6 @@ static void nes_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops nes_udev_ops = {
-	.alloc_context = nes_ualloc_context,
-	.free_context = nes_ufree_context,
-	.uninit_device = nes_uninit_device
-};
-
-
 /**
  * nes_driver_init
  */
@@ -243,7 +236,6 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &nes_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = sysconf(_SC_PAGESIZE);
 
@@ -252,13 +244,11 @@ found:
 	return &dev->ibv_dev;
 }
 
-
-/**
- * nes_register_driver
- */
-static __attribute__((constructor)) void nes_register_driver(void)
-{
-	/* fprintf(stderr, PFX "nes_register_driver: call ibv_register_driver()\n"); */
-
-	verbs_register_driver("nes", nes_driver_init);
-}
+static const struct verbs_device_ops nes_udev_ops = {
+	.name = "nes",
+	.init_device = nes_driver_init,
+	.uninit_device = nes_uninit_device,
+	.alloc_context = nes_ualloc_context,
+	.free_context = nes_ufree_context,
+};
+PROVIDER_DRIVER(nes_udev_ops);
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 8888067761ab37..09c00d21ce2af6 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -107,12 +107,6 @@ static void ocrdma_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops ocrdma_dev_ops = {
-	.alloc_context = ocrdma_alloc_context,
-	.free_context = ocrdma_free_context,
-	.uninit_device = ocrdma_uninit_device
-};
-
 /*
  * ocrdma_alloc_context
  */
@@ -225,18 +219,17 @@ found:
 	bzero(dev->qp_tbl, OCRDMA_MAX_QP * sizeof(struct ocrdma_qp *));
 	pthread_mutex_init(&dev->dev_lock, NULL);
 	pthread_spin_init(&dev->flush_q_lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = &ocrdma_dev_ops;
 	return &dev->ibv_dev;
 qp_err:
 	free(dev);
 	return NULL;
 }
 
-/*
- * ocrdma_register_driver
- */
-static __attribute__ ((constructor))
-void ocrdma_register_driver(void)
-{
-	verbs_register_driver("ocrdma", ocrdma_driver_init);
-}
+static const struct verbs_device_ops ocrdma_dev_ops = {
+	.name = "ocrdma",
+	.init_device = ocrdma_driver_init,
+	.uninit_device = ocrdma_uninit_device,
+	.alloc_context = ocrdma_alloc_context,
+	.free_context = ocrdma_free_context,
+};
+PROVIDER_DRIVER(ocrdma_dev_ops);
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 4d4390bdaf9a7c..0be4a8c82a1e05 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -115,12 +115,6 @@ static void qelr_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops qelr_dev_ops = {
-	.alloc_context = qelr_alloc_context,
-	.free_context = qelr_free_context,
-	.uninit_device = qelr_uninit_device
-};
-
 static void qelr_open_debug_file(struct qelr_devctx *ctx)
 {
 	char *env;
@@ -274,13 +268,14 @@ found:
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &qelr_dev_ops;
-
 	return &dev->ibv_dev;
 }
 
-static __attribute__ ((constructor))
-void qelr_register_driver(void)
-{
-	verbs_register_driver("qelr", qelr_driver_init);
-}
+static const struct verbs_device_ops qelr_dev_ops = {
+	.name = "qelr",
+	.init_device = qelr_driver_init,
+	.uninit_device = qelr_uninit_device,
+	.alloc_context = qelr_alloc_context,
+	.free_context = qelr_free_context,
+};
+PROVIDER_DRIVER(qelr_dev_ops);
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 21820f9fcea561..655800ec3410fd 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -893,12 +893,6 @@ static void rxe_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops rxe_dev_ops = {
-	.alloc_context = rxe_alloc_context,
-	.free_context = rxe_free_context,
-	.uninit_device = rxe_uninit_device
-};
-
 static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
 					    int abi_version)
 {
@@ -921,14 +915,16 @@ static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = &rxe_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
 }
 
-static __attribute__ ((constructor))
-void rxe_register_driver(void)
-{
-	verbs_register_driver("rxe", rxe_driver_init);
-}
+static const struct verbs_device_ops rxe_dev_ops = {
+	.name = "rxe",
+	.init_device = rxe_driver_init,
+	.uninit_device = rxe_uninit_device,
+	.alloc_context = rxe_alloc_context,
+	.free_context = rxe_free_context,
+};
+PROVIDER_DRIVER(rxe_dev_ops);
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index d3886634d7ae7b..75b9296c6e24e3 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -169,12 +169,6 @@ static void pvrdma_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static struct verbs_device_ops pvrdma_dev_ops = {
-	.alloc_context = pvrdma_alloc_context,
-	.free_context  = pvrdma_free_context,
-	.uninit_device = pvrdma_uninit_device
-};
-
 static struct pvrdma_device *pvrdma_driver_init_shared(
 						const char *uverbs_sys_path,
 						int abi_version)
@@ -215,7 +209,6 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 
 	dev->abi_version = abi_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
-	dev->ibv_dev.ops = &pvrdma_dev_ops;
 
 	return dev;
 }
@@ -231,7 +224,11 @@ static struct verbs_device *pvrdma_driver_init(const char *uverbs_sys_path,
 	return &dev->ibv_dev;
 }
 
-static __attribute__((constructor)) void pvrdma_register_driver(void)
-{
-	verbs_register_driver("pvrdma", pvrdma_driver_init);
-}
+static const struct verbs_device_ops pvrdma_dev_ops = {
+	.name = "pvrdma",
+	.init_device = pvrdma_driver_init,
+	.uninit_device = pvrdma_uninit_device,
+	.alloc_context = pvrdma_alloc_context,
+	.free_context  = pvrdma_free_context,
+};
+PROVIDER_DRIVER(pvrdma_dev_ops);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
