From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 01/13] IB/cma: pass the port number to ib_create_qp
Date: Sat, 27 Feb 2016 19:10:19 +0100
Message-ID: <1456596631-19418-2-git-send-email-hch@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456596631-19418-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The new RW API will need this.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9729639..a791522 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -800,6 +800,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ib_pd *pd,
 	if (id->device != pd->device)
 		return -EINVAL;
 
+	qp_init_attr->port_num = id->port_num;
 	qp = ib_create_qp(pd, qp_init_attr);
 	if (IS_ERR(qp))
 		return PTR_ERR(qp);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
