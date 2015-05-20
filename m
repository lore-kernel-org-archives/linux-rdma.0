From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/14] IB/mad: Add MAD size parameters to process_mad
Date: Wed, 20 May 2015 04:13:31 -0400
Message-ID: <1432109615-19564-11-git-send-email-ira.weiny@intel.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In support of variable length MADs add in and out MAD size parameters to the
process_mad call.

The out MAD size parameter is passed by reference such that it can be updated
by the agent to indicate the proper response length to be sent by the MAD
stack.

The in and out MAD parameters are made generic by specifying them as
ib_mad_hdr.

Drivers are modified as needed.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                | 26 +++++++++++++++++---------
 drivers/infiniband/core/sysfs.c              |  5 ++++-
 drivers/infiniband/hw/amso1100/c2_provider.c |  5 ++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  5 ++++-
 drivers/infiniband/hw/cxgb4/provider.c       |  7 +++++--
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |  4 ++--
 drivers/infiniband/hw/ehca/ehca_sqp.c        |  9 ++++++++-
 drivers/infiniband/hw/ipath/ipath_mad.c      |  9 ++++++++-
 drivers/infiniband/hw/ipath/ipath_verbs.h    |  3 ++-
 drivers/infiniband/hw/mlx4/mad.c             | 10 +++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 ++-
 drivers/infiniband/hw/mlx5/mad.c             |  9 ++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  3 ++-
 drivers/infiniband/hw/mthca/mthca_dev.h      |  4 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c      | 10 ++++++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  9 ++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h  |  1 +
 drivers/infiniband/hw/qib/qib_mad.c          |  9 ++++++++-
 drivers/infiniband/hw/qib/qib_verbs.h        |  3 ++-
 include/rdma/ib_verbs.h                      |  8 +++++---
 22 files changed, 113 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index cb5c1e484901..a8ea6137771b 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -745,6 +745,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	u8 port_num;
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
+	size_t in_mad_size = max_mad_size(mad_agent_priv->qp_info->port_priv);
+	size_t out_mad_size;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -781,8 +783,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	local->mad_priv = NULL;
 	local->recv_mad_agent = NULL;
 
-	mad_priv = alloc_mad_priv(max_mad_size(mad_agent_priv->qp_info->port_priv),
-				  GFP_ATOMIC);
+	out_mad_size = max_mad_size(mad_agent_priv->qp_info->port_priv);
+	mad_priv = alloc_mad_priv(out_mad_size, GFP_ATOMIC);
 	if (!mad_priv) {
 		ret = -ENOMEM;
 		dev_err(&device->dev, "No memory for local response MAD\n");
@@ -797,8 +799,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 
 	/* No GRH for DR SMP */
 	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
-				  (struct ib_mad *)smp,
-				  (struct ib_mad *)&mad_priv->mad);
+				  (struct ib_mad_hdr *)smp, in_mad_size,
+				  (struct ib_mad_hdr *)&mad_priv->mad,
+				  &out_mad_size);
 	switch (ret)
 	{
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY:
@@ -2017,6 +2020,7 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	struct ib_mad_agent_private *mad_agent;
 	int port_num;
 	int ret = IB_MAD_RESULT_SUCCESS;
+	size_t resp_mad_size;
 
 	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
 	qp_info = mad_list->mad_queue->qp_info;
@@ -2044,7 +2048,8 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	if (!validate_mad(&recv->mad.mad.mad_hdr, qp_info->qp->qp_num))
 		goto out;
 
-	response = alloc_mad_priv(max_mad_size(port_priv), GFP_KERNEL);
+	resp_mad_size = max_mad_size(port_priv);
+	response = alloc_mad_priv(resp_mad_size, GFP_KERNEL);
 	if (!response) {
 		dev_err(&port_priv->device->dev,
 			"ib_mad_recv_done_handler no memory for response buffer\n");
@@ -2069,8 +2074,10 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		ret = port_priv->device->process_mad(port_priv->device, 0,
 						     port_priv->port_num,
 						     wc, &recv->grh,
-						     &recv->mad.mad,
-						     &response->mad.mad);
+						     (struct ib_mad_hdr *)&recv->mad.mad,
+						     max_mad_size(port_priv),
+						     (struct ib_mad_hdr *)&response->mad.mad,
+						     &resp_mad_size);
 		if (ret & IB_MAD_RESULT_SUCCESS) {
 			if (ret & IB_MAD_RESULT_CONSUMED)
 				goto out;
@@ -2693,8 +2700,9 @@ static int ib_mad_post_receive_mads(struct ib_mad_qp_info *qp_info,
 			mad_priv = mad;
 			mad = NULL;
 		} else {
-			mad_priv =
-			alloc_mad_priv(max_mad_size(qp_info->port_priv), GFP_KERNEL);
+			size_t mad_size = max_mad_size(qp_info->port_priv);
+
+			mad_priv = alloc_mad_priv(mad_size, GFP_KERNEL);
 			if (!mad_priv) {
 				dev_err(&qp_info->port_priv->device->dev,
 					"No memory for receive buffer\n");
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index d0334c101ecb..101ba69362e8 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -326,6 +326,7 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	int width  = (tab_attr->index >> 16) & 0xff;
 	struct ib_mad *in_mad  = NULL;
 	struct ib_mad *out_mad = NULL;
+	size_t out_mad_size = sizeof(*out_mad);
 	ssize_t ret;
 
 	if (!p->ibdev->process_mad)
@@ -347,7 +348,9 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	in_mad->data[41] = p->port_num;	/* PortSelect field */
 
 	if ((p->ibdev->process_mad(p->ibdev, IB_MAD_IGNORE_MKEY,
-		 p->port_num, NULL, NULL, in_mad, out_mad) &
+		 p->port_num, NULL, NULL,
+		 (struct ib_mad_hdr *)in_mad, sizeof(*in_mad),
+		 (struct ib_mad_hdr *)out_mad, &out_mad_size) &
 	     (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) !=
 	    (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) {
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index d396c39918de..7a1f92549bfa 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -584,7 +584,10 @@ static int c2_process_mad(struct ib_device *ibdev,
 			  u8 port_num,
 			  struct ib_wc *in_wc,
 			  struct ib_grh *in_grh,
-			  struct ib_mad *in_mad, struct ib_mad *out_mad)
+			  struct ib_mad_hdr *in_mad,
+			  size_t in_mad_size,
+			  struct ib_mad_hdr *out_mad,
+			  size_t *out_mad_size)
 {
 	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 061ef08c92e2..c6b1a36accaa 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -87,7 +87,10 @@ static int iwch_process_mad(struct ib_device *ibdev,
 			    u8 port_num,
 			    struct ib_wc *in_wc,
 			    struct ib_grh *in_grh,
-			    struct ib_mad *in_mad, struct ib_mad *out_mad)
+			    struct ib_mad_hdr *in_mad,
+			    size_t in_mad_size,
+			    struct ib_mad_hdr *out_mad,
+			    size_t *out_mad_size)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ef08a9f29451..12519473d7da 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -81,8 +81,11 @@ static int c4iw_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 
 static int c4iw_process_mad(struct ib_device *ibdev, int mad_flags,
 			    u8 port_num, struct ib_wc *in_wc,
-			    struct ib_grh *in_grh, struct ib_mad *in_mad,
-			    struct ib_mad *out_mad)
+			    struct ib_grh *in_grh,
+			    struct ib_mad_hdr *in_mad,
+			    size_t in_mad_size,
+			    struct ib_mad_hdr *out_mad,
+			    size_t *out_mad_size)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 077185b3fbd6..7ea3ea36a6ef 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -192,8 +192,8 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		     struct ib_wc *in_wc, struct ib_grh *in_grh,
-		     struct ib_mad *in_mad,
-		     struct ib_mad *out_mad);
+		     struct ib_mad_hdr *in, size_t in_mad_size,
+		     struct ib_mad_hdr *out, size_t *out_mad_size);
 
 void ehca_poll_eqs(unsigned long data);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index dba8f9f8b996..76b401720593 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -218,9 +218,16 @@ perf_reply:
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		     struct ib_wc *in_wc, struct ib_grh *in_grh,
-		     struct ib_mad *in_mad, struct ib_mad *out_mad)
+		     struct ib_mad_hdr *in, size_t in_mad_size,
+		     struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	int ret;
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	if (!port_num || port_num > ibdev->phys_port_cnt || !in_wc)
 		return IB_MAD_RESULT_FAILURE;
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index e890e5ba0e01..b384cfd4685e 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1491,9 +1491,16 @@ bail:
  */
 int ipath_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		      struct ib_wc *in_wc, struct ib_grh *in_grh,
-		      struct ib_mad *in_mad, struct ib_mad *out_mad)
+		      struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	int ret;
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index ae6cff4abffc..cd8dd09722f4 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -703,7 +703,8 @@ int ipath_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      struct ib_wc *in_wc,
 		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad, struct ib_mad *out_mad);
+		      struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size);
 
 /*
  * Compare the lower 24 bits of the two values.
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index d44614f9da49..ce1a6105411d 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -868,8 +868,16 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size)
 {
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
+
 	switch (rdma_port_get_link_layer(ibdev, port_num)) {
 	case IB_LINK_LAYER_INFINIBAND:
 		return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index fce3934372a1..a8c92c6d403a 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -710,7 +710,8 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 void *in_mad, void *response_mad);
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad);
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size);
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 9cf9a37bb5ff..76abd14b04c7 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -59,10 +59,17 @@ int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	u16 slid;
 	int err;
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dff1cfcdf476..d6c88b7f9d2d 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -587,7 +587,8 @@ int mlx5_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx5_ib_fmr_dealloc(struct ib_fmr *ibfmr);
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad);
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size);
 struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_ucontext *context,
 					  struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d64ad4e..60d15f13a597 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -578,8 +578,8 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      struct ib_wc *in_wc,
 		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad,
-		      struct ib_mad *out_mad);
+		      struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size);
 int mthca_create_agents(struct mthca_dev *dev);
 void mthca_free_agents(struct mthca_dev *dev);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 2a34cd2f92b7..78504be7fcca 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -198,13 +198,19 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      struct ib_wc *in_wc,
 		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad,
-		      struct ib_mad *out_mad)
+		      struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	int err;
 	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 	u16 prev_lid = 0;
 	struct ib_port_attr pattr;
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	/* Forward locally generated traps to the SM */
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP &&
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 05530e3f6ff0..1eb0bae56381 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3222,7 +3222,8 @@ static int nes_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
  */
 static int nes_process_mad(struct ib_device *ibdev, int mad_flags,
 		u8 port_num, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		struct ib_mad *in_mad, struct ib_mad *out_mad)
+		struct ib_mad_hdr *in, size_t in_mad_size,
+		struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	nes_debug(NES_DBG_INIT, "\n");
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index d812904f3984..74c2f2df7554 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -198,10 +198,17 @@ int ocrdma_process_mad(struct ib_device *ibdev,
 		       u8 port_num,
 		       struct ib_wc *in_wc,
 		       struct ib_grh *in_grh,
-		       struct ib_mad *in_mad, struct ib_mad *out_mad)
+		       struct ib_mad_hdr *in, size_t in_mad_size,
+		       struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	int status;
 	struct ocrdma_dev *dev;
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_PERF_MGMT:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 726a87cf22dc..7c29d17d179b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -44,5 +44,6 @@ int ocrdma_process_mad(struct ib_device *,
 		       u8 port_num,
 		       struct ib_wc *in_wc,
 		       struct ib_grh *in_grh,
-		       struct ib_mad *in_mad, struct ib_mad *out_mad);
+		       struct ib_mad_hdr *in, size_t in_mad_size,
+		       struct ib_mad_hdr *out, size_t *out_mad_size);
 #endif				/* __OCRDMA_AH_H__ */
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
index 091edd68a8a3..42e9f0d5da9b 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
@@ -29,6 +29,7 @@
 #define __OCRDMA_STATS_H__
 
 #include <linux/debugfs.h>
+#include <rdma/ib_mad.h>
 #include "ocrdma.h"
 #include "ocrdma_hw.h"
 
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 8dc3bc213845..13eefcee33dc 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2402,11 +2402,18 @@ bail:
  */
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 		    struct ib_wc *in_wc, struct ib_grh *in_grh,
-		    struct ib_mad *in_mad, struct ib_mad *out_mad)
+		    struct ib_mad_hdr *in, size_t in_mad_size,
+		    struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	int ret;
 	struct qib_ibport *ibp = to_iport(ibdev, port);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (WARN_ON(in_mad_size != sizeof(*in_mad) ||
+		    *out_mad_size != sizeof(*out_mad)))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bfc8948fdd35..77f1d313932a 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -873,7 +873,8 @@ void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    struct ib_wc *in_wc, struct ib_grh *in_grh,
-		    struct ib_mad *in_mad, struct ib_mad *out_mad);
+		    struct ib_mad_hdr *in, size_t in_mad_size,
+		    struct ib_mad_hdr *out, size_t *out_mad_size);
 int qib_create_agents(struct qib_ibdev *dev);
 void qib_free_agents(struct qib_ibdev *dev);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8859afea4e2f..7b1dcb380987 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1452,7 +1452,7 @@ struct ib_flow {
 	struct ib_uobject	*uobject;
 };
 
-struct ib_mad;
+struct ib_mad_hdr;
 struct ib_grh;
 
 enum ib_process_mad_flags {
@@ -1693,8 +1693,10 @@ struct ib_device {
 						  u8 port_num,
 						  struct ib_wc *in_wc,
 						  struct ib_grh *in_grh,
-						  struct ib_mad *in_mad,
-						  struct ib_mad *out_mad);
+						  struct ib_mad_hdr *in_mad,
+						  size_t in_mad_size,
+						  struct ib_mad_hdr *out_mad,
+						  size_t *out_mad_size);
 	struct ib_xrcd *	   (*alloc_xrcd)(struct ib_device *device,
 						 struct ib_ucontext *ucontext,
 						 struct ib_udata *udata);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
