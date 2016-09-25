From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/13] IB/hfi1: Fix resource release in context allocation
Date: Sun, 25 Sep 2016 07:42:23 -0700
Message-ID: <20160925144221.10261.39146.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Correct resource free in allocate_ctxt() function.
When context creation fails allocated resources are properly
released and pointer in receive context data table is set back
to NULL.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c |   17 ++++++++++++-----
 drivers/infiniband/hw/hfi1/init.c     |    1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 335796f..13bb6a5 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -978,14 +978,16 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	 */
 	uctxt->sc = sc_alloc(dd, SC_USER, uctxt->rcvhdrqentsize,
 			     uctxt->dd->node);
-	if (!uctxt->sc)
-		return -ENOMEM;
-
+	if (!uctxt->sc) {
+		ret = -ENOMEM;
+		goto ctxdata_free;
+	}
 	hfi1_cdbg(PROC, "allocated send context %u(%u)\n", uctxt->sc->sw_index,
 		  uctxt->sc->hw_context);
 	ret = sc_enable(uctxt->sc);
 	if (ret)
-		return ret;
+		goto ctxdata_free;
+
 	/*
 	 * Setup shared context resources if the user-level has requested
 	 * shared contexts and this is the 'master' process.
@@ -999,7 +1001,7 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 		 * send context because it will be done during file close
 		 */
 		if (ret)
-			return ret;
+			goto ctxdata_free;
 	}
 	uctxt->userversion = uinfo->userversion;
 	uctxt->flags = hfi1_cap_mask; /* save current flag state */
@@ -1019,6 +1021,11 @@ static int allocate_ctxt(struct file *fp, struct hfi1_devdata *dd,
 	fd->uctxt = uctxt;
 
 	return 0;
+
+ctxdata_free:
+	dd->rcd[ctxt] = NULL;
+	hfi1_free_ctxtdata(dd, uctxt);
+	return ret;
 }
 
 static int init_subctxts(struct hfi1_ctxtdata *uctxt,
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index ab2f221..60db615 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -336,6 +336,7 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 	}
 	return rcd;
 bail:
+	dd->rcd[ctxt] = NULL;
 	kfree(rcd->egrbufs.rcvtids);
 	kfree(rcd->egrbufs.buffers);
 	kfree(rcd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
