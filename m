From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/3] IB/core: Add locking around event dispatching on XRC target QPs
Date: Thu,  1 Aug 2013 18:49:53 +0300
Message-ID: <1375372194-23339-3-git-send-email-ogerlitz@mellanox.com>
References: <1375372194-23339-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375372194-23339-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Fix a potential race when event occurrs on a target XRC QP and in
the middle of reporting that on its shared qps, one of them is
destroyed by user space application. Also add note for kernel consumers
in ib_verbs.h that they must not destroy the QP from within the handler.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    3 +++
 include/rdma/ib_verbs.h         |    6 ++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 22192de..077fd64 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -346,10 +346,13 @@ EXPORT_SYMBOL(ib_destroy_srq);
 static void __ib_shared_qp_event_handler(struct ib_event *event, void *context)
 {
 	struct ib_qp *qp = context;
+	unsigned long flags;
 
+	spin_lock_irqsave(&qp->device->event_handler_lock, flags);
 	list_for_each_entry(event->element.qp, &qp->open_list, open_list)
 		if (event->element.qp->event_handler)
 			event->element.qp->event_handler(event, event->element.qp->qp_context);
+	spin_unlock_irqrestore(&qp->device->event_handler_lock, flags);
 }
 
 static void __ib_insert_xrcd_qp(struct ib_xrcd *xrcd, struct ib_qp *qp)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 645c3ce..a84d3df 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -635,6 +635,12 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_RESERVED_END		= 1 << 31,
 };
 
+
+/*
+ * Note: users may not call ib_close_qp or ib_destroy_qp from the event_handler
+ * callback to destroy the passed in QP.
+ */
+
 struct ib_qp_init_attr {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
