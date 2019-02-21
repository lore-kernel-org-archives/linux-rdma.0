From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Thu, 21 Feb 2019 08:19:07 -0800
Message-ID: <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
RDMA_NLDEV_CMD_DELLINK API.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 16 deletions(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 04c80cebef49..23a90ad52485 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -5,8 +5,7 @@
 #include <linux/types.h>
 
 enum {
-	RDMA_NL_RDMA_CM = 1,
-	RDMA_NL_IWCM,
+	RDMA_NL_IWCM = 2,
 	RDMA_NL_RSVD,
 	RDMA_NL_LS,	/* RDMA Local Services */
 	RDMA_NL_NLDEV,	/* RDMA device interface */
@@ -14,8 +13,7 @@ enum {
 };
 
 enum {
-	RDMA_NL_GROUP_CM = 1,
-	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_IWPM = 2,
 	RDMA_NL_GROUP_LS,
 	RDMA_NL_NUM_GROUPS
 };
@@ -24,15 +22,17 @@ enum {
 #define RDMA_NL_GET_OP(type) (type & ((1 << 10) - 1))
 #define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)
 
-enum {
-	RDMA_NL_RDMA_CM_ID_STATS = 0,
-	RDMA_NL_RDMA_CM_NUM_OPS
-};
+/* The minimum version that the iwpm kernel supports */
+#define IWPM_UABI_VERSION_MIN	3
+
+/* The latest version that the iwpm kernel supports */
+#define IWPM_UABI_VERSION	4
 
+/* iwarp port mapper message flags */
 enum {
-	RDMA_NL_RDMA_CM_ATTR_SRC_ADDR = 1,
-	RDMA_NL_RDMA_CM_ATTR_DST_ADDR,
-	RDMA_NL_RDMA_CM_NUM_ATTR,
+
+	/* Do not map the port for this IWPM request */
+	IWPM_FLAGS_NO_PORT_MAP = (1 << 0),
 };
 
 /* iwarp port mapper op-codes */
@@ -45,6 +45,7 @@ enum {
 	RDMA_NL_IWPM_HANDLE_ERR,
 	RDMA_NL_IWPM_MAPINFO,
 	RDMA_NL_IWPM_MAPINFO_NUM,
+	RDMA_NL_IWPM_HELLO,
 	RDMA_NL_IWPM_NUM_OPS
 };
 
@@ -83,20 +84,38 @@ enum {
 	IWPM_NLA_MANAGE_MAPPING_UNSPEC = 0,
 	IWPM_NLA_MANAGE_MAPPING_SEQ,
 	IWPM_NLA_MANAGE_ADDR,
-	IWPM_NLA_MANAGE_MAPPED_LOC_ADDR,
+	IWPM_NLA_MANAGE_FLAGS,
+	IWPM_NLA_MANAGE_MAPPING_MAX
+};
+
+enum {
+	IWPM_NLA_RMANAGE_MAPPING_UNSPEC = 0,
+	IWPM_NLA_RMANAGE_MAPPING_SEQ,
+	IWPM_NLA_RMANAGE_ADDR,
+	IWPM_NLA_RMANAGE_MAPPED_LOC_ADDR,
+	/* The following maintains bisectability of rdma-core */
+	IWPM_NLA_MANAGE_MAPPED_LOC_ADDR = IWPM_NLA_RMANAGE_MAPPED_LOC_ADDR,
 	IWPM_NLA_RMANAGE_MAPPING_ERR,
 	IWPM_NLA_RMANAGE_MAPPING_MAX
 };
 
-#define IWPM_NLA_MANAGE_MAPPING_MAX 3
-#define IWPM_NLA_QUERY_MAPPING_MAX  4
 #define IWPM_NLA_MAPINFO_SEND_MAX   3
+#define IWPM_NLA_REMOVE_MAPPING_MAX 3
 
 enum {
 	IWPM_NLA_QUERY_MAPPING_UNSPEC = 0,
 	IWPM_NLA_QUERY_MAPPING_SEQ,
 	IWPM_NLA_QUERY_LOCAL_ADDR,
 	IWPM_NLA_QUERY_REMOTE_ADDR,
+	IWPM_NLA_QUERY_FLAGS,
+	IWPM_NLA_QUERY_MAPPING_MAX,
+};
+
+enum {
+	IWPM_NLA_RQUERY_MAPPING_UNSPEC = 0,
+	IWPM_NLA_RQUERY_MAPPING_SEQ,
+	IWPM_NLA_RQUERY_LOCAL_ADDR,
+	IWPM_NLA_RQUERY_REMOTE_ADDR,
 	IWPM_NLA_RQUERY_MAPPED_LOC_ADDR,
 	IWPM_NLA_RQUERY_MAPPED_REM_ADDR,
 	IWPM_NLA_RQUERY_MAPPING_ERR,
@@ -114,6 +133,7 @@ enum {
 	IWPM_NLA_MAPINFO_UNSPEC = 0,
 	IWPM_NLA_MAPINFO_LOCAL_ADDR,
 	IWPM_NLA_MAPINFO_MAPPED_ADDR,
+	IWPM_NLA_MAPINFO_FLAGS,
 	IWPM_NLA_MAPINFO_MAX
 };
 
@@ -132,6 +152,12 @@ enum {
 	IWPM_NLA_ERR_MAX
 };
 
+enum {
+	IWPM_NLA_HELLO_UNSPEC = 0,
+	IWPM_NLA_HELLO_ABI_VERSION,
+	IWPM_NLA_HELLO_MAX
+};
+
 /*
  * Local service operations:
  *   RESOLVE - The client requests the local service to resolve a path.
@@ -229,9 +255,11 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_GET, /* can dump */
 	RDMA_NLDEV_CMD_SET,
 
-	/* 3 - 4 are free to use */
+	RDMA_NLDEV_CMD_NEWLINK,
 
-	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
+	RDMA_NLDEV_CMD_DELLINK,
+
+	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
 
 	/* 6 - 8 are free to use */
 
@@ -431,6 +459,20 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
 
 	/*
+	 * Indexes to get/set secific entry,
+	 * for QP use RDMA_NLDEV_ATTR_RES_LQPN
+	 */
+	RDMA_NLDEV_ATTR_RES_PDN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CQN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_MRN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CM_IDN,            /* u32 */
+	RDMA_NLDEV_ATTR_RES_CTXN,	       /* u32 */
+	/*
+	 * Identifies the rdma driver. eg: "rxe" or "siw"
+	 */
+	RDMA_NLDEV_ATTR_LINK_TYPE,		/* string */
+
+	/*
 	 * Always the end
 	 */
 	RDMA_NLDEV_ATTR_MAX
-- 
1.8.3.1
