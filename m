From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 7/8] iw_cxgb4: Add missing debug stats
Date: Wed, 26 Mar 2014 18:53:58 +0530
Message-ID: <1395840239-4368-8-git-send-email-hariprasad@chelsio.com>
References: <1395840239-4368-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395840239-4368-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/mem.c      | 6 +++++-
 drivers/infiniband/hw/cxgb4/resource.c | 6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index a5db32c..9e5d120 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -259,8 +259,12 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 
 	if ((!reset_tpt_entry) && (*stag == T4_STAG_UNSET)) {
 		stag_idx = c4iw_get_resource(&rdev->resource.tpt_table);
-		if (!stag_idx)
+		if (!stag_idx) {
+			mutex_lock(&rdev->stats.lock);
+			rdev->stats.stag.fail++;
+			mutex_unlock(&rdev->stats.lock);
 			return -ENOMEM;
+		}
 		mutex_lock(&rdev->stats.lock);
 		rdev->stats.stag.cur += 32;
 		if (rdev->stats.stag.cur > rdev->stats.stag.max)
diff --git a/drivers/infiniband/hw/cxgb4/resource.c b/drivers/infiniband/hw/cxgb4/resource.c
index 94b5fd9..67df71a 100644
--- a/drivers/infiniband/hw/cxgb4/resource.c
+++ b/drivers/infiniband/hw/cxgb4/resource.c
@@ -179,8 +179,12 @@ u32 c4iw_get_qpid(struct c4iw_rdev *rdev, struct c4iw_dev_ucontext *uctx)
 		kfree(entry);
 	} else {
 		qid = c4iw_get_resource(&rdev->resource.qid_table);
-		if (!qid)
+		if (!qid) {
+			mutex_lock(&rdev->stats.lock);
+			rdev->stats.qid.fail++;
+			mutex_unlock(&rdev->stats.lock);
 			goto out;
+		}
 		mutex_lock(&rdev->stats.lock);
 		rdev->stats.qid.cur += rdev->qpmask + 1;
 		mutex_unlock(&rdev->stats.lock);
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
