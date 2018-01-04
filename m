From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next v1 6/9] rdma: Update kernel header file
Date: Thu,  4 Jan 2018 09:01:47 +0200
Message-ID: <20180104070150.15625-7-leon@kernel.org>
References: <20180104070150.15625-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180104070150.15625-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Synchronize iporute2 package with latest kernel
RDMA netlink header file.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/uapi/rdma/rdma_netlink.h | 58 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 48fbf3c3..a6f60c22 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _RDMA_NETLINK_H
-#define _RDMA_NETLINK_H
+#ifndef _UAPI_RDMA_NETLINK_H
+#define _UAPI_RDMA_NETLINK_H
 
 #include <linux/types.h>
 
@@ -236,6 +236,16 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_PORT_NEW,
 	RDMA_NLDEV_CMD_PORT_DEL,
 
+	RDMA_NLDEV_CMD_RES_GET, /* can dump */
+	RDMA_NLDEV_CMD_RES_SET,
+	RDMA_NLDEV_CMD_RES_NEW,
+	RDMA_NLDEV_CMD_RES_DEL,
+
+	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
+	RDMA_NLDEV_CMD_RES_QP_SET,
+	RDMA_NLDEV_CMD_RES_QP_NEW,
+	RDMA_NLDEV_CMD_RES_QP_DEL,
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -303,6 +313,50 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_ATTR_DEV_NODE_TYPE,		/* u8 */
 
+	RDMA_NLDEV_ATTR_RES_SUMMARY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX,	/* u64 */
+
+	RDMA_NLDEV_ATTR_RES_QP,			/* nested table */
+	RDMA_NLDEV_ATTR_RES_QP_ENTRY,		/* nested table */
+	/*
+	 * Local QPN
+	 */
+	RDMA_NLDEV_ATTR_RES_LQPN,		/* u32 */
+	/*
+	 * Remote QPN,
+	 * Applicable for RC and UC only IBTA 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQPN,		/* u32 */
+	/*
+	 * Receive Queue PSN,
+	 * Applicable for RC and UC only 11.2.5.3 QUERY QUEUE PAIR
+	 */
+	RDMA_NLDEV_ATTR_RES_RQ_PSN,		/* u32 */
+	/*
+	 * Send Queue PSN
+	 */
+	RDMA_NLDEV_ATTR_RES_SQ_PSN,		/* u32 */
+	RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE,	/* u8 */
+	/*
+	 * QP types as visible to RDMA/core, the reserved QPT
+	 * are not exported through this interface.
+	 */
+	RDMA_NLDEV_ATTR_RES_TYPE,		/* u8 */
+	RDMA_NLDEV_ATTR_RES_STATE,		/* u8 */
+	/*
+	 * Process ID created QP, in case of kernel PID is equal to 0
+	 * and this field won't be set, so user will distinguish user/kernel
+	 * processes without relying on PID number.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID,		/* u32 */
+	/*
+	 * The name of process created following resource.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID_COMM,		/* string */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _RDMA_NETLINK_H */
-- 
2.15.1
