From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 1/5] iw_cxgb4: detect fatal errors while creating listening filters
Date: Tue,  8 Sep 2015 09:56:57 +0530
Message-ID: <1441686421-5899-2-git-send-email-hariprasad@chelsio.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In c4iw_create_listen(), if we're using listen filters, then bail out
of the busy loop if the device becomes fatally dead

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3ad8dc7..42087c9 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3202,6 +3202,10 @@ static int create_server4(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 				sin->sin_addr.s_addr, sin->sin_port, 0,
 				ep->com.dev->rdev.lldi.rxq_ids[0], 0, 0);
 			if (err == -EBUSY) {
+				if (c4iw_fatal_error(&ep->com.dev->rdev)) {
+					err = -EIO;
+					break;
+				}
 				set_current_state(TASK_UNINTERRUPTIBLE);
 				schedule_timeout(usecs_to_jiffies(100));
 			}
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
