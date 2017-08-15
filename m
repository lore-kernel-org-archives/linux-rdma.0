From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 1/2] cm: Don't allocate ib_cm workqueue with WQ_MEM_RECLAIM
Date: Tue, 15 Aug 2017 22:20:37 +0300
Message-ID: <1502824838-21745-2-git-send-email-sagi@grimberg.me>
References: <1502824838-21745-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502824838-21745-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

create_workqueue always creates the workqueue with WQ_MEM_RECLAIM
and silences a flush dependency warn for WQ_LEGACY. Instead, we
want to keep the warn in case the allocator tries to flush the
cm workqueue because its very likely that cm work execution will
yield memory allocations (for example cm connection requests).

Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 2b4d613a3474..838e3507eadc 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4201,7 +4201,7 @@ static int __init ib_cm_init(void)
 		goto error1;
 	}
 
-	cm.wq = create_workqueue("ib_cm");
+	cm.wq = alloc_workqueue("ib_cm", 0, 1);
 	if (!cm.wq) {
 		ret = -ENOMEM;
 		goto error2;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
