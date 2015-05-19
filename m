From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH V2 for-4.1 1/9] RDMA/ocrdma: Fix EQ destroy failure during driver unload
Date: Tue, 19 May 2015 11:32:32 +0530
Message-ID: <1432015360-15447-2-git-send-email-selvin.xavier@avagotech.com>
References: <1432015360-15447-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432015360-15447-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Changing the destroy sequence of mailbox queue and event queues.
FW expects mailbox queue to be destroyed before desroying the EQs.

Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 0c9e959..3a5ea5af 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -3147,9 +3147,9 @@ void ocrdma_cleanup_hw(struct ocrdma_dev *dev)
 	ocrdma_free_pd_pool(dev);
 	ocrdma_mbx_delete_ah_tbl(dev);
 
-	/* cleanup the eqs */
-	ocrdma_destroy_eqs(dev);
-
 	/* cleanup the control path */
 	ocrdma_destroy_mq(dev);
+
+	/* cleanup the eqs */
+	ocrdma_destroy_eqs(dev);
 }
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
