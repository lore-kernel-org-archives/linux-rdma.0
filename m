From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 33/36] IB/odp/hmm: add core infiniband structure and helper for ODP with HMM.
Date: Thu, 21 May 2015 15:23:50 -0400
Message-ID: <1432236233-4035-34-git-send-email-j.glisse@gmail.com>
References: <1432236233-4035-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432236233-4035-1-git-send-email-j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This add new core infiniband structure and helper to implement ODP (on
demand paging) on top of HMM. We need to retain the tree of ib_umem as
some hardware associate unique identifiant with each umem (or mr) and
only allow hardware page table to be updated using this unique id.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/umem_odp.c    | 148 ++++++++++++++++++++++++++=
+++++++-
 drivers/infiniband/core/uverbs_cmd.c  |   6 +-
 drivers/infiniband/core/uverbs_main.c |   6 ++
 include/rdma/ib_umem_odp.h            |  28 ++++++-
 include/rdma/ib_verbs.h               |  17 +++-
 5 files changed, 199 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/co=
re/umem_odp.c
index e55e124..d5d57a8 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -41,9 +41,155 @@
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
+	hmm_mirror_unregister(&ib_mirror->base);
+
+	ib_device =3D ib_mirror->ib_device;
+	mutex_lock(&ib_device->hmm_mutex);
+	list_del_init(&ib_mirror->list);
+	mutex_unlock(&ib_device->hmm_mutex);
+	kfree(ib_mirror);
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
+	if (!ib_mirror)
+		list_for_each_entry(ib_mirror, &ib_device->ib_mirrors, list) {
+			if (ib_mirror->base.hmm->mm !=3D mm)
+				continue;
+			ib_mirror =3D ib_mirror_ref(ib_mirror);
+			break;
+		}
+
+	if (ib_mirror =3D=3D NULL ||
+	    ib_mirror =3D=3D list_first_entry(&ib_device->ib_mirrors,
+					  struct ib_mirror, list)) {
+		/* We need to create a new mirror. */
+		ib_mirror =3D kmalloc(sizeof(*ib_mirror), GFP_KERNEL);
+		if (ib_mirror =3D=3D NULL) {
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
index ccd6bbe..3225ab5 100644
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
index 88cce9b..3f069d7 100644
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
@@ -297,6 +298,11 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uv=
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
index 7b00d30..83da1bd 100644
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
@@ -1157,7 +1160,9 @@ struct ib_ucontext {
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
@@ -1172,7 +1177,7 @@ struct ib_ucontext {
 	/* A list of umems that don't have private mmu notifier counters yet.=
 */
 	struct list_head	no_private_counters;
 	int                     odp_mrs_count;
-#endif /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
+#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 };
=20
@@ -1657,6 +1662,14 @@ struct ib_device {
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
