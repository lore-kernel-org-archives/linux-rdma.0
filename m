From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V1 08/10] IB/umem: Add support to huge ODP
Date: Wed,  5 Apr 2017 09:23:57 +0300
Message-ID: <20170405062359.26623-9-leon@kernel.org>
References: <20170405062359.26623-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405062359.26623-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add IB_ACCESS_HUGETLB ib_reg_mr flag.
Hugetlb region registered with this flag
will use single translation entry per huge page.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/umem.c     |  2 +-
 drivers/infiniband/core/umem_odp.c | 19 +++++++++++++++++--
 include/rdma/ib_umem_odp.h         |  6 ++++--
 include/rdma/ib_verbs.h            |  1 +
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 6b87c051ffd4..3dbf811d3c51 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -133,7 +133,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	if (access & IB_ACCESS_ON_DEMAND) {
 		put_pid(umem->pid);
-		ret = ib_umem_odp_get(context, umem);
+		ret = ib_umem_odp_get(context, umem, access);
 		if (ret) {
 			kfree(umem);
 			return ERR_PTR(ret);
diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 73053c8a9e3b..0780b1afefa9 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/vmalloc.h>
+#include <linux/hugetlb.h>
 
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
@@ -306,7 +307,8 @@ struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
 }
 EXPORT_SYMBOL(ib_alloc_odp_umem);
 
-int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
+int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
+		    int access)
 {
 	int ret_val;
 	struct pid *our_pid;
@@ -315,6 +317,20 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 	if (!mm)
 		return -EINVAL;
 
+	if (access & IB_ACCESS_HUGETLB) {
+		struct vm_area_struct *vma;
+		struct hstate *h;
+
+		vma = find_vma(mm, ib_umem_start(umem));
+		if (!vma || !is_vm_hugetlb_page(vma))
+			return -EINVAL;
+		h = hstate_vma(vma);
+		umem->page_shift = huge_page_shift(h);
+		umem->hugetlb = 1;
+	} else {
+		umem->hugetlb = 0;
+	}
+
 	/* Prevent creating ODP MRs in child processes */
 	rcu_read_lock();
 	our_pid = get_task_pid(current->group_leader, PIDTYPE_PID);
@@ -325,7 +341,6 @@ int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
 		goto out_mm;
 	}
 
-	umem->hugetlb = 0;
 	umem->odp_data = kzalloc(sizeof(*umem->odp_data), GFP_KERNEL);
 	if (!umem->odp_data) {
 		ret_val = -ENOMEM;
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 542cd8b3414c..fb67554aabd6 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -84,7 +84,8 @@ struct ib_umem_odp {
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 
-int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem);
+int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem,
+		    int access);
 struct ib_umem *ib_alloc_odp_umem(struct ib_ucontext *context,
 				  unsigned long addr,
 				  size_t size);
@@ -154,7 +155,8 @@ static inline int ib_umem_mmu_notifier_retry(struct ib_umem *item,
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 
 static inline int ib_umem_odp_get(struct ib_ucontext *context,
-				  struct ib_umem *umem)
+				  struct ib_umem *umem,
+				  int access)
 {
 	return -EINVAL;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0f1813c13687..b60288beb3fe 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1336,6 +1336,7 @@ enum ib_access_flags {
 	IB_ACCESS_MW_BIND	= (1<<4),
 	IB_ZERO_BASED		= (1<<5),
 	IB_ACCESS_ON_DEMAND     = (1<<6),
+	IB_ACCESS_HUGETLB	= (1<<7),
 };
 
 /*
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
