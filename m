From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 01/19] rdma: update uapi headers
Date: Wed, 20 Feb 2019 09:21:18 +0200
Message-ID: <20190220072136.3840-2-leon@kernel.org>
References: <20190220072136.3840-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190220072136.3840-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Update rdma_netlink,h file upto kernel commit
f2a0e45f36b0 RDMA/nldev: Don't expose number of not-visible entries

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 64 +++++++++++++++++++++------
 1 file changed, 50 insertions(+), 14 deletions(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 04c80ceb..5027c627 100644
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
 
+/* The latest version that the iwpm kernel supports */
+#define IWPM_UABI_VERSION	4
+
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
@@ -430,6 +456,16 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
 	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
 
+	/*
+	 * Indexes to get/set secific entry,
+	 * for QP use RDMA_NLDEV_ATTR_RES_LQPN
+	 */
+	RDMA_NLDEV_ATTR_RES_PDN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CQN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_MRN,               /* u32 */
+	RDMA_NLDEV_ATTR_RES_CM_IDN,            /* u32 */
+	RDMA_NLDEV_ATTR_RES_CTXN,	       /* u32 */
+
 	/*
 	 * Always the end
 	 */
-- 
2.19.1
