From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Thu, 17 Mar 2016 10:48:31 -0600
Message-ID: <20160317164831.GI19501@obsidianresearch.com>
References: <1457795927-16634-1-git-send-email-devesh.sharma@broadcom.com>
 <20160312204502.GA8346@obsidianresearch.com>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
 <20160315203112.GA2786@obsidianresearch.com>
 <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw@mail.gmail.com>
 <20160317161237.GB19501@obsidianresearch.com>
 <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 17, 2016 at 10:01:55PM +0530, Devesh Sharma wrote:
> On Thu, Mar 17, 2016 at 9:42 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Thu, Mar 17, 2016 at 09:38:30PM +0530, Devesh Sharma wrote:
> >
> >> To my mind mutex is *not* solving the problem completely unless we
> >> make it a coarser grained lock. The possible deadlock problem still
> >> lingers around it.
> >
> > Review the last version I sent, with this statement in mind:
> 
> I am sorry I lost the track of it, which one you are point..we have
> been discussion for a quite some time now!

Not saying it is perfect, but it should be close:

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
