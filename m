From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc 2/4] RDMA/ocrdma: populate max_sge_rd in device attributes
Date: Fri,  5 Feb 2016 20:06:38 +0530
Message-ID: <1454683001-21275-3-git-send-email-selvin.xavier@broadcom.com>
References: <1454683001-21275-1-git-send-email-selvin.xavier@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454683001-21275-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

max_sge_rd is used by some of the ULPs to calculate the maximum
number of SGEs that can be used for RDMA READ. Populating this
value in the response of query_device verb. Also, avoid checking
the max_srq_sge while populating max_sge.

Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index d4c687b..7cf1324 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -125,8 +125,8 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 					IB_DEVICE_SYS_IMAGE_GUID |
 					IB_DEVICE_LOCAL_DMA_LKEY |
 					IB_DEVICE_MEM_MGT_EXTENSIONS;
-	attr->max_sge = min(dev->attr.max_send_sge, dev->attr.max_srq_sge);
-	attr->max_sge_rd = 0;
+	attr->max_sge = dev->attr.max_send_sge;
+	attr->max_sge_rd = attr->max_sge;
 	attr->max_cq = dev->attr.max_cq;
 	attr->max_cqe = dev->attr.max_cqe;
 	attr->max_mr = dev->attr.max_mr;
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
