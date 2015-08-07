From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] svcrdma: limit FRMR page list lengths to device max
Date: Fri, 7 Aug 2015 11:11:20 -0500
Message-ID: <20150807163539.EFDEFE0ACC@smtp.ogc.us>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Svcrdma was incorrectly allocating fastreg MRs and page lists using
RPCSVC_MAXPAGES, which can exceed the device capabilities.  So limit
the depth to the minimum of RPCSVC_MAXPAGES and xprt->sc_frmr_pg_list_len.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
Doug, this patch needs to be added after this commit:

e20684a xprtrdma, svcrdma: Convert to ib_alloc_mr

and before these commits:

af78181 cxgb3: Support ib_alloc_mr verb
b7e06cd iw_cxgb4: Support ib_alloc_mr verb

This will avoid a bisect window where NFSRDMA over cxgb4 is broken.

Bruce, please ACK if this commit looks good, and also if you're ok with
this flowing through Doug's rdma tree due to the dependencies.
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 8752a2d..11d5133 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -733,17 +733,19 @@ static struct svc_rdma_fastreg_mr *rdma_alloc_frmr(struct svcxprt_rdma *xprt)
 	struct ib_mr *mr;
 	struct ib_fast_reg_page_list *pl;
 	struct svc_rdma_fastreg_mr *frmr;
+	u32 num_sg;
 
 	frmr = kmalloc(sizeof(*frmr), GFP_KERNEL);
 	if (!frmr)
 		goto err;
 
-	mr = ib_alloc_mr(xprt->sc_pd, IB_MR_TYPE_MEM_REG, RPCSVC_MAXPAGES);
+	num_sg = min_t(u32, RPCSVC_MAXPAGES, xprt->sc_frmr_pg_list_len);
+	mr = ib_alloc_mr(xprt->sc_pd, IB_MR_TYPE_MEM_REG, num_sg);
 	if (IS_ERR(mr))
 		goto err_free_frmr;
 
 	pl = ib_alloc_fast_reg_page_list(xprt->sc_cm_id->device,
-					 RPCSVC_MAXPAGES);
+					 num_sg);
 	if (IS_ERR(pl))
 		goto err_free_mr;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
