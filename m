From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] staging/rdma/hfi1: use one-shot LCB write
Date: Thu,  5 Nov 2015 19:02:29 -0500
Message-ID: <1446768149-30557-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use the one-shot LCB write implemented in the 8051 firmware.
This speeds up 8051 LCB writes by 2x.  Use old method for older
firmwares.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   42 +++++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/chip.h |    1 +
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index e489819..89315d5 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -4774,13 +4774,25 @@ int read_lcb_csr(struct hfi1_devdata *dd, u32 addr, u64 *data)
  */
 static int write_lcb_via_8051(struct hfi1_devdata *dd, u32 addr, u64 data)
 {
+	u32 regno;
+	int ret;
 
-	if (acquire_lcb_access(dd, 0) == 0) {
-		write_csr(dd, addr, data);
-		release_lcb_access(dd, 0);
-		return 0;
+	if (dd->icode == ICODE_FUNCTIONAL_SIMULATOR ||
+	    (dd->dc8051_ver < dc8051_ver(0, 20))) {
+		if (acquire_lcb_access(dd, 0) == 0) {
+			write_csr(dd, addr, data);
+			release_lcb_access(dd, 0);
+			return 0;
+		}
+		return -EBUSY;
 	}
-	return -EBUSY;
+
+	/* register is an index of LCB registers: (offset - base) / 8 */
+	regno = (addr - DC_LCB_CFG_RUN) >> 3;
+	ret = do_8051_command(dd, HCMD_WRITE_LCB_CSR, regno, &data);
+	if (ret != HCMD_SUCCESS)
+		return -EBUSY;
+	return 0;
 }
 
 /*
@@ -4862,6 +4874,26 @@ static int do_8051_command(
 	 */
 
 	/*
+	 * When writing a LCB CSR, out_data contains the full value to
+	 * to be written, while in_data contains the relative LCB
+	 * address in 7:0.  Do the work here, rather than the caller,
+	 * of distrubting the write data to where it needs to go:
+	 *
+	 * Write data
+	 *   39:00 -> in_data[47:8]
+	 *   47:40 -> DC8051_CFG_EXT_DEV_0.RETURN_CODE
+	 *   63:48 -> DC8051_CFG_EXT_DEV_0.RSP_DATA
+	 */
+	if (type == HCMD_WRITE_LCB_CSR) {
+		in_data |= ((*out_data) & 0xffffffffffull) << 8;
+		reg = ((((*out_data) >> 40) & 0xff) <<
+				DC_DC8051_CFG_EXT_DEV_0_RETURN_CODE_SHIFT)
+		      | ((((*out_data) >> 48) & 0xffff) <<
+				DC_DC8051_CFG_EXT_DEV_0_RSP_DATA_SHIFT);
+		write_csr(dd, DC_DC8051_CFG_EXT_DEV_0, reg);
+	}
+
+	/*
 	 * Do two writes: the first to stabilize the type and req_data, the
 	 * second to activate.
 	 */
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index ebf9041..d74aed8 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -235,6 +235,7 @@
 #define HCMD_MISC		   0x05
 #define HCMD_READ_LCB_IDLE_MSG 0x06
 #define HCMD_READ_LCB_CSR      0x07
+#define HCMD_WRITE_LCB_CSR     0x08
 #define HCMD_INTERFACE_TEST	   0xff
 
 /* DC_DC8051_CFG_HOST_CMD_1.RETURN_CODE - 8051 host command return */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
