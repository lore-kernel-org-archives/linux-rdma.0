From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/2] RDMA/vmw_pvrdma: Fix a signedness
Date: Mon, 28 Aug 2017 17:19:36 -0700
Message-ID: <8b33192c915a301385dbe1e755e5a60b86cc7e07.1503965717.git.aditr@vmware.com>
References: <cover.1503965717.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1503965717.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
index 34727f6..6b98890 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c
@@ -299,7 +299,7 @@ static inline struct pvrdma_cqe *get_cqe(struct pvrdma_cq *cq, int i)
 
 void _pvrdma_flush_cqe(struct pvrdma_qp *qp, struct pvrdma_cq *cq)
 {
-	int head;
+	unsigned int head;
 	int has_data;
 
 	if (!cq->is_kernel)
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
