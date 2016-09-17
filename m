From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] iw_cxgb4: Fix error return code in c4iw_rdev_open()
Date: Sat, 17 Sep 2016 00:41:37 +0000
Message-ID: <1474072897-30502-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Fix to return error code -ENOMEM from the __get_free_page() error
handling case instead of 0, as done elsewhere in this function.

Fixes: 05eb23893c2c ("cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes")
Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 3c4b212..3f7f869 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -828,8 +828,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	}
 	rdev->status_page = (struct t4_dev_status_page *)
 			    __get_free_page(GFP_KERNEL);
-	if (!rdev->status_page)
+	if (!rdev->status_page) {
+		err = -ENOMEM;
 		goto destroy_ocqp_pool;
+	}
 	rdev->status_page->qp_start = rdev->lldi.vr->qp.start;
 	rdev->status_page->qp_size = rdev->lldi.vr->qp.size;
 	rdev->status_page->cq_start = rdev->lldi.vr->cq.start;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
