From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 2/2] iw_cxgb4: don't hang threads forever waiting on WR replies
Date: Wed, 17 Dec 2014 14:11:03 +0530
Message-ID: <1418805663-15333-3-git-send-email-hariprasad@chelsio.com>
References: <1418805663-15333-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418805663-15333-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In c4iw_wait_for_reply(), if a FW6_MSG WR reply is not received after
C4IW_WR_TO seconds, fail the WR operation and mark the device as fatally
dead. Further, if the device is marked fatally dead, then fail the WR
wait immediately.

Also change the timeout to 60 seconds.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index b5678ac..9214260 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -196,7 +196,7 @@ static inline int c4iw_num_stags(struct c4iw_rdev *rdev)
 	return (int)(rdev->lldi.vr->stag.size >> 5);
 }
 
-#define C4IW_WR_TO (30*HZ)
+#define C4IW_WR_TO (60*HZ)
 
 struct c4iw_wr_wait {
 	struct completion completion;
@@ -220,22 +220,22 @@ static inline int c4iw_wait_for_reply(struct c4iw_rdev *rdev,
 				 u32 hwtid, u32 qpid,
 				 const char *func)
 {
-	unsigned to = C4IW_WR_TO;
 	int ret;
 
-	do {
-		ret = wait_for_completion_timeout(&wr_waitp->completion, to);
-		if (!ret) {
-			printk(KERN_ERR MOD "%s - Device %s not responding - "
-			       "tid %u qpid %u\n", func,
-			       pci_name(rdev->lldi.pdev), hwtid, qpid);
-			if (c4iw_fatal_error(rdev)) {
-				wr_waitp->ret = -EIO;
-				break;
-			}
-			to = to << 2;
-		}
-	} while (!ret);
+	if (c4iw_fatal_error(rdev)) {
+		wr_waitp->ret = -EIO;
+		goto out;
+	}
+
+	ret = wait_for_completion_timeout(&wr_waitp->completion, C4IW_WR_TO);
+	if (!ret) {
+		PDBG(KERN_ERR MOD "%s - Device %s not responding (disabling"
+		     " device) - tid %u qpid %u\n", func,
+		     pci_name(rdev->lldi.pdev), hwtid, qpid);
+		rdev->flags |= T4_FATAL_ERROR;
+		wr_waitp->ret = -EIO;
+	}
+out:
 	if (wr_waitp->ret)
 		PDBG("%s: FW reply %d tid %u qpid %u\n",
 		     pci_name(rdev->lldi.pdev), wr_waitp->ret, hwtid, qpid);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
