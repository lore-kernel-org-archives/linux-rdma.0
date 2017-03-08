From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 08/26] IB/ocrdma: Improve size determinations in
 ocrdma_mbx_rdma_stats()
Date: Wed, 8 Mar 2017 13:58:49 +0100
Message-ID: <b72381fc-8ffd-ba40-45d3-2d3f8fb2e224@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Tue, 7 Mar 2017 20:16:16 +0100

Replace the specification of two data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determinations a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 1f7d88d7569e..0628600bee56 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1302,7 +1302,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
 	mqe->u.nonemb_req.sge[0].len = dev->stats_mem.size;
 
 	/* Cache the old stats */
-	memcpy(old_stats, req, sizeof(struct ocrdma_rdma_stats_resp));
+	memcpy(old_stats, req, sizeof(*old_stats));
 	memset(req, 0, dev->stats_mem.size);
 
 	ocrdma_init_mch((struct ocrdma_mbx_hdr *)req,
@@ -1315,7 +1315,7 @@ int ocrdma_mbx_rdma_stats(struct ocrdma_dev *dev, bool reset)
 	status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);
 	if (status)
 		/* Copy from cache, if mbox fails */
-		memcpy(req, old_stats, sizeof(struct ocrdma_rdma_stats_resp));
+		memcpy(req, old_stats, sizeof(*old_stats));
 	else
 		ocrdma_le32_to_cpu(req, dev->stats_mem.size);
 
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
