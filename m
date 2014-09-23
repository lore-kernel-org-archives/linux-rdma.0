From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] IB/core: Fix race condition in ib_uverbs_open_qp
Date: Tue, 23 Sep 2014 12:38:26 +0300
Message-ID: <1411465106-3117-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

In ib_uverbs_open_qp, the sharable xrc target qp is created as a "pseudo" qp
and added to a list of qp's sharing the same physical QP. This is done before
the "pseudo" qp is assigned a uobject.

There is a race condition here if an async event arrives at the physical qp.
If the event is handled after the pseudo qp is added to the list, but before
it is assigned a uobject, the kernel crashes in ib_uverbs_qp_event_handler,
due to trying to dereference a NULL uobject pointer.

Note that simply checking for non-NULL is not enough, due to error flows
in ib_uverbs_open_qp. If the failure is after assigning the uobject, but
before the qp has fully been created, we still have a problem.

Thus, in ib_uverbs_qp_event_handler, we test that the uobject is present,
and also that it is live.

Reported-by: Matthew Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index c73b22a..bb6fea1 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -502,6 +502,10 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr)
 {
 	struct ib_uevent_object *uobj;
 
+	/* for XRC target qp's, check that qp is live */
+	if (!event->element.qp->uobject || !event->element.qp->uobject->live)
+		return;
+
 	uobj = container_of(event->element.qp->uobject,
 			    struct ib_uevent_object, uobject);
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
