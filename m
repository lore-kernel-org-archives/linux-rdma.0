From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/20 v2] rdma/uverbs: Export XRC domains to user space
Date: Fri, 19 Aug 2011 02:14:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A08@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow user space to create XRC domains.  Because xrcd's are
expected to be shared among multiple processes, we use inodes to
identify an xrcd.

Based on patches by Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   11 +
 drivers/infiniband/core/uverbs_cmd.c  |  319 +++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c |   17 ++
 drivers/infiniband/core/verbs.c       |    1 
 include/rdma/ib_user_verbs.h          |   19 ++
 include/rdma/ib_verbs.h               |    2 
 6 files changed, 368 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index a078e56..461e2f3 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -76,6 +76,8 @@ struct ib_uverbs_device {
 	struct ib_device		       *ib_dev;
 	int					devnum;
 	struct cdev			        cdev;
+	struct rb_root				xrcd_tree;
+	struct mutex				xrcd_tree_mutex;
 };
 
 struct ib_uverbs_event_file {
@@ -120,6 +122,11 @@ struct ib_uevent_object {
 	u32			events_reported;
 };
 
+struct ib_uxrcd_object {
+	struct ib_uobject	uobject;
+	atomic_t		refcnt;
+};
+
 struct ib_uqp_object {
 	struct ib_uevent_object	uevent;
 	struct list_head 	mcast_list;
@@ -142,6 +149,7 @@ extern struct idr ib_uverbs_ah_idr;
 extern struct idr ib_uverbs_cq_idr;
 extern struct idr ib_uverbs_qp_idr;
 extern struct idr ib_uverbs_srq_idr;
+extern struct idr ib_uverbs_xrcd_idr;
 
 void idr_remove_uobj(struct idr *idp, struct ib_uobject *uobj);
 
@@ -161,6 +169,7 @@ void ib_uverbs_qp_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_srq_event_handler(struct ib_event *event, void *context_ptr);
 void ib_uverbs_event_handler(struct ib_event_handler *handler,
 			     struct ib_event *event);
+void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev, struct ib_xrcd *xrcd);
 
 #define IB_UVERBS_DECLARE_CMD(name)					\
 	ssize_t ib_uverbs_##name(struct ib_uverbs_file *file,		\
@@ -195,5 +204,7 @@ IB_UVERBS_DECLARE_CMD(create_srq);
 IB_UVERBS_DECLARE_CMD(modify_srq);
 IB_UVERBS_DECLARE_CMD(query_srq);
 IB_UVERBS_DECLARE_CMD(destroy_srq);
+IB_UVERBS_DECLARE_CMD(open_xrcd);
+IB_UVERBS_DECLARE_CMD(close_xrcd);
 
 #endif /* UVERBS_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 48d21d0..7b2b3b8 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -47,6 +47,7 @@ static struct lock_class_key cq_lock_key;
 static struct lock_class_key qp_lock_key;
 static struct lock_class_key ah_lock_key;
 static struct lock_class_key srq_lock_key;
+static struct lock_class_key xrcd_lock_key;
 
 #define INIT_UDATA(udata, ibuf, obuf, ilen, olen)			\
 	do {								\
@@ -255,6 +256,18 @@ static void put_srq_read(struct ib_srq *srq)
 	put_uobj_read(srq->uobject);
 }
 
+static struct ib_xrcd *idr_read_xrcd(int xrcd_handle, struct ib_ucontext *context,
+				     struct ib_uobject **uobj)
+{
+	*uobj = idr_read_uobj(&ib_uverbs_xrcd_idr, xrcd_handle, context, 0);
+	return *uobj ? (*uobj)->object : NULL;
+}
+
+static void put_xrcd_read(struct ib_uobject *uobj)
+{
+	put_uobj_read(uobj);
+}
+
 ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 			      const char __user *buf,
 			      int in_len, int out_len)
@@ -298,6 +311,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&ucontext->qp_list);
 	INIT_LIST_HEAD(&ucontext->srq_list);
 	INIT_LIST_HEAD(&ucontext->ah_list);
+	INIT_LIST_HEAD(&ucontext->xrcd_list);
 	ucontext->closing = 0;
 
 	resp.num_comp_vectors = file->device->num_comp_vectors;
@@ -579,6 +593,311 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 	return in_len;
 }
 
+struct xrcd_table_entry {
+	struct rb_node  node;
+	struct ib_xrcd *xrcd;
+	struct inode   *inode;
+};
+
+static int xrcd_table_insert(struct ib_uverbs_device *dev,
+			    struct inode *inode,
+			    struct ib_xrcd *xrcd)
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
+		if (inode < scan->inode) {
+			p = &(*p)->rb_left;
+		} else if (inode > scan->inode) {
+			p = &(*p)->rb_right;
+		} else {
+			kfree(entry);
+			return -EEXIST;
+		}
+	}
+
+	rb_link_node(&entry->node, parent, p);
+	rb_insert_color(&entry->node, &dev->xrcd_tree);
+	igrab(inode);
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
+	struct xrcd_table_entry *entry;
+
+	entry = xrcd_table_search(dev, inode);
+	if (entry) {
+		iput(inode);
+		rb_erase(&entry->node, &dev->xrcd_tree);
+		kfree(entry);
+	}
+}
+
+ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
+			    const char __user *buf, int in_len,
+			    int out_len)
+{
+	struct ib_uverbs_open_xrcd	cmd;
+	struct ib_uverbs_open_xrcd_resp	resp;
+	struct ib_udata			udata;
+	struct ib_uxrcd_object         *obj;
+	struct ib_xrcd                 *xrcd = NULL;
+	struct file                    *f = NULL;
+	struct inode                   *inode = NULL;
+	int				ret = 0;
+	int				new_xrcd = 0;
+
+	if (out_len < sizeof resp)
+		return -ENOSPC;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	INIT_UDATA(&udata, buf + sizeof cmd,
+		   (unsigned long) cmd.response + sizeof resp,
+		   in_len - sizeof cmd, out_len - sizeof  resp);
+
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
+	obj = kmalloc(sizeof *obj, GFP_KERNEL);
+	if (!obj) {
+		ret = -ENOMEM;
+		goto err_tree_mutex_unlock;
+	}
+
+	init_uobj(&obj->uobject, 0, file->ucontext, &xrcd_lock_key);
+
+	down_write(&obj->uobject.mutex);
+
+	if (!xrcd) {
+		xrcd = file->device->ib_dev->alloc_xrcd(file->device->ib_dev,
+							file->ucontext, &udata);
+		if (IS_ERR(xrcd)) {
+			ret = PTR_ERR(xrcd);
+			goto err;
+		}
+
+		xrcd->inode   = inode;
+		xrcd->device  = file->device->ib_dev;
+		atomic_set(&xrcd->usecnt, 0);
+		mutex_init(&xrcd->tgt_qp_mutex);
+		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
+		new_xrcd = 1;
+	}
+
+	atomic_set(&obj->refcnt, 0);
+	obj->uobject.object = xrcd;
+	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+	if (ret)
+		goto err_idr;
+
+	memset(&resp, 0, sizeof resp);
+	resp.xrcd_handle = obj->uobject.id;
+
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
+	if (copy_to_user((void __user *) (unsigned long) cmd.response,
+			 &resp, sizeof resp)) {
+		ret = -EFAULT;
+		goto err_copy;
+	}
+
+	if (f)
+		fput(f);
+
+	mutex_lock(&file->mutex);
+	list_add_tail(&obj->uobject.list, &file->ucontext->xrcd_list);
+	mutex_unlock(&file->mutex);
+
+	obj->uobject.live = 1;
+	up_write(&obj->uobject.mutex);
+
+	mutex_unlock(&file->device->xrcd_tree_mutex);
+	return in_len;
+
+err_copy:
+	if (inode) {
+		if (new_xrcd)
+			xrcd_table_delete(file->device, inode);
+		atomic_dec(&xrcd->usecnt);
+	}
+
+err_insert_xrcd:
+	idr_remove_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
+
+err_idr:
+	ib_dealloc_xrcd(xrcd);
+
+err:
+	put_uobj_write(&obj->uobject);
+
+err_tree_mutex_unlock:
+	if (f)
+		fput(f);
+
+	mutex_unlock(&file->device->xrcd_tree_mutex);
+
+	return ret;
+}
+
+ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
+			     const char __user *buf, int in_len,
+			     int out_len)
+{
+	struct ib_uverbs_close_xrcd cmd;
+	struct ib_uobject           *uobj;
+	struct ib_xrcd              *xrcd = NULL;
+	struct inode                *inode = NULL;
+	struct ib_uxrcd_object      *obj;
+	int                         live;
+	int                         ret = 0;
+
+	if (copy_from_user(&cmd, buf, sizeof cmd))
+		return -EFAULT;
+
+	mutex_lock(&file->device->xrcd_tree_mutex);
+	uobj = idr_write_uobj(&ib_uverbs_xrcd_idr, cmd.xrcd_handle, file->ucontext);
+	if (!uobj) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	xrcd  = uobj->object;
+	inode = xrcd->inode;
+	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
+	if (atomic_read(&obj->refcnt)) {
+		put_uobj_write(uobj);
+		ret = -EBUSY;
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
+	if (inode && ret)
+		atomic_inc(&xrcd->usecnt);
+
+	put_uobj_write(uobj);
+
+	if (ret)
+		goto out;
+
+	if (inode && !live)
+		xrcd_table_delete(file->device, inode);
+
+	idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+	mutex_lock(&file->mutex);
+	list_del(&uobj->list);
+	mutex_unlock(&file->mutex);
+
+	put_uobj(uobj);
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
+}
+
 ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 			 const char __user *buf, int in_len,
 			 int out_len)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 56898b6..bb9dcea 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -72,6 +72,7 @@ DEFINE_IDR(ib_uverbs_ah_idr);
 DEFINE_IDR(ib_uverbs_cq_idr);
 DEFINE_IDR(ib_uverbs_qp_idr);
 DEFINE_IDR(ib_uverbs_srq_idr);
+DEFINE_IDR(ib_uverbs_xrcd_idr);
 
 static DEFINE_SPINLOCK(map_lock);
 static DECLARE_BITMAP(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -107,6 +108,8 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_MODIFY_SRQ]		= ib_uverbs_modify_srq,
 	[IB_USER_VERBS_CMD_QUERY_SRQ]		= ib_uverbs_query_srq,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]		= ib_uverbs_destroy_srq,
+	[IB_USER_VERBS_CMD_OPEN_XRCD]		= ib_uverbs_open_xrcd,
+	[IB_USER_VERBS_CMD_CLOSE_XRCD]		= ib_uverbs_close_xrcd,
 };
 
 static void ib_uverbs_add_one(struct ib_device *device);
@@ -241,6 +244,18 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 		kfree(uobj);
 	}
 
+	mutex_lock(&file->device->xrcd_tree_mutex);
+	list_for_each_entry_safe(uobj, tmp, &context->xrcd_list, list) {
+		struct ib_xrcd *xrcd = uobj->object;
+		struct ib_uxrcd_object *uxrcd =
+			container_of(uobj, struct ib_uxrcd_object, uobject);
+
+		idr_remove_uobj(&ib_uverbs_xrcd_idr, uobj);
+		ib_uverbs_dealloc_xrcd(file->device, xrcd);
+		kfree(uxrcd);
+	}
+	mutex_unlock(&file->device->xrcd_tree_mutex);
+
 	list_for_each_entry_safe(uobj, tmp, &context->pd_list, list) {
 		struct ib_pd *pd = uobj->object;
 
@@ -741,6 +756,8 @@ static void ib_uverbs_add_one(struct ib_device *device)
 
 	kref_init(&uverbs_dev->ref);
 	init_completion(&uverbs_dev->comp);
+	uverbs_dev->xrcd_tree = RB_ROOT;
+	mutex_init(&uverbs_dev->xrcd_tree_mutex);
 
 	spin_lock(&map_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index a0e515b..6d034b6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1094,6 +1094,7 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
 	xrcd = device->alloc_xrcd(device, NULL, NULL);
 	if (!IS_ERR(xrcd)) {
 		xrcd->device = device;
+		xrcd->inode = NULL;
 		atomic_set(&xrcd->usecnt, 0);
 		mutex_init(&xrcd->tgt_qp_mutex);
 		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
diff --git a/include/rdma/ib_user_verbs.h b/include/rdma/ib_user_verbs.h
index fe5b051..b5cb63f 100644
--- a/include/rdma/ib_user_verbs.h
+++ b/include/rdma/ib_user_verbs.h
@@ -81,7 +81,9 @@ enum {
 	IB_USER_VERBS_CMD_MODIFY_SRQ,
 	IB_USER_VERBS_CMD_QUERY_SRQ,
 	IB_USER_VERBS_CMD_DESTROY_SRQ,
-	IB_USER_VERBS_CMD_POST_SRQ_RECV
+	IB_USER_VERBS_CMD_POST_SRQ_RECV,
+	IB_USER_VERBS_CMD_OPEN_XRCD,
+	IB_USER_VERBS_CMD_CLOSE_XRCD
 };
 
 /*
@@ -222,6 +224,21 @@ struct ib_uverbs_dealloc_pd {
 	__u32 pd_handle;
 };
 
+struct ib_uverbs_open_xrcd {
+	__u64 response;
+	__u32 fd;
+	__u32 oflags;
+	__u64 driver_data[0];
+};
+
+struct ib_uverbs_open_xrcd_resp {
+	__u32 xrcd_handle;
+};
+
+struct ib_uverbs_close_xrcd {
+	__u32 xrcd_handle;
+};
+
 struct ib_uverbs_reg_mr {
 	__u64 response;
 	__u64 start;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 45ed04b..a779fa0 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -850,6 +850,7 @@ struct ib_ucontext {
 	struct list_head	qp_list;
 	struct list_head	srq_list;
 	struct list_head	ah_list;
+	struct list_head	xrcd_list;
 	int			closing;
 };
 
@@ -880,6 +881,7 @@ struct ib_pd {
 struct ib_xrcd {
 	struct ib_device       *device;
 	atomic_t          	usecnt; /* count all exposed resources */
+	struct inode	       *inode;
 
 	struct mutex		tgt_qp_mutex;
 	struct list_head	tgt_qp_list;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
