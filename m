From: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/8] infiniband: mthca: use setup_timer() helper.
Date: Fri, 22 Sep 2017 15:57:12 +0530
Message-ID: <1506076036-16496-5-git-send-email-allen.lkml@gmail.com>
References: <1506076036-16496-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506076036-16496-1-git-send-email-allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_catas.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_catas.c b/drivers/infiniband/hw/mthca/mthca_catas.c
index f6474c2..23cc08d 100644
--- a/drivers/infiniband/hw/mthca/mthca_catas.c
+++ b/drivers/infiniband/hw/mthca/mthca_catas.c
@@ -149,7 +149,7 @@ void mthca_start_catas_poll(struct mthca_dev *dev)
 {
 	phys_addr_t addr;
 
-	init_timer(&dev->catas_err.timer);
+	setup_timer(&dev->catas_err.timer, poll_catas, (unsigned long)dev);
 	dev->catas_err.map  = NULL;
 
 	addr = pci_resource_start(dev->pdev, 0) +
@@ -164,8 +164,6 @@ void mthca_start_catas_poll(struct mthca_dev *dev)
 		return;
 	}
 
-	dev->catas_err.timer.data     = (unsigned long) dev;
-	dev->catas_err.timer.function = poll_catas;
 	dev->catas_err.timer.expires  = jiffies + MTHCA_CATAS_POLL_INTERVAL;
 	INIT_LIST_HEAD(&dev->catas_err.list);
 	add_timer(&dev->catas_err.timer);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
