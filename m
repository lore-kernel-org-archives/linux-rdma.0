From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v2 4/7] staging/rdma/hfi1: hfi1_ioctl remove setlink state
Date: Mon, 16 Nov 2015 17:32:37 -0500
Message-ID: <1447713160-24858-5-git-send-email-ira.weiny@intel.com>
References: <1447713160-24858-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447713160-24858-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Set link state is not supported remove from the switch statement and allow the
default to return -ENOTTY

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes from v1:
	Just remove the check for SETLINKSTATE and allow the switch to default
	to -ENOTTY
	Update commit message to reflect this

 drivers/staging/rdma/hfi1/diag.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 2bb857b2a103..979890b40194 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -1004,11 +1004,6 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	spin_lock_irqsave(&dd->hfi1_snoop.snoop_lock, flags);
 
 	switch (cmd) {
-	case HFI1_SNOOP_IOCSETLINKSTATE:
-		snoop_dbg("HFI1_SNOOP_IOCSETLINKSTATE is not valid");
-		ret = -EINVAL;
-		break;
-
 	case HFI1_SNOOP_IOCSETLINKSTATE_EXTRA:
 		memset(&link_info, 0, sizeof(link_info));
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
