From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Thu, 10 Mar 2016 14:05:35 -0700
Message-ID: <20160310210535.GA9735@obsidianresearch.com>
References: <1457343873-14869-1-git-send-email-devesh.sharma@broadcom.com>
 <20160307190833.GA1886@obsidianresearch.com>
 <CANjDDBiYagKm79n5sWNsCnxruSzqDqZYREmw1mGBR_upapF4hQ@mail.gmail.com>
 <20160308175334.GB10805@obsidianresearch.com>
 <56E053C8.8050008@dev.mellanox.co.il>
 <20160309190354.GD21139@obsidianresearch.com>
 <56E159CC.3090805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E159CC.3090805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 10, 2016 at 01:26:04PM +0200, Yishai Hadas wrote:

>> No, I don't think that is true, the completion looks like it is
>> actually needed because the goto out in ib_uverbs_close needs to wait
>> for ib_uverbs_free_hw_resources to do the cleanups ib_uverbs_close

>> skipped over before it can go ahead and kref_put things.
> Why not ? the final cleanup as part of uverbs_close doesn't depend on ib_dev,
> the kref should be fine for that. The race is *only* for
> ib_uverbs_cleanup_ucontext that uses ib_dev and it should be solved as of
> above suggestion.

It has nothing to do with ib_dev, srcu doesn't lock the list:

CPU 0                                   CPU 1
rcu_assign_pointer(ib_dev, null)
ib_uverbs_free_hw_resources()
synchronize_srcu();
                                        ib_uverbs_close()
                                        srcu_read_lock
					.. goto out
					kref_put(file->ref) .. kfree(file)
ib_uverbs_free_hw_resources()
mutex_lock(&lists_mutex);
while (!list_empty(&uverbs_dev->uverbs_file_list))
  .. Boom, use after free of file->list ..

Ie, as I said, we can't put until we know the list_del is done, and
the goto skips over list_del.

The completion is preventing the above scenario, can't remove it.

> >@@ -953,18 +953,20 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
> >  {
> >  	struct ib_uverbs_file *file = filp->private_data;
> >  	struct ib_uverbs_device *dev = file->device;
> >-	struct ib_ucontext *ucontext = NULL;
> >
> >  	mutex_lock(&file->device->lists_mutex);
> >-	ucontext = file->ucontext;
> >-	file->ucontext = NULL;
> >  	if (!file->is_closed) {
> >  		list_del(&file->list);
> >  		file->is_closed = 1;
> >  	}
> >  	mutex_unlock(&file->device->lists_mutex);
> 
> At that point file was deleted from the list and there is *no* sync any more
> with ib_uverbs_free_hw_resources relates to that file.

Yes, that is right. The ordering of the two locking blocks in ib_uverbs_close should
be swapped to prevent this.

> >-		if (ucontext) {
> >-			ib_dev->disassociate_ucontext(ucontext);
> >-			ib_uverbs_cleanup_ucontext(file, ucontext);
> >+		mutex_lock(&file->cleanup_mutex);
> >+		if (file->ucontext) {
> >+			ib_dev->disassociate_ucontext(file->ucontext);
> 
> This might end up with deadlock, what is the difference between taking this
> cleanup mutex comparing the list mutex ? see above comment re calling
> disassociate_ucontext under the lock.

If the above can deadlock then so can the wait on completion, since it
is basically the same construct.

Fortunately that isn't hard to deal with, more like this:

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 39680aed99dd..b46bbd3dda98 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -953,18 +953,20 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_uverbs_device *dev = file->device;
-	struct ib_ucontext *ucontext = NULL;
+
+	mutex_lock(&file->cleanup_mutex);
+	if (file->ucontext) {
+		ib_uverbs_cleanup_ucontext(file, file->ucontext);
+		file->ucontext = NULL;
+	}
+	mutex_unlock(&file->cleanup_mutex);
 
 	mutex_lock(&file->device->lists_mutex);
-	ucontext = file->ucontext;
-	file->ucontext = NULL;
 	if (!file->is_closed) {
 		list_del(&file->list);
 		file->is_closed = 1;
 	}
 	mutex_unlock(&file->device->lists_mutex);
-	if (ucontext)
-		ib_uverbs_cleanup_ucontext(file, ucontext);
 
 	if (file->async_file)
 		kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
@@ -1177,26 +1179,28 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 
 	mutex_lock(&uverbs_dev->lists_mutex);
 	while (!list_empty(&uverbs_dev->uverbs_file_list)) {
-		struct ib_ucontext *ucontext;
-
 		file = list_first_entry(&uverbs_dev->uverbs_file_list,
 					struct ib_uverbs_file, list);
 		file->is_closed = 1;
-		ucontext = file->ucontext;
 		list_del(&file->list);
-		file->ucontext = NULL;
 		kref_get(&file->ref);
 		mutex_unlock(&uverbs_dev->lists_mutex);
+
 		/* We must release the mutex before going ahead and calling
 		 * disassociate_ucontext. disassociate_ucontext might end up
 		 * indirectly calling uverbs_close, for example due to freeing
 		 * the resources (e.g mmput).
 		 */
 		ib_uverbs_event_handler(&file->event_handler, &event);
-		if (ucontext) {
-			ib_dev->disassociate_ucontext(ucontext);
-			ib_uverbs_cleanup_ucontext(file, ucontext);
+		mutex_lock(&file->cleanup_mutex);
+		if (file->ucontext) {
+			file->ucontext = NULL;
+			mutex_unlock(&file->cleanup_mutex);
+			ib_dev->disassociate_ucontext(file->ucontext);
+			ib_uverbs_cleanup_ucontext(file, file->ucontext);
 		}
+		else
+			mutex_unlock(&file->cleanup_mutex);
 
 		mutex_lock(&uverbs_dev->lists_mutex);
 		kref_put(&file->ref, ib_uverbs_release_file);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
