From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 15/19] IB/hfi1: Fix misspelling in comment
Date: Fri, 28 Apr 2017 10:40:25 -0700
Message-ID: <20170428174024.23960.49925.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428173443.23960.32602.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Checkpatch flagged a misspelled word. Fix it.

Fixes: 8764522e5251 ("staging/rdma/hfi1: Unexpected link up pkey values are not an error")
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 1ce560e..500b857 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7088,7 +7088,7 @@ static void add_full_mgmt_pkey(struct hfi1_pportdata *ppd)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
-	/* Sanity check - ppd->pkeys[2] should be 0, or already initalized */
+	/* Sanity check - ppd->pkeys[2] should be 0, or already initialized */
 	if (!((ppd->pkeys[2] == 0) || (ppd->pkeys[2] == FULL_MGMT_P_KEY)))
 		dd_dev_warn(dd, "%s pkey[2] already set to 0x%x, resetting it to 0x%x\n",
 			    __func__, ppd->pkeys[2], FULL_MGMT_P_KEY);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
