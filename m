From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 06/10] verbs: Provide common code to match providers against kernel devices
Date: Tue, 19 Sep 2017 15:18:47 -0600
Message-ID: <1505855931-4956-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1505855931-4956-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1505855931-4956-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Checking the PCI device against a table is basically duplicated in every
driver. Follow the pattern from the kernel and attach a matching table to
the verbs_device_ops driver entry point that describes all the kernel
devices the provider can handle and have the core code match against that
table.

The driver gets a pointer to the table entry that matches in the allocation
function.

This implementation is based around modalias instead of reading the PCI
specific vendor & device files. modalias lets us support the ACPI and OF
provider and provides a straightforward path to make the providers demand
load based on their supported modalias strings, like the kernel.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/driver.h | 43 +++++++++++++++++++++++++++
 libibverbs/init.c   | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 168728cfa1a524..a3cdbe1e60cbad 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -96,14 +96,56 @@ struct verbs_qp {
 	struct verbs_xrcd       *xrcd;
 };
 
+enum {
+	VERBS_MATCH_SENTINEL = 0,
+	VERBS_MATCH_PCI = 1,
+	VERBS_MATCH_MODALIAS = 2,
+};
+
+struct verbs_match_ent {
+	void *driver_data;
+	const char *modalias;
+	uint16_t vendor;
+	uint16_t device;
+	uint8_t kind;
+};
+#define VERBS_PCI_MATCH(_vendor, _device, _data)                               \
+	{                                                                      \
+	    .driver_data = (_data),                                            \
+	    .vendor = (_vendor),                                               \
+	    .device = (_device),                                               \
+	    .kind = VERBS_MATCH_PCI,                                           \
+	}
+
+#define VERBS_MODALIAS_MATCH(_mod_str, _data)                                  \
+	{                                                                      \
+	    .driver_data = (_data),                                            \
+	    .modalias = (_mod_str),                                            \
+	    .kind = VERBS_MATCH_MODALIAS,                                      \
+	}
+
+/* Matching on the IB device name is STRONGLY discouraged. This will only
+ * match if there is no device/modalias file available, and it will eventually
+ * be disabled entirely if the kernel supports renaming. Use is strongly
+ * discouraged.
+ */
+#define VERBS_NAME_MATCH(_name_prefix, _data)                                  \
+	{                                                                      \
+	    .driver_data = (_data),                                            \
+	    .modalias = "rdma_device:*N" _name_prefix "*",                     \
+	    .kind = VERBS_MATCH_MODALIAS,                                      \
+	}
+
 /* A rdma device detected in sysfs */
 struct verbs_sysfs_dev {
 	struct list_node entry;
 	void *provider_data;
+	const struct verbs_match_ent *match;
 	char sysfs_name[IBV_SYSFS_NAME_MAX];
 	char ibdev_name[IBV_SYSFS_NAME_MAX];
 	char sysfs_path[IBV_SYSFS_PATH_MAX];
 	char ibdev_path[IBV_SYSFS_PATH_MAX];
+	char modalias[512];
 	int abi_ver;
 	struct timespec time_created;
 };
@@ -114,6 +156,7 @@ struct verbs_device_ops {
 
 	int match_min_abi_version;
 	int match_max_abi_version;
+	const struct verbs_match_ent *match_table;
 
 	bool (*match_device)(struct verbs_sysfs_dev *sysfs_dev);
 
diff --git a/libibverbs/init.c b/libibverbs/init.c
index d75d70b195a6f6..ff2c60ffcbc963 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -46,6 +46,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <assert.h>
+#include <fnmatch.h>
 
 #include <util/util.h>
 #include "ibverbs.h"
@@ -138,6 +139,11 @@ static int find_sysfs_devs(struct list_head *tmp_sysfs_dev_list)
 					value, sizeof value) > 0)
 			sysfs_dev->abi_ver = strtol(value, NULL, 10);
 
+		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path,
+					"device/modalias", sysfs_dev->modalias,
+					sizeof(sysfs_dev->modalias)) <= 0)
+			sysfs_dev->modalias[0] = 0;
+
 		list_add(tmp_sysfs_dev_list, &sysfs_dev->entry);
 		sysfs_dev      = NULL;
 	}
@@ -340,12 +346,86 @@ out:
 	closedir(conf_dir);
 }
 
+/* Match a single modalias value */
+static bool match_modalias(const struct verbs_match_ent *ent, const char *value)
+{
+	char pci_ma[100];
+
+	switch (ent->kind) {
+	case VERBS_MATCH_MODALIAS:
+		return fnmatch(ent->modalias, value, 0) == 0;
+	case VERBS_MATCH_PCI:
+		snprintf(pci_ma, sizeof(pci_ma), "pci:v%08Xd%08Xsv*",
+			 ent->vendor, ent->device);
+		return fnmatch(pci_ma, value, 0) == 0;
+	default:
+		return false;
+	}
+}
+
+/* Search a null terminated table of verbs_match_ent's and return the one
+ * that matches the device the verbs sysfs device is bound to or NULL.
+ */
+static const struct verbs_match_ent *
+match_modalias_device(const struct verbs_device_ops *ops,
+		      struct verbs_sysfs_dev *sysfs_dev)
+{
+	const struct verbs_match_ent *i;
+
+	for (i = ops->match_table; i->kind != VERBS_MATCH_SENTINEL; i++)
+		if (match_modalias(i, sysfs_dev->modalias))
+			return i;
+
+	return NULL;
+}
+
+/* Match the device name itself */
+static const struct verbs_match_ent *
+match_name(const struct verbs_device_ops *ops,
+		      struct verbs_sysfs_dev *sysfs_dev)
+{
+	char name_ma[100];
+	const struct verbs_match_ent *i;
+
+	if (!check_snprintf(name_ma, sizeof(name_ma),
+			    "rdma_device:N%s", sysfs_dev->ibdev_name))
+		return NULL;
+
+	for (i = ops->match_table; i->kind != VERBS_MATCH_SENTINEL; i++)
+		if (match_modalias(i, name_ma))
+			return i;
+
+	return NULL;
+}
+
 /* True if the provider matches the selected rdma sysfs device */
 static bool match_device(const struct verbs_device_ops *ops,
 			 struct verbs_sysfs_dev *sysfs_dev)
 {
-	if (!ops->match_device(sysfs_dev))
-		return false;
+	if (ops->match_table) {
+		/* The internally generated alias is checked first, since some
+		 * devices like rxe can attach to a random modalias, including
+		 * ones that match other providers.
+		 */
+		sysfs_dev->match = match_name(ops, sysfs_dev);
+		if (!sysfs_dev->match)
+			sysfs_dev->match =
+			    match_modalias_device(ops, sysfs_dev);
+	}
+
+	if (ops->match_device) {
+		/* If a matching function is provided then it is called
+		 * unconditionally after the table match above, it is
+		 * responsible for determining if the device matches based on
+		 * the match pointer and any other internal information.
+		 */
+		if (!ops->match_device(sysfs_dev))
+			return false;
+	} else {
+		/* With no match function, we must have a table match */
+		if (!sysfs_dev->match)
+			return false;
+	}
 
 	if (sysfs_dev->abi_ver < ops->match_min_abi_version ||
 	    sysfs_dev->abi_ver > ops->match_max_abi_version) {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
