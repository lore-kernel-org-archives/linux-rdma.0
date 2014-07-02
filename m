From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 7/8] rdmacm: Update addrinfo with XRC support
Date: Tue,  1 Jul 2014 23:11:18 -0700
Message-ID: <1404281479-6755-8-git-send-email-sean.hefty@intel.com>
References: <1404281479-6755-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404281479-6755-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove internal defines, and use libibverbs exported values
instead.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/addrinfo.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/src/addrinfo.c b/src/addrinfo.c
index 68eaddd..cdeb663 100644
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2010-2014 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -45,14 +45,6 @@
 #include <rdma/rdma_cma.h>
 #include <infiniband/ib.h>
 
-#ifdef IBV_XRC_OPS
-#define RDMA_QPT_XRC_SEND IBV_QPT_XRC_SEND
-#define RDMA_QPT_XRC_RECV IBV_QPT_XRC_RECV
-#else
-#define RDMA_QPT_XRC_SEND 9
-#define RDMA_QPT_XRC_RECV 10
-#endif
-
 struct rdma_addrinfo nohints;
 
 static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
@@ -68,8 +60,8 @@ static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 	switch (rai->ai_qp_type) {
 	case IBV_QPT_RC:
 	case IBV_QPT_UC:
-	case RDMA_QPT_XRC_SEND:
-	case RDMA_QPT_XRC_RECV:
+	case IBV_QPT_XRC_SEND:
+	case IBV_QPT_XRC_RECV:
 		ai->ai_socktype = SOCK_STREAM;
 		break;
 	case IBV_QPT_UD:
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
