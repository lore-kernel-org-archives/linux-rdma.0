From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
Subject: [PATCH 5/8] IB/odp/hmm: add core infiniband structure and helper for ODP with HMM v2.
Date: Fri, 17 Jul 2015 15:01:02 -0400
Message-ID: <1437159665-6612-6-git-send-email-jglisse@redhat.com>
References: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437159665-6612-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christophe Harle <charle@nvidia.com>, Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, Mark Hairgrove <mhairgrove@nvidia.com>, Lucien Dunning <ldunning@nvidia.com>, Cameron Buschardt <cabuschardt@nvidia.com>, Arvind Gopalakrishnan <arvindg@nvidia.com>, Haggai Eran <haggaie@mellanox.com>, Shachar Raindel <raindel@mellanox.com>, Liran Liss <liranl@mellanox.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>
List-Id: linux-rdma@vger.kernel.org

This add new core infiniband structure and helper to implement ODP (on
demand paging) on top of HMM. We need to retain the tree of ib_umem as
some hardware associate unique identifiant with each umem (or mr) and
only allow hardware page table to be updated using this unique id.

Changed since v1:
  - Adapt to new hmm_mirror lifetime rules.
  - Fix scan of existing mirror in ib_umem_odp_get().

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Haggai Eran <haggaie@mellanox.com>
---
 drivers/infiniband/core/umem_odp.c    | 150 ++++++++++++++++++++++++++=
+++++++-
 drivers/infiniband/core/uverbs_cmd.c  |   6 +-
 drivers/infiniband/core/uverbs_main.c |   6 ++
 include/rdma/ib_umem_odp.h            |  28 ++++++-
 include/rdma/ib_verbs.h               |  17 +++-
 5 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
index 7f16120..ac87ac6 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -41,9 +41,157 @@
 #include <rdma/ib_umem.h>
 #include <rdma/ib_umem_odp.h>
=20
+
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+
+
+static void ib_mirror_destroy(struct kref *kref)
+{
+	struct ib_mirror *ib_mirror;
+	struct ib_device *ib_device;
+
+	ib_mirror =3D container_of(kref, struct ib_mirror, kref);
+
+	ib_device =3D ib_mirror->ib_device;
+	mutex_lock(&ib_device->hmm_mutex);
+	list_del_init(&ib_mirror->list);
+	mutex_unlock(&ib_device->hmm_mutex);
+
+	/* hmm_mirror_unregister() will free the structure. */
+	hmm_mirror_unregister(&ib_mirror->base);
+}
+
+void ib_mirror_unref(struct ib_mirror *ib_mirror)
+{
+	if (ib_mirror =3D=3D NULL)
+		return;
+
+	kref_put(&ib_mirror->kref, ib_mirror_destroy);
+}
+EXPORT_SYMBOL(ib_mirror_unref);
+
+static inline struct ib_mirror *ib_mirror_ref(struct ib_mirror *ib_mir=
ror)
+{
+	if (!ib_mirror || !kref_get_unless_zero(&ib_mirror->kref))
+		return NULL;
+	return ib_mirror;
+}
+
+int ib_umem_odp_get(struct ib_ucontext *context, struct ib_umem *umem)
+{
+	struct mm_struct *mm =3D get_task_mm(current);
+	struct ib_device *ib_device =3D context->device;
+	struct ib_mirror *ib_mirror;
+	struct pid *our_pid;
+	int ret;
+
+	if (!mm || !ib_device->hmm_ready)
+		return -EINVAL;
+
+	/* FIXME can this really happen ? */
+	if (unlikely(ib_umem_start(umem) =3D=3D ib_umem_end(umem)))
+		return -EINVAL;
+
+	/* Prevent creating ODP MRs in child processes */
+	rcu_read_lock();
+	our_pid =3D get_task_pid(current->group_leader, PIDTYPE_PID);
+	rcu_read_unlock();
+	put_pid(our_pid);
+	if (context->tgid !=3D our_pid) {
+		mmput(mm);
+		return -EINVAL;
+	}
+
+	umem->hugetlb =3D 0;
+	umem->odp_data =3D kmalloc(sizeof(*umem->odp_data), GFP_KERNEL);
+	if (umem->odp_data =3D=3D NULL) {
+		mmput(mm);
+		return -ENOMEM;
+	}
+	umem->odp_data->private =3D NULL;
+	umem->odp_data->umem =3D umem;
+
+	mutex_lock(&ib_device->hmm_mutex);
+	/* Is there an existing mirror for this process mm ? */
+	ib_mirror =3D ib_mirror_ref(context->ib_mirror);
+	if (!ib_mirror) {
+		struct ib_mirror *tmp;
+
+		list_for_each_entry(tmp, &ib_device->ib_mirrors, list) {
+			if (tmp->base.hmm->mm !=3D mm)
+				continue;
+			ib_mirror =3D ib_mirror_ref(tmp);
+			break;
+		}
+	}
+
+	if (!ib_mirror) {
+		/* We need to create a new mirror. */
+		ib_mirror =3D kmalloc(sizeof(*ib_mirror), GFP_KERNEL);
+		if (!ib_mirror) {
+			mutex_unlock(&ib_device->hmm_mutex);
+			mmput(mm);
+			return -ENOMEM;
+		}
+		kref_init(&ib_mirror->kref);
+		init_rwsem(&ib_mirror->hmm_mr_rwsem);
+		ib_mirror->umem_tree =3D RB_ROOT;
+		ib_mirror->ib_device =3D ib_device;
+
+		ib_mirror->base.device =3D &ib_device->hmm_dev;
+		ret =3D hmm_mirror_register(&ib_mirror->base);
+		if (ret) {
+			mutex_unlock(&ib_device->hmm_mutex);
+			kfree(ib_mirror);
+			mmput(mm);
+			return ret;
+		}
+
+		list_add(&ib_mirror->list, &ib_device->ib_mirrors);
+		context->ib_mirror =3D ib_mirror_ref(ib_mirror);
+	}
+	mutex_unlock(&ib_device->hmm_mutex);
+	umem->odp_data.ib_mirror =3D ib_mirror;
+
+	down_write(&ib_mirror->umem_rwsem);
+	rbt_ib_umem_insert(&umem->odp_data->interval_tree, &mirror->umem_tree=
);
+	up_write(&ib_mirror->umem_rwsem);
+
+	mmput(mm);
+	return 0;
+}
+
+void ib_umem_odp_release(struct ib_umem *umem)
+{
+	struct ib_mirror *ib_mirror =3D umem->odp_data;
+
+	/*
+	 * Ensure that no more pages are mapped in the umem.
+	 *
+	 * It is the driver's responsibility to ensure, before calling us,
+	 * that the hardware will not attempt to access the MR any more.
+	 */
+
+	/* One optimization to release resources early here would be to call =
:
+	 *	hmm_mirror_range_discard(&ib_mirror->base,
+	 *			 ib_umem_start(umem),
+	 *			 ib_umem_end(umem));
+	 * But we can have overlapping umem so we would need to only discard
+	 * range covered by one and only one umem while holding the umem rwse=
m.
+	 */
+	down_write(&ib_mirror->umem_rwsem);
+	rbt_ib_umem_remove(&umem->odp_data->interval_tree, &mirror->umem_tree=
);
+	up_write(&ib_mirror->umem_rwsem);
+
+	ib_mirror_unref(ib_mirror);
+	kfree(umem->odp_data);
+	kfree(umem);
+}
+
+
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
+
 static void ib_umem_notifier_start_account(struct ib_umem *item)
 {
 	mutex_lock(&item->odp_data->umem_mutex);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index 58f9a73..165c9cd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -337,7 +337,9 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file=
 *file,
 	ucontext->closing =3D 0;
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+	ucontext->ib_mirror =3D NULL;
+#else  /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	ucontext->umem_tree =3D RB_ROOT;
 	init_rwsem(&ucontext->umem_rwsem);
 	ucontext->odp_mrs_count =3D 0;
@@ -348,7 +350,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file=
 *file,
 		goto err_free;
 	if (!(dev_attr.device_cap_flags & IB_DEVICE_ON_DEMAND_PAGING))
 		ucontext->invalidate_range =3D NULL;
-#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
=20
 	resp.num_comp_vectors =3D file->device->num_comp_vectors;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband=
/core/uverbs_main.c
index f6eef2d..361f531 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -45,6 +45,7 @@
 #include <linux/cdev.h>
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
+#include <rdma/ib_umem_odp.h>
=20
 #include <asm/uaccess.h>
=20
@@ -298,6 +299,11 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uv=
erbs_file *file,
 		kfree(uobj);
 	}
=20
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+	ib_mirror_unref(context->ib_mirror);
+	context->ib_mirror =3D NULL;
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
 	put_pid(context->tgid);
=20
 	return context->device->dealloc_ucontext(context);
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index 765aeb3..c7c2670 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -37,6 +37,32 @@
 #include <rdma/ib_verbs.h>
 #include <linux/interval_tree.h>
=20
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+/* struct ib_mirror - per process mirror structure for infiniband driv=
er.
+ *
+ * @ib_device: Infiniband device this mirror is associated with.
+ * @base: The hmm base mirror struct.
+ * @kref: Refcount for the structure.
+ * @list: For the list of ib_mirror of a given ib_device.
+ * @umem_tree: Red black tree of ib_umem ordered by virtual address.
+ * @umem_rwsem: Semaphore protecting the reb black tree.
+ *
+ * Because ib_ucontext struct is tie to file descriptor there can be s=
everal of
+ * them for a same process, which violate HMM requirement. Hence we cr=
eate only
+ * one ib_mirror struct per process and have each ib_umem struct refer=
ence it.
+ */
+struct ib_mirror {
+	struct ib_device	*ib_device;
+	struct hmm_mirror	base;
+	struct kref		kref;
+	struct list_head	list;
+	struct rb_root		umem_tree;
+	struct rw_semaphore	umem_rwsem;
+};
+
+void ib_mirror_unref(struct ib_mirror *ib_mirror);
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+
 struct umem_odp_node {
 	u64 __subtree_last;
 	struct rb_node rb;
@@ -44,7 +70,7 @@ struct umem_odp_node {
=20
 struct ib_umem_odp {
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+	struct ib_mirror	*ib_mirror;
 #else
 	/*
 	 * An array of the pages included in the on-demand paging umem.
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a66551b..fc063e7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -49,6 +49,9 @@
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 #include <uapi/linux/if_ether.h>
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#include <linux/hmm.h>
+#endif
=20
 #include <linux/atomic.h>
 #include <linux/mmu_notifier.h>
@@ -1216,7 +1219,9 @@ struct ib_ucontext {
=20
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-#ifndef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+	struct ib_mirror	*ib_mirror;
+#else  /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	struct rb_root      umem_tree;
 	/*
 	 * Protects .umem_rbroot and tree, as well as odp_mrs_count and
@@ -1231,7 +1236,7 @@ struct ib_ucontext {
 	/* A list of umems that don't have private mmu notifier counters yet.=
 */
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
-#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 };
=20
@@ -1729,6 +1734,14 @@ struct ib_device {
=20
 	struct ib_dma_mapping_ops   *dma_ops;
=20
+#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
+	/* For ODP using HMM. */
+	struct hmm_device	     hmm_dev;
+	struct list_head	     ib_mirrors;
+	struct mutex		     hmm_mutex;
+	bool			     hmm_ready;
+#endif
+
 	struct module               *owner;
 	struct device                dev;
 	struct kobject               *ports_parent;
--=20
1.9.3
