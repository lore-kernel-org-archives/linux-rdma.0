From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 07/17] staging/rdma/hfi1: Extend quiet timeout
Date: Tue,  1 Dec 2015 15:38:16 -0500
Message-ID: <1449002306-15180-8-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The longest quiet timeout is now 6s.  Extend the driver wait to 6s.

The driver wasn't following our internal specification: 6 seconds.
This patch corrects that issue.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- Added more information in commit message

 drivers/staging/rdma/hfi1/chip.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 8191065..d9bb389 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6371,9 +6371,10 @@ static int goto_offline(struct hfi1_pportdata *ppd, u8 rem_reason)
 	 * depending on how the link went down.  The 8051 firmware
 	 * will observe the needed wait time and only move to ready
 	 * when that is completed.  The largest of the quiet timeouts
-	 * is 2.5s, so wait that long and then a bit more.
+	 * is 6s, so wait that long and then at least 0.5s more for
+	 * other transitions, and another 0.5s for a buffer.
 	 */
-	ret = wait_fm_ready(dd, 3000);
+	ret = wait_fm_ready(dd, 7000);
 	if (ret) {
 		dd_dev_err(dd,
 			"After going offline, timed out waiting for the 8051 to become ready to accept host requests\n");
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
