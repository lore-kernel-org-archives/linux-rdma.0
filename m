From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/vmw_pvrdma: Remove unused qp_type
Date: Tue, 17 Jan 2017 10:34:00 +0200
Message-ID: <1484642040-10668-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Remove the unused qp_type parameter from function's args

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index c8c01e5..dbbfd35 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -151,7 +151,7 @@ static int pvrdma_set_rq_size(struct pvrdma_dev *dev,
 }
 
 static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *req_cap,
-			      enum ib_qp_type type, struct pvrdma_qp *qp)
+			      struct pvrdma_qp *qp)
 {
 	if (req_cap->max_send_wr > dev->dsr->caps.max_qp_wr ||
 	    req_cap->max_send_sge > dev->dsr->caps.max_sge) {
@@ -276,8 +276,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 			qp->is_kernel = true;
 
 			ret = pvrdma_set_sq_size(to_vdev(pd->device),
-						 &init_attr->cap,
-						 init_attr->qp_type, qp);
+						 &init_attr->cap, qp);
 			if (ret)
 				goto err_qp;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
