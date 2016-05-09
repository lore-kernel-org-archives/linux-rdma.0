From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v1 1/1] [librdmacm] examples/rping.c: fix unwanted abort during qp creation
Date: Mon,  9 May 2016 13:14:36 +0530
Message-ID: <1462779876-9480-1-git-send-email-bharat@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Memset rping control block structure to 0 to avoid accessing garbage
values in the upcoming checks in librdmacm causing unwanted abort during
creation of qp.

Fixes: b873915aee7b ("librdmacm/rping: Persistent rping server")

Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 examples/rping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/examples/rping.c b/examples/rping.c
index a5aa8c5f38d6..a0d10779a8b1 100644
--- a/examples/rping.c
+++ b/examples/rping.c
@@ -759,6 +759,7 @@ static struct rping_cb *clone_cb(struct rping_cb *listening_cb)
 	struct rping_cb *cb = malloc(sizeof *cb);
 	if (!cb)
 		return NULL;
+	memset(cb, 0, sizeof *cb);
 	*cb = *listening_cb;
 	cb->child_cm_id->context = cb;
 	return cb;
-- 
2.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
