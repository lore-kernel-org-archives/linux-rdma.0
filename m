From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 36/54] staging/rdma/hfi1: Fix fabric serdes reset by
 re-downloading firmware
Date: Wed, 03 Feb 2016 14:35:40 -0800
Message-ID: <20160203223536.5923.42021.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

A host fabric serdes reset is required to go back to polling.
However, access to the fabric serdes may have been invalidated
by the sibling HFI when it downloads its fabric serdes firmware.
Work around this by re-downloading and re-validating the serdes
firmware at reset time on Bx hardware.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/firmware.c |   57 ++++++++++++++++++++++++++--------
 1 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 4ba524b..0b23e3e 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -233,6 +233,8 @@ static const u8 all_pcie_serdes_broadcast = 0xe0;
 
 /* forwards */
 static void dispose_one_firmware(struct firmware_details *fdet);
+static int load_fabric_serdes_firmware(struct hfi1_devdata *dd,
+				       struct firmware_details *fdet);
 
 /*
  * Read a single 64-bit value from 8051 data memory.
@@ -1092,27 +1094,56 @@ static void turn_off_spicos(struct hfi1_devdata *dd, int flags)
 }
 
 /*
- *  Reset all of the fabric serdes for our HFI.
+ * Reset all of the fabric serdes for this HFI in preparation to take the
+ * link to Polling.
+ *
+ * To do a reset, we need to write to to the serdes registers.  Unfortunately,
+ * the fabric serdes download to the other HFI on the ASIC will have turned
+ * off the firmware validation on this HFI.  This means we can't write to the
+ * registers to reset the serdes.  Work around this by performing a complete
+ * re-download and validation of the fabric serdes firmware.  This, as a
+ * by-product, will reset the serdes.  NOTE: the re-download requires that
+ * the 8051 be in the Offline state.  I.e. not actively trying to use the
+ * serdes.  This routine is called at the point where the link is Offline and
+ * is getting ready to go to Polling.
  */
 void fabric_serdes_reset(struct hfi1_devdata *dd)
 {
-	u8 ra;
-
-	if (dd->icode != ICODE_RTL_SILICON) /* only for RTL */
+	if (!fw_fabric_serdes_load)
 		return;
 
-	ra = fabric_serdes_broadcast[dd->hfi1_id];
+	if (is_ax(dd)) {
+		/* A0 serdes do not work with a re-download */
+		u8 ra = fabric_serdes_broadcast[dd->hfi1_id];
+
+		acquire_hw_mutex(dd);
+		set_sbus_fast_mode(dd);
+		/* place SerDes in reset and disable SPICO */
+		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000011);
+		/* wait 100 refclk cycles @ 156.25MHz => 640ns */
+		udelay(1);
+		/* remove SerDes reset */
+		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000010);
+		/* turn SPICO enable on */
+		sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000002);
+		clear_sbus_fast_mode(dd);
+		release_hw_mutex(dd);
+		return;
+	}
 
 	acquire_hw_mutex(dd);
 	set_sbus_fast_mode(dd);
-	/* place SerDes in reset and disable SPICO */
-	sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000011);
-	/* wait 100 refclk cycles @ 156.25MHz => 640ns */
-	udelay(1);
-	/* remove SerDes reset */
-	sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000010);
-	/* turn SPICO enable on */
-	sbus_request(dd, ra, 0x07, WRITE_SBUS_RECEIVER, 0x00000002);
+
+	turn_off_spicos(dd, SPICO_FABRIC);
+	/*
+	 * No need for firmware retry - what to download has already been
+	 * decided.
+	 * No need to pay attention to the load return - the only failure
+	 * is a validation failure, which has already been checked by the
+	 * initial download.
+	 */
+	(void)load_fabric_serdes_firmware(dd, &fw_fabric);
+
 	clear_sbus_fast_mode(dd);
 	release_hw_mutex(dd);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
