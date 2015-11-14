From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 10/18] staging/rdma/hfi1: Adds software counters for bitfields
 within various error status fields
Date: Fri, 13 Nov 2015 19:37:08 -0800
Message-ID: <1447472236-622-10-git-send-email-jubin.john@intel.com>
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

From: Joel Rosenzweig <joel.b.rosenzweig@intel.com>

Provides error status counters for CceErrStatus, Send*ErrStatus,
RcvErrStatus and MISC_ERR_STATUS

Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Joel Rosenzweig <joel.b.rosenzweig@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/chip.c | 3185 +++++++++++++++++++++++++++++++++++++-
 drivers/staging/rdma/hfi1/chip.h |  269 ++++
 drivers/staging/rdma/hfi1/hfi.h  |   34 +
 3 files changed, 3487 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b0c1e2b..c83f360 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -663,7 +663,7 @@ static struct flag_table egress_err_info_flags[] = {
  */
 #define SES(name) SEND_ERR_STATUS_SEND_##name##_ERR_SMASK
 static struct flag_table send_err_status_flags[] = {
-/* 0*/	FLAG_ENTRY0("SDmaRpyTagErr", SES(CSR_PARITY)),
+/* 0*/	FLAG_ENTRY0("SendCsrParityErr", SES(CSR_PARITY)),
 /* 1*/	FLAG_ENTRY0("SendCsrReadBadAddrErr", SES(CSR_READ_BAD_ADDR)),
 /* 2*/	FLAG_ENTRY0("SendCsrWriteBadAddrErr", SES(CSR_WRITE_BAD_ADDR))
 };
@@ -1538,6 +1538,2336 @@ static u64 access_sw_send_schedule(const struct cntr_entry *entry,
 	return dd->verbs_dev.n_send_schedule;
 }
 
+/* Software counters for the error status bits within MISC_ERR_STATUS */
+static u64 access_misc_pll_lock_fail_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[12];
+}
+
+static u64 access_misc_mbist_fail_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[11];
+}
+
+static u64 access_misc_invalid_eep_cmd_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[10];
+}
+
+static u64 access_misc_efuse_done_parity_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[9];
+}
+
+static u64 access_misc_efuse_write_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[8];
+}
+
+static u64 access_misc_efuse_read_bad_addr_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[7];
+}
+
+static u64 access_misc_efuse_csr_parity_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[6];
+}
+
+static u64 access_misc_fw_auth_failed_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[5];
+}
+
+static u64 access_misc_key_mismatch_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[4];
+}
+
+static u64 access_misc_sbus_write_failed_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[3];
+}
+
+static u64 access_misc_csr_write_bad_addr_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[2];
+}
+
+static u64 access_misc_csr_read_bad_addr_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[1];
+}
+
+static u64 access_misc_csr_parity_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->misc_err_status_cnt[0];
+}
+
+/*
+ * Software counter for the aggregate of
+ * individual CceErrStatus counters
+ */
+static u64 access_sw_cce_err_status_aggregated_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_cce_err_status_aggregate;
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within CceErrStatus
+ */
+static u64 access_cce_msix_csr_parity_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[40];
+}
+
+static u64 access_cce_int_map_unc_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[39];
+}
+
+static u64 access_cce_int_map_cor_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[38];
+}
+
+static u64 access_cce_msix_table_unc_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[37];
+}
+
+static u64 access_cce_msix_table_cor_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[36];
+}
+
+static u64 access_cce_rxdma_conv_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[35];
+}
+
+static u64 access_cce_rcpl_async_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[34];
+}
+
+static u64 access_cce_seg_write_bad_addr_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[33];
+}
+
+static u64 access_cce_seg_read_bad_addr_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl, int mode,
+						u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[32];
+}
+
+static u64 access_la_triggered_cnt(const struct cntr_entry *entry,
+				   void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[31];
+}
+
+static u64 access_cce_trgt_cpl_timeout_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[30];
+}
+
+static u64 access_pcic_receive_parity_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[29];
+}
+
+static u64 access_pcic_transmit_back_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[28];
+}
+
+static u64 access_pcic_transmit_front_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[27];
+}
+
+static u64 access_pcic_cpl_dat_q_unc_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[26];
+}
+
+static u64 access_pcic_cpl_hd_q_unc_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[25];
+}
+
+static u64 access_pcic_post_dat_q_unc_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[24];
+}
+
+static u64 access_pcic_post_hd_q_unc_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[23];
+}
+
+static u64 access_pcic_retry_sot_mem_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[22];
+}
+
+static u64 access_pcic_retry_mem_unc_err(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[21];
+}
+
+static u64 access_pcic_n_post_dat_q_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[20];
+}
+
+static u64 access_pcic_n_post_h_q_parity_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[19];
+}
+
+static u64 access_pcic_cpl_dat_q_cor_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[18];
+}
+
+static u64 access_pcic_cpl_hd_q_cor_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[17];
+}
+
+static u64 access_pcic_post_dat_q_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[16];
+}
+
+static u64 access_pcic_post_hd_q_cor_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[15];
+}
+
+static u64 access_pcic_retry_sot_mem_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[14];
+}
+
+static u64 access_pcic_retry_mem_cor_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[13];
+}
+
+static u64 access_cce_cli1_async_fifo_dbg_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[12];
+}
+
+static u64 access_cce_cli1_async_fifo_rxdma_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[11];
+}
+
+static u64 access_cce_cli1_async_fifo_sdma_hd_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[10];
+}
+
+static u64 access_cce_cl1_async_fifo_pio_crdt_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[9];
+}
+
+static u64 access_cce_cli2_async_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[8];
+}
+
+static u64 access_cce_csr_cfg_bus_parity_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[7];
+}
+
+static u64 access_cce_cli0_async_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[6];
+}
+
+static u64 access_cce_rspd_data_parity_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[5];
+}
+
+static u64 access_cce_trgt_access_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[4];
+}
+
+static u64 access_cce_trgt_async_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[3];
+}
+
+static u64 access_cce_csr_write_bad_addr_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[2];
+}
+
+static u64 access_cce_csr_read_bad_addr_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[1];
+}
+
+static u64 access_ccs_csr_parity_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->cce_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within RcvErrStatus
+ */
+static u64 access_rx_csr_parity_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[63];
+}
+
+static u64 access_rx_csr_write_bad_addr_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[62];
+}
+
+static u64 access_rx_csr_read_bad_addr_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[61];
+}
+
+static u64 access_rx_dma_csr_unc_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[60];
+}
+
+static u64 access_rx_dma_dq_fsm_encoding_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[59];
+}
+
+static u64 access_rx_dma_eq_fsm_encoding_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[58];
+}
+
+static u64 access_rx_dma_csr_parity_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[57];
+}
+
+static u64 access_rx_rbuf_data_cor_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[56];
+}
+
+static u64 access_rx_rbuf_data_unc_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[55];
+}
+
+static u64 access_rx_dma_data_fifo_rd_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[54];
+}
+
+static u64 access_rx_dma_data_fifo_rd_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[53];
+}
+
+static u64 access_rx_dma_hdr_fifo_rd_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[52];
+}
+
+static u64 access_rx_dma_hdr_fifo_rd_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[51];
+}
+
+static u64 access_rx_rbuf_desc_part2_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[50];
+}
+
+static u64 access_rx_rbuf_desc_part2_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[49];
+}
+
+static u64 access_rx_rbuf_desc_part1_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[48];
+}
+
+static u64 access_rx_rbuf_desc_part1_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[47];
+}
+
+static u64 access_rx_hq_intr_fsm_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[46];
+}
+
+static u64 access_rx_hq_intr_csr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[45];
+}
+
+static u64 access_rx_lookup_csr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[44];
+}
+
+static u64 access_rx_lookup_rcv_array_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[43];
+}
+
+static u64 access_rx_lookup_rcv_array_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[42];
+}
+
+static u64 access_rx_lookup_des_part2_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[41];
+}
+
+static u64 access_rx_lookup_des_part1_unc_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[40];
+}
+
+static u64 access_rx_lookup_des_part1_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[39];
+}
+
+static u64 access_rx_rbuf_next_free_buf_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[38];
+}
+
+static u64 access_rx_rbuf_next_free_buf_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[37];
+}
+
+static u64 access_rbuf_fl_init_wr_addr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[36];
+}
+
+static u64 access_rx_rbuf_fl_initdone_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[35];
+}
+
+static u64 access_rx_rbuf_fl_write_addr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[34];
+}
+
+static u64 access_rx_rbuf_fl_rd_addr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[33];
+}
+
+static u64 access_rx_rbuf_empty_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[32];
+}
+
+static u64 access_rx_rbuf_full_err_cnt(const struct cntr_entry *entry,
+				       void *context, int vl, int mode,
+				       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[31];
+}
+
+static u64 access_rbuf_bad_lookup_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[30];
+}
+
+static u64 access_rbuf_ctx_id_parity_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[29];
+}
+
+static u64 access_rbuf_csr_qeopdw_parity_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[28];
+}
+
+static u64 access_rx_rbuf_csr_q_num_of_pkt_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[27];
+}
+
+static u64 access_rx_rbuf_csr_q_t1_ptr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[26];
+}
+
+static u64 access_rx_rbuf_csr_q_hd_ptr_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[25];
+}
+
+static u64 access_rx_rbuf_csr_q_vld_bit_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[24];
+}
+
+static u64 access_rx_rbuf_csr_q_next_buf_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[23];
+}
+
+static u64 access_rx_rbuf_csr_q_ent_cnt_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[22];
+}
+
+static u64 access_rx_rbuf_csr_q_head_buf_num_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[21];
+}
+
+static u64 access_rx_rbuf_block_list_read_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[20];
+}
+
+static u64 access_rx_rbuf_block_list_read_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[19];
+}
+
+static u64 access_rx_rbuf_lookup_des_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[18];
+}
+
+static u64 access_rx_rbuf_lookup_des_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[17];
+}
+
+static u64 access_rx_rbuf_lookup_des_reg_unc_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[16];
+}
+
+static u64 access_rx_rbuf_lookup_des_reg_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[15];
+}
+
+static u64 access_rx_rbuf_free_list_cor_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[14];
+}
+
+static u64 access_rx_rbuf_free_list_unc_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[13];
+}
+
+static u64 access_rx_rcv_fsm_encoding_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[12];
+}
+
+static u64 access_rx_dma_flag_cor_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[11];
+}
+
+static u64 access_rx_dma_flag_unc_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[10];
+}
+
+static u64 access_rx_dc_sop_eop_parity_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[9];
+}
+
+static u64 access_rx_rcv_csr_parity_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[8];
+}
+
+static u64 access_rx_rcv_qp_map_table_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[7];
+}
+
+static u64 access_rx_rcv_qp_map_table_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[6];
+}
+
+static u64 access_rx_rcv_data_cor_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[5];
+}
+
+static u64 access_rx_rcv_data_unc_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[4];
+}
+
+static u64 access_rx_rcv_hdr_cor_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[3];
+}
+
+static u64 access_rx_rcv_hdr_unc_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[2];
+}
+
+static u64 access_rx_dc_intf_parity_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[1];
+}
+
+static u64 access_rx_dma_csr_cor_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->rcv_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendPioErrStatus
+ */
+static u64 access_pio_pec_sop_head_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[35];
+}
+
+static u64 access_pio_pcc_sop_head_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[34];
+}
+
+static u64 access_pio_last_returned_cnt_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[33];
+}
+
+static u64 access_pio_current_free_cnt_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[32];
+}
+
+static u64 access_pio_reserved_31_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[31];
+}
+
+static u64 access_pio_reserved_30_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[30];
+}
+
+static u64 access_pio_ppmc_sop_len_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[29];
+}
+
+static u64 access_pio_ppmc_bqc_mem_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[28];
+}
+
+static u64 access_pio_vl_fifo_parity_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[27];
+}
+
+static u64 access_pio_vlf_sop_parity_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[26];
+}
+
+static u64 access_pio_vlf_v1_len_parity_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[25];
+}
+
+static u64 access_pio_block_qw_count_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[24];
+}
+
+static u64 access_pio_write_qw_valid_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[23];
+}
+
+static u64 access_pio_state_machine_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[22];
+}
+
+static u64 access_pio_write_data_parity_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[21];
+}
+
+static u64 access_pio_host_addr_mem_cor_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[20];
+}
+
+static u64 access_pio_host_addr_mem_unc_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[19];
+}
+
+static u64 access_pio_pkt_evict_sm_or_arb_sm_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[18];
+}
+
+static u64 access_pio_init_sm_in_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[17];
+}
+
+static u64 access_pio_ppmc_pbl_fifo_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[16];
+}
+
+static u64 access_pio_credit_ret_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[15];
+}
+
+static u64 access_pio_v1_len_mem_bank1_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[14];
+}
+
+static u64 access_pio_v1_len_mem_bank0_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[13];
+}
+
+static u64 access_pio_v1_len_mem_bank1_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[12];
+}
+
+static u64 access_pio_v1_len_mem_bank0_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[11];
+}
+
+static u64 access_pio_sm_pkt_reset_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[10];
+}
+
+static u64 access_pio_pkt_evict_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[9];
+}
+
+static u64 access_pio_sbrdctrl_crrel_fifo_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[8];
+}
+
+static u64 access_pio_sbrdctl_crrel_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[7];
+}
+
+static u64 access_pio_pec_fifo_parity_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[6];
+}
+
+static u64 access_pio_pcc_fifo_parity_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[5];
+}
+
+static u64 access_pio_sb_mem_fifo1_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[4];
+}
+
+static u64 access_pio_sb_mem_fifo0_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[3];
+}
+
+static u64 access_pio_csr_parity_err_cnt(const struct cntr_entry *entry,
+					 void *context, int vl, int mode,
+					 u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[2];
+}
+
+static u64 access_pio_write_addr_parity_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[1];
+}
+
+static u64 access_pio_write_bad_ctxt_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_pio_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendDmaErrStatus
+ */
+static u64 access_sdma_pcie_req_tracking_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_dma_err_status_cnt[3];
+}
+
+static u64 access_sdma_pcie_req_tracking_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_dma_err_status_cnt[2];
+}
+
+static u64 access_sdma_csr_parity_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_dma_err_status_cnt[1];
+}
+
+static u64 access_sdma_rpy_tag_err_cnt(const struct cntr_entry *entry,
+				       void *context, int vl, int mode,
+				       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_dma_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendEgressErrStatus
+ */
+static u64 access_tx_read_pio_memory_csr_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[63];
+}
+
+static u64 access_tx_read_sdma_memory_csr_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[62];
+}
+
+static u64 access_tx_egress_fifo_cor_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[61];
+}
+
+static u64 access_tx_read_pio_memory_cor_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[60];
+}
+
+static u64 access_tx_read_sdma_memory_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[59];
+}
+
+static u64 access_tx_sb_hdr_cor_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[58];
+}
+
+static u64 access_tx_credit_overrun_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[57];
+}
+
+static u64 access_tx_launch_fifo8_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[56];
+}
+
+static u64 access_tx_launch_fifo7_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[55];
+}
+
+static u64 access_tx_launch_fifo6_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[54];
+}
+
+static u64 access_tx_launch_fifo5_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[53];
+}
+
+static u64 access_tx_launch_fifo4_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[52];
+}
+
+static u64 access_tx_launch_fifo3_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[51];
+}
+
+static u64 access_tx_launch_fifo2_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[50];
+}
+
+static u64 access_tx_launch_fifo1_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[49];
+}
+
+static u64 access_tx_launch_fifo0_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[48];
+}
+
+static u64 access_tx_credit_return_vl_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[47];
+}
+
+static u64 access_tx_hcrc_insertion_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[46];
+}
+
+static u64 access_tx_egress_fifo_unc_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[45];
+}
+
+static u64 access_tx_read_pio_memory_unc_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[44];
+}
+
+static u64 access_tx_read_sdma_memory_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[43];
+}
+
+static u64 access_tx_sb_hdr_unc_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[42];
+}
+
+static u64 access_tx_credit_return_partiy_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[41];
+}
+
+static u64 access_tx_launch_fifo8_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[40];
+}
+
+static u64 access_tx_launch_fifo7_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[39];
+}
+
+static u64 access_tx_launch_fifo6_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[38];
+}
+
+static u64 access_tx_launch_fifo5_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[37];
+}
+
+static u64 access_tx_launch_fifo4_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[36];
+}
+
+static u64 access_tx_launch_fifo3_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[35];
+}
+
+static u64 access_tx_launch_fifo2_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[34];
+}
+
+static u64 access_tx_launch_fifo1_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[33];
+}
+
+static u64 access_tx_launch_fifo0_unc_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[32];
+}
+
+static u64 access_tx_sdma15_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[31];
+}
+
+static u64 access_tx_sdma14_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[30];
+}
+
+static u64 access_tx_sdma13_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[29];
+}
+
+static u64 access_tx_sdma12_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[28];
+}
+
+static u64 access_tx_sdma11_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[27];
+}
+
+static u64 access_tx_sdma10_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[26];
+}
+
+static u64 access_tx_sdma9_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[25];
+}
+
+static u64 access_tx_sdma8_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[24];
+}
+
+static u64 access_tx_sdma7_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[23];
+}
+
+static u64 access_tx_sdma6_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[22];
+}
+
+static u64 access_tx_sdma5_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[21];
+}
+
+static u64 access_tx_sdma4_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[20];
+}
+
+static u64 access_tx_sdma3_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[19];
+}
+
+static u64 access_tx_sdma2_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[18];
+}
+
+static u64 access_tx_sdma1_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[17];
+}
+
+static u64 access_tx_sdma0_disallowed_packet_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[16];
+}
+
+static u64 access_tx_config_parity_err_cnt(const struct cntr_entry *entry,
+					   void *context, int vl, int mode,
+					   u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[15];
+}
+
+static u64 access_tx_sbrd_ctl_csr_parity_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[14];
+}
+
+static u64 access_tx_launch_csr_parity_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[13];
+}
+
+static u64 access_tx_illegal_vl_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[12];
+}
+
+static u64 access_tx_sbrd_ctl_state_machine_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[11];
+}
+
+static u64 access_egress_reserved_10_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[10];
+}
+
+static u64 access_egress_reserved_9_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[9];
+}
+
+static u64 access_tx_sdma_launch_intf_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[8];
+}
+
+static u64 access_tx_pio_launch_intf_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[7];
+}
+
+static u64 access_egress_reserved_6_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[6];
+}
+
+static u64 access_tx_incorrect_link_state_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[5];
+}
+
+static u64 access_tx_linkdown_err_cnt(const struct cntr_entry *entry,
+				      void *context, int vl, int mode,
+				      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[4];
+}
+
+static u64 access_tx_egress_fifi_underrun_or_parity_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[3];
+}
+
+static u64 access_egress_reserved_2_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[2];
+}
+
+static u64 access_tx_pkt_integrity_mem_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[1];
+}
+
+static u64 access_tx_pkt_integrity_mem_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_egress_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendErrStatus
+ */
+static u64 access_send_csr_write_bad_addr_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_err_status_cnt[2];
+}
+
+static u64 access_send_csr_read_bad_addr_err_cnt(const struct cntr_entry *entry,
+						 void *context, int vl,
+						 int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_err_status_cnt[1];
+}
+
+static u64 access_send_csr_parity_cnt(const struct cntr_entry *entry,
+				      void *context, int vl, int mode,
+				      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->send_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendCtxtErrStatus
+ */
+static u64 access_pio_write_out_of_bounds_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_ctxt_err_status_cnt[4];
+}
+
+static u64 access_pio_write_overflow_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_ctxt_err_status_cnt[3];
+}
+
+static u64 access_pio_write_crosses_boundary_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_ctxt_err_status_cnt[2];
+}
+
+static u64 access_pio_disallowed_packet_err_cnt(const struct cntr_entry *entry,
+						void *context, int vl,
+						int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_ctxt_err_status_cnt[1];
+}
+
+static u64 access_pio_inconsistent_sop_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl, int mode,
+					       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_ctxt_err_status_cnt[0];
+}
+
+/*
+ * Software counters corresponding to each of the
+ * error status bits within SendDmaEngErrStatus
+ */
+static u64 access_sdma_header_request_fifo_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[23];
+}
+
+static u64 access_sdma_header_storage_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[22];
+}
+
+static u64 access_sdma_packet_tracking_cor_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[21];
+}
+
+static u64 access_sdma_assembly_cor_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[20];
+}
+
+static u64 access_sdma_desc_table_cor_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[19];
+}
+
+static u64 access_sdma_header_request_fifo_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[18];
+}
+
+static u64 access_sdma_header_storage_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[17];
+}
+
+static u64 access_sdma_packet_tracking_unc_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[16];
+}
+
+static u64 access_sdma_assembly_unc_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[15];
+}
+
+static u64 access_sdma_desc_table_unc_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[14];
+}
+
+static u64 access_sdma_timeout_err_cnt(const struct cntr_entry *entry,
+				       void *context, int vl, int mode,
+				       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[13];
+}
+
+static u64 access_sdma_header_length_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[12];
+}
+
+static u64 access_sdma_header_address_err_cnt(const struct cntr_entry *entry,
+					      void *context, int vl, int mode,
+					      u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[11];
+}
+
+static u64 access_sdma_header_select_err_cnt(const struct cntr_entry *entry,
+					     void *context, int vl, int mode,
+					     u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[10];
+}
+
+static u64 access_sdma_reserved_9_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[9];
+}
+
+static u64 access_sdma_packet_desc_overflow_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[8];
+}
+
+static u64 access_sdma_length_mismatch_err_cnt(const struct cntr_entry *entry,
+					       void *context, int vl,
+					       int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[7];
+}
+
+static u64 access_sdma_halt_err_cnt(const struct cntr_entry *entry,
+				    void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[6];
+}
+
+static u64 access_sdma_mem_read_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[5];
+}
+
+static u64 access_sdma_first_desc_err_cnt(const struct cntr_entry *entry,
+					  void *context, int vl, int mode,
+					  u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[4];
+}
+
+static u64 access_sdma_tail_out_of_bounds_err_cnt(
+				const struct cntr_entry *entry,
+				void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[3];
+}
+
+static u64 access_sdma_too_long_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[2];
+}
+
+static u64 access_sdma_gen_mismatch_err_cnt(const struct cntr_entry *entry,
+					    void *context, int vl, int mode,
+					    u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[1];
+}
+
+static u64 access_sdma_wrong_dw_err_cnt(const struct cntr_entry *entry,
+					void *context, int vl, int mode,
+					u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->sw_send_dma_eng_err_status_cnt[0];
+}
+
 #define def_access_sw_cpu(cntr) \
 static u64 access_sw_cpu_##cntr(const struct cntr_entry *entry,		      \
 			      void *context, int vl, int mode, u64 data)      \
@@ -1730,6 +4060,794 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_kmem_wait),
 [C_SW_SEND_SCHED] = CNTR_ELEM("SendSched", 0, 0, CNTR_NORMAL,
 			    access_sw_send_schedule),
+/* MISC_ERR_STATUS */
+[C_MISC_PLL_LOCK_FAIL_ERR] = CNTR_ELEM("MISC_PLL_LOCK_FAIL_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_pll_lock_fail_err_cnt),
+[C_MISC_MBIST_FAIL_ERR] = CNTR_ELEM("MISC_MBIST_FAIL_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_mbist_fail_err_cnt),
+[C_MISC_INVALID_EEP_CMD_ERR] = CNTR_ELEM("MISC_INVALID_EEP_CMD_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_invalid_eep_cmd_err_cnt),
+[C_MISC_EFUSE_DONE_PARITY_ERR] = CNTR_ELEM("MISC_EFUSE_DONE_PARITY_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_efuse_done_parity_err_cnt),
+[C_MISC_EFUSE_WRITE_ERR] = CNTR_ELEM("MISC_EFUSE_WRITE_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_efuse_write_err_cnt),
+[C_MISC_EFUSE_READ_BAD_ADDR_ERR] = CNTR_ELEM("MISC_EFUSE_READ_BAD_ADDR_ERR", 0,
+				0, CNTR_NORMAL,
+				access_misc_efuse_read_bad_addr_err_cnt),
+[C_MISC_EFUSE_CSR_PARITY_ERR] = CNTR_ELEM("MISC_EFUSE_CSR_PARITY_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_efuse_csr_parity_err_cnt),
+[C_MISC_FW_AUTH_FAILED_ERR] = CNTR_ELEM("MISC_FW_AUTH_FAILED_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_fw_auth_failed_err_cnt),
+[C_MISC_KEY_MISMATCH_ERR] = CNTR_ELEM("MISC_KEY_MISMATCH_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_key_mismatch_err_cnt),
+[C_MISC_SBUS_WRITE_FAILED_ERR] = CNTR_ELEM("MISC_SBUS_WRITE_FAILED_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_sbus_write_failed_err_cnt),
+[C_MISC_CSR_WRITE_BAD_ADDR_ERR] = CNTR_ELEM("MISC_CSR_WRITE_BAD_ADDR_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_csr_write_bad_addr_err_cnt),
+[C_MISC_CSR_READ_BAD_ADDR_ERR] = CNTR_ELEM("MISC_CSR_READ_BAD_ADDR_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_csr_read_bad_addr_err_cnt),
+[C_MISC_CSR_PARITY_ERR] = CNTR_ELEM("MISC_CSR_PARITY_ERR", 0, 0,
+				CNTR_NORMAL,
+				access_misc_csr_parity_err_cnt),
+/* CceErrStatus */
+[C_CCE_ERR_STATUS_AGGREGATED_CNT] = CNTR_ELEM("CceErrStatusAggregatedCnt", 0, 0,
+				CNTR_NORMAL,
+				access_sw_cce_err_status_aggregated_cnt),
+[C_CCE_MSIX_CSR_PARITY_ERR] = CNTR_ELEM("CceMsixCsrParityErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_msix_csr_parity_err_cnt),
+[C_CCE_INT_MAP_UNC_ERR] = CNTR_ELEM("CceIntMapUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_int_map_unc_err_cnt),
+[C_CCE_INT_MAP_COR_ERR] = CNTR_ELEM("CceIntMapCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_int_map_cor_err_cnt),
+[C_CCE_MSIX_TABLE_UNC_ERR] = CNTR_ELEM("CceMsixTableUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_msix_table_unc_err_cnt),
+[C_CCE_MSIX_TABLE_COR_ERR] = CNTR_ELEM("CceMsixTableCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_msix_table_cor_err_cnt),
+[C_CCE_RXDMA_CONV_FIFO_PARITY_ERR] = CNTR_ELEM("CceRxdmaConvFifoParityErr", 0,
+				0, CNTR_NORMAL,
+				access_cce_rxdma_conv_fifo_parity_err_cnt),
+[C_CCE_RCPL_ASYNC_FIFO_PARITY_ERR] = CNTR_ELEM("CceRcplAsyncFifoParityErr", 0,
+				0, CNTR_NORMAL,
+				access_cce_rcpl_async_fifo_parity_err_cnt),
+[C_CCE_SEG_WRITE_BAD_ADDR_ERR] = CNTR_ELEM("CceSegWriteBadAddrErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_seg_write_bad_addr_err_cnt),
+[C_CCE_SEG_READ_BAD_ADDR_ERR] = CNTR_ELEM("CceSegReadBadAddrErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_seg_read_bad_addr_err_cnt),
+[C_LA_TRIGGERED] = CNTR_ELEM("Cce LATriggered", 0, 0,
+				CNTR_NORMAL,
+				access_la_triggered_cnt),
+[C_CCE_TRGT_CPL_TIMEOUT_ERR] = CNTR_ELEM("CceTrgtCplTimeoutErr", 0, 0,
+				CNTR_NORMAL,
+				access_cce_trgt_cpl_timeout_err_cnt),
+[C_PCIC_RECEIVE_PARITY_ERR] = CNTR_ELEM("PcicReceiveParityErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_receive_parity_err_cnt),
+[C_PCIC_TRANSMIT_BACK_PARITY_ERR] = CNTR_ELEM("PcicTransmitBackParityErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_transmit_back_parity_err_cnt),
+[C_PCIC_TRANSMIT_FRONT_PARITY_ERR] = CNTR_ELEM("PcicTransmitFrontParityErr", 0,
+				0, CNTR_NORMAL,
+				access_pcic_transmit_front_parity_err_cnt),
+[C_PCIC_CPL_DAT_Q_UNC_ERR] = CNTR_ELEM("PcicCplDatQUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_cpl_dat_q_unc_err_cnt),
+[C_PCIC_CPL_HD_Q_UNC_ERR] = CNTR_ELEM("PcicCplHdQUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_cpl_hd_q_unc_err_cnt),
+[C_PCIC_POST_DAT_Q_UNC_ERR] = CNTR_ELEM("PcicPostDatQUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_post_dat_q_unc_err_cnt),
+[C_PCIC_POST_HD_Q_UNC_ERR] = CNTR_ELEM("PcicPostHdQUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_post_hd_q_unc_err_cnt),
+[C_PCIC_RETRY_SOT_MEM_UNC_ERR] = CNTR_ELEM("PcicRetrySotMemUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_retry_sot_mem_unc_err_cnt),
+[C_PCIC_RETRY_MEM_UNC_ERR] = CNTR_ELEM("PcicRetryMemUncErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_retry_mem_unc_err),
+[C_PCIC_N_POST_DAT_Q_PARITY_ERR] = CNTR_ELEM("PcicNPostDatQParityErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_n_post_dat_q_parity_err_cnt),
+[C_PCIC_N_POST_H_Q_PARITY_ERR] = CNTR_ELEM("PcicNPostHQParityErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_n_post_h_q_parity_err_cnt),
+[C_PCIC_CPL_DAT_Q_COR_ERR] = CNTR_ELEM("PcicCplDatQCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_cpl_dat_q_cor_err_cnt),
+[C_PCIC_CPL_HD_Q_COR_ERR] = CNTR_ELEM("PcicCplHdQCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_cpl_hd_q_cor_err_cnt),
+[C_PCIC_POST_DAT_Q_COR_ERR] = CNTR_ELEM("PcicPostDatQCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_post_dat_q_cor_err_cnt),
+[C_PCIC_POST_HD_Q_COR_ERR] = CNTR_ELEM("PcicPostHdQCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_post_hd_q_cor_err_cnt),
+[C_PCIC_RETRY_SOT_MEM_COR_ERR] = CNTR_ELEM("PcicRetrySotMemCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_retry_sot_mem_cor_err_cnt),
+[C_PCIC_RETRY_MEM_COR_ERR] = CNTR_ELEM("PcicRetryMemCorErr", 0, 0,
+				CNTR_NORMAL,
+				access_pcic_retry_mem_cor_err_cnt),
+[C_CCE_CLI1_ASYNC_FIFO_DBG_PARITY_ERR] = CNTR_ELEM(
+				"CceCli1AsyncFifoDbgParityError", 0, 0,
+				CNTR_NORMAL,
+				access_cce_cli1_async_fifo_dbg_parity_err_cnt),
+[C_CCE_CLI1_ASYNC_FIFO_RXDMA_PARITY_ERR] = CNTR_ELEM(
+				"CceCli1AsyncFifoRxdmaParityError", 0, 0,
+				CNTR_NORMAL,
+				access_cce_cli1_async_fifo_rxdma_parity_err_cnt
+				),
+[C_CCE_CLI1_ASYNC_FIFO_SDMA_HD_PARITY_ERR] = CNTR_ELEM(
+			"CceCli1AsyncFifoSdmaHdParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_cli1_async_fifo_sdma_hd_parity_err_cnt),
+[C_CCE_CLI1_ASYNC_FIFO_PIO_CRDT_PARITY_ERR] = CNTR_ELEM(
+			"CceCli1AsyncFifoPioCrdtParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_cl1_async_fifo_pio_crdt_parity_err_cnt),
+[C_CCE_CLI2_ASYNC_FIFO_PARITY_ERR] = CNTR_ELEM("CceCli2AsyncFifoParityErr", 0,
+			0, CNTR_NORMAL,
+			access_cce_cli2_async_fifo_parity_err_cnt),
+[C_CCE_CSR_CFG_BUS_PARITY_ERR] = CNTR_ELEM("CceCsrCfgBusParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_csr_cfg_bus_parity_err_cnt),
+[C_CCE_CLI0_ASYNC_FIFO_PARTIY_ERR] = CNTR_ELEM("CceCli0AsyncFifoParityErr", 0,
+			0, CNTR_NORMAL,
+			access_cce_cli0_async_fifo_parity_err_cnt),
+[C_CCE_RSPD_DATA_PARITY_ERR] = CNTR_ELEM("CceRspdDataParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_rspd_data_parity_err_cnt),
+[C_CCE_TRGT_ACCESS_ERR] = CNTR_ELEM("CceTrgtAccessErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_trgt_access_err_cnt),
+[C_CCE_TRGT_ASYNC_FIFO_PARITY_ERR] = CNTR_ELEM("CceTrgtAsyncFifoParityErr", 0,
+			0, CNTR_NORMAL,
+			access_cce_trgt_async_fifo_parity_err_cnt),
+[C_CCE_CSR_WRITE_BAD_ADDR_ERR] = CNTR_ELEM("CceCsrWriteBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_csr_write_bad_addr_err_cnt),
+[C_CCE_CSR_READ_BAD_ADDR_ERR] = CNTR_ELEM("CceCsrReadBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_cce_csr_read_bad_addr_err_cnt),
+[C_CCE_CSR_PARITY_ERR] = CNTR_ELEM("CceCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_ccs_csr_parity_err_cnt),
+
+/* RcvErrStatus */
+[C_RX_CSR_PARITY_ERR] = CNTR_ELEM("RxCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_csr_parity_err_cnt),
+[C_RX_CSR_WRITE_BAD_ADDR_ERR] = CNTR_ELEM("RxCsrWriteBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_csr_write_bad_addr_err_cnt),
+[C_RX_CSR_READ_BAD_ADDR_ERR] = CNTR_ELEM("RxCsrReadBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_csr_read_bad_addr_err_cnt),
+[C_RX_DMA_CSR_UNC_ERR] = CNTR_ELEM("RxDmaCsrUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_csr_unc_err_cnt),
+[C_RX_DMA_DQ_FSM_ENCODING_ERR] = CNTR_ELEM("RxDmaDqFsmEncodingErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_dq_fsm_encoding_err_cnt),
+[C_RX_DMA_EQ_FSM_ENCODING_ERR] = CNTR_ELEM("RxDmaEqFsmEncodingErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_eq_fsm_encoding_err_cnt),
+[C_RX_DMA_CSR_PARITY_ERR] = CNTR_ELEM("RxDmaCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_csr_parity_err_cnt),
+[C_RX_RBUF_DATA_COR_ERR] = CNTR_ELEM("RxRbufDataCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_data_cor_err_cnt),
+[C_RX_RBUF_DATA_UNC_ERR] = CNTR_ELEM("RxRbufDataUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_data_unc_err_cnt),
+[C_RX_DMA_DATA_FIFO_RD_COR_ERR] = CNTR_ELEM("RxDmaDataFifoRdCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_data_fifo_rd_cor_err_cnt),
+[C_RX_DMA_DATA_FIFO_RD_UNC_ERR] = CNTR_ELEM("RxDmaDataFifoRdUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_data_fifo_rd_unc_err_cnt),
+[C_RX_DMA_HDR_FIFO_RD_COR_ERR] = CNTR_ELEM("RxDmaHdrFifoRdCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_hdr_fifo_rd_cor_err_cnt),
+[C_RX_DMA_HDR_FIFO_RD_UNC_ERR] = CNTR_ELEM("RxDmaHdrFifoRdUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_hdr_fifo_rd_unc_err_cnt),
+[C_RX_RBUF_DESC_PART2_COR_ERR] = CNTR_ELEM("RxRbufDescPart2CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_desc_part2_cor_err_cnt),
+[C_RX_RBUF_DESC_PART2_UNC_ERR] = CNTR_ELEM("RxRbufDescPart2UncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_desc_part2_unc_err_cnt),
+[C_RX_RBUF_DESC_PART1_COR_ERR] = CNTR_ELEM("RxRbufDescPart1CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_desc_part1_cor_err_cnt),
+[C_RX_RBUF_DESC_PART1_UNC_ERR] = CNTR_ELEM("RxRbufDescPart1UncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_desc_part1_unc_err_cnt),
+[C_RX_HQ_INTR_FSM_ERR] = CNTR_ELEM("RxHqIntrFsmErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_hq_intr_fsm_err_cnt),
+[C_RX_HQ_INTR_CSR_PARITY_ERR] = CNTR_ELEM("RxHqIntrCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_hq_intr_csr_parity_err_cnt),
+[C_RX_LOOKUP_CSR_PARITY_ERR] = CNTR_ELEM("RxLookupCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_lookup_csr_parity_err_cnt),
+[C_RX_LOOKUP_RCV_ARRAY_COR_ERR] = CNTR_ELEM("RxLookupRcvArrayCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_lookup_rcv_array_cor_err_cnt),
+[C_RX_LOOKUP_RCV_ARRAY_UNC_ERR] = CNTR_ELEM("RxLookupRcvArrayUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_lookup_rcv_array_unc_err_cnt),
+[C_RX_LOOKUP_DES_PART2_PARITY_ERR] = CNTR_ELEM("RxLookupDesPart2ParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_lookup_des_part2_parity_err_cnt),
+[C_RX_LOOKUP_DES_PART1_UNC_COR_ERR] = CNTR_ELEM("RxLookupDesPart1UncCorErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_lookup_des_part1_unc_cor_err_cnt),
+[C_RX_LOOKUP_DES_PART1_UNC_ERR] = CNTR_ELEM("RxLookupDesPart1UncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_lookup_des_part1_unc_err_cnt),
+[C_RX_RBUF_NEXT_FREE_BUF_COR_ERR] = CNTR_ELEM("RxRbufNextFreeBufCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_next_free_buf_cor_err_cnt),
+[C_RX_RBUF_NEXT_FREE_BUF_UNC_ERR] = CNTR_ELEM("RxRbufNextFreeBufUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_next_free_buf_unc_err_cnt),
+[C_RX_RBUF_FL_INIT_WR_ADDR_PARITY_ERR] = CNTR_ELEM(
+			"RxRbufFlInitWrAddrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rbuf_fl_init_wr_addr_parity_err_cnt),
+[C_RX_RBUF_FL_INITDONE_PARITY_ERR] = CNTR_ELEM("RxRbufFlInitdoneParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_fl_initdone_parity_err_cnt),
+[C_RX_RBUF_FL_WRITE_ADDR_PARITY_ERR] = CNTR_ELEM("RxRbufFlWrAddrParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_fl_write_addr_parity_err_cnt),
+[C_RX_RBUF_FL_RD_ADDR_PARITY_ERR] = CNTR_ELEM("RxRbufFlRdAddrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_fl_rd_addr_parity_err_cnt),
+[C_RX_RBUF_EMPTY_ERR] = CNTR_ELEM("RxRbufEmptyErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_empty_err_cnt),
+[C_RX_RBUF_FULL_ERR] = CNTR_ELEM("RxRbufFullErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_full_err_cnt),
+[C_RX_RBUF_BAD_LOOKUP_ERR] = CNTR_ELEM("RxRBufBadLookupErr", 0, 0,
+			CNTR_NORMAL,
+			access_rbuf_bad_lookup_err_cnt),
+[C_RX_RBUF_CTX_ID_PARITY_ERR] = CNTR_ELEM("RxRbufCtxIdParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rbuf_ctx_id_parity_err_cnt),
+[C_RX_RBUF_CSR_QEOPDW_PARITY_ERR] = CNTR_ELEM("RxRbufCsrQEOPDWParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rbuf_csr_qeopdw_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_NUM_OF_PKT_PARITY_ERR] = CNTR_ELEM(
+			"RxRbufCsrQNumOfPktParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_csr_q_num_of_pkt_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_T1_PTR_PARITY_ERR] = CNTR_ELEM(
+			"RxRbufCsrQTlPtrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_csr_q_t1_ptr_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_HD_PTR_PARITY_ERR] = CNTR_ELEM("RxRbufCsrQHdPtrParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_csr_q_hd_ptr_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_VLD_BIT_PARITY_ERR] = CNTR_ELEM("RxRbufCsrQVldBitParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_csr_q_vld_bit_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_NEXT_BUF_PARITY_ERR] = CNTR_ELEM("RxRbufCsrQNextBufParityErr",
+			0, 0, CNTR_NORMAL,
+			access_rx_rbuf_csr_q_next_buf_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_ENT_CNT_PARITY_ERR] = CNTR_ELEM("RxRbufCsrQEntCntParityErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_csr_q_ent_cnt_parity_err_cnt),
+[C_RX_RBUF_CSR_Q_HEAD_BUF_NUM_PARITY_ERR] = CNTR_ELEM(
+			"RxRbufCsrQHeadBufNumParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_csr_q_head_buf_num_parity_err_cnt),
+[C_RX_RBUF_BLOCK_LIST_READ_COR_ERR] = CNTR_ELEM("RxRbufBlockListReadCorErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_block_list_read_cor_err_cnt),
+[C_RX_RBUF_BLOCK_LIST_READ_UNC_ERR] = CNTR_ELEM("RxRbufBlockListReadUncErr", 0,
+			0, CNTR_NORMAL,
+			access_rx_rbuf_block_list_read_unc_err_cnt),
+[C_RX_RBUF_LOOKUP_DES_COR_ERR] = CNTR_ELEM("RxRbufLookupDesCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_lookup_des_cor_err_cnt),
+[C_RX_RBUF_LOOKUP_DES_UNC_ERR] = CNTR_ELEM("RxRbufLookupDesUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_lookup_des_unc_err_cnt),
+[C_RX_RBUF_LOOKUP_DES_REG_UNC_COR_ERR] = CNTR_ELEM(
+			"RxRbufLookupDesRegUncCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_lookup_des_reg_unc_cor_err_cnt),
+[C_RX_RBUF_LOOKUP_DES_REG_UNC_ERR] = CNTR_ELEM("RxRbufLookupDesRegUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_lookup_des_reg_unc_err_cnt),
+[C_RX_RBUF_FREE_LIST_COR_ERR] = CNTR_ELEM("RxRbufFreeListCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_free_list_cor_err_cnt),
+[C_RX_RBUF_FREE_LIST_UNC_ERR] = CNTR_ELEM("RxRbufFreeListUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rbuf_free_list_unc_err_cnt),
+[C_RX_RCV_FSM_ENCODING_ERR] = CNTR_ELEM("RxRcvFsmEncodingErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_fsm_encoding_err_cnt),
+[C_RX_DMA_FLAG_COR_ERR] = CNTR_ELEM("RxDmaFlagCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_flag_cor_err_cnt),
+[C_RX_DMA_FLAG_UNC_ERR] = CNTR_ELEM("RxDmaFlagUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_flag_unc_err_cnt),
+[C_RX_DC_SOP_EOP_PARITY_ERR] = CNTR_ELEM("RxDcSopEopParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dc_sop_eop_parity_err_cnt),
+[C_RX_RCV_CSR_PARITY_ERR] = CNTR_ELEM("RxRcvCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_csr_parity_err_cnt),
+[C_RX_RCV_QP_MAP_TABLE_COR_ERR] = CNTR_ELEM("RxRcvQpMapTableCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_qp_map_table_cor_err_cnt),
+[C_RX_RCV_QP_MAP_TABLE_UNC_ERR] = CNTR_ELEM("RxRcvQpMapTableUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_qp_map_table_unc_err_cnt),
+[C_RX_RCV_DATA_COR_ERR] = CNTR_ELEM("RxRcvDataCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_data_cor_err_cnt),
+[C_RX_RCV_DATA_UNC_ERR] = CNTR_ELEM("RxRcvDataUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_data_unc_err_cnt),
+[C_RX_RCV_HDR_COR_ERR] = CNTR_ELEM("RxRcvHdrCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_hdr_cor_err_cnt),
+[C_RX_RCV_HDR_UNC_ERR] = CNTR_ELEM("RxRcvHdrUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_rcv_hdr_unc_err_cnt),
+[C_RX_DC_INTF_PARITY_ERR] = CNTR_ELEM("RxDcIntfParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dc_intf_parity_err_cnt),
+[C_RX_DMA_CSR_COR_ERR] = CNTR_ELEM("RxDmaCsrCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_rx_dma_csr_cor_err_cnt),
+/* SendPioErrStatus */
+[C_PIO_PEC_SOP_HEAD_PARITY_ERR] = CNTR_ELEM("PioPecSopHeadParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pec_sop_head_parity_err_cnt),
+[C_PIO_PCC_SOP_HEAD_PARITY_ERR] = CNTR_ELEM("PioPccSopHeadParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pcc_sop_head_parity_err_cnt),
+[C_PIO_LAST_RETURNED_CNT_PARITY_ERR] = CNTR_ELEM("PioLastReturnedCntParityErr",
+			0, 0, CNTR_NORMAL,
+			access_pio_last_returned_cnt_parity_err_cnt),
+[C_PIO_CURRENT_FREE_CNT_PARITY_ERR] = CNTR_ELEM("PioCurrentFreeCntParityErr", 0,
+			0, CNTR_NORMAL,
+			access_pio_current_free_cnt_parity_err_cnt),
+[C_PIO_RSVD_31_ERR] = CNTR_ELEM("Pio Reserved 31", 0, 0,
+			CNTR_NORMAL,
+			access_pio_reserved_31_err_cnt),
+[C_PIO_RSVD_30_ERR] = CNTR_ELEM("Pio Reserved 30", 0, 0,
+			CNTR_NORMAL,
+			access_pio_reserved_30_err_cnt),
+[C_PIO_PPMC_SOP_LEN_ERR] = CNTR_ELEM("PioPpmcSopLenErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_ppmc_sop_len_err_cnt),
+[C_PIO_PPMC_BQC_MEM_PARITY_ERR] = CNTR_ELEM("PioPpmcBqcMemParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_ppmc_bqc_mem_parity_err_cnt),
+[C_PIO_VL_FIFO_PARITY_ERR] = CNTR_ELEM("PioVlFifoParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_vl_fifo_parity_err_cnt),
+[C_PIO_VLF_SOP_PARITY_ERR] = CNTR_ELEM("PioVlfSopParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_vlf_sop_parity_err_cnt),
+[C_PIO_VLF_V1_LEN_PARITY_ERR] = CNTR_ELEM("PioVlfVlLenParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_vlf_v1_len_parity_err_cnt),
+[C_PIO_BLOCK_QW_COUNT_PARITY_ERR] = CNTR_ELEM("PioBlockQwCountParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_block_qw_count_parity_err_cnt),
+[C_PIO_WRITE_QW_VALID_PARITY_ERR] = CNTR_ELEM("PioWriteQwValidParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_qw_valid_parity_err_cnt),
+[C_PIO_STATE_MACHINE_ERR] = CNTR_ELEM("PioStateMachineErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_state_machine_err_cnt),
+[C_PIO_WRITE_DATA_PARITY_ERR] = CNTR_ELEM("PioWriteDataParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_data_parity_err_cnt),
+[C_PIO_HOST_ADDR_MEM_COR_ERR] = CNTR_ELEM("PioHostAddrMemCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_host_addr_mem_cor_err_cnt),
+[C_PIO_HOST_ADDR_MEM_UNC_ERR] = CNTR_ELEM("PioHostAddrMemUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_host_addr_mem_unc_err_cnt),
+[C_PIO_PKT_EVICT_SM_OR_ARM_SM_ERR] = CNTR_ELEM("PioPktEvictSmOrArbSmErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pkt_evict_sm_or_arb_sm_err_cnt),
+[C_PIO_INIT_SM_IN_ERR] = CNTR_ELEM("PioInitSmInErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_init_sm_in_err_cnt),
+[C_PIO_PPMC_PBL_FIFO_ERR] = CNTR_ELEM("PioPpmcPblFifoErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_ppmc_pbl_fifo_err_cnt),
+[C_PIO_CREDIT_RET_FIFO_PARITY_ERR] = CNTR_ELEM("PioCreditRetFifoParityErr", 0,
+			0, CNTR_NORMAL,
+			access_pio_credit_ret_fifo_parity_err_cnt),
+[C_PIO_V1_LEN_MEM_BANK1_COR_ERR] = CNTR_ELEM("PioVlLenMemBank1CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_v1_len_mem_bank1_cor_err_cnt),
+[C_PIO_V1_LEN_MEM_BANK0_COR_ERR] = CNTR_ELEM("PioVlLenMemBank0CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_v1_len_mem_bank0_cor_err_cnt),
+[C_PIO_V1_LEN_MEM_BANK1_UNC_ERR] = CNTR_ELEM("PioVlLenMemBank1UncErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_v1_len_mem_bank1_unc_err_cnt),
+[C_PIO_V1_LEN_MEM_BANK0_UNC_ERR] = CNTR_ELEM("PioVlLenMemBank0UncErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_v1_len_mem_bank0_unc_err_cnt),
+[C_PIO_SM_PKT_RESET_PARITY_ERR] = CNTR_ELEM("PioSmPktResetParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_sm_pkt_reset_parity_err_cnt),
+[C_PIO_PKT_EVICT_FIFO_PARITY_ERR] = CNTR_ELEM("PioPktEvictFifoParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pkt_evict_fifo_parity_err_cnt),
+[C_PIO_SBRDCTRL_CRREL_FIFO_PARITY_ERR] = CNTR_ELEM(
+			"PioSbrdctrlCrrelFifoParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_sbrdctrl_crrel_fifo_parity_err_cnt),
+[C_PIO_SBRDCTL_CRREL_PARITY_ERR] = CNTR_ELEM("PioSbrdctlCrrelParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_sbrdctl_crrel_parity_err_cnt),
+[C_PIO_PEC_FIFO_PARITY_ERR] = CNTR_ELEM("PioPecFifoParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pec_fifo_parity_err_cnt),
+[C_PIO_PCC_FIFO_PARITY_ERR] = CNTR_ELEM("PioPccFifoParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_pcc_fifo_parity_err_cnt),
+[C_PIO_SB_MEM_FIFO1_ERR] = CNTR_ELEM("PioSbMemFifo1Err", 0, 0,
+			CNTR_NORMAL,
+			access_pio_sb_mem_fifo1_err_cnt),
+[C_PIO_SB_MEM_FIFO0_ERR] = CNTR_ELEM("PioSbMemFifo0Err", 0, 0,
+			CNTR_NORMAL,
+			access_pio_sb_mem_fifo0_err_cnt),
+[C_PIO_CSR_PARITY_ERR] = CNTR_ELEM("PioCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_csr_parity_err_cnt),
+[C_PIO_WRITE_ADDR_PARITY_ERR] = CNTR_ELEM("PioWriteAddrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_addr_parity_err_cnt),
+[C_PIO_WRITE_BAD_CTXT_ERR] = CNTR_ELEM("PioWriteBadCtxtErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_bad_ctxt_err_cnt),
+/* SendDmaErrStatus */
+[C_SDMA_PCIE_REQ_TRACKING_COR_ERR] = CNTR_ELEM("SDmaPcieReqTrackingCorErr", 0,
+			0, CNTR_NORMAL,
+			access_sdma_pcie_req_tracking_cor_err_cnt),
+[C_SDMA_PCIE_REQ_TRACKING_UNC_ERR] = CNTR_ELEM("SDmaPcieReqTrackingUncErr", 0,
+			0, CNTR_NORMAL,
+			access_sdma_pcie_req_tracking_unc_err_cnt),
+[C_SDMA_CSR_PARITY_ERR] = CNTR_ELEM("SDmaCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_csr_parity_err_cnt),
+[C_SDMA_RPY_TAG_ERR] = CNTR_ELEM("SDmaRpyTagErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_rpy_tag_err_cnt),
+/* SendEgressErrStatus */
+[C_TX_READ_PIO_MEMORY_CSR_UNC_ERR] = CNTR_ELEM("TxReadPioMemoryCsrUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_read_pio_memory_csr_unc_err_cnt),
+[C_TX_READ_SDMA_MEMORY_CSR_UNC_ERR] = CNTR_ELEM("TxReadSdmaMemoryCsrUncErr", 0,
+			0, CNTR_NORMAL,
+			access_tx_read_sdma_memory_csr_err_cnt),
+[C_TX_EGRESS_FIFO_COR_ERR] = CNTR_ELEM("TxEgressFifoCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_egress_fifo_cor_err_cnt),
+[C_TX_READ_PIO_MEMORY_COR_ERR] = CNTR_ELEM("TxReadPioMemoryCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_read_pio_memory_cor_err_cnt),
+[C_TX_READ_SDMA_MEMORY_COR_ERR] = CNTR_ELEM("TxReadSdmaMemoryCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_read_sdma_memory_cor_err_cnt),
+[C_TX_SB_HDR_COR_ERR] = CNTR_ELEM("TxSbHdrCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_sb_hdr_cor_err_cnt),
+[C_TX_CREDIT_OVERRUN_ERR] = CNTR_ELEM("TxCreditOverrunErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_credit_overrun_err_cnt),
+[C_TX_LAUNCH_FIFO8_COR_ERR] = CNTR_ELEM("TxLaunchFifo8CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo8_cor_err_cnt),
+[C_TX_LAUNCH_FIFO7_COR_ERR] = CNTR_ELEM("TxLaunchFifo7CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo7_cor_err_cnt),
+[C_TX_LAUNCH_FIFO6_COR_ERR] = CNTR_ELEM("TxLaunchFifo6CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo6_cor_err_cnt),
+[C_TX_LAUNCH_FIFO5_COR_ERR] = CNTR_ELEM("TxLaunchFifo5CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo5_cor_err_cnt),
+[C_TX_LAUNCH_FIFO4_COR_ERR] = CNTR_ELEM("TxLaunchFifo4CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo4_cor_err_cnt),
+[C_TX_LAUNCH_FIFO3_COR_ERR] = CNTR_ELEM("TxLaunchFifo3CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo3_cor_err_cnt),
+[C_TX_LAUNCH_FIFO2_COR_ERR] = CNTR_ELEM("TxLaunchFifo2CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo2_cor_err_cnt),
+[C_TX_LAUNCH_FIFO1_COR_ERR] = CNTR_ELEM("TxLaunchFifo1CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo1_cor_err_cnt),
+[C_TX_LAUNCH_FIFO0_COR_ERR] = CNTR_ELEM("TxLaunchFifo0CorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_fifo0_cor_err_cnt),
+[C_TX_CREDIT_RETURN_VL_ERR] = CNTR_ELEM("TxCreditReturnVLErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_credit_return_vl_err_cnt),
+[C_TX_HCRC_INSERTION_ERR] = CNTR_ELEM("TxHcrcInsertionErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_hcrc_insertion_err_cnt),
+[C_TX_EGRESS_FIFI_UNC_ERR] = CNTR_ELEM("TxEgressFifoUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_egress_fifo_unc_err_cnt),
+[C_TX_READ_PIO_MEMORY_UNC_ERR] = CNTR_ELEM("TxReadPioMemoryUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_read_pio_memory_unc_err_cnt),
+[C_TX_READ_SDMA_MEMORY_UNC_ERR] = CNTR_ELEM("TxReadSdmaMemoryUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_read_sdma_memory_unc_err_cnt),
+[C_TX_SB_HDR_UNC_ERR] = CNTR_ELEM("TxSbHdrUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_sb_hdr_unc_err_cnt),
+[C_TX_CREDIT_RETURN_PARITY_ERR] = CNTR_ELEM("TxCreditReturnParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_credit_return_partiy_err_cnt),
+[C_TX_LAUNCH_FIFO8_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo8UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo8_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO7_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo7UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo7_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO6_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo6UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo6_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO5_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo5UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo5_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO4_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo4UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo4_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO3_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo3UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo3_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO2_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo2UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo2_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO1_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo1UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo1_unc_or_parity_err_cnt),
+[C_TX_LAUNCH_FIFO0_UNC_OR_PARITY_ERR] = CNTR_ELEM("TxLaunchFifo0UncOrParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_launch_fifo0_unc_or_parity_err_cnt),
+[C_TX_SDMA15_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma15DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma15_disallowed_packet_err_cnt),
+[C_TX_SDMA14_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma14DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma14_disallowed_packet_err_cnt),
+[C_TX_SDMA13_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma13DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma13_disallowed_packet_err_cnt),
+[C_TX_SDMA12_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma12DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma12_disallowed_packet_err_cnt),
+[C_TX_SDMA11_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma11DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma11_disallowed_packet_err_cnt),
+[C_TX_SDMA10_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma10DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma10_disallowed_packet_err_cnt),
+[C_TX_SDMA9_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma9DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma9_disallowed_packet_err_cnt),
+[C_TX_SDMA8_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma8DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma8_disallowed_packet_err_cnt),
+[C_TX_SDMA7_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma7DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma7_disallowed_packet_err_cnt),
+[C_TX_SDMA6_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma6DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma6_disallowed_packet_err_cnt),
+[C_TX_SDMA5_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma5DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma5_disallowed_packet_err_cnt),
+[C_TX_SDMA4_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma4DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma4_disallowed_packet_err_cnt),
+[C_TX_SDMA3_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma3DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma3_disallowed_packet_err_cnt),
+[C_TX_SDMA2_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma2DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma2_disallowed_packet_err_cnt),
+[C_TX_SDMA1_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma1DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma1_disallowed_packet_err_cnt),
+[C_TX_SDMA0_DISALLOWED_PACKET_ERR] = CNTR_ELEM("TxSdma0DisallowedPacketErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma0_disallowed_packet_err_cnt),
+[C_TX_CONFIG_PARITY_ERR] = CNTR_ELEM("TxConfigParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_config_parity_err_cnt),
+[C_TX_SBRD_CTL_CSR_PARITY_ERR] = CNTR_ELEM("TxSbrdCtlCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_sbrd_ctl_csr_parity_err_cnt),
+[C_TX_LAUNCH_CSR_PARITY_ERR] = CNTR_ELEM("TxLaunchCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_launch_csr_parity_err_cnt),
+[C_TX_ILLEGAL_CL_ERR] = CNTR_ELEM("TxIllegalVLErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_illegal_vl_err_cnt),
+[C_TX_SBRD_CTL_STATE_MACHINE_PARITY_ERR] = CNTR_ELEM(
+			"TxSbrdCtlStateMachineParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_sbrd_ctl_state_machine_parity_err_cnt),
+[C_TX_RESERVED_10] = CNTR_ELEM("Tx Egress Reserved 10", 0, 0,
+			CNTR_NORMAL,
+			access_egress_reserved_10_err_cnt),
+[C_TX_RESERVED_9] = CNTR_ELEM("Tx Egress Reserved 9", 0, 0,
+			CNTR_NORMAL,
+			access_egress_reserved_9_err_cnt),
+[C_TX_SDMA_LAUNCH_INTF_PARITY_ERR] = CNTR_ELEM("TxSdmaLaunchIntfParityErr",
+			0, 0, CNTR_NORMAL,
+			access_tx_sdma_launch_intf_parity_err_cnt),
+[C_TX_PIO_LAUNCH_INTF_PARITY_ERR] = CNTR_ELEM("TxPioLaunchIntfParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_pio_launch_intf_parity_err_cnt),
+[C_TX_RESERVED_6] = CNTR_ELEM("Tx Egress Reserved 6", 0, 0,
+			CNTR_NORMAL,
+			access_egress_reserved_6_err_cnt),
+[C_TX_INCORRECT_LINK_STATE_ERR] = CNTR_ELEM("TxIncorrectLinkStateErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_incorrect_link_state_err_cnt),
+[C_TX_LINK_DOWN_ERR] = CNTR_ELEM("TxLinkdownErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_linkdown_err_cnt),
+[C_TX_EGRESS_FIFO_UNDERRUN_OR_PARITY_ERR] = CNTR_ELEM(
+			"EgressFifoUnderrunOrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_egress_fifi_underrun_or_parity_err_cnt),
+[C_TX_RESERVED_2] = CNTR_ELEM("Tx Egress Reserved 2", 0, 0,
+			CNTR_NORMAL,
+			access_egress_reserved_2_err_cnt),
+[C_TX_PKT_INTEGRITY_MEM_UNC_ERR] = CNTR_ELEM("TxPktIntegrityMemUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_pkt_integrity_mem_unc_err_cnt),
+[C_TX_PKT_INTEGRITY_MEM_COR_ERR] = CNTR_ELEM("TxPktIntegrityMemCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_tx_pkt_integrity_mem_cor_err_cnt),
+/* SendErrStatus */
+[C_SEND_CSR_WRITE_BAD_ADDR_ERR] = CNTR_ELEM("SendCsrWriteBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_send_csr_write_bad_addr_err_cnt),
+[C_SEND_CSR_READ_BAD_ADD_ERR] = CNTR_ELEM("SendCsrReadBadAddrErr", 0, 0,
+			CNTR_NORMAL,
+			access_send_csr_read_bad_addr_err_cnt),
+[C_SEND_CSR_PARITY_ERR] = CNTR_ELEM("SendCsrParityErr", 0, 0,
+			CNTR_NORMAL,
+			access_send_csr_parity_cnt),
+/* SendCtxtErrStatus */
+[C_PIO_WRITE_OUT_OF_BOUNDS_ERR] = CNTR_ELEM("PioWriteOutOfBoundsErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_out_of_bounds_err_cnt),
+[C_PIO_WRITE_OVERFLOW_ERR] = CNTR_ELEM("PioWriteOverflowErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_write_overflow_err_cnt),
+[C_PIO_WRITE_CROSSES_BOUNDARY_ERR] = CNTR_ELEM("PioWriteCrossesBoundaryErr",
+			0, 0, CNTR_NORMAL,
+			access_pio_write_crosses_boundary_err_cnt),
+[C_PIO_DISALLOWED_PACKET_ERR] = CNTR_ELEM("PioDisallowedPacketErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_disallowed_packet_err_cnt),
+[C_PIO_INCONSISTENT_SOP_ERR] = CNTR_ELEM("PioInconsistentSopErr", 0, 0,
+			CNTR_NORMAL,
+			access_pio_inconsistent_sop_err_cnt),
+/* SendDmaEngErrStatus */
+[C_SDMA_HEADER_REQUEST_FIFO_COR_ERR] = CNTR_ELEM("SDmaHeaderRequestFifoCorErr",
+			0, 0, CNTR_NORMAL,
+			access_sdma_header_request_fifo_cor_err_cnt),
+[C_SDMA_HEADER_STORAGE_COR_ERR] = CNTR_ELEM("SDmaHeaderStorageCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_header_storage_cor_err_cnt),
+[C_SDMA_PACKET_TRACKING_COR_ERR] = CNTR_ELEM("SDmaPacketTrackingCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_packet_tracking_cor_err_cnt),
+[C_SDMA_ASSEMBLY_COR_ERR] = CNTR_ELEM("SDmaAssemblyCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_assembly_cor_err_cnt),
+[C_SDMA_DESC_TABLE_COR_ERR] = CNTR_ELEM("SDmaDescTableCorErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_desc_table_cor_err_cnt),
+[C_SDMA_HEADER_REQUEST_FIFO_UNC_ERR] = CNTR_ELEM("SDmaHeaderRequestFifoUncErr",
+			0, 0, CNTR_NORMAL,
+			access_sdma_header_request_fifo_unc_err_cnt),
+[C_SDMA_HEADER_STORAGE_UNC_ERR] = CNTR_ELEM("SDmaHeaderStorageUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_header_storage_unc_err_cnt),
+[C_SDMA_PACKET_TRACKING_UNC_ERR] = CNTR_ELEM("SDmaPacketTrackingUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_packet_tracking_unc_err_cnt),
+[C_SDMA_ASSEMBLY_UNC_ERR] = CNTR_ELEM("SDmaAssemblyUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_assembly_unc_err_cnt),
+[C_SDMA_DESC_TABLE_UNC_ERR] = CNTR_ELEM("SDmaDescTableUncErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_desc_table_unc_err_cnt),
+[C_SDMA_TIMEOUT_ERR] = CNTR_ELEM("SDmaTimeoutErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_timeout_err_cnt),
+[C_SDMA_HEADER_LENGTH_ERR] = CNTR_ELEM("SDmaHeaderLengthErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_header_length_err_cnt),
+[C_SDMA_HEADER_ADDRESS_ERR] = CNTR_ELEM("SDmaHeaderAddressErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_header_address_err_cnt),
+[C_SDMA_HEADER_SELECT_ERR] = CNTR_ELEM("SDmaHeaderSelectErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_header_select_err_cnt),
+[C_SMDA_RESERVED_9] = CNTR_ELEM("SDma Reserved 9", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_reserved_9_err_cnt),
+[C_SDMA_PACKET_DESC_OVERFLOW_ERR] = CNTR_ELEM("SDmaPacketDescOverflowErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_packet_desc_overflow_err_cnt),
+[C_SDMA_LENGTH_MISMATCH_ERR] = CNTR_ELEM("SDmaLengthMismatchErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_length_mismatch_err_cnt),
+[C_SDMA_HALT_ERR] = CNTR_ELEM("SDmaHaltErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_halt_err_cnt),
+[C_SDMA_MEM_READ_ERR] = CNTR_ELEM("SDmaMemReadErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_mem_read_err_cnt),
+[C_SDMA_FIRST_DESC_ERR] = CNTR_ELEM("SDmaFirstDescErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_first_desc_err_cnt),
+[C_SDMA_TAIL_OUT_OF_BOUNDS_ERR] = CNTR_ELEM("SDmaTailOutOfBoundsErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_tail_out_of_bounds_err_cnt),
+[C_SDMA_TOO_LONG_ERR] = CNTR_ELEM("SDmaTooLongErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_too_long_err_cnt),
+[C_SDMA_GEN_MISMATCH_ERR] = CNTR_ELEM("SDmaGenMismatchErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_gen_mismatch_err_cnt),
+[C_SDMA_WRONG_DW_ERR] = CNTR_ELEM("SDmaWrongDwErr", 0, 0,
+			CNTR_NORMAL,
+			access_sdma_wrong_dw_err_cnt),
 };
 
 static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
@@ -2182,6 +5300,7 @@ static char *send_err_status_string(char *buf, int buf_len, u64 flags)
 static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	/*
 	 * For most these errors, there is nothing that can be done except
@@ -2197,6 +5316,14 @@ static void handle_cce_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		/* then a fix up */
 		start_freeze_handling(dd->pport, FREEZE_SELF);
 	}
+
+	for (i = 0; i < NUM_CCE_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i)) {
+			incr_cntr64(&dd->cce_err_status_cnt[i]);
+			/* maintain a counter over all cce_err_status errors */
+			incr_cntr64(&dd->sw_cce_err_status_aggregate);
+		}
+	}
 }
 
 /*
@@ -2241,6 +5368,7 @@ static void free_rcverr(struct hfi1_devdata *dd)
 static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	dd_dev_info(dd, "Receive Error: %s\n",
 		rxe_err_status_string(buf, sizeof(buf), reg));
@@ -2257,36 +5385,58 @@ static void handle_rxe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 
 		start_freeze_handling(dd->pport, flags);
 	}
+
+	for (i = 0; i < NUM_RCV_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->rcv_err_status_cnt[i]);
+	}
 }
 
 static void handle_misc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	dd_dev_info(dd, "Misc Error: %s",
 		misc_err_status_string(buf, sizeof(buf), reg));
+	for (i = 0; i < NUM_MISC_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->misc_err_status_cnt[i]);
+	}
 }
 
 static void handle_pio_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	dd_dev_info(dd, "PIO Error: %s\n",
 		pio_err_status_string(buf, sizeof(buf), reg));
 
 	if (reg & ALL_PIO_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
+
+	for (i = 0; i < NUM_SEND_PIO_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->send_pio_err_status_cnt[i]);
+	}
 }
 
 static void handle_sdma_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	dd_dev_info(dd, "SDMA Error: %s\n",
 		sdma_err_status_string(buf, sizeof(buf), reg));
 
 	if (reg & ALL_SDMA_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
+
+	for (i = 0; i < NUM_SEND_DMA_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->send_dma_err_status_cnt[i]);
+	}
 }
 
 static void count_port_inactive(struct hfi1_devdata *dd)
@@ -2352,6 +5502,7 @@ static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	u64 reg_copy = reg, handled = 0;
 	char buf[96];
+	int i = 0;
 
 	if (reg & ALL_TXE_EGRESS_FREEZE_ERR)
 		start_freeze_handling(dd->pport, 0);
@@ -2383,15 +5534,25 @@ static void handle_egress_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 	if (reg)
 		dd_dev_info(dd, "Egress Error: %s\n",
 			egress_err_status_string(buf, sizeof(buf), reg));
+
+	for (i = 0; i < NUM_SEND_EGRESS_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->send_egress_err_status_cnt[i]);
+	}
 }
 
 static void handle_txe_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 {
 	char buf[96];
+	int i = 0;
 
 	dd_dev_info(dd, "Send Error: %s\n",
 		send_err_status_string(buf, sizeof(buf), reg));
 
+	for (i = 0; i < NUM_SEND_ERR_STATUS_COUNTERS; i++) {
+		if (reg & (1ull << i))
+			incr_cntr64(&dd->send_err_status_cnt[i]);
+	}
 }
 
 /*
@@ -2483,6 +5644,7 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	char flags[96];
 	u64 status;
 	u32 sw_index;
+	int i = 0;
 
 	sw_index = dd->hw_to_sw[hw_context];
 	if (sw_index >= dd->num_send_contexts) {
@@ -2516,12 +5678,23 @@ static void is_sendctxt_err_int(struct hfi1_devdata *dd,
 	 */
 	if (sc->type != SC_USER)
 		queue_work(dd->pport->hfi1_wq, &sc->halt_work);
+
+	/*
+	 * Update the counters for the corresponding status bits.
+	 * Note that these particular counters are aggregated over all
+	 * 160 contexts.
+	 */
+	for (i = 0; i < NUM_SEND_CTXT_ERR_STATUS_COUNTERS; i++) {
+		if (status & (1ull << i))
+			incr_cntr64(&dd->sw_ctxt_err_status_cnt[i]);
+	}
 }
 
 static void handle_sdma_eng_err(struct hfi1_devdata *dd,
 				unsigned int source, u64 status)
 {
 	struct sdma_engine *sde;
+	int i = 0;
 
 	sde = &dd->per_sdma[source];
 #ifdef CONFIG_SDMA_VERBOSITY
@@ -2531,6 +5704,16 @@ static void handle_sdma_eng_err(struct hfi1_devdata *dd,
 		   sde->this_idx, source, (unsigned long long)status);
 #endif
 	sdma_engine_error(sde, status);
+
+	/*
+	* Update the counters for the corresponding status bits.
+	* Note that these particular counters are aggregated over
+	* all 16 DMA engines.
+	*/
+	for (i = 0; i < NUM_SEND_DMA_ENG_ERR_STATUS_COUNTERS; i++) {
+		if (status & (1ull << i))
+			incr_cntr64(&dd->sw_send_dma_eng_err_status_cnt[i]);
+	}
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index ebf9041..a24dd09 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -788,6 +788,275 @@ enum {
 	C_SW_PIO_WAIT,
 	C_SW_KMEM_WAIT,
 	C_SW_SEND_SCHED,
+/* MISC_ERR_STATUS */
+	C_MISC_PLL_LOCK_FAIL_ERR,
+	C_MISC_MBIST_FAIL_ERR,
+	C_MISC_INVALID_EEP_CMD_ERR,
+	C_MISC_EFUSE_DONE_PARITY_ERR,
+	C_MISC_EFUSE_WRITE_ERR,
+	C_MISC_EFUSE_READ_BAD_ADDR_ERR,
+	C_MISC_EFUSE_CSR_PARITY_ERR,
+	C_MISC_FW_AUTH_FAILED_ERR,
+	C_MISC_KEY_MISMATCH_ERR,
+	C_MISC_SBUS_WRITE_FAILED_ERR,
+	C_MISC_CSR_WRITE_BAD_ADDR_ERR,
+	C_MISC_CSR_READ_BAD_ADDR_ERR,
+	C_MISC_CSR_PARITY_ERR,
+/* CceErrStatus */
+	/*
+	* A special counter that is the aggregate count
+	* of all the cce_err_status errors.  The remainder
+	* are actual bits in the CceErrStatus register.
+	*/
+	C_CCE_ERR_STATUS_AGGREGATED_CNT,
+	C_CCE_MSIX_CSR_PARITY_ERR,
+	C_CCE_INT_MAP_UNC_ERR,
+	C_CCE_INT_MAP_COR_ERR,
+	C_CCE_MSIX_TABLE_UNC_ERR,
+	C_CCE_MSIX_TABLE_COR_ERR,
+	C_CCE_RXDMA_CONV_FIFO_PARITY_ERR,
+	C_CCE_RCPL_ASYNC_FIFO_PARITY_ERR,
+	C_CCE_SEG_WRITE_BAD_ADDR_ERR,
+	C_CCE_SEG_READ_BAD_ADDR_ERR,
+	C_LA_TRIGGERED,
+	C_CCE_TRGT_CPL_TIMEOUT_ERR,
+	C_PCIC_RECEIVE_PARITY_ERR,
+	C_PCIC_TRANSMIT_BACK_PARITY_ERR,
+	C_PCIC_TRANSMIT_FRONT_PARITY_ERR,
+	C_PCIC_CPL_DAT_Q_UNC_ERR,
+	C_PCIC_CPL_HD_Q_UNC_ERR,
+	C_PCIC_POST_DAT_Q_UNC_ERR,
+	C_PCIC_POST_HD_Q_UNC_ERR,
+	C_PCIC_RETRY_SOT_MEM_UNC_ERR,
+	C_PCIC_RETRY_MEM_UNC_ERR,
+	C_PCIC_N_POST_DAT_Q_PARITY_ERR,
+	C_PCIC_N_POST_H_Q_PARITY_ERR,
+	C_PCIC_CPL_DAT_Q_COR_ERR,
+	C_PCIC_CPL_HD_Q_COR_ERR,
+	C_PCIC_POST_DAT_Q_COR_ERR,
+	C_PCIC_POST_HD_Q_COR_ERR,
+	C_PCIC_RETRY_SOT_MEM_COR_ERR,
+	C_PCIC_RETRY_MEM_COR_ERR,
+	C_CCE_CLI1_ASYNC_FIFO_DBG_PARITY_ERR,
+	C_CCE_CLI1_ASYNC_FIFO_RXDMA_PARITY_ERR,
+	C_CCE_CLI1_ASYNC_FIFO_SDMA_HD_PARITY_ERR,
+	C_CCE_CLI1_ASYNC_FIFO_PIO_CRDT_PARITY_ERR,
+	C_CCE_CLI2_ASYNC_FIFO_PARITY_ERR,
+	C_CCE_CSR_CFG_BUS_PARITY_ERR,
+	C_CCE_CLI0_ASYNC_FIFO_PARTIY_ERR,
+	C_CCE_RSPD_DATA_PARITY_ERR,
+	C_CCE_TRGT_ACCESS_ERR,
+	C_CCE_TRGT_ASYNC_FIFO_PARITY_ERR,
+	C_CCE_CSR_WRITE_BAD_ADDR_ERR,
+	C_CCE_CSR_READ_BAD_ADDR_ERR,
+	C_CCE_CSR_PARITY_ERR,
+/* RcvErrStatus */
+	C_RX_CSR_PARITY_ERR,
+	C_RX_CSR_WRITE_BAD_ADDR_ERR,
+	C_RX_CSR_READ_BAD_ADDR_ERR,
+	C_RX_DMA_CSR_UNC_ERR,
+	C_RX_DMA_DQ_FSM_ENCODING_ERR,
+	C_RX_DMA_EQ_FSM_ENCODING_ERR,
+	C_RX_DMA_CSR_PARITY_ERR,
+	C_RX_RBUF_DATA_COR_ERR,
+	C_RX_RBUF_DATA_UNC_ERR,
+	C_RX_DMA_DATA_FIFO_RD_COR_ERR,
+	C_RX_DMA_DATA_FIFO_RD_UNC_ERR,
+	C_RX_DMA_HDR_FIFO_RD_COR_ERR,
+	C_RX_DMA_HDR_FIFO_RD_UNC_ERR,
+	C_RX_RBUF_DESC_PART2_COR_ERR,
+	C_RX_RBUF_DESC_PART2_UNC_ERR,
+	C_RX_RBUF_DESC_PART1_COR_ERR,
+	C_RX_RBUF_DESC_PART1_UNC_ERR,
+	C_RX_HQ_INTR_FSM_ERR,
+	C_RX_HQ_INTR_CSR_PARITY_ERR,
+	C_RX_LOOKUP_CSR_PARITY_ERR,
+	C_RX_LOOKUP_RCV_ARRAY_COR_ERR,
+	C_RX_LOOKUP_RCV_ARRAY_UNC_ERR,
+	C_RX_LOOKUP_DES_PART2_PARITY_ERR,
+	C_RX_LOOKUP_DES_PART1_UNC_COR_ERR,
+	C_RX_LOOKUP_DES_PART1_UNC_ERR,
+	C_RX_RBUF_NEXT_FREE_BUF_COR_ERR,
+	C_RX_RBUF_NEXT_FREE_BUF_UNC_ERR,
+	C_RX_RBUF_FL_INIT_WR_ADDR_PARITY_ERR,
+	C_RX_RBUF_FL_INITDONE_PARITY_ERR,
+	C_RX_RBUF_FL_WRITE_ADDR_PARITY_ERR,
+	C_RX_RBUF_FL_RD_ADDR_PARITY_ERR,
+	C_RX_RBUF_EMPTY_ERR,
+	C_RX_RBUF_FULL_ERR,
+	C_RX_RBUF_BAD_LOOKUP_ERR,
+	C_RX_RBUF_CTX_ID_PARITY_ERR,
+	C_RX_RBUF_CSR_QEOPDW_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_NUM_OF_PKT_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_T1_PTR_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_HD_PTR_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_VLD_BIT_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_NEXT_BUF_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_ENT_CNT_PARITY_ERR,
+	C_RX_RBUF_CSR_Q_HEAD_BUF_NUM_PARITY_ERR,
+	C_RX_RBUF_BLOCK_LIST_READ_COR_ERR,
+	C_RX_RBUF_BLOCK_LIST_READ_UNC_ERR,
+	C_RX_RBUF_LOOKUP_DES_COR_ERR,
+	C_RX_RBUF_LOOKUP_DES_UNC_ERR,
+	C_RX_RBUF_LOOKUP_DES_REG_UNC_COR_ERR,
+	C_RX_RBUF_LOOKUP_DES_REG_UNC_ERR,
+	C_RX_RBUF_FREE_LIST_COR_ERR,
+	C_RX_RBUF_FREE_LIST_UNC_ERR,
+	C_RX_RCV_FSM_ENCODING_ERR,
+	C_RX_DMA_FLAG_COR_ERR,
+	C_RX_DMA_FLAG_UNC_ERR,
+	C_RX_DC_SOP_EOP_PARITY_ERR,
+	C_RX_RCV_CSR_PARITY_ERR,
+	C_RX_RCV_QP_MAP_TABLE_COR_ERR,
+	C_RX_RCV_QP_MAP_TABLE_UNC_ERR,
+	C_RX_RCV_DATA_COR_ERR,
+	C_RX_RCV_DATA_UNC_ERR,
+	C_RX_RCV_HDR_COR_ERR,
+	C_RX_RCV_HDR_UNC_ERR,
+	C_RX_DC_INTF_PARITY_ERR,
+	C_RX_DMA_CSR_COR_ERR,
+/* SendPioErrStatus */
+	C_PIO_PEC_SOP_HEAD_PARITY_ERR,
+	C_PIO_PCC_SOP_HEAD_PARITY_ERR,
+	C_PIO_LAST_RETURNED_CNT_PARITY_ERR,
+	C_PIO_CURRENT_FREE_CNT_PARITY_ERR,
+	C_PIO_RSVD_31_ERR,
+	C_PIO_RSVD_30_ERR,
+	C_PIO_PPMC_SOP_LEN_ERR,
+	C_PIO_PPMC_BQC_MEM_PARITY_ERR,
+	C_PIO_VL_FIFO_PARITY_ERR,
+	C_PIO_VLF_SOP_PARITY_ERR,
+	C_PIO_VLF_V1_LEN_PARITY_ERR,
+	C_PIO_BLOCK_QW_COUNT_PARITY_ERR,
+	C_PIO_WRITE_QW_VALID_PARITY_ERR,
+	C_PIO_STATE_MACHINE_ERR,
+	C_PIO_WRITE_DATA_PARITY_ERR,
+	C_PIO_HOST_ADDR_MEM_COR_ERR,
+	C_PIO_HOST_ADDR_MEM_UNC_ERR,
+	C_PIO_PKT_EVICT_SM_OR_ARM_SM_ERR,
+	C_PIO_INIT_SM_IN_ERR,
+	C_PIO_PPMC_PBL_FIFO_ERR,
+	C_PIO_CREDIT_RET_FIFO_PARITY_ERR,
+	C_PIO_V1_LEN_MEM_BANK1_COR_ERR,
+	C_PIO_V1_LEN_MEM_BANK0_COR_ERR,
+	C_PIO_V1_LEN_MEM_BANK1_UNC_ERR,
+	C_PIO_V1_LEN_MEM_BANK0_UNC_ERR,
+	C_PIO_SM_PKT_RESET_PARITY_ERR,
+	C_PIO_PKT_EVICT_FIFO_PARITY_ERR,
+	C_PIO_SBRDCTRL_CRREL_FIFO_PARITY_ERR,
+	C_PIO_SBRDCTL_CRREL_PARITY_ERR,
+	C_PIO_PEC_FIFO_PARITY_ERR,
+	C_PIO_PCC_FIFO_PARITY_ERR,
+	C_PIO_SB_MEM_FIFO1_ERR,
+	C_PIO_SB_MEM_FIFO0_ERR,
+	C_PIO_CSR_PARITY_ERR,
+	C_PIO_WRITE_ADDR_PARITY_ERR,
+	C_PIO_WRITE_BAD_CTXT_ERR,
+/* SendDmaErrStatus */
+	C_SDMA_PCIE_REQ_TRACKING_COR_ERR,
+	C_SDMA_PCIE_REQ_TRACKING_UNC_ERR,
+	C_SDMA_CSR_PARITY_ERR,
+	C_SDMA_RPY_TAG_ERR,
+/* SendEgressErrStatus */
+	C_TX_READ_PIO_MEMORY_CSR_UNC_ERR,
+	C_TX_READ_SDMA_MEMORY_CSR_UNC_ERR,
+	C_TX_EGRESS_FIFO_COR_ERR,
+	C_TX_READ_PIO_MEMORY_COR_ERR,
+	C_TX_READ_SDMA_MEMORY_COR_ERR,
+	C_TX_SB_HDR_COR_ERR,
+	C_TX_CREDIT_OVERRUN_ERR,
+	C_TX_LAUNCH_FIFO8_COR_ERR,
+	C_TX_LAUNCH_FIFO7_COR_ERR,
+	C_TX_LAUNCH_FIFO6_COR_ERR,
+	C_TX_LAUNCH_FIFO5_COR_ERR,
+	C_TX_LAUNCH_FIFO4_COR_ERR,
+	C_TX_LAUNCH_FIFO3_COR_ERR,
+	C_TX_LAUNCH_FIFO2_COR_ERR,
+	C_TX_LAUNCH_FIFO1_COR_ERR,
+	C_TX_LAUNCH_FIFO0_COR_ERR,
+	C_TX_CREDIT_RETURN_VL_ERR,
+	C_TX_HCRC_INSERTION_ERR,
+	C_TX_EGRESS_FIFI_UNC_ERR,
+	C_TX_READ_PIO_MEMORY_UNC_ERR,
+	C_TX_READ_SDMA_MEMORY_UNC_ERR,
+	C_TX_SB_HDR_UNC_ERR,
+	C_TX_CREDIT_RETURN_PARITY_ERR,
+	C_TX_LAUNCH_FIFO8_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO7_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO6_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO5_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO4_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO3_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO2_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO1_UNC_OR_PARITY_ERR,
+	C_TX_LAUNCH_FIFO0_UNC_OR_PARITY_ERR,
+	C_TX_SDMA15_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA14_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA13_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA12_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA11_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA10_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA9_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA8_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA7_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA6_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA5_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA4_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA3_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA2_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA1_DISALLOWED_PACKET_ERR,
+	C_TX_SDMA0_DISALLOWED_PACKET_ERR,
+	C_TX_CONFIG_PARITY_ERR,
+	C_TX_SBRD_CTL_CSR_PARITY_ERR,
+	C_TX_LAUNCH_CSR_PARITY_ERR,
+	C_TX_ILLEGAL_CL_ERR,
+	C_TX_SBRD_CTL_STATE_MACHINE_PARITY_ERR,
+	C_TX_RESERVED_10,
+	C_TX_RESERVED_9,
+	C_TX_SDMA_LAUNCH_INTF_PARITY_ERR,
+	C_TX_PIO_LAUNCH_INTF_PARITY_ERR,
+	C_TX_RESERVED_6,
+	C_TX_INCORRECT_LINK_STATE_ERR,
+	C_TX_LINK_DOWN_ERR,
+	C_TX_EGRESS_FIFO_UNDERRUN_OR_PARITY_ERR,
+	C_TX_RESERVED_2,
+	C_TX_PKT_INTEGRITY_MEM_UNC_ERR,
+	C_TX_PKT_INTEGRITY_MEM_COR_ERR,
+/* SendErrStatus */
+	C_SEND_CSR_WRITE_BAD_ADDR_ERR,
+	C_SEND_CSR_READ_BAD_ADD_ERR,
+	C_SEND_CSR_PARITY_ERR,
+/* SendCtxtErrStatus */
+	C_PIO_WRITE_OUT_OF_BOUNDS_ERR,
+	C_PIO_WRITE_OVERFLOW_ERR,
+	C_PIO_WRITE_CROSSES_BOUNDARY_ERR,
+	C_PIO_DISALLOWED_PACKET_ERR,
+	C_PIO_INCONSISTENT_SOP_ERR,
+/*SendDmaEngErrStatus */
+	C_SDMA_HEADER_REQUEST_FIFO_COR_ERR,
+	C_SDMA_HEADER_STORAGE_COR_ERR,
+	C_SDMA_PACKET_TRACKING_COR_ERR,
+	C_SDMA_ASSEMBLY_COR_ERR,
+	C_SDMA_DESC_TABLE_COR_ERR,
+	C_SDMA_HEADER_REQUEST_FIFO_UNC_ERR,
+	C_SDMA_HEADER_STORAGE_UNC_ERR,
+	C_SDMA_PACKET_TRACKING_UNC_ERR,
+	C_SDMA_ASSEMBLY_UNC_ERR,
+	C_SDMA_DESC_TABLE_UNC_ERR,
+	C_SDMA_TIMEOUT_ERR,
+	C_SDMA_HEADER_LENGTH_ERR,
+	C_SDMA_HEADER_ADDRESS_ERR,
+	C_SDMA_HEADER_SELECT_ERR,
+	C_SMDA_RESERVED_9,
+	C_SDMA_PACKET_DESC_OVERFLOW_ERR,
+	C_SDMA_LENGTH_MISMATCH_ERR,
+	C_SDMA_HALT_ERR,
+	C_SDMA_MEM_READ_ERR,
+	C_SDMA_FIRST_DESC_ERR,
+	C_SDMA_TAIL_OUT_OF_BOUNDS_ERR,
+	C_SDMA_TOO_LONG_ERR,
+	C_SDMA_GEN_MISMATCH_ERR,
+	C_SDMA_WRONG_DW_ERR,
 	DEV_CNTR_LAST  /* Must be kept last */
 };
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index e7ed319..44a7124 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -100,6 +100,20 @@ extern unsigned long hfi1_cap_mask;
 			HFI1_CAP_MISC_MASK)
 
 /*
+ * Driver context will store software counters for each of the events
+ * associated with these status registers
+ */
+#define NUM_CCE_ERR_STATUS_COUNTERS 41
+#define NUM_RCV_ERR_STATUS_COUNTERS 64
+#define NUM_MISC_ERR_STATUS_COUNTERS 13
+#define NUM_SEND_PIO_ERR_STATUS_COUNTERS 36
+#define NUM_SEND_DMA_ERR_STATUS_COUNTERS 4
+#define NUM_SEND_EGRESS_ERR_STATUS_COUNTERS 64
+#define NUM_SEND_ERR_STATUS_COUNTERS 3
+#define NUM_SEND_CTXT_ERR_STATUS_COUNTERS 5
+#define NUM_SEND_DMA_ENG_ERR_STATUS_COUNTERS 24
+
+/*
  * per driver stats, either not device nor port-specific, or
  * summed over all of the devices and ports.
  * They are described by name via ipathfs filesystem, so layout
@@ -1053,6 +1067,26 @@ struct hfi1_devdata {
 	atomic_t drop_packet;
 	u8 do_drop;
 
+	/*
+	 * Software counters for the status bits defined by the
+	 * associated error status registers
+	 */
+	u64 cce_err_status_cnt[NUM_CCE_ERR_STATUS_COUNTERS];
+	u64 rcv_err_status_cnt[NUM_RCV_ERR_STATUS_COUNTERS];
+	u64 misc_err_status_cnt[NUM_MISC_ERR_STATUS_COUNTERS];
+	u64 send_pio_err_status_cnt[NUM_SEND_PIO_ERR_STATUS_COUNTERS];
+	u64 send_dma_err_status_cnt[NUM_SEND_DMA_ERR_STATUS_COUNTERS];
+	u64 send_egress_err_status_cnt[NUM_SEND_EGRESS_ERR_STATUS_COUNTERS];
+	u64 send_err_status_cnt[NUM_SEND_ERR_STATUS_COUNTERS];
+
+	/* Software counter that spans all contexts */
+	u64 sw_ctxt_err_status_cnt[NUM_SEND_CTXT_ERR_STATUS_COUNTERS];
+	/* Software counter that spans all DMA engines */
+	u64 sw_send_dma_eng_err_status_cnt[
+		NUM_SEND_DMA_ENG_ERR_STATUS_COUNTERS];
+	/* Software counter that aggregates all cce_err_status errors */
+	u64 sw_cce_err_status_aggregate;
+
 	/* receive interrupt functions */
 	rhf_rcv_function_ptr *rhf_rcv_function_map;
 	rhf_rcv_function_ptr normal_rhf_rcv_functions[8];
-- 
1.7.0.7
