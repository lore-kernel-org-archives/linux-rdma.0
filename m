From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v9 1/4] IB/netlink: Add defines for local service requests through netlink
Date: Fri, 14 Aug 2015 08:52:06 -0400
Message-ID: <1439556729-27876-2-git-send-email-kaike.wan@intel.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439556729-27876-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds netlink defines for local service client, local service
group, local service operations, and related attributes.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h |   82 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 6e4bb42..c19a5dc 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -7,12 +7,14 @@ enum {
 	RDMA_NL_RDMA_CM = 1,
 	RDMA_NL_NES,
 	RDMA_NL_C4IW,
+	RDMA_NL_LS,	/* RDMA Local Services */
 	RDMA_NL_NUM_CLIENTS
 };
 
 enum {
 	RDMA_NL_GROUP_CM = 1,
 	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_LS,
 	RDMA_NL_NUM_GROUPS
 };
 
@@ -128,5 +130,85 @@ enum {
 	IWPM_NLA_ERR_MAX
 };
 
+/*
+ * Local service operations:
+ *   RESOLVE - The client requests the local service to resolve a path.
+ *   SET_TIMEOUT - The local service requests the client to set the timeout.
+ */
+enum {
+	RDMA_NL_LS_OP_RESOLVE = 0,
+	RDMA_NL_LS_OP_SET_TIMEOUT,
+	RDMA_NL_LS_NUM_OPS
+};
+
+/* Local service netlink message flags */
+#define RDMA_NL_LS_F_ERR	0x0100	/* Failed response */
+
+/*
+ * Local service resolve operation family header.
+ * The layout for the resolve operation:
+ *    nlmsg header
+ *    family header
+ *    attributes
+ */
+
+/*
+ * Local service path use:
+ * Specify how the path(s) will be used.
+ *   ALL - For connected CM operation (6 pathrecords)
+ *   UNIDIRECTIONAL - For unidirectional UD (1 pathrecord)
+ *   GMP - For miscellaneous GMP like operation (at least 1 reversible
+ *         pathrecord)
+ */
+enum {
+	LS_RESOLVE_PATH_USE_ALL = 0,
+	LS_RESOLVE_PATH_USE_UNIDIRECTIONAL,
+	LS_RESOLVE_PATH_USE_GMP,
+	LS_RESOLVE_PATH_USE_MAX
+};
+
+#define LS_DEVICE_NAME_MAX 64
+
+struct rdma_ls_resolve_header {
+	__u8 device_name[LS_DEVICE_NAME_MAX];
+	__u8 port_num;
+	__u8 path_use;
+};
+
+/* Local service attribute type */
+#define RDMA_NLA_F_MANDATORY	(1 << 13)
+#define RDMA_NLA_TYPE_MASK	(~(NLA_F_NESTED | NLA_F_NET_BYTEORDER | \
+				  RDMA_NLA_F_MANDATORY))
+
+/*
+ * Local service attributes:
+ *   Attr Name       Size                       Byte order
+ *   -----------------------------------------------------
+ *   PATH_RECORD     struct ib_path_rec_data
+ *   TIMEOUT         u32                        cpu
+ *   SERVICE_ID      u64                        cpu
+ *   DGID            u8[16]                     BE
+ *   SGID            u8[16]                     BE
+ *   TCLASS          u8
+ *   PKEY            u16                        cpu
+ *   QOS_CLASS       u16                        cpu
+ */
+enum {
+	LS_NLA_TYPE_UNSPEC = 0,
+	LS_NLA_TYPE_PATH_RECORD,
+	LS_NLA_TYPE_TIMEOUT,
+	LS_NLA_TYPE_SERVICE_ID,
+	LS_NLA_TYPE_DGID,
+	LS_NLA_TYPE_SGID,
+	LS_NLA_TYPE_TCLASS,
+	LS_NLA_TYPE_PKEY,
+	LS_NLA_TYPE_QOS_CLASS,
+	LS_NLA_TYPE_MAX
+};
+
+/* Local service DGID/SGID attribute: big endian */
+struct rdma_nla_ls_gid {
+	__u8		gid[16];
+};
 
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
