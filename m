From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 07/10] providers: Use the new common PCI matching infrastructure
Date: Tue, 19 Sep 2017 15:18:48 -0600
Message-ID: <1505855931-4956-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "moderated list:HF1 USERSPACE PROVIDER for
        hf1.ko" <intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "open list:IPATH/QIB USERSPACE PROVIDER for
        ib_qib.ko" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Migrate all trivial cases, these are all just copies of a few variations of
the table scan.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/bnxt_re/main.c           | 40 ++++---------------------------
 providers/hfi1verbs/hfiverbs.c     | 39 ++++--------------------------
 providers/i40iw/i40iw_umain.c      | 49 ++++----------------------------------
 providers/ipathverbs/ipathverbs.c  | 39 ++++--------------------------
 providers/mlx4/mlx4.c              | 38 ++++-------------------------
 providers/mlx5/mlx5.c              | 38 ++++-------------------------
 providers/mthca/mthca.c            | 47 ++++++------------------------------
 providers/nes/nes_umain.c          | 46 +++++------------------------------
 providers/ocrdma/ocrdma_main.c     | 43 +++++++--------------------------
 providers/qedr/qelr_main.c         | 41 ++++---------------------------
 providers/vmw_pvrdma/pvrdma_main.c | 30 ++++++-----------------
 11 files changed, 61 insertions(+), 389 deletions(-)

diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index c83baacbb9f749..998c9fe3313389 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -52,15 +52,8 @@
 
 #define PCI_VENDOR_ID_BROADCOM		0x14E4
 
-#define CNA(v, d)					\
-	{	.vendor = PCI_VENDOR_ID_##v,		\
-		.device = d }
-
-static const struct {
-	unsigned int vendor;
-	unsigned int device;
-} cna_table[] = {
-	CNA(BROADCOM, 0x1614),  /* BCM57454 */
+#define CNA(v, d) VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, d, NULL)
+static const struct verbs_match_ent cna_table[] = {
 	CNA(BROADCOM, 0x16C0),  /* BCM57417 NPAR */
 	CNA(BROADCOM, 0x16CE),  /* BMC57311 */
 	CNA(BROADCOM, 0x16CF),  /* BMC57312 */
@@ -78,7 +71,8 @@ static const struct {
 	CNA(BROADCOM, 0x16EB),  /* BCM57412 NPAR */
 	CNA(BROADCOM, 0x16F0),  /* BCM58730 */
 	CNA(BROADCOM, 0x16F1),  /* BCM57452 */
-	CNA(BROADCOM, 0xD802)   /* BCM58802 */
+	CNA(BROADCOM, 0xD802),  /* BCM58802 */
+	{}
 };
 
 static struct ibv_context_ops bnxt_re_cntx_ops = {
@@ -174,30 +168,6 @@ static void bnxt_re_uninit_context(struct verbs_device *vdev,
 	}
 }
 
-static bool bnxt_re_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[10];
-	unsigned int vendor, device;
-	int i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof(value)) < 0)
-		return false;
-	vendor = strtol(value, NULL, 16);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof(value)) < 0)
-		return false;
-	device = strtol(value, NULL, 16);
-
-	for (i = 0; i < sizeof(cna_table) / sizeof(cna_table[0]); ++i)
-		if (vendor == cna_table[i].vendor &&
-		    device == cna_table[i].device)
-			return true;
-	return false;
-}
-
 static struct verbs_device *
 bnxt_re_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
@@ -218,7 +188,7 @@ static const struct verbs_device_ops bnxt_re_dev_ops = {
 	.name = "bnxt_re",
 	.match_min_abi_version = BNXT_RE_ABI_VERSION,
 	.match_max_abi_version = BNXT_RE_ABI_VERSION,
-	.match_device = bnxt_re_device_match,
+	.match_table = cna_table,
 	.alloc_device = bnxt_re_device_alloc,
 	.init_context = bnxt_re_init_context,
 	.uninit_context = bnxt_re_uninit_context,
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index 5bb436593517e1..7f8f5714db1630 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -77,16 +77,12 @@
 #define PCI_DEVICE_ID_HFI_INTEL1		0x24f1
 #endif
 
-#define HFI(v, d) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = PCI_DEVICE_ID_HFI_##d }
-
-static struct {
-	unsigned		vendor;
-	unsigned		device;
-} hca_table[] = {
+#define HFI(v, d)                                                              \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, PCI_DEVICE_ID_HFI_##d, NULL)
+static const struct verbs_match_ent hca_table[] = {
 	HFI(INTEL, INTEL0),
 	HFI(INTEL, INTEL1),
+	{}
 };
 
 static struct ibv_context_ops hfi1_ctx_ops = {
@@ -180,31 +176,6 @@ static void hf11_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool hfi1_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char			value[8];
-	unsigned                vendor, device;
-	int                     i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			return true;
-
-	return false;
-}
-
 static struct verbs_device *hfi1_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct hfi1_device    *dev;
@@ -222,7 +193,7 @@ static const struct verbs_device_ops hfi1_dev_ops = {
 	.name = "hfi1verbs",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
-	.match_device = hfi1_device_match,
+	.match_table = hca_table,
 	.alloc_device = hfi1_device_alloc,
 	.uninit_device  = hf11_uninit_device,
 	.alloc_context = hfi1_alloc_context,
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index bcba6158e60e40..61c2a92dd6734c 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -50,16 +50,8 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 
-#define INTEL_HCA(v, d, t)		\
-	{ .vendor = v,		\
-	  .device = d,		\
-	  .type = INTEL_ ## t }
-
-static struct hca_ent {
-	unsigned int vendor;
-	unsigned int device;
-	enum i40iw_uhca_type type;
-} hca_table[] = {
+#define INTEL_HCA(v, d, t) VERBS_PCI_MATCH(v, d, (void *)(INTEL_##t))
+static const struct verbs_match_ent hca_table[] = {
 #ifdef I40E_DEV_ID_X722_A0
 	INTEL_HCA(I40E_INTEL_VENDOR_ID, I40E_DEV_ID_X722_A0, i40iw),
 #endif
@@ -96,6 +88,7 @@ static struct hca_ent {
 #ifdef I40E_DEV_ID_X722_FPGA_VF
 	INTEL_HCA(I40E_INTEL_VENDOR_ID, I40E_DEV_ID_X722_FPGA_VF, i40iw),
 #endif
+	{}
 };
 
 static struct ibv_context *i40iw_ualloc_context(struct ibv_device *, int);
@@ -215,48 +208,16 @@ static void i40iw_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-/**
- * i40iw_driver_init - create device struct and provide callback routines for user context
- * @uverbs_sys_path: sys path
- * @abi_version: not used
- */
-static bool i40iw_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[16];
-	unsigned int vendor, device;
-	int i;
-
-	if ((ibv_read_sysfs_file(uverbs_sys_path, "device/vendor", value, sizeof(value)) < 0) ||
-	    (sscanf(value, "%i", &vendor) != 1))
-		return false;
-
-	if ((ibv_read_sysfs_file(uverbs_sys_path, "device/device", value, sizeof(value)) < 0) ||
-	    (sscanf(value, "%i", &device) != 1))
-		return false;
-
-	for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i) {
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device) {
-			sysfs_dev->provider_data = &hca_table[i];
-			return true;
-		}
-	}
-
-	return false;
-}
-
 static struct verbs_device *
 i40iw_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct i40iw_udevice *dev;
-	struct hca_ent *hca_ent = sysfs_dev->provider_data;
 
 	dev = calloc(1, sizeof(*dev));
 	if (!dev)
 		return NULL;
 
-	dev->hca_type = hca_ent->type;
+	dev->hca_type = (uintptr_t)sysfs_dev->match->driver_data;
 	dev->page_size = I40IW_HW_PAGE_SIZE;
 	return &dev->ibv_dev;
 }
@@ -265,7 +226,7 @@ static const struct verbs_device_ops i40iw_udev_ops = {
 	.name = "i40iw",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
-	.match_device = i40iw_device_match,
+	.match_table = hca_table,
 	.alloc_device = i40iw_device_alloc,
 	.uninit_device  = i40iw_uninit_device,
 	.alloc_context = i40iw_ualloc_context,
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 3c141263d8ff86..449abb0489955a 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -73,19 +73,15 @@
 #define PCI_DEVICE_ID_INFINIPATH_7322		0x7322
 #endif
 
-#define HCA(v, d) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = PCI_DEVICE_ID_INFINIPATH_##d }
-
-static struct {
-	unsigned		vendor;
-	unsigned		device;
-} hca_table[] = {
+#define HCA(v, d)                                                              \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, PCI_DEVICE_ID_INFINIPATH_##d, NULL)
+static const struct verbs_match_ent hca_table[] = {
 	HCA(PATHSCALE,	HT),
 	HCA(PATHSCALE,	PE800),
 	HCA(QLOGIC,	6220),
 	HCA(QLOGIC,	7220),
 	HCA(QLOGIC,	7322),
+	{}
 };
 
 static struct ibv_context_ops ipath_ctx_ops = {
@@ -179,31 +175,6 @@ static void ipath_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool ipath_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char			value[8];
-	unsigned                vendor, device;
-	int                     i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			return true;
-
-	return false;
-}
-
 static struct verbs_device *
 ipath_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
@@ -222,7 +193,7 @@ static const struct verbs_device_ops ipath_dev_ops = {
 	.name = "ipathverbs",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
-	.match_device = ipath_device_match,
+	.match_table = hca_table,
 	.alloc_device = ipath_device_alloc,
 	.uninit_device  = ipath_uninit_device,
 	.alloc_context = ipath_alloc_context,
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index b52684a563b495..6de0bee559e79f 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -49,14 +49,8 @@ int mlx4_cleanup_upon_device_fatal = 0;
 #define PCI_VENDOR_ID_MELLANOX			0x15b3
 #endif
 
-#define HCA(v, d) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = d }
-
-static struct {
-	unsigned		vendor;
-	unsigned		device;
-} hca_table[] = {
+#define HCA(v, d) VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, d, NULL)
+static const struct verbs_match_ent hca_table[] = {
 	HCA(MELLANOX, 0x6340),	/* MT25408 "Hermon" SDR */
 	HCA(MELLANOX, 0x634a),	/* MT25408 "Hermon" DDR */
 	HCA(MELLANOX, 0x6354),	/* MT25408 "Hermon" QDR */
@@ -84,6 +78,7 @@ static struct {
 	HCA(MELLANOX, 0x100e),	/* MT27551 Family */
 	HCA(MELLANOX, 0x100f),	/* MT27560 Family */
 	HCA(MELLANOX, 0x1010),	/* MT27561 Family */
+	{}
 };
 
 static struct ibv_context_ops mlx4_ctx_ops = {
@@ -286,31 +281,6 @@ static void mlx4_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool mlx4_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char			value[8];
-	unsigned		vendor, device;
-	int			i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	vendor = strtol(value, NULL, 16);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return false;
-	device = strtol(value, NULL, 16);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			return true;
-
-	return false;
-}
-
 static struct verbs_device *mlx4_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct mlx4_device *dev;
@@ -333,7 +303,7 @@ static const struct verbs_device_ops mlx4_dev_ops = {
 	.name = "mlx4",
 	.match_min_abi_version = MLX4_UVERBS_MIN_ABI_VERSION,
 	.match_max_abi_version = MLX4_UVERBS_MAX_ABI_VERSION,
-	.match_device = mlx4_device_match,
+	.match_table = hca_table,
 	.alloc_device = mlx4_device_alloc,
 	.uninit_device = mlx4_uninit_device,
 	.init_context = mlx4_init_context,
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 44cfd97b73cbbb..15f258dfca7387 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -59,15 +59,8 @@
 #define CPU_EQUAL(x, y) 1
 #endif
 
-
-#define HCA(v, d) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = d }
-
-static struct {
-	unsigned		vendor;
-	unsigned		device;
-} hca_table[] = {
+#define HCA(v, d) VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, d, NULL)
+static const struct verbs_match_ent hca_table[] = {
 	HCA(MELLANOX, 0x1011),	/* MT4113 Connect-IB */
 	HCA(MELLANOX, 0x1012),	/* Connect-IB Virtual Function */
 	HCA(MELLANOX, 0x1013),	/* ConnectX-4 */
@@ -82,6 +75,7 @@ static struct {
 	HCA(MELLANOX, 0x101c),	/* ConnectX-6 VF */
 	HCA(MELLANOX, 0xa2d2),	/* BlueField integrated ConnectX-5 network controller */
 	HCA(MELLANOX, 0xa2d3),	/* BlueField integrated ConnectX-5 network controller VF */
+	{}
 };
 
 uint32_t mlx5_debug_mask = 0;
@@ -1026,30 +1020,6 @@ static void mlx5_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool mlx5_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char			value[8];
-	unsigned		vendor, device;
-	int			i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			return true;
-	return false;
-}
-
 static struct verbs_device *mlx5_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct mlx5_device *dev;
@@ -1072,7 +1042,7 @@ static const struct verbs_device_ops mlx5_dev_ops = {
 	.name = "mlx5",
 	.match_min_abi_version = MLX5_UVERBS_MIN_ABI_VERSION,
 	.match_max_abi_version = MLX5_UVERBS_MAX_ABI_VERSION,
-	.match_device = mlx5_device_match,
+	.match_table = hca_table,
 	.alloc_device = mlx5_device_alloc,
 	.uninit_device = mlx5_uninit_device,
 	.init_context = mlx5_init_context,
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 521e5b9afe4f2b..511b8d5139af9c 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -72,16 +72,10 @@
 #define PCI_VENDOR_ID_TOPSPIN			0x1867
 #endif
 
-#define HCA(v, d, t) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = PCI_DEVICE_ID_MELLANOX_##d,		\
-	  .type = MTHCA_##t }
-
-static struct hca_ent {
-	unsigned		vendor;
-	unsigned		device;
-	enum mthca_hca_type	type;
-} hca_table[] = {
+#define HCA(v, d, t)                                                           \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, PCI_DEVICE_ID_MELLANOX_##d,         \
+			(void *)(MTHCA_##t))
+static const struct verbs_match_ent hca_table[] = {
 	HCA(MELLANOX, TAVOR,	    TAVOR),
 	HCA(MELLANOX, ARBEL_COMPAT, TAVOR),
 	HCA(MELLANOX, ARBEL,	    ARBEL),
@@ -92,6 +86,7 @@ static struct hca_ent {
 	HCA(TOPSPIN,  ARBEL,	    ARBEL),
 	HCA(TOPSPIN,  SINAI_OLD,    ARBEL),
 	HCA(TOPSPIN,  SINAI,	    ARBEL),
+	{}
 };
 
 static struct ibv_context_ops mthca_ctx_ops = {
@@ -216,44 +211,16 @@ static void mthca_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool mthca_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char			value[8];
-	unsigned                vendor, device;
-	int                     i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device) {
-			sysfs_dev->provider_data = &hca_table[i];
-			return true;
-		}
-
-	return false;
-}
-
 static struct verbs_device *
 mthca_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct mthca_device    *dev;
-	struct hca_ent *hca_ent = sysfs_dev->provider_data;
 
 	dev = calloc(1, sizeof(*dev));
 	if (!dev)
 		return NULL;
 
-	dev->hca_type    = hca_ent->type;
+	dev->hca_type    = (uintptr_t)sysfs_dev->match->driver_data;
 	dev->page_size   = sysconf(_SC_PAGESIZE);
 
 	return &dev->ibv_dev;
@@ -263,7 +230,7 @@ static const struct verbs_device_ops mthca_dev_ops = {
 	.name = "mthca",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = MTHCA_UVERBS_ABI_VERSION,
-	.match_device = mthca_device_match,
+	.match_table = hca_table,
 	.alloc_device = mthca_device_alloc,
 	.uninit_device = mthca_uninit_device,
 	.alloc_context = mthca_alloc_context,
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index fc021a9196b6ad..fd3d19def399b2 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -55,18 +55,12 @@ long int page_size;
 #define PCI_VENDOR_ID_NETEFFECT		0x1678
 #endif
 
-#define HCA(v, d, t)                            \
-	{ .vendor = PCI_VENDOR_ID_##v,              \
-	  .device = d,    \
-	  .type = NETEFFECT_##t }
-
-static struct hca_ent {
-	unsigned vendor;
-	unsigned device;
-	enum nes_uhca_type type;
-} hca_table[] = {
+#define HCA(v, d, t)                                                           \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, d, (void *)(NETEFFECT_##t))
+static const struct verbs_match_ent hca_table[] = {
 	HCA(NETEFFECT, 0x0100, nes),
 	HCA(NETEFFECT, 0x0110, nes),
+	{},
 };
 
 static struct ibv_context *nes_ualloc_context(struct ibv_device *, int);
@@ -191,38 +185,10 @@ static void nes_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool nes_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[16];
-	unsigned vendor, device;
-	int i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-			value, sizeof(value)) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-			value, sizeof(value)) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device) {
-			sysfs_dev->provider_data = &hca_table[i];
-			return true;
-		}
-
-	return false;
-}
-
 static struct verbs_device *
 nes_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct nes_udevice *dev;
-	struct hca_ent *hca_ent = sysfs_dev->provider_data;
 	char value[16];
 
 	if (ibv_read_sysfs_file("/sys/module/iw_nes", "parameters/debug_level",
@@ -237,7 +203,7 @@ nes_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 	if (!dev)
 		return NULL;
 
-	dev->hca_type = hca_ent->type;
+	dev->hca_type = (uintptr_t)sysfs_dev->match->driver_data;
 	dev->page_size = sysconf(_SC_PAGESIZE);
 
 	nes_debug(NES_DBG_INIT, "libnes initialized\n");
@@ -249,7 +215,7 @@ static const struct verbs_device_ops nes_udev_ops = {
 	.name = "nes",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
-	.match_device = nes_device_match,
+	.match_table = hca_table,
 	.alloc_device = nes_device_alloc,
 	.uninit_device = nes_uninit_device,
 	.alloc_context = nes_ualloc_context,
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index f08a49fb73e021..92a5b8a5d1c86c 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -55,15 +55,13 @@
 #define PCI_DEVICE_ID_EMULEX_GEN2        0x720
 #define PCI_DEVICE_ID_EMULEX_GEN2_VF     0x728
 
-#define UCNA(v, d)                            \
-	{ .vendor = PCI_VENDOR_ID_##v,        \
-	  .device = PCI_DEVICE_ID_EMULEX_##d }
-
-static struct {
-	unsigned vendor;
-	unsigned device;
-} ucna_table[] = {
-	UCNA(EMULEX, GEN1), UCNA(EMULEX, GEN2), UCNA(EMULEX, GEN2_VF)
+#define UCNA(v, d)                                                             \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, PCI_DEVICE_ID_EMULEX_##d, NULL)
+static const struct verbs_match_ent ucna_table[] = {
+	UCNA(EMULEX, GEN1),
+	UCNA(EMULEX, GEN2),
+	UCNA(EMULEX, GEN2_VF),
+	{}
 };
 
 static struct ibv_context *ocrdma_alloc_context(struct ibv_device *, int);
@@ -168,31 +166,6 @@ static void ocrdma_free_context(struct ibv_context *ibctx)
 	free(ctx);
 }
 
-static bool ocrdma_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[16];
-	unsigned vendor, device;
-	int i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof(value)) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof(value)) < 0)
-		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof ucna_table / sizeof ucna_table[0]; ++i) {
-		if (vendor == ucna_table[i].vendor &&
-		    device == ucna_table[i].device)
-			return true;
-	}
-	return false;
-}
-
 static struct verbs_device *
 ocrdma_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
@@ -218,7 +191,7 @@ static const struct verbs_device_ops ocrdma_dev_ops = {
 	.name = "ocrdma",
 	.match_min_abi_version = OCRDMA_ABI_VERSION,
 	.match_max_abi_version = OCRDMA_ABI_VERSION,
-	.match_device = ocrdma_device_match,
+	.match_table = ucna_table,
 	.alloc_device = ocrdma_device_alloc,
 	.uninit_device = ocrdma_uninit_device,
 	.alloc_context = ocrdma_alloc_context,
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 4d1b92f40a413a..1297e8e16acee5 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -64,14 +64,9 @@
 uint32_t qelr_dp_level;
 uint32_t qelr_dp_module;
 
-#define QHCA(d)					\
-	{ .vendor = PCI_VENDOR_ID_QLOGIC,	\
-	  .device = PCI_DEVICE_ID_QLOGIC_##d }
-
-static const struct {
-	unsigned int vendor;
-	unsigned int device;
-} hca_table[] = {
+#define QHCA(d)                                                                \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_##d, NULL)
+static const struct verbs_match_ent hca_table[] = {
 	QHCA(57980S),
 	QHCA(57980S_40),
 	QHCA(57980S_10),
@@ -82,6 +77,7 @@ static const struct {
 	QHCA(57980S_IOV),
 	QHCA(AH),
 	QHCA(AH_IOV),
+	{}
 };
 
 static struct ibv_context *qelr_alloc_context(struct ibv_device *, int);
@@ -227,33 +223,6 @@ static void qelr_free_context(struct ibv_context *ibctx)
 	free(ctx);
 }
 
-static bool qedr_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[16];
-	unsigned int vendor, device;
-	int i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof(value)) < 0)
-		return false;
-
-	sscanf(value, "%i", &vendor);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof(value)) < 0)
-		return false;
-
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof(hca_table) / sizeof(hca_table[0]); ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device)
-			return true;
-
-	return false;
-}
-
 static struct verbs_device *qedr_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct qelr_device *dev;
@@ -269,7 +238,7 @@ static const struct verbs_device_ops qelr_dev_ops = {
 	.name = "qelr",
 	.match_min_abi_version = QELR_ABI_VERSION,
 	.match_max_abi_version = QELR_ABI_VERSION,
-	.match_device = qedr_device_match,
+	.match_table = hca_table,
 	.alloc_device = qedr_device_alloc,
 	.uninit_device = qelr_uninit_device,
 	.alloc_context = qelr_alloc_context,
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 9bcf2ddd172afb..0826629c081018 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -169,28 +169,6 @@ static void pvrdma_uninit_device(struct verbs_device *verbs_device)
 	free(dev);
 }
 
-static bool pvrdma_device_match(struct verbs_sysfs_dev *sysfs_dev)
-{
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
-	char value[8];
-	unsigned int vendor_id, device_id;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof(value)) < 0)
-		return false;
-	vendor_id = strtol(value, NULL, 16);
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof(value)) < 0)
-		return false;
-	device_id = strtol(value, NULL, 16);
-
-	if (vendor_id != PCI_VENDOR_ID_VMWARE ||
-	    device_id != PCI_DEVICE_ID_VMWARE_PVRDMA)
-		return false;
-	return true;
-}
-
 static struct verbs_device *
 pvrdma_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
@@ -206,11 +184,17 @@ pvrdma_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 	return &dev->ibv_dev;
 }
 
+static const struct verbs_match_ent hca_table[] = {
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_PVRDMA,
+			NULL),
+	{}
+};
+
 static const struct verbs_device_ops pvrdma_dev_ops = {
 	.name = "pvrdma",
 	.match_min_abi_version = PVRDMA_UVERBS_ABI_VERSION,
 	.match_max_abi_version = PVRDMA_UVERBS_ABI_VERSION,
-	.match_device = pvrdma_device_match,
+	.match_table = hca_table,
 	.alloc_device = pvrdma_device_alloc,
 	.uninit_device = pvrdma_uninit_device,
 	.alloc_context = pvrdma_alloc_context,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
