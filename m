From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 1/2] rdma: Update RDMA header file
Date: Mon, 26 Mar 2018 11:28:28 +0300
Message-ID: <20180326082829.21214-2-leon@kernel.org>
References: <20180326082829.21214-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326082829.21214-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Update RDMA netlink header file to kernel commit 29cf1351d450
("RDMA/nldev: provide detailed PD information")

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/include/uapi/rdma/rdma_netlink.h | 38 +++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
index dbac3b82..9446a721 100644
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
