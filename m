From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/complib/cl_types.h: convert cl_status_t to int
Date: Thu, 04 Feb 2010 16:13:04 +0200
Message-ID: <4B6AD5F0.5000207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/complib/cl_types.h |   49 ++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/opensm/include/complib/cl_types.h b/opensm/include/complib/cl_types.h
index 17e0df8..a773e51 100644
--- a/opensm/include/complib/cl_types.h
+++ b/opensm/include/complib/cl_types.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2005 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2010 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  *
  * This software is available to you under a choice of one of two
@@ -263,31 +263,30 @@ typedef uint64_t net64_t;
 *
 * SYNOPSIS
 */
-typedef enum _cl_status {
-	CL_SUCCESS = 0,
-	CL_ERROR,
-	CL_INVALID_STATE,
-	CL_INVALID_OPERATION,
-	CL_INVALID_SETTING,
-	CL_INVALID_PARAMETER,
-	CL_INSUFFICIENT_RESOURCES,
-	CL_INSUFFICIENT_MEMORY,
-	CL_INVALID_PERMISSION,
-	CL_COMPLETED,
-	CL_NOT_DONE,
-	CL_PENDING,
-	CL_TIMEOUT,
-	CL_CANCELED,
-	CL_REJECT,
-	CL_OVERRUN,
-	CL_NOT_FOUND,
-	CL_UNAVAILABLE,
-	CL_BUSY,
-	CL_DISCONNECT,
-	CL_DUPLICATE,
+#define CL_SUCCESS                 0
+#define CL_ERROR                   1
+#define CL_INVALID_STATE           2
+#define CL_INVALID_OPERATION       3
+#define CL_INVALID_SETTING         4
+#define CL_INVALID_PARAMETER       5
+#define CL_INSUFFICIENT_RESOURCES  6
+#define CL_INSUFFICIENT_MEMORY     7
+#define CL_INVALID_PERMISSION      8
+#define CL_COMPLETED               9
+#define CL_NOT_DONE               10
+#define CL_PENDING                11
+#define CL_TIMEOUT                12
+#define CL_CANCELED               13
+#define CL_REJECT                 14
+#define CL_OVERRUN                15
+#define CL_NOT_FOUND              16
+#define CL_UNAVAILABLE            17
+#define CL_BUSY                   18
+#define CL_DISCONNECT             19
+#define CL_DUPLICATE              20
+#define CL_STATUS_COUNT           21 /* should be the last value */

-	CL_STATUS_COUNT		/* should be the last value */
-} cl_status_t;
+typedef int cl_status_t;
 /*
 * SEE ALSO
 *	Data Types, CL_STATUS_MSG
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
