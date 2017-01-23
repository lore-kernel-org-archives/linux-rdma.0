From: Ram Amrani <Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] qedr: fix memory leak in PD allocation and simplify it
Date: Mon, 23 Jan 2017 17:28:38 +0200
Message-ID: <1485185319-18771-5-git-send-email-Ram.Amrani@qlogic.com>
References: <1485185319-18771-1-git-send-email-Ram.Amrani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485185319-18771-1-git-send-email-Ram.Amrani-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

Free the PD if no internal resource were availbale.
Move userspace code to under the relevant 'if'.

Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 25fb75d..66bd297 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -471,8 +471,6 @@ struct ib_pd *qedr_alloc_pd(struct ib_device *ibdev,
 			    struct ib_ucontext *context, struct ib_udata *udata)
 {
 	struct qedr_dev *dev = get_qedr_dev(ibdev);
-	struct qedr_ucontext *uctx = NULL;
-	struct qedr_alloc_pd_uresp uresp;
 	struct qedr_pd *pd;
 	u16 pd_id;
 	int rc;
@@ -489,21 +487,33 @@ struct ib_pd *qedr_alloc_pd(struct ib_device *ibdev,
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	dev->ops->rdma_alloc_pd(dev->rdma_ctx, &pd_id);
+	rc = dev->ops->rdma_alloc_pd(dev->rdma_ctx, &pd_id);
+	if (rc)
+		goto err;
 
-	uresp.pd_id = pd_id;
 	pd->pd_id = pd_id;
 
 	if (udata && context) {
+		struct qedr_alloc_pd_uresp uresp;
+
+		uresp.pd_id = pd_id;
+
 		rc = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
-		if (rc)
+		if (rc) {
 			DP_ERR(dev, "copy error pd_id=0x%x.\n", pd_id);
-		uctx = get_qedr_ucontext(context);
-		uctx->pd = pd;
-		pd->uctx = uctx;
+			dev->ops->rdma_dealloc_pd(dev->rdma_ctx, pd_id);
+			goto err;
+		}
+
+		pd->uctx = get_qedr_ucontext(context);
+		pd->uctx->pd = pd;
 	}
 
 	return &pd->ibpd;
+
+err:
+	kfree(pd);
+	return ERR_PTR(rc);
 }
 
 int qedr_dealloc_pd(struct ib_pd *ibpd)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
