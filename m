From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/14] IB/mad: Add base version to ib_create_send_mad
Date: Wed, 20 May 2015 04:13:28 -0400
Message-ID: <1432109615-19564-8-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In preparation to support the new OPA MAD Base version, add a base version
parameter to ib_create_send_mad and set it to IB_MGMT_BASE_VERSION for current
users.

Definition of the new base version and it's processing will occur in later
patches.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/agent.c         | 3 ++-
 drivers/infiniband/core/cm.c            | 6 ++++--
 drivers/infiniband/core/mad.c           | 3 ++-
 drivers/infiniband/core/mad_rmpp.c      | 6 ++++--
 drivers/infiniband/core/sa_query.c      | 3 ++-
 drivers/infiniband/core/user_mad.c      | 3 ++-
 drivers/infiniband/hw/mlx4/mad.c        | 3 ++-
 drivers/infiniband/hw/mthca/mthca_mad.c | 3 ++-
 drivers/infiniband/hw/qib/qib_iba7322.c | 3 ++-
 drivers/infiniband/hw/qib/qib_mad.c     | 3 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c   | 3 ++-
 include/rdma/ib_mad.h                   | 4 +++-
 12 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/agent.c b/drivers/infiniband/core/agent.c
index a6fc4d6dc7d7..5c7627c3278c 100644
--- a/drivers/infiniband/core/agent.c
+++ b/drivers/infiniband/core/agent.c
@@ -108,7 +108,8 @@ void agent_send_response(struct ib_mad *mad, struct ib_grh *grh,
 
 	send_buf = ib_create_send_mad(agent, wc->src_qp, wc->pkey_index, 0,
 				      IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-				      GFP_KERNEL);
+				      GFP_KERNEL,
+				      IB_MGMT_BASE_VERSION);
 	if (IS_ERR(send_buf)) {
 		dev_err(&device->dev, "ib_create_send_mad error\n");
 		goto err1;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c3be6663f4f5..dbddddd6fb5d 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -267,7 +267,8 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 	m = ib_create_send_mad(mad_agent, cm_id_priv->id.remote_cm_qpn,
 			       cm_id_priv->av.pkey_index,
 			       0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-			       GFP_ATOMIC);
+			       GFP_ATOMIC,
+			       IB_MGMT_BASE_VERSION);
 	if (IS_ERR(m)) {
 		ib_destroy_ah(ah);
 		return PTR_ERR(m);
@@ -297,7 +298,8 @@ static int cm_alloc_response_msg(struct cm_port *port,
 
 	m = ib_create_send_mad(port->mad_agent, 1, mad_recv_wc->wc->pkey_index,
 			       0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
-			       GFP_ATOMIC);
+			       GFP_ATOMIC,
+			       IB_MGMT_BASE_VERSION);
 	if (IS_ERR(m)) {
 		ib_destroy_ah(ah);
 		return PTR_ERR(m);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 96daba58afad..8055195b5d60 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -920,7 +920,8 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 					    u32 remote_qpn, u16 pkey_index,
 					    int rmpp_active,
 					    int hdr_len, int data_len,
-					    gfp_t gfp_mask)
+					    gfp_t gfp_mask,
+					    u8 base_version)
 {
 	struct ib_mad_agent_private *mad_agent_priv;
 	struct ib_mad_send_wr_private *mad_send_wr;
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 13279826342f..9c284d9b4fa9 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -139,7 +139,8 @@ static void ack_recv(struct mad_rmpp_recv *rmpp_recv,
 	hdr_len = ib_get_mad_data_offset(recv_wc->recv_buf.mad->mad_hdr.mgmt_class);
 	msg = ib_create_send_mad(&rmpp_recv->agent->agent, recv_wc->wc->src_qp,
 				 recv_wc->wc->pkey_index, 1, hdr_len,
-				 0, GFP_KERNEL);
+				 0, GFP_KERNEL,
+				 IB_MGMT_BASE_VERSION);
 	if (IS_ERR(msg))
 		return;
 
@@ -165,7 +166,8 @@ static struct ib_mad_send_buf *alloc_response_msg(struct ib_mad_agent *agent,
 	hdr_len = ib_get_mad_data_offset(recv_wc->recv_buf.mad->mad_hdr.mgmt_class);
 	msg = ib_create_send_mad(agent, recv_wc->wc->src_qp,
 				 recv_wc->wc->pkey_index, 1,
-				 hdr_len, 0, GFP_KERNEL);
+				 hdr_len, 0, GFP_KERNEL,
+				 IB_MGMT_BASE_VERSION);
 	if (IS_ERR(msg))
 		ib_destroy_ah(ah);
 	else {
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 7f7c8c9fa92c..78fbedd8d013 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -583,7 +583,8 @@ static int alloc_mad(struct ib_sa_query *query, gfp_t gfp_mask)
 	query->mad_buf = ib_create_send_mad(query->port->agent, 1,
 					    query->sm_ah->pkey_index,
 					    0, IB_MGMT_SA_HDR, IB_MGMT_SA_DATA,
-					    gfp_mask);
+					    gfp_mask,
+					    IB_MGMT_BASE_VERSION);
 	if (IS_ERR(query->mad_buf)) {
 		kref_put(&query->sm_ah->ref, free_sm_ah);
 		return -ENOMEM;
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index acff2f4bb6dd..6be72a563c61 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -520,7 +520,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	packet->msg = ib_create_send_mad(agent,
 					 be32_to_cpu(packet->mad.hdr.qpn),
 					 packet->mad.hdr.pkey_index, rmpp_active,
-					 hdr_len, data_len, GFP_KERNEL);
+					 hdr_len, data_len, GFP_KERNEL,
+					 IB_MGMT_BASE_VERSION);
 	if (IS_ERR(packet->msg)) {
 		ret = PTR_ERR(packet->msg);
 		goto err_ah;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9cd2b002d7ae..d44614f9da49 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -366,7 +366,8 @@ static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *ma
 
 	if (agent) {
 		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
-					      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+					      IB_MGMT_MAD_DATA, GFP_ATOMIC,
+					      IB_MGMT_BASE_VERSION);
 		if (IS_ERR(send_buf))
 			return;
 		/*
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 8881fa376e06..2a34cd2f92b7 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -170,7 +170,8 @@ static void forward_trap(struct mthca_dev *dev,
 
 	if (agent) {
 		send_buf = ib_create_send_mad(agent, qpn, 0, 0, IB_MGMT_MAD_HDR,
-					      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+					      IB_MGMT_MAD_DATA, GFP_ATOMIC,
+					      IB_MGMT_BASE_VERSION);
 		if (IS_ERR(send_buf))
 			return;
 		/*
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index f32b4628e991..6c8ff10101c0 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -5502,7 +5502,8 @@ static void try_7322_ipg(struct qib_pportdata *ppd)
 		goto retry;
 
 	send_buf = ib_create_send_mad(agent, 0, 0, 0, IB_MGMT_MAD_HDR,
-				      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+				      IB_MGMT_MAD_DATA, GFP_ATOMIC,
+				      IB_MGMT_BASE_VERSION);
 	if (IS_ERR(send_buf))
 		goto retry;
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 395f4046dba2..8dc3bc213845 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -83,7 +83,8 @@ static void qib_send_trap(struct qib_ibport *ibp, void *data, unsigned len)
 		return;
 
 	send_buf = ib_create_send_mad(agent, 0, 0, 0, IB_MGMT_MAD_HDR,
-				      IB_MGMT_MAD_DATA, GFP_ATOMIC);
+				      IB_MGMT_MAD_DATA, GFP_ATOMIC,
+				      IB_MGMT_BASE_VERSION);
 	if (IS_ERR(send_buf))
 		return;
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9b84b4c0a000..68201d69d99e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -476,7 +476,8 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 	rsp = ib_create_send_mad(mad_agent, mad_wc->wc->src_qp,
 				 mad_wc->wc->pkey_index, 0,
 				 IB_MGMT_DEVICE_HDR, IB_MGMT_DEVICE_DATA,
-				 GFP_KERNEL);
+				 GFP_KERNEL,
+				 IB_MGMT_BASE_VERSION);
 	if (IS_ERR(rsp))
 		goto err_rsp;
 
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 1b37b493b2b4..ddc82d65a9e5 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -622,6 +622,7 @@ int ib_process_mad_wc(struct ib_mad_agent *mad_agent,
  *   automatically adjust the allocated buffer size to account for any
  *   additional padding that may be necessary.
  * @gfp_mask: GFP mask used for the memory allocation.
+ * @base_version: Base Version of this MAD
  *
  * This routine allocates a MAD for sending.  The returned MAD send buffer
  * will reference a data buffer usable for sending a MAD, along
@@ -637,7 +638,8 @@ struct ib_mad_send_buf *ib_create_send_mad(struct ib_mad_agent *mad_agent,
 					   u32 remote_qpn, u16 pkey_index,
 					   int rmpp_active,
 					   int hdr_len, int data_len,
-					   gfp_t gfp_mask);
+					   gfp_t gfp_mask,
+					   u8 base_version);
 
 /**
  * ib_is_mad_class_rmpp - returns whether given management class
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
