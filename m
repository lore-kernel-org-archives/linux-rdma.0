From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/54] staging/rdma/hfi1: Support external device
 configuration requests from 8051
Date: Wed, 03 Feb 2016 14:31:31 -0800
Message-ID: <20160203223127.5923.12250.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch implements support for turning on and off the clock data
recovery mechanisms implemented in QSFP cable on request by the DC 8051
on a per-lane basis.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |   52 ++++++++++++++++++++++++++++++++++----
 drivers/staging/rdma/hfi1/chip.h |    1 +
 drivers/staging/rdma/hfi1/hfi.h  |    1 +
 drivers/staging/rdma/hfi1/init.c |    1 +
 4 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 4d70a96..41af05e 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -6085,13 +6085,19 @@ static void hreq_response(struct hfi1_devdata *dd, u8 return_code, u16 rsp_data)
 }
 
 /*
- * Handle requests from the 8051.
+ * Handle host requests from the 8051.
+ *
+ * This is a work-queue function outside of the interrupt.
  */
-static void handle_8051_request(struct hfi1_devdata *dd)
+void handle_8051_request(struct work_struct *work)
 {
+	struct hfi1_pportdata *ppd = container_of(work, struct hfi1_pportdata,
+							dc_host_req_work);
+	struct hfi1_devdata *dd = ppd->dd;
 	u64 reg;
-	u16 data;
-	u8 type;
+	u16 data = 0;
+	u8 type, i, lanes, *cache = ppd->qsfp_info.cache;
+	u8 cdr_ctrl_byte = cache[QSFP_CDR_CTRL_BYTE_OFFS];
 
 	reg = read_csr(dd, DC_DC8051_CFG_EXT_DEV_1);
 	if ((reg & DC_DC8051_CFG_EXT_DEV_1_REQ_NEW_SMASK) == 0)
@@ -6112,12 +6118,46 @@ static void handle_8051_request(struct hfi1_devdata *dd)
 	case HREQ_READ_CONFIG:
 	case HREQ_SET_TX_EQ_ABS:
 	case HREQ_SET_TX_EQ_REL:
-	case HREQ_ENABLE:
 		dd_dev_info(dd, "8051 request: request 0x%x not supported\n",
 			type);
 		hreq_response(dd, HREQ_NOT_SUPPORTED, 0);
 		break;
 
+	case HREQ_ENABLE:
+		lanes = data & 0xF;
+		for (i = 0; lanes; lanes >>= 1, i++) {
+			if (!(lanes & 1))
+				continue;
+			if (data & 0x200) {
+				/* enable TX CDR */
+				if (cache[QSFP_MOD_PWR_OFFS] & 0x8 &&
+				    cache[QSFP_CDR_INFO_OFFS] & 0x80)
+					cdr_ctrl_byte |= (1 << (i + 4));
+			} else {
+				/* disable TX CDR */
+				if (cache[QSFP_MOD_PWR_OFFS] & 0x8 &&
+				    cache[QSFP_CDR_INFO_OFFS] & 0x80)
+					cdr_ctrl_byte &= ~(1 << (i + 4));
+			}
+
+			if (data & 0x800) {
+				/* enable RX CDR */
+				if (cache[QSFP_MOD_PWR_OFFS] & 0x4 &&
+				    cache[QSFP_CDR_INFO_OFFS] & 0x40)
+					cdr_ctrl_byte |= (1 << i);
+			} else {
+				/* disable RX CDR */
+				if (cache[QSFP_MOD_PWR_OFFS] & 0x4 &&
+				    cache[QSFP_CDR_INFO_OFFS] & 0x40)
+					cdr_ctrl_byte &= ~(1 << i);
+			}
+		}
+		qsfp_write(ppd, ppd->dd->hfi1_id, QSFP_CDR_CTRL_BYTE_OFFS,
+			   &cdr_ctrl_byte, 1);
+		hreq_response(dd, HREQ_SUCCESS, data);
+		refresh_qsfp_cache(ppd, &ppd->qsfp_info);
+		break;
+
 	case HREQ_CONFIG_DONE:
 		hreq_response(dd, HREQ_SUCCESS, 0);
 		break;
@@ -7373,7 +7413,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			host_msg &= ~(u64)LINKUP_ACHIEVED;
 		}
 		if (host_msg & EXT_DEVICE_CFG_REQ) {
-			handle_8051_request(dd);
+			queue_work(ppd->hfi1_wq, &ppd->dc_host_req_work);
 			host_msg &= ~(u64)EXT_DEVICE_CFG_REQ;
 		}
 		if (host_msg & VERIFY_CAP_FRAME) {
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 5e4fe43..0e95f0b 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -647,6 +647,7 @@ void handle_verify_cap(struct work_struct *work);
 void handle_freeze(struct work_struct *work);
 void handle_link_up(struct work_struct *work);
 void handle_link_down(struct work_struct *work);
+void handle_8051_request(struct work_struct *work);
 void handle_link_downgrade(struct work_struct *work);
 void handle_link_bounce(struct work_struct *work);
 void handle_sma_message(struct work_struct *work);
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index f79b070..0fe630e 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -589,6 +589,7 @@ struct hfi1_pportdata {
 	struct work_struct link_vc_work;
 	struct work_struct link_up_work;
 	struct work_struct link_down_work;
+	struct work_struct dc_host_req_work;
 	struct work_struct sma_message_work;
 	struct work_struct freeze_work;
 	struct work_struct link_downgrade_work;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 354935f..2851e90 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -495,6 +495,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	INIT_WORK(&ppd->link_vc_work, handle_verify_cap);
 	INIT_WORK(&ppd->link_up_work, handle_link_up);
 	INIT_WORK(&ppd->link_down_work, handle_link_down);
+	INIT_WORK(&ppd->dc_host_req_work, handle_8051_request);
 	INIT_WORK(&ppd->freeze_work, handle_freeze);
 	INIT_WORK(&ppd->link_downgrade_work, handle_link_downgrade);
 	INIT_WORK(&ppd->sma_message_work, handle_sma_message);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
