From: Jubin John <jubin.john@intel.com>
Subject: [PATCH 17/18] staging/rdma/hfi1: Adding counter resolutions for
 DataPortCounters
Date: Fri, 13 Nov 2015 19:37:15 -0800
Message-ID: <1447472236-622-17-git-send-email-jubin.john@intel.com>
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

From: Andrea Lowe <andrea.l.lowe@intel.com>

Changing the 32-bit reserved field in opa_port_data_counters_msg
to the new 'resolution' field. PMA will use resolutions to right-
shift values for LocalLinkIntegrity and LinkErrorRecovery when
computing the ErrorCounterSummary for a DataPortCounters request.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Andrea Lowe <andrea.l.lowe@intel.com>
Signed-off-by: Jubin John <jubin.john@intel.com>
---
 drivers/staging/rdma/hfi1/mad.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index e151359..11a571a 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2076,13 +2076,20 @@ struct opa_aggregate {
 	u8 data[0];
 };
 
-/* Request contains first two fields, response contains those plus the rest */
+#define MSK_LLI 0x000000f0
+#define MSK_LLI_SFT 4
+#define MSK_LER 0x0000000f
+#define MSK_LER_SFT 0
+#define ADD_LLI 8
+#define ADD_LER 2
+
+/* Request contains first three fields, response contains those plus the rest */
 struct opa_port_data_counters_msg {
 	__be64 port_select_mask[4];
 	__be32 vl_select_mask;
+	__be32 resolution;
 
 	/* Response fields follow */
-	__be32 reserved1;
 	struct _port_dctrs {
 		u8 port_number;
 		u8 reserved2[3];
@@ -2480,7 +2487,8 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	return reply((struct ib_mad_hdr *)pmp);
 }
 
-static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port)
+static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
+				     u8 res_lli, u8 res_ler)
 {
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	struct hfi1_ibport *ibp = to_iport(ibdev, port);
@@ -2496,14 +2504,14 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port)
 						CNTR_INVALID_VL);
 	error_counter_summary += read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
 						CNTR_INVALID_VL);
-	error_counter_summary += read_dev_cntr(dd, C_DC_TX_REPLAY,
-						CNTR_INVALID_VL);
-	error_counter_summary += read_dev_cntr(dd, C_DC_RX_REPLAY,
-						CNTR_INVALID_VL);
-	error_counter_summary += read_dev_cntr(dd, C_DC_SEQ_CRC_CNT,
-						CNTR_INVALID_VL);
-	error_counter_summary += read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
-						CNTR_INVALID_VL);
+	/* local link integrity must be right-shifted by the lli resolution */
+	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
+	tmp += read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
+	error_counter_summary += (tmp >> res_lli);
+	/* link error recovery must b right-shifted by the ler resolution */
+	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
+	tmp += read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT, CNTR_INVALID_VL);
+	error_counter_summary += (tmp >> res_ler);
 	error_counter_summary += read_dev_cntr(dd, C_DC_RCV_ERR,
 						CNTR_INVALID_VL);
 	error_counter_summary += read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL);
@@ -2583,6 +2591,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	u32 num_ports;
 	u8 num_pslm;
 	u8 lq, num_vls;
+	u8 res_lli, res_ler;
 	u64 port_mask;
 	unsigned long port_num;
 	unsigned long vl;
@@ -2593,6 +2602,10 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));
 	num_vls = hweight32(be32_to_cpu(req->vl_select_mask));
 	vl_select_mask = be32_to_cpu(req->vl_select_mask);
+	res_lli = (u8)(be32_to_cpu(req->resolution) & MSK_LLI) >> MSK_LLI_SFT;
+	res_lli = res_lli ? res_lli + ADD_LLI : 0;
+	res_ler = (u8)(be32_to_cpu(req->resolution) & MSK_LER) >> MSK_LER_SFT;
+	res_ler = res_ler ? res_ler + ADD_LER : 0;
 
 	if (num_ports != 1 || (vl_select_mask & ~VL_MASK_ALL)) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
@@ -2663,7 +2676,8 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BCN, CNTR_INVALID_VL));
 
 	rsp->port_error_counter_summary =
-		cpu_to_be64(get_error_counter_summary(ibdev, port));
+		cpu_to_be64(get_error_counter_summary(ibdev, port,
+						      res_lli, res_ler));
 
 	vlinfo = &(rsp->vls[0]);
 	vfi = 0;
-- 
1.7.0.7
