From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/32] libibumad: include umad_str.h in umad_str.c
Date: Thu, 13 Oct 2016 19:51:04 +0200
Message-ID: <1476381095-20041-2-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So that we have the prototypes available in the implementation file
and do get proper type checking for them.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libibumad/umad_str.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libibumad/umad_str.c b/libibumad/umad_str.c
index 79d51af..d4832e1 100644
--- a/libibumad/umad_str.c
+++ b/libibumad/umad_str.c
@@ -40,6 +40,7 @@
 #include <infiniband/umad_sm.h>
 #include <infiniband/umad_sa.h>
 #include <infiniband/umad_cm.h>
+#include "umad_str.h"
 
 const char * umad_class_str(uint8_t mgmt_class)
 {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
