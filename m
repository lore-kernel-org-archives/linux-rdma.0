From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue-BUmcmmAb0Fc@public.gmane.org>
Subject: [PATCH] ib_uverbs: Fix pages leak when using XRC SRQs
Date: Tue, 7 Apr 2015 13:22:24 +0200
Message-ID: <20150407132224.5f201e40@dingo>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


  Hello,

  When an application using XRCs abruptly terminates, the mmaped pages
of the CQ buffers are leaked.

  This comes from the fact that when resources are released in
ib_uverbs_cleanup_ucontext(), we fail to release the CQs because their
refcount is not 0.

  When creating an XRC SRQ, we increment the associated CQ refcount.
This refcount is only decremented when the SRQ is released.

  Therefore we need to release the SRQs prior to the CQs to make sure
that all references to the CQs are gone before trying to release these.

Signed-off-by: Sebastien Dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 259dcc7..88cce9b 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -246,6 +246,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uqp);
 	}
 
+	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
+		struct ib_srq *srq = uobj->object;
+		struct ib_uevent_object *uevent =
+			container_of(uobj, struct ib_uevent_object, uobject);
+
+		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
+		ib_destroy_srq(srq);
+		ib_uverbs_release_uevent(file, uevent);
+		kfree(uevent);
+	}
+
 	list_for_each_entry_safe(uobj, tmp, &context->cq_list, list) {
 		struct ib_cq *cq = uobj->object;
 		struct ib_uverbs_event_file *ev_file = cq->cq_context;
@@ -258,17 +269,6 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(ucq);
 	}
 
-	list_for_each_entry_safe(uobj, tmp, &context->srq_list, list) {
-		struct ib_srq *srq = uobj->object;
-		struct ib_uevent_object *uevent =
-			container_of(uobj, struct ib_uevent_object, uobject);
-
-		idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
-		ib_destroy_srq(srq);
-		ib_uverbs_release_uevent(file, uevent);
-		kfree(uevent);
-	}
-
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
