From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [RFC] IB/uverbs: Add support for passing memory region invalidations to userspace
Date: Mon, 11 Oct 2010 21:13:05 -0700
Message-ID: <adaiq181226.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

I think I've finally gotten my revision of ummunotify to live within
userspace verbs into a reasonable state.  I've done no testing beyond
compiling it and reading over the code -- in fact, I haven't even
implemented the corresponding support in libibverbs -- but I wanted to
get this out so that people can take a look.

Given that we are probably no more than a week away from the 2.6.37
merge window, I don't think this is appropriate for 2.6.37, but I
definitely plan to get this into 2.6.38 unless there is some big problem
I don't see right now.

As usual, all comments and criticisms welcome!

---

IB/uverbs: Add support for passing memory region invalidations to userspace

As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
and follow-up messages, libraries using RDMA would like to track
precisely when application code changes memory mapping via free(),
munmap(), etc.  Current pure-userspace solutions using malloc hooks
and other tricks are not robust, and the feeling among experts is that
the issue is unfixable without kernel help.

We solve this not by implementing the full API proposed in the email
linked above but rather with a simpler and more generic interface.
Unlike previous attempts at this, which implemented a new generic
character device, this patch works within the existing RDMA userspace
verbs support.  Specifically, we implement three new userspace
operations:

 1. A new version of the "register MR" operation, which creates an MR
    for which the kernel will notify userspace when the virtual
    mapping changes.  We need a new operation for this (rather than,
    say, simply adding another flag to the access_flags field of the
    existing reg_mr operation) because we need to extend the ABI to
    allow userspace to pass in a cookie that will be returned as part
    of invalidation events.

 2. A new version of the "deregister MR" operation that returns the
    number of invalidate events passed to userspace.  Now that we
    generate events for MRs, we need this event count in the destroy
    operation to avoid unfixable races in userspace for exactly
    analogous reasons to the existing destroy CQ, QP and SRQ operations.

 3. A new command to create an MMU notification file descriptor for a
    userspace verbs context.  We require this FD to be created before
    allowing any MRs with invalidation notification to be registered.
    When an invalidation event occurs, the kernel queues an event on
    this FD that userspace can retrieve with read().

    We also allow userspace to mmap() one page at offset 0 to map a
    kernel page that contains a generation counter that is incremented
    each time an event is queued.  This allows userspace to have a
    fast path that checks that no events have occurred, without
    needing to do a system call.

Thanks to Jason Gunthorpe for suggestions on the interface design.  Also
thanks to Jeff Squyres for prototyping support for this in Open MPI, which
helped find several bugs during development.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/core/umem.c        |  141 +++++++++++++++++
 drivers/infiniband/core/uverbs.h      |   24 +++-
 drivers/infiniband/core/uverbs_cmd.c  |  279 ++++++++++++++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c |  122 ++++++++++++++-
 include/rdma/ib_umem.h                |   58 +++++++
 include/rdma/ib_user_verbs.h          |   42 +++++-
 7 files changed, 601 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 89d70de..9e5c776 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -21,6 +21,7 @@ config INFINIBAND_USER_MAD
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
 	select ANON_INODES
+	select MMU_NOTIFIER
 	---help---
 	  Userspace InfiniBand access support.  This enables the
 	  kernel side of userspace verbs and the userspace
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 415e186..8a2579a 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -292,3 +292,144 @@ int ib_umem_page_count(struct ib_umem *umem)
 	return n;
 }
 EXPORT_SYMBOL(ib_umem_page_count);
+
+void ib_ummunotify_register_range(struct ib_ummunotify_context *context,
+				  struct ib_ummunotify_range *range)
+{
+	struct ib_ummunotify_range *trange;
+	struct rb_node **n = &context->reg_tree.rb_node;
+	struct rb_node *pn;
+	unsigned long flags;
+
+	spin_lock_irqsave(&context->lock, flags);
+
+	pn = NULL;
+	while (*n) {
+		pn = *n;
+		trange = rb_entry(pn, struct ib_ummunotify_range, node);
+
+		if (range->start <= trange->start)
+			n = &pn->rb_left;
+		else
+			n = &pn->rb_right;
+	}
+
+	rb_link_node(&range->node, pn, n);
+	rb_insert_color(&range->node, &context->reg_tree);
+
+	spin_unlock_irqrestore(&context->lock, flags);
+}
+EXPORT_SYMBOL(ib_ummunotify_register_range);
+
+void ib_ummunotify_unregister_range(struct ib_ummunotify_context *context,
+				    struct ib_ummunotify_range *range)
+{
+	unsigned long flags;
+
+	if (!ib_ummunotify_context_used(context))
+		return;
+
+	if (RB_EMPTY_NODE(&range->node))
+		return;
+
+	spin_lock_irqsave(&context->lock, flags);
+	rb_erase(&range->node, &context->reg_tree);
+	spin_unlock_irqrestore(&context->lock, flags);
+}
+EXPORT_SYMBOL(ib_ummunotify_unregister_range);
+
+static void ib_ummunotify_handle_notify(struct mmu_notifier *mn,
+					unsigned long start, unsigned long end)
+{
+	struct ib_ummunotify_context *context =
+		container_of(mn, struct ib_ummunotify_context, mmu_notifier);
+	unsigned long flags;
+	struct rb_node *n;
+	struct ib_ummunotify_range *range;
+
+	spin_lock_irqsave(&context->lock, flags);
+
+	for (n = rb_first(&context->reg_tree); n; n = rb_next(n)) {
+		range = rb_entry(n, struct ib_ummunotify_range, node);
+
+		/*
+		 * Ranges overlap if they're not disjoint; and they're
+		 * disjoint if the end of one is before the start of
+		 * the other one.  So if both disjointness comparisons
+		 * fail then the ranges overlap.
+		 *
+		 * Since we keep the tree of regions we're watching
+		 * sorted by start address, we can end this loop as
+		 * soon as we hit a region that starts past the end of
+		 * the range for the event we're handling.
+		 */
+		if (range->start >= end)
+			break;
+
+		/*
+		 * Just go to the next region if the start of the
+		 * range is after the end of the region -- there
+		 * might still be more overlapping ranges that have a
+		 * greater start.
+		 */
+		if (start >= range->end)
+			continue;
+
+		context->callback(context, range);
+	}
+
+	spin_unlock_irqrestore(&context->lock, flags);
+}
+
+static void ib_ummunotify_invalidate_page(struct mmu_notifier *mn,
+					  struct mm_struct *mm,
+					  unsigned long addr)
+{
+	ib_ummunotify_handle_notify(mn, addr, addr + PAGE_SIZE);
+}
+
+static void ib_ummunotify_invalidate_range_start(struct mmu_notifier *mn,
+						 struct mm_struct *mm,
+						 unsigned long start,
+						 unsigned long end)
+{
+	ib_ummunotify_handle_notify(mn, start, end);
+}
+
+static const struct mmu_notifier_ops ib_ummunotify_mmu_notifier_ops = {
+	.invalidate_page	= ib_ummunotify_invalidate_page,
+	.invalidate_range_start	= ib_ummunotify_invalidate_range_start,
+};
+
+int ib_ummunotify_init_context(struct ib_ummunotify_context *context,
+			       void (*callback)(struct ib_ummunotify_context *,
+						struct ib_ummunotify_range *))
+{
+	int ret;
+
+	context->callback = callback;
+	context->reg_tree = RB_ROOT;
+	spin_lock_init(&context->lock);
+
+	context->mm = current->mm;
+	atomic_inc(&current->mm->mm_count);
+
+	context->mmu_notifier.ops = &ib_ummunotify_mmu_notifier_ops;
+	ret = mmu_notifier_register(&context->mmu_notifier, context->mm);
+	if (ret) {
+		mmdrop(context->mm);
+		context->mm = NULL;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(ib_ummunotify_init_context);
+
+void ib_ummunotify_cleanup_context(struct ib_ummunotify_context *context)
+{
+	if (!ib_ummunotify_context_used(context))
+		return;
+	mmu_notifier_unregister(&context->mmu_notifier, context->mm);
+	mmdrop(context->mm);
+}
+EXPORT_SYMBOL(ib_ummunotify_cleanup_context);
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a078e56..10fec27 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -78,9 +78,15 @@ struct ib_uverbs_device {
 	struct cdev			        cdev;
 };
 
+enum ib_uverbs_event_file_type {
+	IB_UVERBS_EVENT_FILE_ASYNC,
+	IB_UVERBS_EVENT_FILE_COMP,
+	IB_UVERBS_EVENT_FILE_MMU_NOTIFY,
+};
+
 struct ib_uverbs_event_file {
 	struct kref				ref;
-	int					is_async;
+	enum ib_uverbs_event_file_type		type;
 	struct ib_uverbs_file		       *uverbs_file;
 	spinlock_t				lock;
 	int					is_closed;
@@ -95,13 +101,17 @@ struct ib_uverbs_file {
 	struct ib_uverbs_device		       *device;
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
+	struct ib_ummunotify_context	        mmu_notify_context;
+	u64				       *mmu_notify_counter;
 	struct ib_uverbs_event_file	       *async_file;
+	struct ib_uverbs_event_file	       *mmu_notify_file;
 };
 
 struct ib_uverbs_event {
 	union {
 		struct ib_uverbs_async_event_desc	async;
 		struct ib_uverbs_comp_event_desc	comp;
+		struct ib_uverbs_mmu_notify_event_desc	mmu_notify;
 	}					desc;
 	struct list_head			list;
 	struct list_head			obj_list;
@@ -120,6 +130,11 @@ struct ib_uevent_object {
 	u32			events_reported;
 };
 
+struct ib_umr_object {
+	struct ib_uevent_object	uevent;
+	struct ib_ummunotify_range range;
+};
+
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
@@ -146,7 +161,7 @@ extern struct idr ib_uverbs_srq_idr;
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					int is_async);
+					enum ib_uverbs_event_file_type type);
 struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd);
 
 void ib_uverbs_release_ucq(struct ib_uverbs_file *file,
@@ -156,6 +171,8 @@ void ib_uverbs_release_uevent(struct ib_uverbs_file *file,
 			      struct ib_uevent_object *uobj);
 
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context);
+void ib_uverbs_mr_event_handler(struct ib_ummunotify_context *context,
+				struct ib_ummunotify_range *range);
 void ib_uverbs_cq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
@@ -195,5 +212,8 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(create_mmu_notify_channel);
+IB_UVERBS_DECLARE_CMD(reg_mmu_notify_mr);
+IB_UVERBS_DECLARE_CMD(dereg_mmu_notify_mr);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 6fcfbeb..5d7890e 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -307,7 +307,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 		goto err_free;
 	resp.async_fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, 1);
+	filp = ib_uverbs_alloc_event_file(file, IB_UVERBS_EVENT_FILE_ASYNC);
 	if (IS_ERR(filp)) {
 		ret = PTR_ERR(filp);
 		goto err_fd;
@@ -577,54 +577,42 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 }
 
-ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
-			 const char __user *buf, int in_len,
-			 int out_len)
+static ssize_t ib_uverbs_reg_mr_common(struct ib_uverbs_file *file,
+				       struct ib_uverbs_reg_mmu_notify_mr *cmd,
+				       struct ib_uverbs_reg_mr_resp *resp,
+				       struct ib_udata *udata,
+				       bool do_notify)
 {
-	struct ib_uverbs_reg_mr      cmd;
-	struct ib_uverbs_reg_mr_resp resp;
-	struct ib_udata              udata;
-	struct ib_uobject           *uobj;
-	struct ib_pd                *pd;
-	struct ib_mr                *mr;
-	int                          ret;
-
-	if (out_len < sizeof resp)
-		return -ENOSPC;
+	struct ib_umr_object	       *obj;
+	struct ib_pd		       *pd;
+	struct ib_mr		       *mr;
+	int				ret;
 
-	if (copy_from_user(&cmd, buf, sizeof cmd))
-		return -EFAULT;
-
-	INIT_UDATA(&udata, buf + sizeof cmd,
-		   (unsigned long) cmd.response + sizeof resp,
-		   in_len - sizeof cmd, out_len - sizeof resp);
-
-	if ((cmd.start & ~PAGE_MASK) != (cmd.hca_va & ~PAGE_MASK))
+	if ((cmd->start & ~PAGE_MASK) != (cmd->hca_va & ~PAGE_MASK))
 		return -EINVAL;
 
 	/*
 	 * Local write permission is required if remote write or
 	 * remote atomic permission is also requested.
 	 */
-	if (cmd.access_flags & (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE_WRITE) &&
-	    !(cmd.access_flags & IB_ACCESS_LOCAL_WRITE))
+	if (cmd->access_flags & (IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_REMOTE_WRITE) &&
+	    !(cmd->access_flags & IB_ACCESS_LOCAL_WRITE))
 		return -EINVAL;
 
-	uobj = kmalloc(sizeof *uobj, GFP_KERNEL);
-	if (!uobj)
+	obj = kmalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj)
 		return -ENOMEM;
 
-	init_uobj(uobj, 0, file->ucontext, &mr_lock_key);
-	down_write(&uobj->mutex);
-
-	pd = idr_read_pd(cmd.pd_handle, file->ucontext);
+	init_uobj(&obj->uevent.uobject, cmd->user_handle, file->ucontext, &mr_lock_key);
+	down_write(&obj->uevent.uobject.mutex);
+	pd = idr_read_pd(cmd->pd_handle, file->ucontext);
 	if (!pd) {
 		ret = -EINVAL;
 		goto err_free;
 	}
 
-	mr = pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_va,
-				     cmd.access_flags, &udata);
+	mr = pd->device->reg_user_mr(pd, cmd->start, cmd->length, cmd->hca_va,
+				     cmd->access_flags, udata);
 	if (IS_ERR(mr)) {
 		ret = PTR_ERR(mr);
 		goto err_put;
@@ -632,22 +620,22 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 
 	mr->device  = pd->device;
 	mr->pd      = pd;
-	mr->uobject = uobj;
+	mr->uobject = &obj->uevent.uobject;
 	atomic_inc(&pd->usecnt);
 	atomic_set(&mr->usecnt, 0);
 
-	uobj->object = mr;
-	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
+	obj->uevent.uobject.object = mr;
+	ret = idr_add_uobj(&ib_uverbs_mr_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_unreg;
 
 	memset(&resp, 0, sizeof resp);
-	resp.lkey      = mr->lkey;
-	resp.rkey      = mr->rkey;
-	resp.mr_handle = uobj->id;
+	resp->lkey      = mr->lkey;
+	resp->rkey      = mr->rkey;
+	resp->mr_handle = obj->uevent.uobject.id;
 
-	if (copy_to_user((void __user *) (unsigned long) cmd.response,
-			 &resp, sizeof resp)) {
+	if (copy_to_user((void __user *) (unsigned long) cmd->response,
+			 resp, sizeof *resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
@@ -655,17 +643,23 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	put_pd_read(pd);
 
 	mutex_lock(&file->mutex);
-	list_add_tail(&uobj->list, &file->ucontext->mr_list);
+	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->mr_list);
 	mutex_unlock(&file->mutex);
 
-	uobj->live = 1;
+	obj->uevent.uobject.live = 1;
 
-	up_write(&uobj->mutex);
+	if (do_notify)
+		ib_ummunotify_register_range(&file->mmu_notify_context,
+					     &obj->range);
+	else
+		ib_ummunotify_clear_range(&obj->range);
 
-	return in_len;
+	up_write(&obj->uevent.uobject.mutex);
+
+	return 0;
 
 err_copy:
-	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+	idr_remove_uobj(&ib_uverbs_mr_idr, &obj->uevent.uobject);
 
 err_unreg:
 	ib_dereg_mr(mr);
@@ -674,27 +668,83 @@ err_put:
 	put_pd_read(pd);
 
 err_free:
-	put_uobj_write(uobj);
+	put_uobj_write(&obj->uevent.uobject);
 	return ret;
 }
 
-ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
-			   const char __user *buf, int in_len,
-			   int out_len)
+ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
+			 const char __user *buf, int in_len,
+			 int out_len)
 {
-	struct ib_uverbs_dereg_mr cmd;
-	struct ib_mr             *mr;
-	struct ib_uobject	 *uobj;
-	int                       ret = -EINVAL;
+	struct ib_uverbs_reg_mr			cmd;
+	struct ib_uverbs_reg_mmu_notify_mr	not_cmd;
+	struct ib_uverbs_reg_mr_resp		resp;
+	struct ib_udata				udata;
+	int					ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof resp);
+
+	not_cmd.response	= cmd.response;
+	not_cmd.user_handle	= 0;
+	not_cmd.start		= cmd.start;
+	not_cmd.length		= cmd.length;
+	not_cmd.hca_va		= cmd.hca_va;
+	not_cmd.pd_handle	= cmd.pd_handle;
+	not_cmd.access_flags	= cmd.access_flags;
+
+	ret = ib_uverbs_reg_mr_common(file, &not_cmd, &resp, &udata, false);
+	return ret ? ret : in_len;
+}
+
+ssize_t ib_uverbs_reg_mmu_notify_mr(struct ib_uverbs_file *file,
+				    const char __user *buf, int in_len,
+				    int out_len)
+{
+	struct ib_uverbs_reg_mmu_notify_mr	cmd;
+	struct ib_uverbs_reg_mr_resp		resp;
+	struct ib_udata				udata;
+	int					ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (!ib_ummunotify_context_used(&file->mmu_notify_context))
+		return -EINVAL;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	uobj = idr_write_uobj(&ib_uverbs_mr_idr, cmd.mr_handle, file->ucontext);
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof resp);
+
+	ret = ib_uverbs_reg_mr_common(file, &cmd, &resp, &udata, true);
+	return ret ? ret : in_len;
+}
+
+static ssize_t ib_uverbs_dereg_mr_common(struct ib_uverbs_file *file,
+					 int mr_handle,
+					 u32 *events_reported)
+{
+	struct ib_uobject      *uobj;
+	struct ib_mr	       *mr;
+	struct ib_umr_object   *obj;
+	int			ret;
+
+	uobj = idr_write_uobj(&ib_uverbs_mr_idr, mr_handle, file->ucontext);
 	if (!uobj)
 		return -EINVAL;
 
 	mr = uobj->object;
+	obj = container_of(uobj, struct ib_umr_object, uevent.uobject);
 
 	ret = ib_dereg_mr(mr);
 	if (!ret)
@@ -705,15 +755,61 @@ ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	ib_ummunotify_unregister_range(&file->mmu_notify_context,
+				       &obj->range);
+
 	idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
 
 	mutex_lock(&file->mutex);
 	list_del(&uobj->list);
 	mutex_unlock(&file->mutex);
 
+	ib_uverbs_release_uevent(file, &obj->uevent);
+
+	if (events_reported)
+		*events_reported = obj->uevent.events_reported;
+
 	put_uobj(uobj);
 
-	return in_len;
+	return 0;
+}
+
+ssize_t ib_uverbs_dereg_mr(struct ib_uverbs_file *file,
+			   const char __user *buf, int in_len,
+			   int out_len)
+{
+	struct ib_uverbs_dereg_mr	cmd;
+	int				ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	ret = ib_uverbs_dereg_mr_common(file, cmd.mr_handle, NULL);
+
+	return ret ? ret : in_len;
+}
+
+
+ssize_t ib_uverbs_dereg_mmu_notify_mr(struct ib_uverbs_file *file,
+				      const char __user *buf, int in_len,
+				      int out_len)
+{
+	struct ib_uverbs_dereg_mmu_notify_mr		cmd;
+	struct ib_uverbs_dereg_mmu_notify_mr_resp	resp;
+	int						ret;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	ret = ib_uverbs_dereg_mr_common(file, cmd.mr_handle,
+					&resp.events_reported);
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp))
+		return -EFAULT;
+
+	return ret ? ret : in_len;
+
 }
 
 ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
@@ -736,7 +832,7 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 		return ret;
 	resp.fd = ret;
 
-	filp = ib_uverbs_alloc_event_file(file, 0);
+	filp = ib_uverbs_alloc_event_file(file, IB_UVERBS_EVENT_FILE_COMP);
 	if (IS_ERR(filp)) {
 		put_unused_fd(resp.fd);
 		return PTR_ERR(filp);
@@ -2179,3 +2275,74 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	return ret ? ret : in_len;
 }
+
+ssize_t ib_uverbs_create_mmu_notify_channel(struct ib_uverbs_file *file,
+					    const char __user *buf, int in_len,
+					    int out_len)
+{
+	struct ib_uverbs_create_mmu_notify_channel	cmd;
+	struct ib_uverbs_create_mmu_notify_channel_resp	resp;
+	struct file				       *filp;
+	int ret;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	mutex_lock(&file->mutex);
+
+	if (file->mmu_notify_file) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = get_unused_fd();
+	if (ret < 0)
+		goto err;
+	resp.fd = ret;
+
+	filp = ib_uverbs_alloc_event_file(file, IB_UVERBS_EVENT_FILE_MMU_NOTIFY);
+	if (IS_ERR(filp)) {
+		ret = PTR_ERR(filp);
+		goto err_put_fd;
+	}
+
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_fput;
+	}
+
+	ret = ib_ummunotify_init_context(&file->mmu_notify_context,
+					 ib_uverbs_mr_event_handler);
+	if (ret)
+		goto err_fput;
+
+	file->mmu_notify_counter = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!file->mmu_notify_counter) {
+		ret = -ENOMEM;
+		goto err_context;
+	}
+
+	file->mmu_notify_file = filp->private_data;
+	fd_install(resp.fd, filp);
+
+	mutex_unlock(&file->mutex);
+
+	return in_len;
+
+err_context:
+	ib_ummunotify_cleanup_context(&file->mmu_notify_context);
+
+err_fput:
+	fput(filp);
+
+err_put_fd:
+	put_unused_fd(resp.fd);
+
+err:
+	mutex_unlock(&file->mutex);
+	return ret;
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index ec83e9f..d8d0356 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -107,6 +107,9 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_MODIFY_SRQ]		= ib_uverbs_modify_srq,
 	[IB_USER_VERBS_CMD_QUERY_SRQ]		= ib_uverbs_query_srq,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
+	[IB_USER_VERBS_CMD_CREATE_MMU_NOTIFY_CHANNEL] = ib_uverbs_create_mmu_notify_channel,
+	[IB_USER_VERBS_CMD_REG_MMU_NOTIFY_MR]	= ib_uverbs_reg_mmu_notify_mr,
+	[IB_USER_VERBS_CMD_DEREG_MMU_NOTIFY_MR]	= ib_uverbs_dereg_mmu_notify_mr,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -235,9 +238,15 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 
 	list_for_each_entry_safe(uobj, tmp, &context->mr_list, list) {
 		struct ib_mr *mr = uobj->object;
+		struct ib_umr_object *umr =
+			container_of(uobj, struct ib_umr_object, uevent.uobject);
 
 		idr_remove_uobj(&ib_uverbs_mr_idr, uobj);
+		if (ib_ummunotify_context_used(&file->mmu_notify_context))
+			ib_ummunotify_unregister_range(&file->mmu_notify_context,
+						       &umr->range);
 		ib_dereg_mr(mr);
+		ib_uverbs_release_uevent(file, &umr->uevent);
 		kfree(uobj);
 	}
 
@@ -249,6 +258,9 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	ib_ummunotify_cleanup_context(&file->mmu_notify_context);
+	kfree(file->mmu_notify_counter);
+
 	return context->device->dealloc_ucontext(context);
 }
 
@@ -268,7 +280,7 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 {
 	struct ib_uverbs_event_file *file = filp->private_data;
 	struct ib_uverbs_event *event;
-	int eventsz;
+	int uninitialized_var(eventsz);
 	int ret = 0;
 
 	spin_lock_irq(&file->lock);
@@ -288,10 +300,17 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 
 	event = list_entry(file->event_list.next, struct ib_uverbs_event, list);
 
-	if (file->is_async)
+	switch (file->type) {
+	case IB_UVERBS_EVENT_FILE_ASYNC:
 		eventsz = sizeof (struct ib_uverbs_async_event_desc);
-	else
+		break;
+	case IB_UVERBS_EVENT_FILE_COMP:
 		eventsz = sizeof (struct ib_uverbs_comp_event_desc);
+		break;
+	case IB_UVERBS_EVENT_FILE_MMU_NOTIFY:
+		eventsz = sizeof (struct ib_uverbs_mmu_notify_event_desc);
+		break;
+	}
 
 	if (eventsz > count) {
 		ret   = -EINVAL;
@@ -318,6 +337,37 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 	return ret;
 }
 
+static int uverbs_mmu_notify_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct ib_uverbs_file *file = vma->vm_private_data;
+
+	if (vmf->pgoff != 0)
+		return VM_FAULT_SIGBUS;
+
+	vmf->page = virt_to_page(file->mmu_notify_counter);
+	get_page(vmf->page);
+
+	return 0;
+}
+
+static const struct vm_operations_struct uverbs_mmu_notify_vm_ops = {
+	.fault		= uverbs_mmu_notify_fault,
+};
+
+static int ib_uverbs_event_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct ib_uverbs_event_file *ev_file = filp->private_data;
+	struct ib_uverbs_file *file = ev_file->uverbs_file;
+
+	if (vma->vm_end - vma->vm_start != PAGE_SIZE || vma->vm_pgoff != 0)
+		return -EINVAL;
+
+	vma->vm_ops		= &uverbs_mmu_notify_vm_ops;
+	vma->vm_private_data	= file;
+
+	return 0;
+}
+
 static unsigned int ib_uverbs_event_poll(struct file *filp,
 					 struct poll_table_struct *wait)
 {
@@ -355,10 +405,15 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	}
 	spin_unlock_irq(&file->lock);
 
-	if (file->is_async) {
+	if (file->type == IB_UVERBS_EVENT_FILE_ASYNC) {
 		ib_unregister_event_handler(&file->uverbs_file->event_handler);
 		kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
 	}
+
+	if (file->type == IB_UVERBS_EVENT_FILE_MMU_NOTIFY) {
+		/* XXX */
+	}
+
 	kref_put(&file->ref, ib_uverbs_release_event_file);
 
 	return 0;
@@ -373,6 +428,16 @@ static const struct file_operations uverbs_event_fops = {
 	.llseek	 = no_llseek,
 };
 
+static const struct file_operations uverbs_event_mmap_fops = {
+	.owner	 = THIS_MODULE,
+	.read	 = ib_uverbs_event_read,
+	.mmap    = ib_uverbs_event_mmap,
+	.poll    = ib_uverbs_event_poll,
+	.release = ib_uverbs_event_close,
+	.fasync  = ib_uverbs_event_fasync,
+	.llseek	 = no_llseek,
+};
+
 void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
 {
 	struct ib_uverbs_event_file    *file = cq_context;
@@ -408,6 +473,47 @@ void ib_uverbs_comp_handler(struct ib_cq *cq, void *cq_context)
 	kill_fasync(&file->async_queue, SIGIO, POLL_IN);
 }
 
+void ib_uverbs_mr_event_handler(struct ib_ummunotify_context *context,
+				struct ib_ummunotify_range *range)
+{
+	struct ib_uverbs_event_file    *file =
+		container_of(context, struct ib_uverbs_file,
+			     mmu_notify_context)->mmu_notify_file;
+	struct ib_umr_object	       *uobj;
+	struct ib_uverbs_event	       *entry;
+	unsigned long			flags;
+
+	if (!file)
+		return;
+
+	spin_lock_irqsave(&file->lock, flags);
+	if (file->is_closed) {
+		spin_unlock_irqrestore(&file->lock, flags);
+		return;
+	}
+
+	entry = kmalloc(sizeof *entry, GFP_ATOMIC);
+	if (!entry) {
+		spin_unlock_irqrestore(&file->lock, flags);
+		return;
+	}
+
+	uobj = container_of(range, struct ib_umr_object, range);
+
+	entry->desc.mmu_notify.cq_handle = uobj->uevent.uobject.user_handle;
+	entry->counter		         = &uobj->uevent.events_reported;
+
+	list_add_tail(&entry->list, &file->event_list);
+	list_add_tail(&entry->obj_list, &uobj->uevent.event_list);
+
+	++(*file->uverbs_file->mmu_notify_counter);
+
+	spin_unlock_irqrestore(&file->lock, flags);
+
+	wake_up_interruptible(&file->poll_wait);
+	kill_fasync(&file->async_queue, SIGIO, POLL_IN);
+}
+
 static void ib_uverbs_async_handler(struct ib_uverbs_file *file,
 				    __u64 element, __u64 event,
 				    struct list_head *obj_list,
@@ -486,7 +592,7 @@ void ib_uverbs_event_handler(struct ib_event_handler *handler,
 }
 
 struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
-					int is_async)
+					enum ib_uverbs_event_file_type type)
 {
 	struct ib_uverbs_event_file *ev_file;
 	struct file *filp;
@@ -501,7 +607,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	init_waitqueue_head(&ev_file->poll_wait);
 	ev_file->uverbs_file = uverbs_file;
 	ev_file->async_queue = NULL;
-	ev_file->is_async    = is_async;
+	ev_file->type	     = type;
 	ev_file->is_closed   = 0;
 
 	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
@@ -530,7 +636,7 @@ struct ib_uverbs_event_file *ib_uverbs_lookup_comp_file(int fd)
 		goto out;
 
 	ev_file = filp->private_data;
-	if (ev_file->is_async) {
+	if (ev_file->type != IB_UVERBS_EVENT_FILE_COMP) {
 		ev_file = NULL;
 		goto out;
 	}
@@ -621,6 +727,8 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	file->async_file = NULL;
 	kref_init(&file->ref);
 	mutex_init(&file->mutex);
+	ib_ummunotify_clear_context(&file->mmu_notify_context);
+	file->mmu_notify_counter = NULL;
 
 	filp->private_data = file;
 
diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 9ee0d2e..0caf274 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -34,6 +34,8 @@
 #define IB_UMEM_H
 
 #include <linux/list.h>
+#include <linux/mmu_notifier.h>
+#include <linux/rbtree.h>
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
 
@@ -59,6 +61,21 @@ struct ib_umem_chunk {
 	struct scatterlist      page_list[0];
 };
 
+struct ib_ummunotify_range {
+	unsigned long		start;
+	unsigned long		end;
+	struct rb_node		node;
+};
+
+struct ib_ummunotify_context {
+	struct mmu_notifier	mmu_notifier;
+	void		      (*callback)(struct ib_ummunotify_context *,
+					  struct ib_ummunotify_range *);
+	struct mm_struct       *mm;
+	struct rb_root		reg_tree;
+	spinlock_t		lock;
+};
+
 #ifdef CONFIG_INFINIBAND_USER_MEM
 
 struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
@@ -66,6 +83,31 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 void ib_umem_release(struct ib_umem *umem);
 int ib_umem_page_count(struct ib_umem *umem);
 
+void ib_ummunotify_register_range(struct ib_ummunotify_context *context,
+				  struct ib_ummunotify_range *range);
+void ib_ummunotify_unregister_range(struct ib_ummunotify_context *context,
+				    struct ib_ummunotify_range *range);
+
+int ib_ummunotify_init_context(struct ib_ummunotify_context *context,
+			       void (*callback)(struct ib_ummunotify_context *,
+						struct ib_ummunotify_range *));
+void ib_ummunotify_cleanup_context(struct ib_ummunotify_context *context);
+
+static inline void ib_ummunotify_clear_range(struct ib_ummunotify_range *range)
+{
+	RB_CLEAR_NODE(&range->node);
+}
+
+static inline void ib_ummunotify_clear_context(struct ib_ummunotify_context *context)
+{
+	context->mm = NULL;
+}
+
+static inline int ib_ummunotify_context_used(struct ib_ummunotify_context *context)
+{
+	return !!context->mm;
+}
+
 #else /* CONFIG_INFINIBAND_USER_MEM */
 
 #include <linux/err.h>
@@ -78,6 +120,22 @@ static inline struct ib_umem *ib_umem_get(struct ib_ucontext *context,
 static inline void ib_umem_release(struct ib_umem *umem) { }
 static inline int ib_umem_page_count(struct ib_umem *umem) { return 0; }
 
+void ib_ummunotify_register_range(struct ib_ummunotify_context *context,
+				  struct ib_ummunotify_range *range) { }
+void ib_ummunotify_unregister_range(struct ib_ummunotify_context *context,
+				    struct ib_ummunotify_range *range) { }
+
+int ib_ummunotify_init_context(struct ib_ummunotify_context *context,
+			       void (*callback)(struct ib_ummunotify_context *,
+						struct ib_ummunotify_range *)) { return 0; }
+void ib_ummunotify_cleanup_context(struct ib_ummunotify_context *context) { }
+
+static inline void ib_ummunotify_clear_range(struct ib_ummunotify_range *range) { }
+
+static inline void ib_ummunotify_clear_context(struct ib_ummunotify_context *context) { }
+
+static inline int ib_ummunotify_context_used(struct ib_ummunotify_context *context) { return 0; }
+
 #endif /* CONFIG_INFINIBAND_USER_MEM */
 
 #endif /* IB_UMEM_H */
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index a17f771..e458c08 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -81,7 +81,14 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	/*
+	 * Leave a gap to avoid clashing with uverbs commands that
+	 * OFED may have shipped without sending upstream
+	 */
+	IB_USER_VERBS_CMD_CREATE_MMU_NOTIFY_CHANNEL,
+	IB_USER_VERBS_CMD_REG_MMU_NOTIFY_MR,
+	IB_USER_VERBS_CMD_DEREG_MMU_NOTIFY_MR,
 };
 
 /*
@@ -105,6 +112,10 @@ struct ib_uverbs_comp_event_desc {
 	__u64 cq_handle;
 };
 
+struct ib_uverbs_mmu_notify_event_desc {
+	__u64 cq_handle;
+};
+
 /*
  * All commands from userspace should start with a __u32 command field
  * followed by __u16 in_words and out_words fields (which give the
@@ -686,4 +697,33 @@ struct ib_uverbs_destroy_srq_resp {
 	__u32 events_reported;
 };
 
+struct ib_uverbs_create_mmu_notify_channel {
+	__u64 response;
+};
+
+struct ib_uverbs_create_mmu_notify_channel_resp {
+	__u32 fd;
+};
+
+struct ib_uverbs_reg_mmu_notify_mr {
+	__u64 response;
+	__u64 user_handle;
+	__u64 start;
+	__u64 length;
+	__u64 hca_va;
+	__u32 pd_handle;
+	__u32 access_flags;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_dereg_mmu_notify_mr {
+	__u64 response;
+	__u32 mr_handle;
+	__u32 reserved;
+};
+
+struct ib_uverbs_dereg_mmu_notify_mr_resp {
+	__u32 events_reported;
+};
+
 #endif /* IB_USER_VERBS_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
