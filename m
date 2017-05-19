From: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: calculate t4_eq_status_entries properly
Date: Fri, 19 May 2017 14:48:42 +0530
Message-ID: <1495185522-8055-1-git-send-email-ganeshgr@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org, Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

use egrstatuspagesize to calculate t4_eq_status_entries.

Fixes: bb58d07964f2 ("cxgb4: Update IngPad and IngPack values")
Reported-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 329fb65e..f96a96d 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -971,7 +971,7 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 		 devp->rdev.lldi.sge_egrstatuspagesize);
 
 	devp->rdev.hw_queue.t4_eq_status_entries =
-		devp->rdev.lldi.sge_ingpadboundary > 64 ? 2 : 1;
+		devp->rdev.lldi.sge_egrstatuspagesize / 64;
 	devp->rdev.hw_queue.t4_max_eq_size = 65520;
 	devp->rdev.hw_queue.t4_max_iq_size = 65520;
 	devp->rdev.hw_queue.t4_max_rq_size = 8192 -
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
