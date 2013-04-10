From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 1/3] IB/core: Verify that QP handler is valid before dispatching events
Date: Wed, 10 Apr 2013 17:26:46 +0300
Message-ID: <1365604008-22455-2-git-send-email-ogerlitz@mellanox.com>
References: <1365604008-22455-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365604008-22455-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For QPs of type IB_QPT_XRC_TGT the IB core assigns a common event handler
__ib_shared_qp_event_handler, and the optionally supplied event handler
is stored. When the common handler is called it iterates on all opened
QPs and calles the original handlers without checking if they are
NULL, fix that.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a8fdd33..22192de 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -348,7 +348,8 @@ static void __ib_shared_qp_event_handler(struct ib_event *event, void *context)
 	struct ib_qp *qp = context;
 
 	list_for_each_entry(event->element.qp, &qp->open_list, open_list)
-		event->element.qp->event_handler(event, event->element.qp->qp_context);
+		if (event->element.qp->event_handler)
+			event->element.qp->event_handler(event, event->element.qp->qp_context);
 }
 
 static void __ib_insert_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
