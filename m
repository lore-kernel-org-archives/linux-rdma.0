From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4] IB/uverbs: Fix race between uverbs_close and remove_one
Date: Sat, 12 Mar 2016 10:18:47 -0500
Message-ID: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixes: 35d4a0b63dc0 ("IB/uverbs: Fix race between ib_uverbs_open and remove_one")

If "rmmod <vendor-driver>" is done while having rdma applications still running
on a host, the system crashes in the page-fault handler trying to fetch
physical address of an daggling device pointer.

During rmmod every vendor driver must call ib_unregister_device. As part of
this call, IB-stack tries to free-up all the resource associated with the
leaving driver. During the call to ib_uverbs_remove_one, a fatal-event is given
to all the alive rdma applications. The fatal-event causes applications to call
ib_uverbs_close(). Thus, causes two different cleanup context to run in parallel.
In the above scenario, it is possible that ib_uverbs_remove_one() completes and
unblock ib_unregister_device() while ib_uverbs_close() is still waiting for
some of the hardware specific firmware commands to finish. The unblocked
ib_unregister_device() context can actually proceed and free the ib_device
structure. At the same time, in ib_uverbs_close() context the firmware command
may complete and may try to dereference ib_device pointer. But ib_device
pointer is a daggling pointer. Dereference to this pointer causes kernel to
invoke the page_fault handler. It fails to fetch the physical address and
causes kernel panic.

This patch adds two solutions as a remedy:

A) In ib_uverbs_close() context a NULL pointer check on dev->ib_dev pointer is
   added. The check is under a srcu_read_lock. If dev->ib_dev is NULL, the
   check prevents ib_uverbs_close() to enter into ib_uverbs_cleanup_ucontext()
   if ib_uverbs_remove_one has already started. If dev->ib_dev is not NULL,
   ib_uverbs_close() will continue as it is today.

With solution 'A' in place, it is still possible that after reading dev->ib_dev
NULL ib_uverbs_close() context go ahaed and put reference to
ib_uverbs_release_file, even before ib_uverbs_remove_one() reaches to this file
pointer traversing the entire file list one by one. Thus, again to synchronize
these two independent contexts we add solution 'B'

B) If ib_uverbs_close() context reads dev->ib_dev as NULL then, drop the
   srcu_read_lock() and wait for ib_uverbs_remove_one() context to reach
   to the stage where all the resources attached to this file pointer are
   freed. Now, allow ib_uverbs_close() context to put the reference of
   ib_uverbs_release_file. This behaviour is achived with the help of a
   completion signaling.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-by: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd..94a7339 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -121,6 +121,7 @@ struct ib_uverbs_file {
 	struct ib_event_handler			event_handler;
 	struct ib_uverbs_event_file	       *async_file;
 	struct list_head			list;
+	struct completion			fcomp;
 	int					is_closed;
 };
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 39680ae..da1fed2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -928,6 +928,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	file->async_file = NULL;
 	kref_init(&file->ref);
 	mutex_init(&file->mutex);
+	init_completion(&file->fcomp);
 
 	filp->private_data = file;
 	kobject_get(&dev->kobj);
@@ -954,6 +955,17 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_device *dev = file->device;
 	struct ib_ucontext *ucontext = NULL;
+	struct ib_device *ib_dev;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
+	ib_dev = srcu_dereference(dev->ib_dev,
+				  &dev->disassociate_srcu);
+	if (!ib_dev) {
+		srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
+		wait_for_completion(&file->fcomp);
+		goto out;
+	}
 
 	mutex_lock(&file->device->lists_mutex);
 	ucontext = file->ucontext;
@@ -965,10 +977,11 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->device->lists_mutex);
 	if (ucontext)
 		ib_uverbs_cleanup_ucontext(file, ucontext);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
-
+out:
 	kref_put(&file->ref, ib_uverbs_release_file);
 	kobject_put(&dev->kobj);
 
@@ -1199,6 +1212,7 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 		}
 
 		mutex_lock(&uverbs_dev->lists_mutex);
+		complete(&file->fcomp);
 		kref_put(&file->ref, ib_uverbs_release_file);
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
