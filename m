From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/19] IB/rdmavt/hfi1/qib: Use the MGID and MLID for
 multicast addressing
Date: Fri, 28 Apr 2017 10:39:17 -0700
Message-ID: <20170428173916.23960.18136.stgit@scvm10.sc.intel.com>
References: <20170428173443.23960.32602.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170428173443.23960.32602.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The Infiniband spec defines "A multicast address is defined by a
MGID and a MLID" (section 10.5).

The current code only uses the MGID for identifying multicast groups.
Update the driver to be compliant with this definition.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/verbs.c    |    2 +
 drivers/infiniband/hw/qib/qib_verbs.c |    2 +
 drivers/infiniband/sw/rdmavt/mcast.c  |   61 ++++++++++++++++++++++++---------
 include/rdma/rdma_vt.h                |    3 +-
 include/rdma/rdmavt_qp.h              |    7 +++-
 5 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 070a349..f74abb1 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -603,7 +603,7 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 
 		if (lnh != HFI1_LRH_GRH)
 			goto drop;
-		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid);
+		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid, lid);
 		if (!mcast)
 			goto drop;
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index e120efe..68d449c 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -356,7 +356,7 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 
 		if (lnh != QIB_LRH_GRH)
 			goto drop;
-		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid);
+		mcast = rvt_mcast_find(&ibp->rvp, &hdr->u.l.grh.dgid, lid);
 		if (mcast == NULL)
 			goto drop;
 		this_cpu_inc(ibp->pmastats->n_multicast_rcv);
diff --git a/drivers/infiniband/sw/rdmavt/mcast.c b/drivers/infiniband/sw/rdmavt/mcast.c
index 05c8c2a..1f12b69 100644
--- a/drivers/infiniband/sw/rdmavt/mcast.c
+++ b/drivers/infiniband/sw/rdmavt/mcast.c
@@ -100,10 +100,11 @@ static void rvt_mcast_qp_free(struct rvt_mcast_qp *mqp)
 /**
  * mcast_alloc - allocate the multicast GID structure
  * @mgid: the multicast GID
+ * @lid: the muilticast LID (host order)
  *
  * A list of QPs will be attached to this structure.
  */
-static struct rvt_mcast *rvt_mcast_alloc(union ib_gid *mgid)
+static struct rvt_mcast *rvt_mcast_alloc(union ib_gid *mgid, u16 lid)
 {
 	struct rvt_mcast *mcast;
 
@@ -111,7 +112,9 @@ static void rvt_mcast_qp_free(struct rvt_mcast_qp *mqp)
 	if (!mcast)
 		goto bail;
 
-	mcast->mgid = *mgid;
+	mcast->mcast_addr.mgid = *mgid;
+	mcast->mcast_addr.lid = lid;
+
 	INIT_LIST_HEAD(&mcast->qp_list);
 	init_waitqueue_head(&mcast->wait);
 	atomic_set(&mcast->refcount, 0);
@@ -131,15 +134,19 @@ static void rvt_mcast_free(struct rvt_mcast *mcast)
 }
 
 /**
- * rvt_mcast_find - search the global table for the given multicast GID
+ * rvt_mcast_find - search the global table for the given multicast GID/LID
+ * NOTE: It is valid to have 1 MLID with multiple MGIDs.  It is not valid
+ * to have 1 MGID with multiple MLIDs.
  * @ibp: the IB port structure
  * @mgid: the multicast GID to search for
+ * @lid: the multicast LID portion of the multicast address (host order)
  *
  * The caller is responsible for decrementing the reference count if found.
  *
  * Return: NULL if not found.
  */
-struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid)
+struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid,
+				 u16 lid)
 {
 	struct rb_node *n;
 	unsigned long flags;
@@ -153,15 +160,18 @@ struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid)
 
 		mcast = rb_entry(n, struct rvt_mcast, rb_node);
 
-		ret = memcmp(mgid->raw, mcast->mgid.raw,
-			     sizeof(union ib_gid));
+		ret = memcmp(mgid->raw, mcast->mcast_addr.mgid.raw,
+			     sizeof(*mgid));
 		if (ret < 0) {
 			n = n->rb_left;
 		} else if (ret > 0) {
 			n = n->rb_right;
 		} else {
-			atomic_inc(&mcast->refcount);
-			found = mcast;
+			/* MGID/MLID must match */
+			if (mcast->mcast_addr.lid == lid) {
+				atomic_inc(&mcast->refcount);
+				found = mcast;
+			}
 			break;
 		}
 	}
@@ -177,7 +187,8 @@ struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid)
  *
  * Return: zero if both were added.  Return EEXIST if the GID was already in
  * the table but the QP was added.  Return ESRCH if the QP was already
- * attached and neither structure was added.
+ * attached and neither structure was added. Return EINVAL if the MGID was
+ * found, but the MLID did NOT match.
  */
 static int rvt_mcast_add(struct rvt_dev_info *rdi, struct rvt_ibport *ibp,
 			 struct rvt_mcast *mcast, struct rvt_mcast_qp *mqp)
@@ -195,8 +206,9 @@ static int rvt_mcast_add(struct rvt_dev_info *rdi, struct rvt_ibport *ibp,
 		pn = *n;
 		tmcast = rb_entry(pn, struct rvt_mcast, rb_node);
 
-		ret = memcmp(mcast->mgid.raw, tmcast->mgid.raw,
-			     sizeof(union ib_gid));
+		ret = memcmp(mcast->mcast_addr.mgid.raw,
+			     tmcast->mcast_addr.mgid.raw,
+			     sizeof(mcast->mcast_addr.mgid));
 		if (ret < 0) {
 			n = &pn->rb_left;
 			continue;
@@ -206,6 +218,11 @@ static int rvt_mcast_add(struct rvt_dev_info *rdi, struct rvt_ibport *ibp,
 			continue;
 		}
 
+		if (tmcast->mcast_addr.lid != mcast->mcast_addr.lid) {
+			ret = EINVAL;
+			goto bail;
+		}
+
 		/* Search the QP list to see if this is already there. */
 		list_for_each_entry_rcu(p, &tmcast->qp_list, list) {
 			if (p->qp == mqp->qp) {
@@ -276,7 +293,7 @@ int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	 * Allocate data structures since its better to do this outside of
 	 * spin locks and it will most likely be needed.
 	 */
-	mcast = rvt_mcast_alloc(gid);
+	mcast = rvt_mcast_alloc(gid, lid);
 	if (!mcast)
 		return -ENOMEM;
 
@@ -296,6 +313,10 @@ int rvt_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		/* Exceeded the maximum number of mcast groups. */
 		ret = -ENOMEM;
 		goto bail_mqp;
+	case EINVAL:
+		/* Invalid MGID/MLID pair */
+		ret = -EINVAL;
+		goto bail_mqp;
 	default:
 		break;
 	}
@@ -344,14 +365,20 @@ int rvt_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 		}
 
 		mcast = rb_entry(n, struct rvt_mcast, rb_node);
-		ret = memcmp(gid->raw, mcast->mgid.raw,
-			     sizeof(union ib_gid));
-		if (ret < 0)
+		ret = memcmp(gid->raw, mcast->mcast_addr.mgid.raw,
+			     sizeof(*gid));
+		if (ret < 0) {
 			n = n->rb_left;
-		else if (ret > 0)
+		} else if (ret > 0) {
 			n = n->rb_right;
-		else
+		} else {
+			/* MGID/MLID must match */
+			if (mcast->mcast_addr.lid != lid) {
+				spin_unlock_irq(&ibp->lock);
+				return -EINVAL;
+			}
 			break;
+		}
 	}
 
 	/* Search the QP list. */
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 8fc1ca7..7f89568 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -516,6 +516,7 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		struct rvt_sge *isge, struct ib_sge *sge, int acc);
-struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid);
+struct rvt_mcast *rvt_mcast_find(struct rvt_ibport *ibp, union ib_gid *mgid,
+				 u16 lid);
 
 #endif          /* DEF_RDMA_VT_H */
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index e3bb312..75a077c 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -435,9 +435,14 @@ struct rvt_mcast_qp {
 	struct rvt_qp *qp;
 };
 
+struct rvt_mcast_addr {
+	union ib_gid mgid;
+	u16 lid;
+};
+
 struct rvt_mcast {
 	struct rb_node rb_node;
-	union ib_gid mgid;
+	struct rvt_mcast_addr mcast_addr;
 	struct list_head qp_list;
 	wait_queue_head_t wait;
 	atomic_t refcount;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
