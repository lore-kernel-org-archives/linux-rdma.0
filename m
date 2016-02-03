From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 51/54] staging/rdma/hfi1: Change for data type of port number
Date: Wed, 03 Feb 2016 14:37:50 -0800
Message-ID: <20160203223746.5923.71675.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This commit changes the data type for port_num in
pma_get_opa_porterrors() from unsigned long to u8.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 3df1c8e..97bdcb7 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2687,7 +2687,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 {
 	size_t response_data_size;
 	struct _port_ectrs *rsp;
-	unsigned long port_num;
+	u8 port_num;
 	struct opa_port_error_counters64_msg *req;
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u32 num_ports;
@@ -2728,7 +2728,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	port_num = find_first_bit((unsigned long *)&port_mask,
 					sizeof(port_mask));
 
-	if ((u8)port_num != port) {
+	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)pmp);
 	}
@@ -2739,7 +2739,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	ppd = ppd_from_ibp(ibp);
 
 	memset(rsp, 0, sizeof(*rsp));
-	rsp->port_number = (u8)port_num;
+	rsp->port_number = port_num;
 
 	rsp->port_rcv_constraint_errors =
 		cpu_to_be64(read_port_cntr(ppd, C_SW_RCV_CSTR_ERR,
@@ -2807,7 +2807,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u64 port_mask;
 	u32 num_ports;
-	unsigned long port_num;
+	u8 port_num;
 	u8 num_pslm;
 	u64 reg;
 
@@ -2840,7 +2840,7 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 	port_num = find_first_bit((unsigned long *)&port_mask,
 				  sizeof(port_mask));
 
-	if ((u8)port_num != port) {
+	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)pmp);
 	}
@@ -3048,7 +3048,7 @@ static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
 	u64 port_mask;
 	u32 num_ports;
-	unsigned long port_num;
+	u8 port_num;
 	u8 num_pslm;
 	u32 error_info_select;
 
@@ -3073,7 +3073,7 @@ static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
 	port_num = find_first_bit((unsigned long *)&port_mask,
 				  sizeof(port_mask));
 
-	if ((u8)port_num != port) {
+	if (port_num != port) {
 		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)pmp);
 	}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
