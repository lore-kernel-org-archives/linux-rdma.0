From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 1/5] verbs: Remove diagnostic ignored "-Wmissing-prototypes"
Date: Thu, 31 Aug 2017 14:50:55 -0600
Message-ID: <1504212659-9674-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504212659-9674-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When the symbol version function __ibv_register_driver
was deleted the pragma was accidently left behind.

Fixes: 6843def955d0 ("verbs: Remove ibv_register_driver")
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 libibverbs/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/libibverbs/init.c b/libibverbs/init.c
index 4d064bc6cdf213..e0fa4caae6f125 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -50,8 +50,6 @@
 #include <util/util.h>
 #include "ibverbs.h"
 
-#pragma GCC diagnostic ignored "-Wmissing-prototypes"
-
 int abi_ver;
 
 struct ibv_sysfs_dev {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
