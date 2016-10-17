From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/12] IB/hfi1: Fix a potential memory leak in
 hfi1_create_ctxts()
Date: Mon, 17 Oct 2016 04:19:41 -0700
Message-ID: <20161017111941.7934.23509.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In the function hfi1_create_ctxts the array "dd->rcd" is allocated and
then populated with allocated resources in a loop. Previously, if
error happened during the loop, only resource allocated in the current
iteration would be freed. The array itself would then be freed, leaving
the resources that were allocated in previous iterations and referenced
by the array elements in limbo.

This patch makes sure all allocated resources are freed before freeing
the array "dd->rcd". Also the resource allocation now takes account of
the numa node the device is attached to.

Reviewed-by: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/init.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 5872f10..4a7e741 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -144,6 +144,8 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		struct hfi1_ctxtdata *rcd;
 
 		ppd = dd->pport + (i % dd->num_pports);
+
+		/* dd->rcd[i] gets assigned inside the callee */
 		rcd = hfi1_create_ctxtdata(ppd, i, dd->node);
 		if (!rcd) {
 			dd_dev_err(dd,
@@ -169,8 +171,6 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		if (!rcd->sc) {
 			dd_dev_err(dd,
 				   "Unable to allocate kernel send context, failing\n");
-			dd->rcd[rcd->ctxt] = NULL;
-			hfi1_free_ctxtdata(dd, rcd);
 			goto nomem;
 		}
 
@@ -178,9 +178,6 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 		if (ret < 0) {
 			dd_dev_err(dd,
 				   "Failed to setup kernel receive context, failing\n");
-			sc_free(rcd->sc);
-			dd->rcd[rcd->ctxt] = NULL;
-			hfi1_free_ctxtdata(dd, rcd);
 			ret = -EFAULT;
 			goto bail;
 		}
@@ -196,6 +193,10 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 nomem:
 	ret = -ENOMEM;
 bail:
+	if (dd->rcd) {
+		for (i = 0; i < dd->num_rcv_contexts; ++i)
+			hfi1_free_ctxtdata(dd, dd->rcd[i]);
+	}
 	kfree(dd->rcd);
 	dd->rcd = NULL;
 	return ret;
@@ -216,7 +217,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 	    dd->num_rcv_contexts - dd->first_user_ctxt)
 		kctxt_ngroups = (dd->rcv_entries.nctxt_extra -
 				 (dd->num_rcv_contexts - dd->first_user_ctxt));
-	rcd = kzalloc(sizeof(*rcd), GFP_KERNEL);
+	rcd = kzalloc_node(sizeof(*rcd), GFP_KERNEL, numa);
 	if (rcd) {
 		u32 rcvtids, max_entries;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
