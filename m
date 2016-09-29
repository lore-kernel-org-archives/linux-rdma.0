From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 7/9] Remove old MADV_DONTFORK/DOFORK compat
Date: Thu, 29 Sep 2016 14:47:54 -0600
Message-ID: <1475182076-5411-8-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

All supported distros have this now.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/src/memory.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/libibverbs/src/memory.c b/libibverbs/src/memory.c
index 8e728c4f61fc..5c8255d47c15 100644
--- a/libibverbs/src/memory.c
+++ b/libibverbs/src/memory.c
@@ -46,17 +46,6 @@
 
 #include "ibverbs.h"
 
-/*
- * Most distro's headers don't have these yet.
- */
-#ifndef MADV_DONTFORK
-#define MADV_DONTFORK	10
-#endif
-
-#ifndef MADV_DOFORK
-#define MADV_DOFORK	11
-#endif
-
 struct ibv_mem_node {
 	enum {
 		IBV_RED,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
