From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] RDMA/uverbs: Initialize cq_context appropriately
Date: Tue,  1 Aug 2017 10:58:35 +0530
Message-ID: <1501565315-3183-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Initializing cq_context with ev_queue in create_cq(), leads to NULL pointer
dereference in ib_uverbs_comp_handler(), if application doesnot use completion
channel. This patch fixes the cq_context initialization.

Fixes: 1e7710f3f65 ("IB/core: Change completion channel to use the reworked")
Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2c98533a0203..8c829522d8c4 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1015,7 +1015,8 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	cq->uobject       = &obj->uobject;
 	cq->comp_handler  = ib_uverbs_comp_handler;
 	cq->event_handler = ib_uverbs_cq_event_handler;
-	cq->cq_context    = &ev_file->ev_queue;
+	cq->cq_context    = (cmd->comp_channel >= 0) ?
+				&ev_file->ev_queue : NULL;
 	atomic_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
