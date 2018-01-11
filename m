From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 02/17] verbs: Include rdma/ib_user_verbs.h in kern-abi.h
Date: Thu, 11 Jan 2018 15:13:25 -0700
Message-ID: <20180111221340.965-3-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There are a few overlapping definitions that are identical in both
headers, delete them from kern-abi.h to make them includable.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/kern-abi.h | 62 ++++++---------------------------------------------
 1 file changed, 7 insertions(+), 55 deletions(-)

diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index f53e22fce5303b..d7acdaa9a4bca9 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -37,9 +37,14 @@
 
 #include <linux/types.h>
 
+#include <rdma/ib_user_verbs.h>
+
 /*
- * This file must be kept in sync with the kernel's version of
- * drivers/infiniband/include/ib_user_verbs.h
+ * This file contains copied data from the kernel's include/uapi/rdma/ib_user_verbs.h,
+ * now included above.
+ *
+ * Whenever possible use the definition from the kernel header and avoid
+ * copying from that header into this file.
  */
 
 /*
@@ -48,59 +53,6 @@
 #define IB_USER_VERBS_MIN_ABI_VERSION	3
 #define IB_USER_VERBS_MAX_ABI_VERSION	6
 
-#define IB_USER_VERBS_CMD_THRESHOLD    50
-
-enum {
-	IB_USER_VERBS_CMD_GET_CONTEXT,
-	IB_USER_VERBS_CMD_QUERY_DEVICE,
-	IB_USER_VERBS_CMD_QUERY_PORT,
-	IB_USER_VERBS_CMD_ALLOC_PD,
-	IB_USER_VERBS_CMD_DEALLOC_PD,
-	IB_USER_VERBS_CMD_CREATE_AH,
-	IB_USER_VERBS_CMD_MODIFY_AH,
-	IB_USER_VERBS_CMD_QUERY_AH,
-	IB_USER_VERBS_CMD_DESTROY_AH,
-	IB_USER_VERBS_CMD_REG_MR,
-	IB_USER_VERBS_CMD_REG_SMR,
-	IB_USER_VERBS_CMD_REREG_MR,
-	IB_USER_VERBS_CMD_QUERY_MR,
-	IB_USER_VERBS_CMD_DEREG_MR,
-	IB_USER_VERBS_CMD_ALLOC_MW,
-	IB_USER_VERBS_CMD_BIND_MW,
-	IB_USER_VERBS_CMD_DEALLOC_MW,
-	IB_USER_VERBS_CMD_CREATE_COMP_CHANNEL,
-	IB_USER_VERBS_CMD_CREATE_CQ,
-	IB_USER_VERBS_CMD_RESIZE_CQ,
-	IB_USER_VERBS_CMD_DESTROY_CQ,
-	IB_USER_VERBS_CMD_POLL_CQ,
-	IB_USER_VERBS_CMD_PEEK_CQ,
-	IB_USER_VERBS_CMD_REQ_NOTIFY_CQ,
-	IB_USER_VERBS_CMD_CREATE_QP,
-	IB_USER_VERBS_CMD_QUERY_QP,
-	IB_USER_VERBS_CMD_MODIFY_QP,
-	IB_USER_VERBS_CMD_DESTROY_QP,
-	IB_USER_VERBS_CMD_POST_SEND,
-	IB_USER_VERBS_CMD_POST_RECV,
-	IB_USER_VERBS_CMD_ATTACH_MCAST,
-	IB_USER_VERBS_CMD_DETACH_MCAST,
-	IB_USER_VERBS_CMD_CREATE_SRQ,
-	IB_USER_VERBS_CMD_MODIFY_SRQ,
-	IB_USER_VERBS_CMD_QUERY_SRQ,
-	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV,
-	IB_USER_VERBS_CMD_OPEN_XRCD,
-	IB_USER_VERBS_CMD_CLOSE_XRCD,
-	IB_USER_VERBS_CMD_CREATE_XSRQ,
-	IB_USER_VERBS_CMD_OPEN_QP
-};
-
-#define IB_USER_VERBS_CMD_COMMAND_MASK		0xff
-#define IB_USER_VERBS_CMD_FLAGS_MASK		0xff000000u
-#define IB_USER_VERBS_CMD_FLAGS_SHIFT		24
-
-
-#define IB_USER_VERBS_CMD_FLAG_EXTENDED		0x80ul
-
 /* use this mask for creating extended commands */
 #define IB_USER_VERBS_CMD_EXTENDED_MASK \
 	(IB_USER_VERBS_CMD_FLAG_EXTENDED << \
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
