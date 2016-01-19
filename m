From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/31] staging/rdma/hfi1: Remove user context allocation and
 de-alloction functions
Date: Tue, 19 Jan 2016 14:42:55 -0800
Message-ID: <20160119224255.32765.13555.stgit@scvm10.sc.intel.com>
References: <20160119223610.32765.10571.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160119223610.32765.10571.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

IB user context alloc and dealloc functions have been added to rdmavt.
This patch removes them from hfi1.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/verbs.c |   44 ++-----------------------------------
 1 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index fa5b9c1..301716a 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -152,16 +152,6 @@ const int ib_hfi1_state_ops[IB_QPS_ERR + 1] = {
 	    HFI1_POST_SEND_OK | HFI1_FLUSH_SEND,
 };
 
-struct hfi1_ucontext {
-	struct ib_ucontext ibucontext;
-};
-
-static inline struct hfi1_ucontext *to_iucontext(struct ib_ucontext
-						  *ibucontext)
-{
-	return container_of(ibucontext, struct hfi1_ucontext, ibucontext);
-}
-
 static inline void _hfi1_schedule_send(struct rvt_qp *qp);
 
 /*
@@ -1679,36 +1669,6 @@ unsigned hfi1_get_npkeys(struct hfi1_devdata *dd)
 	return ARRAY_SIZE(dd->pport[0].pkeys);
 }
 
-/**
- * alloc_ucontext - allocate a ucontest
- * @ibdev: the infiniband device
- * @udata: not used by the driver
- */
-
-static struct ib_ucontext *alloc_ucontext(struct ib_device *ibdev,
-					  struct ib_udata *udata)
-{
-	struct hfi1_ucontext *context;
-	struct ib_ucontext *ret;
-
-	context = kmalloc(sizeof(*context), GFP_KERNEL);
-	if (!context) {
-		ret = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
-	ret = &context->ibucontext;
-
-bail:
-	return ret;
-}
-
-static int dealloc_ucontext(struct ib_ucontext *context)
-{
-	kfree(to_iucontext(context));
-	return 0;
-}
-
 static void init_ibport(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_ibport *ibp = &ppd->ibport_data;
@@ -1848,8 +1808,8 @@ int hfi1_register_ib_device(struct hfi1_devdata *dd)
 	ibdev->modify_port = modify_port;
 	ibdev->query_pkey = NULL;
 	ibdev->query_gid = query_gid;
-	ibdev->alloc_ucontext = alloc_ucontext;
-	ibdev->dealloc_ucontext = dealloc_ucontext;
+	ibdev->alloc_ucontext = NULL;
+	ibdev->dealloc_ucontext = NULL;
 	ibdev->alloc_pd = NULL;
 	ibdev->dealloc_pd = NULL;
 	ibdev->create_ah = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
