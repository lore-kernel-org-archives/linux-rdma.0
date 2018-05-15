From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v3 iproute2-next 1/3] rdma: update rdma_netlink.h to get new
 driver attributes
Date: Tue, 15 May 2018 13:41:02 -0700
Message-ID: <c3ca5acd90cd6ba56cde78730a27e868ceba02d4.1526483157.git.swise@opengridcomputing.com>
References: <cover.1526483157.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1526483157.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Pull in the rdma_netlink.h changes from kernel
commits:

25a0ad85156a ("RDMA/nldev: Add explicit pad attribute")
da5c85078215 ("RDMA/nldev: add driver-specific resource tracking)"
0d52d803767e ("RDMA/uapi: Fix uapi breakage")

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 60416ed..6513fb8 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -249,10 +249,22 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_NUM_OPS
 };
 
+enum {
+	RDMA_NLDEV_ATTR_ENTRY_STRLEN = 16,
+};
+
+enum rdma_nldev_print_type {
+	RDMA_NLDEV_PRINT_TYPE_UNSPEC,
+	RDMA_NLDEV_PRINT_TYPE_HEX,
+};
+
 enum rdma_nldev_attr {
 	/* don't change the order or add anything between, this is ABI! */
 	RDMA_NLDEV_ATTR_UNSPEC,
 
+	/* Pad attribute for 64b alignment */
+	RDMA_NLDEV_ATTR_PAD = RDMA_NLDEV_ATTR_UNSPEC,
+
 	/* Identifier for ib_device */
 	RDMA_NLDEV_ATTR_DEV_INDEX,		/* u32 */
 
@@ -387,7 +399,6 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
 	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
 	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
-
 	/*
 	 * Provides logical name and index of netdevice which is
 	 * connected to physical port. This information is relevant
@@ -400,7 +411,24 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
 	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
+	/*
+	 * driver-specific attributes.
+	 */
+	RDMA_NLDEV_ATTR_DRIVER,			/* nested table */
+	RDMA_NLDEV_ATTR_DRIVER_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_DRIVER_STRING,		/* string */
+	/*
+	 * u8 values from enum rdma_nldev_print_type
+	 */
+	RDMA_NLDEV_ATTR_DRIVER_PRINT_TYPE,	/* u8 */
+	RDMA_NLDEV_ATTR_DRIVER_S32,		/* s32 */
+	RDMA_NLDEV_ATTR_DRIVER_U32,		/* u32 */
+	RDMA_NLDEV_ATTR_DRIVER_S64,		/* s64 */
+	RDMA_NLDEV_ATTR_DRIVER_U64,		/* u64 */
 
+	/*
+	 * Always the end
+	 */
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _RDMA_NETLINK_H */
-- 
1.8.3.1
