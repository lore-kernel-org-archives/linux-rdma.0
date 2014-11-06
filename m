From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 1/6] ib/mad: Add function to support format specifiers for node description
Date: Thu,  6 Nov 2014 17:06:35 -0500
Message-ID: <1415311595-29720-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

ib_build_node_desc - prints src node description into dest while mapping format
specifiers

Specifiers supported:
%h system hostname
%d device name

Define a default Node Description format to be "%h %d"

Original work done by Mike Heinz.

The function signature is generic to support some devices which are not
processing an ib_smp object when calling this function.

Reviewed-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Michael Heinz <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---

Changes from V1
	remove unnecessary ib_smi include

 drivers/infiniband/core/mad.c | 37 +++++++++++++++++++++++++++++++++++++
 include/rdma/ib_mad.h         | 17 +++++++++++++++++
 include/rdma/ib_verbs.h       |  6 ++++--
 3 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 74c30f4..93cf8a0 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -39,6 +39,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/utsname.h>
 #include <rdma/ib_cache.h>
 
 #include "mad_priv.h"
@@ -996,6 +997,42 @@ int ib_get_mad_data_offset(u8 mgmt_class)
 }
 EXPORT_SYMBOL(ib_get_mad_data_offset);
 
+void ib_build_node_desc(char *dest, char *src, int dest_len,
+			struct ib_device *dev)
+{
+	char *end = dest + dest_len-1;
+	char *field;
+
+	while (*src && (dest < end)) {
+		if (*src != '%') {
+			*dest++ = *src++;
+		} else {
+			src++;
+			switch (*src) {
+			case 'h':
+				field = init_utsname()->nodename;
+				src++;
+				while (*field && (*field != '.') && (dest < end))
+					*dest++ = *field++;
+			break;
+			case 'd':
+				field = dev->name;
+				src++;
+				while (*field && (dest < end))
+					*dest++ = *field++;
+				break;
+			default:
+				src++;
+			}
+		}
+	}
+	if (dest < end)
+		*dest = 0;
+	else
+		*end = 0;
+}
+EXPORT_SYMBOL(ib_build_node_desc);
+
 int ib_is_mad_class_rmpp(u8 mgmt_class)
 {
 	if ((mgmt_class == IB_MGMT_CLASS_SUBN_ADM) ||
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 9bb99e9..975642e 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -677,4 +677,21 @@ void ib_free_send_mad(struct ib_mad_send_buf *send_buf);
  */
 int ib_mad_kernel_rmpp_agent(struct ib_mad_agent *agent);
 
+#define IB_DEFAULT_ND_FORMAT "%h %d"
+/**
+ * ib_build_node_desc - prints src node description into dest while mapping
+ * format specifiers
+ *
+ * Specifiers supported:
+ * %h system hostname
+ * %d device name
+ *
+ * @dest: destination buffer
+ * @src: source buffer
+ * @dest_len: destination buffer length
+ * @dev: ib_device
+ */
+void ib_build_node_desc(char *dest, char *src, int dest_len,
+			struct ib_device *dev);
+
 #endif /* IB_MAD_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 470a011..f3ec6de 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -55,6 +55,8 @@
 
 extern struct workqueue_struct *ib_wq;
 
+#define IB_DEVICE_DESC_MAX 64
+
 union ib_gid {
 	u8	raw[16];
 	struct {
@@ -351,7 +353,7 @@ enum ib_device_modify_flags {
 
 struct ib_device_modify {
 	u64	sys_image_guid;
-	char	node_desc[64];
+	char	node_desc[IB_DEVICE_DESC_MAX];
 };
 
 enum ib_port_modify_flags {
@@ -1625,7 +1627,7 @@ struct ib_device {
 	u64			     uverbs_cmd_mask;
 	u64			     uverbs_ex_cmd_mask;
 
-	char			     node_desc[64];
+	char			     node_desc[IB_DEVICE_DESC_MAX];
 	__be64			     node_guid;
 	u32			     local_dma_lkey;
 	u8                           node_type;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
