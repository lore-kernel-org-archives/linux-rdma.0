From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next] iw_cxgb4: Pass qid range to user space driver
Date: Fri, 11 Dec 2015 13:02:01 +0530
Message-ID: <1449819121-6993-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enhances the t4_dev_status_page to pass the qid start and size
attributes from iw_cxgb4 to libcxgb4.
Bump the ABI Version to 3 -> To allow libcxgb4 to detect old drivers and
revert to the old way of computing the qid ranges.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 4 ++++
 drivers/infiniband/hw/cxgb4/t4.h     | 7 +++++++
 drivers/infiniband/hw/cxgb4/user.h   | 2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 1a29739..fab8ba3 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -850,6 +850,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	}
 	rdev->status_page = (struct t4_dev_status_page *)
 			    __get_free_page(GFP_KERNEL);
+	rdev->status_page->qp_start = rdev->lldi.vr->qp.start;
+	rdev->status_page->qp_size = rdev->lldi.vr->qp.size;
+	rdev->status_page->cq_start = rdev->lldi.vr->cq.start;
+	rdev->status_page->cq_size = rdev->lldi.vr->cq.size;
 	if (!rdev->status_page) {
 		pr_err(MOD "error allocating status page\n");
 		goto err4;
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 274a7ab..483d99b 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -700,4 +700,11 @@ static inline void t4_set_cq_in_error(struct t4_cq *cq)
 
 struct t4_dev_status_page {
 	u8 db_off;
+	u8 pad1;
+	u16 pad2;
+	u32 pad3;
+	u64 qp_start;
+	u64 qp_size;
+	u64 cq_start;
+	u64 cq_size;
 };
diff --git a/drivers/infiniband/hw/cxgb4/user.h b/drivers/infiniband/hw/cxgb4/user.h
index cbd0ce1..295f422 100644
--- a/drivers/infiniband/hw/cxgb4/user.h
+++ b/drivers/infiniband/hw/cxgb4/user.h
@@ -32,7 +32,7 @@
 #ifndef __C4IW_USER_H__
 #define __C4IW_USER_H__
 
-#define C4IW_UVERBS_ABI_VERSION	2
+#define C4IW_UVERBS_ABI_VERSION	3
 
 /*
  * Make sure that all structs defined in this file remain laid out so
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
