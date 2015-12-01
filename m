From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 14/17] staging/rdma/hfi1: unknown frame messages are not errors
Date: Tue,  1 Dec 2015 15:38:23 -0500
Message-ID: <1449002306-15180-15-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change reported unknown frame messages into a counter.
These are informational, no errors.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- No changes

 drivers/staging/rdma/hfi1/chip.c |   18 ++++++++++++++++++
 drivers/staging/rdma/hfi1/chip.h |    1 +
 drivers/staging/rdma/hfi1/hfi.h  |    2 ++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 85365d8..e7c1505 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1417,6 +1417,17 @@ static u64 access_sw_link_up_cnt(const struct cntr_entry *entry, void *context,
 	return read_write_sw(ppd->dd, &ppd->link_up, mode, data);
 }
 
+static u64 access_sw_unknown_frame_cnt(const struct cntr_entry *entry,
+				       void *context, int vl, int mode,
+				       u64 data)
+{
+	struct hfi1_pportdata *ppd = (struct hfi1_pportdata *)context;
+
+	if (vl != CNTR_INVALID_VL)
+		return 0;
+	return read_write_sw(ppd->dd, &ppd->unknown_frame_count, mode, data);
+}
+
 static u64 access_sw_xmit_discards(const struct cntr_entry *entry,
 				    void *context, int vl, int mode, u64 data)
 {
@@ -4880,6 +4891,8 @@ static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
 			access_sw_link_dn_cnt),
 [C_SW_LINK_UP] = CNTR_ELEM("SwLinkUp", 0, 0, CNTR_SYNTH | CNTR_32BIT,
 			access_sw_link_up_cnt),
+[C_SW_UNKNOWN_FRAME] = CNTR_ELEM("UnknownFrame", 0, 0, CNTR_NORMAL,
+				 access_sw_unknown_frame_cnt),
 [C_SW_XMIT_DSCD] = CNTR_ELEM("XmitDscd", 0, 0, CNTR_SYNTH | CNTR_32BIT,
 			access_sw_xmit_discards),
 [C_SW_XMIT_DSCD_VL] = CNTR_ELEM("XmitDscdVl", 0, 0,
@@ -7227,6 +7240,11 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			}
 			err &= ~(u64)FAILED_LNI;
 		}
+		/* unknown frames can happen durning LNI, just count */
+		if (err & UNKNOWN_FRAME) {
+			ppd->unknown_frame_count++;
+			err &= ~(u64)UNKNOWN_FRAME;
+		}
 		if (err) {
 			/* report remaining errors, but do not do anything */
 			dd_dev_err(dd, "8051 info error: %s\n",
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 3a51137..96f71e1 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -1080,6 +1080,7 @@ enum {
 	C_RX_WORDS,
 	C_SW_LINK_DOWN,
 	C_SW_LINK_UP,
+	C_SW_UNKNOWN_FRAME,
 	C_SW_XMIT_DSCD,
 	C_SW_XMIT_DSCD_VL,
 	C_SW_XMIT_CSTR_ERR,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 41aac12..fcf6331 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -713,6 +713,8 @@ struct hfi1_pportdata {
 	u64 link_downed;
 	/* number of times link retrained successfully */
 	u64 link_up;
+	/* number of times a link unknown frame was reported */
+	u64 unknown_frame_count;
 	/* port_ltp_crc_mode is returned in 'portinfo' MADs */
 	u16 port_ltp_crc_mode;
 	/* port_crc_mode_enabled is the crc we support */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
