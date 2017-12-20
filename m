From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rc 2/4] RDMA/vmw_pvrdma: Use refcount_dec_and_test to
 avoid warning
Date: Wed, 20 Dec 2017 09:50:01 -0800
Message-ID: <20171220174956.GA20571@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220174748.GA18149-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

refcount_dec generates a warning when the operation
causes the refcount to hit zero. Avoid this by using
refcount_dec_and_test.

Fixes: 8b10ba783c9d ("RDMA/vmw_pvrdma: Add shared receive queue support")
Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index 826ccb8..a2b1a3c 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -236,8 +236,8 @@ static void pvrdma_free_srq(struct pvrdma_dev *dev, struct pvrdma_srq *srq)
 	dev->srq_tbl[srq->srq_handle] = NULL;
 	spin_unlock_irqrestore(&dev->srq_tbl_lock, flags);
 
-	refcount_dec(&srq->refcnt);
-	wait_event(srq->wait, !refcount_read(&srq->refcnt));
+	if (!refcount_dec_and_test(&srq->refcnt))
+		wait_event(srq->wait, !refcount_read(&srq->refcnt));
 
 	/* There is no support for kernel clients, so this is safe. */
 	ib_umem_release(srq->umem);
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
