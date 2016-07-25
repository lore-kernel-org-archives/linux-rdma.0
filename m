From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/28] IB/hfi1: Fix integrity errors counter value
 calculation
Date: Mon, 25 Jul 2016 13:37:54 -0700
Message-ID: <20160725203753.4800.72981.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

PMA should not sum TX and RX replay counts when reporting
local link integrity errors. Fixed by removing C_DC_TX_REPLAY
counter from calculation of the link integrity errors counter
value.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c |   32 +++++++++-----------------------
 1 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 962bb11..5590a4c 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2418,14 +2418,9 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 	rsp->port_rcv_remote_physical_errors =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
 					  CNTR_INVALID_VL));
-	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
-	tmp2 = tmp + read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
-	if (tmp2 < tmp) {
-		/* overflow/wrapped */
-		rsp->local_link_integrity_errors = cpu_to_be64(~0);
-	} else {
-		rsp->local_link_integrity_errors = cpu_to_be64(tmp2);
-	}
+	rsp->local_link_integrity_errors =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_RX_REPLAY,
+					  CNTR_INVALID_VL));
 	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
 	tmp2 = tmp + read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
 				   CNTR_INVALID_VL);
@@ -2520,9 +2515,8 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port,
 	error_counter_summary += read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
 					       CNTR_INVALID_VL);
 	/* local link integrity must be right-shifted by the lli resolution */
-	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
-	tmp += read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
-	error_counter_summary += (tmp >> res_lli);
+	error_counter_summary += (read_dev_cntr(dd, C_DC_RX_REPLAY,
+						CNTR_INVALID_VL) >> res_lli);
 	/* link error recovery must b right-shifted by the ler resolution */
 	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
 	tmp += read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT, CNTR_INVALID_VL);
@@ -2791,14 +2785,9 @@ static void pma_get_opa_port_ectrs(struct ib_device *ibdev,
 	rsp->port_rcv_constraint_errors =
 		cpu_to_be64(read_port_cntr(ppd, C_SW_RCV_CSTR_ERR,
 					   CNTR_INVALID_VL));
-	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
-	tmp2 = tmp + read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
-	if (tmp2 < tmp) {
-		/* overflow/wrapped */
-		rsp->local_link_integrity_errors = cpu_to_be64(~0);
-	} else {
-		rsp->local_link_integrity_errors = cpu_to_be64(tmp2);
-	}
+	rsp->local_link_integrity_errors =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_RX_REPLAY,
+					  CNTR_INVALID_VL));
 	rsp->excessive_buffer_overruns =
 		cpu_to_be64(read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL));
 }
@@ -3156,10 +3145,8 @@ static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
 	if (counter_select & CS_PORT_RCV_REMOTE_PHYSICAL_ERRORS)
 		write_dev_cntr(dd, C_DC_RMT_PHY_ERR, CNTR_INVALID_VL, 0);
 
-	if (counter_select & CS_LOCAL_LINK_INTEGRITY_ERRORS) {
-		write_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL, 0);
+	if (counter_select & CS_LOCAL_LINK_INTEGRITY_ERRORS)
 		write_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL, 0);
-	}
 
 	if (counter_select & CS_LINK_ERROR_RECOVERY) {
 		write_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL, 0);
@@ -3956,7 +3943,6 @@ void clear_linkup_counters(struct hfi1_devdata *dd)
 	write_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL, 0);
 	write_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT, CNTR_INVALID_VL, 0);
 	/* LocalLinkIntegrityErrors */
-	write_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL, 0);
 	write_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL, 0);
 	/* ExcessiveBufferOverruns */
 	write_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL, 0);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
