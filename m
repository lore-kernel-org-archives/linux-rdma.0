From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] IB/uverbs: Support for associating XRC domains to inodes
Date: Wed, 03 Feb 2010 13:35:58 -0800
Message-ID: <adaeil2gfy9.fsf@roland-alpha.cisco.com>
References: <1264446094-4460-1-git-send-email-rolandd@cisco.com>
	<1264446094-4460-5-git-send-email-rolandd@cisco.com>
	<201002011552.24904.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201002011552.24904.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> (Jack Morgenstein's
	message of "Mon, 1 Feb 2010 15:52:24 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I think I have uncovered a couple of bugs in my review (not surprising, since you
 > most likely could not try out the code).

Thanks.  Yes, this was all compile-tested only.

 > 1. the xrcd refcnt is incremented when creating an xrc qp and xrc srq, but is unconditionally
 >    decremented in destroy_qp/destroy_srq whether we have an xrcd or not.

This was all messed up... the error path of create_qp was bogus too.
I think the updated patch below is good though.

 > 2. In closing/deallocating xrc domains, it is not an error if ib_dealloc_xrcd returns "busy".
 >    This simply means that there are other user processes still using that xrc domain.
 >    The current process still needs to clean up its uobject.  In particular, the usecnt should
 >    not be re-incremented on the busy return. (If it gets re-incremented on busy, no one can ever
 >    succeed in closing an xrc domain if more that one process is using it).

I do agree we shouldn't reincrement the use count if the dealloc
fails -- in ib_uverbs_dealloc_xrcd we're in the path of closing a
context and so there's no real way to recover if the ib_dealloc_xrcd
fails.  But I don't think the busy case is an issue -- we should return
without trying to dealloc if the xrcd is held by another process, since
the atomic_dec_and_test will return a non-zero value in that case I
think.  So the simplification in the patch below should be OK, right?
---
 drivers/infiniband/core/uverbs.h      |    9 +-
 drivers/infiniband/core/uverbs_cmd.c  |  294 ++++++++++++++++++++++++++++-----
 drivers/infiniband/core/uverbs_main.c |    6 +-
 drivers/infiniband/core/verbs.c       |    2 +-
 include/rdma/ib_verbs.h               |    2 +-
 5 files changed, 268 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 9180acd..e873437 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -70,10 +70,12 @@
 struct ib_uverbs_device {
 	struct kref				ref;
 	struct completion			comp;
-	int					devnum;
 	struct cdev			       *cdev;
 	struct device			       *dev;
 	struct ib_device		       *ib_dev;
+	struct rb_root				xrcd_tree;
+	struct mutex				xrcd_tree_mutex;
+	int					devnum;
 	int					num_comp_vectors;
 };
 
@@ -121,15 +123,18 @@ struct ib_uevent_object {
 
 struct ib_uxrcd_object {
 	struct ib_uobject	uobject;
+	atomic_t		refcnt;
 };
 
 struct ib_usrq_object {
 	struct ib_uevent_object	uevent;
+	struct ib_uxrcd_object *uxrcd;
 };
 
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
+	struct ib_uxrcd_object *uxrcd;
 };
 
 struct ib_ucq_object {
@@ -169,6 +174,8 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
+void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
+			    struct ib_xrcd *xrcd);
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index b209339..cd4c692 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -256,14 +256,11 @@ static void put_srq_read(struct ib_srq *srq)
 }
 
 static struct ib_xrcd *idr_read_xrcd(int xrcd_handle,
-				     struct ib_ucontext *context)
+				     struct ib_ucontext *context,
+				     struct ib_uobject **uobj)
 {
-	return idr_read_obj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
-}
-
-static void put_xrcd_read(struct ib_xrcd *xrcd)
-{
-	put_uobj_read(xrcd->uobject);
+	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+	return *uobj ? (*uobj)->object : NULL;
 }
 
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
@@ -1040,6 +1037,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_qp                   *qp;
 	struct ib_qp_init_attr          attr;
 	struct ib_xrcd		       *xrcd;
+	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
 	int ret;
 
 	if (out_len < sizeof resp)
@@ -1062,12 +1060,18 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	srq = (cmd.is_srq && cmd.qp_type != IB_QPT_XRC) ?
 		idr_read_srq(cmd.srq_handle, file->ucontext) : NULL;
 	xrcd = cmd.qp_type == IB_QPT_XRC ?
-		idr_read_xrcd(cmd.srq_handle, file->ucontext) : NULL;
+		idr_read_xrcd(cmd.srq_handle, file->ucontext, &xrcd_uobj) : NULL;
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
 	rcq = cmd.recv_cq_handle == cmd.send_cq_handle ?
 		scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
 
+	if (xrcd) {
+		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
+		atomic_inc(&obj->uxrcd->refcnt);
+	} else
+		obj->uxrcd = NULL;
+
 	if (!pd || !scq || !rcq || (cmd.is_srq && !srq) ||
 	    (cmd.qp_type == IB_QPT_XRC && !xrcd)) {
 		ret = -EINVAL;
@@ -1145,7 +1149,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	if (srq)
 		put_srq_read(srq);
 	if (xrcd)
-		put_xrcd_read(xrcd);
+		put_uobj_read(xrcd_uobj);
 
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uevent.uobject.list, &file->ucontext->qp_list);
@@ -1172,8 +1176,10 @@ err_put:
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
-	if (xrcd)
-		put_xrcd_read(xrcd);
+	if (xrcd) {
+		atomic_dec(&obj->uxrcd->refcnt);
+		put_uobj_read(xrcd_uobj);
+	}
 
 	put_uobj_write(&obj->uevent.uobject);
 	return ret;
@@ -1402,6 +1408,9 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	if (obj->uxrcd)
+		atomic_dec(&obj->uxrcd->refcnt);
+
 	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -2032,6 +2041,7 @@ ssize_t ib_uverbs_create_srq(struct ib_uverbs_file *file,
 	atomic_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
+	obj->uxrcd = NULL;
 	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
 	if (ret)
 		goto err_destroy;
@@ -2085,6 +2095,7 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	struct ib_srq			*srq;
 	struct ib_cq			*xrc_cq;
 	struct ib_xrcd			*xrcd;
+	struct ib_uobject		*xrcd_uobj;
 	struct ib_srq_init_attr		 attr;
 	int ret;
 
@@ -2117,7 +2128,7 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 		goto err_put_pd;
 	}
 
-	xrcd  = idr_read_xrcd(cmd.xrcd_handle, file->ucontext);
+	xrcd  = idr_read_xrcd(cmd.xrcd_handle, file->ucontext, &xrcd_uobj);
 	if (!xrcd) {
 		ret = -EINVAL;
 		goto err_put_cq;
@@ -2130,6 +2141,8 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 	attr.attr.srq_limit = cmd.srq_limit;
 
 	obj->uevent.events_reported = 0;
+	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
+	atomic_inc(&obj->uxrcd->refcnt);
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 
 	srq = pd->device->create_xrc_srq(pd, xrc_cq, xrcd, &attr, &udata);
@@ -2167,7 +2180,7 @@ ssize_t ib_uverbs_create_xrc_srq(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_xrcd_read(xrcd);
+	put_uobj_read(xrcd_uobj);
 	put_cq_read(xrc_cq);
 	put_pd_read(pd);
 
@@ -2188,7 +2201,8 @@ err_destroy:
 	ib_destroy_srq(srq);
 
 err_put:
-	put_xrcd_read(xrcd);
+	atomic_dec(&obj->uxrcd->refcnt);
+	put_uobj_read(xrcd_uobj);
 
 err_put_cq:
 	put_cq_read(xrc_cq);
@@ -2300,6 +2314,9 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	if (ret)
 		return ret;
 
+	if (obj->uxrcd)
+		atomic_dec(&obj->uxrcd->refcnt);
+
 	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
 
 	mutex_lock(&file->mutex);
@@ -2320,6 +2337,93 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 	return ret ? ret : in_len;
 }
 
+struct xrcd_table_entry {
+	struct rb_node	node;
+	struct ib_xrcd *xrcd;
+	struct inode   *inode;
+};
+
+static int xrcd_table_insert(struct ib_uverbs_device *dev,
+			     struct inode *inode,
+			     struct ib_xrcd *xrcd)
+{
+	struct xrcd_table_entry *entry, *scan;
+	struct rb_node **p = &dev->xrcd_tree.rb_node;
+	struct rb_node *parent = NULL;
+
+	entry = kmalloc(sizeof *entry, GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->xrcd  = xrcd;
+	entry->inode = inode;
+
+	while (*p) {
+		parent = *p;
+		scan = rb_entry(parent, struct xrcd_table_entry, node);
+
+		if (inode < scan->inode)
+			p = &(*p)->rb_left;
+		else if (inode > scan->inode)
+			p = &(*p)->rb_right;
+		else {
+			kfree(entry);
+			return -EEXIST;
+		}
+	}
+
+	rb_link_node(&entry->node, parent, p);
+	rb_insert_color(&entry->node, &dev->xrcd_tree);
+
+	igrab(inode);
+
+	return 0;
+}
+
+static struct xrcd_table_entry *xrcd_table_search(struct ib_uverbs_device *dev,
+						  struct inode *inode)
+{
+	struct xrcd_table_entry *entry;
+	struct rb_node *p = dev->xrcd_tree.rb_node;
+
+	while (p) {
+		entry = rb_entry(p, struct xrcd_table_entry, node);
+
+		if (inode < entry->inode)
+			p = p->rb_left;
+		else if (inode > entry->inode)
+			p = p->rb_right;
+		else
+			return entry;
+	}
+
+	return NULL;
+}
+
+static struct ib_xrcd *find_xrcd(struct ib_uverbs_device *dev, struct inode *inode)
+{
+	struct xrcd_table_entry *entry;
+
+	entry = xrcd_table_search(dev, inode);
+	if (!entry)
+		return NULL;
+
+	return entry->xrcd;
+}
+
+
+static void xrcd_table_delete(struct ib_uverbs_device *dev,
+			      struct inode *inode)
+{
+	struct xrcd_table_entry *entry = xrcd_table_search(dev, inode);
+
+	if (entry) {
+		iput(inode);
+		rb_erase(&entry->node, &dev->xrcd_tree);
+		kfree(entry);
+	}
+}
+
 ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
@@ -2328,8 +2432,11 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	struct ib_uverbs_open_xrcd_resp	resp;
 	struct ib_udata			udata;
 	struct ib_uxrcd_object	       *obj;
-	struct ib_xrcd		       *xrcd;
-	int ret;
+	struct ib_xrcd		       *xrcd = NULL;
+	struct file		       *f = NULL;
+	struct inode		       *inode = NULL;
+	int				ret = 0;
+	int				new_xrcd = 0;
 
 	if (out_len < sizeof resp)
 		return -ENOSPC;
@@ -2337,32 +2444,64 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
-	/* file descriptors/inodes not yet implemented */
-	if (cmd.fd != -1)
-		return -ENOSYS;
-
 	INIT_UDATA(&udata, buf + sizeof cmd,
 		   (unsigned long) cmd.response + sizeof resp,
 		   in_len - sizeof cmd, out_len - sizeof resp);
 
+	mutex_lock(&file->device->xrcd_tree_mutex);
+
+	if (cmd.fd != -1) {
+		/* search for file descriptor */
+		f = fget(cmd.fd);
+		if (!f) {
+			ret = -EBADF;
+			goto err_tree_mutex_unlock;
+		}
+
+		inode = f->f_dentry->d_inode;
+		if (!inode) {
+			ret = -EBADF;
+			goto err_tree_mutex_unlock;
+		}
+
+		xrcd = find_xrcd(file->device, inode);
+		if (!xrcd && !(cmd.oflags & O_CREAT)) {
+			/* no file descriptor. Need CREATE flag */
+			ret = -EAGAIN;
+			goto err_tree_mutex_unlock;
+		}
+
+		if (xrcd && cmd.oflags & O_EXCL) {
+			ret = -EINVAL;
+			goto err_tree_mutex_unlock;
+		}
+	}
+
 	obj = kmalloc(sizeof *obj, GFP_KERNEL);
-	if (!obj)
-		return -ENOMEM;
+	if (!obj) {
+		ret = -ENOMEM;
+		goto err_tree_mutex_unlock;
+	}
 
 	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_key);
+
 	down_write(&obj->uobject.mutex);
 
-	xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
-						file->ucontext, &udata);
-	if (IS_ERR(xrcd)) {
-		ret = PTR_ERR(xrcd);
-		goto err;
-	}
+	if (!xrcd) {
+		xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
+							file->ucontext, &udata);
+		if (IS_ERR(xrcd)) {
+			ret = PTR_ERR(xrcd);
+			goto err;
+		}
 
-	xrcd->uobject = &obj->uobject;
-	xrcd->device  = file->device->ib_dev;
-	atomic_set(&xrcd->usecnt, 0);
+		xrcd->inode   = inode;
+		xrcd->device  = file->device->ib_dev;
+		atomic_set(&xrcd->usecnt, 0);
+		new_xrcd = 1;
+	}
 
+	atomic_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
 	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 	if (ret)
@@ -2371,12 +2510,25 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	memset(&resp, 0, sizeof resp);
 	resp.xrcd_handle = obj->uobject.id;
 
+	if (inode) {
+		if (new_xrcd) {
+			/* create new inode/xrcd table entry */
+			ret = xrcd_table_insert(file->device, inode, xrcd);
+			if (ret)
+				goto err_insert_xrcd;
+		}
+		atomic_inc(&xrcd->usecnt);
+	}
+
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp)) {
 		ret = -EFAULT;
 		goto err_copy;
 	}
 
+	if (f)
+		fput(f);
+
 	mutex_lock(&file->mutex);
 	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
 	mutex_unlock(&file->mutex);
@@ -2385,9 +2537,17 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 	up_write(&obj->uobject.mutex);
 
+	mutex_unlock(&file->device->xrcd_tree_mutex);
 	return in_len;
 
 err_copy:
+	if (inode) {
+		if (new_xrcd)
+			xrcd_table_delete(file->device, inode);
+		atomic_dec(&xrcd->usecnt);
+	}
+
+err_insert_xrcd:
 	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 
 err_idr:
@@ -2395,33 +2555,66 @@ err_idr:
 
 err:
 	put_uobj_write(&obj->uobject);
+
+err_tree_mutex_unlock:
+	if (f)
+		fput(f);
+
+	mutex_unlock(&file->device->xrcd_tree_mutex);
+
 	return ret;
 }
 
 ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
-				   const char __user *buf, int in_len,
-				   int out_len)
+			     const char __user *buf, int in_len,
+			     int out_len)
 {
 	struct ib_uverbs_close_xrcd	cmd;
 	struct ib_uobject	       *uobj;
-	int				ret;
+	struct ib_xrcd		       *xrcd = NULL;
+	struct inode		       *inode = NULL;
+	struct ib_uxrcd_object	       *obj;
+	int				live;
+	int				ret = 0;
 
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	mutex_lock(&file->device->xrcd_tree_mutex);
 	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle,
 			      file->ucontext);
-	if (!uobj)
-		return -EINVAL;
+	if (!uobj) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	ret = ib_dealloc_xrcd(uobj->object);
-	if (!ret)
-		uobj->live = 0;
+	xrcd  = uobj->object;
+	inode = xrcd->inode;
+	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
+	if (atomic_read(&obj->refcnt)) {
+		ret = -EBUSY;
+		put_uobj_write(uobj);
+		goto out;
+	}
+
+	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
+		ret = ib_dealloc_xrcd(uobj->object);
+		if (!ret)
+			uobj->live = 0;
+	}
+
+	live = uobj->live;
+
+	if (inode && ret)
+		atomic_inc(&xrcd->usecnt);
 
 	put_uobj_write(uobj);
 
 	if (ret)
-		return ret;
+		goto out;
+
+	if (inode && !live)
+		xrcd_table_delete(file->device, inode);
 
 	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
 
@@ -2431,5 +2624,24 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 
 	put_uobj(uobj);
 
-	return in_len;
+	ret = in_len;
+
+out:
+	mutex_unlock(&file->device->xrcd_tree_mutex);
+	return ret;
+}
+
+void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
+			    struct ib_xrcd *xrcd)
+{
+	struct inode *inode;
+
+	inode = xrcd->inode;
+	if (inode && !atomic_dec_and_test(&xrcd->usecnt))
+		return;
+
+	ib_dealloc_xrcd(xrcd);
+
+	if (inode)
+		xrcd_table_delete(dev, inode);
 }
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2a97810..2b9d744 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -250,15 +250,17 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	mutex_lock(&file->device->xrcd_tree_mutex);
 	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
 		struct ib_xrcd *xrcd = uobj->object;
 		struct ib_uxrcd_object *uxrcd =
 			container_of(uobj, struct ib_uxrcd_object, uobject);
 
 		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
-		ib_dealloc_xrcd(xrcd);
+		ib_uverbs_dealloc_xrcd(file->device, xrcd);
 		kfree(uxrcd);
 	}
+	mutex_unlock(&file->device->xrcd_tree_mutex);
 
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
@@ -763,6 +765,8 @@ static void ib_uverbs_add_one(struct ib_device *device)
 
 	kref_init(&uverbs_dev->ref);
 	init_completion(&uverbs_dev->comp);
+	uverbs_dev->xrcd_tree = RB_ROOT;
+	mutex_init(&uverbs_dev->xrcd_tree_mutex);
 
 	spin_lock(&map_lock);
 	uverbs_dev->devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index b75193c..99f76b6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1014,7 +1014,7 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
 	xrcd = device->alloc_xrcd(device, NULL, NULL);
 	if (!IS_ERR(xrcd)) {
 		xrcd->device  = device;
-		xrcd->uobject = NULL;
+		xrcd->inode   = NULL;
 		atomic_set(&xrcd->usecnt, 0);
 	}
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1d843c3..322d145 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -848,7 +848,7 @@ struct ib_pd {
 
 struct ib_xrcd {
 	struct ib_device       *device;
-	struct ib_uobject      *uobject;
+	struct inode	       *inode;
 	atomic_t		usecnt; /* count all resources */
 };
 
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
