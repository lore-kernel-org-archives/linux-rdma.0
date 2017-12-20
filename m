From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 for-rc 1/4] RDMA/vmw_pvrdma: Call ib_umem_release on
 destroy QP path
Date: Wed, 20 Dec 2017 09:49:03 -0800
Message-ID: <20171220174859.GA19620@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
References: <20171220174748.GA18149@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171220174748.GA18149-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The QP cleanup did not previously call ib_umem_release. Fix this.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Reviewed-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index 10420a1..dceebc6 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -431,6 +431,13 @@ static void pvrdma_free_qp(struct pvrdma_qp *qp)
 	atomic_dec(&qp->refcnt);
 	wait_event(qp->wait, !atomic_read(&qp->refcnt));
 
+	if (!qp->is_kernel) {
+		if (qp->rumem)
+			ib_umem_release(qp->rumem);
+		if (qp->sumem)
+			ib_umem_release(qp->sumem);
+	}
+
 	pvrdma_page_dir_cleanup(dev, &qp->pdir);
 
 	kfree(qp);
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
