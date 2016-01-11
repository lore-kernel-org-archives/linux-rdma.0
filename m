From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.5 1/2] iw_cxgb4: Fix static checker warning in c4iw_rdev_open()
Date: Mon, 11 Jan 2016 15:50:59 +0530
Message-ID: <1452507660-27441-2-git-send-email-hariprasad@chelsio.com>
References: <1452507660-27441-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452507660-27441-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The commit c5dfb000b904 ("iw_cxgb4: Pass qid range to user space
driver") from Dec 11, 2015, leads to the following static checker
warning:

	drivers/infiniband/hw/cxgb4/device.c:857 c4iw_rdev_open()
        warn: variable dereferenced before check 'rdev->status_page'
Fixing it.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index bf15538..2b67743 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -850,14 +850,14 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	}
 	rdev->status_page = (struct t4_dev_status_page *)
 			    __get_free_page(GFP_KERNEL);
+	if (!rdev->status_page) {
+		pr_err(MOD "error allocating status page\n");
+		goto destroy_ocqp_pool;
+	}
 	rdev->status_page->qp_start = rdev->lldi.vr->qp.start;
 	rdev->status_page->qp_size = rdev->lldi.vr->qp.size;
 	rdev->status_page->cq_start = rdev->lldi.vr->cq.start;
 	rdev->status_page->cq_size = rdev->lldi.vr->cq.size;
-	if (!rdev->status_page) {
-		pr_err(MOD "error allocating status page\n");
-		goto err4;
-	}
 
 	if (c4iw_wr_log) {
 		rdev->wr_log = kzalloc((1 << c4iw_wr_log_size_order) *
@@ -873,6 +873,8 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	rdev->status_page->db_off = 0;
 
 	return 0;
+destroy_ocqp_pool:
+	c4iw_ocqp_pool_destroy(rdev);
 err4:
 	c4iw_rqtpool_destroy(rdev);
 err3:
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
