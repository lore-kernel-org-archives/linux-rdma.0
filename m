From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V8 4/6] IB/uverbs: Enable device removal when there are active user space applications
Date: Thu, 13 Aug 2015 18:32:05 +0300
Message-ID: <1439479927-8751-5-git-send-email-yishaih@mellanox.com>
References: <1439479927-8751-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439479927-8751-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enables the uverbs_remove_one to succeed despite the fact that there are
running IB applications working with the given ib device.  This
functionality enables a HW device to be unbind/reset despite the fact that
there are running user space applications using it.

It exposes a new IB kernel API named 'disassociate_ucontext' which lets
a driver detaching its HW resources from a given user context without
crashing/terminating the application. In case a driver implemented the
above API and registered with ib_uverb there will be no dependency between its
device to its uverbs_device. Upon calling remove_one of ib_uverbs the call
should return after disassociating the open HW resources without waiting to
clients disconnecting. In case driver didn't implement this API there will be no
change to current behaviour and uverbs_remove_one will return only when last
client has disconnected and reference count on uverbs device became 0.

In case the lower driver device was removed any application will
continue working over some zombie HCA, further calls will ended with an
immediate error.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |    9 +-
 drivers/infiniband/core/uverbs_main.c |  360 +++++++++++++++++++++++++++------
 include/rdma/ib_verbs.h               |    1 +
 3 files changed, 302 insertions(+), 68 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index ea52db1..3863d33 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -89,12 +89,16 @@ struct ib_uverbs_device {
 	int					num_comp_vectors;
 	struct completion			comp;
 	struct device			       *dev;
-	struct ib_device		       *ib_dev;
+	struct ib_device	__rcu	       *ib_dev;
 	int					devnum;
 	struct cdev			        cdev;
 	struct rb_root				xrcd_tree;
 	struct mutex				xrcd_tree_mutex;
 	struct kobject				kobj;
+	struct srcu_struct			disassociate_srcu;
+	struct mutex				lists_mutex; /* protect lists */
+	struct list_head			uverbs_file_list;
+	struct list_head			uverbs_events_file_list;
 };
 
 struct ib_uverbs_event_file {
@@ -106,6 +110,7 @@ struct ib_uverbs_event_file {
 	wait_queue_head_t			poll_wait;
 	struct fasync_struct		       *async_queue;
 	struct list_head			event_list;
+	struct list_head			list;
 };
 
 struct ib_uverbs_file {
@@ -115,6 +120,8 @@ struct ib_uverbs_file {
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
 	struct ib_uverbs_event_file	       *async_file;
+	struct list_head			list;
+	int					is_closed;
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index dc968df..59b28a6 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -137,6 +137,7 @@ static void ib_uverbs_release_dev(struct kobject *kobj)
 	struct ib_uverbs_device *dev =
 		container_of(kobj, struct ib_uverbs_device, kobj);
 
+	cleanup_srcu_struct(&dev->disassociate_srcu);
 	kfree(dev);
 }
 
@@ -207,9 +208,6 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 {
 	struct ib_uobject *uobj, *tmp;
 
-	if (!context)
-		return 0;
-
 	context->closing = 1;
 
 	list_for_each_entry_safe(uobj, tmp, &context->ah_list, list) {
@@ -318,8 +316,16 @@ static void ib_uverbs_release_file(struct kref *ref)
 {
 	struct ib_uverbs_file *file =
 		container_of(ref, struct ib_uverbs_file, ref);
+	struct ib_device *ib_dev;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	ib_dev = srcu_dereference(file->device->ib_dev,
+				  &file->device->disassociate_srcu);
+	if (ib_dev && !ib_dev->disassociate_ucontext)
+		module_put(ib_dev->owner);
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
 
-	module_put(file->device->ib_dev->owner);
 	if (atomic_dec_and_test(&file->device->refcount))
 		ib_uverbs_comp_dev(file->device);
 
@@ -343,9 +349,19 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 			return -EAGAIN;
 
 		if (wait_event_interruptible(file->poll_wait,
-					     !list_empty(&file->event_list)))
+					     (!list_empty(&file->event_list) ||
+			/* The barriers built into wait_event_interruptible()
+			 * and wake_up() guarentee this will see the null set
+			 * without using RCU
+			 */
+					     !file->uverbs_file->device->ib_dev)))
 			return -ERESTARTSYS;
 
+		/* If device was disassociated and no event exists set an error */
+		if (list_empty(&file->event_list) &&
+		    !file->uverbs_file->device->ib_dev)
+			return -EIO;
+
 		spin_lock_irq(&file->lock);
 	}
 
@@ -408,8 +424,11 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_event_file *file = filp->private_data;
 	struct ib_uverbs_event *entry, *tmp;
+	int closed_already = 0;
 
+	mutex_lock(&file->uverbs_file->device->lists_mutex);
 	spin_lock_irq(&file->lock);
+	closed_already = file->is_closed;
 	file->is_closed = 1;
 	list_for_each_entry_safe(entry, tmp, &file->event_list, list) {
 		if (entry->counter)
@@ -417,9 +436,14 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 		kfree(entry);
 	}
 	spin_unlock_irq(&file->lock);
+	if (!closed_already) {
+		list_del(&file->list);
+		if (file->is_async)
+			ib_unregister_event_handler(&file->uverbs_file->
+				event_handler);
+	}
+	mutex_unlock(&file->uverbs_file->device->lists_mutex);
 
-	if (file->is_async)
-		ib_unregister_event_handler(&file->uverbs_file->event_handler);
 	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
 	kref_put(&file->ref, ib_uverbs_release_event_file);
 
@@ -584,6 +608,11 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	if (IS_ERR(filp))
 		goto err_put_refs;
 
+	mutex_lock(&uverbs_file->device->lists_mutex);
+	list_add_tail(&ev_file->list,
+		      &uverbs_file->device->uverbs_events_file_list);
+	mutex_unlock(&uverbs_file->device->lists_mutex);
+
 	if (is_async) {
 		WARN_ON(uverbs_file->async_file);
 		uverbs_file->async_file = ev_file;
@@ -646,12 +675,11 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	struct ib_uverbs_file *file = filp->private_data;
-	struct ib_device *ib_dev = file->device->ib_dev;
+	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
 	__u32 flags;
-
-	if (!ib_dev)
-		return -ENODEV;
+	int srcu_key;
+	ssize_t ret;
 
 	if (count < sizeof hdr)
 		return -EINVAL;
@@ -659,6 +687,14 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof hdr))
 		return -EFAULT;
 
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	ib_dev = srcu_dereference(file->device->ib_dev,
+				  &file->device->disassociate_srcu);
+	if (!ib_dev) {
+		ret = -EIO;
+		goto out;
+	}
+
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
@@ -666,26 +702,36 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		__u32 command;
 
 		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-					   IB_USER_VERBS_CMD_COMMAND_MASK))
-			return -EINVAL;
+					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
 
 		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
-		    !uverbs_cmd_table[command])
-			return -EINVAL;
+		    !uverbs_cmd_table[command]) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (!file->ucontext &&
-		    command != IB_USER_VERBS_CMD_GET_CONTEXT)
-			return -EINVAL;
+		    command != IB_USER_VERBS_CMD_GET_CONTEXT) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (!(ib_dev->uverbs_cmd_mask & (1ull << command)))
-			return -ENOSYS;
+		if (!(ib_dev->uverbs_cmd_mask & (1ull << command))) {
+			ret = -ENOSYS;
+			goto out;
+		}
 
-		if (hdr.in_words * 4 != count)
-			return -EINVAL;
+		if (hdr.in_words * 4 != count) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		return uverbs_cmd_table[command](file, ib_dev,
+		ret = uverbs_cmd_table[command](file, ib_dev,
 						 buf + sizeof(hdr),
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
@@ -696,51 +742,72 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_uverbs_ex_cmd_hdr ex_hdr;
 		struct ib_udata ucore;
 		struct ib_udata uhw;
-		int err;
 		size_t written_count = count;
 
 		if (hdr.command & ~(__u32)(IB_USER_VERBS_CMD_FLAGS_MASK |
-					   IB_USER_VERBS_CMD_COMMAND_MASK))
-			return -EINVAL;
+					   IB_USER_VERBS_CMD_COMMAND_MASK)) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
 
 		if (command >= ARRAY_SIZE(uverbs_ex_cmd_table) ||
-		    !uverbs_ex_cmd_table[command])
-			return -ENOSYS;
+		    !uverbs_ex_cmd_table[command]) {
+			ret = -ENOSYS;
+			goto out;
+		}
 
-		if (!file->ucontext)
-			return -EINVAL;
+		if (!file->ucontext) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
-			return -ENOSYS;
+		if (!(ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
+			ret = -ENOSYS;
+			goto out;
+		}
 
-		if (count < (sizeof(hdr) + sizeof(ex_hdr)))
-			return -EINVAL;
+		if (count < (sizeof(hdr) + sizeof(ex_hdr))) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr)))
-			return -EFAULT;
+		if (copy_from_user(&ex_hdr, buf + sizeof(hdr), sizeof(ex_hdr))) {
+			ret = -EFAULT;
+			goto out;
+		}
 
 		count -= sizeof(hdr) + sizeof(ex_hdr);
 		buf += sizeof(hdr) + sizeof(ex_hdr);
 
-		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count)
-			return -EINVAL;
+		if ((hdr.in_words + ex_hdr.provider_in_words) * 8 != count) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		if (ex_hdr.cmd_hdr_reserved)
-			return -EINVAL;
+		if (ex_hdr.cmd_hdr_reserved) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (ex_hdr.response) {
-			if (!hdr.out_words && !ex_hdr.provider_out_words)
-				return -EINVAL;
+			if (!hdr.out_words && !ex_hdr.provider_out_words) {
+				ret = -EINVAL;
+				goto out;
+			}
 
 			if (!access_ok(VERIFY_WRITE,
 				       (void __user *) (unsigned long) ex_hdr.response,
-				       (hdr.out_words + ex_hdr.provider_out_words) * 8))
-				return -EFAULT;
+				       (hdr.out_words + ex_hdr.provider_out_words) * 8)) {
+				ret = -EFAULT;
+				goto out;
+			}
 		} else {
-			if (hdr.out_words || ex_hdr.provider_out_words)
-				return -EINVAL;
+			if (hdr.out_words || ex_hdr.provider_out_words) {
+				ret = -EINVAL;
+				goto out;
+			}
 		}
 
 		INIT_UDATA_BUF_OR_NULL(&ucore, buf, (unsigned long) ex_hdr.response,
@@ -752,29 +819,43 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 				       ex_hdr.provider_in_words * 8,
 				       ex_hdr.provider_out_words * 8);
 
-		err = uverbs_ex_cmd_table[command](file,
+		ret = uverbs_ex_cmd_table[command](file,
 						   ib_dev,
 						   &ucore,
 						   &uhw);
-
-		if (err)
-			return err;
-
-		return written_count;
+		if (!ret)
+			ret = written_count;
+	} else {
+		ret = -ENOSYS;
 	}
 
-	return -ENOSYS;
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+	return ret;
 }
 
 static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct ib_uverbs_file *file = filp->private_data;
-	struct ib_device *ib_dev = file->device->ib_dev;
+	struct ib_device *ib_dev;
+	int ret = 0;
+	int srcu_key;
 
-	if (!ib_dev || !file->ucontext)
-		return -ENODEV;
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	ib_dev = srcu_dereference(file->device->ib_dev,
+				  &file->device->disassociate_srcu);
+	if (!ib_dev) {
+		ret = -EIO;
+		goto out;
+	}
+
+	if (!file->ucontext)
+		ret = -ENODEV;
 	else
-		return ib_dev->mmap(file->ucontext, vma);
+		ret = ib_dev->mmap(file->ucontext, vma);
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+	return ret;
 }
 
 /*
@@ -791,21 +872,43 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_device *dev;
 	struct ib_uverbs_file *file;
+	struct ib_device *ib_dev;
 	int ret;
+	int module_dependent;
+	int srcu_key;
 
 	dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev);
 	if (!atomic_inc_not_zero(&dev->refcount))
 		return -ENXIO;
 
-	if (!try_module_get(dev->ib_dev->owner)) {
-		ret = -ENODEV;
+	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
+	mutex_lock(&dev->lists_mutex);
+	ib_dev = srcu_dereference(dev->ib_dev,
+				  &dev->disassociate_srcu);
+	if (!ib_dev) {
+		ret = -EIO;
 		goto err;
 	}
 
-	file = kmalloc(sizeof *file, GFP_KERNEL);
+	/* In case IB device supports disassociate ucontext, there is no hard
+	 * dependency between uverbs device and its low level device.
+	 */
+	module_dependent = !(ib_dev->disassociate_ucontext);
+
+	if (module_dependent) {
+		if (!try_module_get(ib_dev->owner)) {
+			ret = -ENODEV;
+			goto err;
+		}
+	}
+
+	file = kzalloc(sizeof(*file), GFP_KERNEL);
 	if (!file) {
 		ret = -ENOMEM;
-		goto err_module;
+		if (module_dependent)
+			goto err_module;
+
+		goto err;
 	}
 
 	file->device	 = dev;
@@ -816,13 +919,18 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = file;
 	kobject_get(&dev->kobj);
+	list_add_tail(&file->list, &dev->uverbs_file_list);
+	mutex_unlock(&dev->lists_mutex);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 
 	return nonseekable_open(inode, filp);
 
 err_module:
-	module_put(dev->ib_dev->owner);
+	module_put(ib_dev->owner);
 
 err:
+	mutex_unlock(&dev->lists_mutex);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 	if (atomic_dec_and_test(&dev->refcount))
 		ib_uverbs_comp_dev(dev);
 
@@ -833,8 +941,18 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_device *dev = file->device;
-
-	ib_uverbs_cleanup_ucontext(file, file->ucontext);
+	struct ib_ucontext *ucontext = NULL;
+
+	mutex_lock(&file->device->lists_mutex);
+	ucontext = file->ucontext;
+	file->ucontext = NULL;
+	if (!file->is_closed) {
+		list_del(&file->list);
+		file->is_closed = 1;
+	}
+	mutex_unlock(&file->device->lists_mutex);
+	if (ucontext)
+		ib_uverbs_cleanup_ucontext(file, ucontext);
 
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
@@ -871,12 +989,21 @@ static struct ib_client uverbs_client = {
 static ssize_t show_ibdev(struct device *device, struct device_attribute *attr,
 			  char *buf)
 {
+	int ret = -ENODEV;
+	int srcu_key;
 	struct ib_uverbs_device *dev = dev_get_drvdata(device);
+	struct ib_device *ib_dev;
 
 	if (!dev)
 		return -ENODEV;
 
-	return sprintf(buf, "%s\n", dev->ib_dev->name);
+	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
+	ib_dev = srcu_dereference(dev->ib_dev, &dev->disassociate_srcu);
+	if (ib_dev)
+		ret = sprintf(buf, "%s\n", ib_dev->name);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
+
+	return ret;
 }
 static DEVICE_ATTR(ibdev, S_IRUGO, show_ibdev, NULL);
 
@@ -884,11 +1011,19 @@ static ssize_t show_dev_abi_version(struct device *device,
 				    struct device_attribute *attr, char *buf)
 {
 	struct ib_uverbs_device *dev = dev_get_drvdata(device);
+	int ret = -ENODEV;
+	int srcu_key;
+	struct ib_device *ib_dev;
 
 	if (!dev)
 		return -ENODEV;
+	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
+	ib_dev = srcu_dereference(dev->ib_dev, &dev->disassociate_srcu);
+	if (ib_dev)
+		ret = sprintf(buf, "%d\n", ib_dev->uverbs_abi_ver);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 
-	return sprintf(buf, "%d\n", dev->ib_dev->uverbs_abi_ver);
+	return ret;
 }
 static DEVICE_ATTR(abi_version, S_IRUGO, show_dev_abi_version, NULL);
 
@@ -928,6 +1063,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	int devnum;
 	dev_t base;
 	struct ib_uverbs_device *uverbs_dev;
+	int ret;
 
 	if (!device->alloc_ucontext)
 		return;
@@ -936,11 +1072,20 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (!uverbs_dev)
 		return;
 
+	ret = init_srcu_struct(&uverbs_dev->disassociate_srcu);
+	if (ret) {
+		kfree(uverbs_dev);
+		return;
+	}
+
 	atomic_set(&uverbs_dev->refcount, 1);
 	init_completion(&uverbs_dev->comp);
 	uverbs_dev->xrcd_tree = RB_ROOT;
 	mutex_init(&uverbs_dev->xrcd_tree_mutex);
 	kobject_init(&uverbs_dev->kobj, &ib_uverbs_dev_ktype);
+	mutex_init(&uverbs_dev->lists_mutex);
+	INIT_LIST_HEAD(&uverbs_dev->uverbs_file_list);
+	INIT_LIST_HEAD(&uverbs_dev->uverbs_events_file_list);
 
 	spin_lock(&map_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -961,7 +1106,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	}
 	spin_unlock(&map_lock);
 
-	uverbs_dev->ib_dev           = device;
+	rcu_assign_pointer(uverbs_dev->ib_dev, device);
 	uverbs_dev->num_comp_vectors = device->num_comp_vectors;
 
 	cdev_init(&uverbs_dev->cdev, NULL);
@@ -1005,9 +1150,72 @@ err:
 	return;
 }
 
+static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
+					struct ib_device *ib_dev)
+{
+	struct ib_uverbs_file *file;
+	struct ib_uverbs_event_file *event_file;
+	struct ib_event event;
+
+	/* Pending running commands to terminate */
+	synchronize_srcu(&uverbs_dev->disassociate_srcu);
+	event.event = IB_EVENT_DEVICE_FATAL;
+	event.element.port_num = 0;
+	event.device = ib_dev;
+
+	mutex_lock(&uverbs_dev->lists_mutex);
+	while (!list_empty(&uverbs_dev->uverbs_file_list)) {
+		struct ib_ucontext *ucontext;
+
+		file = list_first_entry(&uverbs_dev->uverbs_file_list,
+					struct ib_uverbs_file, list);
+		file->is_closed = 1;
+		ucontext = file->ucontext;
+		list_del(&file->list);
+		file->ucontext = NULL;
+		kref_get(&file->ref);
+		mutex_unlock(&uverbs_dev->lists_mutex);
+		/* We must release the mutex before going ahead and calling
+		 * disassociate_ucontext. disassociate_ucontext might end up
+		 * indirectly calling uverbs_close, for example due to freeing
+		 * the resources (e.g mmput).
+		 */
+		ib_uverbs_event_handler(&file->event_handler, &event);
+		if (ucontext) {
+			ib_dev->disassociate_ucontext(ucontext);
+			ib_uverbs_cleanup_ucontext(file, ucontext);
+		}
+
+		mutex_lock(&uverbs_dev->lists_mutex);
+		kref_put(&file->ref, ib_uverbs_release_file);
+	}
+
+	while (!list_empty(&uverbs_dev->uverbs_events_file_list)) {
+		event_file = list_first_entry(&uverbs_dev->
+					      uverbs_events_file_list,
+					      struct ib_uverbs_event_file,
+					      list);
+		spin_lock_irq(&event_file->lock);
+		event_file->is_closed = 1;
+		spin_unlock_irq(&event_file->lock);
+
+		list_del(&event_file->list);
+		if (event_file->is_async) {
+			ib_unregister_event_handler(&event_file->uverbs_file->
+						    event_handler);
+			event_file->uverbs_file->event_handler.device = NULL;
+		}
+
+		wake_up_interruptible(&event_file->poll_wait);
+		kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
+	}
+	mutex_unlock(&uverbs_dev->lists_mutex);
+}
+
 static void ib_uverbs_remove_one(struct ib_device *device)
 {
 	struct ib_uverbs_device *uverbs_dev = ib_get_client_data(device, &uverbs_client);
+	int wait_clients = 1;
 
 	if (!uverbs_dev)
 		return;
@@ -1021,9 +1229,27 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	else
 		clear_bit(uverbs_dev->devnum - IB_UVERBS_MAX_DEVICES, overflow_map);
 
+	if (device->disassociate_ucontext) {
+		/* We disassociate HW resources and immediately return.
+		 * Userspace will see a EIO errno for all future access.
+		 * Upon returning, ib_device may be freed internally and is not
+		 * valid any more.
+		 * uverbs_device is still available until all clients close
+		 * their files, then the uverbs device ref count will be zero
+		 * and its resources will be freed.
+		 * Note: At this point no more files can be opened since the
+		 * cdev was deleted, however active clients can still issue
+		 * commands and close their open files.
+		 */
+		rcu_assign_pointer(uverbs_dev->ib_dev, NULL);
+		ib_uverbs_free_hw_resources(uverbs_dev, device);
+		wait_clients = 0;
+	}
+
 	if (atomic_dec_and_test(&uverbs_dev->refcount))
 		ib_uverbs_comp_dev(uverbs_dev);
-	wait_for_completion(&uverbs_dev->comp);
+	if (wait_clients)
+		wait_for_completion(&uverbs_dev->comp);
 	kobject_put(&uverbs_dev->kobj);
 }
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index b0f898e..4f21d72 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1724,6 +1724,7 @@ struct ib_device {
 	int			   (*destroy_flow)(struct ib_flow *flow_id);
 	int			   (*check_mr_status)(struct ib_mr *mr, u32 check_mask,
 						      struct ib_mr_status *mr_status);
+	void			   (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
 
 	struct ib_dma_mapping_ops   *dma_ops;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
