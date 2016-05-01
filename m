From: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: use RCU_INIT_POINTER() when NULLing.
Date: Sun,  1 May 2016 18:05:31 +0530
Message-ID: <1462106131-9073-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It is safe to use RCU_INIT_POINTER() to NULL a pointer, instead of
rcu_assign_pointer().
This results in slightly smaller/faster code.

Signed-off-by: Muhammad Falak R Wani <falakreyaz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index cfcdc16..34e0f90 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -1303,7 +1303,7 @@ static void cleanup_device_data(struct hfi1_devdata *dd)
 
 		spin_lock(&ppd->cc_state_lock);
 		cc_state = get_cc_state(ppd);
-		rcu_assign_pointer(ppd->cc_state, NULL);
+		RCU_INIT_POINTER(ppd->cc_state, NULL);
 		spin_unlock(&ppd->cc_state_lock);
 
 		if (cc_state)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
