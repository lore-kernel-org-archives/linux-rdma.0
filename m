From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 2/4] providers: Make every provider allocate a verbs_device
Date: Tue, 28 Feb 2017 14:31:35 -0700
Message-ID: <1488317497-538-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1488317497-538-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488317497-538-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Switch struct ibv_device to verbs_device in the provider specific device
structure and use calloc to allocate it so the unset bytes are zero.

This lets us change the return type of ibv_driver_init_func to
struct verbs_device without changing the control flow at all.

Also make a few _init functions static for consistency/simplicity.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h                |  4 ++--
 libibverbs/init.c                  |  5 +++--
 providers/cxgb3/iwch.c             |  8 ++++----
 providers/cxgb3/iwch.h             |  2 +-
 providers/cxgb4/dev.c              |  6 +++---
 providers/cxgb4/libcxgb4.h         |  2 +-
 providers/hfi1verbs/hfiverbs.c     |  8 ++++----
 providers/hfi1verbs/hfiverbs.h     |  2 +-
 providers/hns/hns_roce_u.c         |  8 ++++----
 providers/hns/hns_roce_u.h         |  2 +-
 providers/i40iw/i40iw_umain.c      |  7 ++++---
 providers/i40iw/i40iw_umain.h      |  5 +----
 providers/ipathverbs/ipathverbs.c  |  8 ++++----
 providers/ipathverbs/ipathverbs.h  |  2 +-
 providers/mthca/mthca.c            |  6 +++---
 providers/mthca/mthca.h            |  2 +-
 providers/nes/nes_umain.c          |  7 ++++---
 providers/nes/nes_umain.h          |  5 +----
 providers/ocrdma/ocrdma_main.c     | 10 +++++-----
 providers/ocrdma/ocrdma_main.h     |  4 +---
 providers/qedr/qelr.h              |  2 +-
 providers/qedr/qelr_main.c         | 10 ++++------
 providers/qedr/qelr_main.h         |  2 --
 providers/rxe/rxe.c                |  8 ++++----
 providers/rxe/rxe.h                |  2 +-
 providers/vmw_pvrdma/pvrdma.h      |  2 +-
 providers/vmw_pvrdma/pvrdma_main.c |  8 ++++----
 27 files changed, 64 insertions(+), 73 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 96f4903d19670a..9e7f02ca30190c 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -115,8 +115,8 @@ static inline struct verbs_device *verbs_get_device(
 		NULL : container_of(dev, struct verbs_device, device);
 }
 
-typedef struct ibv_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
-						   int abi_version);
+typedef struct verbs_device *(*ibv_driver_init_func)(const char *uverbs_sys_path,
+						     int abi_version);
 typedef struct verbs_device *(*verbs_driver_init_func)(const char *uverbs_sys_path,
 						       int abi_version);
 
diff --git a/libibverbs/init.c b/libibverbs/init.c
index 6eb6a2082bae3c..11c2a587abf745 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -384,9 +384,10 @@ static struct ibv_device *try_driver(struct ibv_driver *driver,
 	char value[16];
 
 	if (driver->init_func) {
-		dev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
-		if (!dev)
+		vdev = driver->init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
+		if (!vdev)
 			return NULL;
+		dev = &vdev->device;
 	} else {
 		vdev = driver->verbs_init_func(sysfs_dev->sysfs_path, sysfs_dev->abi_ver);
 		if (!vdev)
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index a03bced9eeaf61..6e60949f39dcc1 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -171,8 +171,8 @@ static struct ibv_device_ops iwch_dev_ops = {
 	.free_context = iwch_free_context
 };
 
-static struct ibv_device *cxgb3_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *cxgb3_driver_init(const char *uverbs_sys_path,
+					      int abi_version)
 {
 	char devstr[IBV_SYSFS_PATH_MAX], ibdev[16], value[32], *cp;
 	struct iwch_device *dev;
@@ -245,13 +245,13 @@ found:
 	PDBG("%s found vendor %d device %d type %d\n", 
 	     __FUNCTION__, vendor, device, hca_table[i].type);
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		return NULL;
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = iwch_dev_ops;
+	dev->ibv_dev.device.ops = iwch_dev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->abi_version = abi_version;
 
diff --git a/providers/cxgb3/iwch.h b/providers/cxgb3/iwch.h
index 9ea58b73036f43..ba6e610cbca7ac 100644
--- a/providers/cxgb3/iwch.h
+++ b/providers/cxgb3/iwch.h
@@ -51,7 +51,7 @@ struct iwch_mr;
 #define ABI_VERS 1
 
 struct iwch_device {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 	enum iwch_hca_type hca_type;
 	struct iwch_mr **mmid2ptr;
 	struct iwch_qp **qpid2ptr;
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index b0233de0dd40c4..ec7fa53de50a89 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -397,8 +397,8 @@ void dump_state(void)
  */
 int c4iw_abi_version = 1;
 
-static struct ibv_device *cxgb4_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *cxgb4_driver_init(const char *uverbs_sys_path,
+					      int abi_version)
 {
 	char devstr[IBV_SYSFS_PATH_MAX], ibdev[16], value[32], *cp;
 	struct c4iw_dev *dev;
@@ -470,7 +470,7 @@ found:
 	}
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = c4iw_dev_ops;
+	dev->ibv_dev.device.ops = c4iw_dev_ops;
 	dev->chip_version = CHELSIO_CHIP_VERSION(hca_table[i].device >> 8);
 	dev->abi_version = abi_version;
 	list_node_init(&dev->list);
diff --git a/providers/cxgb4/libcxgb4.h b/providers/cxgb4/libcxgb4.h
index b64b33564c76e5..e7d13c5ec58f94 100644
--- a/providers/cxgb4/libcxgb4.h
+++ b/providers/cxgb4/libcxgb4.h
@@ -51,7 +51,7 @@ extern unsigned long c4iw_page_mask;
 struct c4iw_mr;
 
 struct c4iw_dev {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 	unsigned chip_version;
 	int max_mr;
 	struct c4iw_mr **mmid2ptr;
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index 760534797b5724..e8e777e833d0a3 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -178,8 +178,8 @@ static struct ibv_device_ops hfi1_dev_ops = {
 	.free_context	= hfi1_free_context
 };
 
-static struct ibv_device *hfi1_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *hfi1_driver_init(const char *uverbs_sys_path,
+					     int abi_version)
 {
 	char			value[8];
 	struct hfi1_device    *dev;
@@ -204,14 +204,14 @@ static struct ibv_device *hfi1_driver_init(const char *uverbs_sys_path,
 	return NULL;
 
 found:
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
 			uverbs_sys_path);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = hfi1_dev_ops;
+	dev->ibv_dev.device.ops = hfi1_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/hfi1verbs/hfiverbs.h b/providers/hfi1verbs/hfiverbs.h
index 194db8350dac6f..456d36872df8a8 100644
--- a/providers/hfi1verbs/hfiverbs.h
+++ b/providers/hfi1verbs/hfiverbs.h
@@ -69,7 +69,7 @@
 #define PFX		"hfi1: "
 
 struct hfi1_device {
-	struct ibv_device	ibv_dev;
+	struct verbs_device	ibv_dev;
 	int			abi_version;
 };
 
diff --git a/providers/hns/hns_roce_u.c b/providers/hns/hns_roce_u.c
index 281f9f408a161d..fe13e3b940e76f 100644
--- a/providers/hns/hns_roce_u.c
+++ b/providers/hns/hns_roce_u.c
@@ -178,8 +178,8 @@ static struct ibv_device_ops hns_roce_dev_ops = {
 	.free_context	= hns_roce_free_context
 };
 
-static struct ibv_device *hns_roce_driver_init(const char *uverbs_sys_path,
-					       int abi_version)
+static struct verbs_device *hns_roce_driver_init(const char *uverbs_sys_path,
+						 int abi_version)
 {
 	struct hns_roce_device  *dev;
 	char			 value[128];
@@ -208,14 +208,14 @@ static struct ibv_device *hns_roce_driver_init(const char *uverbs_sys_path,
 	return NULL;
 
 found:
-	dev = malloc(sizeof(struct hns_roce_device));
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
 			uverbs_sys_path);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = hns_roce_dev_ops;
+	dev->ibv_dev.device.ops = hns_roce_dev_ops;
 	dev->u_hw = (struct hns_roce_u_hw *)u_hw;
 	dev->hw_version = hw_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
diff --git a/providers/hns/hns_roce_u.h b/providers/hns/hns_roce_u.h
index cb2f26060711dd..dc8956af4f8fae 100644
--- a/providers/hns/hns_roce_u.h
+++ b/providers/hns/hns_roce_u.h
@@ -80,7 +80,7 @@ enum {
 };
 
 struct hns_roce_device {
-	struct ibv_device		ibv_dev;
+	struct verbs_device		ibv_dev;
 	int				page_size;
 	struct hns_roce_u_hw		*u_hw;
 	int				hw_version;
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index a1e98aca11f125..69493b56dbbdb1 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -218,7 +218,8 @@ static struct ibv_device_ops i40iw_udev_ops = {
  * @uverbs_sys_path: sys path
  * @abi_version: not used
  */
-struct ibv_device *i40iw_driver_init(const char *uverbs_sys_path, int abi_version)
+static struct verbs_device *i40iw_driver_init(const char *uverbs_sys_path,
+					      int abi_version)
 {
 	char value[16];
 	struct i40iw_udevice *dev;
@@ -241,13 +242,13 @@ struct ibv_device *i40iw_driver_init(const char *uverbs_sys_path, int abi_versio
 
 	return NULL;
 found:
-	dev = malloc(sizeof(*dev));
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "%s: failed to allocate memory for device object\n", __func__);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = i40iw_udev_ops;
+	dev->ibv_dev.device.ops = i40iw_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = I40IW_HW_PAGE_SIZE;
 	return &dev->ibv_dev;
diff --git a/providers/i40iw/i40iw_umain.h b/providers/i40iw/i40iw_umain.h
index 1f86c8f90b10d9..d70ed657ebc0df 100644
--- a/providers/i40iw/i40iw_umain.h
+++ b/providers/i40iw/i40iw_umain.h
@@ -69,7 +69,7 @@ enum i40iw_uhca_type {
 };
 
 struct i40iw_udevice {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 	enum i40iw_uhca_type hca_type;
 	int page_size;
 };
@@ -156,9 +156,6 @@ static inline struct i40iw_uqp *to_i40iw_uqp(struct ibv_qp *ibqp)
 	return to_i40iw_uxxx(qp, qp);
 }
 
-/* i40iw_umain.c */
-struct ibv_device *i40iw_driver_init(const char *, int);
-
 /* i40iw_uverbs.c */
 int i40iw_uquery_device(struct ibv_context *, struct ibv_device_attr *);
 int i40iw_uquery_port(struct ibv_context *, uint8_t, struct ibv_port_attr *);
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index e953864e79f37e..c45675735c10b9 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -177,8 +177,8 @@ static struct ibv_device_ops ipath_dev_ops = {
 	.free_context	= ipath_free_context
 };
 
-static struct ibv_device *ipath_driver_init(const char *uverbs_sys_path,
-					    int abi_version)
+static struct verbs_device *ipath_driver_init(const char *uverbs_sys_path,
+					      int abi_version)
 {
 	char			value[8];
 	struct ipath_device    *dev;
@@ -203,14 +203,14 @@ static struct ibv_device *ipath_driver_init(const char *uverbs_sys_path,
 	return NULL;
 
 found:
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
 			uverbs_sys_path);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = ipath_dev_ops;
+	dev->ibv_dev.device.ops = ipath_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/ipathverbs/ipathverbs.h b/providers/ipathverbs/ipathverbs.h
index b036c69a4158b3..13acec2466f607 100644
--- a/providers/ipathverbs/ipathverbs.h
+++ b/providers/ipathverbs/ipathverbs.h
@@ -49,7 +49,7 @@
 #define PFX		"ipath: "
 
 struct ipath_device {
-	struct ibv_device	ibv_dev;
+	struct verbs_device	ibv_dev;
 	int			abi_version;
 };
 
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 4103a3a8ca629d..9dbd6610f1e61f 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -214,7 +214,7 @@ static struct ibv_device_ops mthca_dev_ops = {
 	.free_context  = mthca_free_context
 };
 
-static struct ibv_device *mthca_driver_init(const char *uverbs_sys_path,
+static struct verbs_device *mthca_driver_init(const char *uverbs_sys_path,
 					    int abi_version)
 {
 	char			value[8];
@@ -246,14 +246,14 @@ found:
 		return NULL;
 	}
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
 			uverbs_sys_path);
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = mthca_dev_ops;
+	dev->ibv_dev.device.ops = mthca_dev_ops;
 	dev->hca_type    = hca_table[i].type;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 
diff --git a/providers/mthca/mthca.h b/providers/mthca/mthca.h
index 61ee92807fcb86..d456e6a50c889f 100644
--- a/providers/mthca/mthca.h
+++ b/providers/mthca/mthca.h
@@ -89,7 +89,7 @@ enum {
 struct mthca_ah_page;
 
 struct mthca_device {
-	struct ibv_device   ibv_dev;
+	struct verbs_device ibv_dev;
 	enum mthca_hca_type hca_type;
 	int                 page_size;
 };
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index 4b19dd7829cbe6..b166c0916e4ce9 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -194,7 +194,8 @@ static struct ibv_device_ops nes_udev_ops = {
 /**
  * nes_driver_init
  */
-struct ibv_device *nes_driver_init(const char *uverbs_sys_path, int abi_version)
+static struct verbs_device *nes_driver_init(const char *uverbs_sys_path,
+					    int abi_version)
 {
 	char value[16];
 	struct nes_udevice *dev;
@@ -229,13 +230,13 @@ found:
 			sscanf(value, "%u", &nes_debug_level);
 	}
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		nes_debug(NES_DBG_INIT, "Fatal: couldn't allocate device for libnes\n");
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = nes_udev_ops;
+	dev->ibv_dev.device.ops = nes_udev_ops;
 	dev->hca_type = hca_table[i].type;
 	dev->page_size = sysconf(_SC_PAGESIZE);
 
diff --git a/providers/nes/nes_umain.h b/providers/nes/nes_umain.h
index 6a4366802db209..5676c377357d12 100644
--- a/providers/nes/nes_umain.h
+++ b/providers/nes/nes_umain.h
@@ -248,7 +248,7 @@ struct nes_user_doorbell {
 };
 
 struct nes_udevice {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 	enum nes_uhca_type hca_type;
 	int page_size;
 };
@@ -351,9 +351,6 @@ static inline struct nes_uqp *to_nes_uqp(struct ibv_qp *ibqp)
 }
 
 
-/* nes_umain.c */
-struct ibv_device *nes_driver_init(const char *, int);
-
 /* nes_uverbs.c */
 int nes_uquery_device(struct ibv_context *, struct ibv_device_attr *);
 int nes_uquery_port(struct ibv_context *, uint8_t, struct ibv_port_attr *);
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index dfd3172841255b..8dad5ffe17694d 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -172,8 +172,8 @@ static void ocrdma_free_context(struct ibv_context *ibctx)
 /**
  * ocrdma_driver_init
  */
-struct ibv_device *ocrdma_driver_init(const char *uverbs_sys_path,
-				      int abi_version)
+static struct verbs_device *ocrdma_driver_init(const char *uverbs_sys_path,
+					       int abi_version)
 {
 
 	char value[16];
@@ -207,20 +207,20 @@ found:
 		return NULL;
 	}
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		ocrdma_err("%s() Fatal: fail allocate device for libocrdma\n",
 			   __func__);
 		return NULL;
 	}
-	bzero(dev, sizeof *dev);
+
 	dev->qp_tbl = malloc(OCRDMA_MAX_QP * sizeof(struct ocrdma_qp *));
 	if (!dev->qp_tbl)
 		goto qp_err;
 	bzero(dev->qp_tbl, OCRDMA_MAX_QP * sizeof(struct ocrdma_qp *));
 	pthread_mutex_init(&dev->dev_lock, NULL);
 	pthread_spin_init(&dev->flush_q_lock, PTHREAD_PROCESS_PRIVATE);
-	dev->ibv_dev.ops = ocrdma_dev_ops;
+	dev->ibv_dev.device.ops = ocrdma_dev_ops;
 	list_node_init(&dev->entry);
 	pthread_mutex_lock(&ocrdma_dev_list_lock);
 	list_add_tail(&ocrdma_dev_list, &dev->entry);
diff --git a/providers/ocrdma/ocrdma_main.h b/providers/ocrdma/ocrdma_main.h
index 6c74545d08df2d..b2b27abdcabfd1 100644
--- a/providers/ocrdma/ocrdma_main.h
+++ b/providers/ocrdma/ocrdma_main.h
@@ -54,7 +54,7 @@
 struct ocrdma_qp;
 
 struct ocrdma_device {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 	struct ocrdma_qp **qp_tbl;
 	pthread_mutex_t dev_lock;
 	pthread_spinlock_t flush_q_lock;
@@ -266,8 +266,6 @@ static inline struct ocrdma_ah *get_ocrdma_ah(struct ibv_ah *ibah)
 	return get_ocrdma_xxx(ah, ah);
 }
 
-struct ibv_device *ocrdma_driver_init(const char *, int);
-
 void ocrdma_init_ahid_tbl(struct ocrdma_devctx *ctx);
 int ocrdma_query_device(struct ibv_context *, struct ibv_device_attr *);
 int ocrdma_query_port(struct ibv_context *, uint8_t, struct ibv_port_attr *);
diff --git a/providers/qedr/qelr.h b/providers/qedr/qelr.h
index e887d9f8e4713a..426bba6ec019e7 100644
--- a/providers/qedr/qelr.h
+++ b/providers/qedr/qelr.h
@@ -112,7 +112,7 @@ struct qelr_buf {
 };
 
 struct qelr_device {
-	struct ibv_device ibv_dev;
+	struct verbs_device ibv_dev;
 };
 
 struct qelr_devctx {
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 0378d2c37944db..ef192c533de350 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -231,8 +231,8 @@ static void qelr_free_context(struct ibv_context *ibctx)
 	free(ctx);
 }
 
-struct ibv_device *qelr_driver_init(const char *uverbs_sys_path,
-				    int abi_version)
+static struct verbs_device *qelr_driver_init(const char *uverbs_sys_path,
+					     int abi_version)
 {
 	char value[16];
 	struct qelr_device *dev;
@@ -265,16 +265,14 @@ found:
 		return NULL;
 	}
 
-	dev = malloc(sizeof(*dev));
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		qelr_err("%s() Fatal: fail allocate device for libqedr\n",
 			 __func__);
 		return NULL;
 	}
 
-	bzero(dev, sizeof(*dev));
-
-	dev->ibv_dev.ops = qelr_dev_ops;
+	dev->ibv_dev.device.ops = qelr_dev_ops;
 
 	return &dev->ibv_dev;
 }
diff --git a/providers/qedr/qelr_main.h b/providers/qedr/qelr_main.h
index 88d52b7aed2b66..f0b16d9804363e 100644
--- a/providers/qedr/qelr_main.h
+++ b/providers/qedr/qelr_main.h
@@ -40,8 +40,6 @@
 #include <infiniband/driver.h>
 #include <util/udma_barrier.h>
 
-struct ibv_device *qelr_driver_init(const char *, int);
-
 int qelr_query_device(struct ibv_context *, struct ibv_device_attr *);
 int qelr_query_port(struct ibv_context *, uint8_t, struct ibv_port_attr *);
 
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 7fcd754b8058c1..fba3bc719cd45a 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -891,8 +891,8 @@ static struct ibv_device_ops rxe_dev_ops = {
 	.free_context = rxe_free_context,
 };
 
-static struct ibv_device *rxe_driver_init(const char *uverbs_sys_path,
-					  int abi_version)
+static struct verbs_device *rxe_driver_init(const char *uverbs_sys_path,
+					    int abi_version)
 {
 	struct rxe_device *dev;
 	char value[16];
@@ -905,7 +905,7 @@ static struct ibv_device *rxe_driver_init(const char *uverbs_sys_path,
 	if (strncmp(value, "rxe", 3))
 		return NULL;
 
-	dev = malloc(sizeof *dev);
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr,
 			"rxe: Fatal: couldn't allocate device for %s\n",
@@ -913,7 +913,7 @@ static struct ibv_device *rxe_driver_init(const char *uverbs_sys_path,
 		return NULL;
 	}
 
-	dev->ibv_dev.ops = rxe_dev_ops;
+	dev->ibv_dev.device.ops = rxe_dev_ops;
 	dev->abi_version = abi_version;
 
 	return &dev->ibv_dev;
diff --git a/providers/rxe/rxe.h b/providers/rxe/rxe.h
index 0a67a810d7ceed..fbf18b26f3e19a 100644
--- a/providers/rxe/rxe.h
+++ b/providers/rxe/rxe.h
@@ -43,7 +43,7 @@ enum rdma_network_type {
 };
 
 struct rxe_device {
-	struct ibv_device	ibv_dev;
+	struct verbs_device	ibv_dev;
 	int	abi_version;
 };
 
diff --git a/providers/vmw_pvrdma/pvrdma.h b/providers/vmw_pvrdma/pvrdma.h
index 29c99912d1d304..a5a34e845ad66b 100644
--- a/providers/vmw_pvrdma/pvrdma.h
+++ b/providers/vmw_pvrdma/pvrdma.h
@@ -110,7 +110,7 @@ enum {
 };
 
 struct pvrdma_device {
-	struct ibv_device		ibv_dev;
+	struct verbs_device		ibv_dev;
 	int				page_size;
 	int				abi_version;
 };
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 7190efaf086af5..a518cacba79da3 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -198,7 +198,7 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 		return NULL;
 	}
 
-	dev = malloc(sizeof(*dev));
+	dev = calloc(1, sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "couldn't allocate device for %s\n",
 			uverbs_sys_path);
@@ -207,13 +207,13 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 
 	dev->abi_version = abi_version;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
-	dev->ibv_dev.ops = pvrdma_dev_ops;
+	dev->ibv_dev.device.ops = pvrdma_dev_ops;
 
 	return dev;
 }
 
-static struct ibv_device *pvrdma_driver_init(const char *uverbs_sys_path,
-					     int abi_version)
+static struct verbs_device *pvrdma_driver_init(const char *uverbs_sys_path,
+					       int abi_version)
 {
 	struct pvrdma_device *dev = pvrdma_driver_init_shared(uverbs_sys_path,
 							      abi_version);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
