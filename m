From: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/1] rdma/cxgb4: Fix memory leaks during module exit
Date: Fri,  9 Jun 2017 22:17:49 +0530
Message-ID: <20170609164749.28399-1-rajur@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fix memory leaks of iw_cxgb4 module in the exit path

Signed-off-by: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index f96a96dbcf1f..ae0b79aeea2e 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -767,7 +767,7 @@ void c4iw_release_dev_ucontext(struct c4iw_rdev *rdev,
 		kfree(entry);
 	}
 
-	list_for_each_safe(pos, nxt, &uctx->qpids) {
+	list_for_each_safe(pos, nxt, &uctx->cqids) {
 		entry = list_entry(pos, struct c4iw_qid_list, entry);
 		list_del_init(&entry->entry);
 		kfree(entry);
@@ -880,13 +880,15 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	rdev->free_workq = create_singlethread_workqueue("iw_cxgb4_free");
 	if (!rdev->free_workq) {
 		err = -ENOMEM;
-		goto err_free_status_page;
+		goto err_free_status_page_and_wr_log;
 	}
 
 	rdev->status_page->db_off = 0;
 
 	return 0;
-err_free_status_page:
+err_free_status_page_and_wr_log:
+	if (c4iw_wr_log && rdev->wr_log)
+		kfree(rdev->wr_log);
 	free_page((unsigned long)rdev->status_page);
 destroy_ocqp_pool:
 	c4iw_ocqp_pool_destroy(rdev);
@@ -903,9 +905,11 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 {
 	destroy_workqueue(rdev->free_workq);
 	kfree(rdev->wr_log);
+	c4iw_release_dev_ucontext(rdev, &rdev->uctx);
 	free_page((unsigned long)rdev->status_page);
 	c4iw_pblpool_destroy(rdev);
 	c4iw_rqtpool_destroy(rdev);
+	c4iw_ocqp_pool_destroy(rdev);
 	c4iw_destroy_resource(&rdev->resource);
 }
 
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
