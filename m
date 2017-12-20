From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/4] RDMA/vmw_pvrdma: Use more specific sizeof in
 kcalloc
Date: Wed, 20 Dec 2017 11:26:00 -0800
Message-ID: <20171220192555.GA31203@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220192305.GA28403@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220192305.GA28403-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Convert the sizeof(void *) in two kcalloc calls to be more
specific for the arrays that are being allocated.

Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index e926818..69835d1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -243,13 +243,13 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
 	mutex_init(&dev->port_mutex);
 	spin_lock_init(&dev->desc_lock);
 
-	dev->cq_tbl = kcalloc(dev->dsr->caps.max_cq, sizeof(void *),
+	dev->cq_tbl = kcalloc(dev->dsr->caps.max_cq, sizeof(struct pvrdma_cq *),
 			      GFP_KERNEL);
 	if (!dev->cq_tbl)
 		return ret;
 	spin_lock_init(&dev->cq_tbl_lock);
 
-	dev->qp_tbl = kcalloc(dev->dsr->caps.max_qp, sizeof(void *),
+	dev->qp_tbl = kcalloc(dev->dsr->caps.max_qp, sizeof(struct pvrdma_qp *),
 			      GFP_KERNEL);
 	if (!dev->qp_tbl)
 		goto err_cq_free;
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
