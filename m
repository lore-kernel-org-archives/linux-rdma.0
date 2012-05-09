From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V0.1 4/7] IB/core: Add RSS and TSS QP groups
Date: Wed, 9 May 2012 18:07:38 +0300
Message-ID: <alpine.LRH.2.00.1205091803420.21487@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
MQ/Multi-Queue) are common networking techniques which allow to use
contemporary NICs that support multiple receive and transmit descriptor
queues (multi-queue), see also Documentation/networking/scaling.txt

This patch introduces the concept of RSS and TSS QP groups which
allows for implementing them by low level drivers and using it
by IPoIB and later also by user space ULPs.

A QP group is a set of QPs consists of a parent QP and two disjoint sets
of RSS and TSS QPs. The creation of a QP group is a two stage process:

In the the 1st stage, the parent QP is created.

In the 2nd stage the children QPs of the parent are created.

Each child QP indicates if its a RSS or TSS QP. Both the TSS
and RSS sets of QPs should have contiguous QP numbers.

A few new elements/concepts are introduced to support this:

Three new device capabilities that can be set by the low level driver:

- IB_DEVICE_QPG which is set to indicate QP groups are supported.

- IB_DEVICE_UD_RSS which is set to indicate that the device supports
RSS, that is applying hash function on incoming TCP/UDP/IP packets and
dispatching them to multiple "rings" (child QPs).

- IB_DEVICE_UD_TSS which is set to indicate that the device supports
"HW TSS" which means that the HW is capable of over-riding the source
UD QPN present in sent IB datagram header (DTH) with the parent's QPN.

Low level drivers not supporting HW TSS, could still support QP groups, such
as combination is referred as "SW TSS". Where in this case, the low level drive
fills in the qpg_tss_mask_sz field of struct ib_qp_cap returned from
ib_create_qp. Such that this mask can be used to retrieve the parent QPN from
incoming packets carrying a child QPN (as of the contiguous QP numbers requirement).

- max rss table size device attribute, which is the maximal size of the RSS
indirection table  supported by the device

- qp group type attribute for qp creation saying whether this is a parent QP
or rx/tx (rss/tss) child QP or none of the above for non rss/tss QPs.

- per qp group type, another attribute is added, for parent QPs, the number
of rx/tx child QPs and for child QPs pointer to the parent.

- IB_QP_GROUP_RSS attribute mask, which should be used when modifying
the parent QP state from reset to init

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

fixes from V0:

removed wrong setting done in the ehca driver in ehca_create_srq

 drivers/infiniband/core/verbs.c              |    3 +++
 drivers/infiniband/hw/amso1100/c2_provider.c |    3 +++
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    2 ++
 drivers/infiniband/hw/cxgb4/qp.c             |    3 +++
 drivers/infiniband/hw/ehca/ehca_qp.c         |    3 +++
 drivers/infiniband/hw/ipath/ipath_qp.c       |    3 +++
 drivers/infiniband/hw/mlx4/qp.c              |    3 +++
 drivers/infiniband/hw/mthca/mthca_provider.c |    3 +++
 drivers/infiniband/hw/nes/nes_verbs.c        |    3 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    5 +++++
 drivers/infiniband/hw/qib/qib_qp.c           |    5 +++++
 include/rdma/ib_verbs.h                      |   26 +++++++++++++++++++++++++-
 12 files changed, 61 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 30f199e..bbe0e5f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -496,6 +496,9 @@ static const struct {
 						IB_QP_QKEY),
 				[IB_QPT_GSI] = (IB_QP_PKEY_INDEX		|
 						IB_QP_QKEY),
+			},
+			.opt_param = {
+				[IB_QPT_UD]  = IB_QP_GROUP_RSS
 			}
 		},
 	},
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index 07eb3a8..546760b 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -241,6 +241,9 @@ static struct ib_qp *c2_create_qp(struct ib_pd *pd,
 	if (init_attr->create_flags)
 		return ERR_PTR(-EINVAL);

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	switch (init_attr->qp_type) {
 	case IB_QPT_RC:
 		qp = kzalloc(sizeof(*qp), GFP_KERNEL);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 0bdf09a..49850f6 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -902,6 +902,8 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
 	PDBG("%s ib_pd %p\n", __func__, pd);
 	if (attrs->qp_type != IB_QPT_RC)
 		return ERR_PTR(-EINVAL);
+	if (attrs->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
 	php = to_iwch_pd(pd);
 	rhp = php->rhp;
 	schp = get_chp(rhp, ((struct iwch_cq *) attrs->send_cq)->cq.cqid);
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 5f940ae..7ff2aa8 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1402,6 +1402,9 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd, struct ib_qp_init_attr *attrs,
 	if (attrs->qp_type != IB_QPT_RC)
 		return ERR_PTR(-EINVAL);

+	if (attrs->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	php = to_c4iw_pd(pd);
 	rhp = php->rhp;
 	schp = get_chp(rhp, ((struct c4iw_cq *)attrs->send_cq)->cq.cqid);
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 964f855..07832b7 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -464,6 +464,9 @@ static struct ehca_qp *internal_create_qp(
 	int is_llqp = 0, has_srq = 0, is_user = 0;
 	int qp_type, max_send_sge, max_recv_sge, ret;

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	/* h_call's out parameters */
 	struct ehca_alloc_qp_parms parms;
 	u32 swqe_size = 0, rwqe_size = 0, ib_qp_num;
diff --git a/drivers/infiniband/hw/ipath/ipath_qp.c b/drivers/infiniband/hw/ipath/ipath_qp.c
index 0857a9c..117b775 100644
--- a/drivers/infiniband/hw/ipath/ipath_qp.c
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c
@@ -755,6 +755,9 @@ struct ib_qp *ipath_create_qp(struct ib_pd *ibpd,
 		goto bail;
 	}

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	if (init_attr->cap.max_send_sge > ib_ipath_max_sges ||
 	    init_attr->cap.max_send_wr > ib_ipath_max_qp_wrs) {
 		ret = ERR_PTR(-EINVAL);
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 5967644..a32482c 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -787,6 +787,9 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	    (udata || init_attr->qp_type != IB_QPT_UD))
 		return ERR_PTR(-EINVAL);

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	switch (init_attr->qp_type) {
 	case IB_QPT_XRC_TGT:
 		pd = to_mxrcd(init_attr->xrcd)->pd;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 5b71d43..120aa1e 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -518,6 +518,9 @@ static struct ib_qp *mthca_create_qp(struct ib_pd *pd,
 	if (init_attr->create_flags)
 		return ERR_PTR(-EINVAL);

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	switch (init_attr->qp_type) {
 	case IB_QPT_RC:
 	case IB_QPT_UC:
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 8b8812d..24825b5 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1131,6 +1131,9 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	if (init_attr->create_flags)
 		return ERR_PTR(-EINVAL);

+	if (init_attr->qpg_type != IB_QPG_NONE)
+		return ERR_PTR(-ENOSYS);
+
 	atomic_inc(&qps_created);
 	switch (init_attr->qp_type) {
 		case IB_QPT_RC:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index e9f74d1..9035aae 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -841,6 +841,11 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 			   __func__, dev->id, attrs->qp_type);
 		return -EINVAL;
 	}
+	if (attrs->qpg_type != IB_QPG_NONE) {
+		ocrdma_err("%s(%d) unsupported qpg type=0x%x requested\n",
+			   __func__, dev->id, attrs->qpg_type);
+		return -ENOSYS;
+	}
 	if (attrs->cap.max_send_wr > dev->attr.max_wqe) {
 		ocrdma_err("%s(%d) unsupported send_wr=0x%x requested\n",
 			   __func__, dev->id, attrs->cap.max_send_wr);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 7e7e16f..838b1c7 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -986,6 +986,11 @@ struct ib_qp *qib_create_qp(struct ib_pd *ibpd,
 		goto bail;
 	}

+	if (init_attr->qpg_type != IB_QPG_NONE) {
+		ret = ERR_PTR(-ENOSYS);
+		goto bail;
+	}
+
 	/* Check receive queue parameters if no SRQ is specified. */
 	if (!init_attr->srq) {
 		if (init_attr->cap.max_recv_sge > ib_qib_max_sges ||
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 07996af..2e30f89 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -115,6 +115,9 @@ enum ib_device_cap_flags {
 	IB_DEVICE_XRC			= (1<<20),
 	IB_DEVICE_MEM_MGT_EXTENSIONS	= (1<<21),
 	IB_DEVICE_BLOCK_MULTICAST_LOOPBACK = (1<<22),
+	IB_DEVICE_QPG			= (1<<23),
+	IB_DEVICE_UD_RSS		= (1<<24),
+	IB_DEVICE_UD_TSS		= (1<<25)
 };

 enum ib_atomic_cap {
@@ -162,6 +165,7 @@ struct ib_device_attr {
 	int			max_srq_wr;
 	int			max_srq_sge;
 	unsigned int		max_fast_reg_page_list_len;
+	int			max_rss_tbl_sz;
 	u16			max_pkeys;
 	u8			local_ca_ack_delay;
 };
@@ -584,6 +588,7 @@ struct ib_qp_cap {
 	u32	max_send_sge;
 	u32	max_recv_sge;
 	u32	max_inline_data;
+	u32	qpg_tss_mask_sz;
 };

 enum ib_sig_type {
@@ -616,6 +621,18 @@ enum ib_qp_create_flags {
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	= 1 << 1,
 };

+enum ib_qpg_type {
+	IB_QPG_NONE	= 0,
+	IB_QPG_PARENT	= (1<<0),
+	IB_QPG_CHILD_RX = (1<<1),
+	IB_QPG_CHILD_TX = (1<<2)
+};
+
+struct ib_qpg_init_attrib {
+	u32 tss_child_count;
+	u32 rss_child_count;
+};
+
 struct ib_qp_init_attr {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void		       *qp_context;
@@ -624,9 +641,14 @@ struct ib_qp_init_attr {
 	struct ib_srq	       *srq;
 	struct ib_xrcd	       *xrcd;     /* XRC TGT QPs only */
 	struct ib_qp_cap	cap;
+	union {
+		struct ib_qp *qpg_parent; /* see qpg_type */
+		struct ib_qpg_init_attrib parent_attrib;
+	};
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
 	enum ib_qp_create_flags	create_flags;
+	enum ib_qpg_type	qpg_type;
 	u8			port_num; /* special QP types only */
 };

@@ -693,7 +715,8 @@ enum ib_qp_attr_mask {
 	IB_QP_MAX_DEST_RD_ATOMIC	= (1<<17),
 	IB_QP_PATH_MIG_STATE		= (1<<18),
 	IB_QP_CAP			= (1<<19),
-	IB_QP_DEST_QPN			= (1<<20)
+	IB_QP_DEST_QPN			= (1<<20),
+	IB_QP_GROUP_RSS			= (1<<21)
 };

 enum ib_qp_state {
@@ -972,6 +995,7 @@ struct ib_qp {
 	void		       *qp_context;
 	u32			qp_num;
 	enum ib_qp_type		qp_type;
+	enum ib_qpg_type	qpg_type;
 };

 struct ib_mr {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
