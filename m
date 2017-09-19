From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 08/10] cxgb: Use the new common PCI matching infrastructure
Date: Tue, 19 Sep 2017 15:18:49 -0600
Message-ID: <1505855931-4956-9-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cxgb has an additional check for firmware version that will still
be handled by the matching function, after the core code has setup
the match pointer.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/cxgb3/iwch.c | 43 +++++++++----------------------------------
 providers/cxgb4/dev.c  | 44 ++++++++++----------------------------------
 2 files changed, 19 insertions(+), 68 deletions(-)

diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index 7eb283bd9a89e1..3cc1d4c185e97e 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -56,16 +56,10 @@
 #define PCI_DEVICE_ID_CHELSIO_T3C20	0x0035
 #define PCI_DEVICE_ID_CHELSIO_S320E	0x0036
 
-#define HCA(v, d, t) \
-	{ .vendor = PCI_VENDOR_ID_##v,			\
-	  .device = PCI_DEVICE_ID_CHELSIO_##d,		\
-	  .type = CHELSIO_##t }
-
-static struct hca_ent {
-	unsigned vendor;
-	unsigned device;
-	enum iwch_hca_type type;
-} hca_table[] = {
+#define HCA(v, d, t)                                                           \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_##v, PCI_DEVICE_ID_CHELSIO_##d,          \
+			(void *)(CHELSIO_##t))
+static const struct verbs_match_ent hca_table[] = {
 	HCA(CHELSIO, PE9000_2C, T3B),
 	HCA(CHELSIO, T302E, T3A),
 	HCA(CHELSIO, T302X, T3A),
@@ -175,31 +169,12 @@ static void iwch_uninit_device(struct verbs_device *verbs_device)
 
 static bool iwch_device_match(struct verbs_sysfs_dev *sysfs_dev)
 {
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
 	char value[32], *cp;
-	unsigned vendor, device, fw_maj, fw_min;
-	int i;
+	unsigned int fw_maj, fw_min;
 
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
+	/* Rely on the core code to match PCI devices */
+	if (!sysfs_dev->match)
 		return false;
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
-			goto found;
-		}
-
-	return false;
-
-found:
 
 	/* 
 	 * Verify that the firmware major number matches.  Major number
@@ -237,14 +212,13 @@ found:
 static struct verbs_device *iwch_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct iwch_device *dev;
-	struct hca_ent *hca_ent = sysfs_dev->provider_data;
 
 	dev = calloc(1, sizeof(*dev));
 	if (!dev)
 		return NULL;
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
-	dev->hca_type = hca_ent->type;
+	dev->hca_type = (uintptr_t)sysfs_dev->match->driver_data;
 	dev->abi_version = sysfs_dev->abi_ver;
 
 	iwch_page_size = sysconf(_SC_PAGESIZE);
@@ -278,6 +252,7 @@ static const struct verbs_device_ops iwch_dev_ops = {
 	.name = "cxgb3",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = ABI_VERS,
+	.match_table = hca_table,
 	.match_device = iwch_device_match,
 	.alloc_device = iwch_device_alloc,
 	.uninit_device = iwch_uninit_device,
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 43c5a3c97bc864..c99b9e35515f89 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -48,23 +48,17 @@
 /*
  * Macros needed to support the PCI Device ID Table ...
  */
-#define CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN \
-	static struct hca_ent { \
-		unsigned vendor; \
-		unsigned device; \
-	} hca_table[] = {
+#define CH_PCI_DEVICE_ID_TABLE_DEFINE_BEGIN                                    \
+	static const struct verbs_match_ent hca_table[] = {
 
 #define CH_PCI_DEVICE_ID_FUNCTION \
 		0x4
 
-#define CH_PCI_ID_TABLE_ENTRY(__DeviceID) \
-		{ \
-			.vendor = PCI_VENDOR_ID_CHELSIO, \
-			.device = (__DeviceID), \
-		}
+#define CH_PCI_ID_TABLE_ENTRY(__DeviceID)                                      \
+	VERBS_PCI_MATCH(PCI_VENDOR_ID_CHELSIO, __DeviceID, NULL)
 
 #define CH_PCI_DEVICE_ID_TABLE_DEFINE_END \
-	}
+	{} }
 
 #include "t4_chip_type.h"
 #include "t4_pci_id_tbl.h"
@@ -401,31 +395,13 @@ int c4iw_abi_version = 1;
 
 static bool c4iw_device_match(struct verbs_sysfs_dev *sysfs_dev)
 {
-	const char *uverbs_sys_path = sysfs_dev->sysfs_path;
 	char value[32], *cp;
-	unsigned vendor, device, fw_maj, fw_min;
-	int i;
-
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
-				value, sizeof value) < 0)
-		return false;
-	sscanf(value, "%i", &vendor);
+	unsigned int fw_maj, fw_min;
 
-	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
-				value, sizeof value) < 0)
+	/* Rely on the core code to match PCI devices */
+	if (!sysfs_dev->match)
 		return false;
-	sscanf(value, "%i", &device);
-
-	for (i = 0; i < sizeof hca_table / sizeof hca_table[0]; ++i)
-		if (vendor == hca_table[i].vendor &&
-		    device == hca_table[i].device) {
-			sysfs_dev->provider_data = &hca_table[i];
-			goto found;
-		}
-
-	return false;
 
-found:
 	/*
 	 * Verify that the firmware major number matches.  Major number
 	 * mismatches are fatal.  Minor number mismatches are tolerated.
@@ -461,7 +437,6 @@ found:
 static struct verbs_device *c4iw_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 {
 	struct c4iw_dev *dev;
-	struct hca_ent *hca_ent = sysfs_dev->provider_data;
 
 	c4iw_page_size = sysconf(_SC_PAGESIZE);
 	c4iw_page_shift = long_log2(c4iw_page_size);
@@ -477,7 +452,7 @@ static struct verbs_device *c4iw_device_alloc(struct verbs_sysfs_dev *sysfs_dev)
 
 	pthread_spin_init(&dev->lock, PTHREAD_PROCESS_PRIVATE);
 	c4iw_abi_version = sysfs_dev->abi_ver;
-	dev->chip_version = CHELSIO_CHIP_VERSION(hca_ent->device >> 8);
+	dev->chip_version = CHELSIO_CHIP_VERSION(sysfs_dev->match->device >> 8);
 	dev->abi_version = sysfs_dev->abi_ver;
 	list_node_init(&dev->list);
 
@@ -517,6 +492,7 @@ static const struct verbs_device_ops c4iw_dev_ops = {
 	.name = "cxgb4",
 	.match_min_abi_version = 0,
 	.match_max_abi_version = INT_MAX,
+	.match_table = hca_table,
 	.match_device = c4iw_device_match,
 	.alloc_device = c4iw_device_alloc,
 	.uninit_device = c4iw_uninit_device,
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
