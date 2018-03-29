From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH v4 iproute2-next 1/7] rdma: update rdma_netlink.h
Date: Thu, 29 Mar 2018 09:10:30 -0700
Message-ID: <8b0ef68809c44e8d92d47a7bf95a69f2d9743407.1522359537.git.swise@opengridcomputing.com>
References: <cover.1522359537.git.swise@opengridcomputing.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1522359537.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: dsahern@gmail.com
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise@opengridcomputing.com>

Pull in the latest rdma_netlink.h which has support for
the rdma nldev resource tracking objects being added
with this patch series.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index dbac3b8..9446a72 100644
--- a/rdma/include/uapi/rdma/rdma_netlink.h
+++ b/rdma/include/uapi/rdma/rdma_netlink.h
@@ -238,6 +238,14 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_RES_CM_ID_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_CQ_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_MR_GET, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_PD_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -350,6 +358,36 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_RES_KERN_NAME,		/* string */
 
+	RDMA_NLDEV_ATTR_RES_CM_ID,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY,	/* nested table */
+	/*
+	 * rdma_cm_id port space.
+	 */
+	RDMA_NLDEV_ATTR_RES_PS,			/* u32 */
+	/*
+	 * Source and destination socket addresses
+	 */
+	RDMA_NLDEV_ATTR_RES_SRC_ADDR,		/* __kernel_sockaddr_storage */
+	RDMA_NLDEV_ATTR_RES_DST_ADDR,		/* __kernel_sockaddr_storage */
+
+	RDMA_NLDEV_ATTR_RES_CQ,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_CQ_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CQE,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_USECNT,		/* u64 */
+	RDMA_NLDEV_ATTR_RES_POLL_CTX,		/* u8 */
+
+	RDMA_NLDEV_ATTR_RES_MR,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_MR_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_RKEY,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_LKEY,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_IOVA,		/* u64 */
+	RDMA_NLDEV_ATTR_RES_MRLEN,		/* u64 */
+
+	RDMA_NLDEV_ATTR_RES_PD,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_PD_ENTRY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
+	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _RDMA_NETLINK_H */
-- 
1.8.3.1
