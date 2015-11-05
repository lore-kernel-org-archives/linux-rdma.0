From: jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] staging/rdma/hfi1: Always download SBus firmware
Date: Wed,  4 Nov 2015 23:36:05 -0500
Message-ID: <1446698165-26547-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

B0 dual port parts require the SBus firmware to always be
downloaded.

Remove reset of the SBus Master spico.  It is not necessary
since the SBus firmware download already does that.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c |    2 +-
 drivers/staging/rdma/hfi1/pcie.c     |   12 +-----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index b4bdcf3..f311282 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1568,7 +1568,7 @@ int load_pcie_firmware(struct hfi1_devdata *dd)
 	/* both firmware loads below use the SBus */
 	set_sbus_fast_mode(dd);
 
-	if (fw_sbus_load && (dd->flags & HFI1_DO_INIT_ASIC)) {
+	if (fw_sbus_load) {
 		turn_off_spicos(dd, SPICO_SBUS);
 		ret = load_sbus_firmware(dd, &fw_sbus);
 		if (ret)
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index a956044..6f0eff7 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -947,17 +947,7 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	}
 
 retry:
-
-	if (therm) {
-		/*
-		 * toggle SPICO_ENABLE to get back to the state
-		 * just after the firmware load
-		 */
-		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
-			WRITE_SBUS_RECEIVER, 0x00000040);
-		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
-			WRITE_SBUS_RECEIVER, 0x00000140);
-	}
+	/* the SBus download will reset the spico for thermal */
 
 	/* step 3: download SBus Master firmware */
 	/* step 4: download PCIe Gen3 SerDes firmware */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
