From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 13/20] IB/hfi1: Adjust high temperature warning for QSFP
 cable
Date: Sun, 09 Apr 2017 10:16:47 -0700
Message-ID: <20170409171646.10579.73509.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When we receive a QSFP_HIGH_TEMP_ALARM or QSFP_HIGH_TEMP_WARNING
interrupt, print a "QSFP cable temperature too high" message.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Neel Desai <neel.desai-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c904c29..b5cbffa 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9325,7 +9325,7 @@ static int handle_qsfp_error_conditions(struct hfi1_pportdata *ppd,
 
 	if ((qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_ALARM) ||
 	    (qsfp_interrupt_status[0] & QSFP_HIGH_TEMP_WARNING))
-		dd_dev_info(dd, "%s: QSFP cable on fire\n",
+		dd_dev_info(dd, "%s: QSFP cable temperature too high\n",
 			    __func__);
 
 	if ((qsfp_interrupt_status[0] & QSFP_LOW_TEMP_ALARM) ||

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
