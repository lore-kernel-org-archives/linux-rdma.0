From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Tue, 30 Jun 2015 12:40:35 -0600
Message-ID: <20150630184035.GC2819@obsidianresearch.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <1435659967-27173-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435659967-27173-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 01:26:05PM +0300, Yishai Hadas wrote:
>  struct ib_uverbs_device {
> -	struct kref				ref;
> +	struct kref				comp_ref;
> +	struct kref				free_ref;

So.. I was looking at this, and there is something wrong with the
existing code. 

This old code:

	cdev_del(&uverbs_dev->cdev);
	[..]
 	wait_for_completion(&uverbs_dev->comp);
-	kfree(uverbs_dev);

Has built in to it an assumption that when cdev_del returns there can
be no possible open() running. Which doesn't appear to be true, cdev
calls open unlocked and relies on refcounting to make everything work
out.

Even other places in the rdma core work this way, eg user_mad.

Which means open can be running concurrently with the rest of that
stuff, which creates several obvious problems.

I *think* (and I am not totally sure) that when you use cdev with a
dynamic structure, it *must* be chained off of a kobject for the
containing structure. Certainly, other examples in the kernel I've
looked at recently do this. (Typically the cdev will be part of the

Ie it should look like this:

  struct ib_uverbs_device {
	struct kobject			        kobj;
	struct cdev			        cdev;

	cdev_init(&uverbs_dev->cdev, NULL);
	uverbs_dev->cdev.kobj.parent = &uverbs_dev->kobj;
	cdev_add(..)

The cdev will hold a kref on the parent (the containing structure) and
only when that kref is released is it guaranteed that open will never
be called again.

So, kobj becomes your free_ref, and cdev properly chains off it to
close that little hole with kref.

---

The next problem is that open can run concurrently with
wait_for_completion, so the waiting scheme is wrong too.

This is a great example of why you should never use a kref for an
active count. It seems like the right thing, but it is subtly wrong.

krefs have this special property:

kref_get()
        WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);

So when the code did this:

-	kref_put(&uverbs_dev->ref, ib_uverbs_release_dev);
-	wait_for_completion(&uverbs_dev->comp);
-	kfree(uverbs_dev);

There is a race where another CPU may be in ib_uverbs_open
about to do kref_get, which will trigger the above WARN_ON, or a
use after free race with the kfree

A good way to implement this pattern is to use an atomic with a
bias. See how kernfs_get_active/kernfs_put_active/kernfs_drain work
for a very good example of this scheme.

This is an existing bug, I think a dedicated patch which
 - adds the kobj and moves the kfree(uverbs_dev) into it
 - Fixes the active count scheme to use an atomic not a kref

Would be appropriate. Once done the disassociate patch doesn't have to
really do anything with this stuff.

I would also recommend looking at other uses of cdev_add in the rdma
core, they may be similarly off..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
