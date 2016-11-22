From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 05/11] IB/core: Change wc.slid from 16 to 32 bits
Date: Tue, 22 Nov 2016 14:38:46 -0500
Message-ID: <1479843532-47496-6-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479843532-47496-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

lid field in ib_wc is increased to 32 bits. This enables core
components to use the larger addresses if needed.
The user ABI is unchanged and return 16 bit values when queried.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c            | 4 ++--
 drivers/infiniband/core/mad_rmpp.c      | 4 ++--
 drivers/infiniband/core/user_mad.c      | 2 +-
 drivers/infiniband/core/uverbs_cmd.c    | 2 +-
 drivers/infiniband/hw/hfi1/mad.c        | 2 +-
 drivers/infiniband/hw/hfi1/rc.c         | 2 +-
 drivers/infiniband/hw/hfi1/ruc.c        | 2 +-
 drivers/infiniband/hw/hfi1/uc.c         | 2 +-
 drivers/infiniband/hw/mlx4/mad.c        | 6 +++---
 drivers/infiniband/hw/mlx4/mcg.c        | 2 +-
 drivers/infiniband/hw/mlx5/mad.c        | 2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c | 4 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c | 2 +-
 drivers/infiniband/hw/qib/qib_rc.c      | 2 +-
 drivers/infiniband/hw/qib/qib_ruc.c     | 2 +-
 drivers/infiniband/hw/qib/qib_uc.c      | 2 +-
 drivers/infiniband/sw/rdmavt/cq.c       | 2 +-
 include/rdma/ib_verbs.h                 | 2 +-
 18 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c995255..137c4c2 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1576,7 +1576,7 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 {
 	if (!cm_req_get_primary_subnet_local(req_msg)) {
 		if (req_msg->primary_local_lid == IB_LID_PERMISSIVE) {
-			req_msg->primary_local_lid = cpu_to_be16(wc->slid);
+			req_msg->primary_local_lid = cpu_to_be16((u16)wc->slid);
 			cm_req_set_primary_sl(req_msg, wc->sl);
 		}
 
@@ -1586,7 +1586,7 @@ static void cm_process_routed_req(struct cm_req_msg *req_msg, struct ib_wc *wc)
 
 	if (!cm_req_get_alt_subnet_local(req_msg)) {
 		if (req_msg->alt_local_lid == IB_LID_PERMISSIVE) {
-			req_msg->alt_local_lid = cpu_to_be16(wc->slid);
+			req_msg->alt_local_lid = cpu_to_be16((u16)wc->slid);
 			cm_req_set_alt_sl(req_msg, wc->sl);
 		}
 
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index c34dca3..8a076e1 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -316,7 +316,7 @@ static void recv_cleanup_handler(struct work_struct *work)
 	mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
 	rmpp_recv->tid = mad_hdr->tid;
 	rmpp_recv->src_qp = mad_recv_wc->wc->src_qp;
-	rmpp_recv->slid = mad_recv_wc->wc->slid;
+	rmpp_recv->slid = (u16)mad_recv_wc->wc->slid;
 	rmpp_recv->mgmt_class = mad_hdr->mgmt_class;
 	rmpp_recv->class_version = mad_hdr->class_version;
 	rmpp_recv->method  = mad_hdr->method;
@@ -337,7 +337,7 @@ static void recv_cleanup_handler(struct work_struct *work)
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		if (rmpp_recv->tid == mad_hdr->tid &&
 		    rmpp_recv->src_qp == mad_recv_wc->wc->src_qp &&
-		    rmpp_recv->slid == mad_recv_wc->wc->slid &&
+		    rmpp_recv->slid == (u16)mad_recv_wc->wc->slid &&
 		    rmpp_recv->mgmt_class == mad_hdr->mgmt_class &&
 		    rmpp_recv->class_version == mad_hdr->class_version &&
 		    rmpp_recv->method == mad_hdr->method)
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 415a318..2a0b928 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -229,7 +229,7 @@ static void recv_handler(struct ib_mad_agent *agent,
 	packet->mad.hdr.status	   = 0;
 	packet->mad.hdr.length	   = hdr_size(file) + mad_recv_wc->mad_len;
 	packet->mad.hdr.qpn	   = cpu_to_be32(mad_recv_wc->wc->src_qp);
-	packet->mad.hdr.lid	   = cpu_to_be16(mad_recv_wc->wc->slid);
+	packet->mad.hdr.lid	   = cpu_to_be16((u16)mad_recv_wc->wc->slid);
 	packet->mad.hdr.sl	   = mad_recv_wc->wc->sl;
 	packet->mad.hdr.path_bits  = mad_recv_wc->wc->dlid_path_bits;
 	packet->mad.hdr.pkey_index = mad_recv_wc->wc->pkey_index;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e135c08..a203cf2 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1619,7 +1619,7 @@ static int copy_wc_to_user(void __user *dest, struct ib_wc *wc)
 	tmp.src_qp		= wc->src_qp;
 	tmp.wc_flags		= wc->wc_flags;
 	tmp.pkey_index		= wc->pkey_index;
-	tmp.slid		= wc->slid;
+	tmp.slid		= (u16)wc->slid;
 	tmp.sl			= wc->sl;
 	tmp.dlid_path_bits	= wc->dlid_path_bits;
 	tmp.port_num		= wc->port_num;
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 9487c9b..c76e546 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3974,7 +3974,7 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
 			       const struct ib_wc *in_wc)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	u16 slid = in_wc->slid;
+	u16 slid = (u16)in_wc->slid;
 	u16 pkey;
 
 	if (in_wc->pkey_index >= ARRAY_SIZE(ppd->pkeys))
diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index caca6f5..40ae502 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2306,7 +2306,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = (u16)qp->remote_ah_attr.dlid;
+		wc.slid = qp->remote_ah_attr.dlid;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 2fe2b2f..777cfc8 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -591,7 +591,7 @@ static void ruc_loopback(struct rvt_qp *sqp)
 	wc.byte_len = wqe->length;
 	wc.qp = &qp->ibqp;
 	wc.src_qp = qp->remote_qpn;
-	wc.slid = (u16)qp->remote_ah_attr.dlid;
+	wc.slid = qp->remote_ah_attr.dlid;
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
diff --git a/drivers/infiniband/hw/hfi1/uc.c b/drivers/infiniband/hw/hfi1/uc.c
index 0572dc7..5e6d1ba 100644
--- a/drivers/infiniband/hw/hfi1/uc.c
+++ b/drivers/infiniband/hw/hfi1/uc.c
@@ -451,7 +451,7 @@ void hfi1_uc_rcv(struct hfi1_packet *packet)
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = (u16)qp->remote_ah_attr.dlid;
+		wc.slid = qp->remote_ah_attr.dlid;
 		/*
 		 * It seems that IB mandates the presence of an SL in a
 		 * work completion only for the UD transport (see section
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 404ec4e..8e50de0 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -167,7 +167,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 
 		op_modifier |= 0x4;
 
-		in_modifier |= in_wc->slid << 16;
+		in_modifier |= (u16)in_wc->slid << 16;
 	}
 
 	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma, in_modifier,
@@ -599,7 +599,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 		memcpy((char *)&tun_mad->hdr.slid_mac_47_32, &(wc->smac[4]), 2);
 	} else {
 		tun_mad->hdr.sl_vid = cpu_to_be16(((u16)(wc->sl)) << 12);
-		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16(wc->slid);
+		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16((u16)wc->slid);
 	}
 
 	ib_dma_sync_single_for_device(&dev->ib_dev,
@@ -787,7 +787,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		}
 	}
 
-	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+	slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
 		forward_trap(to_mdev(ibdev), port_num, in_mad);
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index d46a847..a21d37f 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -244,7 +244,7 @@ static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
 	wc.sl = 0;
 	wc.dlid_path_bits = 0;
 	wc.port_num = ctx->port;
-	wc.slid = (u16)ah_attr.dlid;  /* opensm lid */
+	wc.slid = ah_attr.dlid;  /* opensm lid */
 	wc.src_qp = 1;
 	return mlx4_ib_send_to_slave(dev, slave, ctx->port, IB_QPT_GSI, &wc, NULL, mad);
 }
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 39e5848..f0323b7 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -66,7 +66,7 @@ static int process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 	u16 slid;
 	int err;
 
-	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+	slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0)
 		return IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_CONSUMED;
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index c7f49bb..d07f389 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1913,7 +1913,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 			(in_wc->wc_flags & IB_WC_GRH ? 0x80 : 0);
 		MTHCA_PUT(inbox, val,               MAD_IFC_G_PATH_OFFSET);
 
-		MTHCA_PUT(inbox, in_wc->slid,       MAD_IFC_RLID_OFFSET);
+		MTHCA_PUT(inbox, (u16)in_wc->slid,       MAD_IFC_RLID_OFFSET);
 		MTHCA_PUT(inbox, in_wc->pkey_index, MAD_IFC_PKEY_OFFSET);
 
 		if (in_grh)
@@ -1921,7 +1921,7 @@ int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
 
 		op_modifier |= 0x4;
 
-		in_modifier |= in_wc->slid << 16;
+		in_modifier |= (u16)in_wc->slid << 16;
 	}
 
 	err = mthca_cmd_box(dev, inmailbox->dma, outmailbox->dma,
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index b503d160..e9a7dd0 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -204,7 +204,7 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u16 *out_mad_pkey_index)
 {
 	int err;
-	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+	u16 slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 	u16 prev_lid = 0;
 	struct ib_port_attr pattr;
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index 91f0d08..9d0b2bc 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2018,7 +2018,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 			wc.opcode = IB_WC_RECV;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = (u16)qp->remote_ah_attr.dlid;
+		wc.slid = qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
 		/* zero fields that are N/A */
 		wc.vendor_err = 0;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index 0b0620f..588b4ae 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -566,7 +566,7 @@ static void qib_ruc_loopback(struct rvt_qp *sqp)
 	wc.byte_len = wqe->length;
 	wc.qp = &qp->ibqp;
 	wc.src_qp = qp->remote_qpn;
-	wc.slid = (u16)qp->remote_ah_attr.dlid;
+	wc.slid = qp->remote_ah_attr.dlid;
 	wc.sl = qp->remote_ah_attr.sl;
 	wc.port_num = 1;
 	/* Signal completion event if the solicited bit is set. */
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 7a10748..5b2d483 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -403,7 +403,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 		wc.status = IB_WC_SUCCESS;
 		wc.qp = &qp->ibqp;
 		wc.src_qp = qp->remote_qpn;
-		wc.slid = (u16)qp->remote_ah_attr.dlid;
+		wc.slid = qp->remote_ah_attr.dlid;
 		wc.sl = qp->remote_ah_attr.sl;
 		/* zero fields that are N/A */
 		wc.vendor_err = 0;
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 6d9904a..a03b240 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -105,7 +105,7 @@ void rvt_cq_enter(struct rvt_cq *cq, struct ib_wc *entry, bool solicited)
 		wc->uqueue[head].src_qp = entry->src_qp;
 		wc->uqueue[head].wc_flags = entry->wc_flags;
 		wc->uqueue[head].pkey_index = entry->pkey_index;
-		wc->uqueue[head].slid = entry->slid;
+		wc->uqueue[head].slid = (u16)entry->slid;
 		wc->uqueue[head].sl = entry->sl;
 		wc->uqueue[head].dlid_path_bits = entry->dlid_path_bits;
 		wc->uqueue[head].port_num = entry->port_num;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3d80720..b3f9130 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -896,7 +896,7 @@ struct ib_wc {
 	u32			src_qp;
 	int			wc_flags;
 	u16			pkey_index;
-	u16			slid;
+	u32			slid;
 	u8			sl;
 	u8			dlid_path_bits;
 	u8			port_num;	/* valid only for DR SMPs on switches */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
