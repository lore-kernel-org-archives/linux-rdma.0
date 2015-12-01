From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 16/17] staging/rdma/hfi1: Fix Xmit Wait calculation
Date: Tue,  1 Dec 2015 15:38:25 -0500
Message-ID: <1449002306-15180-17-git-send-email-jubin.john@intel.com>
References: <1449002306-15180-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449002306-15180-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Total XMIT wait needs to sum the xmit wait values of all the VLs not just
those requested in the query.  Also, make the algorithm used for both
PortStatus and PortDataCounters the same.

Reviewed-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Breyer, Scott J <scott.j.breyer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- No changes

 drivers/staging/rdma/hfi1/mad.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a122565..6fb4eab 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2272,7 +2272,7 @@ static void a0_portstatus(struct hfi1_pportdata *ppd,
 	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		int vfi = 0;
-		u64 max_vl_xmit_wait = 0, tmp;
+		u64 sum_vl_xmit_wait = 0;
 		u32 vl_all_mask = VL_MASK_ALL;
 		u64 rcv_data, rcv_bubble;
 
@@ -2302,12 +2302,18 @@ static void a0_portstatus(struct hfi1_pportdata *ppd,
 
 		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
 				 8 * sizeof(vl_all_mask)) {
-			tmp = read_port_cntr(ppd, C_TX_WAIT_VL,
-					     idx_from_vl(vl));
-			if (tmp > max_vl_xmit_wait)
-				max_vl_xmit_wait = tmp;
+			u64 tmp = sum_vl_xmit_wait +
+				  read_port_cntr(ppd, C_TX_WAIT_VL,
+						 idx_from_vl(vl));
+			if (tmp < sum_vl_xmit_wait) {
+				/* we wrapped */
+				sum_vl_xmit_wait = (u64)~0;
+				break;
+			}
+			sum_vl_xmit_wait = tmp;
 		}
-		rsp->port_xmit_wait = cpu_to_be64(max_vl_xmit_wait);
+		if (be64_to_cpu(rsp->port_xmit_wait) > sum_vl_xmit_wait)
+			rsp->port_xmit_wait = cpu_to_be64(sum_vl_xmit_wait);
 	}
 }
 
@@ -2513,13 +2519,14 @@ static u64 get_error_counter_summary(struct ib_device *ibdev, u8 port)
 	return error_counter_summary;
 }
 
-static void a0_datacounters(struct hfi1_devdata *dd, struct _port_dctrs *rsp,
+static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp,
 			    u32 vl_select_mask)
 {
-	if (!is_bx(dd)) {
+	if (!is_bx(ppd->dd)) {
 		unsigned long vl;
 		int vfi = 0;
 		u64 rcv_data, rcv_bubble, sum_vl_xmit_wait = 0;
+		u32 vl_all_mask = VL_MASK_ALL;
 
 		rcv_data = be64_to_cpu(rsp->port_rcv_data);
 		rcv_bubble = be64_to_cpu(rsp->port_rcv_bubble);
@@ -2545,10 +2552,11 @@ static void a0_datacounters(struct hfi1_devdata *dd, struct _port_dctrs *rsp,
 			vfi++;
 		}
 		vfi = 0;
-		for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
-				8 * sizeof(vl_select_mask)) {
+		for_each_set_bit(vl, (unsigned long *)&(vl_all_mask),
+				 8 * sizeof(vl_all_mask)) {
 			u64 tmp = sum_vl_xmit_wait +
-				be64_to_cpu(rsp->vls[vfi++].port_vl_xmit_wait);
+				  read_port_cntr(ppd, C_TX_WAIT_VL,
+						 idx_from_vl(vl));
 			if (tmp < sum_vl_xmit_wait) {
 				/* we wrapped */
 				sum_vl_xmit_wait = (u64) ~0;
@@ -2710,7 +2718,7 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 		vfi++;
 	}
 
-	a0_datacounters(dd, rsp, vl_select_mask);
+	a0_datacounters(ppd, rsp, vl_select_mask);
 
 	if (resp_len)
 		*resp_len += response_data_size;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
