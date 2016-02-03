From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 53/54] staging/rdma/hfi1: Adding support for hfi counters
 via sysfs
Date: Wed, 03 Feb 2016 14:38:07 -0800
Message-ID: <20160203223804.5923.5830.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It enables access to counters in
/sys/class/infiniband/hfi1_0/ports/1/counters
by providing infrastructure when PMA queries occur. Counters symbol_error
and VL15_dropped are not supported in OPA, therefore, 0 will always be
returned. In addition, two common routines (pma_get_opa_port_dctrs,
pma_get_opa_port_ectrs) were created to query counters to avoid code
duplication.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/mad.c |  306 ++++++++++++++++++++++++++++++++-------
 1 files changed, 252 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index a315579..2fcc9f3 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -2524,6 +2524,27 @@ static void a0_datacounters(struct hfi1_pportdata *ppd, struct _port_dctrs *rsp,
 	}
 }
 
+static void pma_get_opa_port_dctrs(struct ib_device *ibdev,
+				   struct _port_dctrs *rsp)
+{
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+
+	rsp->port_xmit_data = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_FLITS,
+						CNTR_INVALID_VL));
+	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
+						CNTR_INVALID_VL));
+	rsp->port_xmit_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_PKTS,
+						CNTR_INVALID_VL));
+	rsp->port_rcv_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_PKTS,
+						CNTR_INVALID_VL));
+	rsp->port_multicast_xmit_pkts =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_XMIT_PKTS,
+					  CNTR_INVALID_VL));
+	rsp->port_multicast_rcv_pkts =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_RCV_PKTS,
+					  CNTR_INVALID_VL));
+}
+
 static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 			struct ib_device *ibdev, u8 port, u32 *resp_len)
 {
@@ -2592,34 +2613,14 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	 */
 	hfi1_read_link_quality(dd, &lq);
 	rsp->link_quality_indicator = cpu_to_be32((u32)lq);
+	pma_get_opa_port_dctrs(ibdev, rsp);
 
-	/* rsp->sw_port_congestion is 0 for HFIs */
-	/* rsp->port_xmit_time_cong is 0 for HFIs */
-	/* rsp->port_xmit_wasted_bw ??? */
-	/* rsp->port_xmit_wait_data ??? */
-	/* rsp->port_mark_fecn is 0 for HFIs */
-
-	rsp->port_xmit_data = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_FLITS,
-						CNTR_INVALID_VL));
-	rsp->port_rcv_data = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FLITS,
-						CNTR_INVALID_VL));
-	rsp->port_xmit_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_XMIT_PKTS,
-						CNTR_INVALID_VL));
-	rsp->port_rcv_pkts = cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_PKTS,
-						CNTR_INVALID_VL));
-	rsp->port_multicast_xmit_pkts =
-		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_XMIT_PKTS,
-						CNTR_INVALID_VL));
-	rsp->port_multicast_rcv_pkts =
-		cpu_to_be64(read_dev_cntr(dd, C_DC_MC_RCV_PKTS,
-						CNTR_INVALID_VL));
 	rsp->port_xmit_wait =
 		cpu_to_be64(read_port_cntr(ppd, C_TX_WAIT, CNTR_INVALID_VL));
 	rsp->port_rcv_fecn =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_FCN, CNTR_INVALID_VL));
 	rsp->port_rcv_becn =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_BCN, CNTR_INVALID_VL));
-
 	rsp->port_error_counter_summary =
 		cpu_to_be64(get_error_counter_summary(ibdev, port,
 						      res_lli, res_ler));
@@ -2682,6 +2683,81 @@ static int pma_get_opa_datacounters(struct opa_pma_mad *pmp,
 	return reply((struct ib_mad_hdr *)pmp);
 }
 
+static int pma_get_ib_portcounters_ext(struct ib_pma_mad *pmp,
+				       struct ib_device *ibdev, u8 port)
+{
+	struct ib_pma_portcounters_ext *p = (struct ib_pma_portcounters_ext *)
+						pmp->data;
+	struct _port_dctrs rsp;
+
+	if (pmp->mad_hdr.attr_mod != 0 || p->port_select != port) {
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
+		goto bail;
+	}
+
+	memset(&rsp, 0, sizeof(rsp));
+	pma_get_opa_port_dctrs(ibdev, &rsp);
+
+	p->port_xmit_data = rsp.port_xmit_data;
+	p->port_rcv_data = rsp.port_rcv_data;
+	p->port_xmit_packets = rsp.port_xmit_pkts;
+	p->port_rcv_packets = rsp.port_rcv_pkts;
+	p->port_unicast_xmit_packets = 0;
+	p->port_unicast_rcv_packets =  0;
+	p->port_multicast_xmit_packets = rsp.port_multicast_xmit_pkts;
+	p->port_multicast_rcv_packets = rsp.port_multicast_rcv_pkts;
+
+bail:
+	return reply((struct ib_mad_hdr *)pmp);
+}
+
+static void pma_get_opa_port_ectrs(struct ib_device *ibdev,
+				   struct _port_ectrs *rsp, u8 port)
+{
+	u64 tmp, tmp2;
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+
+	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
+	tmp2 = tmp + read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
+					CNTR_INVALID_VL);
+	if (tmp2 > (u32)UINT_MAX || tmp2 < tmp) {
+		/* overflow/wrapped */
+		rsp->link_error_recovery = cpu_to_be32(~0);
+	} else {
+		rsp->link_error_recovery = cpu_to_be32(tmp2);
+	}
+
+	rsp->link_downed = cpu_to_be32(read_port_cntr(ppd, C_SW_LINK_DOWN,
+						CNTR_INVALID_VL));
+	rsp->port_rcv_errors =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_RCV_ERR, CNTR_INVALID_VL));
+	rsp->port_rcv_remote_physical_errors =
+		cpu_to_be64(read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
+					  CNTR_INVALID_VL));
+	rsp->port_rcv_switch_relay_errors = 0;
+	rsp->port_xmit_discards =
+		cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD,
+					   CNTR_INVALID_VL));
+	rsp->port_xmit_constraint_errors =
+		cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_CSTR_ERR,
+					   CNTR_INVALID_VL));
+	rsp->port_rcv_constraint_errors =
+		cpu_to_be64(read_port_cntr(ppd, C_SW_RCV_CSTR_ERR,
+					   CNTR_INVALID_VL));
+	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
+	tmp2 = tmp + read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
+	if (tmp2 < tmp) {
+		/* overflow/wrapped */
+		rsp->local_link_integrity_errors = cpu_to_be64(~0);
+	} else {
+		rsp->local_link_integrity_errors = cpu_to_be64(tmp2);
+	}
+	rsp->excessive_buffer_overruns =
+		cpu_to_be64(read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL));
+}
+
 static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 			struct ib_device *ibdev, u8 port, u32 *resp_len)
 {
@@ -2697,7 +2773,7 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	struct hfi1_pportdata *ppd;
 	struct _vls_ectrs *vlinfo;
 	unsigned long vl;
-	u64 port_mask, tmp, tmp2;
+	u64 port_mask, tmp;
 	u32 vl_select_mask;
 	int vfi;
 
@@ -2741,44 +2817,16 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	memset(rsp, 0, sizeof(*rsp));
 	rsp->port_number = port_num;
 
-	rsp->port_rcv_constraint_errors =
-		cpu_to_be64(read_port_cntr(ppd, C_SW_RCV_CSTR_ERR,
-					   CNTR_INVALID_VL));
-	/* port_rcv_switch_relay_errors is 0 for HFIs */
-	rsp->port_xmit_discards =
-		cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_DSCD,
-						CNTR_INVALID_VL));
+	pma_get_opa_port_ectrs(ibdev, rsp, port_num);
+
 	rsp->port_rcv_remote_physical_errors =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_RMT_PHY_ERR,
-						CNTR_INVALID_VL));
-	tmp = read_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL);
-	tmp2 = tmp + read_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL);
-	if (tmp2 < tmp) {
-		/* overflow/wrapped */
-		rsp->local_link_integrity_errors = cpu_to_be64(~0);
-	} else {
-		rsp->local_link_integrity_errors = cpu_to_be64(tmp2);
-	}
-	tmp = read_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL);
-	tmp2 = tmp + read_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
-					CNTR_INVALID_VL);
-	if (tmp2 > (u32)UINT_MAX || tmp2 < tmp) {
-		/* overflow/wrapped */
-		rsp->link_error_recovery = cpu_to_be32(~0);
-	} else {
-		rsp->link_error_recovery = cpu_to_be32(tmp2);
-	}
-	rsp->port_xmit_constraint_errors =
-		cpu_to_be64(read_port_cntr(ppd, C_SW_XMIT_CSTR_ERR,
-					   CNTR_INVALID_VL));
-	rsp->excessive_buffer_overruns =
-		cpu_to_be64(read_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL));
+					  CNTR_INVALID_VL));
 	rsp->fm_config_errors =
 		cpu_to_be64(read_dev_cntr(dd, C_DC_FM_CFG_ERR,
 						CNTR_INVALID_VL));
-	rsp->link_downed = cpu_to_be32(read_port_cntr(ppd, C_SW_LINK_DOWN,
-						CNTR_INVALID_VL));
 	tmp = read_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL);
+
 	rsp->uncorrectable_errors = tmp < 0x100 ? (tmp & 0xff) : 0xff;
 
 	vlinfo = (struct _vls_ectrs *)&(rsp->vls[0]);
@@ -2798,6 +2846,91 @@ static int pma_get_opa_porterrors(struct opa_pma_mad *pmp,
 	return reply((struct ib_mad_hdr *)pmp);
 }
 
+static int pma_get_ib_portcounters(struct ib_pma_mad *pmp,
+				   struct ib_device *ibdev, u8 port)
+{
+	struct ib_pma_portcounters *p = (struct ib_pma_portcounters *)
+		pmp->data;
+	struct _port_ectrs rsp;
+	u64 temp_link_overrun_errors;
+	u64 temp_64;
+	u32 temp_32;
+
+	memset(&rsp, 0, sizeof(rsp));
+	pma_get_opa_port_ectrs(ibdev, &rsp, port);
+
+	if (pmp->mad_hdr.attr_mod != 0 || p->port_select != port) {
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
+		goto bail;
+	}
+
+	p->symbol_error_counter = 0; /* N/A for OPA */
+
+	temp_32 = be32_to_cpu(rsp.link_error_recovery);
+	if (temp_32 > 0xFFUL)
+		p->link_error_recovery_counter = 0xFF;
+	else
+		p->link_error_recovery_counter = (u8)temp_32;
+
+	temp_32 = be32_to_cpu(rsp.link_downed);
+	if (temp_32 > 0xFFUL)
+		p->link_downed_counter = 0xFF;
+	else
+		p->link_downed_counter = (u8)temp_32;
+
+	temp_64 = be64_to_cpu(rsp.port_rcv_errors);
+	if (temp_64 > 0xFFFFUL)
+		p->port_rcv_errors = cpu_to_be16(0xFFFF);
+	else
+		p->port_rcv_errors = cpu_to_be16((u16)temp_64);
+
+	temp_64 = be64_to_cpu(rsp.port_rcv_remote_physical_errors);
+	if (temp_64 > 0xFFFFUL)
+		p->port_rcv_remphys_errors = cpu_to_be16(0xFFFF);
+	else
+		p->port_rcv_remphys_errors = cpu_to_be16((u16)temp_64);
+
+	temp_64 = be64_to_cpu(rsp.port_rcv_switch_relay_errors);
+	p->port_rcv_switch_relay_errors = cpu_to_be16((u16)temp_64);
+
+	temp_64 = be64_to_cpu(rsp.port_xmit_discards);
+	if (temp_64 > 0xFFFFUL)
+		p->port_xmit_discards = cpu_to_be16(0xFFFF);
+	else
+		p->port_xmit_discards = cpu_to_be16((u16)temp_64);
+
+	temp_64 = be64_to_cpu(rsp.port_xmit_constraint_errors);
+	if (temp_64 > 0xFFUL)
+		p->port_xmit_constraint_errors = 0xFF;
+	else
+		p->port_xmit_constraint_errors = (u8)temp_64;
+
+	temp_64 = be64_to_cpu(rsp.port_rcv_constraint_errors);
+	if (temp_64 > 0xFFUL)
+		p->port_rcv_constraint_errors = 0xFFUL;
+	else
+		p->port_rcv_constraint_errors = (u8)temp_64;
+
+	/* LocalLink: 7:4, BufferOverrun: 3:0 */
+	temp_64 = be64_to_cpu(rsp.local_link_integrity_errors);
+	if (temp_64 > 0xFUL)
+		temp_64 = 0xFUL;
+
+	temp_link_overrun_errors = temp_64 << 4;
+
+	temp_64 = be64_to_cpu(rsp.excessive_buffer_overruns);
+	if (temp_64 > 0xFUL)
+		temp_64 = 0xFUL;
+	temp_link_overrun_errors |= temp_64;
+
+	p->link_overrun_errors = (u8)temp_link_overrun_errors;
+
+	p->vl15_dropped = 0; /* N/A for OPA */
+
+bail:
+	return reply((struct ib_mad_hdr *)pmp);
+}
+
 static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 			struct ib_device *ibdev, u8 port, u32 *resp_len)
 {
@@ -3964,6 +4097,68 @@ static int process_subn(struct ib_device *ibdev, int mad_flags,
 	return ret;
 }
 
+static int process_perf(struct ib_device *ibdev, u8 port,
+			const struct ib_mad *in_mad,
+			struct ib_mad *out_mad)
+{
+	struct ib_pma_mad *pmp = (struct ib_pma_mad *)out_mad;
+	struct ib_class_port_info *cpi = (struct ib_class_port_info *)
+						&pmp->data;
+	int ret = IB_MAD_RESULT_FAILURE;
+
+	*out_mad = *in_mad;
+	if (pmp->mad_hdr.class_version != 1) {
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_VERSION;
+		ret = reply((struct ib_mad_hdr *)pmp);
+		return ret;
+	}
+
+	switch (pmp->mad_hdr.method) {
+	case IB_MGMT_METHOD_GET:
+		switch (pmp->mad_hdr.attr_id) {
+		case IB_PMA_PORT_COUNTERS:
+			ret = pma_get_ib_portcounters(pmp, ibdev, port);
+			break;
+		case IB_PMA_PORT_COUNTERS_EXT:
+			ret = pma_get_ib_portcounters_ext(pmp, ibdev, port);
+			break;
+		case IB_PMA_CLASS_PORT_INFO:
+			cpi->capability_mask = IB_PMA_CLASS_CAP_EXT_WIDTH;
+			ret = reply((struct ib_mad_hdr *)pmp);
+			break;
+		default:
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
+			ret = reply((struct ib_mad_hdr *)pmp);
+			break;
+		}
+		break;
+
+	case IB_MGMT_METHOD_SET:
+		if (pmp->mad_hdr.attr_id) {
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
+			ret = reply((struct ib_mad_hdr *)pmp);
+		}
+		break;
+
+	case IB_MGMT_METHOD_TRAP:
+	case IB_MGMT_METHOD_GET_RESP:
+		/*
+		 * The ib_mad module will call us to process responses
+		 * before checking for other consumers.
+		 * Just tell the caller to process it normally.
+		 */
+		ret = IB_MAD_RESULT_SUCCESS;
+		break;
+
+	default:
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_METHOD;
+		ret = reply((struct ib_mad_hdr *)pmp);
+		break;
+	}
+
+	return ret;
+}
+
 static int process_perf_opa(struct ib_device *ibdev, u8 port,
 			    const struct opa_mad *in_mad,
 			    struct opa_mad *out_mad, u32 *resp_len)
@@ -4107,6 +4302,9 @@ static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
 		ret = process_subn(ibdev, mad_flags, port, in_mad, out_mad);
 		break;
+	case IB_MGMT_CLASS_PERF_MGMT:
+		ret = process_perf(ibdev, port, in_mad, out_mad);
+		break;
 	default:
 		ret = IB_MAD_RESULT_SUCCESS;
 		break;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
