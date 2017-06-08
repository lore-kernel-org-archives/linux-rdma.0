From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 5/8] lib/interval_tree: Fast overlap detection
Date: Thu,  8 Jun 2017 11:03:26 -0700
Message-ID: <20170608180329.11457-6-dave@stgolabs.net>
References: <20170608180329.11457-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608180329.11457-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, peterz@infradead.org, akpm@linux-foundation.org
Cc: jack@suse.cz, kirill.shutemov@linux.intel.com, ldufour@linux.vnet.ibm.com, mhocko@suse.com, mgorman@techsingularity.net, dave@stgolabs.net, linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Doug Ledford <dledford@redhat.com>, Christian Benvenuti <benve@cisco.com>, linux-rdma@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

Allow interval trees to quickly check for overlaps to avoid
unnecesary tree lookups in interval_tree_iter_first().

As of this patch, all interval tree flavors will require
using a 'rb_root_cached' such that we can have the leftmost
node easily available. While most users will make use of this
feature, those with special functions (in addition to the generic
insert, delete, search calls) will avoid using the cached
option as they can do funky things with insertions -- for example,
vma_interval_tree_insert_after().

Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Christian Benvenuti <benve@cisco.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
This is part of the rbtree internal caching series:
https://marc.info/?l=linux-kernel&m=149611025616685

 drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c             |  8 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  7 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |  2 +-
 drivers/gpu/drm/drm_mm.c                           | 10 ++---
 drivers/gpu/drm/drm_vma_manager.c                  |  2 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c            |  6 +--
 drivers/gpu/drm/radeon/radeon.h                    |  2 +-
 drivers/gpu/drm/radeon/radeon_mn.c                 |  8 ++--
 drivers/gpu/drm/radeon/radeon_vm.c                 |  7 ++--
 drivers/infiniband/core/umem_rbtree.c              |  4 +-
 drivers/infiniband/core/uverbs_cmd.c               |  2 +-
 drivers/infiniband/hw/hfi1/mmu_rb.c                | 10 ++---
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  6 +--
 drivers/infiniband/hw/usnic/usnic_uiom.h           |  2 +-
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c | 15 +++----
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h | 12 +++---
 drivers/vhost/vhost.c                              |  2 +-
 drivers/vhost/vhost.h                              |  2 +-
 fs/hugetlbfs/inode.c                               |  6 +--
 fs/inode.c                                         |  2 +-
 include/drm/drm_mm.h                               |  2 +-
 include/linux/fs.h                                 |  4 +-
 include/linux/interval_tree.h                      |  8 ++--
 include/linux/interval_tree_generic.h              | 46 +++++++++++++++++-----
 include/linux/mm.h                                 | 17 ++++----
 include/linux/rmap.h                               |  4 +-
 include/rdma/ib_umem_odp.h                         | 11 ++++--
 include/rdma/ib_verbs.h                            |  2 +-
 lib/interval_tree_test.c                           |  4 +-
 mm/interval_tree.c                                 | 10 ++---
 mm/memory.c                                        |  4 +-
 mm/mmap.c                                          | 10 ++---
 mm/rmap.c                                          |  4 +-
 33 files changed, 139 insertions(+), 102 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
index 38f739fb727b..3f8aef21b9a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c
@@ -51,7 +51,7 @@ struct amdgpu_mn {
 
 	/* objects protected by lock */
 	struct mutex		lock;
-	struct rb_root		objects;
+	struct rb_root_cached	objects;
 };
 
 struct amdgpu_mn_node {
@@ -76,8 +76,8 @@ static void amdgpu_mn_destroy(struct work_struct *work)
 	mutex_lock(&adev->mn_lock);
 	mutex_lock(&rmn->lock);
 	hash_del(&rmn->node);
-	rbtree_postorder_for_each_entry_safe(node, next_node, &rmn->objects,
-					     it.rb) {
+	rbtree_postorder_for_each_entry_safe(node, next_node,
+					     &rmn->objects.rb_root, it.rb) {
 		list_for_each_entry_safe(bo, next_bo, &node->bos, mn_list) {
 			bo->mn = NULL;
 			list_del_init(&bo->mn_list);
@@ -252,7 +252,7 @@ static struct amdgpu_mn *amdgpu_mn_get(struct amdgpu_device *adev)
 	rmn->mm = mm;
 	rmn->mn.ops = &amdgpu_mn_ops;
 	mutex_init(&rmn->lock);
-	rmn->objects = RB_ROOT;
+	rmn->objects = RB_ROOT_CACHED;
 
 	r = __mmu_notifier_register(&rmn->mn, mm);
 	if (r)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 83c172a6e938..ab73ace3d38a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2150,7 +2150,7 @@ int amdgpu_vm_init(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 	struct amd_sched_rq *rq;
 	int r;
 
-	vm->va = RB_ROOT;
+	vm->va = RB_ROOT_CACHED;
 	vm->client_id = atomic64_inc_return(&adev->vm_manager.client_counter);
 	spin_lock_init(&vm->status_lock);
 	INIT_LIST_HEAD(&vm->invalidated);
@@ -2239,10 +2239,11 @@ void amdgpu_vm_fini(struct amdgpu_device *adev, struct amdgpu_vm *vm)
 
 	amd_sched_entity_fini(vm->entity.sched, &vm->entity);
 
-	if (!RB_EMPTY_ROOT(&vm->va)) {
+	if (!RB_EMPTY_ROOT(&vm->va.rb_root)) {
 		dev_err(adev->dev, "still active bo inside vm\n");
 	}
-	rbtree_postorder_for_each_entry_safe(mapping, tmp, &vm->va, rb) {
+	rbtree_postorder_for_each_entry_safe(mapping, tmp,
+					     &vm->va.rb_root, rb) {
 		list_del(&mapping->list);
 		amdgpu_vm_it_remove(mapping, &vm->va);
 		kfree(mapping);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
index e1d951ece433..6b2e8309ca70 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h
@@ -96,7 +96,7 @@ struct amdgpu_vm_pt {
 
 struct amdgpu_vm {
 	/* tree of virtual addresses mapped */
-	struct rb_root		va;
+	struct rb_root_cached	va;
 
 	/* protecting invalidated */
 	spinlock_t		status_lock;
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index f794089d30ac..21863f0afb87 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -169,7 +169,7 @@ INTERVAL_TREE_DEFINE(struct drm_mm_node, rb,
 struct drm_mm_node *
 __drm_mm_interval_first(const struct drm_mm *mm, u64 start, u64 last)
 {
-	return drm_mm_interval_tree_iter_first((struct rb_root *)&mm->interval_tree,
+	return drm_mm_interval_tree_iter_first((struct rb_root_cached *)&mm->interval_tree,
 					       start, last) ?: (struct drm_mm_node *)&mm->head_node;
 }
 EXPORT_SYMBOL(__drm_mm_interval_first);
@@ -198,7 +198,7 @@ static void drm_mm_interval_tree_add_node(struct drm_mm_node *hole_node,
 		link = &hole_node->rb.rb_right;
 	} else {
 		rb = NULL;
-		link = &mm->interval_tree.rb_node;
+		link = &mm->interval_tree.rb_root.rb_node;
 	}
 
 	while (*link) {
@@ -214,7 +214,7 @@ static void drm_mm_interval_tree_add_node(struct drm_mm_node *hole_node,
 
 	rb_link_node(&node->rb, rb, link);
 	rb_insert_augmented(&node->rb,
-			    &mm->interval_tree,
+			    &mm->interval_tree.rb_root,
 			    &drm_mm_interval_tree_augment);
 }
 
@@ -577,7 +577,7 @@ void drm_mm_replace_node(struct drm_mm_node *old, struct drm_mm_node *new)
 	*new = *old;
 
 	list_replace(&old->node_list, &new->node_list);
-	rb_replace_node(&old->rb, &new->rb, &old->mm->interval_tree);
+	rb_replace_node(&old->rb, &new->rb, &old->mm->interval_tree.rb_root);
 
 	if (drm_mm_hole_follows(old)) {
 		list_replace(&old->hole_stack, &new->hole_stack);
@@ -863,7 +863,7 @@ void drm_mm_init(struct drm_mm *mm, u64 start, u64 size)
 	mm->color_adjust = NULL;
 
 	INIT_LIST_HEAD(&mm->hole_stack);
-	mm->interval_tree = RB_ROOT;
+	mm->interval_tree = RB_ROOT_CACHED;
 	mm->holes_size = RB_ROOT;
 	mm->holes_addr = RB_ROOT;
 
diff --git a/drivers/gpu/drm/drm_vma_manager.c b/drivers/gpu/drm/drm_vma_manager.c
index d9100b565198..28f1226576f8 100644
--- a/drivers/gpu/drm/drm_vma_manager.c
+++ b/drivers/gpu/drm/drm_vma_manager.c
@@ -147,7 +147,7 @@ struct drm_vma_offset_node *drm_vma_offset_lookup_locked(struct drm_vma_offset_m
 	struct rb_node *iter;
 	unsigned long offset;
 
-	iter = mgr->vm_addr_space_mm.interval_tree.rb_node;
+	iter = mgr->vm_addr_space_mm.interval_tree.rb_root.rb_node;
 	best = NULL;
 
 	while (likely(iter)) {
diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
index 1a0ce1dc68f5..40cd8c32a153 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -49,7 +49,7 @@ struct i915_mmu_notifier {
 	spinlock_t lock;
 	struct hlist_node node;
 	struct mmu_notifier mn;
-	struct rb_root objects;
+	struct rb_root_cached objects;
 	struct workqueue_struct *wq;
 };
 
@@ -123,7 +123,7 @@ static void i915_gem_userptr_mn_invalidate_range_start(struct mmu_notifier *_mn,
 	struct interval_tree_node *it;
 	LIST_HEAD(cancelled);
 
-	if (RB_EMPTY_ROOT(&mn->objects))
+	if (RB_EMPTY_ROOT(&mn->objects.rb_root))
 		return;
 
 	/* interval ranges are inclusive, but invalidate range is exclusive */
@@ -172,7 +172,7 @@ i915_mmu_notifier_create(struct mm_struct *mm)
 
 	spin_lock_init(&mn->lock);
 	mn->mn.ops = &i915_gem_userptr_notifier;
-	mn->objects = RB_ROOT;
+	mn->objects = RB_ROOT_CACHED;
 	mn->wq = alloc_workqueue("i915-userptr-release", WQ_UNBOUND, 0);
 	if (mn->wq == NULL) {
 		kfree(mn);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 342e3b1fb9c7..569915163b57 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -937,7 +937,7 @@ struct radeon_vm_id {
 struct radeon_vm {
 	struct mutex		mutex;
 
-	struct rb_root		va;
+	struct rb_root_cached	va;
 
 	/* protecting invalidated and freed */
 	spinlock_t		status_lock;
diff --git a/drivers/gpu/drm/radeon/radeon_mn.c b/drivers/gpu/drm/radeon/radeon_mn.c
index 896f2cf51e4e..1d62288b7ee3 100644
--- a/drivers/gpu/drm/radeon/radeon_mn.c
+++ b/drivers/gpu/drm/radeon/radeon_mn.c
@@ -50,7 +50,7 @@ struct radeon_mn {
 
 	/* objects protected by lock */
 	struct mutex		lock;
-	struct rb_root		objects;
+	struct rb_root_cached	objects;
 };
 
 struct radeon_mn_node {
@@ -75,8 +75,8 @@ static void radeon_mn_destroy(struct work_struct *work)
 	mutex_lock(&rdev->mn_lock);
 	mutex_lock(&rmn->lock);
 	hash_del(&rmn->node);
-	rbtree_postorder_for_each_entry_safe(node, next_node, &rmn->objects,
-					     it.rb) {
+	rbtree_postorder_for_each_entry_safe(node, next_node,
+					     &rmn->objects.rb_root, it.rb) {
 
 		interval_tree_remove(&node->it, &rmn->objects);
 		list_for_each_entry_safe(bo, next_bo, &node->bos, mn_list) {
@@ -205,7 +205,7 @@ static struct radeon_mn *radeon_mn_get(struct radeon_device *rdev)
 	rmn->mm = mm;
 	rmn->mn.ops = &radeon_mn_ops;
 	mutex_init(&rmn->lock);
-	rmn->objects = RB_ROOT;
+	rmn->objects = RB_ROOT_CACHED;
 	
 	r = __mmu_notifier_register(&rmn->mn, mm);
 	if (r)
diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index 5f68245579a3..f44777a6c2e8 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -1185,7 +1185,7 @@ int radeon_vm_init(struct radeon_device *rdev, struct radeon_vm *vm)
 		vm->ids[i].last_id_use = NULL;
 	}
 	mutex_init(&vm->mutex);
-	vm->va = RB_ROOT;
+	vm->va = RB_ROOT_CACHED;
 	spin_lock_init(&vm->status_lock);
 	INIT_LIST_HEAD(&vm->invalidated);
 	INIT_LIST_HEAD(&vm->freed);
@@ -1232,10 +1232,11 @@ void radeon_vm_fini(struct radeon_device *rdev, struct radeon_vm *vm)
 	struct radeon_bo_va *bo_va, *tmp;
 	int i, r;
 
-	if (!RB_EMPTY_ROOT(&vm->va)) {
+	if (!RB_EMPTY_ROOT(&vm->va.rb_root)) {
 		dev_err(rdev->dev, "still active bo inside vm\n");
 	}
-	rbtree_postorder_for_each_entry_safe(bo_va, tmp, &vm->va, it.rb) {
+	rbtree_postorder_for_each_entry_safe(bo_va, tmp,
+					     &vm->va.rb_root, it.rb) {
 		interval_tree_remove(&bo_va->it, &vm->va);
 		r = radeon_bo_reserve(bo_va->bo, false);
 		if (!r) {
diff --git a/drivers/infiniband/core/umem_rbtree.c b/drivers/infiniband/core/umem_rbtree.c
index d176597b4d78..fc801920e341 100644
--- a/drivers/infiniband/core/umem_rbtree.c
+++ b/drivers/infiniband/core/umem_rbtree.c
@@ -72,7 +72,7 @@ INTERVAL_TREE_DEFINE(struct umem_odp_node, rb, u64, __subtree_last,
 /* @last is not a part of the interval. See comment for function
  * node_last.
  */
-int rbt_ib_umem_for_each_in_range(struct rb_root *root,
+int rbt_ib_umem_for_each_in_range(struct rb_root_cached *root,
 				  u64 start, u64 last,
 				  umem_call_back cb,
 				  void *cookie)
@@ -95,7 +95,7 @@ int rbt_ib_umem_for_each_in_range(struct rb_root *root,
 }
 EXPORT_SYMBOL(rbt_ib_umem_for_each_in_range);
 
-struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root *root,
+struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root_cached *root,
 				       u64 addr, u64 length)
 {
 	struct umem_odp_node *node;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 0ad3b05405d8..f73d4153dbd0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -117,7 +117,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	ucontext->closing = 0;
 
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	ucontext->umem_tree = RB_ROOT;
+	ucontext->umem_tree = RB_ROOT_CACHED;
 	init_rwsem(&ucontext->umem_rwsem);
 	ucontext->odp_mrs_count = 0;
 	INIT_LIST_HEAD(&ucontext->no_private_counters);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index ccbf52c8ff6f..1835447dcd73 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -54,7 +54,7 @@
 
 struct mmu_rb_handler {
 	struct mmu_notifier mn;
-	struct rb_root root;
+	struct rb_root_cached root;
 	void *ops_arg;
 	spinlock_t lock;        /* protect the RB tree */
 	struct mmu_rb_ops *ops;
@@ -111,7 +111,7 @@ int hfi1_mmu_rb_register(void *ops_arg, struct mm_struct *mm,
 	if (!handlr)
 		return -ENOMEM;
 
-	handlr->root = RB_ROOT;
+	handlr->root = RB_ROOT_CACHED;
 	handlr->ops = ops;
 	handlr->ops_arg = ops_arg;
 	INIT_HLIST_NODE(&handlr->mn.hlist);
@@ -152,9 +152,9 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	INIT_LIST_HEAD(&del_list);
 
 	spin_lock_irqsave(&handler->lock, flags);
-	while ((node = rb_first(&handler->root))) {
+	while ((node = rb_first_cached(&handler->root))) {
 		rbnode = rb_entry(node, struct mmu_rb_node, node);
-		rb_erase(node, &handler->root);
+		rb_erase_cached(node, &handler->root);
 		/* move from LRU list to delete list */
 		list_move(&rbnode->list, &del_list);
 	}
@@ -305,7 +305,7 @@ static void mmu_notifier_mem_invalidate(struct mmu_notifier *mn,
 {
 	struct mmu_rb_handler *handler =
 		container_of(mn, struct mmu_rb_handler, mn);
-	struct rb_root *root = &handler->root;
+	struct rb_root_cached *root = &handler->root;
 	struct mmu_rb_node *node, *ptr = NULL;
 	unsigned long flags;
 	bool added = false;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index c49db7c33979..4381c0a9a873 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -227,7 +227,7 @@ static void __usnic_uiom_reg_release(struct usnic_uiom_pd *pd,
 	vpn_last = vpn_start + npages - 1;
 
 	spin_lock(&pd->lock);
-	usnic_uiom_remove_interval(&pd->rb_root, vpn_start,
+	usnic_uiom_remove_interval(&pd->root, vpn_start,
 					vpn_last, &rm_intervals);
 	usnic_uiom_unmap_sorted_intervals(&rm_intervals, pd);
 
@@ -379,7 +379,7 @@ struct usnic_uiom_reg *usnic_uiom_reg_get(struct usnic_uiom_pd *pd,
 	err = usnic_uiom_get_intervals_diff(vpn_start, vpn_last,
 						(writable) ? IOMMU_WRITE : 0,
 						IOMMU_WRITE,
-						&pd->rb_root,
+						&pd->root,
 						&sorted_diff_intervals);
 	if (err) {
 		usnic_err("Failed disjoint interval vpn [0x%lx,0x%lx] err %d\n",
@@ -395,7 +395,7 @@ struct usnic_uiom_reg *usnic_uiom_reg_get(struct usnic_uiom_pd *pd,
 
 	}
 
-	err = usnic_uiom_insert_interval(&pd->rb_root, vpn_start, vpn_last,
+	err = usnic_uiom_insert_interval(&pd->root, vpn_start, vpn_last,
 					(writable) ? IOMMU_WRITE : 0);
 	if (err) {
 		usnic_err("Failed insert interval vpn [0x%lx,0x%lx] err %d\n",
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.h b/drivers/infiniband/hw/usnic/usnic_uiom.h
index 45ca7c1613a7..431efe4143f4 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.h
@@ -55,7 +55,7 @@ struct usnic_uiom_dev {
 struct usnic_uiom_pd {
 	struct iommu_domain		*domain;
 	spinlock_t			lock;
-	struct rb_root			rb_root;
+	struct rb_root_cached		root;
 	struct list_head		devs;
 	int				dev_cnt;
 };
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
index 42b4b4c4e452..d399523206c7 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
@@ -100,9 +100,9 @@ static int interval_cmp(void *priv, struct list_head *a, struct list_head *b)
 }
 
 static void
-find_intervals_intersection_sorted(struct rb_root *root, unsigned long start,
-					unsigned long last,
-					struct list_head *list)
+find_intervals_intersection_sorted(struct rb_root_cached *root,
+				   unsigned long start, unsigned long last,
+				   struct list_head *list)
 {
 	struct usnic_uiom_interval_node *node;
 
@@ -118,7 +118,7 @@ find_intervals_intersection_sorted(struct rb_root *root, unsigned long start,
 
 int usnic_uiom_get_intervals_diff(unsigned long start, unsigned long last,
 					int flags, int flag_mask,
-					struct rb_root *root,
+					struct rb_root_cached *root,
 					struct list_head *diff_set)
 {
 	struct usnic_uiom_interval_node *interval, *tmp;
@@ -175,7 +175,7 @@ void usnic_uiom_put_interval_set(struct list_head *intervals)
 		kfree(interval);
 }
 
-int usnic_uiom_insert_interval(struct rb_root *root, unsigned long start,
+int usnic_uiom_insert_interval(struct rb_root_cached *root, unsigned long start,
 				unsigned long last, int flags)
 {
 	struct usnic_uiom_interval_node *interval, *tmp;
@@ -246,8 +246,9 @@ int usnic_uiom_insert_interval(struct rb_root *root, unsigned long start,
 	return err;
 }
 
-void usnic_uiom_remove_interval(struct rb_root *root, unsigned long start,
-				unsigned long last, struct list_head *removed)
+void usnic_uiom_remove_interval(struct rb_root_cached *root,
+				unsigned long start, unsigned long last,
+				struct list_head *removed)
 {
 	struct usnic_uiom_interval_node *interval;
 
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
index c0b0b876ab90..1d7fc3226bca 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
@@ -48,12 +48,12 @@ struct usnic_uiom_interval_node {
 
 extern void
 usnic_uiom_interval_tree_insert(struct usnic_uiom_interval_node *node,
-					struct rb_root *root);
+					struct rb_root_cached *root);
 extern void
 usnic_uiom_interval_tree_remove(struct usnic_uiom_interval_node *node,
-					struct rb_root *root);
+					struct rb_root_cached *root);
 extern struct usnic_uiom_interval_node *
-usnic_uiom_interval_tree_iter_first(struct rb_root *root,
+usnic_uiom_interval_tree_iter_first(struct rb_root_cached *root,
 					unsigned long start,
 					unsigned long last);
 extern struct usnic_uiom_interval_node *
@@ -63,7 +63,7 @@ usnic_uiom_interval_tree_iter_next(struct usnic_uiom_interval_node *node,
  * Inserts {start...last} into {root}.  If there are overlaps,
  * nodes will be broken up and merged
  */
-int usnic_uiom_insert_interval(struct rb_root *root,
+int usnic_uiom_insert_interval(struct rb_root_cached *root,
 				unsigned long start, unsigned long last,
 				int flags);
 /*
@@ -71,7 +71,7 @@ int usnic_uiom_insert_interval(struct rb_root *root,
  * 'removed.' The caller is responsibile for freeing memory of nodes in
  * 'removed.'
  */
-void usnic_uiom_remove_interval(struct rb_root *root,
+void usnic_uiom_remove_interval(struct rb_root_cached *root,
 				unsigned long start, unsigned long last,
 				struct list_head *removed);
 /*
@@ -81,7 +81,7 @@ void usnic_uiom_remove_interval(struct rb_root *root,
 int usnic_uiom_get_intervals_diff(unsigned long start,
 					unsigned long last, int flags,
 					int flag_mask,
-					struct rb_root *root,
+					struct rb_root_cached *root,
 					struct list_head *diff_set);
 /* Call this to free diff_set returned by usnic_uiom_get_intervals_diff */
 void usnic_uiom_put_interval_set(struct list_head *intervals);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 042030e5a035..80ea4b23e097 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1272,7 +1272,7 @@ static struct vhost_umem *vhost_umem_alloc(void)
 	if (!umem)
 		return NULL;
 
-	umem->umem_tree = RB_ROOT;
+	umem->umem_tree = RB_ROOT_CACHED;
 	umem->numem = 0;
 	INIT_LIST_HEAD(&umem->umem_list);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f55671d53f28..4e2e54cc4102 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -71,7 +71,7 @@ struct vhost_umem_node {
 };
 
 struct vhost_umem {
-	struct rb_root umem_tree;
+	struct rb_root_cached umem_tree;
 	struct list_head umem_list;
 	int numem;
 };
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 33b33ec2a090..5b13e23962a7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -334,7 +334,7 @@ static void remove_huge_page(struct page *page)
 }
 
 static void
-hugetlb_vmdelete_list(struct rb_root *root, pgoff_t start, pgoff_t end)
+hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end)
 {
 	struct vm_area_struct *vma;
 
@@ -514,7 +514,7 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 
 	i_size_write(inode, offset);
 	i_mmap_lock_write(mapping);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
+	if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 		hugetlb_vmdelete_list(&mapping->i_mmap, pgoff, 0);
 	i_mmap_unlock_write(mapping);
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
@@ -539,7 +539,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 		inode_lock(inode);
 		i_mmap_lock_write(mapping);
-		if (!RB_EMPTY_ROOT(&mapping->i_mmap))
+		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 						hole_start >> PAGE_SHIFT,
 						hole_end  >> PAGE_SHIFT);
diff --git a/fs/inode.c b/fs/inode.c
index a25b9d5fb52e..afeedfc096bb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -352,7 +352,7 @@ void address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->private_list);
 	spin_lock_init(&mapping->private_lock);
-	mapping->i_mmap = RB_ROOT;
+	mapping->i_mmap = RB_ROOT_CACHED;
 }
 EXPORT_SYMBOL(address_space_init_once);
 
diff --git a/include/drm/drm_mm.h b/include/drm/drm_mm.h
index 49b292e98fec..8d10fc97801c 100644
--- a/include/drm/drm_mm.h
+++ b/include/drm/drm_mm.h
@@ -172,7 +172,7 @@ struct drm_mm {
 	 * according to the (increasing) start address of the memory node. */
 	struct drm_mm_node head_node;
 	/* Keep an interval_tree for fast lookup of drm_mm_nodes by address. */
-	struct rb_root interval_tree;
+	struct rb_root_cached interval_tree;
 	struct rb_root holes_size;
 	struct rb_root holes_addr;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ecc301043abf..0756ecdc3cf5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -380,7 +380,7 @@ struct address_space {
 	struct radix_tree_root	page_tree;	/* radix tree of all pages */
 	spinlock_t		tree_lock;	/* and lock protecting it */
 	atomic_t		i_mmap_writable;/* count VM_SHARED mappings */
-	struct rb_root		i_mmap;		/* tree of private and shared mappings */
+	struct rb_root_cached	i_mmap;		/* tree of private and shared mappings */
 	struct rw_semaphore	i_mmap_rwsem;	/* protect tree, count, list */
 	/* Protected by tree_lock together with the radix tree */
 	unsigned long		nrpages;	/* number of total pages */
@@ -473,7 +473,7 @@ static inline void i_mmap_unlock_read(struct address_space *mapping)
  */
 static inline int mapping_mapped(struct address_space *mapping)
 {
-	return	!RB_EMPTY_ROOT(&mapping->i_mmap);
+	return	!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root);
 }
 
 /*
diff --git a/include/linux/interval_tree.h b/include/linux/interval_tree.h
index 724556aa3c95..202ee1283f4b 100644
--- a/include/linux/interval_tree.h
+++ b/include/linux/interval_tree.h
@@ -11,13 +11,15 @@ struct interval_tree_node {
 };
 
 extern void
-interval_tree_insert(struct interval_tree_node *node, struct rb_root *root);
+interval_tree_insert(struct interval_tree_node *node,
+		     struct rb_root_cached *root);
 
 extern void
-interval_tree_remove(struct interval_tree_node *node, struct rb_root *root);
+interval_tree_remove(struct interval_tree_node *node,
+		     struct rb_root_cached *root);
 
 extern struct interval_tree_node *
-interval_tree_iter_first(struct rb_root *root,
+interval_tree_iter_first(struct rb_root_cached *root,
 			 unsigned long start, unsigned long last);
 
 extern struct interval_tree_node *
diff --git a/include/linux/interval_tree_generic.h b/include/linux/interval_tree_generic.h
index 58370e1862ad..f096423c8cbd 100644
--- a/include/linux/interval_tree_generic.h
+++ b/include/linux/interval_tree_generic.h
@@ -65,11 +65,13 @@ RB_DECLARE_CALLBACKS(static, ITPREFIX ## _augment, ITSTRUCT, ITRB,	      \
 									      \
 /* Insert / remove interval nodes from the tree */			      \
 									      \
-ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node, struct rb_root *root)	      \
+ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node,			      \
+				  struct rb_root_cached *root)	 	      \
 {									      \
-	struct rb_node **link = &root->rb_node, *rb_parent = NULL;	      \
+	struct rb_node **link = &root->rb_root.rb_node, *rb_parent = NULL;    \
 	ITTYPE start = ITSTART(node), last = ITLAST(node);		      \
 	ITSTRUCT *parent;						      \
+	bool leftmost = true;						      \
 									      \
 	while (*link) {							      \
 		rb_parent = *link;					      \
@@ -78,18 +80,22 @@ ITSTATIC void ITPREFIX ## _insert(ITSTRUCT *node, struct rb_root *root)	      \
 			parent->ITSUBTREE = last;			      \
 		if (start < ITSTART(parent))				      \
 			link = &parent->ITRB.rb_left;			      \
-		else							      \
+		else {							      \
 			link = &parent->ITRB.rb_right;			      \
+			leftmost = false;				      \
+		}							      \
 	}								      \
 									      \
 	node->ITSUBTREE = last;						      \
 	rb_link_node(&node->ITRB, rb_parent, link);			      \
-	rb_insert_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+	rb_insert_augmented_cached(&node->ITRB, root,			      \
+				   leftmost, &ITPREFIX ## _augment);	      \
 }									      \
 									      \
-ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node, struct rb_root *root)	      \
+ITSTATIC void ITPREFIX ## _remove(ITSTRUCT *node,			      \
+				  struct rb_root_cached *root)		      \
 {									      \
-	rb_erase_augmented(&node->ITRB, root, &ITPREFIX ## _augment);	      \
+	rb_erase_augmented_cached(&node->ITRB, root, &ITPREFIX ## _augment);  \
 }									      \
 									      \
 /*									      \
@@ -140,15 +146,35 @@ ITPREFIX ## _subtree_search(ITSTRUCT *node, ITTYPE start, ITTYPE last)	      \
 }									      \
 									      \
 ITSTATIC ITSTRUCT *							      \
-ITPREFIX ## _iter_first(struct rb_root *root, ITTYPE start, ITTYPE last)      \
+ITPREFIX ## _iter_first(struct rb_root_cached *root,			      \
+			ITTYPE start, ITTYPE last)			      \
 {									      \
-	ITSTRUCT *node;							      \
+	ITSTRUCT *node, *leftmost;					      \
 									      \
-	if (!root->rb_node)						      \
+	if (!root->rb_root.rb_node)					      \
 		return NULL;						      \
-	node = rb_entry(root->rb_node, ITSTRUCT, ITRB);			      \
+									      \
+	/*								      \
+	 * Fastpath range intersection/overlap between A: [a0, a1] and	      \
+	 * B: [b0, b1] is given by:					      \
+	 *								      \
+	 *         a0 <= b1 && b0 <= a1					      \
+	 *								      \
+	 *  ... where A holds the lock range and B holds the smallest	      \
+	 * 'start' and largest 'last' in the tree. For the later, we	      \
+	 * rely on the root node, which by augmented interval tree	      \
+	 * property, holds the largest value in its last-in-subtree.	      \
+	 * This allows mitigating some of the tree walk overhead for	      \
+	 * for non-intersecting ranges, maintained and consulted in O(1).     \
+	 */								      \
+	node = rb_entry(root->rb_root.rb_node, ITSTRUCT, ITRB);		      \
 	if (node->ITSUBTREE < start)					      \
 		return NULL;						      \
+									      \
+	leftmost = rb_entry(root->rb_leftmost, ITSTRUCT, ITRB);		      \
+	if (ITSTART(leftmost) > last)					      \
+		return NULL;						      \
+									      \
 	return ITPREFIX ## _subtree_search(node, start, last);		      \
 }									      \
 									      \
diff --git a/include/linux/mm.h b/include/linux/mm.h
index c0b1759304ec..feb47006e2f5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2020,13 +2020,13 @@ extern int nommu_shrink_inode_mappings(struct inode *, size_t, size_t);
 
 /* interval_tree.c */
 void vma_interval_tree_insert(struct vm_area_struct *node,
-			      struct rb_root *root);
+			      struct rb_root_cached *root);
 void vma_interval_tree_insert_after(struct vm_area_struct *node,
 				    struct vm_area_struct *prev,
-				    struct rb_root *root);
+				    struct rb_root_cached *root);
 void vma_interval_tree_remove(struct vm_area_struct *node,
-			      struct rb_root *root);
-struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root *root,
+			      struct rb_root_cached *root);
+struct vm_area_struct *vma_interval_tree_iter_first(struct rb_root_cached *root,
 				unsigned long start, unsigned long last);
 struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 				unsigned long start, unsigned long last);
@@ -2036,11 +2036,12 @@ struct vm_area_struct *vma_interval_tree_iter_next(struct vm_area_struct *node,
 	     vma; vma = vma_interval_tree_iter_next(vma, start, last))
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root *root);
+				   struct rb_root_cached *root);
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root *root);
-struct anon_vma_chain *anon_vma_interval_tree_iter_first(
-	struct rb_root *root, unsigned long start, unsigned long last);
+				   struct rb_root_cached *root);
+struct anon_vma_chain *
+anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
+				  unsigned long start, unsigned long last);
 struct anon_vma_chain *anon_vma_interval_tree_iter_next(
 	struct anon_vma_chain *node, unsigned long start, unsigned long last);
 #ifdef CONFIG_DEBUG_VM_RB
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 43ef2c30cb0f..22c298c6cc26 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -55,7 +55,9 @@ struct anon_vma {
 	 * is serialized by a system wide lock only visible to
 	 * mm_take_all_locks() (mm_all_locks_mutex).
 	 */
-	struct rb_root rb_root;	/* Interval tree of private "related" vmas */
+
+	/* Interval tree of private "related" vmas */
+	struct rb_root_cached rb_root;
 };
 
 /*
diff --git a/include/rdma/ib_umem_odp.h b/include/rdma/ib_umem_odp.h
index fb67554aabd6..5eb7f5bc8248 100644
--- a/include/rdma/ib_umem_odp.h
+++ b/include/rdma/ib_umem_odp.h
@@ -111,22 +111,25 @@ int ib_umem_odp_map_dma_pages(struct ib_umem *umem, u64 start_offset, u64 bcnt,
 void ib_umem_odp_unmap_dma_pages(struct ib_umem *umem, u64 start_offset,
 				 u64 bound);
 
-void rbt_ib_umem_insert(struct umem_odp_node *node, struct rb_root *root);
-void rbt_ib_umem_remove(struct umem_odp_node *node, struct rb_root *root);
+void rbt_ib_umem_insert(struct umem_odp_node *node,
+			struct rb_root_cached *root);
+void rbt_ib_umem_remove(struct umem_odp_node *node,
+			struct rb_root_cached *root);
 typedef int (*umem_call_back)(struct ib_umem *item, u64 start, u64 end,
 			      void *cookie);
 /*
  * Call the callback on each ib_umem in the range. Returns the logical or of
  * the return values of the functions called.
  */
-int rbt_ib_umem_for_each_in_range(struct rb_root *root, u64 start, u64 end,
+int rbt_ib_umem_for_each_in_range(struct rb_root_cached *root,
+				  u64 start, u64 end,
 				  umem_call_back cb, void *cookie);
 
 /*
  * Find first region intersecting with address range.
  * Return NULL if not found
  */
-struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root *root,
+struct ib_umem_odp *rbt_ib_umem_lookup(struct rb_root_cached *root,
 				       u64 addr, u64 length);
 
 static inline int ib_umem_mmu_notifier_retry(struct ib_umem *item,
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0e480a5630d4..3b54b19a8eac 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1417,7 +1417,7 @@ struct ib_ucontext {
 
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-	struct rb_root      umem_tree;
+	struct rb_root_cached   umem_tree;
 	/*
 	 * Protects .umem_rbroot and tree, as well as odp_mrs_count and
 	 * mmu notifiers registration.
diff --git a/lib/interval_tree_test.c b/lib/interval_tree_test.c
index df495fe81421..0e343fd29570 100644
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -19,14 +19,14 @@ __param(bool, search_all, false, "Searches will iterate all nodes in the tree");
 
 __param(uint, max_endpoint, ~0, "Largest value for the interval's endpoint");
 
-static struct rb_root root = RB_ROOT;
+static struct rb_root_cached root = RB_ROOT_CACHED;
 static struct interval_tree_node *nodes = NULL;
 static u32 *queries = NULL;
 
 static struct rnd_state rnd;
 
 static inline unsigned long
-search(struct rb_root *root, unsigned long start, unsigned long last)
+search(struct rb_root_cached *root, unsigned long start, unsigned long last)
 {
 	struct interval_tree_node *node;
 	unsigned long results = 0;
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index f2c2492681bf..b47664358796 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -28,7 +28,7 @@ INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 /* Insert node immediately after prev in the interval tree */
 void vma_interval_tree_insert_after(struct vm_area_struct *node,
 				    struct vm_area_struct *prev,
-				    struct rb_root *root)
+				    struct rb_root_cached *root)
 {
 	struct rb_node **link;
 	struct vm_area_struct *parent;
@@ -55,7 +55,7 @@ void vma_interval_tree_insert_after(struct vm_area_struct *node,
 
 	node->shared.rb_subtree_last = last;
 	rb_link_node(&node->shared.rb, &parent->shared.rb, link);
-	rb_insert_augmented(&node->shared.rb, root,
+	rb_insert_augmented(&node->shared.rb, &root->rb_root,
 			    &vma_interval_tree_augment);
 }
 
@@ -74,7 +74,7 @@ INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     static inline, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
-				   struct rb_root *root)
+				   struct rb_root_cached *root)
 {
 #ifdef CONFIG_DEBUG_VM_RB
 	node->cached_vma_start = avc_start_pgoff(node);
@@ -84,13 +84,13 @@ void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 }
 
 void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
-				   struct rb_root *root)
+				   struct rb_root_cached *root)
 {
 	__anon_vma_interval_tree_remove(node, root);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_first(struct rb_root *root,
+anon_vma_interval_tree_iter_first(struct rb_root_cached *root,
 				  unsigned long first, unsigned long last)
 {
 	return __anon_vma_interval_tree_iter_first(root, first, last);
diff --git a/mm/memory.c b/mm/memory.c
index b1b97b490791..3b164eb979b2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2593,7 +2593,7 @@ static void unmap_mapping_range_vma(struct vm_area_struct *vma,
 	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
 }
 
-static inline void unmap_mapping_range_tree(struct rb_root *root,
+static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
 					    struct zap_details *details)
 {
 	struct vm_area_struct *vma;
@@ -2657,7 +2657,7 @@ void unmap_mapping_range(struct address_space *mapping,
 		details.last_index = ULONG_MAX;
 
 	i_mmap_lock_write(mapping);
-	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap)))
+	if (unlikely(!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root)))
 		unmap_mapping_range_tree(&mapping->i_mmap, &details);
 	i_mmap_unlock_write(mapping);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 3bd5ecd20d4d..31482e1f008a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -670,7 +670,7 @@ int __vma_adjust(struct vm_area_struct *vma, unsigned long start,
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next = vma->vm_next, *orig_vma = vma;
 	struct address_space *mapping = NULL;
-	struct rb_root *root = NULL;
+	struct rb_root_cached *root = NULL;
 	struct anon_vma *anon_vma = NULL;
 	struct file *file = vma->vm_file;
 	bool start_changed = false, end_changed = false;
@@ -3279,7 +3279,7 @@ static DEFINE_MUTEX(mm_all_locks_mutex);
 
 static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 {
-	if (!test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
+	if (!test_bit(0, (unsigned long *) &anon_vma->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change from under us
 		 * because we hold the mm_all_locks_mutex.
@@ -3295,7 +3295,7 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
 		 * anon_vma->root->rwsem.
 		 */
 		if (__test_and_set_bit(0, (unsigned long *)
-				       &anon_vma->root->rb_root.rb_node))
+				       &anon_vma->root->rb_root.rb_root.rb_node))
 			BUG();
 	}
 }
@@ -3397,7 +3397,7 @@ int mm_take_all_locks(struct mm_struct *mm)
 
 static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 {
-	if (test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_node)) {
+	if (test_bit(0, (unsigned long *) &anon_vma->root->rb_root.rb_root.rb_node)) {
 		/*
 		 * The LSB of head.next can't change to 0 from under
 		 * us because we hold the mm_all_locks_mutex.
@@ -3411,7 +3411,7 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
 		 * anon_vma->root->rwsem.
 		 */
 		if (!__test_and_clear_bit(0, (unsigned long *)
-					  &anon_vma->root->rb_root.rb_node))
+					  &anon_vma->root->rb_root.rb_root.rb_node))
 			BUG();
 		anon_vma_unlock_write(anon_vma);
 	}
diff --git a/mm/rmap.c b/mm/rmap.c
index ced14f1af6dc..ad479e5e081d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -390,7 +390,7 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		 * Leave empty anon_vmas on the list - we'll need
 		 * to free them outside the lock.
 		 */
-		if (RB_EMPTY_ROOT(&anon_vma->rb_root)) {
+		if (RB_EMPTY_ROOT(&anon_vma->rb_root.rb_root)) {
 			anon_vma->parent->degree--;
 			continue;
 		}
@@ -424,7 +424,7 @@ static void anon_vma_ctor(void *data)
 
 	init_rwsem(&anon_vma->rwsem);
 	atomic_set(&anon_vma->refcount, 0);
-	anon_vma->rb_root = RB_ROOT;
+	anon_vma->rb_root = RB_ROOT_CACHED;
 }
 
 void __init anon_vma_init(void)
-- 
2.12.0
