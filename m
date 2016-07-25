From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 22/28] IB/hfi1: Reset QSFP on every run through channel
 tuning
Date: Mon, 25 Jul 2016 13:40:03 -0700
Message-ID: <20160725204002.4800.19893.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Active QSFP cables were reset only every alternate iteration of the
channel tuning algorithm instead of every iteration due to incorrect
reset of the flag that controlled QSFP reset, resulting in using stale
QSFP status in the channel tuning algorithm.

Fixes: 8ebd4cf1852a ("Add active and optical cable support")
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/platform.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 41af629..965c8ae 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -624,9 +624,13 @@ static int tune_active_qsfp(struct hfi1_pportdata *ppd, u32 *ptr_tx_preset,
 	if (ret)
 		return ret;
 
+	/*
+	 * We'll change the QSFP memory contents from here on out, thus we set a
+	 * flag here to remind ourselves to reset the QSFP module. This prevents
+	 * reuse of stale settings established in our previous pass through.
+	 */
 	if (ppd->qsfp_info.reset_needed) {
 		reset_qsfp(ppd);
-		ppd->qsfp_info.reset_needed = 0;
 		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
 	} else {
 		ppd->qsfp_info.reset_needed = 1;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
