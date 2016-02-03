From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/7] IB/rdmavt: Add srq functionality to rdmavt
Date: Wed, 03 Feb 2016 14:14:36 -0800
Message-ID: <20160203221430.1765.4768.stgit@scvm10.sc.intel.com>
References: <20160203221136.1765.8947.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203221136.1765.8947.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fill in srq function stubs with code derived from hfi1 and qib.
Move necessary functions and data structure members as well.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c  |   37 +++++
 drivers/infiniband/sw/rdmavt/srq.c |  257 +++++++++++++++++++++++++++++++++++-
 drivers/infiniband/sw/rdmavt/srq.h |    1 
 drivers/infiniband/sw/rdmavt/vt.c  |    1 
 include/rdma/rdma_vt.h             |    3 
 5 files changed, 293 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 8f85665..8efb0f5 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -1510,7 +1510,42 @@ bail:
 int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
 		      struct ib_recv_wr **bad_wr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
+	struct rvt_rwq *wq;
+	unsigned long flags;
+
+	for (; wr; wr = wr->next) {
+		struct rvt_rwqe *wqe;
+		u32 next;
+		int i;
+
+		if ((unsigned)wr->num_sge > srq->rq.max_sge) {
+			*bad_wr = wr;
+			return -EINVAL;
+		}
+
+		spin_lock_irqsave(&srq->rq.lock, flags);
+		wq = srq->rq.wq;
+		next = wq->head + 1;
+		if (next >= srq->rq.size)
+			next = 0;
+		if (next == wq->tail) {
+			spin_unlock_irqrestore(&srq->rq.lock, flags);
+			*bad_wr = wr;
+			return -ENOMEM;
+		}
+
+		wqe = rvt_get_rwqe_ptr(&srq->rq, wq->head);
+		wqe->wr_id = wr->wr_id;
+		wqe->num_sge = wr->num_sge;
+		for (i = 0; i < wr->num_sge; i++)
+			wqe->sg_list[i] = wr->sg_list[i];
+		/* Make sure queue entry is written before the head index. */
+		smp_wmb();
+		wq->head = next;
+		spin_unlock_irqrestore(&srq->rq.lock, flags);
+	}
+	return 0;
 }
 
 void rvt_free_qpn(struct rvt_qpn_table *qpt, u32 qpn)
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index c9eb8b3..4960a89 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -45,8 +45,21 @@
  *
  */
 
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+
 #include "srq.h"
 
+/*
+ * Do any initialization needed when a driver registers with rdmavt.
+ */
+void rvt_driver_srq_init(struct rvt_dev_info *rdi)
+{
+	spin_lock_init(&rdi->n_srqs_lock);
+	rdi->n_srqs_allocated = 0;
+}
+
 /**
  * rvt_create_srq - create a shared receive queue
  * @ibpd: the protection domain of the SRQ to create
@@ -57,7 +70,96 @@ struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 			      struct ib_srq_init_attr *srq_init_attr,
 			      struct ib_udata *udata)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	struct rvt_dev_info *dev = ib_to_rvt(ibpd->device);
+	struct rvt_srq *srq;
+	u32 sz;
+	struct ib_srq *ret;
+
+	if (srq_init_attr->srq_type != IB_SRQT_BASIC)
+		return ERR_PTR(-ENOSYS);
+
+	if (srq_init_attr->attr.max_sge == 0 ||
+	    srq_init_attr->attr.max_sge > dev->dparms.props.max_srq_sge ||
+	    srq_init_attr->attr.max_wr == 0 ||
+	    srq_init_attr->attr.max_wr > dev->dparms.props.max_srq_wr)
+		return ERR_PTR(-EINVAL);
+
+	srq = kmalloc(sizeof(*srq), GFP_KERNEL);
+	if (!srq)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 * Need to use vmalloc() if we want to support large #s of entries.
+	 */
+	srq->rq.size = srq_init_attr->attr.max_wr + 1;
+	srq->rq.max_sge = srq_init_attr->attr.max_sge;
+	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
+		sizeof(struct rvt_rwqe);
+	srq->rq.wq = vmalloc_user(sizeof(struct rvt_rwq) + srq->rq.size * sz);
+	if (!srq->rq.wq) {
+		ret = ERR_PTR(-ENOMEM);
+		goto bail_srq;
+	}
+
+	/*
+	 * Return the address of the RWQ as the offset to mmap.
+	 * See rvt_mmap() for details.
+	 */
+	if (udata && udata->outlen >= sizeof(__u64)) {
+		int err;
+		u32 s = sizeof(struct rvt_rwq) + srq->rq.size * sz;
+
+		srq->ip =
+		    rvt_create_mmap_info(dev, s, ibpd->uobject->context,
+					 srq->rq.wq);
+		if (!srq->ip) {
+			ret = ERR_PTR(-ENOMEM);
+			goto bail_wq;
+		}
+
+		err = ib_copy_to_udata(udata, &srq->ip->offset,
+				       sizeof(srq->ip->offset));
+		if (err) {
+			ret = ERR_PTR(err);
+			goto bail_ip;
+		}
+	} else {
+		srq->ip = NULL;
+	}
+
+	/*
+	 * ib_create_srq() will initialize srq->ibsrq.
+	 */
+	spin_lock_init(&srq->rq.lock);
+	srq->rq.wq->head = 0;
+	srq->rq.wq->tail = 0;
+	srq->limit = srq_init_attr->attr.srq_limit;
+
+	spin_lock(&dev->n_srqs_lock);
+	if (dev->n_srqs_allocated == dev->dparms.props.max_srq) {
+		spin_unlock(&dev->n_srqs_lock);
+		ret = ERR_PTR(-ENOMEM);
+		goto bail_ip;
+	}
+
+	dev->n_srqs_allocated++;
+	spin_unlock(&dev->n_srqs_lock);
+
+	if (srq->ip) {
+		spin_lock_irq(&dev->pending_lock);
+		list_add(&srq->ip->pending_mmaps, &dev->pending_mmaps);
+		spin_unlock_irq(&dev->pending_lock);
+	}
+
+	return &srq->ibsrq;
+
+bail_ip:
+	kfree(srq->ip);
+bail_wq:
+	vfree(srq->rq.wq);
+bail_srq:
+	kfree(srq);
+	return ret;
 }
 
 /**
@@ -71,16 +173,161 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 		   enum ib_srq_attr_mask attr_mask,
 		   struct ib_udata *udata)
 {
-	return -EOPNOTSUPP;
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
+	struct rvt_dev_info *dev = ib_to_rvt(ibsrq->device);
+	struct rvt_rwq *wq;
+	int ret = 0;
+
+	if (attr_mask & IB_SRQ_MAX_WR) {
+		struct rvt_rwq *owq;
+		struct rvt_rwqe *p;
+		u32 sz, size, n, head, tail;
+
+		/* Check that the requested sizes are below the limits. */
+		if ((attr->max_wr > dev->dparms.props.max_srq_wr) ||
+		    ((attr_mask & IB_SRQ_LIMIT) ?
+		     attr->srq_limit : srq->limit) > attr->max_wr)
+			return -EINVAL;
+
+		sz = sizeof(struct rvt_rwqe) +
+			srq->rq.max_sge * sizeof(struct ib_sge);
+		size = attr->max_wr + 1;
+		wq = vmalloc_user(sizeof(struct rvt_rwq) + size * sz);
+		if (!wq)
+			return -ENOMEM;
+
+		/* Check that we can write the offset to mmap. */
+		if (udata && udata->inlen >= sizeof(__u64)) {
+			__u64 offset_addr;
+			__u64 offset = 0;
+
+			ret = ib_copy_from_udata(&offset_addr, udata,
+						 sizeof(offset_addr));
+			if (ret)
+				goto bail_free;
+			udata->outbuf = (void __user *)
+					(unsigned long)offset_addr;
+			ret = ib_copy_to_udata(udata, &offset,
+					       sizeof(offset));
+			if (ret)
+				goto bail_free;
+		}
+
+		spin_lock_irq(&srq->rq.lock);
+		/*
+		 * validate head and tail pointer values and compute
+		 * the number of remaining WQEs.
+		 */
+		owq = srq->rq.wq;
+		head = owq->head;
+		tail = owq->tail;
+		if (head >= srq->rq.size || tail >= srq->rq.size) {
+			ret = -EINVAL;
+			goto bail_unlock;
+		}
+		n = head;
+		if (n < tail)
+			n += srq->rq.size - tail;
+		else
+			n -= tail;
+		if (size <= n) {
+			ret = -EINVAL;
+			goto bail_unlock;
+		}
+		n = 0;
+		p = wq->wq;
+		while (tail != head) {
+			struct rvt_rwqe *wqe;
+			int i;
+
+			wqe = rvt_get_rwqe_ptr(&srq->rq, tail);
+			p->wr_id = wqe->wr_id;
+			p->num_sge = wqe->num_sge;
+			for (i = 0; i < wqe->num_sge; i++)
+				p->sg_list[i] = wqe->sg_list[i];
+			n++;
+			p = (struct rvt_rwqe *)((char *)p + sz);
+			if (++tail >= srq->rq.size)
+				tail = 0;
+		}
+		srq->rq.wq = wq;
+		srq->rq.size = size;
+		wq->head = n;
+		wq->tail = 0;
+		if (attr_mask & IB_SRQ_LIMIT)
+			srq->limit = attr->srq_limit;
+		spin_unlock_irq(&srq->rq.lock);
+
+		vfree(owq);
+
+		if (srq->ip) {
+			struct rvt_mmap_info *ip = srq->ip;
+			struct rvt_dev_info *dev = ib_to_rvt(srq->ibsrq.device);
+			u32 s = sizeof(struct rvt_rwq) + size * sz;
+
+			rvt_update_mmap_info(dev, ip, s, wq);
+
+			/*
+			 * Return the offset to mmap.
+			 * See rvt_mmap() for details.
+			 */
+			if (udata && udata->inlen >= sizeof(__u64)) {
+				ret = ib_copy_to_udata(udata, &ip->offset,
+						       sizeof(ip->offset));
+				if (ret)
+					return ret;
+			}
+
+			/*
+			 * Put user mapping info onto the pending list
+			 * unless it already is on the list.
+			 */
+			spin_lock_irq(&dev->pending_lock);
+			if (list_empty(&ip->pending_mmaps))
+				list_add(&ip->pending_mmaps,
+					 &dev->pending_mmaps);
+			spin_unlock_irq(&dev->pending_lock);
+		}
+	} else if (attr_mask & IB_SRQ_LIMIT) {
+		spin_lock_irq(&srq->rq.lock);
+		if (attr->srq_limit >= srq->rq.size)
+			ret = -EINVAL;
+		else
+			srq->limit = attr->srq_limit;
+		spin_unlock_irq(&srq->rq.lock);
+	}
+	return ret;
+
+bail_unlock:
+	spin_unlock_irq(&srq->rq.lock);
+bail_free:
+	vfree(wq);
+	return ret;
 }
 
 int rvt_query_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr)
 {
-	return -EOPNOTSUPP;
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
+
+	attr->max_wr = srq->rq.size - 1;
+	attr->max_sge = srq->rq.max_sge;
+	attr->srq_limit = srq->limit;
+	return 0;
 }
 
 int rvt_destroy_srq(struct ib_srq *ibsrq)
 {
-	return -EOPNOTSUPP;
-}
+	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
+	struct rvt_dev_info *dev = ib_to_rvt(ibsrq->device);
 
+	spin_lock(&dev->n_srqs_lock);
+	dev->n_srqs_allocated--;
+	spin_unlock(&dev->n_srqs_lock);
+	if (srq->ip)
+		kref_put(&srq->ip->ref, rvt_release_mmap_info);
+	else
+		vfree(srq->rq.wq);
+	kfree(srq);
+
+	return 0;
+}
diff --git a/drivers/infiniband/sw/rdmavt/srq.h b/drivers/infiniband/sw/rdmavt/srq.h
index 9f07880..bf0eaaf 100644
--- a/drivers/infiniband/sw/rdmavt/srq.h
+++ b/drivers/infiniband/sw/rdmavt/srq.h
@@ -49,6 +49,7 @@
  */
 
 #include <rdma/rdma_vt.h>
+void rvt_driver_srq_init(struct rvt_dev_info *rdi);
 struct ib_srq *rvt_create_srq(struct ib_pd *ibpd,
 			      struct ib_srq_init_attr *srq_init_attr,
 			      struct ib_udata *udata);
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index 571463e..d45206c 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -323,6 +323,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, modify_srq);
 	CHECK_DRIVER_OVERRIDE(rdi, destroy_srq);
 	CHECK_DRIVER_OVERRIDE(rdi, query_srq);
+	rvt_driver_srq_init(rdi);
 
 	/* Multicast */
 	rvt_driver_mcast_init(rdi);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index f6569b2..1b77065 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -299,6 +299,9 @@ struct rvt_dev_info {
 	int n_ahs_allocated;
 	spinlock_t n_ahs_lock; /* Protect ah allocated count */
 
+	u32 n_srqs_allocated;
+	spinlock_t n_srqs_lock; /* Protect srqs allocated count */
+
 	int flags;
 	struct rvt_ibport **ports;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
