From: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] Improved node descriptions
Date: Thu, 17 Feb 2011 16:31:03 -0500
Message-ID: <20110217213103.25708.4630.stgit@homer>
References: <20110217213017.25708.95042.stgit@homer>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110217213017.25708.95042.stgit@homer>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The common practice in IB fabrics is to set the description of an HCA to be
the hostname of the machine plus a description (i.e., "myhost hca-1",
"myhost hca-2", etc..)

This has a limitation, however.  The first is that if the machine's
hostname is set via DHCP, the HCA description may be set before the hostname
is, leading to an incorrect description. This can also occur if the machine's
hostname changes for some other reason after boot.

This can cause difficulties and confusion when trying to maintain a large
fabric - if all your nodes are described as "localhost HCA-1" it can be very
difficult to figure out which node is suffering from symbol errors.

This patch addresses the problem by providing a function to build the node
description. If the provided source string for the description contains an
'@' character, the function will substitute the current utsname.

This ensures that even after a fabric has been completely initialized, if
a node's hostname changes, that change will be reflected in the next sweep
of the SM, but also maintains compatibility with existing code since the
behavior is unchanged if the description string does not contain an '@'
character.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---
 drivers/infiniband/core/mad.c |   18 ++++++++++++++++++
 include/rdma/ib_mad.h         |    8 ++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 822cfdc..8e4ac68 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -41,6 +41,7 @@
 #include "mad_rmpp.h"
 #include "smi.h"
 #include "agent.h"
+#include "linux/utsname.h"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("kernel IB MAD API");
@@ -932,6 +933,23 @@ int ib_get_mad_data_offset(u8 mgmt_class)
 }
 EXPORT_SYMBOL(ib_get_mad_data_offset);
 
+void ib_build_node_desc(char *dest, char *src)
+{
+	int i;
+	for (i = 0; i < 64;) {
+		if (*src == '@') {
+			char *name = init_utsname()->nodename;
+			for (; *name && (*name != '.') && (i < 64); ++i)
+				*dest++ = *name++;
+			src++;
+		} else {
+			*dest++ = *src++;
+			i++;
+		}
+	}
+}
+EXPORT_SYMBOL(ib_build_node_desc);
+
 int ib_is_mad_class_rmpp(u8 mgmt_class)
 {
 	if ((mgmt_class == IB_MGMT_CLASS_SUBN_ADM) ||
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index d3b9401..5916617 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -637,6 +637,14 @@ int ib_is_mad_class_rmpp(u8 mgmt_class);
 int ib_get_mad_data_offset(u8 mgmt_class);
 
 /**
+ * ib_build_node_desc - copies the node description and replaces
+ * any @ markers with the present system node name.
+ * @dest: destination
+ * @src: source
+ */
+void ib_build_node_desc(char *dest, char *src);
+
+/**
  * ib_get_rmpp_segment - returns the data buffer for a given RMPP segment.
  * @send_buf: Previously allocated send data buffer.
  * @seg_num: number of segment to return

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
