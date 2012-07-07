From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix assignment of max_srq_sge in device query
Date: Sat,  7 Jul 2012 15:16:03 -0700
Message-ID: <1341699363-16643-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

We want to set attr->max_srq_sge to dev->attr.max_srq_sge, not to itself.

This was detected by Coverity (CID 709210).

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2e2e7ae..b2f9784 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -97,7 +97,7 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr)
 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
 	attr->max_qp_init_rd_atom = dev->attr.max_ord_per_qp;
 	attr->max_srq = (dev->attr.max_qp - 1);
-	attr->max_srq_sge = attr->max_srq_sge;
+	attr->max_srq_sge = dev->attr.max_srq_sge;
 	attr->max_srq_wr = dev->attr.max_rqe;
 	attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
 	attr->max_fast_reg_page_list_len = 0;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
