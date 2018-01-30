From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma/wip/jgg-for-next] RDMA/netlink: Hide unimplemented NLDEV commands
Date: Tue, 30 Jan 2018 17:07:16 +0200
Message-ID: <20180130150716.16372-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The nldev was implemented by following devlink implementation,
including SET/DEL/NEW commands. However these commands were not
implemented and hence don't need to be exposed.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/uapi/rdma/rdma_netlink.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 17e59bec169e..4c77e2a7b07e 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -227,16 +227,14 @@ enum rdma_nldev_command {
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

-	RDMA_NLDEV_CMD_RES_GET, /* can dump */
+	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
+
+	/* 6 - 8 are free to use */
+
+	RDMA_NLDEV_CMD_RES_GET = 9, /* can dump */

 	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */

--
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
