From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH v2 12/45] RDMA/cxgb4: Remove the obsolete kernel module option 'c4iw_debug'
Date: Wed, 11 Oct 2017 10:48:54 -0700
Message-ID: <20171011174927.25113-13-bart.vanassche@wdc.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch avoids that building the cxgb4 module with W=1 triggers
a complaint about a local variable that has not been declared static.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 2331e7d57704..f3235c6169d4 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -99,10 +99,6 @@ module_param(enable_tcp_window_scaling, int, 0644);
 MODULE_PARM_DESC(enable_tcp_window_scaling,
 		 "Enable tcp window scaling (default=1)");
 
-int c4iw_debug;
-module_param(c4iw_debug, int, 0644);
-MODULE_PARM_DESC(c4iw_debug, "obsolete");
-
 static int peer2peer = 1;
 module_param(peer2peer, int, 0644);
 MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=1)");
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
