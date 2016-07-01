From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/18] IB/hfi1: Add counter to track unsupported
 packets drop
Date: Fri, 01 Jul 2016 16:01:22 -0700
Message-ID: <20160701230122.20160.38368.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add sw counter to track dropped unsupported packets.
Report unsupported packets drop as the RcvError.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c   |   31 +++++++++++++++++++++++++++----
 drivers/infiniband/hw/hfi1/driver.c |    1 +
 drivers/infiniband/hw/hfi1/hfi.h    |    3 ++-
 drivers/infiniband/hw/hfi1/mad.c    |    3 ++-
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0662451..9eb4551 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -238,6 +238,9 @@ struct flag_table {
 /* all CceStatus sub-block RXE pause bits */
 #define ALL_RXE_PAUSE CCE_STATUS_RXE_PAUSED_SMASK
 
+#define CNTR_MAX 0xFFFFFFFFFFFFFFFFULL
+#define CNTR_32BIT_MAX 0x00000000FFFFFFFF
+
 /*
  * CCE Error flags.
  */
@@ -3947,6 +3950,28 @@ static u64 access_sdma_wrong_dw_err_cnt(const struct cntr_entry *entry,
 	return dd->sw_send_dma_eng_err_status_cnt[0];
 }
 
+static u64 access_dc_rcv_err_cnt(const struct cntr_entry *entry,
+				 void *context, int vl, int mode,
+				 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	u64 val = 0;
+	u64 csr = entry->csr;
+
+	val = read_write_csr(dd, csr, mode, data);
+	if (mode == CNTR_MODE_R) {
+		val = val > CNTR_MAX - dd->sw_rcv_bypass_packet_errors ?
+			CNTR_MAX : val + dd->sw_rcv_bypass_packet_errors;
+	} else if (mode == CNTR_MODE_W) {
+		dd->sw_rcv_bypass_packet_errors = 0;
+	} else {
+		dd_dev_err(dd, "Invalid cntr register access mode");
+		return 0;
+	}
+	return val;
+}
+
 #define def_access_sw_cpu(cntr) \
 static u64 access_sw_cpu_##cntr(const struct cntr_entry *entry,		      \
 			      void *context, int vl, int mode, u64 data)      \
@@ -4020,7 +4045,8 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			CCE_SEND_CREDIT_INT_CNT, CNTR_NORMAL),
 [C_DC_UNC_ERR] = DC_PERF_CNTR(DcUnctblErr, DCC_ERR_UNCORRECTABLE_CNT,
 			      CNTR_SYNTH),
-[C_DC_RCV_ERR] = DC_PERF_CNTR(DcRecvErr, DCC_ERR_PORTRCV_ERR_CNT, CNTR_SYNTH),
+[C_DC_RCV_ERR] = CNTR_ELEM("DcRecvErr", DCC_ERR_PORTRCV_ERR_CNT, 0, CNTR_SYNTH,
+			    access_dc_rcv_err_cnt),
 [C_DC_FM_CFG_ERR] = DC_PERF_CNTR(DcFmCfgErr, DCC_ERR_FMCONFIG_ERR_CNT,
 				 CNTR_SYNTH),
 [C_DC_RMT_PHY_ERR] = DC_PERF_CNTR(DcRmtPhyErr, DCC_ERR_RCVREMOTE_PHY_ERR_CNT,
@@ -11668,9 +11694,6 @@ static void free_cntrs(struct hfi1_devdata *dd)
 	dd->cntrnames = NULL;
 }
 
-#define CNTR_MAX 0xFFFFFFFFFFFFFFFFULL
-#define CNTR_32BIT_MAX 0x00000000FFFFFFFF
-
 static u64 read_dev_port_cntr(struct hfi1_devdata *dd, struct cntr_entry *entry,
 			      u64 *psval, void *context, int vl)
 {
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index c75b0ae..6c81d15 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -1362,6 +1362,7 @@ int process_receive_bypass(struct hfi1_packet *packet)
 
 	dd_dev_err(packet->rcd->dd,
 		   "Bypass packets are not supported in normal operation. Dropping\n");
+	incr_cntr64(&packet->rcd->dd->sw_rcv_bypass_packet_errors);
 	return RHF_RCV_CONTINUE;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 1dd48ef..748e235 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1128,7 +1128,8 @@ struct hfi1_devdata {
 		NUM_SEND_DMA_ENG_ERR_STATUS_COUNTERS];
 	/* Software counter that aggregates all cce_err_status errors */
 	u64 sw_cce_err_status_aggregate;
-
+	/* Software counter that aggregates all bypass packet rcv errors */
+	u64 sw_rcv_bypass_packet_errors;
 	/* receive interrupt functions */
 	rhf_rcv_function_ptr *rhf_rcv_function_map;
 	rhf_rcv_function_ptr normal_rhf_rcv_functions[8];
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 349a138..962bb11 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2874,7 +2874,8 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	tmp = read_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL);
 
 	rsp->uncorrectable_errors = tmp < 0x100 ? (tmp & 0xff) : 0xff;
-
+	rsp->port_rcv_errors =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_ERR, CNTR_INVALID_VL));
 	vlinfo = &rsp->vls[0];
 	vfi = 0;
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
