From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 14/18] staging/rdma/hfi1: unknown frame messages are not errors
Date: Fri, 13 Nov 2015 19:37:12 -0800
Message-ID: <1447472236-622-14-git-send-email-jubin.john@intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1447472236-622-1-git-send-email-jubin.john@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick@intel.com>

Change reported unknown frame messages into a counter.
These are informational, no errors.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c |   18 ++++++++++++++++++
 drivers/staging/rdma/hfi1/chip.h |    1 +
 drivers/staging/rdma/hfi1/hfi.h  |    2 ++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 2ac145f..f26b9d5 100644
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
index a24dd09..eb22061 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -1079,6 +1079,7 @@ enum {
 	C_RX_WORDS,
 	C_SW_LINK_DOWN,
 	C_SW_LINK_UP,
+	C_SW_UNKNOWN_FRAME,
 	C_SW_XMIT_DSCD,
 	C_SW_XMIT_DSCD_VL,
 	C_SW_XMIT_CSTR_ERR,
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 44a7124..4558a19 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -720,6 +720,8 @@ struct hfi1_pportdata {
 	u64 link_downed;
 	/* number of times link retrained successfully */
 	u64 link_up;
+	/* number of times a link unknown frame was reported */
+	u64 unknown_frame_count;
 	/* port_ltp_crc_mode is returned in 'portinfo' MADs */
 	u16 port_ltp_crc_mode;
 	/* port_crc_mode_enabled is the crc we support */
-- 
1.7.0.7
