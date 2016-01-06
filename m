From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 35/36] IB/rdmavt: Add mmap related functions
Date: Wed, 06 Jan 2016 10:04:57 -0800
Message-ID: <20160106180451.8747.41824.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The mmap data structure was moved in a previous commit. This patch now
pulls in the related functions.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/mmap.c |  140 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/mmap.h |    2 -
 drivers/infiniband/sw/rdmavt/vt.c   |    1 
 include/rdma/rdma_vt.h              |   15 ++++
 4 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index d09f3a0..fc30ff7 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -46,8 +46,61 @@
  */
 
 #include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <asm/pgtable.h>
 #include "mmap.h"
 
+void rvt_mmap_init(struct rvt_dev_info *rdi)
+{
+	INIT_LIST_HEAD(&rdi->pending_mmaps);
+	spin_lock_init(&rdi->pending_lock);
+	rdi->mmap_offset = PAGE_SIZE;
+	spin_lock_init(&rdi->mmap_offset_lock);
+}
+
+/**
+ * rvt_release_mmap_info - free mmap info structure
+ * @ref: a pointer to the kref within struct rvt_mmap_info
+ */
+void rvt_release_mmap_info(struct kref *ref)
+{
+	struct rvt_mmap_info *ip =
+		container_of(ref, struct rvt_mmap_info, ref);
+	struct rvt_dev_info *rdi = ib_to_rvt(ip->context->device);
+
+	spin_lock_irq(&rdi->pending_lock);
+	list_del(&ip->pending_mmaps);
+	spin_unlock_irq(&rdi->pending_lock);
+
+	vfree(ip->obj);
+	kfree(ip);
+}
+EXPORT_SYMBOL(rvt_release_mmap_info);
+
+/*
+ * open and close keep track of how many times the CQ is mapped,
+ * to avoid releasing it.
+ */
+static void rvt_vma_open(struct vm_area_struct *vma)
+{
+	struct rvt_mmap_info *ip = vma->vm_private_data;
+
+	kref_get(&ip->ref);
+}
+
+static void rvt_vma_close(struct vm_area_struct *vma)
+{
+	struct rvt_mmap_info *ip = vma->vm_private_data;
+
+	kref_put(&ip->ref, rvt_release_mmap_info);
+}
+
+static const struct vm_operations_struct rvt_vm_ops = {
+	.open = rvt_vma_open,
+	.close = rvt_vma_close,
+};
+
 /**
  * rvt_mmap - create a new mmap region
  * @context: the IB user context of the process making the mmap() call
@@ -56,5 +109,90 @@
  */
 int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 {
-	return -EOPNOTSUPP;
+	struct rvt_dev_info *rdi = ib_to_rvt(context->device);
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	struct rvt_mmap_info *ip, *pp;
+	int ret = -EINVAL;
+
+	/*
+	 * Search the device's list of objects waiting for a mmap call.
+	 * Normally, this list is very short since a call to create a
+	 * CQ, QP, or SRQ is soon followed by a call to mmap().
+	 */
+	spin_lock_irq(&rdi->pending_lock);
+	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps,
+				 pending_mmaps) {
+		/* Only the creator is allowed to mmap the object */
+		if (context != ip->context || (__u64)offset != ip->offset)
+			continue;
+		/* Don't allow a mmap larger than the object. */
+		if (size > ip->size)
+			break;
+
+		list_del_init(&ip->pending_mmaps);
+		spin_unlock_irq(&rdi->pending_lock);
+
+		ret = remap_vmalloc_range(vma, ip->obj, 0);
+		if (ret)
+			goto done;
+		vma->vm_ops = &rvt_vm_ops;
+		vma->vm_private_data = ip;
+		rvt_vma_open(vma);
+		goto done;
+	}
+	spin_unlock_irq(&rdi->pending_lock);
+done:
+	return ret;
+}
+EXPORT_SYMBOL(rvt_mmap);
+
+/*
+ * Allocate information for hfi1_mmap
+ */
+struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj)
+{
+	struct rvt_mmap_info *ip;
+
+	ip = kmalloc(sizeof(*ip), GFP_KERNEL);
+	if (!ip)
+		return ip;
+
+	size = PAGE_ALIGN(size);
+
+	spin_lock_irq(&rdi->mmap_offset_lock);
+	if (rdi->mmap_offset == 0)
+		rdi->mmap_offset = PAGE_SIZE;
+	ip->offset = rdi->mmap_offset;
+	rdi->mmap_offset += size;
+	spin_unlock_irq(&rdi->mmap_offset_lock);
+
+	INIT_LIST_HEAD(&ip->pending_mmaps);
+	ip->size = size;
+	ip->context = context;
+	ip->obj = obj;
+	kref_init(&ip->ref);
+
+	return ip;
+}
+EXPORT_SYMBOL(rvt_create_mmap_info);
+
+void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
+			  u32 size, void *obj)
+{
+	size = PAGE_ALIGN(size);
+
+	spin_lock_irq(&rdi->mmap_offset_lock);
+	if (rdi->mmap_offset == 0)
+		rdi->mmap_offset = PAGE_SIZE;
+	ip->offset = rdi->mmap_offset;
+	rdi->mmap_offset += size;
+	spin_unlock_irq(&rdi->mmap_offset_lock);
+
+	ip->size = size;
+	ip->obj = obj;
 }
+EXPORT_SYMBOL(rvt_update_mmap_info);
diff --git a/drivers/infiniband/sw/rdmavt/mmap.h b/drivers/infiniband/sw/rdmavt/mmap.h
index 94f6377..3513e25 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.h
+++ b/drivers/infiniband/sw/rdmavt/mmap.h
@@ -50,6 +50,6 @@
 
 #include <rdma/rdma_vt.h>
 
-int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+void rvt_mmap_init(struct rvt_dev_info *rdi);
 
 #endif          /* DEF_RDMAVTMMAP_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index f2d995d..ab4105a 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -241,6 +241,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	}
 
 	/* Once we get past here we can use the rvt_pr macros */
+	rvt_mmap_init(rdi);
 
 	/* Dev Ops */
 	CHECK_DRIVER_OVERRIDE(rdi, query_device);
diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
index 950c291..fd25d23 100644
--- a/include/rdma/rdma_vt.h
+++ b/include/rdma/rdma_vt.h
@@ -254,6 +254,12 @@ struct rvt_dev_info {
 	struct rvt_ibport **ports;
 
 	struct rvt_qp_ibdev *qp_dev;
+
+	/* memory maps */
+	struct list_head pending_mmaps;
+	spinlock_t mmap_offset_lock; /* protect mmap_offset */
+	u32 mmap_offset;
+	spinlock_t pending_lock; /* protect pending mmap list */
 };
 
 static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
@@ -285,4 +291,13 @@ int rvt_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		u32 len, u64 vaddr, u32 rkey, int acc);
 int rvt_lkey_ok(struct rvt_lkey_table *rkt, struct rvt_pd *pd,
 		struct rvt_sge *isge, struct ib_sge *sge, int acc);
+int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
+void rvt_release_mmap_info(struct kref *ref);
+struct rvt_mmap_info *rvt_create_mmap_info(struct rvt_dev_info *rdi,
+					   u32 size,
+					   struct ib_ucontext *context,
+					   void *obj);
+void rvt_update_mmap_info(struct rvt_dev_info *rdi, struct rvt_mmap_info *ip,
+			  u32 size, void *obj);
+
 #endif          /* DEF_RDMA_VT_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
