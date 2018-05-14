From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v2 iproute2-next 1/3] rdma: update rdma_netlink.h to get new
 driver attributes
Date: Mon, 14 May 2018 08:42:27 -0700
Message-ID: <ef3d41db66cf503f717f92f6e595c065ea4dbe4e.1526312594.git.swise@opengridcomputing.com>
References: <cover.1526312594.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1526312594.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Pull in the rdma_netlink.h changes from kernel
commits:

25a0ad85156a ("RDMA/nldev: Add explicit pad attribute")
da5c85078215 ("RDMA/nldev: add driver-specific resource tracking)"

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 60416ed..40be0d8 100644
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
 
@@ -387,6 +399,20 @@ enum rdma_nldev_attr {
 	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
 	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
 	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
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
 
 	/*
 	 * Provides logical name and index of netdevice which is
-- 
1.8.3.1
