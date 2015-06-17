From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 24/49] IB/hfi1: add OPA mad handling part2
Date: Wed, 17 Jun 2015 08:30:45 -0400
Message-ID: <20150617123044.8744.25478.stgit@phlsvslse11.ph.intel.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Friedley <andrew.friedley-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Arthur Kepner <arthur.kepner-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Caz Yokoyama <caz.yokoyama-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Gregor <john.a.gregor-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kevin Pine <kevin.pine-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kyle Liddell <kyle.liddell-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ravi Krishnaswamy <ravi.krishnaswamy-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sanath Kumar <sanath.s.kumar-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sudeep Dutt <sudeep.dutt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vlad Danushevsky <vladimir.danusevsky-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mad.c | 1343 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 1343 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 77bd455..28bef38 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -2742,3 +2742,1346 @@ static int pma_get_opa_errorinfo(struct opa_pma_mad *pmp,
 
 		tmp &=  RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SC_SMASK;
 		tmp <<= 2;
+		rsp->excessive_buffer_overrun_ei.status_and_sc = tmp;
+		/* set the status bit */
+		rsp->excessive_buffer_overrun_ei.status_and_sc |= 0x80;
+	}
+
+	rsp->port_xmit_constraint_ei.status =
+		dd->err_info_xmit_constraint.status;
+	rsp->port_xmit_constraint_ei.pkey =
+		cpu_to_be16(dd->err_info_xmit_constraint.pkey);
+	rsp->port_xmit_constraint_ei.slid =
+		cpu_to_be32(dd->err_info_xmit_constraint.slid);
+
+	rsp->port_rcv_constraint_ei.status =
+		dd->err_info_rcv_constraint.status;
+	rsp->port_rcv_constraint_ei.pkey =
+		cpu_to_be16(dd->err_info_rcv_constraint.pkey);
+	rsp->port_rcv_constraint_ei.slid =
+		cpu_to_be32(dd->err_info_rcv_constraint.slid);
+
+	/* UncorrectableErrorInfo */
+	rsp->uncorrectable_ei.status_and_code = dd->err_info_uncorrectable;
+
+	/* FMConfigErrorInfo */
+	rsp->fm_config_ei.status_and_code = dd->err_info_fmconfig;
+
+	return reply((struct ib_mad_hdr *)pmp);
+}
+
+static int pma_set_opa_portstatus(struct opa_pma_mad *pmp,
+				  struct ib_device *ibdev, u8 port)
+{
+	struct opa_clear_port_status *req =
+		(struct opa_clear_port_status *)pmp->data;
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	u32 nports = be32_to_cpu(pmp->mad_hdr.attr_mod) >> 24;
+	u64 portn = be64_to_cpu(req->port_select_mask[3]);
+	u32 counter_select = be32_to_cpu(req->counter_select_mask);
+	u32 vl_select_mask = VL_MASK_ALL; /* clear all per-vl cnts */
+	unsigned long vl;
+
+	if ((nports != 1) || (portn != 1 << port)) {
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)pmp);
+	}
+	/*
+	 * only counters returned by pma_get_opa_portstatus() are
+	 * handled, so when pma_get_opa_portstatus() gets a fix,
+	 * the corresponding change should be made here as well.
+	 */
+
+
+	if (counter_select & CS_PORT_XMIT_DATA)
+		write_dev_cntr(dd, C_DC_XMIT_FLITS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_RCV_DATA)
+		write_dev_cntr(dd, C_DC_RCV_FLITS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_XMIT_PKTS)
+		write_dev_cntr(dd, C_DC_XMIT_PKTS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_RCV_PKTS)
+		write_dev_cntr(dd, C_DC_RCV_PKTS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_MCAST_XMIT_PKTS)
+		write_dev_cntr(dd, C_DC_MC_XMIT_PKTS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_MCAST_RCV_PKTS)
+		write_dev_cntr(dd, C_DC_MC_RCV_PKTS, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_XMIT_WAIT)
+		write_port_cntr(ppd, C_TX_WAIT, CNTR_INVALID_VL, 0);
+
+	/* ignore cs_sw_portCongestion for HFIs */
+
+	if (counter_select & CS_PORT_RCV_FECN)
+		write_dev_cntr(dd, C_DC_RCV_FCN, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_RCV_BECN)
+		write_dev_cntr(dd, C_DC_RCV_BCN, CNTR_INVALID_VL, 0);
+
+	/* ignore cs_port_xmit_time_cong for HFIs */
+	/* ignore cs_port_xmit_wasted_bw for now */
+	/* ignore cs_port_xmit_wait_data for now */
+	if (counter_select & CS_PORT_RCV_BUBBLE)
+		write_dev_cntr(dd, C_DC_RCV_BBL, CNTR_INVALID_VL, 0);
+
+	/* Only applicable for switch */
+	/*if (counter_select & CS_PORT_MARK_FECN)
+		write_csr(dd, DCC_PRF_PORT_MARK_FECN_CNT, 0);*/
+
+	if (counter_select & CS_PORT_RCV_CONSTRAINT_ERRORS)
+		write_port_cntr(ppd, C_SW_RCV_CSTR_ERR, CNTR_INVALID_VL, 0);
+
+	/* ignore cs_port_rcv_switch_relay_errors for HFIs */
+	if (counter_select & CS_PORT_XMIT_DISCARDS)
+		write_port_cntr(ppd, C_SW_XMIT_DSCD, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_XMIT_CONSTRAINT_ERRORS)
+		write_port_cntr(ppd, C_SW_XMIT_CSTR_ERR, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_PORT_RCV_REMOTE_PHYSICAL_ERRORS)
+		write_dev_cntr(dd, C_DC_RMT_PHY_ERR, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_LOCAL_LINK_INTEGRITY_ERRORS) {
+		write_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL, 0);
+		write_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL, 0);
+	}
+
+	if (counter_select & CS_LINK_ERROR_RECOVERY) {
+		write_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL, 0);
+		write_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT,
+						CNTR_INVALID_VL, 0);
+	}
+
+	if (counter_select & CS_PORT_RCV_ERRORS)
+		write_dev_cntr(dd, C_DC_RCV_ERR, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_EXCESSIVE_BUFFER_OVERRUNS) {
+		write_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL, 0);
+		dd->rcv_ovfl_cnt = 0;
+	}
+
+	if (counter_select & CS_FM_CONFIG_ERRORS)
+		write_dev_cntr(dd, C_DC_FM_CFG_ERR, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_LINK_DOWNED)
+		write_port_cntr(ppd, C_SW_LINK_DOWN, CNTR_INVALID_VL, 0);
+
+	if (counter_select & CS_UNCORRECTABLE_ERRORS)
+		write_dev_cntr(dd, C_DC_UNC_ERR, CNTR_INVALID_VL, 0);
+
+	for_each_set_bit(vl, (unsigned long *)&(vl_select_mask),
+			 8 * sizeof(vl_select_mask)) {
+
+		if (counter_select & CS_PORT_XMIT_DATA)
+			write_port_cntr(ppd, C_TX_FLIT_VL, idx_from_vl(vl), 0);
+
+		if (counter_select & CS_PORT_RCV_DATA)
+			write_dev_cntr(dd, C_DC_RX_FLIT_VL, idx_from_vl(vl), 0);
+
+		if (counter_select & CS_PORT_XMIT_PKTS)
+			write_port_cntr(ppd, C_TX_PKT_VL, idx_from_vl(vl), 0);
+
+		if (counter_select & CS_PORT_RCV_PKTS)
+			write_dev_cntr(dd, C_DC_RX_PKT_VL, idx_from_vl(vl), 0);
+
+		if (counter_select & CS_PORT_XMIT_WAIT)
+			write_port_cntr(ppd, C_TX_WAIT_VL, idx_from_vl(vl), 0);
+
+		/* sw_port_vl_congestion is 0 for HFIs */
+		if (counter_select & CS_PORT_RCV_FECN)
+			write_dev_cntr(dd, C_DC_RCV_FCN_VL, idx_from_vl(vl), 0);
+
+		if (counter_select & CS_PORT_RCV_BECN)
+			write_dev_cntr(dd, C_DC_RCV_BCN_VL, idx_from_vl(vl), 0);
+
+		/* port_vl_xmit_time_cong is 0 for HFIs */
+		/* port_vl_xmit_wasted_bw ??? */
+		/* port_vl_xmit_wait_data - TXE (table 13-9 HFI spec) ??? */
+		if (counter_select & CS_PORT_RCV_BUBBLE)
+			write_dev_cntr(dd, C_DC_RCV_BBL_VL, idx_from_vl(vl), 0);
+
+		/*if (counter_select & CS_PORT_MARK_FECN)
+		     write_csr(dd, DCC_PRF_PORT_VL_MARK_FECN_CNT + offset, 0);
+		*/
+		/* port_vl_xmit_discards ??? */
+	}
+
+	return reply((struct ib_mad_hdr *)pmp);
+}
+
+static int pma_set_opa_errorinfo(struct opa_pma_mad *pmp,
+				 struct ib_device *ibdev, u8 port)
+{
+	struct _port_ei *rsp;
+	struct opa_port_error_info_msg *req;
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	u64 port_mask;
+	u32 num_ports;
+	unsigned long port_num;
+	u8 num_pslm;
+	u32 error_info_select;
+
+	req = (struct opa_port_error_info_msg *)pmp->data;
+	rsp = (struct _port_ei *)&(req->port[0]);
+
+	num_ports = OPA_AM_NPORT(be32_to_cpu(pmp->mad_hdr.attr_mod));
+	num_pslm = hweight64(be64_to_cpu(req->port_select_mask[3]));
+
+	memset(rsp, 0, sizeof(*rsp));
+
+	if (num_ports != 1 || num_ports != num_pslm) {
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)pmp);
+	}
+
+	/*
+	 * The bit set in the mask needs to be consistent with the port
+	 * the request came in on.
+	 */
+	port_mask = be64_to_cpu(req->port_select_mask[3]);
+	port_num = find_first_bit((unsigned long *)&port_mask,
+				  sizeof(port_mask));
+
+	if ((u8)port_num != port) {
+		pmp->mad_hdr.status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)pmp);
+	}
+
+	error_info_select = be32_to_cpu(req->error_info_select_mask);
+
+	/* PortRcvErrorInfo */
+	if (error_info_select & ES_PORT_RCV_ERROR_INFO)
+		/* turn off status bit */
+		dd->err_info_rcvport.status_and_code &= ~OPA_EI_STATUS_SMASK;
+
+	/* ExcessiverBufferOverrunInfo */
+	if (error_info_select & ES_EXCESSIVE_BUFFER_OVERRUN_INFO)
+		/* status bit is essentially kept in the h/w - bit 5 of
+		 * RCV_ERR_INFO */
+		write_csr(dd, RCV_ERR_INFO,
+			  RCV_ERR_INFO_RCV_EXCESS_BUFFER_OVERRUN_SMASK);
+
+	if (error_info_select & ES_PORT_XMIT_CONSTRAINT_ERROR_INFO)
+		dd->err_info_xmit_constraint.status &= ~OPA_EI_STATUS_SMASK;
+
+	if (error_info_select & ES_PORT_RCV_CONSTRAINT_ERROR_INFO)
+		dd->err_info_rcv_constraint.status &= ~OPA_EI_STATUS_SMASK;
+
+	/* UncorrectableErrorInfo */
+	if (error_info_select & ES_UNCORRECTABLE_ERROR_INFO)
+		/* turn off status bit */
+		dd->err_info_uncorrectable &= ~OPA_EI_STATUS_SMASK;
+
+	/* FMConfigErrorInfo */
+	if (error_info_select & ES_FM_CONFIG_ERROR_INFO)
+		/* turn off status bit */
+		dd->err_info_fmconfig &= ~OPA_EI_STATUS_SMASK;
+
+	return reply((struct ib_mad_hdr *)pmp);
+}
+
+struct opa_congestion_info_attr {
+	__be16 congestion_info;
+	u8 control_table_cap;	/* Multiple of 64 entry unit CCTs */
+	u8 congestion_log_length;
+} __packed;
+
+static int __subn_get_opa_cong_info(struct opa_smp *smp, u32 am, u8 *data,
+				    struct ib_device *ibdev, u8 port,
+				    u32 *resp_len)
+{
+	struct opa_congestion_info_attr *p =
+		(struct opa_congestion_info_attr *)data;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+
+	p->congestion_info = 0;
+	p->control_table_cap = ppd->cc_max_table_entries;
+	p->congestion_log_length = OPA_CONG_LOG_ELEMS;
+
+	if (resp_len)
+		*resp_len += sizeof(*p);
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+static int __subn_get_opa_cong_setting(struct opa_smp *smp, u32 am,
+					     u8 *data,
+					     struct ib_device *ibdev,
+					     u8 port, u32 *resp_len)
+{
+	int i;
+	struct opa_congestion_setting_attr *p =
+		(struct opa_congestion_setting_attr *) data;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct opa_congestion_setting_entry_shadow *entries;
+	struct cc_state *cc_state;
+
+	rcu_read_lock();
+
+	cc_state = get_cc_state(ppd);
+
+	if (cc_state == NULL) {
+		rcu_read_unlock();
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	entries = cc_state->cong_setting.entries;
+	p->port_control = cpu_to_be16(cc_state->cong_setting.port_control);
+	p->control_map = cpu_to_be32(cc_state->cong_setting.control_map);
+	for (i = 0; i < OPA_MAX_SLS; i++) {
+		p->entries[i].ccti_increase = entries[i].ccti_increase;
+		p->entries[i].ccti_timer = cpu_to_be16(entries[i].ccti_timer);
+		p->entries[i].trigger_threshold =
+			entries[i].trigger_threshold;
+		p->entries[i].ccti_min = entries[i].ccti_min;
+	}
+
+	rcu_read_unlock();
+
+	if (resp_len)
+		*resp_len += sizeof(*p);
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+static int __subn_set_opa_cong_setting(struct opa_smp *smp, u32 am, u8 *data,
+				       struct ib_device *ibdev, u8 port,
+				       u32 *resp_len)
+{
+	struct opa_congestion_setting_attr *p =
+		(struct opa_congestion_setting_attr *) data;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct opa_congestion_setting_entry_shadow *entries;
+	int i;
+
+	ppd->cc_sl_control_map = be32_to_cpu(p->control_map);
+
+	entries = ppd->congestion_entries;
+	for (i = 0; i < OPA_MAX_SLS; i++) {
+		entries[i].ccti_increase = p->entries[i].ccti_increase;
+		entries[i].ccti_timer = be16_to_cpu(p->entries[i].ccti_timer);
+		entries[i].trigger_threshold =
+			p->entries[i].trigger_threshold;
+		entries[i].ccti_min = p->entries[i].ccti_min;
+	}
+
+	return __subn_get_opa_cong_setting(smp, am, data, ibdev, port,
+					   resp_len);
+}
+
+static int __subn_get_opa_hfi1_cong_log(struct opa_smp *smp, u32 am,
+					u8 *data, struct ib_device *ibdev,
+					u8 port, u32 *resp_len)
+{
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	struct opa_hfi1_cong_log *cong_log = (struct opa_hfi1_cong_log *)data;
+	s64 ts;
+	int i;
+
+	if (am != 0) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	spin_lock(&ppd->cc_log_lock);
+
+	cong_log->log_type = OPA_CC_LOG_TYPE_HFI;
+	cong_log->congestion_flags = 0;
+	cong_log->threshold_event_counter =
+		cpu_to_be16(ppd->threshold_event_counter);
+	memcpy(cong_log->threshold_cong_event_map,
+	       ppd->threshold_cong_event_map,
+	       sizeof(cong_log->threshold_cong_event_map));
+	/* keep timestamp in units of 1.024 usec */
+	ts = ktime_to_ns(ktime_get()) / 1024;
+	cong_log->current_time_stamp = cpu_to_be32(ts);
+	for (i = 0; i < OPA_CONG_LOG_ELEMS; i++) {
+		struct opa_hfi1_cong_log_event_internal *cce =
+			&ppd->cc_events[ppd->cc_mad_idx++];
+		if (ppd->cc_mad_idx == OPA_CONG_LOG_ELEMS)
+			ppd->cc_mad_idx = 0;
+		/*
+		 * Entries which are older than twice the time
+		 * required to wrap the counter are supposed to
+		 * be zeroed (CA10-49 IBTA, release 1.2.1, V1).
+		 */
+		if ((u64)(ts - cce->timestamp) > (2 * UINT_MAX))
+			continue;
+		memcpy(cong_log->events[i].local_qp_cn_entry, &cce->lqpn, 3);
+		memcpy(cong_log->events[i].remote_qp_number_cn_entry,
+			&cce->rqpn, 3);
+		cong_log->events[i].sl_svc_type_cn_entry =
+			((cce->sl & 0x1f) << 3) | (cce->svc_type & 0x7);
+		cong_log->events[i].remote_lid_cn_entry =
+			cpu_to_be32(cce->rlid);
+		cong_log->events[i].timestamp_cn_entry =
+			cpu_to_be32(cce->timestamp);
+	}
+
+	/*
+	 * Reset threshold_cong_event_map, and threshold_event_counter
+	 * to 0 when log is read.
+	 */
+	memset(ppd->threshold_cong_event_map, 0x0,
+	       sizeof(ppd->threshold_cong_event_map));
+	ppd->threshold_event_counter = 0;
+
+	spin_unlock(&ppd->cc_log_lock);
+
+	if (resp_len)
+		*resp_len += sizeof(struct opa_hfi1_cong_log);
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
+				   struct ib_device *ibdev, u8 port,
+				   u32 *resp_len)
+{
+	struct ib_cc_table_attr *cc_table_attr =
+		(struct ib_cc_table_attr *) data;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	u32 start_block = OPA_AM_START_BLK(am);
+	u32 n_blocks = OPA_AM_NBLK(am);
+	struct ib_cc_table_entry_shadow *entries;
+	int i, j;
+	u32 sentry, eentry;
+	struct cc_state *cc_state;
+
+	/* sanity check n_blocks, start_block */
+	if (n_blocks == 0 ||
+	    start_block + n_blocks > ppd->cc_max_table_entries) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	rcu_read_lock();
+
+	cc_state = get_cc_state(ppd);
+
+	if (cc_state == NULL) {
+		rcu_read_unlock();
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	sentry = start_block * IB_CCT_ENTRIES;
+	eentry = sentry + (IB_CCT_ENTRIES * n_blocks);
+
+	cc_table_attr->ccti_limit = cpu_to_be16(cc_state->cct.ccti_limit);
+
+	entries = cc_state->cct.entries;
+
+	/* return n_blocks, though the last block may not be full */
+	for (j = 0, i = sentry; i < eentry; j++, i++)
+		cc_table_attr->ccti_entries[j].entry =
+			cpu_to_be16(entries[i].entry);
+
+	rcu_read_unlock();
+
+	if (resp_len)
+		*resp_len += sizeof(u16)*(IB_CCT_ENTRIES * n_blocks + 1);
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+void cc_state_reclaim(struct rcu_head *rcu)
+{
+	struct cc_state *cc_state = container_of(rcu, struct cc_state, rcu);
+
+	kfree(cc_state);
+}
+
+static int __subn_set_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
+				   struct ib_device *ibdev, u8 port,
+				   u32 *resp_len)
+{
+	struct ib_cc_table_attr *p = (struct ib_cc_table_attr *) data;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	u32 start_block = OPA_AM_START_BLK(am);
+	u32 n_blocks = OPA_AM_NBLK(am);
+	struct ib_cc_table_entry_shadow *entries;
+	int i, j;
+	u32 sentry, eentry;
+	u16 ccti_limit;
+	struct cc_state *old_cc_state, *new_cc_state;
+
+	/* sanity check n_blocks, start_block */
+	if (n_blocks == 0 ||
+	    start_block + n_blocks > ppd->cc_max_table_entries) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	sentry = start_block * IB_CCT_ENTRIES;
+	eentry = sentry + ((n_blocks - 1) * IB_CCT_ENTRIES) +
+		 (be16_to_cpu(p->ccti_limit)) % IB_CCT_ENTRIES + 1;
+
+	/* sanity check ccti_limit */
+	ccti_limit = be16_to_cpu(p->ccti_limit);
+	if (ccti_limit + 1 > eentry) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	new_cc_state = kzalloc(sizeof(*new_cc_state), GFP_KERNEL);
+	if (new_cc_state == NULL)
+		goto getit;
+
+	spin_lock(&ppd->cc_state_lock);
+
+	old_cc_state = get_cc_state(ppd);
+
+	if (old_cc_state == NULL) {
+		spin_unlock(&ppd->cc_state_lock);
+		kfree(new_cc_state);
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	*new_cc_state = *old_cc_state;
+
+	new_cc_state->cct.ccti_limit = ccti_limit;
+
+	entries = ppd->ccti_entries;
+	ppd->total_cct_entry = ccti_limit + 1;
+
+	for (j = 0, i = sentry; i < eentry; j++, i++)
+		entries[i].entry = be16_to_cpu(p->ccti_entries[j].entry);
+
+	memcpy(new_cc_state->cct.entries, entries,
+	       eentry * sizeof(struct ib_cc_table_entry));
+
+	new_cc_state->cong_setting.port_control = IB_CC_CCS_PC_SL_BASED;
+	new_cc_state->cong_setting.control_map = ppd->cc_sl_control_map;
+	memcpy(new_cc_state->cong_setting.entries, ppd->congestion_entries,
+	       OPA_MAX_SLS * sizeof(struct opa_congestion_setting_entry));
+
+	rcu_assign_pointer(ppd->cc_state, new_cc_state);
+
+	spin_unlock(&ppd->cc_state_lock);
+
+	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
+
+getit:
+	return __subn_get_opa_cc_table(smp, am, data, ibdev, port, resp_len);
+}
+
+struct opa_led_info {
+	__be32 rsvd_led_mask;
+	__be32 rsvd;
+};
+
+#define OPA_LED_SHIFT	31
+#define OPA_LED_MASK	(1 << OPA_LED_SHIFT)
+
+static int __subn_get_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
+				   struct ib_device *ibdev, u8 port,
+				   u32 *resp_len)
+{
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct opa_led_info *p = (struct opa_led_info *) data;
+	u32 nport = OPA_AM_NPORT(am);
+	u64 reg;
+
+	if (port != 1 || nport != 1 || OPA_AM_PORTNUM(am)) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	reg = read_csr(dd, DCC_CFG_LED_CNTRL);
+	if ((reg & DCC_CFG_LED_CNTRL_LED_CNTRL_SMASK) &&
+		((reg & DCC_CFG_LED_CNTRL_LED_SW_BLINK_RATE_SMASK) == 0xf))
+			p->rsvd_led_mask = cpu_to_be32(OPA_LED_MASK);
+
+	if (resp_len)
+		*resp_len += sizeof(struct opa_led_info);
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+static int __subn_set_opa_led_info(struct opa_smp *smp, u32 am, u8 *data,
+				   struct ib_device *ibdev, u8 port,
+				   u32 *resp_len)
+{
+	struct hfi1_devdata *dd = dd_from_ibdev(ibdev);
+	struct opa_led_info *p = (struct opa_led_info *) data;
+	u32 nport = OPA_AM_NPORT(am);
+	int on = !!(be32_to_cpu(p->rsvd_led_mask) & OPA_LED_MASK);
+
+	if (port != 1 || nport != 1 || OPA_AM_PORTNUM(am)) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	setextled(dd, on);
+
+	return __subn_get_opa_led_info(smp, am, data, ibdev, port, resp_len);
+}
+
+static int subn_get_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
+			    u8 *data, struct ib_device *ibdev, u8 port,
+			    u32 *resp_len)
+{
+	int ret;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+
+	switch (attr_id) {
+	case IB_SMP_ATTR_NODE_DESC:
+		ret = __subn_get_opa_nodedesc(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_NODE_INFO:
+		ret = __subn_get_opa_nodeinfo(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_PORT_INFO:
+		ret = __subn_get_opa_portinfo(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_PKEY_TABLE:
+		ret = __subn_get_opa_pkeytable(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_SL_TO_SC_MAP:
+		ret = __subn_get_opa_sl_to_sc(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_SL_MAP:
+		ret = __subn_get_opa_sc_to_sl(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_VLT_MAP:
+		ret = __subn_get_opa_sc_to_vlt(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_VLNT_MAP:
+		ret = __subn_get_opa_sc_to_vlnt(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_PORT_STATE_INFO:
+		ret = __subn_get_opa_psi(smp, am, data, ibdev, port,
+					 resp_len);
+		break;
+	case OPA_ATTRIB_ID_BUFFER_CONTROL_TABLE:
+		ret = __subn_get_opa_bct(smp, am, data, ibdev, port,
+					 resp_len);
+		break;
+	case OPA_ATTRIB_ID_CABLE_INFO:
+		ret = __subn_get_opa_cable_info(smp, am, data, ibdev, port,
+						resp_len);
+		break;
+	case IB_SMP_ATTR_VL_ARB_TABLE:
+		ret = __subn_get_opa_vl_arb(smp, am, data, ibdev, port,
+					    resp_len);
+		break;
+	case OPA_ATTRIB_ID_CONGESTION_INFO:
+		ret = __subn_get_opa_cong_info(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_HFI_CONGESTION_SETTING:
+		ret = __subn_get_opa_cong_setting(smp, am, data, ibdev,
+						  port, resp_len);
+		break;
+	case OPA_ATTRIB_ID_HFI_CONGESTION_LOG:
+		ret = __subn_get_opa_hfi1_cong_log(smp, am, data, ibdev,
+						   port, resp_len);
+		break;
+	case OPA_ATTRIB_ID_CONGESTION_CONTROL_TABLE:
+		ret = __subn_get_opa_cc_table(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_LED_INFO:
+		ret = __subn_get_opa_led_info(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_SM_INFO:
+		if (ibp->port_cap_flags & IB_PORT_SM_DISABLED)
+			return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+		if (ibp->port_cap_flags & IB_PORT_SM)
+			return IB_MAD_RESULT_SUCCESS;
+		/* FALLTHROUGH */
+	default:
+		smp->status |= IB_SMP_UNSUP_METH_ATTR;
+		ret = reply((struct ib_mad_hdr *)smp);
+		break;
+	}
+	return ret;
+}
+
+static int subn_set_opa_sma(__be16 attr_id, struct opa_smp *smp, u32 am,
+			    u8 *data, struct ib_device *ibdev, u8 port,
+			    u32 *resp_len)
+{
+	int ret;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+
+	switch (attr_id) {
+	case IB_SMP_ATTR_PORT_INFO:
+		ret = __subn_set_opa_portinfo(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_PKEY_TABLE:
+		ret = __subn_set_opa_pkeytable(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_SL_TO_SC_MAP:
+		ret = __subn_set_opa_sl_to_sc(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_SL_MAP:
+		ret = __subn_set_opa_sc_to_sl(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_VLT_MAP:
+		ret = __subn_set_opa_sc_to_vlt(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_SC_TO_VLNT_MAP:
+		ret = __subn_set_opa_sc_to_vlnt(smp, am, data, ibdev, port,
+					       resp_len);
+		break;
+	case OPA_ATTRIB_ID_PORT_STATE_INFO:
+		ret = __subn_set_opa_psi(smp, am, data, ibdev, port,
+					 resp_len);
+		break;
+	case OPA_ATTRIB_ID_BUFFER_CONTROL_TABLE:
+		ret = __subn_set_opa_bct(smp, am, data, ibdev, port,
+					 resp_len);
+		break;
+	case IB_SMP_ATTR_VL_ARB_TABLE:
+		ret = __subn_set_opa_vl_arb(smp, am, data, ibdev, port,
+					    resp_len);
+		break;
+	case OPA_ATTRIB_ID_HFI_CONGESTION_SETTING:
+		ret = __subn_set_opa_cong_setting(smp, am, data, ibdev,
+						  port, resp_len);
+		break;
+	case OPA_ATTRIB_ID_CONGESTION_CONTROL_TABLE:
+		ret = __subn_set_opa_cc_table(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_LED_INFO:
+		ret = __subn_set_opa_led_info(smp, am, data, ibdev, port,
+					      resp_len);
+		break;
+	case IB_SMP_ATTR_SM_INFO:
+		if (ibp->port_cap_flags & IB_PORT_SM_DISABLED)
+			return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
+		if (ibp->port_cap_flags & IB_PORT_SM)
+			return IB_MAD_RESULT_SUCCESS;
+		/* FALLTHROUGH */
+	default:
+		smp->status |= IB_SMP_UNSUP_METH_ATTR;
+		ret = reply((struct ib_mad_hdr *)smp);
+		break;
+	}
+	return ret;
+}
+
+static inline void set_aggr_error(struct opa_aggregate *ag)
+{
+	ag->err_reqlength |= cpu_to_be16(0x8000);
+}
+
+static int subn_get_opa_aggregate(struct opa_smp *smp,
+				  struct ib_device *ibdev, u8 port,
+				  u32 *resp_len)
+{
+	int i;
+	u32 num_attr = be32_to_cpu(smp->attr_mod) & 0x000000ff;
+	u8 *next_smp = opa_get_smp_data(smp);
+
+	if (num_attr < 1 || num_attr > 117) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	for (i = 0; i < num_attr; i++) {
+		struct opa_aggregate *agg;
+		size_t agg_data_len;
+		size_t agg_size;
+		u32 am;
+
+		agg = (struct opa_aggregate *)next_smp;
+		agg_data_len = (be16_to_cpu(agg->err_reqlength) & 0x007f) * 8;
+		agg_size = sizeof(*agg) + agg_data_len;
+		am = be32_to_cpu(agg->attr_mod);
+
+		*resp_len += agg_size;
+
+		if (next_smp + agg_size > ((u8 *)smp) + sizeof(*smp)) {
+			smp->status |= IB_SMP_INVALID_FIELD;
+			return reply((struct ib_mad_hdr *)smp);
+		}
+
+		/* zero the payload for this segment */
+		memset(next_smp + sizeof(*agg), 0, agg_data_len);
+
+		(void) subn_get_opa_sma(agg->attr_id, smp, am, agg->data,
+					ibdev, port, NULL);
+		if (smp->status & ~IB_SMP_DIRECTION) {
+			set_aggr_error(agg);
+			return reply((struct ib_mad_hdr *)smp);
+		}
+		next_smp += agg_size;
+
+	}
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+static int subn_set_opa_aggregate(struct opa_smp *smp,
+				  struct ib_device *ibdev, u8 port,
+				  u32 *resp_len)
+{
+	int i;
+	u32 num_attr = be32_to_cpu(smp->attr_mod) & 0x000000ff;
+	u8 *next_smp = opa_get_smp_data(smp);
+
+	if (num_attr < 1 || num_attr > 117) {
+		smp->status |= IB_SMP_INVALID_FIELD;
+		return reply((struct ib_mad_hdr *)smp);
+	}
+
+	for (i = 0; i < num_attr; i++) {
+		struct opa_aggregate *agg;
+		size_t agg_data_len;
+		size_t agg_size;
+		u32 am;
+
+		agg = (struct opa_aggregate *)next_smp;
+		agg_data_len = (be16_to_cpu(agg->err_reqlength) & 0x007f) * 8;
+		agg_size = sizeof(*agg) + agg_data_len;
+		am = be32_to_cpu(agg->attr_mod);
+
+		*resp_len += agg_size;
+
+		if (next_smp + agg_size > ((u8 *)smp) + sizeof(*smp)) {
+			smp->status |= IB_SMP_INVALID_FIELD;
+			return reply((struct ib_mad_hdr *)smp);
+		}
+
+		(void) subn_set_opa_sma(agg->attr_id, smp, am, agg->data,
+					ibdev, port, NULL);
+		if (smp->status & ~IB_SMP_DIRECTION) {
+			set_aggr_error(agg);
+			return reply((struct ib_mad_hdr *)smp);
+		}
+		next_smp += agg_size;
+
+	}
+
+	return reply((struct ib_mad_hdr *)smp);
+}
+
+/*
+ * OPAv1 specifies that, on the transition to link up, these counters
+ * are cleared:
+ *   PortRcvErrors [*]
+ *   LinkErrorRecovery
+ *   LocalLinkIntegrityErrors
+ *   ExcessiveBufferOverruns [*]
+ *
+ * [*] Error info associated with these counters is retained, but the
+ * error info status is reset to 0.
+ */
+void clear_linkup_counters(struct hfi1_devdata *dd)
+{
+	/* PortRcvErrors */
+	write_dev_cntr(dd, C_DC_RCV_ERR, CNTR_INVALID_VL, 0);
+	dd->err_info_rcvport.status_and_code &= ~OPA_EI_STATUS_SMASK;
+	/* LinkErrorRecovery */
+	write_dev_cntr(dd, C_DC_SEQ_CRC_CNT, CNTR_INVALID_VL, 0);
+	write_dev_cntr(dd, C_DC_REINIT_FROM_PEER_CNT, CNTR_INVALID_VL, 0);
+	/* LocalLinkIntegrityErrors */
+	write_dev_cntr(dd, C_DC_TX_REPLAY, CNTR_INVALID_VL, 0);
+	write_dev_cntr(dd, C_DC_RX_REPLAY, CNTR_INVALID_VL, 0);
+	/* ExcessiveBufferOverruns */
+	write_dev_cntr(dd, C_RCV_OVF, CNTR_INVALID_VL, 0);
+	dd->rcv_ovfl_cnt = 0;
+	dd->err_info_xmit_constraint.status &= ~OPA_EI_STATUS_SMASK;
+}
+
+/*
+ * is_local_mad() returns 1 if 'mad' is sent from, and destined to the
+ * local node, 0 otherwise.
+ */
+static int is_local_mad(struct hfi1_ibport *ibp, const struct opa_mad *mad,
+			const struct ib_wc *in_wc)
+{
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	const struct opa_smp *smp = (const struct opa_smp *)mad;
+
+	if (smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) {
+		return (smp->hop_cnt == 0 &&
+			smp->route.dr.dr_slid == OPA_LID_PERMISSIVE &&
+			smp->route.dr.dr_dlid == OPA_LID_PERMISSIVE);
+	}
+
+	return (in_wc->slid == ppd->lid);
+}
+
+/*
+ * opa_local_smp_check() should only be called on MADs for which
+ * is_local_mad() returns true. It applies the SMP checks that are
+ * specific to SMPs which are sent from, and destined to this node.
+ * opa_local_smp_check() returns 0 if the SMP passes its checks, 1
+ * otherwise.
+ *
+ * SMPs which arrive from other nodes are instead checked by
+ * opa_smp_check().
+ */
+static int opa_local_smp_check(struct hfi1_ibport *ibp,
+			       const struct ib_wc *in_wc)
+{
+	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
+	u16 slid = in_wc->slid;
+	u16 pkey;
+
+	if (in_wc->pkey_index >= ARRAY_SIZE(ppd->pkeys))
+		return 1;
+
+	pkey = ppd->pkeys[in_wc->pkey_index];
+	/*
+	 * We need to do the "node-local" checks specified in OPAv1,
+	 * rev 0.90, section 9.10.26, which are:
+	 *   - pkey is 0x7fff, or 0xffff
+	 *   - Source QPN == 0 || Destination QPN == 0
+	 *   - the MAD header's management class is either
+	 *     IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE or
+	 *     IB_MGMT_CLASS_SUBN_LID_ROUTED
+	 *   - SLID != 0
+	 *
+	 * However, we know (and so don't need to check again) that,
+	 * for local SMPs, the MAD stack passes MADs with:
+	 *   - Source QPN of 0
+	 *   - MAD mgmt_class is IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE
+	 *   - SLID is either: OPA_LID_PERMISSIVE (0xFFFFFFFF), or
+	 *     our own port's lid
+	 *
+	 */
+	if (pkey == LIM_MGMT_P_KEY || pkey == FULL_MGMT_P_KEY)
+		return 0;
+	ingress_pkey_table_fail(ppd, pkey, slid);
+	return 1;
+}
+
+static int process_subn_opa(struct ib_device *ibdev, int mad_flags,
+			    u8 port, const struct opa_mad *in_mad,
+			    struct opa_mad *out_mad,
+			    u32 *resp_len)
+{
+	struct opa_smp *smp = (struct opa_smp *)out_mad;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	u8 *data;
+	u32 am;
+	__be16 attr_id;
+	int ret;
+
+	*out_mad = *in_mad;
+	data = opa_get_smp_data(smp);
+
+	am = be32_to_cpu(smp->attr_mod);
+	attr_id = smp->attr_id;
+	if (smp->class_version != OPA_SMI_CLASS_VERSION) {
+		smp->status |= IB_SMP_UNSUP_VERSION;
+		ret = reply((struct ib_mad_hdr *)smp);
+		goto bail;
+	}
+	ret = check_mkey(ibp, (struct ib_mad_hdr *)smp, mad_flags, smp->mkey,
+			 smp->route.dr.dr_slid, smp->route.dr.return_path,
+			 smp->hop_cnt);
+	if (ret) {
+		u32 port_num = be32_to_cpu(smp->attr_mod);
+
+		/*
+		 * If this is a get/set portinfo, we already check the
+		 * M_Key if the MAD is for another port and the M_Key
+		 * is OK on the receiving port. This check is needed
+		 * to increment the error counters when the M_Key
+		 * fails to match on *both* ports.
+		 */
+		if (attr_id == IB_SMP_ATTR_PORT_INFO &&
+		    (smp->method == IB_MGMT_METHOD_GET ||
+		     smp->method == IB_MGMT_METHOD_SET) &&
+		    port_num && port_num <= ibdev->phys_port_cnt &&
+		    port != port_num)
+			(void) check_mkey(to_iport(ibdev, port_num),
+					  (struct ib_mad_hdr *)smp, 0,
+					  smp->mkey, smp->route.dr.dr_slid,
+					  smp->route.dr.return_path,
+					  smp->hop_cnt);
+		ret = IB_MAD_RESULT_FAILURE;
+		goto bail;
+	}
+
+	*resp_len = opa_get_smp_header_size(smp);
+
+	switch (smp->method) {
+	case IB_MGMT_METHOD_GET:
+		switch (attr_id) {
+		default:
+			clear_opa_smp_data(smp);
+			ret = subn_get_opa_sma(attr_id, smp, am, data,
+					       ibdev, port, resp_len);
+			goto bail;
+		case OPA_ATTRIB_ID_AGGREGATE:
+			ret = subn_get_opa_aggregate(smp, ibdev, port,
+						     resp_len);
+			goto bail;
+		}
+	case IB_MGMT_METHOD_SET:
+		switch (attr_id) {
+		default:
+			ret = subn_set_opa_sma(attr_id, smp, am, data,
+					       ibdev, port, resp_len);
+			goto bail;
+		case OPA_ATTRIB_ID_AGGREGATE:
+			ret = subn_set_opa_aggregate(smp, ibdev, port,
+						     resp_len);
+			goto bail;
+		}
+	case IB_MGMT_METHOD_TRAP:
+	case IB_MGMT_METHOD_REPORT:
+	case IB_MGMT_METHOD_REPORT_RESP:
+	case IB_MGMT_METHOD_GET_RESP:
+		/*
+		 * The ib_mad module will call us to process responses
+		 * before checking for other consumers.
+		 * Just tell the caller to process it normally.
+		 */
+		ret = IB_MAD_RESULT_SUCCESS;
+		goto bail;
+	default:
+		smp->status |= IB_SMP_UNSUP_METHOD;
+		ret = reply((struct ib_mad_hdr *)smp);
+	}
+
+bail:
+	return ret;
+}
+
+static int process_subn(struct ib_device *ibdev, int mad_flags,
+			u8 port, const struct ib_mad *in_mad,
+			struct ib_mad *out_mad)
+{
+	struct ib_smp *smp = (struct ib_smp *)out_mad;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+	int ret;
+
+	*out_mad = *in_mad;
+	if (smp->class_version != 1) {
+		smp->status |= IB_SMP_UNSUP_VERSION;
+		ret = reply((struct ib_mad_hdr *)smp);
+		goto bail;
+	}
+
+	ret = check_mkey(ibp, (struct ib_mad_hdr *)smp, mad_flags,
+			 smp->mkey, (__force __be32)smp->dr_slid,
+			 smp->return_path, smp->hop_cnt);
+	if (ret) {
+		u32 port_num = be32_to_cpu(smp->attr_mod);
+
+		/*
+		 * If this is a get/set portinfo, we already check the
+		 * M_Key if the MAD is for another port and the M_Key
+		 * is OK on the receiving port. This check is needed
+		 * to increment the error counters when the M_Key
+		 * fails to match on *both* ports.
+		 */
+		if (in_mad->mad_hdr.attr_id == IB_SMP_ATTR_PORT_INFO &&
+		    (smp->method == IB_MGMT_METHOD_GET ||
+		     smp->method == IB_MGMT_METHOD_SET) &&
+		    port_num && port_num <= ibdev->phys_port_cnt &&
+		    port != port_num)
+			(void) check_mkey(to_iport(ibdev, port_num),
+					  (struct ib_mad_hdr *)smp, 0,
+					  smp->mkey,
+					  (__force __be32)smp->dr_slid,
+					  smp->return_path, smp->hop_cnt);
+		ret = IB_MAD_RESULT_FAILURE;
+		goto bail;
+	}
+
+	switch (smp->method) {
+	case IB_MGMT_METHOD_GET:
+		switch (smp->attr_id) {
+		case IB_SMP_ATTR_NODE_INFO:
+			ret = subn_get_nodeinfo(smp, ibdev, port);
+			goto bail;
+		default:
+			smp->status |= IB_SMP_UNSUP_METH_ATTR;
+			ret = reply((struct ib_mad_hdr *)smp);
+			goto bail;
+		}
+	}
+
+bail:
+	return ret;
+}
+
+static int process_perf_opa(struct ib_device *ibdev, u8 port,
+			    const struct opa_mad *in_mad,
+			    struct opa_mad *out_mad, u32 *resp_len)
+{
+	struct opa_pma_mad *pmp = (struct opa_pma_mad *)out_mad;
+	int ret;
+
+	*out_mad = *in_mad;
+
+	if (pmp->mad_hdr.class_version != OPA_SMI_CLASS_VERSION) {
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_VERSION;
+		return reply((struct ib_mad_hdr *)pmp);
+	}
+
+	*resp_len = sizeof(struct opa_mad);
+
+	switch (pmp->mad_hdr.method) {
+	case IB_MGMT_METHOD_GET:
+		switch (pmp->mad_hdr.attr_id) {
+		case IB_PMA_CLASS_PORT_INFO:
+			ret = pma_get_opa_classportinfo(pmp, ibdev);
+			goto bail;
+		case OPA_PM_ATTRIB_ID_PORT_STATUS:
+			ret = pma_get_opa_portstatus(pmp, ibdev, port);
+			goto bail;
+		case OPA_PM_ATTRIB_ID_DATA_PORT_COUNTERS:
+			ret = pma_get_opa_datacounters(pmp, ibdev, port);
+			goto bail;
+		case OPA_PM_ATTRIB_ID_ERROR_PORT_COUNTERS:
+			ret = pma_get_opa_porterrors(pmp, ibdev, port);
+			goto bail;
+		case OPA_PM_ATTRIB_ID_ERROR_INFO:
+			ret = pma_get_opa_errorinfo(pmp, ibdev, port);
+			goto bail;
+		default:
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
+			ret = reply((struct ib_mad_hdr *)pmp);
+			goto bail;
+		}
+
+	case IB_MGMT_METHOD_SET:
+		switch (pmp->mad_hdr.attr_id) {
+		case OPA_PM_ATTRIB_ID_CLEAR_PORT_STATUS:
+			ret = pma_set_opa_portstatus(pmp, ibdev, port);
+			goto bail;
+		case OPA_PM_ATTRIB_ID_ERROR_INFO:
+			ret = pma_set_opa_errorinfo(pmp, ibdev, port);
+			goto bail;
+		default:
+			pmp->mad_hdr.status |= IB_SMP_UNSUP_METH_ATTR;
+			ret = reply((struct ib_mad_hdr *)pmp);
+			goto bail;
+		}
+
+	case IB_MGMT_METHOD_TRAP:
+	case IB_MGMT_METHOD_GET_RESP:
+		/*
+		 * The ib_mad module will call us to process responses
+		 * before checking for other consumers.
+		 * Just tell the caller to process it normally.
+		 */
+		ret = IB_MAD_RESULT_SUCCESS;
+		goto bail;
+
+	default:
+		pmp->mad_hdr.status |= IB_SMP_UNSUP_METHOD;
+		ret = reply((struct ib_mad_hdr *)pmp);
+	}
+
+bail:
+	return ret;
+}
+
+static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
+			        u8 port, const struct ib_wc *in_wc,
+			        const struct ib_grh *in_grh,
+			        const struct opa_mad *in_mad,
+			        struct opa_mad *out_mad, size_t *out_mad_size,
+			        u16 *out_mad_pkey_index)
+{
+	int ret;
+	int pkey_idx;
+	u32 resp_len = 0;
+	struct hfi1_ibport *ibp = to_iport(ibdev, port);
+
+	pkey_idx = hfi1_lookup_pkey_idx(ibp, LIM_MGMT_P_KEY);
+	if (pkey_idx < 0) {
+		pr_warn("failed to find limited mgmt pkey, defaulting 0x%x\n",
+			hfi1_get_pkey(ibp, 1));
+		pkey_idx = 1;
+	}
+	*out_mad_pkey_index = (u16)pkey_idx;
+
+	switch (in_mad->mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
+	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
+		if (is_local_mad(ibp, in_mad, in_wc)) {
+			ret = opa_local_smp_check(ibp, in_wc);
+			if (ret)
+				return IB_MAD_RESULT_FAILURE;
+		}
+		ret = process_subn_opa(ibdev, mad_flags, port, in_mad,
+				       out_mad, &resp_len);
+		goto bail;
+	case IB_MGMT_CLASS_PERF_MGMT:
+		ret = process_perf_opa(ibdev, port, in_mad, out_mad,
+				       &resp_len);
+		goto bail;
+
+	default:
+		ret = IB_MAD_RESULT_SUCCESS;
+	}
+
+bail:
+	if (ret & IB_MAD_RESULT_REPLY)
+		*out_mad_size = round_up(resp_len, 8);
+	else if (ret & IB_MAD_RESULT_SUCCESS)
+		*out_mad_size = in_wc->byte_len - sizeof(struct ib_grh);
+
+	return ret;
+}
+
+static int hfi1_process_ib_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+			       const struct ib_wc *in_wc,
+			       const struct ib_grh *in_grh,
+			       const struct ib_mad *in_mad,
+			       struct ib_mad *out_mad)
+{
+	int ret;
+
+	switch (in_mad->mad_hdr.mgmt_class) {
+	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
+	case IB_MGMT_CLASS_SUBN_LID_ROUTED:
+		ret = process_subn(ibdev, mad_flags, port, in_mad, out_mad);
+		goto bail;
+	default:
+		ret = IB_MAD_RESULT_SUCCESS;
+	}
+
+bail:
+	return ret;
+}
+
+/**
+ * hfi1_process_mad - process an incoming MAD packet
+ * @ibdev: the infiniband device this packet came in on
+ * @mad_flags: MAD flags
+ * @port: the port number this packet came in on
+ * @in_wc: the work completion entry for this packet
+ * @in_grh: the global route header for this packet
+ * @in_mad: the incoming MAD
+ * @out_mad: any outgoing MAD reply
+ *
+ * Returns IB_MAD_RESULT_SUCCESS if this is a MAD that we are not
+ * interested in processing.
+ *
+ * Note that the verbs framework has already done the MAD sanity checks,
+ * and hop count/pointer updating for IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE
+ * MADs.
+ *
+ * This is called by the ib_mad module.
+ */
+int hfi1_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
+		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		     const struct ib_mad_hdr *in_mad, size_t in_mad_size,
+		     struct ib_mad_hdr *out_mad, size_t *out_mad_size,
+		     u16 *out_mad_pkey_index)
+{
+	switch (in_mad->base_version) {
+	case OPA_MGMT_BASE_VERSION:
+		if (unlikely(in_mad_size != sizeof(struct opa_mad))) {
+			dev_err(ibdev->dma_device, "invalid in_mad_size\n");
+			return IB_MAD_RESULT_FAILURE;
+		}
+		return hfi1_process_opa_mad(ibdev, mad_flags, port,
+					    in_wc, in_grh,
+					    (struct opa_mad *)in_mad,
+					    (struct opa_mad *)out_mad,
+					    out_mad_size,
+					    out_mad_pkey_index);
+	case IB_MGMT_BASE_VERSION:
+		return hfi1_process_ib_mad(ibdev, mad_flags, port,
+					  in_wc, in_grh,
+					  (const struct ib_mad *)in_mad,
+					  (struct ib_mad *)out_mad);
+	default:
+		break;
+	}
+
+	return IB_MAD_RESULT_FAILURE;
+}
+
+static void send_handler(struct ib_mad_agent *agent,
+			 struct ib_mad_send_wc *mad_send_wc)
+{
+	ib_free_send_mad(mad_send_wc->send_buf);
+}
+
+int hfi1_create_agents(struct hfi1_ibdev *dev)
+{
+	struct hfi1_devdata *dd = dd_from_dev(dev);
+	struct ib_mad_agent *agent;
+	struct hfi1_ibport *ibp;
+	int p;
+	int ret;
+
+	for (p = 0; p < dd->num_pports; p++) {
+		ibp = &dd->pport[p].ibport_data;
+		agent = ib_register_mad_agent(&dev->ibdev, p + 1, IB_QPT_SMI,
+					      NULL, 0, send_handler,
+					      NULL, NULL, 0);
+		if (IS_ERR(agent)) {
+			ret = PTR_ERR(agent);
+			goto err;
+		}
+
+		ibp->send_agent = agent;
+	}
+
+	return 0;
+
+err:
+	for (p = 0; p < dd->num_pports; p++) {
+		ibp = &dd->pport[p].ibport_data;
+		if (ibp->send_agent) {
+			agent = ibp->send_agent;
+			ibp->send_agent = NULL;
+			ib_unregister_mad_agent(agent);
+		}
+	}
+
+	return ret;
+}
+
+void hfi1_free_agents(struct hfi1_ibdev *dev)
+{
+	struct hfi1_devdata *dd = dd_from_dev(dev);
+	struct ib_mad_agent *agent;
+	struct hfi1_ibport *ibp;
+	int p;
+
+	for (p = 0; p < dd->num_pports; p++) {
+		ibp = &dd->pport[p].ibport_data;
+		if (ibp->send_agent) {
+			agent = ibp->send_agent;
+			ibp->send_agent = NULL;
+			ib_unregister_mad_agent(agent);
+		}
+		if (ibp->sm_ah) {
+			ib_destroy_ah(&ibp->sm_ah->ibah);
+			ibp->sm_ah = NULL;
+		}
+	}
+}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
