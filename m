From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/28] IB/rdmavt: Add mechanism to invalidate MR keys
Date: Mon, 25 Jul 2016 13:38:19 -0700
Message-ID: <20160725203818.4800.76401.stgit@scvm10.sc.intel.com>
References: <20160725203554.4800.37248.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160725203554.4800.37248.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

In order to support extended memory management, add the mechanism to
invalidate MR keys. This includes a flag "lkey_invalid" in the MR data
structure that is to be checked when validating access to the MR via
the associated key, and two utility functions to perform fast memory
registration and memory key invalidate operations.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mr.c |   73 ++++++++++++++++++++++++++++++++++++-
 include/rdma/rdma_vt.h            |    3 ++
 include/rdma/rdmavt_mr.h          |    1 +
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 75f158a..80c4b6b 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -140,6 +140,7 @@ static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
 	init_completion(&mr->comp);
 	/* count returning the ptr to user */
 	atomic_set(&mr->refcount, 1);
+	atomic_set(&mr->lkey_invalid, 0);
 	mr->pd = pd;
 	mr->max_segs = count;
 	return 0;
@@ -531,6 +532,72 @@ int rvt_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg,
 }
 
 /**
+ * rvt_fast_reg_mr - fast register physical MR
+ * @qp: the queue pair where the work request comes from
+ * @ibmr: the memory region to be registered
+ * @key: updated key for this memory region
+ * @access: access flags for this memory region
+ *
+ * Returns 0 on success.
+ */
+int rvt_fast_reg_mr(struct rvt_qp *qp, struct ib_mr *ibmr, u32 key,
+		    int access)
+{
+	struct rvt_mr *mr = to_imr(ibmr);
+
+	if (qp->ibqp.pd != mr->mr.pd)
+		return -EACCES;
+
+	/* not applicable to dma MR or user MR */
+	if (!mr->mr.lkey || mr->umem)
+		return -EINVAL;
+
+	if ((key & 0xFFFFFF00) != (mr->mr.lkey & 0xFFFFFF00))
+		return -EINVAL;
+
+	ibmr->lkey = key;
+	ibmr->rkey = key;
+	mr->mr.lkey = key;
+	mr->mr.access_flags = access;
+	atomic_set(&mr->mr.lkey_invalid, 0);
+
+	return 0;
+}
+EXPORT_SYMBOL(rvt_fast_reg_mr);
+
+/**
+ * rvt_invalidate_rkey - invalidate an MR rkey
+ * @qp: queue pair associated with the invalidate op
+ * @rkey: rkey to invalidate
+ *
+ * Returns 0 on success.
+ */
+int rvt_invalidate_rkey(struct rvt_qp *qp, u32 rkey)
+{
+	struct rvt_dev_info *dev = ib_to_rvt(qp->ibqp.device);
+	struct rvt_lkey_table *rkt = &dev->lkey_table;
+	struct rvt_mregion *mr;
+
+	if (rkey == 0)
+		return -EINVAL;
+
+	rcu_read_lock();
+	mr = rcu_dereference(
+		rkt->table[(rkey >> (32 - dev->dparms.lkey_table_size))]);
+	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+		goto bail;
+
+	atomic_set(&mr->lkey_invalid, 1);
+	rcu_read_unlock();
+	return 0;
+
+bail:
+	rcu_read_unlock();
+	return -EINVAL;
+}
+EXPORT_SYMBOL(rvt_invalidate_rkey);
+
+/**
  * rvt_alloc_fmr - allocate a fast memory region
  * @pd: the protection domain for this memory region
  * @mr_access_flags: access flags for this memory region
@@ -733,7 +800,8 @@ int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 	}
 	mr = rcu_dereference(
 		rkt->table[(sge->lkey >> (32 - dev->dparms.lkey_table_size))]);
-	if (unlikely(!mr || mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
+	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
+		     mr->lkey != sge->lkey || mr->pd != &pd->ibpd))
 		goto bail;
 
 	off = sge->addr - mr->user_base;
@@ -833,7 +901,8 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 
 	mr = rcu_dereference(
 		rkt->table[(rkey >> (32 - dev->dparms.lkey_table_size))]);
-	if (unlikely(!mr || mr->lkey != rkey || qp->ibqp.pd != mr->pd))
+	if (unlikely(!mr || atomic_read(&mr->lkey_invalid) ||
+		     mr->lkey != rkey || qp->ibqp.pd != mr->pd))
 		goto bail;
 
 	off = vaddr - mr->iova;
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 3a70dc0..7fdba92 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -487,6 +487,9 @@ void rvt_unregister_device(struct rvt_dev_info *rvd);
 int rvt_check_ah(struct ib_device *ibdev, struct ib_ah_attr *ah_attr);
 int rvt_init_port(struct rvt_dev_info *rdi, struct rvt_ibport *port,
 		  int port_index, u16 *pkey_table);
+int rvt_fast_reg_mr(struct rvt_qp *qp, struct ib_mr *ibmr, u32 key,
+		    int access);
+int rvt_invalidate_rkey(struct rvt_qp *qp, u32 rkey);
 int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index 5edffdc..6b3c6c8 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -81,6 +81,7 @@ struct rvt_mregion {
 	u32 mapsz;              /* size of the map array */
 	u8  page_shift;         /* 0 - non unform/non powerof2 sizes */
 	u8  lkey_published;     /* in global table */
+	atomic_t lkey_invalid;	/* true if current lkey is invalid */
 	struct completion comp; /* complete when refcount goes to zero */
 	atomic_t refcount;
 	struct rvt_segarray *map[0];    /* the segments */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
