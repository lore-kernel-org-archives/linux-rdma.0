From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 20/23] staging/rdma/hfi1: Load SBus firmware once per ASIC
Date: Mon, 19 Oct 2015 12:43:44 -0400
Message-ID: <1445273027-29634-21-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Using fw_sbus_load to control SBus firmware load doesn't scale across multiple
HFI1 cards in a single system. This patch ensures that the SBus firmware is
loaded once per ASIC.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c | 31 ++++++++-----------------------
 drivers/staging/rdma/hfi1/pcie.c     | 10 ++++++----
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index ace75ce3da3f..b4bdcf341aac 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -1236,35 +1236,20 @@ int load_firmware(struct hfi1_devdata *dd)
 {
 	int ret;
 
-	if (fw_sbus_load || fw_fabric_serdes_load) {
+	if (fw_fabric_serdes_load) {
 		ret = acquire_hw_mutex(dd);
 		if (ret)
 			return ret;
 
 		set_sbus_fast_mode(dd);
 
-		/*
-		 * The SBus contains part of the fabric firmware and so must
-		 * also be downloaded.
-		 */
-		if (fw_sbus_load) {
-			turn_off_spicos(dd, SPICO_SBUS);
-			ret = load_sbus_firmware(dd, &fw_sbus);
-			if (ret)
-				goto clear;
-			fw_sbus_load = 0;
-		}
+		set_serdes_broadcast(dd, all_fabric_serdes_broadcast,
+				fabric_serdes_broadcast[dd->hfi1_id],
+				fabric_serdes_addrs[dd->hfi1_id],
+				NUM_FABRIC_SERDES);
+		turn_off_spicos(dd, SPICO_FABRIC);
+		ret = load_fabric_serdes_firmware(dd, &fw_fabric);
 
-		if (fw_fabric_serdes_load) {
-			set_serdes_broadcast(dd, all_fabric_serdes_broadcast,
-					fabric_serdes_broadcast[dd->hfi1_id],
-					fabric_serdes_addrs[dd->hfi1_id],
-					NUM_FABRIC_SERDES);
-			turn_off_spicos(dd, SPICO_FABRIC);
-			ret = load_fabric_serdes_firmware(dd, &fw_fabric);
-		}
-
-clear:
 		clear_sbus_fast_mode(dd);
 		release_hw_mutex(dd);
 		if (ret)
@@ -1583,7 +1568,7 @@ int load_pcie_firmware(struct hfi1_devdata *dd)
 	/* both firmware loads below use the SBus */
 	set_sbus_fast_mode(dd);
 
-	if (fw_sbus_load) {
+	if (fw_sbus_load && (dd->flags & HFI1_DO_INIT_ASIC)) {
 		turn_off_spicos(dd, SPICO_SBUS);
 		ret = load_sbus_firmware(dd, &fw_sbus);
 		if (ret)
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 3b50cdda1c0a..a956044459a2 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -947,15 +947,16 @@ int do_pcie_gen3_transition(struct hfi1_devdata *dd)
 	}
 
 retry:
+
 	if (therm) {
-		/* toggle SPICO_ENABLE to get back to the state
-		   just after the firmware load */
+		/*
+		 * toggle SPICO_ENABLE to get back to the state
+		 * just after the firmware load
+		 */
 		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
 			WRITE_SBUS_RECEIVER, 0x00000040);
 		sbus_request(dd, SBUS_MASTER_BROADCAST, 0x01,
 			WRITE_SBUS_RECEIVER, 0x00000140);
-		dd_dev_info(dd, "%s: toggle SPICO_ENABLE to reset the bus\n",
-			    __func__);
 	}
 
 	/* step 3: download SBus Master firmware */
@@ -1198,6 +1199,7 @@ retry:
 
 	/* clear the DC reset */
 	write_csr(dd, CCE_DC_CTRL, 0);
+
 	/* Set the LED off */
 	if (is_a0(dd))
 		setextled(dd, 0);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
