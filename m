From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH iproute2-next 06/10] rdma: Update kernel header file
Date: Wed, 31 Jan 2018 10:11:52 +0200
Message-ID: <20180131081156.19607-7-leon@kernel.org>
References: <20180131081156.19607-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180131081156.19607-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Synchronize iporute2 package with latest kernel
RDMA netlink header file.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/uapi/rdma/rdma_netlink.h | 67 ++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 10 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 48fbf3c3..4c77e2a7 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-#ifndef _RDMA_NETLINK_H
-#define _RDMA_NETLINK_H
+#ifndef _UAPI_RDMA_NETLINK_H
+#define _UAPI_RDMA_NETLINK_H
 
 #include <linux/types.h>
 
@@ -227,14 +227,16 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_UNSPEC,
 
 	RDMA_NLDEV_CMD_GET, /* can dump */
-	RDMA_NLDEV_CMD_SET,
-	RDMA_NLDEV_CMD_NEW,
-	RDMA_NLDEV_CMD_DEL,
 
-	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
-	RDMA_NLDEV_CMD_PORT_SET,
-	RDMA_NLDEV_CMD_PORT_NEW,
-	RDMA_NLDEV_CMD_PORT_DEL,
+	/* 2 - 4 are free to use */
+
+	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
+
+	/* 6 - 8 are free to use */
+
+	RDMA_NLDEV_CMD_RES_GET = 9, /* can dump */
+
+	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
 
 	RDMA_NLDEV_NUM_OPS
 };
@@ -303,6 +305,51 @@ enum rdma_nldev_attr {
 
 	RDMA_NLDEV_ATTR_DEV_NODE_TYPE,		/* u8 */
 
+	RDMA_NLDEV_ATTR_RES_SUMMARY,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY,	/* nested table */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME,	/* string */
+	RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR,	/* u64 */
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
+	 * Process ID which created object,
+	 * in case of kernel origin, PID won't exist.
+	 */
+	RDMA_NLDEV_ATTR_RES_PID,		/* u32 */
+	/*
+	 * The name of process created following resource.
+	 * It will exist only for kernel objects.
+	 * For user created objects, the user is supposed
+	 * to read /proc/PID/comm file.
+	 */
+	RDMA_NLDEV_ATTR_RES_KERN_NAME,		/* string */
+
 	RDMA_NLDEV_ATTR_MAX
 };
-#endif /* _RDMA_NETLINK_H */
+#endif /* _UAPI_RDMA_NETLINK_H */
-- 
2.16.1
