From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/20] IB/hfi1: Check for QSFP presence before attempting
 reads
Date: Wed, 01 Mar 2017 10:22:58 -0800
Message-ID: <20170301182253.29989.95160.stgit@scvm10.sc.intel.com>
References: <20170301181719.29989.31238.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301181719.29989.31238.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Attempting to read the status of a QSFP cable creates noise in the logs
and misses out on setting an appropriate Offline/Disabled Reason if the
cable is not plugged in. Check for this prior to attempting the read and
attendant retries.

Fixes: 673b975f1fba ("IB/hfi1: Add QSFP sanity pre-check")
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 8b8840a..f9d0d8c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9533,8 +9533,11 @@ static int test_qsfp_read(struct hfi1_pportdata *ppd)
 	int ret;
 	u8 status;
 
-	/* report success if not a QSFP */
-	if (ppd->port_type != PORT_TYPE_QSFP)
+	/*
+	 * Report success if not a QSFP or, if it is a QSFP, but the cable is
+	 * not present
+	 */
+	if (ppd->port_type != PORT_TYPE_QSFP || !qsfp_mod_present(ppd))
 		return 0;
 
 	/* read byte 2, the status byte */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
