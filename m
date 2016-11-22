From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 03/11] IB/core: Change ah_attr.dlid from 16 to 32 bits
Date: Tue, 22 Nov 2016 14:38:44 -0500
Message-ID: <1479843532-47496-4-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

dlid field in ah_attr is increased to 32 bits. This
enables core components to use the larger addresses if needed.
The user ABI is unchanged and userspace applications can use
16 bit lids when creating and modifying address handles.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad_rmpp.c        |  2 +-
 drivers/infiniband/core/sa_query.c        |  2 +-
 drivers/infiniband/core/uverbs_cmd.c      | 11 +++++++++--
 drivers/infiniband/core/uverbs_marshall.c |  2 +-
 drivers/infiniband/hw/hfi1/driver.c       |  4 ++--
 drivers/infiniband/hw/hfi1/rc.c           |  4 ++--
 drivers/infiniband/hw/hfi1/ruc.c          | 21 +++++++++++----------
 drivers/infiniband/hw/hfi1/uc.c           |  2 +-
 drivers/infiniband/hw/hfi1/ud.c           | 10 +++++-----
 drivers/infiniband/hw/hfi1/verbs.c        |  4 ++--
 drivers/infiniband/hw/mlx4/ah.c           |  2 +-
 drivers/infiniband/hw/mlx4/mcg.c          |  2 +-
 drivers/infiniband/hw/mlx4/qp.c           |  2 +-
 drivers/infiniband/hw/mlx5/ah.c           |  2 +-
 drivers/infiniband/hw/mthca/mthca_av.c    |  2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c    |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c  |  2 +-
 drivers/infiniband/hw/qib/qib_rc.c        |  4 ++--
 drivers/infiniband/hw/qib/qib_ruc.c       | 11 ++++++-----
 drivers/infiniband/hw/qib/qib_uc.c        |  2 +-
 drivers/infiniband/hw/qib/qib_ud.c        |  8 ++++----
 include/rdma/ib_verbs.h                   |  2 +-
 22 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 382941b..c34dca3 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -870,7 +870,7 @@ static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 		if (ib_query_ah(mad_send_wr->send_buf.ah, &ah_attr))
 			continue;
 
-		if (rmpp_recv->slid == ah_attr.dlid) {
+		if (rmpp_recv->slid == (u16)ah_attr.dlid) {
 			newwin = rmpp_recv->repwin;
 			break;
 		}
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 0b0dc43..81b742c 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -958,7 +958,7 @@ static void update_sm_ah(struct work_struct *work)
 		pr_err("Couldn't find index for default PKey\n");
 
 	memset(&ah_attr, 0, sizeof ah_attr);
-	ah_attr.dlid     = (u16)port_attr.sm_lid;
+	ah_attr.dlid     = port_attr.sm_lid;
 	ah_attr.sl       = port_attr.sm_sl;
 	ah_attr.port_num = port->port_num;
 	if (port_attr.grh_required) {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7630c92..36f5bc1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2281,7 +2281,10 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.dest.sgid_index        = attr->ah_attr.grh.sgid_index;
 	resp.dest.hop_limit         = attr->ah_attr.grh.hop_limit;
 	resp.dest.traffic_class     = attr->ah_attr.grh.traffic_class;
-	resp.dest.dlid              = attr->ah_attr.dlid;
+	if (rdma_cap_opa_ah(ib_dev, attr->ah_attr.port_num))
+		resp.dest.dlid	    = OPA_TO_IB_UCAST_LID(attr->ah_attr.dlid);
+	else
+		resp.dest.dlid	    = (u16)attr->ah_attr.dlid;
 	resp.dest.sl                = attr->ah_attr.sl;
 	resp.dest.src_path_bits     = attr->ah_attr.src_path_bits;
 	resp.dest.static_rate       = attr->ah_attr.static_rate;
@@ -2293,7 +2296,11 @@ ssize_t ib_uverbs_query_qp(struct ib_uverbs_file *file,
 	resp.alt_dest.sgid_index    = attr->alt_ah_attr.grh.sgid_index;
 	resp.alt_dest.hop_limit     = attr->alt_ah_attr.grh.hop_limit;
 	resp.alt_dest.traffic_class = attr->alt_ah_attr.grh.traffic_class;
-	resp.alt_dest.dlid          = attr->alt_ah_attr.dlid;
+	if (rdma_cap_opa_ah(ib_dev, attr->alt_ah_attr.port_num))
+		resp.alt_dest.dlid  =
+			OPA_TO_IB_UCAST_LID(attr->alt_ah_attr.dlid);
+	else
+		resp.alt_dest.dlid  = (u16)attr->alt_ah_attr.dlid;
 	resp.alt_dest.sl            = attr->alt_ah_attr.sl;
 	resp.alt_dest.src_path_bits = attr->alt_ah_attr.src_path_bits;
 	resp.alt_dest.static_rate   = attr->alt_ah_attr.static_rate;
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index af020f8..f8c9008 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -42,7 +42,7 @@ void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
 	dst->grh.hop_limit         = src->grh.hop_limit;
 	dst->grh.traffic_class     = src->grh.traffic_class;
 	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
-	dst->dlid 	    	   = src->dlid;
+	dst->dlid		   = (u16)src->dlid;
 	dst->sl   	    	   = src->sl;
 	dst->src_path_bits 	   = src->src_path_bits;
 	dst->static_rate   	   = src->static_rate;
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 6563e4d..4195ba8 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -473,12 +473,12 @@ void hfi1_process_ecn_slowpath(struct rvt_qp *qp, struct hfi1_packet *pkt,
 			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
 		break;
 	case IB_QPT_UC:
-		rlid = qp->remote_ah_attr.dlid;
+		rlid = (u16)qp->remote_ah_attr.dlid;
 		rqpn = qp->remote_qpn;
 		svc_type = IB_CC_SVCTYPE_UC;
 		break;
 	case IB_QPT_RC:
-		rlid = qp->remote_ah_attr.dlid;
+		rlid = (u16)qp->remote_ah_attr.dlid;
 		rqpn = qp->remote_qpn;
 		svc_type = IB_CC_SVCTYPE_RC;
 		break;
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index 8bc5013..caca6f5 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -890,7 +890,7 @@ void hfi1_send_rc_ack(struct hfi1_ctxtdata *rcd, struct rvt_qp *qp,
 	pbc_flags |= ((!!(sc5 & 0x10)) << PBC_DC_INFO_SHIFT);
 	lrh0 |= (sc5 & 0xf) << 12 | (qp->remote_ah_attr.sl & 0xf) << 4;
 	hdr.lrh[0] = cpu_to_be16(lrh0);
-	hdr.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	hdr.lrh[1] = cpu_to_be16((u16)qp->remote_ah_attr.dlid);
 	hdr.lrh[2] = cpu_to_be16(hwords + SIZE_OF_CRC);
 	hdr.lrh[3] = cpu_to_be16(ppd->lid | qp->remote_ah_attr.src_path_bits);
 	ohdr->bth[0] = cpu_to_be32(bth0);
@@ -2306,7 +2306,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = qp->remote_ah_attr.dlid;
+		wc.slid = (u16)qp->remote_ah_attr.dlid;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index a1576ae..2fe2b2f 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -297,7 +297,7 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->alt_ah_attr.dlid ||
+		if (be16_to_cpu(hdr->lrh[3]) != (u16)qp->alt_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->alt_ah_attr.port_num)
 			goto err;
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -332,7 +332,7 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct ib_header *hdr,
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->remote_ah_attr.dlid ||
+		if (be16_to_cpu(hdr->lrh[3]) != (u16)qp->remote_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->port_num)
 			goto err;
 		if (qp->s_mig_state == IB_MIG_REARM &&
@@ -591,7 +591,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	wc.byte_len = wqe->length;
 	wc.qp = &qp->ibqp;
 	wc.src_qp = qp->remote_qpn;
-	wc.slid = qp->remote_ah_attr.dlid;
+	wc.slid = (u16)qp->remote_ah_attr.dlid;
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
@@ -812,7 +812,8 @@ void hfi1_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 	else
 		qp->s_flags &= ~RVT_S_AHG_VALID;
 	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
-	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	ps->s_txreq->phdr.hdr.lrh[1] =
+		cpu_to_be16((u16)qp->remote_ah_attr.dlid);
 	ps->s_txreq->phdr.hdr.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	ps->s_txreq->phdr.hdr.lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
@@ -864,9 +865,9 @@ void hfi1_do_send(struct rvt_qp *qp)
 
 	switch (qp->ibqp.qp_type) {
 	case IB_QPT_RC:
-		if (!loopback && ((qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc
-								) - 1)) ==
-				 ps.ppd->lid)) {
+		if (!loopback && (((u16)qp->remote_ah_attr.dlid &
+				   ~((1 << ps.ppd->lmc) - 1)) ==
+				  ps.ppd->lid)) {
 			ruc_loopback(qp);
 			return;
 		}
@@ -874,9 +875,9 @@ void hfi1_do_send(struct rvt_qp *qp)
 		timeout_int = (qp->timeout_jiffies);
 		break;
 	case IB_QPT_UC:
-		if (!loopback && ((qp->remote_ah_attr.dlid & ~((1 << ps.ppd->lmc
-								) - 1)) ==
-				 ps.ppd->lid)) {
+		if (!loopback && (((u16)qp->remote_ah_attr.dlid &
+				   ~((1 << ps.ppd->lmc) - 1)) ==
+				  ps.ppd->lid)) {
 			ruc_loopback(qp);
 			return;
 		}
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 5e6d1ba..0572dc7 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -451,7 +451,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = qp->remote_ah_attr.dlid;
+		wc.slid = (u16)qp->remote_ah_attr.dlid;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 97ae24b..8a27ab1 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -113,7 +113,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 			hfi1_bad_pqkey(ibp, OPA_TRAP_BAD_P_KEY, pkey,
 				       ah_attr->sl,
 				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
-				       slid, ah_attr->dlid);
+				       slid, (u16)ah_attr->dlid);
 			goto drop;
 		}
 	}
@@ -137,7 +137,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 				       ah_attr->sl,
 				       sqp->ibqp.qp_num, qp->ibqp.qp_num,
 				       lid,
-				       ah_attr->dlid);
+				       (u16)ah_attr->dlid);
 			goto drop;
 		}
 	}
@@ -248,7 +248,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	if (wc.slid == 0 && sqp->ibqp.qp_type == IB_QPT_GSI)
 		wc.slid = be16_to_cpu(IB_LID_PERMISSIVE);
 	wc.sl = ah_attr->sl;
-	wc.dlid_path_bits = ah_attr->dlid & ((1 << ppd->lmc) - 1);
+	wc.dlid_path_bits = (u16)ah_attr->dlid & ((1 << ppd->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
 	rvt_cq_enter(ibcq_to_rvtcq(qp->ibqp.recv_cq), &wc,
@@ -321,7 +321,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	ah_attr = &ibah_to_rvtah(wqe->ud_wr.ah)->attr;
 	if (ah_attr->dlid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
 	    ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
-		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
+		lid = (u16)ah_attr->dlid & ~((1 << ppd->lmc) - 1);
 		if (unlikely(!loopback &&
 			     (lid == ppd->lid ||
 			      (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
@@ -402,7 +402,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 	priv->s_sendcontext = qp_to_send_context(qp, priv->s_sc);
 	ps->s_txreq->psc = priv->s_sendcontext;
 	ps->s_txreq->phdr.hdr.lrh[0] = cpu_to_be16(lrh0);
-	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16(ah_attr->dlid);
+	ps->s_txreq->phdr.hdr.lrh[1] = cpu_to_be16((u16)ah_attr->dlid);
 	ps->s_txreq->phdr.hdr.lrh[2] =
 		cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	if (ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 4b7a16c..a13bfdf 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1781,12 +1781,12 @@ void hfi1_cnp_rcv(struct hfi1_packet *packet)
 
 	switch (packet->qp->ibqp.qp_type) {
 	case IB_QPT_UC:
-		rlid = qp->remote_ah_attr.dlid;
+		rlid = (u16)qp->remote_ah_attr.dlid;
 		rqpn = qp->remote_qpn;
 		svc_type = IB_CC_SVCTYPE_UC;
 		break;
 	case IB_QPT_RC:
-		rlid = qp->remote_ah_attr.dlid;
+		rlid = (u16)qp->remote_ah_attr.dlid;
 		rqpn = qp->remote_qpn;
 		svc_type = IB_CC_SVCTYPE_RC;
 		break;
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 5fc6233..772789f 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -58,7 +58,7 @@ static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 		memcpy(ah->av.ib.dgid, ah_attr->grh.dgid.raw, 16);
 	}
 
-	ah->av.ib.dlid    = cpu_to_be16(ah_attr->dlid);
+	ah->av.ib.dlid    = cpu_to_be16((u16)ah_attr->dlid);
 	if (ah_attr->static_rate) {
 		ah->av.ib.stat_rate = ah_attr->static_rate + MLX4_STAT_RATE_OFFSET;
 		while (ah->av.ib.stat_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index a21d37f..d46a847 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -244,7 +244,7 @@ static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
 	wc.sl = 0;
 	wc.dlid_path_bits = 0;
 	wc.port_num = ctx->port;
-	wc.slid = ah_attr.dlid;  /* opensm lid */
+	wc.slid = (u16)ah_attr.dlid;  /* opensm lid */
 	wc.src_qp = 1;
 	return mlx4_ib_send_to_slave(dev, slave, ctx->port, IB_QPT_GSI, &wc, NULL, mad);
 }
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 570bc86..ada1ecc 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1396,7 +1396,7 @@ static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
 
 
 	path->grh_mylmc     = ah->src_path_bits & 0x7f;
-	path->rlid	    = cpu_to_be16(ah->dlid);
+	path->rlid	    = cpu_to_be16((u16)ah->dlid);
 	if (ah->static_rate) {
 		path->static_rate = ah->static_rate + MLX4_STAT_RATE_OFFSET;
 		while (path->static_rate > IB_RATE_2_5_GBPS + MLX4_STAT_RATE_OFFSET &&
diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index 745efa4..6248542 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -56,7 +56,7 @@ static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
 						ah_attr->grh.sgid_index);
 		ah->av.stat_rate_sl |= (ah_attr->sl & 0x7) << 1;
 	} else {
-		ah->av.rlid = cpu_to_be16(ah_attr->dlid);
+		ah->av.rlid = cpu_to_be16((u16)ah_attr->dlid);
 		ah->av.fl_mlid = ah_attr->src_path_bits & 0x7f;
 		ah->av.stat_rate_sl |= (ah_attr->sl & 0xf);
 	}
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index bcac294..9e0c5c8 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -200,7 +200,7 @@ int mthca_create_ah(struct mthca_dev *dev,
 
 	av->port_pd = cpu_to_be32(pd->pd_num | (ah_attr->port_num << 24));
 	av->g_slid  = ah_attr->src_path_bits;
-	av->dlid    = cpu_to_be16(ah_attr->dlid);
+	av->dlid    = cpu_to_be16((u16)ah_attr->dlid);
 	av->msg_sr  = (3 << 4) | /* 2K message */
 		mthca_get_rate(dev, ah_attr->static_rate, ah_attr->port_num);
 	av->sl_tclass_flowlabel = cpu_to_be32(ah_attr->sl << 28);
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 96e5fb9..32d000f 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -516,7 +516,7 @@ static int mthca_path_set(struct mthca_dev *dev, const struct ib_ah_attr *ah,
 			  struct mthca_qp_path *path, u8 port)
 {
 	path->g_mylmc     = ah->src_path_bits & 0x7f;
-	path->rlid        = cpu_to_be16(ah->dlid);
+	path->rlid        = cpu_to_be16((u16)ah->dlid);
 	path->static_rate = mthca_get_rate(dev, ah->static_rate, port);
 
 	if (ah->ah_flags & IB_AH_GRH) {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 797362a..ea90304 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -215,7 +215,7 @@ struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr)
 
 	/* if pd is for the user process, pass the ah_id to user space */
 	if ((pd->uctx) && (pd->uctx->ah_tbl.va)) {
-		ahid_addr = pd->uctx->ah_tbl.va + attr->dlid;
+		ahid_addr = pd->uctx->ah_tbl.va + (u16)attr->dlid;
 		*ahid_addr = 0;
 		*ahid_addr |= ah->id & OCRDMA_AH_ID_MASK;
 		if (ocrdma_is_udp_encap_supported(dev)) {
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 2097512..91f0d08 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -665,7 +665,7 @@ void qib_send_rc_ack(struct rvt_qp *qp)
 	lrh0 |= ibp->sl_to_vl[qp->remote_ah_attr.sl] << 12 |
 		qp->remote_ah_attr.sl << 4;
 	hdr.lrh[0] = cpu_to_be16(lrh0);
-	hdr.lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	hdr.lrh[1] = cpu_to_be16((u16)qp->remote_ah_attr.dlid);
 	hdr.lrh[2] = cpu_to_be16(hwords + SIZE_OF_CRC);
 	hdr.lrh[3] = cpu_to_be16(ppd->lid | qp->remote_ah_attr.src_path_bits);
 	ohdr->bth[0] = cpu_to_be32(bth0);
@@ -2018,7 +2018,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 			wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = qp->remote_ah_attr.dlid;
+		wc.slid = (u16)qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
 		/* zero fields that are N/A */
 		wc.vendor_err = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index de1bde5..0b0620f 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -297,7 +297,7 @@ int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 and 17.2.8 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->alt_ah_attr.dlid ||
+		if (be16_to_cpu(hdr->lrh[3]) != (u16)qp->alt_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->alt_ah_attr.port_num)
 			goto err;
 		spin_lock_irqsave(&qp->s_lock, flags);
@@ -330,7 +330,7 @@ int qib_ruc_check_hdr(struct qib_ibport *ibp, struct ib_header *hdr,
 			goto err;
 		}
 		/* Validate the SLID. See Ch. 9.6.1.5 */
-		if (be16_to_cpu(hdr->lrh[3]) != qp->remote_ah_attr.dlid ||
+		if (be16_to_cpu(hdr->lrh[3]) != (u16)qp->remote_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->port_num)
 			goto err;
 		if (qp->s_mig_state == IB_MIG_REARM &&
@@ -566,7 +566,7 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	wc.byte_len = wqe->length;
 	wc.qp = &qp->ibqp;
 	wc.src_qp = qp->remote_qpn;
-	wc.slid = qp->remote_ah_attr.dlid;
+	wc.slid = (u16)qp->remote_ah_attr.dlid;
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
@@ -702,7 +702,7 @@ void qib_make_ruc_header(struct rvt_qp *qp, struct ib_other_headers *ohdr,
 	lrh0 |= ibp->sl_to_vl[qp->remote_ah_attr.sl] << 12 |
 		qp->remote_ah_attr.sl << 4;
 	priv->s_hdr->lrh[0] = cpu_to_be16(lrh0);
-	priv->s_hdr->lrh[1] = cpu_to_be16(qp->remote_ah_attr.dlid);
+	priv->s_hdr->lrh[1] = cpu_to_be16((u16)qp->remote_ah_attr.dlid);
 	priv->s_hdr->lrh[2] =
 			cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	priv->s_hdr->lrh[3] = cpu_to_be16(ppd_from_ibp(ibp)->lid |
@@ -744,7 +744,8 @@ void qib_do_send(struct rvt_qp *qp)
 
 	if ((qp->ibqp.qp_type == IB_QPT_RC ||
 	     qp->ibqp.qp_type == IB_QPT_UC) &&
-	    (qp->remote_ah_attr.dlid & ~((1 << ppd->lmc) - 1)) == ppd->lid) {
+	    (((u16)qp->remote_ah_attr.dlid) & ~((1 << ppd->lmc) - 1))
+	    == ppd->lid) {
 		qib_ruc_loopback(qp);
 		return;
 	}
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 5b2d483..7a10748 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -403,7 +403,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = qp->remote_ah_attr.dlid;
+		wc.slid = (u16)qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
 		/* zero fields that are N/A */
 		wc.vendor_err = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index f45cad1..37cd128 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -98,7 +98,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 				      ah_attr->sl,
 				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
 				      cpu_to_be16(lid),
-				      cpu_to_be16(ah_attr->dlid));
+				      cpu_to_be16((u16)ah_attr->dlid));
 			goto drop;
 		}
 	}
@@ -122,7 +122,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 				      ah_attr->sl,
 				      sqp->ibqp.qp_num, qp->ibqp.qp_num,
 				      cpu_to_be16(lid),
-				      cpu_to_be16(ah_attr->dlid));
+				      cpu_to_be16((u16)ah_attr->dlid));
 			goto drop;
 		}
 	}
@@ -296,7 +296,7 @@ int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 			this_cpu_inc(ibp->pmastats->n_unicast_xmit);
 	} else {
 		this_cpu_inc(ibp->pmastats->n_unicast_xmit);
-		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
+		lid = ((u16)ah_attr->dlid) & ~((1 << ppd->lmc) - 1);
 		if (unlikely(lid == ppd->lid)) {
 			unsigned long tflags = *flags;
 			/*
@@ -363,7 +363,7 @@ int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 	else
 		lrh0 |= ibp->sl_to_vl[ah_attr->sl] << 12;
 	priv->s_hdr->lrh[0] = cpu_to_be16(lrh0);
-	priv->s_hdr->lrh[1] = cpu_to_be16(ah_attr->dlid);  /* DEST LID */
+	priv->s_hdr->lrh[1] = cpu_to_be16((u16)ah_attr->dlid);  /* DEST LID */
 	priv->s_hdr->lrh[2] =
 			cpu_to_be16(qp->s_hdrwords + nwords + SIZE_OF_CRC);
 	lid = ppd->lid;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 52216f6..294d3ed 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -814,7 +814,7 @@ struct ib_mr_status {
 
 struct ib_ah_attr {
 	struct ib_global_route	grh;
-	u16			dlid;
+	u32			dlid;
 	u8			sl;
 	u8			src_path_bits;
 	u8			static_rate;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
