From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 6/7] staging/rdma/hfi1: Reduce snoop locking scope in IOCTL handler.
Date: Mon, 16 Nov 2015 17:32:39 -0500
Message-ID: <1447713160-24858-7-git-send-email-ira.weiny@intel.com>
References: <1447713160-24858-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447713160-24858-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch avoids issues while calling into copy from/to user while holding the
lock by only taking the lock when it is absolutely required.

The only commands which require the snoop lock are: *Set Filter *Clear Filter
*Clear Queue

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from V1:
	Adjust to add the done label which can't be removed until a later patch
	Removed SETLINKSTATE

 drivers/staging/rdma/hfi1/diag.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 2bfb455d3ca4..a4dd4cbc2bea 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1004,8 +1004,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		 */
 		return -EINVAL;
 
-	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
-
 	switch (cmd) {
 	case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
 		memset(&link_info, 0, sizeof(link_info));
@@ -1122,11 +1120,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 
 	case HFI1_SNOOP_IOCCLEARQUEUE:
 		snoop_dbg("Clearing snoop queue");
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		drain_snoop_list(&dd->hfi1_snoop.queue);
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 
 	case HFI1_SNOOP_IOCCLEARFILTER:
 		snoop_dbg("Clearing filter");
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		if (dd->hfi1_snoop.filter_callback) {
 			/* Drain packets first */
 			drain_snoop_list(&dd->hfi1_snoop.queue);
@@ -1134,6 +1135,7 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		}
 		kfree(dd->hfi1_snoop.filter_value);
 		dd->hfi1_snoop.filter_value = NULL;
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 
 	case HFI1_SNOOP_IOCSETFILTER:
@@ -1170,13 +1172,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 			break;
 		}
 		/* Drain packets first */
+		spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 		drain_snoop_list(&dd->hfi1_snoop.queue);
 		dd->hfi1_snoop.filter_callback =
 			hfi1_filters[filter_cmd.opcode].filter;
 		/* just in case we see back to back sets */
 		kfree(dd->hfi1_snoop.filter_value);
 		dd->hfi1_snoop.filter_value = filter_value;
-
+		spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 		break;
 	case HFI1_SNOOP_IOCGETVERSION:
 		value = SNOOP_CAPTURE_VERSION;
@@ -1200,7 +1203,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 done:
-	spin_unlock_irqrestore(&dd->hfi1_snoop.snoop_lock, flags);
 	return ret;
 }
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
