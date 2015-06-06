From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/14] IB/mad: Add support for additional MAD info to/from drivers
Date: Sat,  6 Jun 2015 14:38:31 -0400
Message-ID: <1433615915-24591-11-git-send-email-ira.weiny@intel.com>
References: <1433615915-24591-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433615915-24591-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to support alternate sized MADs (and variable sized MADs on OPA
devices) add in/out MAD size parameters to the process_mad core call.

In addition, add an out_mad_pkey_index to communicate the pkey index the driver
wishes the MAD stack to use when sending OPA MAD responses.

The out MAD size and the out MAD PKey index are required by the MAD
stack to generate responses on OPA devices.

Furthermore, the in and out MAD parameters are made generic by specifying them
as ib_mad_hdr rather than ib_mad.

Drivers are modified as needed and are protected by BUG_ON flags if the MAD
sizes passed to them is incorrect.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since V1:
	Add const to the in MAD paramter
	Change WARN_ON to BUG_ON in drivers
	Maintain const struct ib_mad through casts
	Add out_mad_pkey_index
	Update commit message

 drivers/infiniband/core/mad.c                | 17 ++++++++++++-----
 drivers/infiniband/core/sysfs.c              |  7 ++++++-
 drivers/infiniband/hw/amso1100/c2_provider.c |  6 +++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  6 +++++-
 drivers/infiniband/hw/cxgb4/provider.c       |  7 +++++--
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |  5 +++--
 drivers/infiniband/hw/ehca/ehca_sqp.c        |  9 ++++++++-
 drivers/infiniband/hw/ipath/ipath_mad.c      |  9 ++++++++-
 drivers/infiniband/hw/ipath/ipath_verbs.h    |  4 +++-
 drivers/infiniband/hw/mlx4/mad.c             | 10 +++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  4 +++-
 drivers/infiniband/hw/mlx5/mad.c             |  9 ++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h         |  4 +++-
 drivers/infiniband/hw/mthca/mthca_dev.h      |  5 +++--
 drivers/infiniband/hw/mthca/mthca_mad.c      | 10 ++++++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  4 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  9 ++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h     |  4 +++-
 drivers/infiniband/hw/qib/qib_mad.c          |  9 ++++++++-
 drivers/infiniband/hw/qib/qib_verbs.h        |  4 +++-
 include/rdma/ib_verbs.h                      |  9 ++++++---
 21 files changed, 120 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 64b66ffae2cb..e072d2a94690 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -761,6 +761,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
 	size_t mad_size = port_mad_size(mad_agent_priv->qp_info->port_priv);
+	u16 out_mad_pkey_index = 0;
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -811,8 +812,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 
 	/* No GRH for DR SMP */
 	ret = device->process_mad(device, 0, port_num, &mad_wc, NULL,
-				  (const struct ib_mad *)smp,
-				  (struct ib_mad *)mad_priv->mad);
+				  (const struct ib_mad_hdr *)smp, mad_size,
+				  (struct ib_mad_hdr *)mad_priv->mad,
+				  &mad_size, &out_mad_pkey_index);
 	switch (ret)
 	{
 	case IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY:
@@ -2030,6 +2032,8 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	struct ib_mad_agent_private *mad_agent;
 	int port_num;
 	int ret = IB_MAD_RESULT_SUCCESS;
+	size_t mad_size;
+	u16 resp_mad_pkey_index = 0;
 
 	mad_list = (struct ib_mad_list_head *)(unsigned long)wc->wr_id;
 	qp_info = mad_list->mad_queue->qp_info;
@@ -2057,7 +2061,8 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 	if (!validate_mad((const struct ib_mad_hdr *)recv->mad, qp_info->qp->qp_num))
 		goto out;
 
-	response = alloc_mad_private(recv->mad_size, GFP_ATOMIC);
+	mad_size = recv->mad_size;
+	response = alloc_mad_private(mad_size, GFP_KERNEL);
 	if (!response) {
 		dev_err(&port_priv->device->dev,
 			"ib_mad_recv_done_handler no memory for response buffer\n");
@@ -2082,8 +2087,10 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 		ret = port_priv->device->process_mad(port_priv->device, 0,
 						     port_priv->port_num,
 						     wc, &recv->grh,
-						     (const struct ib_mad *)recv->mad,
-						     (struct ib_mad *)response->mad);
+						     (const struct ib_mad_hdr *)recv->mad,
+						     recv->mad_size,
+						     (struct ib_mad_hdr *)response->mad,
+						     &mad_size, &resp_mad_pkey_index);
 		if (ret & IB_MAD_RESULT_SUCCESS) {
 			if (ret & IB_MAD_RESULT_CONSUMED)
 				goto out;
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index d0334c101ecb..ed6b6c85c334 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -326,6 +326,8 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	int width  = (tab_attr->index >> 16) & 0xff;
 	struct ib_mad *in_mad  = NULL;
 	struct ib_mad *out_mad = NULL;
+	size_t mad_size = sizeof(*out_mad);
+	u16 out_mad_pkey_index = 0;
 	ssize_t ret;
 
 	if (!p->ibdev->process_mad)
@@ -347,7 +349,10 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	in_mad->data[41] = p->port_num;	/* PortSelect field */
 
 	if ((p->ibdev->process_mad(p->ibdev, IB_MAD_IGNORE_MKEY,
-		 p->port_num, NULL, NULL, in_mad, out_mad) &
+		 p->port_num, NULL, NULL,
+		 (const struct ib_mad_hdr *)in_mad, mad_size,
+		 (struct ib_mad_hdr *)out_mad, &mad_size,
+		 &out_mad_pkey_index) &
 	     (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) !=
 	    (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) {
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 0f007a6b188b..eac836286fd7 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -584,7 +584,11 @@ static int c2_process_mad(struct ib_device *ibdev,
 			  u8 port_num,
 			  const struct ib_wc *in_wc,
 			  const struct ib_grh *in_grh,
-			  const struct ib_mad *in_mad, struct ib_mad *out_mad)
+			  const struct ib_mad_hdr *in_mad,
+			  size_t in_mad_size,
+			  struct ib_mad_hdr *out_mad,
+			  size_t *out_mad_size,
+			  u16 *out_mad_pkey_index)
 {
 	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 19c830ecbb67..8b6504095414 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -87,7 +87,11 @@ static int iwch_process_mad(struct ib_device *ibdev,
 			    u8 port_num,
 			    const struct ib_wc *in_wc,
 			    const struct ib_grh *in_grh,
-			    const struct ib_mad *in_mad, struct ib_mad *out_mad)
+			    const struct ib_mad_hdr *in_mad,
+			    size_t in_mad_size,
+			    struct ib_mad_hdr *out_mad,
+			    size_t *out_mad_size,
+			    u16 *out_mad_pkey_index)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 75ea26a32076..02aad989c75b 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -82,8 +82,11 @@ static int c4iw_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 static int c4iw_process_mad(struct ib_device *ibdev, int mad_flags,
 			    u8 port_num, const struct ib_wc *in_wc,
 			    const struct ib_grh *in_grh,
-			    const struct ib_mad *in_mad,
-			    struct ib_mad *out_mad)
+			    const struct ib_mad_hdr *in_mad,
+			    size_t in_mad_size,
+			    struct ib_mad_hdr *out_mad,
+			    size_t *out_mad_size,
+			    u16 *out_mad_pkey_index)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 582fc71a8488..0931203d6478 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -192,8 +192,9 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		     const struct ib_mad *in_mad,
-		     struct ib_mad *out_mad);
+		     const struct ib_mad_hdr *in, size_t in_mad_size,
+		     struct ib_mad_hdr *out, size_t *out_mad_size,
+		     u16 *out_mad_pkey_index);
 
 void ehca_poll_eqs(unsigned long data);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index 889ccfda6401..12b5bc23832b 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -218,9 +218,16 @@ perf_reply:
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		     const struct ib_mad *in_mad, struct ib_mad *out_mad)
+		     const struct ib_mad_hdr *in, size_t in_mad_size,
+		     struct ib_mad_hdr *out, size_t *out_mad_size,
+		     u16 *out_mad_pkey_index)
 {
 	int ret;
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	if (!port_num || port_num > ibdev->phys_port_cnt || !in_wc)
 		return IB_MAD_RESULT_FAILURE;
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index 9e8929e23740..948188e37f95 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1491,9 +1491,16 @@ bail:
  */
 int ipath_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		      const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		      const struct ib_mad *in_mad, struct ib_mad *out_mad)
+		      const struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size,
+		      u16 *out_mad_pkey_index)
 {
 	int ret;
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index 7a2b6a17f844..6c3f4d9179b2 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -703,7 +703,9 @@ int ipath_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      const struct ib_wc *in_wc,
 		      const struct ib_grh *in_grh,
-		      const struct ib_mad *in_mad, struct ib_mad *out_mad);
+		      const struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size,
+		      u16 *out_mad_pkey_index);
 
 /*
  * Compare the lower 24 bits of the two values.
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 6ac41cc15872..e960085bef64 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -869,8 +869,16 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-			const struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size,
+			u16 *out_mad_pkey_index)
 {
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
+
 	switch (rdma_port_get_link_layer(ibdev, port_num)) {
 	case IB_LINK_LAYER_INFINIBAND:
 		return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 645d55ef0604..298883bb0c7e 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -710,7 +710,9 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 const void *in_mad, void *response_mad);
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-			const struct ib_mad *in_mad, struct ib_mad *out_mad);
+			const struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size,
+			u16 *out_mad_pkey_index);
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 34e519cd4c64..8e45714fa369 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -59,10 +59,17 @@ int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-			const struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size,
+			u16 *out_mad_pkey_index)
 {
 	u16 slid;
 	int err;
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index c6219032d00c..1013944d3180 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -587,7 +587,9 @@ int mlx5_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx5_ib_fmr_dealloc(struct ib_fmr *ibfmr);
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-			const struct ib_mad *in_mad, struct ib_mad *out_mad);
+			const struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size,
+			u16 *out_mad_pkey_index);
 struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_ucontext *context,
 					  struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index b70f9ff23171..4393a022867b 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -578,8 +578,9 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      const struct ib_wc *in_wc,
 		      const struct ib_grh *in_grh,
-		      const struct ib_mad *in_mad,
-		      struct ib_mad *out_mad);
+		      const struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size,
+		      u16 *out_mad_pkey_index);
 int mthca_create_agents(struct mthca_dev *dev);
 void mthca_free_agents(struct mthca_dev *dev);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index e121e646591d..6b2418b74c99 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -198,13 +198,19 @@ int mthca_process_mad(struct ib_device *ibdev,
 		      u8 port_num,
 		      const struct ib_wc *in_wc,
 		      const struct ib_grh *in_grh,
-		      const struct ib_mad *in_mad,
-		      struct ib_mad *out_mad)
+		      const struct ib_mad_hdr *in, size_t in_mad_size,
+		      struct ib_mad_hdr *out, size_t *out_mad_size,
+		      u16 *out_mad_pkey_index)
 {
 	int err;
 	u16 slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 	u16 prev_lid = 0;
 	struct ib_port_attr pattr;
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	/* Forward locally generated traps to the SM */
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP &&
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 0099e419e24f..3fec491a332c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3222,7 +3222,9 @@ static int nes_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
  */
 static int nes_process_mad(struct ib_device *ibdev, int mad_flags,
 		u8 port_num, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		const struct ib_mad *in_mad, struct ib_mad *out_mad)
+		const struct ib_mad_hdr *in, size_t in_mad_size,
+		struct ib_mad_hdr *out, size_t *out_mad_size,
+		u16 *out_mad_pkey_index)
 {
 	nes_debug(NES_DBG_INIT, "\n");
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index 3216bce08a10..5f8a8dd423fc 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -198,10 +198,17 @@ int ocrdma_process_mad(struct ib_device *ibdev,
 		       u8 port_num,
 		       const struct ib_wc *in_wc,
 		       const struct ib_grh *in_grh,
-		       const struct ib_mad *in_mad, struct ib_mad *out_mad)
+		       const struct ib_mad_hdr *in, size_t in_mad_size,
+		       struct ib_mad_hdr *out, size_t *out_mad_size,
+		       u16 *out_mad_pkey_index)
 {
 	int status;
 	struct ocrdma_dev *dev;
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_PERF_MGMT:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 5c4ae3eba47c..cf366fe03cb8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -44,5 +44,7 @@ int ocrdma_process_mad(struct ib_device *,
 		       u8 port_num,
 		       const struct ib_wc *in_wc,
 		       const struct ib_grh *in_grh,
-		       const struct ib_mad *in_mad, struct ib_mad *out_mad);
+		       const struct ib_mad_hdr *in, size_t in_mad_size,
+		       struct ib_mad_hdr *out, size_t *out_mad_size,
+		       u16 *out_mad_pkey_index);
 #endif				/* __OCRDMA_AH_H__ */
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 206b2050b247..05e3242d8442 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2402,11 +2402,18 @@ bail:
  */
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		    const struct ib_mad *in_mad, struct ib_mad *out_mad)
+		    const struct ib_mad_hdr *in, size_t in_mad_size,
+		    struct ib_mad_hdr *out, size_t *out_mad_size,
+		    u16 *out_mad_pkey_index)
 {
 	int ret;
 	struct qib_ibport *ibp = to_iport(ibdev, port);
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
+	const struct ib_mad *in_mad = (const struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	BUG_ON(in_mad_size != sizeof(*in_mad) ||
+	       *out_mad_size != sizeof(*out_mad));
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index f2f57749c07d..f6e8b0b9d947 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -873,7 +873,9 @@ void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
-		    const struct ib_mad *in_mad, struct ib_mad *out_mad);
+		    const struct ib_mad_hdr *in, size_t in_mad_size,
+		    struct ib_mad_hdr *out, size_t *out_mad_size,
+		    u16 *out_mad_pkey_index);
 int qib_create_agents(struct qib_ibdev *dev);
 void qib_free_agents(struct qib_ibdev *dev);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f054f2db7084..594d4d5665de 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1452,7 +1452,7 @@ struct ib_flow {
 	struct ib_uobject	*uobject;
 };
 
-struct ib_mad;
+struct ib_mad_hdr;
 struct ib_grh;
 
 enum ib_process_mad_flags {
@@ -1693,8 +1693,11 @@ struct ib_device {
 						  u8 port_num,
 						  const struct ib_wc *in_wc,
 						  const struct ib_grh *in_grh,
-						  const struct ib_mad *in_mad,
-						  struct ib_mad *out_mad);
+						  const struct ib_mad_hdr *in_mad,
+						  size_t in_mad_size,
+						  struct ib_mad_hdr *out_mad,
+						  size_t *out_mad_size,
+						  u16 *out_mad_pkey_index);
 	struct ib_xrcd *	   (*alloc_xrcd)(struct ib_device *device,
 						 struct ib_ucontext *ucontext,
 						 struct ib_udata *udata);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
