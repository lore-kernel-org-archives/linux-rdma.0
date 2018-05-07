From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v1 iproute2-next 1/3] rdma: update rdma_netlink.h to get
 driver attrs
Date: Mon, 7 May 2018 08:53:10 -0700
Message-ID: <312486eb14b460e455e7b2926d7ea06e3a8411fc.1525709213.git.swise@opengridcomputing.com>
References: <cover.1525709213.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1525709213.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com, leon@kernel.org
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 37 ++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index 45474f1..40be0d8 100644
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
 
@@ -387,8 +399,31 @@ enum rdma_nldev_attr {
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
 
-	/* Netdev information for relevant protocols, like RoCE and iWARP */
+	/*
+	 * Provides logical name and index of netdevice which is
+	 * connected to physical port. This information is relevant
+	 * for RoCE and iWARP.
+	 *
+	 * The netdevices which are associated with containers are
+	 * supposed to be exported together with GID table once it
+	 * will be exposed through the netlink. Because the
+	 * associated netdevices are properties of GIDs.
+	 */
 	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
 	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
 
-- 
1.8.3.1
