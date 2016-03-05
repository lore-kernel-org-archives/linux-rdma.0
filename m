From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/17] IB/hfi1: Change thermal init to use resource
 reservation
Date: Sat, 05 Mar 2016 08:50:11 -0800
Message-ID: <20160305165011.32025.53295.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the resource reservation system to flag that the ASIC
thermal has been initialized.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index d3a9b9f..7170913 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14331,7 +14331,7 @@ static int thermal_init(struct hfi1_devdata *dd)
 	int ret = 0;
 
 	if (dd->icode != ICODE_RTL_SILICON ||
-	    !(dd->flags & HFI1_DO_INIT_ASIC))
+	    check_chip_resource(dd, CR_THERM_INIT, NULL))
 		return ret;
 
 	ret = acquire_chip_resource(dd, CR_SBUS, SBUS_TIMEOUT);
@@ -14386,6 +14386,12 @@ static int thermal_init(struct hfi1_devdata *dd)
 
 	/* Enable polling of thermal readings */
 	write_csr(dd, ASIC_CFG_THERM_POLL_EN, 0x1);
+
+	/* Set initialized flag */
+	ret = acquire_chip_resource(dd, CR_THERM_INIT, 0);
+	if (ret)
+		THERM_FAILURE(dd, ret, "Unable to set thermal init flag");
+
 done:
 	release_chip_resource(dd, CR_SBUS);
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
