From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 7/8] IB/rdmavt: Add multicast functions
Date: Fri, 22 Jan 2016 13:00:55 -0800
Message-ID: <20160122210053.7850.55983.stgit@scvm10.sc.intel.com>
References: <20160122205822.7850.25466.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160122205822.7850.25466.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds in the multicast add and remove functions as well as the
ancillary infrastructure needed.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mcast.c |  335 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mcast.h |    2 
 drivers/infiniband/sw/rdmavt/qp.c    |    2 
 drivers/infiniband/sw/rdmavt/vt.c    |    1 
 include/rdma/rdma_vt.h               |    8 +
 include/rdma/rdmavt_qp.h             |   22 ++
 6 files changed, 367 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index 5a78dc7..528c1ca 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -45,14 +45,345 @@
  *
  */
 
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/rculist.h>
+#include <rdma/rdma_vt.h>
+#include <rdma/rdmavt_qp.h>
+
 #include "mcast.h"
 
+void rvt_driver_mcast_init(struct rvt_dev_info *rdi)
+{
+	/*
+	 * Anything that needs setup for multicast on a per driver or per rdi
+	 * basis should be done in here.
+	 */
+	spin_lock_init(&rdi->n_mcast_grps_lock);
+}
+
+/**
+ * mcast_qp_alloc - alloc a struct to link a QP to mcast GID struct
+ * @qp: the QP to link
+ */
+static struct rvt_mcast_qp *rvt_mcast_qp_alloc(struct rvt_qp *qp)
+{
+	struct rvt_mcast_qp *mqp;
+
+	mqp = kmalloc(sizeof(*mqp), GFP_KERNEL);
+	if (!mqp)
+		goto bail;
+
+	mqp->qp = qp;
+	atomic_inc(&qp->refcount);
+
+bail:
+	return mqp;
+}
+
+static void rvt_mcast_qp_free(struct rvt_mcast_qp *mqp)
+{
+	struct rvt_qp *qp = mqp->qp;
+
+	/* Notify hfi1_destroy_qp() if it is waiting. */
+	if (atomic_dec_and_test(&qp->refcount))
+		wake_up(&qp->wait);
+
+	kfree(mqp);
+}
+
+/**
+ * mcast_alloc - allocate the multicast GID structure
+ * @mgid: the multicast GID
+ *
+ * A list of QPs will be attached to this structure.
+ */
+static struct rvt_mcast *rvt_mcast_alloc(union ib_gid *mgid)
+{
+	struct rvt_mcast *mcast;
+
+	mcast = kzalloc(sizeof(*mcast), GFP_KERNEL);
+	if (!mcast)
+		goto bail;
+
+	mcast->mgid = *mgid;
+	INIT_LIST_HEAD(&mcast->qp_list);
+	init_waitqueue_head(&mcast->wait);
+	atomic_set(&mcast->refcount, 0);
+
+bail:
+	return mcast;
+}
+
+static void rvt_mcast_free(struct rvt_mcast *mcast)
+{
+	struct rvt_mcast_qp *p, *tmp;
+
+	list_for_each_entry_safe(p, tmp, &mcast->qp_list, list)
+		rvt_mcast_qp_free(p);
+
+	kfree(mcast);
+}
+
+/**
+ * rvt_mcast_find - search the global table for the given multicast GID
+ * @ibp: the IB port structure
+ * @mgid: the multicast GID to search for
+ *
+ * Returns NULL if not found.
+ *
+ * The caller is responsible for decrementing the reference count if found.
+ */
+struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid)
+{
+	struct rb_node *n;
+	unsigned long flags;
+	struct rvt_mcast *found = NULL;
+
+	spin_lock_irqsave(&ibp->lock, flags);
+	n = ibp->mcast_tree.rb_node;
+	while (n) {
+		int ret;
+		struct rvt_mcast *mcast;
+
+		mcast = rb_entry(n, struct rvt_mcast, rb_node);
+
+		ret = memcmp(mgid->raw, mcast->mgid.raw,
+			     sizeof(union ib_gid));
+		if (ret < 0) {
+			n = n->rb_left;
+		} else if (ret > 0) {
+			n = n->rb_right;
+		} else {
+			atomic_inc(&mcast->refcount);
+			found = mcast;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&ibp->lock, flags);
+	return found;
+}
+EXPORT_SYMBOL(rvt_mcast_find);
+
+/**
+ * mcast_add - insert mcast GID into table and attach QP struct
+ * @mcast: the mcast GID table
+ * @mqp: the QP to attach
+ *
+ * Return zero if both were added.  Return EEXIST if the GID was already in
+ * the table but the QP was added.  Return ESRCH if the QP was already
+ * attached and neither structure was added.
+ */
+static int rvt_mcast_add(struct rvt_dev_info *rdi, struct rvt_ibport *ibp,
+			 struct rvt_mcast *mcast, struct rvt_mcast_qp *mqp)
+{
+	struct rb_node **n = &ibp->mcast_tree.rb_node;
+	struct rb_node *pn = NULL;
+	int ret;
+
+	spin_lock_irq(&ibp->lock);
+
+	while (*n) {
+		struct rvt_mcast *tmcast;
+		struct rvt_mcast_qp *p;
+
+		pn = *n;
+		tmcast = rb_entry(pn, struct rvt_mcast, rb_node);
+
+		ret = memcmp(mcast->mgid.raw, tmcast->mgid.raw,
+			     sizeof(union ib_gid));
+		if (ret < 0) {
+			n = &pn->rb_left;
+			continue;
+		}
+		if (ret > 0) {
+			n = &pn->rb_right;
+			continue;
+		}
+
+		/* Search the QP list to see if this is already there. */
+		list_for_each_entry_rcu(p, &tmcast->qp_list, list) {
+			if (p->qp == mqp->qp) {
+				ret = ESRCH;
+				goto bail;
+			}
+		}
+		if (tmcast->n_attached ==
+		    rdi->dparms.props.max_mcast_qp_attach) {
+			ret = ENOMEM;
+			goto bail;
+		}
+
+		tmcast->n_attached++;
+
+		list_add_tail_rcu(&mqp->list, &tmcast->qp_list);
+		ret = EEXIST;
+		goto bail;
+	}
+
+	spin_lock(&rdi->n_mcast_grps_lock);
+	if (rdi->n_mcast_grps_allocated == rdi->dparms.props.max_mcast_grp) {
+		spin_unlock(&rdi->n_mcast_grps_lock);
+		ret = ENOMEM;
+		goto bail;
+	}
+
+	rdi->n_mcast_grps_allocated++;
+	spin_unlock(&rdi->n_mcast_grps_lock);
+
+	mcast->n_attached++;
+
+	list_add_tail_rcu(&mqp->list, &mcast->qp_list);
+
+	atomic_inc(&mcast->refcount);
+	rb_link_node(&mcast->rb_node, pn, n);
+	rb_insert_color(&mcast->rb_node, &ibp->mcast_tree);
+
+	ret = 0;
+
+bail:
+	spin_unlock_irq(&ibp->lock);
+
+	return ret;
+}
+
 int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	return -EOPNOTSUPP;
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+	struct rvt_ibport *ibp = rdi->ports[qp->port_num - 1];
+	struct rvt_mcast *mcast;
+	struct rvt_mcast_qp *mqp;
+	int ret = -ENOMEM;
+
+	if (ibqp->qp_num <= 1 || qp->state == IB_QPS_RESET)
+		return -EINVAL;
+
+	/*
+	 * Allocate data structures since its better to do this outside of
+	 * spin locks and it will most likely be needed.
+	 */
+	mcast = rvt_mcast_alloc(gid);
+	if (!mcast)
+		return -ENOMEM;
+
+	mqp = rvt_mcast_qp_alloc(qp);
+	if (!mqp)
+		goto bail_mcast;
+
+	switch (rvt_mcast_add(rdi, ibp, mcast, mqp)) {
+	case ESRCH:
+		/* Neither was used: OK to attach the same QP twice. */
+		ret = 0;
+		goto bail_mqp;
+	case EEXIST: /* The mcast wasn't used */
+		ret = 0;
+		goto bail_mcast;
+	case ENOMEM:
+		/* Exceeded the maximum number of mcast groups. */
+		ret = -ENOMEM;
+		goto bail_mqp;
+	default:
+		break;
+	}
+
+	return 0;
+
+bail_mqp:
+	rvt_mcast_qp_free(mqp);
+
+bail_mcast:
+	rvt_mcast_free(mcast);
+
+	return ret;
 }
 
 int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 {
-	return -EOPNOTSUPP;
+	struct rvt_qp *qp = ibqp_to_rvtqp(ibqp);
+	struct rvt_dev_info *rdi = ib_to_rvt(ibqp->device);
+	struct rvt_ibport *ibp = rdi->ports[qp->port_num - 1];
+	struct rvt_mcast *mcast = NULL;
+	struct rvt_mcast_qp *p, *tmp, *delp = NULL;
+	struct rb_node *n;
+	int last = 0;
+	int ret = 0;
+
+	if (ibqp->qp_num <= 1 || qp->state == IB_QPS_RESET)
+		return -EINVAL;
+
+	spin_lock_irq(&ibp->lock);
+
+	/* Find the GID in the mcast table. */
+	n = ibp->mcast_tree.rb_node;
+	while (1) {
+		if (!n) {
+			spin_unlock_irq(&ibp->lock);
+			return -EINVAL;
+		}
+
+		mcast = rb_entry(n, struct rvt_mcast, rb_node);
+		ret = memcmp(gid->raw, mcast->mgid.raw,
+			     sizeof(union ib_gid));
+		if (ret < 0)
+			n = n->rb_left;
+		else if (ret > 0)
+			n = n->rb_right;
+		else
+			break;
+	}
+
+	/* Search the QP list. */
+	list_for_each_entry_safe(p, tmp, &mcast->qp_list, list) {
+		if (p->qp != qp)
+			continue;
+		/*
+		 * We found it, so remove it, but don't poison the forward
+		 * link until we are sure there are no list walkers.
+		 */
+		list_del_rcu(&p->list);
+		mcast->n_attached--;
+		delp = p;
+
+		/* If this was the last attached QP, remove the GID too. */
+		if (list_empty(&mcast->qp_list)) {
+			rb_erase(&mcast->rb_node, &ibp->mcast_tree);
+			last = 1;
+		}
+		break;
+	}
+
+	spin_unlock_irq(&ibp->lock);
+	/* QP not attached */
+	if (!delp)
+		return -EINVAL;
+
+	/*
+	 * Wait for any list walkers to finish before freeing the
+	 * list element.
+	 */
+	wait_event(mcast->wait, atomic_read(&mcast->refcount) <= 1);
+	rvt_mcast_qp_free(delp);
+
+	if (last) {
+		atomic_dec(&mcast->refcount);
+		wait_event(mcast->wait, !atomic_read(&mcast->refcount));
+		rvt_mcast_free(mcast);
+		spin_lock_irq(&rdi->n_mcast_grps_lock);
+		rdi->n_mcast_grps_allocated--;
+		spin_unlock_irq(&rdi->n_mcast_grps_lock);
+	}
+
+	return 0;
+}
+
+int rvt_mcast_tree_empty(struct rvt_dev_info *rdi)
+{
+	int i;
+	int in_use = 0;
+
+	for (i = 0; i < rdi->dparms.nports; i++)
+		if (rdi->ports[i]->mcast_tree.rb_node)
+			in_use++;
+	return in_use;
 }
diff --git a/drivers/infiniband/sw/rdmavt/mcast.h b/drivers/infiniband/sw/rdmavt/mcast.h
index 21647c3..cd15a98 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.h
+++ b/drivers/infiniband/sw/rdmavt/mcast.h
@@ -50,7 +50,9 @@
 
 #include <rdma/rdma_vt.h>
 
+void rvt_driver_mcast_init(struct rvt_dev_info *rdi);
 int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
 int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid);
+int rvt_mcast_tree_empty(struct rvt_dev_info *rdi);
 
 #endif          /* DEF_RVTMCAST_H */
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 0eeef49..64b9c01 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -240,6 +240,8 @@ static unsigned rvt_free_all_qps(struct rvt_dev_info *rdi)
 	if (rdi->driver_f.free_all_qps)
 		qp_inuse = rdi->driver_f.free_all_qps(rdi);
 
+	qp_inuse += rvt_mcast_tree_empty(rdi);
+
 	if (!rdi->qp_dev)
 		return qp_inuse;
 
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 7f56a42..5a094eb 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -305,6 +305,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, query_srq);
 
 	/* Multicast */
+	rvt_driver_mcast_init(rdi);
 	CHECK_DRIVER_OVERRIDE(rdi, attach_mcast);
 	CHECK_DRIVER_OVERRIDE(rdi, detach_mcast);
 
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 1c7123f..04e9019 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -306,6 +306,11 @@ struct rvt_dev_info {
 	struct kthread_worker *worker; /* per device cq worker */
 	u32 n_cqs_allocated;    /* number of CQs allocated for device */
 	spinlock_t n_cqs_lock; /* protect count of in use cqs */
+
+	/* Multicast */
+	u32 n_mcast_grps_allocated; /* number of mcast groups allocated */
+	spinlock_t n_mcast_grps_lock;
+
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
@@ -399,8 +404,11 @@ struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
 					   void *obj);
 void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
 			  u32 size, void *obj);
+int rvt_reg_mr(struct rvt_qp *qp, struct ib_reg_wr *wr);
+struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid);
 
 /* Temporary export */
 void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 		  enum ib_qp_type type);
+
 #endif          /* DEF_RDMA_VT_H */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index e66bcc9..a97b95b 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -50,6 +50,7 @@
 
 #include <rdma/rdma_vt.h>
 #include <rdma/ib_pack.h>
+#include <rdma/ib_verbs.h>
 /*
  * Atomic bit definitions for r_aflags.
  */
@@ -386,8 +387,27 @@ struct rvt_qp_ibdev {
 };
 
 /*
+ * There is one struct rvt_mcast for each multicast GID.
+ * All attached QPs are then stored as a list of
+ * struct rvt_mcast_qp.
+ */
+struct rvt_mcast_qp {
+	struct list_head list;
+	struct rvt_qp *qp;
+};
+
+struct rvt_mcast {
+	struct rb_node rb_node;
+	union ib_gid mgid;
+	struct list_head qp_list;
+	wait_queue_head_t wait;
+	atomic_t refcount;
+	int n_attached;
+};
+
+/*
  * Since struct rvt_swqe is not a fixed size, we can't simply index into
- * struct hfi1_qp.s_wq.  This function does the array index computation.
+ * struct rvt_qp.s_wq.  This function does the array index computation.
  */
 static inline struct rvt_swqe *rvt_get_swqe_ptr(struct rvt_qp *qp,
 						unsigned n)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
