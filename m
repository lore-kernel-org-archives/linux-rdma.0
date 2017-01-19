From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] IB/vmw_pvrdma: Don't leak info from alloc_ucontext
Date: Thu, 19 Jan 2017 13:20:39 -0800
Message-ID: <3c91d92f4200f3c7844a198c25f2ce49f468b189.1484859556.git.aditr@vmware.com>
References: <cover.1484859556.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1484859556.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Clear out the user response struct correctly.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index 5489137..c2aa526 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -306,7 +306,7 @@ struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
 	union pvrdma_cmd_resp rsp;
 	struct pvrdma_cmd_create_uc *cmd = &req.create_uc;
 	struct pvrdma_cmd_create_uc_resp *resp = &rsp.create_uc_resp;
-	struct pvrdma_alloc_ucontext_resp uresp;
+	struct pvrdma_alloc_ucontext_resp uresp = {0};
 	int ret;
 	void *ptr;
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
