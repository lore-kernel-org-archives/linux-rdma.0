From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/17] rdma/core: Add SRQ type
Date: Wed, 15 Jun 2011 06:28:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373020FFA@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, there is only a single type of SRQ, but with XRC support
we will add a second.  Prepare for this by defining an SRQ type and
setting all current users to IB_SRQT_BASIC.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c         |    1 +
 drivers/infiniband/core/verbs.c              |    1 +
 drivers/infiniband/hw/ehca/ehca_qp.c         |    3 +++
 drivers/infiniband/hw/ipath/ipath_srq.c      |    5 +++++
 drivers/infiniband/hw/mthca/mthca_provider.c |    3 +++
 drivers/infiniband/hw/qib/qib_srq.c          |    5 +++++
 drivers/infiniband/ulp/ipoib/ipoib_cm.c      |    1 +
 include/rdma/ib_verbs.h                      |    6 ++++++
 8 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index c426992..48d21d0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2013,6 +2013,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 
 	attr.event_handler  = ib_uverbs_srq_event_handler;
 	attr.srq_context    = file;
+	attr.srq_type       = IB_SRQT_BASIC;
 	attr.attr.max_wr    = cmd.max_wr;
 	attr.attr.max_sge   = cmd.max_sge;
 	attr.attr.srq_limit = cmd.srq_limit;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5e03ab7..cbe85dd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -250,6 +250,7 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		srq->uobject       = NULL;
 		srq->event_handler = srq_init_attr->event_handler;
 		srq->srq_context   = srq_init_attr->srq_context;
+		srq->srq_type      = srq_init_attr->srq_type;
 		atomic_inc(&pd->usecnt);
 		atomic_set(&srq->usecnt, 0);
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 32fb342..964f855 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -977,6 +977,9 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 	struct hcp_modify_qp_control_block *mqpcb;
 	u64 hret, update_mask;
 
+	if (srq_init_attr->srq_type != IB_SRQT_BASIC)
+		return ERR_PTR(-ENOSYS);
+
 	/* For common attributes, internal_create_qp() takes its info
 	 * out of qp_init_attr, so copy all common attrs there.
 	 */
diff --git a/drivers/infiniband/hw/ipath/ipath_srq.c b/drivers/infiniband/hw/ipath/ipath_srq.c
index 386e2c7..2627198 100644
--- a/drivers/infiniband/hw/ipath/ipath_srq.c
+++ b/drivers/infiniband/hw/ipath/ipath_srq.c
@@ -107,6 +107,11 @@ struct ib_srq *ipath_create_srq(struct ib_pd *ibpd,
 	u32 sz;
 	struct ib_srq *ret;
 
+	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
+		ret = ERR_PTR(-ENOSYS);
+		goto done;
+	}
+
 	if (srq_init_attr->attr.max_wr == 0) {
 		ret = ERR_PTR(-EINVAL);
 		goto done;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 1e0b4b6..784fd5d 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -474,6 +474,9 @@ static struct ib_srq *mthca_create_srq(struct ib_pd *pd,
 	struct mthca_srq *srq;
 	int err;
 
+	if (init_attr->srq_type != IB_SRQT_BASIC)
+		return ERR_PTR(-ENOSYS);
+
 	srq = kmalloc(sizeof *srq, GFP_KERNEL);
 	if (!srq)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/infiniband/hw/qib/qib_srq.c b/drivers/infiniband/hw/qib/qib_srq.c
index c3ec8ef..d623593 100644
--- a/drivers/infiniband/hw/qib/qib_srq.c
+++ b/drivers/infiniband/hw/qib/qib_srq.c
@@ -107,6 +107,11 @@ struct ib_srq *qib_create_srq(struct ib_pd *ibpd,
 	u32 sz;
 	struct ib_srq *ret;
 
+	if (srq_init_attr->srq_type != IB_SRQT_BASIC) {
+		ret = ERR_PTR(-ENOSYS);
+		goto done;
+	}
+
 	if (srq_init_attr->attr.max_sge == 0 ||
 	    srq_init_attr->attr.max_sge > ib_qib_max_srq_sges ||
 	    srq_init_attr->attr.max_wr == 0 ||
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 93d5580..4aac863 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1503,6 +1503,7 @@ static void ipoib_cm_create_srq(struct net_device *dev, int max_sge)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
 	struct ib_srq_init_attr srq_init_attr = {
+		.srq_type = IB_SRQT_BASIC,
 		.attr = {
 			.max_wr  = ipoib_recvq_size,
 			.max_sge = max_sge
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 760662f..1374a66 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -522,6 +522,10 @@ enum ib_cq_notify_flags {
 	IB_CQ_REPORT_MISSED_EVENTS	= 1 << 2,
 };
 
+enum ib_srq_type {
+	IB_SRQT_BASIC
+};
+
 enum ib_srq_attr_mask {
 	IB_SRQ_MAX_WR	= 1 << 0,
 	IB_SRQ_LIMIT	= 1 << 1,
@@ -537,6 +541,7 @@ struct ib_srq_init_attr {
 	void		      (*event_handler)(struct ib_event *, void *);
 	void		       *srq_context;
 	struct ib_srq_attr	attr;
+	enum ib_srq_type	srq_type;
 };
 
 struct ib_qp_cap {
@@ -887,6 +892,7 @@ struct ib_srq {
 	struct ib_uobject      *uobject;
 	void		      (*event_handler)(struct ib_event *, void *);
 	void		       *srq_context;
+	enum ib_srq_type	srq_type;
 	atomic_t		usecnt;
 };
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
