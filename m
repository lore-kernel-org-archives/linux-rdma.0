From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 12/17] staging/rdma/hfi1: Unexpected link up pkey values are not an error
Date: Tue,  1 Dec 2015 15:38:21 -0500
Message-ID: <1449002306-15180-13-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Only warn when link up pkeys are not what we expect.  Also, allow
for the pkey to already be initialized.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- No changes

 drivers/staging/rdma/hfi1/chip.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e875365..342a564 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6725,10 +6725,10 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
-	/* Sanity check - ppd->pkeys[2] should be 0 */
-	if (ppd->pkeys[2] != 0)
-		dd_dev_err(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
-			   __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
+	/* Sanity check - ppd->pkeys[2] should be 0, or already initalized */
+	if (!((ppd->pkeys[2] == 0) || (ppd->pkeys[2] == FULL_MGMT_P_KEY)))
+		dd_dev_warn(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
+			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);
 	ppd->pkeys[2] = FULL_MGMT_P_KEY;
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_PKEYS, 0);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
