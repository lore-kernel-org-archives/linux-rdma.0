From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 04/13] staging/rdma/hfi: Remove rcv bubbles code
Date: Wed, 11 Nov 2015 02:33:24 -0500
Message-ID: <1447227213-15122-4-git-send-email-jubin.john@intel.com>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447227213-15122-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Rcv bubbles were improperly calculated for HFIs, fix that here.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   64 +-------------------------------------
 1 files changed, 2 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a4b7033..a23ddc4 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2271,34 +2271,8 @@ static void a0_portstatus(struct hfi1_pportdata *ppd,
 {
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
-		int vfi = 0;
 		u64 max_vl_xmit_wait = 0, tmp;
 		u32 vl_all_mask = VL_MASK_ALL;
-		u64 rcv_data, rcv_bubble;
-
-		rcv_data = be64_to_cpu(rsp->port_rcv_data);
-		rcv_bubble = be64_to_cpu(rsp->port_rcv_bubble);
-		/* In the measured time period, calculate the total number
-		 * of flits that were received. Subtract out one false
-		 * rcv_bubble increment for every 32 received flits but
-		 * don't let the number go negative.
-		 */
-		if (rcv_bubble >= (rcv_data>>5)) {
-			rcv_bubble -= (rcv_data>>5);
-			rsp->port_rcv_bubble = cpu_to_be64(rcv_bubble);
-		}
-		for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-				 8 * sizeof(vl_select_mask)) {
-			rcv_data = be64_to_cpu(rsp->vls[vfi].port_vl_rcv_data);
-			rcv_bubble =
-				be64_to_cpu(rsp->vls[vfi].port_vl_rcv_bubble);
-			if (rcv_bubble >= (rcv_data>>5)) {
-				rcv_bubble -= (rcv_data>>5);
-				rsp->vls[vfi].port_vl_rcv_bubble =
-							cpu_to_be64(rcv_bubble);
-			}
-			vfi++;
-		}
 
 		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
 				 8 * sizeof(vl_all_mask)) {
@@ -2363,8 +2337,6 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 					  CNTR_INVALID_VL));
 	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
 					 CNTR_INVALID_VL));
-	rsp->port_rcv_bubble =
-		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BBL, CNTR_INVALID_VL));
 	rsp->port_xmit_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_PKTS,
 					  CNTR_INVALID_VL));
 	rsp->port_rcv_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_PKTS,
@@ -2434,9 +2406,6 @@ static int pma_get_opa_portstatus(struct opa_pma_mad *pmp,
 
 		tmp = read_dev_cntr(dd, C_DC_RX_FLIT_VL, idx_from_vl(vl));
 		rsp->vls[vfi].port_vl_rcv_data = cpu_to_be64(tmp);
-		rsp->vls[vfi].port_vl_rcv_bubble =
-			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BBL_VL,
-					idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_rcv_pkts =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RX_PKT_VL,
@@ -2519,32 +2488,8 @@ static void a0_datacounters(struct hfi1_devdata *dd, struct _port_dctrs *rsp,
 	if (!is_bx(dd)) {
 		unsigned long vl;
 		int vfi = 0;
-		u64 rcv_data, rcv_bubble, sum_vl_xmit_wait = 0;
-
-		rcv_data = be64_to_cpu(rsp->port_rcv_data);
-		rcv_bubble = be64_to_cpu(rsp->port_rcv_bubble);
-		/* In the measured time period, calculate the total number
-		 * of flits that were received. Subtract out one false
-		 * rcv_bubble increment for every 32 received flits but
-		 * don't let the number go negative.
-		 */
-		if (rcv_bubble >= (rcv_data>>5)) {
-			rcv_bubble -= (rcv_data>>5);
-			rsp->port_rcv_bubble = cpu_to_be64(rcv_bubble);
-		}
-		for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-				8 * sizeof(vl_select_mask)) {
-			rcv_data = be64_to_cpu(rsp->vls[vfi].port_vl_rcv_data);
-			rcv_bubble =
-				be64_to_cpu(rsp->vls[vfi].port_vl_rcv_bubble);
-			if (rcv_bubble >= (rcv_data>>5)) {
-				rcv_bubble -= (rcv_data>>5);
-				rsp->vls[vfi].port_vl_rcv_bubble =
-							cpu_to_be64(rcv_bubble);
-			}
-			vfi++;
-		}
-		vfi = 0;
+		u64 sum_vl_xmit_wait = 0;
+
 		for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
 				8 * sizeof(vl_select_mask)) {
 			u64 tmp = sum_vl_xmit_wait +
@@ -2635,8 +2580,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 						CNTR_INVALID_VL));
 	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
 						CNTR_INVALID_VL));
-	rsp->port_rcv_bubble =
-		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BBL, CNTR_INVALID_VL));
 	rsp->port_xmit_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_PKTS,
 						CNTR_INVALID_VL));
 	rsp->port_rcv_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_PKTS,
@@ -2675,9 +2618,6 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		rsp->vls[vfi].port_vl_rcv_data =
 			cpu_to_be64(read_dev_cntr(dd, C_DC_RX_FLIT_VL,
 							idx_from_vl(vl)));
-		rsp->vls[vfi].port_vl_rcv_bubble =
-			cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BBL_VL,
-					idx_from_vl(vl)));
 
 		rsp->vls[vfi].port_vl_xmit_pkts =
 			cpu_to_be64(read_port_cntr(ppd, C_TX_PKT_VL,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
