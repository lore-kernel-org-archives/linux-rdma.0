From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when there are active user space applications
Date: Wed, 13 May 2015 14:10:36 +0300
Message-ID: <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431515438-24042-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Enables the uverbs_remove_one to succeed despite the fact that there are
running IB applications working with the given ib device.  This functionality
enables a HW device to be unbind/reset despite the fact that there are running
user space applications using it.

It exposes a new IB kernel API named 'disassociate_ucontext' which lets a
driver detaching its HW resources from a given user context without
crashing/terminating the application. In case a driver implemented the above
API and registered with ib_uverb there will be no dependency between its device
to its uverbs_device. Upon calling remove_one of ib_uverbs the call should
return after disassociating the open HW resources without waiting to clients
disconnecting. In case driver didn't implement this API there will be no change
to current behaviour and uverbs_remove_one will return only when last client
has disconnected and reference count on uverbs device became 0.

In case the lower driver device was removed any application will continue
working over some zombie HCA, further calls will ended with an immediate error.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |   12 ++
 drivers/infiniband/core/uverbs_cmd.c  |    8 +
 drivers/infiniband/core/uverbs_main.c |  325 +++++++++++++++++++++++++++------
 include/rdma/ib_verbs.h               |    1 +
 4 files changed, 290 insertions(+), 56 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index b716b08..4ef6b1c 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -63,6 +63,10 @@
 		(udata)->outlen = (olen);					\
 	} while (0)
 
+enum uverbs_flags {
+	UVERBS_FLAG_DISASSOCIATE = 1
+};
+
 /*
  * Our lifetime rules for these structs are the following:
  *
@@ -94,6 +98,12 @@ struct ib_uverbs_device {
 	struct cdev			        cdev;
 	struct rb_root				xrcd_tree;
 	struct mutex				xrcd_tree_mutex;
+	struct mutex				disassociate_mutex; /* protect lists of files. */
+	int					disassociated;
+	u32					flags;
+	struct srcu_struct			disassociate_srcu;
+	struct list_head			uverbs_file_list;
+	struct list_head			uverbs_events_file_list;
 };
 
 struct ib_uverbs_event_file {
@@ -105,6 +115,7 @@ struct ib_uverbs_event_file {
 	wait_queue_head_t			poll_wait;
 	struct fasync_struct		       *async_queue;
 	struct list_head			event_list;
+	struct list_head			list;
 };
 
 struct ib_uverbs_file {
@@ -114,6 +125,7 @@ struct ib_uverbs_file {
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
 	struct ib_uverbs_event_file	       *async_file;
+	struct list_head			list;
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a9f0489..4b6a9e6 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -39,6 +39,7 @@
 #include <linux/sched.h>
 
 #include <asm/uaccess.h>
+#include <linux/sched.h>
 
 #include "uverbs.h"
 #include "core_priv.h"
@@ -1326,6 +1327,13 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
 		return -EFAULT;
 	}
 
+	/* Taking ref count on uverbs_file to make sure that file won't be
+	 * freed till that event file is closed. It will enable accessing the
+	 * uverbs_device fields as part of closing the events file and making
+	 * sure that uverbs device is available by that time as well.
+	 * Note: similar is already done for the async event file.
+	*/
+	kref_get(&file->ref);
 	fd_install(resp.fd, filp);
 	return in_len;
 }
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 88cce9b..d96d7c7 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -134,7 +134,12 @@ static void ib_uverbs_release_dev(struct kref *ref)
 	struct ib_uverbs_device *dev =
 		container_of(ref, struct ib_uverbs_device, ref);
 
-	complete(&dev->comp);
+	if (dev->disassociated) {
+		cleanup_srcu_struct(&dev->disassociate_srcu);
+		kfree(dev);
+	} else {
+		complete(&dev->comp);
+	}
 }
 
 static void ib_uverbs_release_event_file(struct kref *ref)
@@ -307,7 +312,9 @@ static void ib_uverbs_release_file(struct kref *ref)
 	struct ib_uverbs_file *file =
 		container_of(ref, struct ib_uverbs_file, ref);
 
-	module_put(file->device->ib_dev->owner);
+	if (!(file->device->flags & UVERBS_FLAG_DISASSOCIATE))
+		module_put(file->device->ib_dev->owner);
+
 	kref_put(&file->device->ref, ib_uverbs_release_dev);
 
 	kfree(file);
@@ -330,9 +337,14 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
 			return -EAGAIN;
 
 		if (wait_event_interruptible(file->poll_wait,
-					     !list_empty(&file->event_list)))
+					     (!list_empty(&file->event_list) ||
+					     file->uverbs_file->device->disassociated)))
 			return -ERESTARTSYS;
 
+		/* We reach here when list is not empty or when device was disassociated */
+		if (list_empty(&file->event_list) && file->uverbs_file->device->disassociated)
+			return -EIO;
+
 		spin_lock_irq(&file->lock);
 	}
 
@@ -405,12 +417,17 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
 	}
 	spin_unlock_irq(&file->lock);
 
-	if (file->is_async) {
-		ib_unregister_event_handler(&file->uverbs_file->event_handler);
-		kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
+	mutex_lock(&file->uverbs_file->device->disassociate_mutex);
+	if (!file->uverbs_file->device->disassociated) {
+		list_del(&file->list);
+		if (file->is_async)
+			ib_unregister_event_handler(&file->uverbs_file->event_handler);
 	}
-	kref_put(&file->ref, ib_uverbs_release_event_file);
 
+	mutex_unlock(&file->uverbs_file->device->disassociate_mutex);
+
+	kref_put(&file->uverbs_file->ref, ib_uverbs_release_file);
+	kref_put(&file->ref, ib_uverbs_release_event_file);
 	return 0;
 }
 
@@ -546,7 +563,7 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 	struct ib_uverbs_event_file *ev_file;
 	struct file *filp;
 
-	ev_file = kmalloc(sizeof *ev_file, GFP_KERNEL);
+	ev_file = kzalloc(sizeof *ev_file, GFP_KERNEL);
 	if (!ev_file)
 		return ERR_PTR(-ENOMEM);
 
@@ -561,10 +578,25 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 
 	filp = anon_inode_getfile("[infinibandevent]", &uverbs_event_fops,
 				  ev_file, O_RDONLY);
-	if (IS_ERR(filp))
+	if (IS_ERR(filp)) {
 		kfree(ev_file);
+		return filp;
+	}
+
+	mutex_lock(&uverbs_file->device->disassociate_mutex);
+	if (!uverbs_file->device->disassociated) {
+		list_add_tail(&ev_file->list,
+			      &uverbs_file->device->uverbs_events_file_list);
+		mutex_unlock(&uverbs_file->device->disassociate_mutex);
 
-	return filp;
+		return filp;
+	}
+
+	mutex_unlock(&uverbs_file->device->disassociate_mutex);
+
+	fput(filp);
+	kfree(ev_file);
+	return ERR_PTR(-EIO);
 }
 
 /*
@@ -602,6 +634,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_cmd_hdr hdr;
 	__u32 flags;
+	int srcu_key;
+	ssize_t ret;
 
 	if (count < sizeof hdr)
 		return -EINVAL;
@@ -609,6 +643,12 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	if (copy_from_user(&hdr, buf, sizeof hdr))
 		return -EFAULT;
 
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	if (file->device->disassociated) {
+		ret = -EIO;
+		goto out;
+	}
+
 	flags = (hdr.command &
 		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
 
@@ -616,26 +656,36 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
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
 
-		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command)))
-			return -ENOSYS;
+		if (!(file->device->ib_dev->uverbs_cmd_mask & (1ull << command))) {
+			ret = -ENOSYS;
+			goto out;
+		}
 
-		if (hdr.in_words * 4 != count)
-			return -EINVAL;
+		if (hdr.in_words * 4 != count) {
+			ret = -EINVAL;
+			goto out;
+		}
 
-		return uverbs_cmd_table[command](file,
+		ret = uverbs_cmd_table[command](file,
 						 buf + sizeof(hdr),
 						 hdr.in_words * 4,
 						 hdr.out_words * 4);
@@ -650,47 +700,69 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
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
 
-		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command)))
-			return -ENOSYS;
+		if (!(file->device->ib_dev->uverbs_ex_cmd_mask & (1ull << command))) {
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
@@ -707,22 +779,37 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 						   &uhw);
 
 		if (err)
-			return err;
-
-		return written_count;
+			ret = err;
+		else
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
+	int ret = 0;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	if (file->device->disassociated) {
+		ret = -EIO;
+		goto out;
+	}
 
 	if (!file->ucontext)
-		return -ENODEV;
+		ret = -ENODEV;
 	else
-		return file->device->ib_dev->mmap(file->ucontext, vma);
+		ret = file->device->ib_dev->mmap(file->ucontext, vma);
+out:
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
+	return ret;
 }
 
 /*
@@ -740,6 +827,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	struct ib_uverbs_device *dev;
 	struct ib_uverbs_file *file;
 	int ret;
+	int module_dependent;
 
 	dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev);
 	if (dev)
@@ -747,15 +835,31 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	else
 		return -ENXIO;
 
-	if (!try_module_get(dev->ib_dev->owner)) {
-		ret = -ENODEV;
+	mutex_lock(&dev->disassociate_mutex);
+	if (dev->disassociated) {
+		ret = -EIO;
 		goto err;
 	}
 
-	file = kmalloc(sizeof *file, GFP_KERNEL);
+	/* In case IB device supports disassociate ucontext, there is no hard
+	 * dependency between uverbs device and its low level device.
+	 */
+	module_dependent = !(dev->flags & UVERBS_FLAG_DISASSOCIATE);
+
+	if (module_dependent) {
+		if (!try_module_get(dev->ib_dev->owner)) {
+			ret = -ENODEV;
+			goto err;
+		}
+	}
+
+	file = kzalloc(sizeof *file, GFP_KERNEL);
 	if (!file) {
 		ret = -ENOMEM;
-		goto err_module;
+		if (module_dependent)
+			goto err_module;
+
+		goto err;
 	}
 
 	file->device	 = dev;
@@ -765,6 +869,8 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	mutex_init(&file->mutex);
 
 	filp->private_data = file;
+	list_add_tail(&file->list, &dev->uverbs_file_list);
+	mutex_unlock(&dev->disassociate_mutex);
 
 	return nonseekable_open(inode, filp);
 
@@ -772,6 +878,7 @@ err_module:
 	module_put(dev->ib_dev->owner);
 
 err:
+	mutex_unlock(&dev->disassociate_mutex);
 	kref_put(&dev->ref, ib_uverbs_release_dev);
 	return ret;
 }
@@ -779,9 +886,26 @@ err:
 static int ib_uverbs_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_file *file = filp->private_data;
+	struct ib_ucontext *ucontext = NULL;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&file->device->disassociate_srcu);
+	mutex_lock(&file->device->disassociate_mutex);
+	if (!file->device->disassociated) {
+		/* No need to remove from the list once alreday disassociated.
+		 * Try doing that might race with ib_uverbs_free_hw_resources
+		 * as mutex is not held by that time.
+		 */
+		list_del(&file->list);
+		ucontext = file->ucontext;
+	}
+
+	mutex_unlock(&file->device->disassociate_mutex);
 
-	ib_uverbs_cleanup_ucontext(file, file->ucontext);
+	if (ucontext)
+		ib_uverbs_cleanup_ucontext(file, ucontext);
 
+	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
 
@@ -873,6 +997,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	int devnum;
 	dev_t base;
 	struct ib_uverbs_device *uverbs_dev;
+	int ret;
 
 	if (!device->alloc_ucontext)
 		return;
@@ -885,6 +1010,13 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	init_completion(&uverbs_dev->comp);
 	uverbs_dev->xrcd_tree = RB_ROOT;
 	mutex_init(&uverbs_dev->xrcd_tree_mutex);
+	mutex_init(&uverbs_dev->disassociate_mutex);
+	ret = init_srcu_struct(&uverbs_dev->disassociate_srcu);
+	if (ret)
+		goto err_init;
+
+	INIT_LIST_HEAD(&uverbs_dev->uverbs_file_list);
+	INIT_LIST_HEAD(&uverbs_dev->uverbs_events_file_list);
 
 	spin_lock(&map_lock);
 	devnum = find_first_zero_bit(dev_map, IB_UVERBS_MAX_DEVICES);
@@ -926,6 +1058,9 @@ static void ib_uverbs_add_one(struct ib_device *device)
 	if (device_create_file(uverbs_dev->dev, &dev_attr_abi_version))
 		goto err_class;
 
+	if (device->disassociate_ucontext)
+		uverbs_dev->flags |= UVERBS_FLAG_DISASSOCIATE;
+
 	ib_set_client_data(device, &uverbs_client, uverbs_dev);
 
 	return;
@@ -941,15 +1076,71 @@ err_cdev:
 		clear_bit(devnum, overflow_map);
 
 err:
+	cleanup_srcu_struct(&uverbs_dev->disassociate_srcu);
+
+err_init:
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
 	wait_for_completion(&uverbs_dev->comp);
 	kfree(uverbs_dev);
 	return;
 }
 
+static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev)
+{
+	struct ib_uverbs_file *file, *tmp_file;
+	struct ib_uverbs_event_file *event_file, *tmp_event_file;
+	struct ib_event event;
+
+	mutex_lock(&uverbs_dev->disassociate_mutex);
+	uverbs_dev->disassociated = 1;
+	/* We must release the mutex before going ahead and calling
+	 * disassociate_ucontext as a nested call to uverbs_close might
+	 * be called as a result of freeing the resources (e.g mmput).
+	 * In addition, we should take an extra ref count on files to prevent
+	 * them being freed as part of parallel file closing, from other task
+	 * or from event occurs internally from that one.
+	 */
+	list_for_each_entry(file, &uverbs_dev->uverbs_file_list, list)
+		kref_get(&file->ref);
+	list_for_each_entry(event_file, &uverbs_dev->uverbs_events_file_list, list)
+		kref_get(&event_file->ref);
+	mutex_unlock(&uverbs_dev->disassociate_mutex);
+
+	/* Pending running commands to terminate */
+	synchronize_srcu(&uverbs_dev->disassociate_srcu);
+	event.event = IB_EVENT_DEVICE_FATAL;
+	event.element.port_num = 0;
+	event.device = uverbs_dev->ib_dev;
+
+	list_for_each_entry(file, &uverbs_dev->uverbs_file_list, list) {
+		ib_uverbs_event_handler(&file->event_handler, &event);
+		uverbs_dev->ib_dev->disassociate_ucontext(file->ucontext);
+		ib_uverbs_cleanup_ucontext(file, file->ucontext);
+	}
+
+	list_for_each_entry(event_file, &uverbs_dev->uverbs_events_file_list, list) {
+		if (event_file->is_async) {
+			/* ib_device is freed once that function/remove_one is
+			 * finished, must unregister the event handler before.
+			 */
+			ib_unregister_event_handler(&event_file->uverbs_file->event_handler);
+		}
+
+		wake_up_interruptible(&event_file->poll_wait);
+		kill_fasync(&event_file->async_queue, SIGIO, POLL_IN);
+	}
+
+	/* A safe iterator is needed as file might be freed as part of loop */
+	list_for_each_entry_safe(file, tmp_file, &uverbs_dev->uverbs_file_list, list)
+		kref_put(&file->ref, ib_uverbs_release_file);
+
+	list_for_each_entry_safe(event_file, tmp_event_file, &uverbs_dev->uverbs_events_file_list, list)
+		kref_put(&event_file->ref, ib_uverbs_release_event_file);
+}
 static void ib_uverbs_remove_one(struct ib_device *device)
 {
 	struct ib_uverbs_device *uverbs_dev = ib_get_client_data(device, &uverbs_client);
+	int wait_clients = 1;
 
 	if (!uverbs_dev)
 		return;
@@ -963,9 +1154,31 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	else
 		clear_bit(uverbs_dev->devnum - IB_UVERBS_MAX_DEVICES, overflow_map);
 
+	if (uverbs_dev->flags & UVERBS_FLAG_DISASSOCIATE) {
+		/* We disassociate HW resources and immediately returning, not
+		 * pending to active userspace clients. Upon returning ib_device
+		 * may be freed internally and is not valid any more.
+		 * uverbs_device is still available, when all clients close
+		 * their files, the uverbs device ref count will be zero and its
+		 * resources will be freed.
+		 * Note: At that step no more files can be opened on that cdev
+		 * as it was deleted, however active clients can still issue
+		 * commands and close their open files.
+		 */
+		ib_uverbs_free_hw_resources(uverbs_dev);
+		wait_clients = 0;
+		/* ib device can no longer be accessed, it is freed when this
+		 * function returns.
+		 */
+		uverbs_dev->ib_dev = NULL;
+	}
+	/* ref count taken as part of add one is put back in both modes. */
 	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
-	wait_for_completion(&uverbs_dev->comp);
-	kfree(uverbs_dev);
+	if (wait_clients) {
+		wait_for_completion(&uverbs_dev->comp);
+		cleanup_srcu_struct(&uverbs_dev->disassociate_srcu);
+		kfree(uverbs_dev);
+	}
 }
 
 static char *uverbs_devnode(struct device *dev, umode_t *mode)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..d9501e7 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1652,6 +1652,7 @@ struct ib_device {
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
