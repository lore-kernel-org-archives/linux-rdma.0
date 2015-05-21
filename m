From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/3] IB/core: Add const to device process_mad
Date: Thu, 21 May 2015 16:40:23 -0400
Message-ID: <1432240824-3277-3-git-send-email-ira.weiny@intel.com>
References: <1432240824-3277-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432240824-3277-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The process_mad device function declares some parameters as "in".  Make those
parameters const and adjust the call tree under process_mad in the various
drivers accordingly.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/amso1100/c2_provider.c  |  6 +++---
 drivers/infiniband/hw/cxgb3/iwch_provider.c   |  6 +++---
 drivers/infiniband/hw/cxgb4/provider.c        |  5 +++--
 drivers/infiniband/hw/ehca/ehca_iverbs.h      |  4 ++--
 drivers/infiniband/hw/ehca/ehca_sqp.c         |  4 ++--
 drivers/infiniband/hw/ipath/ipath_mad.c       |  8 ++++----
 drivers/infiniband/hw/ipath/ipath_verbs.h     |  6 +++---
 drivers/infiniband/hw/mlx4/mad.c              | 21 +++++++++++----------
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  8 ++++----
 drivers/infiniband/hw/mlx5/mad.c              |  8 ++++----
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  8 ++++----
 drivers/infiniband/hw/mthca/mthca_cmd.c       |  4 ++--
 drivers/infiniband/hw/mthca/mthca_cmd.h       |  4 ++--
 drivers/infiniband/hw/mthca/mthca_dev.h       |  6 +++---
 drivers/infiniband/hw/mthca/mthca_mad.c       | 10 +++++-----
 drivers/infiniband/hw/nes/nes_verbs.c         |  4 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c      |  6 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h      |  6 +++---
 drivers/infiniband/hw/qib/qib_mad.c           | 10 +++++-----
 drivers/infiniband/hw/qib/qib_verbs.h         |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/mad.c |  2 +-
 include/linux/mlx5/driver.h                   |  2 +-
 include/rdma/ib_verbs.h                       |  6 +++---
 23 files changed, 75 insertions(+), 73 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index d396c39918de..0f007a6b188b 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -582,9 +582,9 @@ static int c2_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 static int c2_process_mad(struct ib_device *ibdev,
 			  int mad_flags,
 			  u8 port_num,
-			  struct ib_wc *in_wc,
-			  struct ib_grh *in_grh,
-			  struct ib_mad *in_mad, struct ib_mad *out_mad)
+			  const struct ib_wc *in_wc,
+			  const struct ib_grh *in_grh,
+			  const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	pr_debug("%s:%u\n", __func__, __LINE__);
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 061ef08c92e2..19c830ecbb67 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -85,9 +85,9 @@ static int iwch_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 static int iwch_process_mad(struct ib_device *ibdev,
 			    int mad_flags,
 			    u8 port_num,
-			    struct ib_wc *in_wc,
-			    struct ib_grh *in_grh,
-			    struct ib_mad *in_mad, struct ib_mad *out_mad)
+			    const struct ib_wc *in_wc,
+			    const struct ib_grh *in_grh,
+			    const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	return -ENOSYS;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ef08a9f29451..75ea26a32076 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -80,8 +80,9 @@ static int c4iw_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 }
 
 static int c4iw_process_mad(struct ib_device *ibdev, int mad_flags,
-			    u8 port_num, struct ib_wc *in_wc,
-			    struct ib_grh *in_grh, struct ib_mad *in_mad,
+			    u8 port_num, const struct ib_wc *in_wc,
+			    const struct ib_grh *in_grh,
+			    const struct ib_mad *in_mad,
 			    struct ib_mad *out_mad)
 {
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 077185b3fbd6..582fc71a8488 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -191,8 +191,8 @@ int ehca_dealloc_ucontext(struct ib_ucontext *context);
 int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-		     struct ib_wc *in_wc, struct ib_grh *in_grh,
-		     struct ib_mad *in_mad,
+		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		     const struct ib_mad *in_mad,
 		     struct ib_mad *out_mad);
 
 void ehca_poll_eqs(unsigned long data);
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index dba8f9f8b996..765d62d43a30 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -217,8 +217,8 @@ perf_reply:
 }
 
 int ehca_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-		     struct ib_wc *in_wc, struct ib_grh *in_grh,
-		     struct ib_mad *in_mad, struct ib_mad *out_mad)
+		     const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		     const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	int ret;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
index e890e5ba0e01..9e8929e23740 100644
--- a/drivers/infiniband/hw/ipath/ipath_mad.c
+++ b/drivers/infiniband/hw/ipath/ipath_mad.c
@@ -1257,7 +1257,7 @@ static int recv_pma_set_portcounters_ext(struct ib_pma_mad *pmp,
 }
 
 static int process_subn(struct ib_device *ibdev, int mad_flags,
-			u8 port_num, struct ib_mad *in_mad,
+			u8 port_num, const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_smp *smp = (struct ib_smp *)out_mad;
@@ -1389,7 +1389,7 @@ bail:
 }
 
 static int process_perf(struct ib_device *ibdev, u8 port_num,
-			struct ib_mad *in_mad,
+			const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_pma_mad *pmp = (struct ib_pma_mad *)out_mad;
@@ -1490,8 +1490,8 @@ bail:
  * This is called by the ib_mad module.
  */
 int ipath_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-		      struct ib_wc *in_wc, struct ib_grh *in_grh,
-		      struct ib_mad *in_mad, struct ib_mad *out_mad)
+		      const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		      const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	int ret;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.h b/drivers/infiniband/hw/ipath/ipath_verbs.h
index ae6cff4abffc..7a2b6a17f844 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.h
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.h
@@ -701,9 +701,9 @@ static inline void ipath_schedule_send(struct ipath_qp *qp)
 int ipath_process_mad(struct ib_device *ibdev,
 		      int mad_flags,
 		      u8 port_num,
-		      struct ib_wc *in_wc,
-		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad, struct ib_mad *out_mad);
+		      const struct ib_wc *in_wc,
+		      const struct ib_grh *in_grh,
+		      const struct ib_mad *in_mad, struct ib_mad *out_mad);
 
 /*
  * Compare the lower 24 bits of the two values.
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9cd2b002d7ae..614ac6f07ae1 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -111,8 +111,9 @@ __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
 }
 
 int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
-		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		 void *in_mad, void *response_mad)
+		 int port, const struct ib_wc *in_wc,
+		 const struct ib_grh *in_grh,
+		 const void *in_mad, void *response_mad)
 {
 	struct mlx4_cmd_mailbox *inmailbox, *outmailbox;
 	void *inbox;
@@ -220,7 +221,7 @@ static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
  * Snoop SM MADs for port info, GUID info, and  P_Key table sets, so we can
  * synthesize LID change, Client-Rereg, GID change, and P_Key change events.
  */
-static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
+static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad *mad,
 		      u16 prev_lid)
 {
 	struct ib_port_info *pinfo;
@@ -356,7 +357,7 @@ static void node_desc_override(struct ib_device *dev,
 	}
 }
 
-static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, struct ib_mad *mad)
+static void forward_trap(struct mlx4_ib_dev *dev, u8 port_num, const struct ib_mad *mad)
 {
 	int qpn = mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED;
 	struct ib_mad_send_buf *send_buf;
@@ -722,8 +723,8 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 }
 
 static int ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	u16 slid, prev_lid = 0;
 	int err;
@@ -825,8 +826,8 @@ static void edit_counter(struct mlx4_counter *cnt,
 }
 
 static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	struct mlx4_cmd_mailbox *mailbox;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
@@ -866,8 +867,8 @@ static int iboe_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
 }
 
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	switch (rdma_port_get_link_layer(ibdev, port_num)) {
 	case IB_LINK_LAYER_INFINIBAND:
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index fce3934372a1..645d55ef0604 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -706,11 +706,11 @@ int mlx4_ib_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
 		      struct ib_recv_wr **bad_wr);
 
 int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
-		 int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		 void *in_mad, void *response_mad);
+		 int port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		 const void *in_mad, void *response_mad);
 int mlx4_ib_process_mad(struct ib_device *ibdev, int mad_flags,	u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad);
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad);
 int mlx4_ib_mad_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_mad_cleanup(struct mlx4_ib_dev *dev);
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 9cf9a37bb5ff..34e519cd4c64 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -41,8 +41,8 @@ enum {
 };
 
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
-		 u8 port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		 void *in_mad, void *response_mad)
+		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		 const void *in_mad, void *response_mad)
 {
 	u8 op_modifier = 0;
 
@@ -58,8 +58,8 @@ int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 }
 
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad)
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	u16 slid;
 	int err;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index dff1cfcdf476..c6219032d00c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -525,8 +525,8 @@ void __mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq)
 void mlx5_ib_cq_clean(struct mlx5_ib_cq *cq, u32 qpn, struct mlx5_ib_srq *srq);
 void mlx5_ib_free_srq_wqe(struct mlx5_ib_srq *srq, int wqe_index);
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
-		 u8 port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		 void *in_mad, void *response_mad);
+		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		 const void *in_mad, void *response_mad);
 struct ib_ah *create_ib_ah(struct ib_ah_attr *ah_attr,
 			   struct mlx5_ib_ah *ah);
 struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
@@ -586,8 +586,8 @@ int mlx5_ib_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 int mlx5_ib_unmap_fmr(struct list_head *fmr_list);
 int mlx5_ib_fmr_dealloc(struct ib_fmr *ibfmr);
 int mlx5_ib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-			struct ib_wc *in_wc, struct ib_grh *in_grh,
-			struct ib_mad *in_mad, struct ib_mad *out_mad);
+			const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+			const struct ib_mad *in_mad, struct ib_mad *out_mad);
 struct ib_xrcd *mlx5_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_ucontext *context,
 					  struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index 9d3e5c1ac60e..c7f49bbb0c72 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -1858,8 +1858,8 @@ int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn)
 }
 
 int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
-		  int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		  void *in_mad, void *response_mad)
+		  int port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		  const void *in_mad, void *response_mad)
 {
 	struct mthca_mailbox *inmailbox, *outmailbox;
 	void *inbox;
diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.h b/drivers/infiniband/hw/mthca/mthca_cmd.h
index f952244c54de..d2e5b194b938 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.h
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.h
@@ -312,8 +312,8 @@ int mthca_QUERY_QP(struct mthca_dev *dev, u32 num, int is_ee,
 		   struct mthca_mailbox *mailbox);
 int mthca_CONF_SPECIAL_QP(struct mthca_dev *dev, int type, u32 qpn);
 int mthca_MAD_IFC(struct mthca_dev *dev, int ignore_mkey, int ignore_bkey,
-		  int port, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		  void *in_mad, void *response_mad);
+		  int port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		  const void *in_mad, void *response_mad);
 int mthca_READ_MGM(struct mthca_dev *dev, int index,
 		   struct mthca_mailbox *mailbox);
 int mthca_WRITE_MGM(struct mthca_dev *dev, int index,
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 7e6a6d64ad4e..b70f9ff23171 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -576,9 +576,9 @@ int mthca_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
 int mthca_process_mad(struct ib_device *ibdev,
 		      int mad_flags,
 		      u8 port_num,
-		      struct ib_wc *in_wc,
-		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad,
+		      const struct ib_wc *in_wc,
+		      const struct ib_grh *in_grh,
+		      const struct ib_mad *in_mad,
 		      struct ib_mad *out_mad);
 int mthca_create_agents(struct mthca_dev *dev);
 void mthca_free_agents(struct mthca_dev *dev);
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 8881fa376e06..d54608ca0820 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -104,7 +104,7 @@ static void update_sm_ah(struct mthca_dev *dev,
  */
 static void smp_snoop(struct ib_device *ibdev,
 		      u8 port_num,
-		      struct ib_mad *mad,
+		      const struct ib_mad *mad,
 		      u16 prev_lid)
 {
 	struct ib_event event;
@@ -160,7 +160,7 @@ static void node_desc_override(struct ib_device *dev,
 
 static void forward_trap(struct mthca_dev *dev,
 			 u8 port_num,
-			 struct ib_mad *mad)
+			 const struct ib_mad *mad)
 {
 	int qpn = mad->mad_hdr.mgmt_class != IB_MGMT_CLASS_SUBN_LID_ROUTED;
 	struct ib_mad_send_buf *send_buf;
@@ -195,9 +195,9 @@ static void forward_trap(struct mthca_dev *dev,
 int mthca_process_mad(struct ib_device *ibdev,
 		      int mad_flags,
 		      u8 port_num,
-		      struct ib_wc *in_wc,
-		      struct ib_grh *in_grh,
-		      struct ib_mad *in_mad,
+		      const struct ib_wc *in_wc,
+		      const struct ib_grh *in_grh,
+		      const struct ib_mad *in_mad,
 		      struct ib_mad *out_mad)
 {
 	int err;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 05530e3f6ff0..0099e419e24f 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3221,8 +3221,8 @@ static int nes_multicast_detach(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
  * nes_process_mad
  */
 static int nes_process_mad(struct ib_device *ibdev, int mad_flags,
-		u8 port_num, struct ib_wc *in_wc, struct ib_grh *in_grh,
-		struct ib_mad *in_mad, struct ib_mad *out_mad)
+		u8 port_num, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	nes_debug(NES_DBG_INIT, "\n");
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index d812904f3984..3216bce08a10 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -196,9 +196,9 @@ int ocrdma_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
 int ocrdma_process_mad(struct ib_device *ibdev,
 		       int process_mad_flags,
 		       u8 port_num,
-		       struct ib_wc *in_wc,
-		       struct ib_grh *in_grh,
-		       struct ib_mad *in_mad, struct ib_mad *out_mad)
+		       const struct ib_wc *in_wc,
+		       const struct ib_grh *in_grh,
+		       const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	int status;
 	struct ocrdma_dev *dev;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 726a87cf22dc..5c4ae3eba47c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -42,7 +42,7 @@ int ocrdma_modify_ah(struct ib_ah *, struct ib_ah_attr *);
 int ocrdma_process_mad(struct ib_device *,
 		       int process_mad_flags,
 		       u8 port_num,
-		       struct ib_wc *in_wc,
-		       struct ib_grh *in_grh,
-		       struct ib_mad *in_mad, struct ib_mad *out_mad);
+		       const struct ib_wc *in_wc,
+		       const struct ib_grh *in_grh,
+		       const struct ib_mad *in_mad, struct ib_mad *out_mad);
 #endif				/* __OCRDMA_AH_H__ */
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index 395f4046dba2..6ab8ab89d058 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -1854,7 +1854,7 @@ static int pma_set_portcounters_ext(struct ib_pma_mad *pmp,
 }
 
 static int process_subn(struct ib_device *ibdev, int mad_flags,
-			u8 port, struct ib_mad *in_mad,
+			u8 port, const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_smp *smp = (struct ib_smp *)out_mad;
@@ -2006,7 +2006,7 @@ bail:
 }
 
 static int process_perf(struct ib_device *ibdev, u8 port,
-			struct ib_mad *in_mad,
+			const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_pma_mad *pmp = (struct ib_pma_mad *)out_mad;
@@ -2299,7 +2299,7 @@ static int check_cc_key(struct qib_ibport *ibp,
 }
 
 static int process_cc(struct ib_device *ibdev, int mad_flags,
-			u8 port, struct ib_mad *in_mad,
+			u8 port, const struct ib_mad *in_mad,
 			struct ib_mad *out_mad)
 {
 	struct ib_cc_mad *ccp = (struct ib_cc_mad *)out_mad;
@@ -2400,8 +2400,8 @@ bail:
  * This is called by the ib_mad module.
  */
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port,
-		    struct ib_wc *in_wc, struct ib_grh *in_grh,
-		    struct ib_mad *in_mad, struct ib_mad *out_mad)
+		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		    const struct ib_mad *in_mad, struct ib_mad *out_mad)
 {
 	int ret;
 	struct qib_ibport *ibp = to_iport(ibdev, port);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index bfc8948fdd35..f2f57749c07d 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -872,8 +872,8 @@ void qib_cap_mask_chg(struct qib_ibport *ibp);
 void qib_sys_guid_chg(struct qib_ibport *ibp);
 void qib_node_desc_chg(struct qib_ibport *ibp);
 int qib_process_mad(struct ib_device *ibdev, int mad_flags, u8 port_num,
-		    struct ib_wc *in_wc, struct ib_grh *in_grh,
-		    struct ib_mad *in_mad, struct ib_mad *out_mad);
+		    const struct ib_wc *in_wc, const struct ib_grh *in_grh,
+		    const struct ib_mad *in_mad, struct ib_mad *out_mad);
 int qib_create_agents(struct qib_ibdev *dev);
 void qib_free_agents(struct qib_ibdev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mad.c b/drivers/net/ethernet/mellanox/mlx5/core/mad.c
index ee1b0b965f34..1368dac00da0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mad.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mad.c
@@ -36,7 +36,7 @@
 #include <linux/mlx5/cmd.h>
 #include "mlx5_core.h"
 
-int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, void *inb, void *outb,
+int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
 		      u16 opmod, u8 port)
 {
 	struct mlx5_mad_ifc_mbox_in *in = NULL;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9a90e7523dc2..9ec7c93d6fa3 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -696,7 +696,7 @@ int mlx5_core_dump_fill_mkey(struct mlx5_core_dev *dev, struct mlx5_core_mr *mr,
 			     u32 *mkey);
 int mlx5_core_alloc_pd(struct mlx5_core_dev *dev, u32 *pdn);
 int mlx5_core_dealloc_pd(struct mlx5_core_dev *dev, u32 pdn);
-int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, void *inb, void *outb,
+int mlx5_core_mad_ifc(struct mlx5_core_dev *dev, const void *inb, void *outb,
 		      u16 opmod, u8 port);
 void mlx5_pagealloc_init(struct mlx5_core_dev *dev);
 void mlx5_pagealloc_cleanup(struct mlx5_core_dev *dev);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f19739adf80d..48c9acbea53e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1690,9 +1690,9 @@ struct ib_device {
 	int                        (*process_mad)(struct ib_device *device,
 						  int process_mad_flags,
 						  u8 port_num,
-						  struct ib_wc *in_wc,
-						  struct ib_grh *in_grh,
-						  struct ib_mad *in_mad,
+						  const struct ib_wc *in_wc,
+						  const struct ib_grh *in_grh,
+						  const struct ib_mad *in_mad,
 						  struct ib_mad *out_mad);
 	struct ib_xrcd *	   (*alloc_xrcd)(struct ib_device *device,
 						 struct ib_ucontext *ucontext,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
