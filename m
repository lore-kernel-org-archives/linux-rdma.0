From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH iproute2-next v2 06/10] rdma: Update kernel header file
Date: Wed, 17 Jan 2018 12:02:28 +0200
Message-ID: <20180117100232.3155-7-leon@kernel.org>
References: <20180117100232.3155-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117100232.3155-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Synchronize iporute2 package with latest kernel
RDMA netlink header file.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h | 61 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 48fbf3c3..23bef401 100644
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
 
@@ -303,6 +313,51 @@ enum rdma_nldev_attr {
 
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
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
