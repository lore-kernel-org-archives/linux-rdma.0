From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 6/9] IB/qib: Delete QIB user context allocation and
 de-alloction functions
Date: Fri, 22 Jan 2016 12:56:33 -0800
Message-ID: <20160122205632.6530.61188.stgit@scvm10.sc.intel.com>
References: <20160122205437.6530.68843.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205437.6530.68843.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

IB user context alloc and dealloc functions have been added to rdmavt.
Delete the QIB user context alloc/dealloc functions and use the ones in
rdmavt.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_verbs.c |   44 ++-------------------------------
 1 files changed, 2 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 2daca8f..5d230c8 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -133,16 +133,6 @@ const int ib_qib_state_ops[IB_QPS_ERR + 1] = {
 	    QIB_POST_SEND_OK | QIB_FLUSH_SEND,
 };
 
-struct qib_ucontext {
-	struct ib_ucontext ibucontext;
-};
-
-static inline struct qib_ucontext *to_iucontext(struct ib_ucontext
-						  *ibucontext)
-{
-	return container_of(ibucontext, struct qib_ucontext, ibucontext);
-}
-
 /*
  * Translate ib_wr_opcode into ib_wc_opcode.
  */
@@ -1841,36 +1831,6 @@ unsigned qib_get_pkey(struct qib_ibport *ibp, unsigned index)
 	return ret;
 }
 
-/**
- * qib_alloc_ucontext - allocate a ucontest
- * @ibdev: the infiniband device
- * @udata: not used by the QLogic_IB driver
- */
-
-static struct ib_ucontext *qib_alloc_ucontext(struct ib_device *ibdev,
-					      struct ib_udata *udata)
-{
-	struct qib_ucontext *context;
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
-static int qib_dealloc_ucontext(struct ib_ucontext *context)
-{
-	kfree(to_iucontext(context));
-	return 0;
-}
-
 static void init_ibport(struct qib_pportdata *ppd)
 {
 	struct qib_verbs_counters cntrs;
@@ -2062,8 +2022,8 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->modify_port = qib_modify_port;
 	ibdev->query_pkey = NULL;
 	ibdev->query_gid = qib_query_gid;
-	ibdev->alloc_ucontext = qib_alloc_ucontext;
-	ibdev->dealloc_ucontext = qib_dealloc_ucontext;
+	ibdev->alloc_ucontext = NULL;
+	ibdev->dealloc_ucontext = NULL;
 	ibdev->alloc_pd = NULL;
 	ibdev->dealloc_pd = NULL;
 	ibdev->create_ah = NULL;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
