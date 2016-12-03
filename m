From: Pan Bian <bianpan201602-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH 1/1] infiniband: hw: cxgb4: set errno on failure
Date: Sat,  3 Dec 2016 21:04:35 +0800
Message-ID: <1480770275-6155-1-git-send-email-bianpan201602@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>

In function c4iw_rdev_open(), the value of return variable err should be
negative on errors. However, when the call to __get_free_page() returns
a NULL pointer, its value is not set to "-ENOMEM" and keeps 0. 0 means
no error. And thus, the behavior of its caller may be misled. This patch
fixes the bug.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=188821

Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 93e3d27..b99dc9e 100644
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
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
