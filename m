From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 1/2] Function for improved node descriptions
Date: Thu, 24 Feb 2011 14:05:58 -0500
Message-ID: <20110224190558.6970.96776.stgit@homer>
References: <20110224190503.6970.47809.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110224190503.6970.47809.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes from Version 2:

Changed the function to skip over '%' fields that aren't supported and added
code to ensure the string is null terminated no matter how it was formatted.

Changes from Version 1:

Replaced the original substitution of the hostname for '@' with an
implementation of the '%h' and '%d' fields.

Description:

This patch adds a function to do variable substitution in the node
description. If the node description contains a '%h' it will be replaced at
read time with the hostname of the node. If the provided source string
contains a '%d' it will be replaced at read time with the name of the HCA.

For example, if the node description of the second HCA on node-a13 is
set to'%h: %d', at read time this will be expanded to read "node-a2: qib1".

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---
 drivers/infiniband/core/mad.c |   39 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_mad.h         |    9 +++++++++
 include/rdma/ib_verbs.h       |    3 ++-
 3 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 822cfdc..3b5751d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,7 @@
 #include "mad_rmpp.h"
 #include "smi.h"
 #include "agent.h"
+#include "linux/utsname.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("kernel IB MAD API");
@@ -932,6 +933,44 @@ int ib_get_mad_data_offset(u8 mgmt_class)
 }
 EXPORT_SYMBOL(ib_get_mad_data_offset);
 
+void ib_build_node_desc(struct ib_smp *smp, struct ib_device *dev)
+{
+	char *dest = smp->data;
+	char *end = dest + IB_DEVICE_DESC_MAX-1;
+	char *src = dev->node_desc;
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
+				for (; *field && (*field != '.') &&
+					(dest < end);)
+					*dest++ = *field++;
+				break;
+			case 'd':
+				field = dev->name;
+				src++;
+				for (; *field && (dest < end);)
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
index d3b9401..417a371 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -40,6 +40,7 @@
 #include <linux/list.h>
 
 #include <rdma/ib_verbs.h>
+#include <rdma/ib_smi.h>
 
 /* Management base version */
 #define IB_MGMT_BASE_VERSION			1
@@ -637,6 +638,14 @@ int ib_is_mad_class_rmpp(u8 mgmt_class);
 int ib_get_mad_data_offset(u8 mgmt_class);
 
 /**
+ * ib_build_node_desc - copies the node description and replaces
+ * any @ markers with the present system node name.
+ * @dest: destination
+ * @src: source
+ */
+void ib_build_node_desc(struct ib_smp *smp, struct ib_device *dev);
+
+/**
  * ib_get_rmpp_segment - returns the data buffer for a given RMPP segment.
  * @send_buf: Previously allocated send data buffer.
  * @seg_num: number of segment to return
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 55cd0a0..a5986af 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -938,6 +938,7 @@ enum ib_mad_result {
 };
 
 #define IB_DEVICE_NAME_MAX 64
+#define IB_DEVICE_DESC_MAX 64
 
 struct ib_cache {
 	rwlock_t                lock;
@@ -1165,7 +1166,7 @@ struct ib_device {
 	int			     uverbs_abi_ver;
 	u64			     uverbs_cmd_mask;
 
-	char			     node_desc[64];
+	char			     node_desc[IB_DEVICE_DESC_MAX];
 	__be64			     node_guid;
 	u32			     local_dma_lkey;
 	u8                           node_type;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
