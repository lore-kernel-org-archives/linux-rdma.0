From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 05/11] IB/core: Change lid size in struct ib_wc from 16 to 32 bits
Date: Fri, 23 Sep 2016 13:44:28 -0400
Message-ID: <1474652674-13110-6-git-send-email-ira.weiny@intel.com>
References: <1474652674-13110-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474652674-13110-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
 drivers/infiniband/hw/hfi1/hfi.h        | 2 +-
 drivers/infiniband/hw/hfi1/mad.c        | 2 +-
 drivers/infiniband/hw/mlx4/mad.c        | 6 +++---
 drivers/infiniband/hw/mlx5/mad.c        | 2 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c | 4 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c | 2 +-
 drivers/infiniband/sw/rdmavt/cq.c       | 2 +-
 include/rdma/ib_verbs.h                 | 2 +-
 12 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c99525512b34..137c4c27469e 100644
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
index 382941b46e43..1fc9469b5e66 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -316,7 +316,7 @@ create_rmpp_recv(struct ib_mad_agent_private *agent,
 	mad_hdr = &mad_recv_wc->recv_buf.mad->mad_hdr;
 	rmpp_recv->tid = mad_hdr->tid;
 	rmpp_recv->src_qp = mad_recv_wc->wc->src_qp;
-	rmpp_recv->slid = mad_recv_wc->wc->slid;
+	rmpp_recv->slid = (u16)mad_recv_wc->wc->slid;
 	rmpp_recv->mgmt_class = mad_hdr->mgmt_class;
 	rmpp_recv->class_version = mad_hdr->class_version;
 	rmpp_recv->method  = mad_hdr->method;
@@ -337,7 +337,7 @@ find_rmpp_recv(struct ib_mad_agent_private *agent,
 	list_for_each_entry(rmpp_recv, &agent->rmpp_list, list) {
 		if (rmpp_recv->tid == mad_hdr->tid &&
 		    rmpp_recv->src_qp == mad_recv_wc->wc->src_qp &&
-		    rmpp_recv->slid == mad_recv_wc->wc->slid &&
+		    rmpp_recv->slid == (u16)mad_recv_wc->wc->slid &&
 		    rmpp_recv->mgmt_class == mad_hdr->mgmt_class &&
 		    rmpp_recv->class_version == mad_hdr->class_version &&
 		    rmpp_recv->method == mad_hdr->method)
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 415a3185cde7..2a0b92866116 100644
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
index 286ba8ca8cbd..4721f8639e68 100644
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
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 7eef11b316ff..57ebbec2840c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1448,7 +1448,7 @@ static int ingress_pkey_table_search(struct hfi1_pportdata *ppd, u16 pkey)
  * the 'error info' for this failure.
  */
 static void ingress_pkey_table_fail(struct hfi1_pportdata *ppd, u16 pkey,
-				    u16 slid)
+				    u32 slid)
 {
 	struct hfi1_devdata *dd = ppd->dd;
 
diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
index 9487c9bb8920..865f5ee4855f 100644
--- a/drivers/infiniband/hw/hfi1/mad.c
+++ b/drivers/infiniband/hw/hfi1/mad.c
@@ -3974,7 +3974,7 @@ static int opa_local_smp_check(struct hfi1_ibport *ibp,
 			       const struct ib_wc *in_wc)
 {
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
-	u16 slid = in_wc->slid;
+	u32 slid = in_wc->slid;
 	u16 pkey;
 
 	if (in_wc->pkey_index >= ARRAY_SIZE(ppd->pkeys))
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 39c098a9c3d5..b420f77de1d4 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -167,7 +167,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 
 		op_modifier |= 0x4;
 
-		in_modifier |= in_wc->slid << 16;
+		in_modifier |= (u16)in_wc->slid << 16;
 	}
 
 	err = mlx4_cmd_box(dev->dev, inmailbox->dma, outmailbox->dma, in_modifier,
@@ -572,7 +572,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 		memcpy((char *)&tun_mad->hdr.slid_mac_47_32, &(wc->smac[4]), 2);
 	} else {
 		tun_mad->hdr.sl_vid = cpu_to_be16(((u16)(wc->sl)) << 12);
-		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16(wc->slid);
+		tun_mad->hdr.slid_mac_47_32 = cpu_to_be16((u16)wc->slid);
 	}
 
 	ib_dma_sync_single_for_device(&dev->ib_dev,
@@ -760,7 +760,7 @@ static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		}
 	}
 
-	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+	slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP && slid == 0) {
 		forward_trap(to_mdev(ibdev), port_num, in_mad);
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 364aab9f3c9e..b42b26ba3a95 100644
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
index c7f49bbb0c72..d07f389aefb6 100644
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
index ad63fa406d45..90706e3ec92c 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -203,7 +203,7 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u16 *out_mad_pkey_index)
 {
 	int err;
-	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
+	u16 slid = in_wc ? (u16)in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 	u16 prev_lid = 0;
 	struct ib_port_attr pattr;
 	const struct ib_mad *in_mad = (const struct ib_mad *)in;
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index f2f229efbe64..5236468684c9 100644
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
index 75ddef64fea7..69d7e39c4f85 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -882,7 +882,7 @@ struct ib_wc {
 	u32			src_qp;
 	int			wc_flags;
 	u16			pkey_index;
-	u16			slid;
+	u32			slid;
 	u8			sl;
 	u8			dlid_path_bits;
 	u8			port_num;	/* valid only for DR SMPs on switches */
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
