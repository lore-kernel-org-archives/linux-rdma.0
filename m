From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 4/4] verbs: Remove ibv_register_driver
Date: Tue, 28 Feb 2017 14:31:37 -0700
Message-ID: <1488317497-538-5-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1488317497-538-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488317497-538-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is now identical to verbs_register driver, so use the new name.
We prefer verbs_register_driver as a name because of the symver compat
hack for ibv_register_driver.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/compat-1_0.c            |  2 +-
 libibverbs/driver.h                |  5 +----
 libibverbs/init.c                  | 39 ++++++++------------------------------
 providers/cxgb3/iwch.c             |  2 +-
 providers/cxgb4/dev.c              |  2 +-
 providers/hfi1verbs/hfiverbs.c     |  2 +-
 providers/hns/hns_roce_u.c         |  2 +-
 providers/i40iw/i40iw_umain.c      |  2 +-
 providers/ipathverbs/ipathverbs.c  |  2 +-
 providers/mthca/mthca.c            |  2 +-
 providers/nes/nes_umain.c          |  2 +-
 providers/ocrdma/ocrdma_main.c     |  2 +-
 providers/qedr/qelr_main.c         |  2 +-
 providers/rxe/rxe.c                |  2 +-
 providers/vmw_pvrdma/pvrdma_main.c |  2 +-
 15 files changed, 22 insertions(+), 48 deletions(-)

diff --git a/libibverbs/compat-1_0.c b/libibverbs/compat-1_0.c
index 4978b8e9aa45f3..4155a92060e4bf 100644
--- a/libibverbs/compat-1_0.c
+++ b/libibverbs/compat-1_0.c
@@ -940,7 +940,7 @@ symver(__ibv_detach_mcast_1_0, ibv_detach_mcast, IBVERBS_1.0);
 
 typedef struct ibv_device *(*ibv_driver_init_func_1_1)(const char *uverbs_sys_path,
 						       int abi_version);
-void __ibv_register_driver_1_1(const char *name, ibv_driver_init_func init_func_1_1)
+void __ibv_register_driver_1_1(const char *name, ibv_driver_init_func_1_1 init_func)
 {
 	/* The driver interface is private as of rdma-core 13. This stub is
 	 * left to preserve dynamic-link compatability with old libfabrics
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 34820af16e7fe1..e3ac3f7c92b03c 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -127,13 +127,10 @@ verbs_get_device(const struct ibv_device *dev)
 	return container_of(dev, struct verbs_device, device);
 }
 
-typedef struct verbs_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
-						     int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
 						       int abi_version);
-
-void ibv_register_driver(const char *name, ibv_driver_init_func init_func);
 void verbs_register_driver(const char *name, verbs_driver_init_func init_func);
+
 int ibv_cmd_get_context(struct ibv_context *context, struct ibv_get_context *cmd,
 			size_t cmd_size, struct ibv_get_context_resp *resp,
 			size_t resp_size);
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 8e059546cdb5af..fdabe821ee8c80 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -71,7 +71,6 @@ struct ibv_driver_name {
 
 struct ibv_driver {
 	const char	       *name;
-	ibv_driver_init_func	init_func;
 	verbs_driver_init_func	verbs_init_func;
 	struct ibv_driver      *next;
 };
@@ -161,8 +160,8 @@ static int find_sysfs_devs(void)
 	return ret;
 }
 
-static void register_driver(const char *name, ibv_driver_init_func init_func,
-			    verbs_driver_init_func verbs_init_func)
+void verbs_register_driver(const char *name,
+			   verbs_driver_init_func verbs_init_func)
 {
 	struct ibv_driver *driver;
 
@@ -173,7 +172,6 @@ static void register_driver(const char *name, ibv_driver_init_func init_func,
 	}
 
 	driver->name            = name;
-	driver->init_func	= init_func;
 	driver->verbs_init_func = verbs_init_func;
 	driver->next            = NULL;
 
@@ -184,20 +182,6 @@ static void register_driver(const char *name, ibv_driver_init_func init_func,
 	tail_driver = driver;
 }
 
-void __ibv_register_driver(const char *name, ibv_driver_init_func init_func)
-{
-	register_driver(name, init_func, NULL);
-}
-private_symver(__ibv_register_driver, ibv_register_driver);
-
-/* New registration symbol with same functionality - used by providers to
-  * validate that library supports verbs extension.
-  */
-void verbs_register_driver(const char *name, verbs_driver_init_func init_func)
-{
-	register_driver(name, NULL, init_func);
-}
-
 #define __IBV_QUOTE(x)	#x
 #define IBV_QUOTE(x)	__IBV_QUOTE(x)
 #define DLOPEN_TRAILER "-" IBV_QUOTE(IBV_DEVICE_LIBRARY_EXTENSION) ".so"
@@ -384,20 +368,13 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	struct ibv_device *dev;
 	char value[16];
 
-	if (driver->init_func) {
-		vdev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-		if (!vdev)
-			return NULL;
-		dev = &vdev->device;
-	} else {
-		vdev = driver->verbs_init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-		if (!vdev)
-			return NULL;
+	vdev = driver->verbs_init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+	if (!vdev)
+		return NULL;
 
-		dev = &vdev->device;
-		assert(dev->_ops._dummy1 == NULL);
-		assert(dev->_ops._dummy2 == NULL);
-	}
+	dev = &vdev->device;
+	assert(dev->_ops._dummy1 == NULL);
+	assert(dev->_ops._dummy2 == NULL);
 
 	if (ibv_read_sysfs_file(sysfs_dev->ibdev_path, "node_type", value, sizeof value) < 0) {
 		fprintf(stderr, PFX "Warning: no node_type attr under %s.\n",
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 776c42c444ea36..be3905c4ab6850 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -284,5 +284,5 @@ err1:
 
 static __attribute__((constructor)) void cxgb3_register_driver(void)
 {
-	ibv_register_driver("cxgb3", cxgb3_driver_init);
+	verbs_register_driver("cxgb3", cxgb3_driver_init);
 }
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 8488c02830d56f..183f141ac1a9f5 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -512,7 +512,7 @@ static __attribute__((constructor)) void cxgb4_register_driver(void)
 	c4iw_page_size = sysconf(_SC_PAGESIZE);
 	c4iw_page_shift = long_log2(c4iw_page_size);
 	c4iw_page_mask = ~(c4iw_page_size - 1);
-	ibv_register_driver("cxgb4", cxgb4_driver_init);
+	verbs_register_driver("cxgb4", cxgb4_driver_init);
 }
 
 #ifdef STATS
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index 82c2bd15d995eb..b27df3d843c4ad 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -219,5 +219,5 @@ found:
 
 static __attribute__((constructor)) void hfi1_register_driver(void)
 {
-	ibv_register_driver("hfi1verbs", hfi1_driver_init);
+	verbs_register_driver("hfi1verbs", hfi1_driver_init);
 }
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 2b2fd19a41a4fe..a080ca609c8337 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -224,5 +224,5 @@ found:
 
 static __attribute__((constructor)) void hns_roce_register_driver(void)
 {
-	ibv_register_driver("hns", hns_roce_driver_init);
+	verbs_register_driver("hns", hns_roce_driver_init);
 }
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 3d3015b7acdf3a..5946b7c8e63d04 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -256,5 +256,5 @@ found:
 
 static __attribute__ ((constructor)) void i40iw_register_driver(void)
 {
-	ibv_register_driver("i40iw", i40iw_driver_init);
+	verbs_register_driver("i40iw", i40iw_driver_init);
 }
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 7eef9dfccbcb23..0cb6abf2d96563 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -218,5 +218,5 @@ found:
 
 static __attribute__((constructor)) void ipath_register_driver(void)
 {
-	ibv_register_driver("ipathverbs", ipath_driver_init);
+	verbs_register_driver("ipathverbs", ipath_driver_init);
 }
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index abff1eb707a315..96e7944ef72285 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -262,5 +262,5 @@ found:
 
 static __attribute__((constructor)) void mthca_register_driver(void)
 {
-	ibv_register_driver("mthca", mthca_driver_init);
+	verbs_register_driver("mthca", mthca_driver_init);
 }
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index b9ec9c41a9d5d1..20ddc8d01acdce 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -253,5 +253,5 @@ static __attribute__((constructor)) void nes_register_driver(void)
 {
 	/* fprintf(stderr, PFX "nes_register_driver: call ibv_register_driver()\n"); */
 
-	ibv_register_driver("nes", nes_driver_init);
+	verbs_register_driver("nes", nes_driver_init);
 }
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 9e2862843fed68..2f22e8fd02c03a 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -237,5 +237,5 @@ qp_err:
 static __attribute__ ((constructor))
 void ocrdma_register_driver(void)
 {
-	ibv_register_driver("ocrdma", ocrdma_driver_init);
+	verbs_register_driver("ocrdma", ocrdma_driver_init);
 }
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 5d14f733eea727..ba70db9d496755 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -280,5 +280,5 @@ found:
 static __attribute__ ((constructor))
 void qelr_register_driver(void)
 {
-	ibv_register_driver("qelr", qelr_driver_init);
+	verbs_register_driver("qelr", qelr_driver_init);
 }
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 133a1b6ba908e8..a81d022c36a749 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -922,5 +922,5 @@ static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
 static __attribute__ ((constructor))
 void rxe_register_driver(void)
 {
-	ibv_register_driver("rxe", rxe_driver_init);
+	verbs_register_driver("rxe", rxe_driver_init);
 }
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 7630134eda8e6e..047f492699b136 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -225,5 +225,5 @@ static struct verbs_device *pvrdma_driver_init(const char *uverbs_sys_path,
 
 static __attribute__((constructor)) void pvrdma_register_driver(void)
 {
-	ibv_register_driver("pvrdma", pvrdma_driver_init);
+	verbs_register_driver("pvrdma", pvrdma_driver_init);
 }
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
