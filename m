From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v3 1/4] IB/netlink: Add defines for local service requests through netlink
Date: Thu,  4 Jun 2015 08:26:46 -0400
Message-ID: <1433420809-13529-2-git-send-email-kaike.wan@intel.com>
References: <1433420809-13529-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433420809-13529-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds netlink defines for SA client, local service group, local
service operations, and related attributes.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h |   56 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 6e4bb42..bc30b90 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -7,12 +7,14 @@ enum {
 	RDMA_NL_RDMA_CM = 1,
 	RDMA_NL_NES,
 	RDMA_NL_C4IW,
+	RDMA_NL_SA,
 	RDMA_NL_NUM_CLIENTS
 };
 
 enum {
 	RDMA_NL_GROUP_CM = 1,
 	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_LS,
 	RDMA_NL_NUM_GROUPS
 };
 
@@ -128,5 +130,59 @@ enum {
 	IWPM_NLA_ERR_MAX
 };
 
+/* Local service group opcodes */
+enum {
+	RDMA_NL_LS_OP_RESOLVE = 0,
+	RDMA_NL_LS_OP_SET_TIMEOUT,
+	RDMA_NL_LS_NUM_OPS
+};
+
+/* Local service netlink message flags */
+#define RDMA_NL_LS_F_OK		0x0100	/* Success response */
+#define RDMA_NL_LS_F_ERR	0x0200	/* Failed response */
+
+/* Local service attribute type */
+enum {
+	LS_NLA_TYPE_STATUS = 0,
+	LS_NLA_TYPE_PATH_RECORD,
+	LS_NLA_TYPE_TIMEOUT,
+	LS_NLA_TYPE_MAX
+};
+
+/* Local service status attribute */
+enum {
+	LS_NLA_STATUS_SUCCESS = 0,
+	LS_NLA_STATUS_EINVAL,
+	LS_NLA_STATUS_ENODATA,
+	LS_NLA_STATUS_MAX
+};
+
+struct rdma_nla_ls_status {
+	__u32		status;
+};
+
+/* Local service pathrecord attribute */
+/* Flags for pathrecord */
+enum {
+	LS_NLA_PATH_F_GMP		= 1,
+	LS_NLA_PATH_F_PRIMARY		= (1<<1),
+	LS_NLA_PATH_F_ALTERNATE		= (1<<2),
+	LS_NLA_PATH_F_OUTBOUND		= (1<<3),
+	LS_NLA_PATH_F_INBOUND		= (1<<4),
+	LS_NLA_PATH_F_INBOUND_REVERSE	= (1<<5),
+	LS_NLA_PATH_F_BIDIRECTIONAL	= (LS_NLA_PATH_F_OUTBOUND |
+					  LS_NLA_PATH_F_INBOUND_REVERSE),
+	LS_NLA_PATH_F_USER		= (1<<6)
+};
+
+struct rdma_nla_ls_path_rec {
+	__u32	flags;
+	__u32	path_rec[0];
+};
+
+/* Local service timeout attribute */
+struct rdma_nla_ls_timeout {
+	__u32		timeout;
+};
 
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
1.7.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
