From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 05/16] ib/mad: Add MAD size parameters to process_mad
Date: Thu, 13 Nov 2014 14:54:14 -0500
Message-ID: <1415908465-24392-6-git-send-email-ira.weiny@intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415908465-24392-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In support of variable length MADs add in and out MAD size parameters to the
process_mad call.

The out MAD size parameter is passed by reference such that it can be updated
by the agent to indicate the proper response length to be sent by the MAD
stack.

The in and out MAD parameters are made generic by specifying them as
ib_mad_hdr.

Finally all MAD sizes are set to the current IB MAD size and devices which use
MADs are modified to verify the MAD sizes passed to them.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                | 14 ++++++++++----
 drivers/infiniband/core/sysfs.c              |  4 +++-
 drivers/infiniband/hw/amso1100/c2_provider.c |  5 ++++-
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  5 ++++-
 drivers/infiniband/hw/cxgb4/provider.c       |  7 +++++--
 drivers/infiniband/hw/ehca/ehca_sqp.c        |  8 +++++++-
 drivers/infiniband/hw/ipath/ipath_mad.c      |  8 +++++++-
 drivers/infiniband/hw/ipath/ipath_verbs.h    |  3 ++-
 drivers/infiniband/hw/mlx4/mad.c             |  9 ++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h         |  3 ++-
 drivers/infiniband/hw/mlx5/mad.c             |  8 +++++++-
 drivers/infiniband/hw/mthca/mthca_dev.h      |  4 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c      |  9 +++++++--
 drivers/infiniband/hw/nes/nes_verbs.c        |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c     |  3 ++-
 drivers/infiniband/hw/qib/qib_mad.c          |  8 +++++++-
 drivers/infiniband/hw/qib/qib_verbs.h        |  3 ++-
 include/rdma/ib_verbs.h                      |  8 +++++---
 18 files changed, 86 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 0cb91fc..59ea90d 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -736,6 +736,8 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 	u8 port_num;
 	struct ib_wc mad_wc;
 	struct ib_send_wr *send_wr = &mad_send_wr->send_wr;
+	size_t in_mad_size = sizeof(struct ib_mad);
+	size_t out_mad_size = sizeof(struct ib_mad);
 
 	if (device->node_type == RDMA_NODE_IB_SWITCH &&
 	    smp->mgmt_class == IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)
@@ -786,8 +788,9 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 
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
@@ -2038,11 +2041,14 @@ static void ib_mad_recv_done_handler(struct ib_mad_port_private *port_priv,
 local:
 	/* Give driver "right of first refusal" on incoming MAD */
 	if (port_priv->device->process_mad) {
+		size_t resp_mad_size = sizeof(struct ib_mad);
 		ret = port_priv->device->process_mad(port_priv->device, 0,
 						     port_priv->port_num,
 						     wc, &recv->grh,
-						     &recv->mad.mad,
-						     &response->mad.mad);
+						     (struct ib_mad_hdr *)&recv->mad.mad,
+						     sizeof(struct ib_mad),
+						     (struct ib_mad_hdr *)&response->mad.mad,
+						     &resp_mad_size);
 		if (ret & IB_MAD_RESULT_SUCCESS) {
 			if (ret & IB_MAD_RESULT_CONSUMED)
 				goto out;
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cbd0383..fbe2dc5 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -347,7 +347,9 @@ static ssize_t show_pma_counter(struct ib_port *p, struct port_attribute *attr,
 	in_mad->data[41] = p->port_num;	/* PortSelect field */
 
 	if ((p->ibdev->process_mad(p->ibdev, IB_MAD_IGNORE_MKEY,
-		 p->port_num, NULL, NULL, in_mad, out_mad) &
+		 p->port_num, NULL, NULL,
+		 (struct ib_mad_hdr *)in_mad, sizeof(*in_mad),
+		 (struct ib_mad_hdr *)out_mad, NULL) &
 	     (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) !=
 	    (IB_MAD_RESULT_SUCCESS | IB_MAD_RESULT_REPLY)) {
 		ret = -EINVAL;
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 2d5cbf4..e982cb2 100644
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
index 811b24a..30c157a 100644
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
index 72e3b69..673d6e178 100644
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
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index dba8f9f..d4ed490 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -218,9 +218,15 @@ perf_reply:
 
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
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
 
 	if (!port_num || port_num > ibdev->phys_port_cnt || !in_wc)
 		return IB_MAD_RESULT_FAILURE;
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index e890e5b..d554089 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1491,9 +1491,15 @@ bail:
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
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index ae6cff4..cd8dd09 100644
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
index 9098906..cd97722 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -856,8 +856,15 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size)
 {
+	struct ib_mad *in_mad = (struct ib_mad *)in;
+	struct ib_mad *out_mad = (struct ib_mad *)out;
+
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
+
 	switch (rdma_port_get_link_layer(ibdev, port_num)) {
 	case IB_LINK_LAYER_INFINIBAND:
 		return ib_process_mad(ibdev, mad_flags, port_num, in_wc,
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 6eb743f..c5960fe 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -690,7 +690,8 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 		 void *in_mad, void *response_mad);
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
 			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad);
+			struct ib_mad_hdr *in, size_t in_mad_size,
+			struct ib_mad_hdr *out, size_t *out_mad_size);
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index b514bbb..69d1827 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -59,10 +59,16 @@ int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 
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
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
 
 	slid = in_wc ? in_wc->slid : be16_to_cpu(IB_LID_PERMISSIVE);
 
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d6..60d15f1 100644
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
index 2a34cd2..83817da 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -198,13 +198,18 @@ int mthca_process_mad(struct ib_device *ibdev,
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
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
 
 	/* Forward locally generated traps to the SM */
 	if (in_mad->mad_hdr.method == IB_MGMT_METHOD_TRAP &&
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fef067c..73bc51a 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3223,7 +3223,8 @@ static int nes_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
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
index ac02ce4..5606fa5 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -192,7 +192,8 @@ int ocrdma_process_mad(struct ib_device *ibdev,
 		       u8 port_num,
 		       struct ib_wc *in_wc,
 		       struct ib_grh *in_grh,
-		       struct ib_mad *in_mad, struct ib_mad *out_mad)
+		       struct ib_mad_hdr *in, size_t in_mad_size,
+		       struct ib_mad_hdr *out, size_t *out_mad_size)
 {
 	return IB_MAD_RESULT_SUCCESS;
 }
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 2861304..cfc1be7 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -2402,11 +2402,17 @@ bail:
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
+	if (in_mad_size != sizeof(*in_mad) || *out_mad_size != sizeof(*out_mad))
+		return IB_MAD_RESULT_FAILURE;
 
 	switch (in_mad->mad_hdr.mgmt_class) {
 	case IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE:
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bfc8948..77f1d31 100644
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
index 04be3c8..59de0a6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1363,7 +1363,7 @@ struct ib_flow {
 	struct ib_uobject	*uobject;
 };
 
-struct ib_mad;
+struct ib_mad_hdr;
 struct ib_grh;
 
 enum ib_process_mad_flags {
@@ -1595,8 +1595,10 @@ struct ib_device {
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
