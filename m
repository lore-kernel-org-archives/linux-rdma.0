From: Dasaratharaman Chandramouli
        <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 rdma-next 06/18] IB/core: Rename struct ib_ah_attr to rdma_ah_attr
Date: Sat, 29 Apr 2017 14:41:18 -0400
Message-ID: <1493491290-31621-7-git-send-email-dasaratharaman.chandramouli@intel.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch simply renames struct ib_ah_attr to
rdma_ah_attr as these fields specify attributes that are
not necessarily specific to IB.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cm.c                    |  2 +-
 drivers/infiniband/core/mad.c                   |  2 +-
 drivers/infiniband/core/mad_rmpp.c              |  2 +-
 drivers/infiniband/core/multicast.c             |  2 +-
 drivers/infiniband/core/sa_query.c              |  5 +++--
 drivers/infiniband/core/user_mad.c              |  4 ++--
 drivers/infiniband/core/uverbs_cmd.c            |  2 +-
 drivers/infiniband/core/uverbs_marshall.c       |  2 +-
 drivers/infiniband/core/verbs.c                 | 12 ++++++------
 drivers/infiniband/hw/bnxt_re/ib_verbs.c        |  6 +++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h        |  6 +++---
 drivers/infiniband/hw/cxgb3/iwch_provider.c     |  2 +-
 drivers/infiniband/hw/cxgb4/provider.c          |  2 +-
 drivers/infiniband/hw/hfi1/ud.c                 |  4 ++--
 drivers/infiniband/hw/hfi1/verbs.c              |  8 ++++----
 drivers/infiniband/hw/hfi1/verbs.h              |  2 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c         |  5 +++--
 drivers/infiniband/hw/hns/hns_roce_device.h     |  5 +++--
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       |  2 +-
 drivers/infiniband/hw/mlx4/ah.c                 | 10 ++++++----
 drivers/infiniband/hw/mlx4/mad.c                | 10 +++++-----
 drivers/infiniband/hw/mlx4/mcg.c                |  4 ++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h            |  6 +++---
 drivers/infiniband/hw/mlx4/qp.c                 |  8 +++++---
 drivers/infiniband/hw/mlx5/ah.c                 |  6 +++---
 drivers/infiniband/hw/mlx5/mlx5_ib.h            |  4 ++--
 drivers/infiniband/hw/mlx5/qp.c                 |  7 ++++---
 drivers/infiniband/hw/mthca/mthca_av.c          |  4 ++--
 drivers/infiniband/hw/mthca/mthca_dev.h         |  4 ++--
 drivers/infiniband/hw/mthca/mthca_mad.c         |  2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c    |  2 +-
 drivers/infiniband/hw/mthca/mthca_qp.c          |  7 ++++---
 drivers/infiniband/hw/nes/nes_verbs.c           |  3 ++-
 drivers/infiniband/hw/ocrdma/ocrdma.h           |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c        |  8 ++++----
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h        |  6 +++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c        |  2 +-
 drivers/infiniband/hw/qedr/qedr.h               |  4 ++--
 drivers/infiniband/hw/qedr/qedr_cm.c            |  2 +-
 drivers/infiniband/hw/qedr/verbs.c              |  2 +-
 drivers/infiniband/hw/qedr/verbs.h              |  2 +-
 drivers/infiniband/hw/qib/qib_ud.c              |  4 ++--
 drivers/infiniband/hw/qib/qib_verbs.c           |  6 +++---
 drivers/infiniband/hw/qib/qib_verbs.h           |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c    |  2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h    |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h       |  4 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c  |  4 ++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h |  2 +-
 drivers/infiniband/sw/rdmavt/ah.c               |  8 ++++----
 drivers/infiniband/sw/rdmavt/ah.h               |  6 +++---
 drivers/infiniband/sw/rxe/rxe_av.c              |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_loc.h             |  8 ++++----
 drivers/infiniband/sw/rxe/rxe_verbs.c           |  9 +++++----
 drivers/infiniband/ulp/ipoib/ipoib.h            |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c         |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |  2 +-
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c  |  2 +-
 drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c |  2 +-
 include/rdma/ib_marshall.h                      |  2 +-
 include/rdma/ib_sa.h                            |  4 ++--
 include/rdma/ib_verbs.h                         | 22 +++++++++++-----------
 include/rdma/rdma_cm.h                          |  2 +-
 include/rdma/rdma_vt.h                          |  8 ++++----
 include/rdma/rdmavt_qp.h                        |  4 ++--
 66 files changed, 155 insertions(+), 144 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 6535f09..c9751cc 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -228,7 +228,7 @@ struct cm_device {
 struct cm_av {
 	struct cm_port *port;
 	union ib_gid dgid;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	u16 pkey_index;
 	u8 timeout;
 };
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 8a2ceb4..6d8c9ee 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1833,7 +1833,7 @@ static inline int rcv_has_same_gid(const struct ib_mad_agent_private *mad_agent_
 				   const struct ib_mad_send_wr_private *wr,
 				   const struct ib_mad_recv_wc *rwc )
 {
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 	u8 send_resp, rcv_resp;
 	union ib_gid sgid;
 	struct ib_device *device = mad_agent_priv->agent.device;
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 382941b..3536dcf 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -852,7 +852,7 @@ static int init_newwin(struct ib_mad_send_wr_private *mad_send_wr)
 	struct ib_mad_agent_private *agent = mad_send_wr->mad_agent_priv;
 	struct ib_mad_hdr *mad_hdr = mad_send_wr->send_buf.mad;
 	struct mad_rmpp_recv *rmpp_recv;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	unsigned long flags;
 	int newwin = 1;
 
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 322cb67..d56fd80 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -720,7 +720,7 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 			     struct ib_sa_mcmember_rec *rec,
 			     struct net_device *ndev,
 			     enum ib_gid_type gid_type,
-			     struct ib_ah_attr *ah_attr)
+			     struct rdma_ah_attr *ah_attr)
 {
 	int ret;
 	u16 gid_index;
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index b57bdc2..18e0853 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1099,7 +1099,8 @@ static u8 get_src_path_mask(struct ib_device *device, u8 port_num)
 }
 
 int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
-			 struct ib_sa_path_rec *rec, struct ib_ah_attr *ah_attr)
+			 struct ib_sa_path_rec *rec,
+			 struct rdma_ah_attr *ah_attr)
 {
 	int ret;
 	u16 gid_index;
@@ -2011,7 +2012,7 @@ static void update_sm_ah(struct work_struct *work)
 		container_of(work, struct ib_sa_port, update_task);
 	struct ib_sa_sm_ah *new_ah;
 	struct ib_port_attr port_attr;
-	struct ib_ah_attr   ah_attr;
+	struct rdma_ah_attr   ah_attr;
 
 	if (ib_query_port(port->agent->device, port->port_num, &port_attr)) {
 		pr_warn("Couldn't query port\n");
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index aca7ff7..7198c40 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -235,7 +235,7 @@ static void recv_handler(struct ib_mad_agent *agent,
 	packet->mad.hdr.pkey_index = mad_recv_wc->wc->pkey_index;
 	packet->mad.hdr.grh_present = !!(mad_recv_wc->wc->wc_flags & IB_WC_GRH);
 	if (packet->mad.hdr.grh_present) {
-		struct ib_ah_attr ah_attr;
+		struct rdma_ah_attr ah_attr;
 
 		ib_init_ah_from_wc(agent->device, agent->port_num,
 				   mad_recv_wc->wc, mad_recv_wc->recv_buf.grh,
@@ -449,7 +449,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_umad_file *file = filp->private_data;
 	struct ib_umad_packet *packet;
 	struct ib_mad_agent *agent;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	struct ib_ah *ah;
 	struct ib_rmpp_mad *rmpp_mad;
 	__be64 *tid;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index de4753b..6e9bdcd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2519,7 +2519,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 	struct ib_uobject		*uobj;
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
-	struct ib_ah_attr		attr;
+	struct rdma_ah_attr		attr;
 	int ret;
 	struct ib_udata                   udata;
 
diff --git a/drivers/infiniband/core/uverbs_marshall.c b/drivers/infiniband/core/uverbs_marshall.c
index a9739f3..090986f 100644
--- a/drivers/infiniband/core/uverbs_marshall.c
+++ b/drivers/infiniband/core/uverbs_marshall.c
@@ -34,7 +34,7 @@
 #include <rdma/ib_marshall.h>
 
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
-			     struct ib_ah_attr *src)
+			     struct rdma_ah_attr *src)
 {
 	memset(&dst->grh.reserved, 0, sizeof(dst->grh.reserved));
 	dst->dlid 	    	   = src->dlid;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 207e5c2..b1cde14 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -311,7 +311,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 
 /* Address handles */
 
-struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
+struct ib_ah *ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr)
 {
 	struct ib_ah *ah;
 
@@ -452,7 +452,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
 
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
-		       struct ib_ah_attr *ah_attr)
+		       struct rdma_ah_attr *ah_attr)
 {
 	u32 flow_class;
 	u16 gid_index;
@@ -560,7 +560,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 				   const struct ib_grh *grh, u8 port_num)
 {
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	int ret;
 
 	ret = ib_init_ah_from_wc(pd->device, port_num, wc, grh, &ah_attr);
@@ -571,7 +571,7 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 }
 EXPORT_SYMBOL(ib_create_ah_from_wc);
 
-int ib_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
+int ib_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
 	return ah->device->modify_ah ?
 		ah->device->modify_ah(ah, ah_attr) :
@@ -579,7 +579,7 @@ int ib_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
 }
 EXPORT_SYMBOL(ib_modify_ah);
 
-int ib_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr)
+int ib_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr)
 {
 	return ah->device->query_ah ?
 		ah->device->query_ah(ah, ah_attr) :
@@ -1201,7 +1201,7 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, enum ib_qp_state next_state,
 EXPORT_SYMBOL(ib_modify_qp_is_ok);
 
 int ib_resolve_eth_dmac(struct ib_device *device,
-			struct ib_ah_attr *ah_attr)
+			struct rdma_ah_attr *ah_attr)
 {
 	int           ret = 0;
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index a4e8e0b..a0670f4 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -524,7 +524,7 @@ int bnxt_re_destroy_ah(struct ib_ah *ib_ah)
 }
 
 struct ib_ah *bnxt_re_create_ah(struct ib_pd *ib_pd,
-				struct ib_ah_attr *ah_attr,
+				struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata)
 {
 	struct bnxt_re_pd *pd = container_of(ib_pd, struct bnxt_re_pd, ib_pd);
@@ -634,12 +634,12 @@ struct ib_ah *bnxt_re_create_ah(struct ib_pd *ib_pd,
 	return ERR_PTR(rc);
 }
 
-int bnxt_re_modify_ah(struct ib_ah *ib_ah, struct ib_ah_attr *ah_attr)
+int bnxt_re_modify_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
 {
 	return 0;
 }
 
-int bnxt_re_query_ah(struct ib_ah *ib_ah, struct ib_ah_attr *ah_attr)
+int bnxt_re_query_ah(struct ib_ah *ib_ah, struct rdma_ah_attr *ah_attr)
 {
 	struct bnxt_re_ah *ah = container_of(ib_ah, struct bnxt_re_ah, ib_ah);
 
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.h b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
index b4084c2..5c3d717 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.h
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.h
@@ -150,10 +150,10 @@ struct ib_pd *bnxt_re_alloc_pd(struct ib_device *ibdev,
 			       struct ib_udata *udata);
 int bnxt_re_dealloc_pd(struct ib_pd *pd);
 struct ib_ah *bnxt_re_create_ah(struct ib_pd *pd,
-				struct ib_ah_attr *ah_attr,
+				struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata);
-int bnxt_re_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
-int bnxt_re_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
+int bnxt_re_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
+int bnxt_re_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 int bnxt_re_destroy_ah(struct ib_ah *ah);
 struct ib_qp *bnxt_re_create_qp(struct ib_pd *pd,
 				struct ib_qp_init_attr *qp_init_attr,
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 790d7c7..29d3074 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -62,7 +62,7 @@
 #include "common.h"
 
 static struct ib_ah *iwch_ah_create(struct ib_pd *pd,
-				    struct ib_ah_attr *ah_attr,
+				    struct rdma_ah_attr *ah_attr,
 				    struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 6770a31..0771e9a 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -59,7 +59,7 @@
 MODULE_PARM_DESC(fastreg_support, "Advertise fastreg support (default=1)");
 
 static struct ib_ah *c4iw_ah_create(struct ib_pd *pd,
-				    struct ib_ah_attr *ah_attr,
+				    struct rdma_ah_attr *ah_attr,
 				    struct ib_udata *udata)
 
 {
diff --git a/drivers/infiniband/hw/hfi1/ud.c b/drivers/infiniband/hw/hfi1/ud.c
index 45bc3f0..7a438a5 100644
--- a/drivers/infiniband/hw/hfi1/ud.c
+++ b/drivers/infiniband/hw/hfi1/ud.c
@@ -68,7 +68,7 @@ static void ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	struct hfi1_ibport *ibp = to_iport(sqp->ibqp.device, sqp->port_num);
 	struct hfi1_pportdata *ppd;
 	struct rvt_qp *qp;
-	struct ib_ah_attr *ah_attr;
+	struct rdma_ah_attr *ah_attr;
 	unsigned long flags;
 	struct rvt_sge_state ssge;
 	struct rvt_sge *sge;
@@ -272,7 +272,7 @@ int hfi1_make_ud_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 {
 	struct hfi1_qp_priv *priv = qp->priv;
 	struct ib_other_headers *ohdr;
-	struct ib_ah_attr *ah_attr;
+	struct rdma_ah_attr *ah_attr;
 	struct hfi1_pportdata *ppd;
 	struct hfi1_ibport *ibp;
 	struct rvt_swqe *wqe;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 7174a18..0d3ae04 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1459,14 +1459,14 @@ static int hfi1_get_guid_be(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
 /*
  * convert ah port,sl to sc
  */
-u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah)
+u8 ah_to_sc(struct ib_device *ibdev, struct rdma_ah_attr *ah)
 {
 	struct hfi1_ibport *ibp = to_iport(ibdev, ah->port_num);
 
 	return ibp->sl_to_sc[ah->sl];
 }
 
-static int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
+static int hfi1_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr)
 {
 	struct hfi1_ibport *ibp;
 	struct hfi1_pportdata *ppd;
@@ -1484,7 +1484,7 @@ static int hfi1_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 }
 
 static void hfi1_notify_new_ah(struct ib_device *ibdev,
-			       struct ib_ah_attr *ah_attr,
+			       struct rdma_ah_attr *ah_attr,
 			       struct rvt_ah *ah)
 {
 	struct hfi1_ibport *ibp;
@@ -1508,7 +1508,7 @@ static void hfi1_notify_new_ah(struct ib_device *ibdev,
 
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid)
 {
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 	struct ib_ah *ah = ERR_PTR(-EINVAL);
 	struct rvt_qp *qp0;
 
diff --git a/drivers/infiniband/hw/hfi1/verbs.h b/drivers/infiniband/hw/hfi1/verbs.h
index 46b00ed..fb7f0a2 100644
--- a/drivers/infiniband/hw/hfi1/verbs.h
+++ b/drivers/infiniband/hw/hfi1/verbs.h
@@ -308,7 +308,7 @@ void hfi1_rc_hdrerr(
 	u32 rcv_flags,
 	struct rvt_qp *qp);
 
-u8 ah_to_sc(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
+u8 ah_to_sc(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr);
 
 struct ib_ah *hfi1_create_qp0_ah(struct hfi1_ibport *ibp, u16 dlid);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index 0ac294d..214c9b4 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -39,7 +39,8 @@
 #define HNS_ROCE_VLAN_SL_BIT_MASK	7
 #define HNS_ROCE_VLAN_SL_SHIFT		13
 
-struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *ah_attr,
+struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd,
+				 struct rdma_ah_attr *ah_attr,
 				 struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibpd->device);
@@ -98,7 +99,7 @@ struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *ah_attr,
 	return &ah->ibah;
 }
 
-int hns_roce_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+int hns_roce_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 {
 	struct hns_roce_ah *ah = to_hr_ah(ibah);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1a6cb5d..e493a61 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -687,9 +687,10 @@ void hns_roce_bitmap_free_range(struct hns_roce_bitmap *bitmap,
 				unsigned long obj, int cnt,
 				int rr);
 
-struct ib_ah *hns_roce_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *hns_roce_create_ah(struct ib_pd *pd,
+				 struct rdma_ah_attr *ah_attr,
 				 struct ib_udata *udata);
-int hns_roce_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int hns_roce_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
 int hns_roce_destroy_ah(struct ib_ah *ah);
 
 struct ib_pd *hns_roce_alloc_pd(struct ib_device *ib_dev,
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 378c757..4dbe61e 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -2696,7 +2696,7 @@ static int i40iw_query_pkey(struct ib_device *ibdev,
  * @ah_attr: address handle attributes
  */
 static struct ib_ah *i40iw_create_ah(struct ib_pd *ibpd,
-				     struct ib_ah_attr *attr,
+				     struct rdma_ah_attr *attr,
 				     struct ib_udata *udata)
 
 {
diff --git a/drivers/infiniband/hw/mlx4/ah.c b/drivers/infiniband/hw/mlx4/ah.c
index 077c33d..17fcb0b 100644
--- a/drivers/infiniband/hw/mlx4/ah.c
+++ b/drivers/infiniband/hw/mlx4/ah.c
@@ -40,7 +40,8 @@
 
 #include "mlx4_ib.h"
 
-static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+static struct ib_ah *create_ib_ah(struct ib_pd *pd,
+				  struct rdma_ah_attr *ah_attr,
 				  struct mlx4_ib_ah *ah)
 {
 	struct mlx4_dev *dev = to_mdev(pd->device)->dev;
@@ -69,7 +70,8 @@ static struct ib_ah *create_ib_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 	return &ah->ibah;
 }
 
-static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+static struct ib_ah *create_iboe_ah(struct ib_pd *pd,
+				    struct rdma_ah_attr *ah_attr,
 				    struct mlx4_ib_ah *ah)
 {
 	struct mlx4_ib_dev *ibdev = to_mdev(pd->device);
@@ -129,7 +131,7 @@ static struct ib_ah *create_iboe_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata)
 
 {
@@ -163,7 +165,7 @@ struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 		return create_ib_ah(pd, ah_attr, ah); /* never fails */
 }
 
-int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+int mlx4_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 {
 	struct mlx4_ib_ah *ah = to_mah(ibah);
 	enum rdma_link_layer ll;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index db564cc..d934959 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -189,7 +189,7 @@ int mlx4_MAD_IFC(struct mlx4_ib_dev *dev, int mad_ifc_flags,
 static void update_sm_ah(struct mlx4_ib_dev *dev, u8 port_num, u16 lid, u8 sl)
 {
 	struct ib_ah *new_ah;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	unsigned long flags;
 
 	if (!dev->send_agent[port_num - 1][0])
@@ -509,7 +509,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	struct mlx4_ib_demux_pv_ctx *tun_ctx;
 	struct mlx4_ib_demux_pv_qp *tun_qp;
 	struct mlx4_rcv_tunnel_mad *tun_mad;
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 	struct ib_ah *ah;
 	struct ib_qp *src_qp = NULL;
 	unsigned tun_tx_ix = 0;
@@ -1352,7 +1352,7 @@ static int is_proxy_qp0(struct mlx4_ib_dev *dev, int qpn, int slave)
 
 int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index,
-			 u32 remote_qpn, u32 qkey, struct ib_ah_attr *attr,
+			 u32 remote_qpn, u32 qkey, struct rdma_ah_attr *attr,
 			 u8 *s_mac, u16 vlan_id, struct ib_mad *mad)
 {
 	struct ib_sge list;
@@ -1467,7 +1467,7 @@ static int get_slave_base_gid_ix(struct mlx4_ib_dev *dev, int slave, int port)
 }
 
 static void fill_in_real_sgid_index(struct mlx4_ib_dev *dev, int slave, int port,
-				    struct ib_ah_attr *ah_attr)
+				    struct rdma_ah_attr *ah_attr)
 {
 	if (rdma_port_get_link_layer(&dev->ib_dev, port) == IB_LINK_LAYER_INFINIBAND)
 		ah_attr->grh.sgid_index = slave;
@@ -1482,7 +1482,7 @@ static void mlx4_ib_multiplex_mad(struct mlx4_ib_demux_pv_ctx *ctx, struct ib_wc
 	int wr_ix = wc->wr_id & (MLX4_NUM_TUNNEL_BUFS - 1);
 	struct mlx4_tunnel_mad *tunnel = tun_qp->ring[wr_ix].addr;
 	struct mlx4_ib_ah ah;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	u8 *slave_id;
 	int slave;
 	int port;
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 8772d88..492eded 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -209,7 +209,7 @@ static struct mcast_group *mcast_insert(struct mlx4_ib_demux_ctx *ctx,
 static int send_mad_to_wire(struct mlx4_ib_demux_ctx *ctx, struct ib_mad *mad)
 {
 	struct mlx4_ib_dev *dev = ctx->dev;
-	struct ib_ah_attr	ah_attr;
+	struct rdma_ah_attr	ah_attr;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->sm_lock, flags);
@@ -231,7 +231,7 @@ static int send_mad_to_slave(int slave, struct mlx4_ib_demux_ctx *ctx,
 	struct mlx4_ib_dev *dev = ctx->dev;
 	struct ib_mad_agent *agent = dev->send_agent[ctx->port - 1][1];
 	struct ib_wc wc;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 
 	/* Our agent might not yet be registered when mads start to arrive */
 	if (!agent)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 64fed44..c2b9cbf 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -742,9 +742,9 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 void __mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 void mlx4_ib_cq_clean(struct mlx4_ib_cq *cq, u32 qpn, struct mlx4_ib_srq *srq);
 
-struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *mlx4_ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata);
-int mlx4_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int mlx4_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
 int mlx4_ib_destroy_ah(struct ib_ah *ah);
 
 struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
@@ -833,7 +833,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 
 int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 			 enum ib_qp_type dest_qpt, u16 pkey_index, u32 remote_qpn,
-			 u32 qkey, struct ib_ah_attr *attr, u8 *s_mac,
+			 u32 qkey, struct rdma_ah_attr *attr, u8 *s_mac,
 			 u16 vlan_id, struct ib_mad *mad);
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8f38231..47598ce 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1383,7 +1383,8 @@ static void mlx4_set_sched(struct mlx4_qp_path *path, u8 port)
 	path->sched_queue = (path->sched_queue & 0xbf) | ((port - 1) << 6);
 }
 
-static int _mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_ah_attr *ah,
+static int _mlx4_set_path(struct mlx4_ib_dev *dev,
+			  const struct rdma_ah_attr *ah,
 			  u64 smac, u16 vlan_tag, struct mlx4_qp_path *path,
 			  struct mlx4_roce_smac_vlan_info *smac_info, u8 port)
 {
@@ -3394,8 +3395,9 @@ static int to_ib_qp_access_flags(int mlx4_flags)
 	return ib_flags;
 }
 
-static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev, struct ib_ah_attr *ib_ah_attr,
-				struct mlx4_qp_path *path)
+static void to_ib_ah_attr(struct mlx4_ib_dev *ibdev,
+			  struct rdma_ah_attr *ib_ah_attr,
+			  struct mlx4_qp_path *path)
 {
 	struct mlx4_dev *dev = ibdev->dev;
 	int is_eth;
diff --git a/drivers/infiniband/hw/mlx5/ah.c b/drivers/infiniband/hw/mlx5/ah.c
index d090e96..47529ab 100644
--- a/drivers/infiniband/hw/mlx5/ah.c
+++ b/drivers/infiniband/hw/mlx5/ah.c
@@ -34,7 +34,7 @@
 
 static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
 				  struct mlx5_ib_ah *ah,
-				  struct ib_ah_attr *ah_attr,
+				  struct rdma_ah_attr *ah_attr,
 				  enum rdma_link_layer ll)
 {
 	if (ah_attr->ah_flags & IB_AH_GRH) {
@@ -64,7 +64,7 @@ static struct ib_ah *create_ib_ah(struct mlx5_ib_dev *dev,
 	return &ah->ibah;
 }
 
-struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata)
 
 {
@@ -105,7 +105,7 @@ struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
 	return create_ib_ah(dev, ah, ah_attr, ll); /* never fails */
 }
 
-int mlx5_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 {
 	struct mlx5_ib_ah *ah = to_mah(ibah);
 	u32 tmp;
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 93c6466..38c877b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -740,9 +740,9 @@ int mlx5_ib_db_map_user(struct mlx5_ib_ucontext *context, unsigned long virt,
 int mlx5_MAD_IFC(struct mlx5_ib_dev *dev, int ignore_mkey, int ignore_bkey,
 		 u8 port, const struct ib_wc *in_wc, const struct ib_grh *in_grh,
 		 const void *in_mad, void *response_mad);
-struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *mlx5_ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 				struct ib_udata *udata);
-int mlx5_ib_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int mlx5_ib_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
 int mlx5_ib_destroy_ah(struct ib_ah *ah);
 struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 				  struct ib_srq_init_attr *init_attr,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 4e5a811..18974c1 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2206,7 +2206,7 @@ static int modify_raw_packet_tx_affinity(struct mlx5_core_dev *dev,
 }
 
 static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
-			 const struct ib_ah_attr *ah,
+			 const struct rdma_ah_attr *ah,
 			 struct mlx5_qp_path *path, u8 port, int attr_mask,
 			 u32 path_flags, const struct ib_qp_attr *attr,
 			 bool alt)
@@ -4249,8 +4249,9 @@ static int to_ib_qp_access_flags(int mlx5_flags)
 	return ib_flags;
 }
 
-static void to_ib_ah_attr(struct mlx5_ib_dev *ibdev, struct ib_ah_attr *ib_ah_attr,
-				struct mlx5_qp_path *path)
+static void to_ib_ah_attr(struct mlx5_ib_dev *ibdev,
+			  struct rdma_ah_attr *ib_ah_attr,
+			  struct mlx5_qp_path *path)
 {
 	struct mlx5_core_dev *dev = ibdev->mdev;
 
diff --git a/drivers/infiniband/hw/mthca/mthca_av.c b/drivers/infiniband/hw/mthca/mthca_av.c
index c9f0f36..0c95668 100644
--- a/drivers/infiniband/hw/mthca/mthca_av.c
+++ b/drivers/infiniband/hw/mthca/mthca_av.c
@@ -152,7 +152,7 @@ u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u8 port)
 
 int mthca_create_ah(struct mthca_dev *dev,
 		    struct mthca_pd *pd,
-		    struct ib_ah_attr *ah_attr,
+		    struct rdma_ah_attr *ah_attr,
 		    struct mthca_ah *ah)
 {
 	u32 index = -1;
@@ -287,7 +287,7 @@ int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 	return 0;
 }
 
-int mthca_ah_query(struct ib_ah *ibah, struct ib_ah_attr *attr)
+int mthca_ah_query(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	struct mthca_ah *ah   = to_mah(ibah);
 	struct mthca_dev *dev = to_mdev(ibah->device);
diff --git a/drivers/infiniband/hw/mthca/mthca_dev.h b/drivers/infiniband/hw/mthca/mthca_dev.h
index 4393a02..ec7da9a 100644
--- a/drivers/infiniband/hw/mthca/mthca_dev.h
+++ b/drivers/infiniband/hw/mthca/mthca_dev.h
@@ -560,12 +560,12 @@ int mthca_alloc_sqp(struct mthca_dev *dev,
 void mthca_free_qp(struct mthca_dev *dev, struct mthca_qp *qp);
 int mthca_create_ah(struct mthca_dev *dev,
 		    struct mthca_pd *pd,
-		    struct ib_ah_attr *ah_attr,
+		    struct rdma_ah_attr *ah_attr,
 		    struct mthca_ah *ah);
 int mthca_destroy_ah(struct mthca_dev *dev, struct mthca_ah *ah);
 int mthca_read_ah(struct mthca_dev *dev, struct mthca_ah *ah,
 		  struct ib_ud_header *header);
-int mthca_ah_query(struct ib_ah *ibah, struct ib_ah_attr *attr);
+int mthca_ah_query(struct ib_ah *ibah, struct rdma_ah_attr *attr);
 int mthca_ah_grh_present(struct mthca_ah *ah);
 u8 mthca_get_rate(struct mthca_dev *dev, int static_rate, u8 port);
 enum ib_rate mthca_rate_to_ib(struct mthca_dev *dev, u8 mthca_rate, u8 port);
diff --git a/drivers/infiniband/hw/mthca/mthca_mad.c b/drivers/infiniband/hw/mthca/mthca_mad.c
index 9139405..00f7831 100644
--- a/drivers/infiniband/hw/mthca/mthca_mad.c
+++ b/drivers/infiniband/hw/mthca/mthca_mad.c
@@ -75,7 +75,7 @@ static void update_sm_ah(struct mthca_dev *dev,
 			 u8 port_num, u16 lid, u8 sl)
 {
 	struct ib_ah *new_ah;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	unsigned long flags;
 
 	if (!dev->send_agent[port_num - 1][0])
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index e1b8940..c197cd9 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -410,7 +410,7 @@ static int mthca_dealloc_pd(struct ib_pd *pd)
 }
 
 static struct ib_ah *mthca_ah_create(struct ib_pd *pd,
-				     struct ib_ah_attr *ah_attr,
+				     struct rdma_ah_attr *ah_attr,
 				     struct ib_udata *udata)
 
 {
diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 96e5fb9..e0b8e43 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -393,8 +393,9 @@ static int to_ib_qp_access_flags(int mthca_flags)
 	return ib_flags;
 }
 
-static void to_ib_ah_attr(struct mthca_dev *dev, struct ib_ah_attr *ib_ah_attr,
-				struct mthca_qp_path *path)
+static void to_ib_ah_attr(struct mthca_dev *dev,
+			  struct rdma_ah_attr *ib_ah_attr,
+			  struct mthca_qp_path *path)
 {
 	memset(ib_ah_attr, 0, sizeof *ib_ah_attr);
 	ib_ah_attr->port_num 	  = (be32_to_cpu(path->port_pkey) >> 24) & 0x3;
@@ -512,7 +513,7 @@ int mthca_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_m
 	return err;
 }
 
-static int mthca_path_set(struct mthca_dev *dev, const struct ib_ah_attr *ah,
+static int mthca_path_set(struct mthca_dev *dev, const struct rdma_ah_attr *ah,
 			  struct mthca_qp_path *path, u8 port)
 {
 	path->g_mylmc     = ah->src_path_bits & 0x7f;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c5eb78f..25dcd75 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -761,7 +761,8 @@ static int nes_dealloc_pd(struct ib_pd *ibpd)
 /**
  * nes_create_ah
  */
-static struct ib_ah *nes_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+static struct ib_ah *nes_create_ah(struct ib_pd *pd,
+				   struct rdma_ah_attr *ah_attr,
 				   struct ib_udata *udata)
 {
 	return ERR_PTR(-ENOSYS);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 45bdfa0..49ea7b6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -527,7 +527,7 @@ static inline int is_cqe_wr_imm(struct ocrdma_cqe *cqe)
 }
 
 static inline int ocrdma_resolve_dmac(struct ocrdma_dev *dev,
-		struct ib_ah_attr *ah_attr, u8 *mac_addr)
+		struct rdma_ah_attr *ah_attr, u8 *mac_addr)
 {
 	struct in6_addr in6;
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
index cd66e1e..71723db 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.c
@@ -71,7 +71,7 @@ static u16 ocrdma_hdr_type_to_proto_num(int devid, u8 hdr_type)
 }
 
 static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
-			struct ib_ah_attr *attr, union ib_gid *sgid,
+			struct rdma_ah_attr *attr, union ib_gid *sgid,
 			int pdid, bool *isvlan, u16 vlan_tag)
 {
 	int status;
@@ -154,7 +154,7 @@ static inline int set_av_attr(struct ocrdma_dev *dev, struct ocrdma_ah *ah,
 	return status;
 }
 
-struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+struct ib_ah *ocrdma_create_ah(struct ib_pd *ibpd, struct rdma_ah_attr *attr,
 			       struct ib_udata *udata)
 {
 	u32 *ahid_addr;
@@ -248,7 +248,7 @@ int ocrdma_destroy_ah(struct ib_ah *ibah)
 	return 0;
 }
 
-int ocrdma_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+int ocrdma_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	struct ocrdma_ah *ah = get_ocrdma_ah(ibah);
 	struct ocrdma_av *av = ah->av;
@@ -271,7 +271,7 @@ int ocrdma_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
 	return 0;
 }
 
-int ocrdma_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+int ocrdma_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	/* modify_ah is unsupported */
 	return -ENOSYS;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
index 5370eb7..1a65c47 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_ah.h
@@ -51,11 +51,11 @@ enum {
 	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D /* 29 bits */
 };
 
-struct ib_ah *ocrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *ocrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 			       struct ib_udata *udata);
 int ocrdma_destroy_ah(struct ib_ah *ah);
-int ocrdma_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
-int ocrdma_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
+int ocrdma_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
+int ocrdma_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 int ocrdma_process_mad(struct ib_device *,
 		       int process_mad_flags,
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aa69671..0ca52fa 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -2499,7 +2499,7 @@ static int ocrdma_set_av_params(struct ocrdma_qp *qp,
 				int attr_mask)
 {
 	int status;
-	struct ib_ah_attr *ah_attr = &attrs->ah_attr;
+	struct rdma_ah_attr *ah_attr = &attrs->ah_attr;
 	union ib_gid sgid, zgid;
 	struct ib_gid_attr sgid_attr;
 	u32 vlan_id = 0xFFFF;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index bf02ae4..42df615 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -392,7 +392,7 @@ struct qedr_qp {
 
 struct qedr_ah {
 	struct ib_ah ibah;
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 };
 
 enum qedr_mr_type {
@@ -446,7 +446,7 @@ static inline void qedr_inc_sw_prod(struct qedr_qp_hwq_info *info)
 }
 
 static inline int qedr_get_dmac(struct qedr_dev *dev,
-				struct ib_ah_attr *ah_attr, u8 *mac_addr)
+				struct rdma_ah_attr *ah_attr, u8 *mac_addr)
 {
 	union ib_gid zero_sgid = { { 0 } };
 	struct in6_addr in6;
diff --git a/drivers/infiniband/hw/qedr/qedr_cm.c b/drivers/infiniband/hw/qedr/qedr_cm.c
index a6280ce..118966e 100644
--- a/drivers/infiniband/hw/qedr/qedr_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_cm.c
@@ -243,7 +243,7 @@ static inline int qedr_gsi_build_header(struct qedr_dev *dev,
 					int *roce_mode)
 {
 	bool has_vlan = false, has_grh_ipv6 = true;
-	struct ib_ah_attr *ah_attr = &get_qedr_ah(ud_wr(swr)->ah)->attr;
+	struct rdma_ah_attr *ah_attr = &get_qedr_ah(ud_wr(swr)->ah)->attr;
 	struct ib_global_route *grh = &ah_attr->grh;
 	union ib_gid sgid;
 	int send_size = 0;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a3afd2b..8ced8ec 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2112,7 +2112,7 @@ int qedr_destroy_qp(struct ib_qp *ibqp)
 	return rc;
 }
 
-struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct rdma_ah_attr *attr,
 			     struct ib_udata *udata)
 {
 	struct qedr_ah *ah;
diff --git a/drivers/infiniband/hw/qedr/verbs.h b/drivers/infiniband/hw/qedr/verbs.h
index 070677c..0f8ab49 100644
--- a/drivers/infiniband/hw/qedr/verbs.h
+++ b/drivers/infiniband/hw/qedr/verbs.h
@@ -70,7 +70,7 @@ int qedr_query_qp(struct ib_qp *, struct ib_qp_attr *qp_attr,
 		  int qp_attr_mask, struct ib_qp_init_attr *);
 int qedr_destroy_qp(struct ib_qp *ibqp);
 
-struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+struct ib_ah *qedr_create_ah(struct ib_pd *ibpd, struct rdma_ah_attr *attr,
 			     struct ib_udata *udata);
 int qedr_destroy_ah(struct ib_ah *ibah);
 
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index ddd4e74..a99d7e9 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -54,7 +54,7 @@ static void qib_ud_loopback(struct rvt_qp *sqp, struct rvt_swqe *swqe)
 	struct qib_devdata *dd = ppd->dd;
 	struct rvt_dev_info *rdi = &dd->verbs_dev.rdi;
 	struct rvt_qp *qp;
-	struct ib_ah_attr *ah_attr;
+	struct rdma_ah_attr *ah_attr;
 	unsigned long flags;
 	struct rvt_sge_state ssge;
 	struct rvt_sge *sge;
@@ -246,7 +246,7 @@ int qib_make_ud_req(struct rvt_qp *qp, unsigned long *flags)
 {
 	struct qib_qp_priv *priv = qp->priv;
 	struct ib_other_headers *ohdr;
-	struct ib_ah_attr *ah_attr;
+	struct rdma_ah_attr *ah_attr;
 	struct qib_pportdata *ppd;
 	struct qib_ibport *ibp;
 	struct rvt_swqe *wqe;
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 68d449c..16a9aa1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1336,7 +1336,7 @@ static int qib_get_guid_be(struct rvt_dev_info *rdi, struct rvt_ibport *rvp,
 	return 0;
 }
 
-int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
+int qib_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr)
 {
 	if (ah_attr->sl > 15)
 		return -EINVAL;
@@ -1345,7 +1345,7 @@ int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr)
 }
 
 static void qib_notify_new_ah(struct ib_device *ibdev,
-			      struct ib_ah_attr *ah_attr,
+			      struct rdma_ah_attr *ah_attr,
 			      struct rvt_ah *ah)
 {
 	struct qib_ibport *ibp;
@@ -1364,7 +1364,7 @@ static void qib_notify_new_ah(struct ib_device *ibdev,
 
 struct ib_ah *qib_create_qp0_ah(struct qib_ibport *ibp, u16 dlid)
 {
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 	struct ib_ah *ah = ERR_PTR(-EINVAL);
 	struct rvt_qp *qp0;
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.h b/drivers/infiniband/hw/qib/qib_verbs.h
index 212e8ce..a72c309 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.h
+++ b/drivers/infiniband/hw/qib/qib_verbs.h
@@ -310,7 +310,7 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct ib_header *hdr,
 void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct rvt_qp *qp);
 
-int qib_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
+int qib_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr);
 
 int qib_check_send_wqe(struct rvt_qp *qp, struct rvt_swqe *wqe);
 
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 44a9332..4996984 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -740,7 +740,7 @@ int usnic_ib_mmap(struct ib_ucontext *context,
 
 /* In ib callbacks section -  Start of stub funcs */
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-				 struct ib_ah_attr *ah_attr,
+				 struct rdma_ah_attr *ah_attr,
 				 struct ib_udata *udata)
 
 {
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index 0ed8e07..172e43b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -75,7 +75,7 @@ struct ib_ucontext *usnic_ib_alloc_ucontext(struct ib_device *ibdev,
 int usnic_ib_mmap(struct ib_ucontext *context,
 			struct vm_area_struct *vma);
 struct ib_ah *usnic_ib_create_ah(struct ib_pd *pd,
-				 struct ib_ah_attr *ah_attr,
+				 struct rdma_ah_attr *ah_attr,
 				 struct ib_udata *udata);
 
 int usnic_ib_destroy_ah(struct ib_ah *ah);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 9fbe22d..4e56b43 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -440,10 +440,10 @@ void pvrdma_global_route_to_ib(struct ib_global_route *dst,
 			       const struct pvrdma_global_route *src);
 void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
 			       const struct ib_global_route *src);
-void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
+void pvrdma_ah_attr_to_ib(struct rdma_ah_attr *dst,
 			  const struct pvrdma_ah_attr *src);
 void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct ib_ah_attr *src);
+			  const struct rdma_ah_attr *src);
 
 int pvrdma_uar_table_init(struct pvrdma_dev *dev);
 void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
index 6ef4df6..4ce831d 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
@@ -277,7 +277,7 @@ void ib_global_route_to_pvrdma(struct pvrdma_global_route *dst,
 	dst->traffic_class = src->traffic_class;
 }
 
-void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
+void pvrdma_ah_attr_to_ib(struct rdma_ah_attr *dst,
 			  const struct pvrdma_ah_attr *src)
 {
 	pvrdma_global_route_to_ib(&dst->grh, &src->grh);
@@ -291,7 +291,7 @@ void pvrdma_ah_attr_to_ib(struct ib_ah_attr *dst,
 }
 
 void ib_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
-			  const struct ib_ah_attr *src)
+			  const struct rdma_ah_attr *src)
 {
 	ib_global_route_to_pvrdma(&dst->grh, &src->grh);
 	dst->dlid = src->dlid;
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index fec17c4..ae5a03b 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -520,7 +520,7 @@ int pvrdma_dealloc_pd(struct ib_pd *pd)
  *
  * @return: the ib_ah pointer on success, otherwise errno.
  */
-struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 			       struct ib_udata *udata)
 {
 	struct pvrdma_dev *dev = to_vdev(pd->device);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index bfbe96b..002a9b0 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -417,7 +417,7 @@ int pvrdma_resize_cq(struct ib_cq *ibcq, int entries,
 int pvrdma_destroy_cq(struct ib_cq *cq);
 int pvrdma_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *wc);
 int pvrdma_req_notify_cq(struct ib_cq *cq, enum ib_cq_notify_flags flags);
-struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr,
+struct ib_ah *pvrdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 			       struct ib_udata *udata);
 int pvrdma_destroy_ah(struct ib_ah *ah);
 struct ib_qp *pvrdma_create_qp(struct ib_pd *pd,
diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index b0f09fb..22226e2 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -60,7 +60,7 @@
  * Return: 0 on success
  */
 int rvt_check_ah(struct ib_device *ibdev,
-		 struct ib_ah_attr *ah_attr)
+		 struct rdma_ah_attr *ah_attr)
 {
 	int err;
 	struct ib_port_attr port_attr;
@@ -104,7 +104,7 @@ int rvt_check_ah(struct ib_device *ibdev,
  * Return: newly allocated ah
  */
 struct ib_ah *rvt_create_ah(struct ib_pd *pd,
-			    struct ib_ah_attr *ah_attr)
+			    struct rdma_ah_attr *ah_attr)
 {
 	struct rvt_ah *ah;
 	struct rvt_dev_info *dev = ib_to_rvt(pd->device);
@@ -167,7 +167,7 @@ int rvt_destroy_ah(struct ib_ah *ibah)
  *
  * Return: 0 on success
  */
-int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+int rvt_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 {
 	struct rvt_ah *ah = ibah_to_rvtah(ibah);
 
@@ -186,7 +186,7 @@ int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
  *
  * Return: always 0
  */
-int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr)
+int rvt_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr)
 {
 	struct rvt_ah *ah = ibah_to_rvtah(ibah);
 
diff --git a/drivers/infiniband/sw/rdmavt/ah.h b/drivers/infiniband/sw/rdmavt/ah.h
index e9c36be..16105af 100644
--- a/drivers/infiniband/sw/rdmavt/ah.h
+++ b/drivers/infiniband/sw/rdmavt/ah.h
@@ -51,9 +51,9 @@
 #include <rdma/rdma_vt.h>
 
 struct ib_ah *rvt_create_ah(struct ib_pd *pd,
-			    struct ib_ah_attr *ah_attr);
+			    struct rdma_ah_attr *ah_attr);
 int rvt_destroy_ah(struct ib_ah *ibah);
-int rvt_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
-int rvt_query_ah(struct ib_ah *ibah, struct ib_ah_attr *ah_attr);
+int rvt_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
+int rvt_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *ah_attr);
 
 #endif          /* DEF_RVTAH_H */
diff --git a/drivers/infiniband/sw/rxe/rxe_av.c b/drivers/infiniband/sw/rxe/rxe_av.c
index 88a4a7f..fad68aa 100644
--- a/drivers/infiniband/sw/rxe/rxe_av.c
+++ b/drivers/infiniband/sw/rxe/rxe_av.c
@@ -34,7 +34,7 @@
 #include "rxe.h"
 #include "rxe_loc.h"
 
-int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr)
+int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr)
 {
 	struct rxe_port *port;
 
@@ -57,7 +57,7 @@ int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr)
 }
 
 int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
-		     struct rxe_av *av, struct ib_ah_attr *attr)
+		     struct rxe_av *av, struct rdma_ah_attr *attr)
 {
 	memset(av, 0, sizeof(*av));
 	memcpy(&av->grh, &attr->grh, sizeof(attr->grh));
@@ -66,7 +66,7 @@ int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
 }
 
 int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
-		   struct ib_ah_attr *attr)
+		   struct rdma_ah_attr *attr)
 {
 	memcpy(&attr->grh, &av->grh, sizeof(av->grh));
 	attr->ah_flags = IB_AH_GRH;
@@ -76,7 +76,7 @@ int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
 
 int rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
-			struct ib_ah_attr *attr,
+			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
 			union ib_gid *sgid)
 {
diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index ed80913..d6299ed 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -36,17 +36,17 @@
 
 /* rxe_av.c */
 
-int rxe_av_chk_attr(struct rxe_dev *rxe, struct ib_ah_attr *attr);
+int rxe_av_chk_attr(struct rxe_dev *rxe, struct rdma_ah_attr *attr);
 
 int rxe_av_from_attr(struct rxe_dev *rxe, u8 port_num,
-		     struct rxe_av *av, struct ib_ah_attr *attr);
+		     struct rxe_av *av, struct rdma_ah_attr *attr);
 
 int rxe_av_to_attr(struct rxe_dev *rxe, struct rxe_av *av,
-		   struct ib_ah_attr *attr);
+		   struct rdma_ah_attr *attr);
 
 int rxe_av_fill_ip_info(struct rxe_dev *rxe,
 			struct rxe_av *av,
-			struct ib_ah_attr *attr,
+			struct rdma_ah_attr *attr,
 			struct ib_gid_attr *sgid_attr,
 			union ib_gid *sgid);
 
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index b35201d..71f62e0 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -297,7 +297,7 @@ static int rxe_dealloc_pd(struct ib_pd *ibpd)
 	return 0;
 }
 
-static int rxe_init_av(struct rxe_dev *rxe, struct ib_ah_attr *attr,
+static int rxe_init_av(struct rxe_dev *rxe, struct rdma_ah_attr *attr,
 		       struct rxe_av *av)
 {
 	int err;
@@ -321,7 +321,8 @@ static int rxe_init_av(struct rxe_dev *rxe, struct ib_ah_attr *attr,
 	return err;
 }
 
-static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
+static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd,
+				   struct rdma_ah_attr *attr,
 				   struct ib_udata *udata)
 
 {
@@ -356,7 +357,7 @@ static struct ib_ah *rxe_create_ah(struct ib_pd *ibpd, struct ib_ah_attr *attr,
 	return ERR_PTR(err);
 }
 
-static int rxe_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+static int rxe_modify_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	int err;
 	struct rxe_dev *rxe = to_rdev(ibah->device);
@@ -373,7 +374,7 @@ static int rxe_modify_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
 	return 0;
 }
 
-static int rxe_query_ah(struct ib_ah *ibah, struct ib_ah_attr *attr)
+static int rxe_query_ah(struct ib_ah *ibah, struct rdma_ah_attr *attr)
 {
 	struct rxe_dev *rxe = to_rdev(ibah->device);
 	struct rxe_ah *ah = to_rah(ibah);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index 7c8de22..fc9b0a3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -479,7 +479,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 void ipoib_send_comp_handler(struct ib_cq *cq, void *dev_ptr);
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
-				 struct ib_pd *pd, struct ib_ah_attr *attr);
+				 struct ib_pd *pd, struct rdma_ah_attr *attr);
 void ipoib_free_ah(struct kref *kref);
 static inline void ipoib_put_ah(struct ipoib_ah *ah)
 {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2bfcfb1..adbce02 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -52,7 +52,7 @@
 #endif
 
 struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
-				 struct ib_pd *pd, struct ib_ah_attr *attr)
+				 struct ib_pd *pd, struct rdma_ah_attr *attr)
 {
 	struct ipoib_ah *ah;
 	struct ib_ah *vah;
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 05a0722..f6002ef 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -739,7 +739,7 @@ static void path_rec_completion(int status,
 	skb_queue_head_init(&skqueue);
 
 	if (!status) {
-		struct ib_ah_attr av;
+		struct rdma_ah_attr av;
 
 		if (!ib_init_ah_from_path(priv->ca, priv->port, pathrec, &av))
 			ah = ipoib_create_ah(dev, priv->pd, &av);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 21e8514..baf82c7 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -274,7 +274,7 @@ static int ipoib_mcast_join_finish(struct ipoib_mcast *mcast,
 	}
 
 	{
-		struct ib_ah_attr av = {
+		struct rdma_ah_attr av = {
 			.dlid	       = be16_to_cpu(mcast->mcmember.mlid),
 			.port_num      = priv->port,
 			.sl	       = mcast->mcmember.sl,
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
index cee49aa..4f0b74b 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
@@ -730,7 +730,7 @@ void opa_vnic_vema_send_trap(struct opa_vnic_adapter *adapter,
 	struct ib_device *ibp;
 	struct opa_vnic_vema_mad_trap *trap_mad;
 	struct opa_class_port_info *class;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	struct ib_ah *ah;
 	struct opa_veswport_trap *trap;
 	u32 trap_lid;
diff --git a/include/rdma/ib_marshall.h b/include/rdma/ib_marshall.h
index db03720..42a0fc6 100644
--- a/include/rdma/ib_marshall.h
+++ b/include/rdma/ib_marshall.h
@@ -42,7 +42,7 @@ void ib_copy_qp_attr_to_user(struct ib_uverbs_qp_attr *dst,
 			     struct ib_qp_attr *src);
 
 void ib_copy_ah_attr_to_user(struct ib_uverbs_ah_attr *dst,
-			     struct ib_ah_attr *src);
+			     struct rdma_ah_attr *src);
 
 void ib_copy_path_rec_to_user(struct ib_user_path_rec *dst,
 			      struct ib_sa_path_rec *src);
diff --git a/include/rdma/ib_sa.h b/include/rdma/ib_sa.h
index 843b562..3ff8e64 100644
--- a/include/rdma/ib_sa.h
+++ b/include/rdma/ib_sa.h
@@ -421,7 +421,7 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
 			     struct ib_sa_mcmember_rec *rec,
 			     struct net_device *ndev,
 			     enum ib_gid_type gid_type,
-			     struct ib_ah_attr *ah_attr);
+			     struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_init_ah_from_path - Initialize address handle attributes based on an SA
@@ -429,7 +429,7 @@ int ib_init_ah_from_mcmember(struct ib_device *device, u8 port_num,
  */
 int ib_init_ah_from_path(struct ib_device *device, u8 port_num,
 			 struct ib_sa_path_rec *rec,
-			 struct ib_ah_attr *ah_attr);
+			 struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_sa_pack_path - Conert a path record from struct ib_sa_path_rec
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b6a0b5f..ed9f198 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -840,7 +840,7 @@ struct ib_mr_status {
  */
 __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
 
-struct ib_ah_attr {
+struct rdma_ah_attr {
 	struct ib_global_route	grh;
 	u16			dlid;
 	u8			sl;
@@ -1167,8 +1167,8 @@ struct ib_qp_attr {
 	u32			dest_qp_num;
 	int			qp_access_flags;
 	struct ib_qp_cap	cap;
-	struct ib_ah_attr	ah_attr;
-	struct ib_ah_attr	alt_ah_attr;
+	struct rdma_ah_attr	ah_attr;
+	struct rdma_ah_attr	alt_ah_attr;
 	u16			pkey_index;
 	u16			alt_pkey_index;
 	u8			en_sqd_async_notify;
@@ -2032,12 +2032,12 @@ struct ib_device {
 					       struct ib_udata *udata);
 	int                        (*dealloc_pd)(struct ib_pd *pd);
 	struct ib_ah *             (*create_ah)(struct ib_pd *pd,
-						struct ib_ah_attr *ah_attr,
+						struct rdma_ah_attr *ah_attr,
 						struct ib_udata *udata);
 	int                        (*modify_ah)(struct ib_ah *ah,
-						struct ib_ah_attr *ah_attr);
+						struct rdma_ah_attr *ah_attr);
 	int                        (*query_ah)(struct ib_ah *ah,
-					       struct ib_ah_attr *ah_attr);
+					       struct rdma_ah_attr *ah_attr);
 	int                        (*destroy_ah)(struct ib_ah *ah);
 	struct ib_srq *            (*create_srq)(struct ib_pd *pd,
 						 struct ib_srq_init_attr *srq_init_attr,
@@ -2727,7 +2727,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
  * The address handle is used to reference a local or global destination
  * in all UD QP post sends.
  */
-struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr);
+struct ib_ah *ib_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
@@ -2760,7 +2760,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
  */
 int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		       const struct ib_wc *wc, const struct ib_grh *grh,
-		       struct ib_ah_attr *ah_attr);
+		       struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_create_ah_from_wc - Creates an address handle associated with the
@@ -2784,7 +2784,7 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
  * @ah_attr: The new address vector attributes to associate with the
  *   address handle.
  */
-int ib_modify_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
+int ib_modify_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_query_ah - Queries the address vector associated with an address
@@ -2793,7 +2793,7 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
  * @ah_attr: The address vector attributes associated with the address
  *   handle.
  */
-int ib_query_ah(struct ib_ah *ah, struct ib_ah_attr *ah_attr);
+int ib_query_ah(struct ib_ah *ah, struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_destroy_ah - Destroys an address handle.
@@ -3464,5 +3464,5 @@ int ib_sg_to_pages(struct ib_mr *mr, struct scatterlist *sgl, int sg_nents,
 void ib_drain_qp(struct ib_qp *qp);
 
 int ib_resolve_eth_dmac(struct ib_device *device,
-			struct ib_ah_attr *ah_attr);
+			struct rdma_ah_attr *ah_attr);
 #endif /* IB_VERBS_H */
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index d3968b5..c9ac1e1 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -106,7 +106,7 @@ struct rdma_conn_param {
 struct rdma_ud_param {
 	const void *private_data;
 	u8 private_data_len;
-	struct ib_ah_attr ah_attr;
+	struct rdma_ah_attr ah_attr;
 	u32 qp_num;
 	u32 qkey;
 };
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 7f89568..4878aaf 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -170,7 +170,7 @@ struct rvt_pd {
 /* Address handle */
 struct rvt_ah {
 	struct ib_ah ibah;
-	struct ib_ah_attr attr;
+	struct rdma_ah_attr attr;
 	atomic_t refcount;
 	u8 vl;
 	u8 log_pmtu;
@@ -311,10 +311,10 @@ struct rvt_driver_provided {
 	unsigned (*free_all_qps)(struct rvt_dev_info *rdi);
 
 	/* Driver specific AH validation */
-	int (*check_ah)(struct ib_device *, struct ib_ah_attr *);
+	int (*check_ah)(struct ib_device *, struct rdma_ah_attr *);
 
 	/* Inform the driver a new AH has been created */
-	void (*notify_new_ah)(struct ib_device *, struct ib_ah_attr *,
+	void (*notify_new_ah)(struct ib_device *, struct rdma_ah_attr *,
 			      struct rvt_ah *);
 
 	/* Let the driver pick the next queue pair number*/
@@ -506,7 +506,7 @@ static inline void rvt_mod_retry_timer(struct rvt_qp *qp)
 void rvt_dealloc_device(struct rvt_dev_info *rdi);
 int rvt_register_device(struct rvt_dev_info *rvd);
 void rvt_unregister_device(struct rvt_dev_info *rvd);
-int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
+int rvt_check_ah(struct ib_device *ibdev, struct rdma_ah_attr *ah_attr);
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
 		  int port_index, u16 *pkey_table);
 int rvt_fast_reg_mr(struct rvt_qp *qp, struct ib_mr *ibmr, u32 key,
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 75a077c..1d8141a 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -269,8 +269,8 @@ struct rvt_qp {
 	struct ib_qp ibqp;
 	void *priv; /* Driver private data */
 	/* read mostly fields above and below */
-	struct ib_ah_attr remote_ah_attr;
-	struct ib_ah_attr alt_ah_attr;
+	struct rdma_ah_attr remote_ah_attr;
+	struct rdma_ah_attr alt_ah_attr;
 	struct rvt_qp __rcu *next;           /* link list for QPN hash table */
 	struct rvt_swqe *s_wq;  /* send work queue */
 	struct rvt_mmap_info *ip;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
