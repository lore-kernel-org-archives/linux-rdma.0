From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 3/7] rxe: Remove duplicate include
Date: Thu,  8 Feb 2018 20:09:00 -0700
Message-ID: <20180209030904.22370-4-jgg@ziepe.ca>
References: <20180209030904.22370-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180209030904.22370-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This header must always be included after sys/socket.h and netinet/in.h to
avoid conflicts with glibc, and the .c file was including it too early.

rxe.h properly includes the uapi rdma_user_rxe.h header after the needed
includes.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/rxe/rxe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 5978df3abfa7b5..fcc8cfcb6fe49c 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -51,7 +51,6 @@
 
 #include <infiniband/driver.h>
 #include <infiniband/verbs.h>
-#include <rdma/rdma_user_rxe.h>
 
 #include "rxe_queue.h"
 #include "rxe-abi.h"
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
