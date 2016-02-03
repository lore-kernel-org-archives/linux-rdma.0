From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 08/54] staging/rdma/hfi1: Fix missing firmware NULL
 dereference
Date: Wed, 03 Feb 2016 14:31:40 -0800
Message-ID: <20160203223136.5923.26362.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The gen3 bump code must mark a firmware download failure as fatal.
Otherwise a later load attempt will fail with a NULL dereference.

Also:
o Only do a firmware back-off for RTL.  There are no alternates for
  FPGA or simulation.
o Rearrange OS firmware request order to match what is actually
  loaded.  This results in more coherent informational messages
  in the case of missing firmware.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c |   22 +++++++++++-----------
 drivers/staging/rdma/hfi1/pcie.c     |    5 ++++-
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 28ae42f..d954e1a 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -593,27 +593,27 @@ retry:
 		fw_pcie_serdes_name = ALT_FW_PCIE_NAME;
 	}
 
-	if (fw_8051_load) {
-		err = obtain_one_firmware(dd, fw_8051_name, &fw_8051);
+	if (fw_sbus_load) {
+		err = obtain_one_firmware(dd, fw_sbus_name, &fw_sbus);
 		if (err)
 			goto done;
 	}
 
-	if (fw_fabric_serdes_load) {
-		err = obtain_one_firmware(dd, fw_fabric_serdes_name,
-			&fw_fabric);
+	if (fw_pcie_serdes_load) {
+		err = obtain_one_firmware(dd, fw_pcie_serdes_name, &fw_pcie);
 		if (err)
 			goto done;
 	}
 
-	if (fw_sbus_load) {
-		err = obtain_one_firmware(dd, fw_sbus_name, &fw_sbus);
+	if (fw_fabric_serdes_load) {
+		err = obtain_one_firmware(dd, fw_fabric_serdes_name,
+					  &fw_fabric);
 		if (err)
 			goto done;
 	}
 
-	if (fw_pcie_serdes_load) {
-		err = obtain_one_firmware(dd, fw_pcie_serdes_name, &fw_pcie);
+	if (fw_8051_load) {
+		err = obtain_one_firmware(dd, fw_8051_name, &fw_8051);
 		if (err)
 			goto done;
 	}
@@ -621,8 +621,8 @@ retry:
 done:
 	if (err) {
 		/* oops, had problems obtaining a firmware */
-		if (fw_state == FW_EMPTY) {
-			/* retry with alternate */
+		if (fw_state == FW_EMPTY && dd->icode == ICODE_RTL_SILICON) {
+			/* retry with alternate (RTL only) */
 			fw_state = FW_TRY;
 			goto retry;
 		}
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index b2f553d..3cdc804 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -1032,8 +1032,11 @@ retry:
 	/* step 4: download PCIe Gen3 SerDes firmware */
 	dd_dev_info(dd, "%s: downloading firmware\n", __func__);
 	ret = load_pcie_firmware(dd);
-	if (ret)
+	if (ret) {
+		/* do not proceed if the firmware cannot be downloaded */
+		return_error = 1;
 		goto done;
+	}
 
 	/* step 5: set up device parameter settings */
 	dd_dev_info(dd, "%s: setting PCIe registers\n", __func__);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
