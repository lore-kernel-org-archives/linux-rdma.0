From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] RDMA/vmw_pvrdma: Dont hardcode QP header page
Date: Wed, 22 Feb 2017 17:22:57 -0800
Message-ID: <cc8a5acd38cd34668540135aea616c4217e30ecf.1487812849.git.aditr@vmware.com>
References: <cover.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Moved the header page count to a macro.

Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index dbf61c3..9fbe22d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -70,6 +70,7 @@
 #define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
 
 #define PVRDMA_NUM_RING_PAGES		4
+#define PVRDMA_QP_NUM_HEADER_PAGES	1
 
 struct pvrdma_dev;
 
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 3ffbb2d..30062aa 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -170,8 +170,9 @@ static int pvrdma_set_sq_size(struct pvrdma_dev *dev, struct ib_qp_cap *req_cap,
 					     sizeof(struct pvrdma_sge) *
 					     qp->sq.max_sg);
 	/* Note: one extra page for the header. */
-	qp->npages_send = 1 + (qp->sq.wqe_cnt * qp->sq.wqe_size +
-			       PAGE_SIZE - 1) / PAGE_SIZE;
+	qp->npages_send = PVRDMA_QP_NUM_HEADER_PAGES +
+			  (qp->sq.wqe_cnt * qp->sq.wqe_size + PAGE_SIZE - 1) /
+								PAGE_SIZE;
 
 	return 0;
 }
@@ -288,7 +289,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 			qp->npages = qp->npages_send + qp->npages_recv;
 
 			/* Skip header page. */
-			qp->sq.offset = PAGE_SIZE;
+			qp->sq.offset = PVRDMA_QP_NUM_HEADER_PAGES * PAGE_SIZE;
 
 			/* Recv queue pages are after send pages. */
 			qp->rq.offset = qp->npages_send * PAGE_SIZE;
@@ -341,7 +342,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 	cmd->qp_type = ib_qp_type_to_pvrdma(init_attr->qp_type);
 	cmd->access_flags = IB_ACCESS_LOCAL_WRITE;
 	cmd->total_chunks = qp->npages;
-	cmd->send_chunks = qp->npages_send - 1;
+	cmd->send_chunks = qp->npages_send - PVRDMA_QP_NUM_HEADER_PAGES;
 	cmd->pdir_dma = qp->pdir.dir_dma;
 
 	dev_dbg(&dev->pdev->dev, "create queuepair with %d, %d, %d, %d\n",
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
