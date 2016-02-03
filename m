From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 24/54] staging/rdma/hfi1: Verbs Mem affinity support
Date: Wed, 03 Feb 2016 14:33:58 -0800
Message-ID: <20160203223354.5923.61527.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change verbs memory allocations to the device numa node.  This keeps memory
close to the device for optimal performance.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/init.c |    3 ++-
 drivers/staging/rdma/hfi1/qp.c   |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 98b3fc1..629e92a 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -134,7 +134,8 @@ int hfi1_create_ctxts(struct hfi1_devdata *dd)
 	/* Control context has to be always 0 */
 	BUILD_BUG_ON(HFI1_CTRL_CTXT != 0);
 
-	dd->rcd = kcalloc(dd->num_rcv_contexts, sizeof(*dd->rcd), GFP_KERNEL);
+	dd->rcd = kzalloc_node(dd->num_rcv_contexts * sizeof(*dd->rcd),
+			       GFP_KERNEL, dd->node);
 	if (!dd->rcd)
 		goto nomem;
 
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index 05a9619..1a34e6e 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -596,13 +596,14 @@ void *qp_priv_alloc(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 {
 	struct hfi1_qp_priv *priv;
 
-	priv = kzalloc(sizeof(*priv), gfp);
+	priv = kzalloc_node(sizeof(*priv), gfp, rdi->dparms.node);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
 	priv->owner = qp;
 
-	priv->s_hdr = kzalloc(sizeof(*priv->s_hdr), gfp);
+	priv->s_hdr = kzalloc_node(sizeof(*priv->s_hdr), gfp,
+				   rdi->dparms.node);
 	if (!priv->s_hdr) {
 		kfree(priv);
 		return ERR_PTR(-ENOMEM);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
