From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/8] staging/rdma/hfi1: return early if setlink state was specified
Date: Wed, 11 Nov 2015 00:43:06 -0500
Message-ID: <1447220589-9067-6-git-send-email-ira.weiny@intel.com>
References: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447220589-9067-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Set link state was not supported and so we can return early in the parameter
checks rather than falling through the switch clause.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/diag.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/diag.c b/drivers/staging/rdma/hfi1/diag.c
index 556a47591989..a489a79dd3b6 100644
--- a/drivers/staging/rdma/hfi1/diag.c
+++ b/drivers/staging/rdma/hfi1/diag.c
@@ -999,16 +999,14 @@ static long hfi1_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		 * Other are invalid.
 		 */
 		return -EINVAL;
+	} else if (cmd == HFI1_SNOOP_IOCSETLINKSTATE) {
+		/* We do not support the old setlink state */
+		return -EINVAL;
 	}
 
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
