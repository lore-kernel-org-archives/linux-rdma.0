From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-rc 1/6] RDMA/vmw_pvrdma: Clarify QP is_kernel logic
Date: Fri, 8 Dec 2017 11:00:17 -0800
Message-ID: <20171208190010.GA31023@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171208185818.GA28514@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171208185818.GA28514-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Be more consistent in checking is_kernel flag for QPs.

Testing Done: ibv_rc_pingpong, rping, perftests.

Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 10420a1..b932b7e 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -249,8 +249,9 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 		init_waitqueue_head(&qp->wait);
 
 		qp->state = IB_QPS_RESET;
+		qp->is_kernel = !(pd->uobject && udata);
 
-		if (pd->uobject && udata) {
+		if (!qp->is_kernel) {
 			dev_dbg(&dev->pdev->dev,
 				"create queuepair from user space\n");
 
@@ -291,8 +292,6 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 				qp->npages_recv = 0;
 			qp->npages = qp->npages_send + qp->npages_recv;
 		} else {
-			qp->is_kernel = true;
-
 			ret = pvrdma_set_sq_size(to_vdev(pd->device),
 						 &init_attr->cap, qp);
 			if (ret)
@@ -394,7 +393,7 @@ struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
 err_pdir:
 	pvrdma_page_dir_cleanup(dev, &qp->pdir);
 err_umem:
-	if (pd->uobject && udata) {
+	if (!qp->is_kernel) {
 		if (qp->rumem)
 			ib_umem_release(qp->rumem);
 		if (qp->sumem)
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
