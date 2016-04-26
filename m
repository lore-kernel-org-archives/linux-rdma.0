From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4] IB/uverbs: Fix race between uverbs_close and
 remove_one
Date: Tue, 26 Apr 2016 09:18:51 -0600
Message-ID: <20160426151851.GC24104@obsidianresearch.com>
References: <20160312204502.GA8346@obsidianresearch.com>
 <CANjDDBiN8X-Efgp6s2wyT1G6fpQZjdreW0pnnBG71E9jjhy-YA@mail.gmail.com>
 <20160314174814.GB5240@obsidianresearch.com>
 <CANjDDBhVH10=0nSr0q4P4imAX6YrFBhE7QEd4ccRe2yUhN0pQQ@mail.gmail.com>
 <20160315203112.GA2786@obsidianresearch.com>
 <CANjDDBj8aZTeAfwxFuyk9r=kdihfxpxDA69-c4uVxkvcAfXViw@mail.gmail.com>
 <20160317161237.GB19501@obsidianresearch.com>
 <CANjDDBhYH7HsUyP8-Ko7G0tnWxYDGYCGgaC4HK0Eod_isvoWAA@mail.gmail.com>
 <20160317164831.GI19501@obsidianresearch.com>
 <571F7C41.70700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <571F7C41.70700-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 26, 2016 at 10:33:37AM -0400, Doug Ledford wrote:
> On 3/17/2016 12:48 PM, Jason Gunthorpe wrote:
> > On Thu, Mar 17, 2016 at 10:01:55PM +0530, Devesh Sharma wrote:
> >> On Thu, Mar 17, 2016 at 9:42 PM, Jason Gunthorpe
> >> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> >>> On Thu, Mar 17, 2016 at 09:38:30PM +0530, Devesh Sharma wrote:
> >>>
> >>>> To my mind mutex is *not* solving the problem completely unless we
> >>>> make it a coarser grained lock. The possible deadlock problem still
> >>>> lingers around it.
> >>>
> >>> Review the last version I sent, with this statement in mind:
> >>
> >> I am sorry I lost the track of it, which one you are point..we have
> >> been discussion for a quite some time now!
> > 
> > Not saying it is perfect, but it should be close:
> 
> Jason, this is your patch since you completely tossed Devesh's work and
> did your own.  Can you please post a corrected version of this with a
> proper changelog and Signed-off-by.  Thanks.

This was just a sketch/hint how to do it properly, it doesn't even
compile, and Devesh needs to test it before going any further.

Since this seems stuck, here is a complete version that does compile
and might even work..

>From 5b19ced7a4076807284fe76a76b63a9093b590aa Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 26 Apr 2016 09:16:01 -0600
Subject: [PATCH] IB/uverbs: Fix race between uverbs_close and remove_one

Fixes an oops that can happen if uverbs_close races with remove_one:

[67140.260665]  [<ffffffff810c16a0>] ? prepare_to_wait_event+0xf0/0xf0
[67140.268337]  [<ffffffffa04cabc3>] ? ib_dereg_mr+0x23/0x30 [ib_core]
[67140.276009]  [<ffffffffa03ee5f0>] ? ib_uverbs_cleanup_ucontext+0x320/0x440 [ib_uverbs]
[67140.285550]  [<ffffffffa03ee9e9>] ? ib_uverbs_close+0x59/0xb0 [ib_uverbs]
[67140.293807]  [<ffffffff811ff744>] ? __fput+0xe4/0x210

This is because both contexts are running ib_uverbs_cleanup_ucontext
concurrently as the locking scheme was not adaquate.

Directly protect ib_uverbs_cleanup_ucontext against concurrency with a
new lock.

Fixes: 35d4a0b63dc0 ("IB/uverbs: Fix race between ib_uverbs_open and remove_one")
Reported-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h      |  1 +
 drivers/infiniband/core/uverbs_main.c | 37 +++++++++++++++++++++++------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 612ccfd39bf9..f0f6c8fa4b5f 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -116,6 +116,7 @@ struct ib_uverbs_event_file {
 struct ib_uverbs_file {
 	struct kref				ref;
 	struct mutex				mutex;
+	struct mutex                            cleanup_mutex;
 	struct ib_uverbs_device		       *device;
 	struct ib_ucontext		       *ucontext;
 	struct ib_event_handler			event_handler;
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 39680aed99dd..43f268f2deb5 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -928,6 +928,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	file->async_file = NULL;
 	kref_init(&file->ref);
 	mutex_init(&file->mutex);
+	mutex_init(&file->cleanup_mutex);
 
 	filp->private_data = file;
 	kobject_get(&dev->kobj);
@@ -953,18 +954,20 @@ static int ib_uverbs_close(struct inode *inode, struct file *filp)
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
@@ -1178,22 +1181,30 @@ static void ib_uverbs_free_hw_resources(struct ib_uverbs_device *uverbs_dev,
 	mutex_lock(&uverbs_dev->lists_mutex);
 	while (!list_empty(&uverbs_dev->uverbs_file_list)) {
 		struct ib_ucontext *ucontext;
-
 		file = list_first_entry(&uverbs_dev->uverbs_file_list,
 					struct ib_uverbs_file, list);
 		file->is_closed = 1;
-		ucontext = file->ucontext;
 		list_del(&file->list);
-		file->ucontext = NULL;
 		kref_get(&file->ref);
 		mutex_unlock(&uverbs_dev->lists_mutex);
-		/* We must release the mutex before going ahead and calling
-		 * disassociate_ucontext. disassociate_ucontext might end up
-		 * indirectly calling uverbs_close, for example due to freeing
-		 * the resources (e.g mmput).
-		 */
+
 		ib_uverbs_event_handler(&file->event_handler, &event);
+
+		mutex_lock(&file->cleanup_mutex);
+		ucontext = file->ucontext;
+		file->ucontext = NULL;
+		mutex_unlock(&file->cleanup_mutex);
+
+		/* At this point ib_uverbs_close cannnot be running
+		 * ib_uverbs_cleanup_ucontext
+		 */
 		if (ucontext) {
+			/* We must release the mutex before going ahead and
+			 * calling
+			 * disassociate_ucontext. disassociate_ucontext might
+			 * end up indirectly calling uverbs_close, for example
+			 * due to freeing the resources (e.g mmput).
+			 */
 			ib_dev->disassociate_ucontext(ucontext);
 			ib_uverbs_cleanup_ucontext(file, ucontext);
 		}
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
