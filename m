From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Wed, 24 Jun 2015 12:25:19 -0600
Message-ID: <20150624182519.GD21033@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434984438-21733-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 22, 2015 at 05:47:16PM +0300, Yishai Hadas wrote:
> +++ b/drivers/infiniband/core/uverbs_main.c
> @@ -137,7 +137,12 @@ static void ib_uverbs_release_dev(struct kref *ref)
>  	struct ib_uverbs_device *dev =
>  		container_of(ref, struct ib_uverbs_device, ref);
>  
> -	complete(&dev->comp);
> +	if (!dev->ib_dev) {
> +		cleanup_srcu_struct(&dev->disassociate_srcu);
> +		kfree(dev);
> +	} else {
> +		complete(&dev->comp);
> +	}

Oy.. It is so gross to see a kref now being simultaneously used for
actual memory accounting and also for general reference counting.

It is also locked wrong, for instance:

@@ -792,13 +889,18 @@  static int ib_uverbs_open(struct inode *inode, struct file *filp)
 err:
+	mutex_unlock(&dev->lists_mutex);
+	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
 	kref_put(&dev->ref, ib_uverbs_release_dev);

Is not holding the RCU lock while ib_uverbs_release_dev is reading
ib_dev. The barriers in kref are not strong enough to guarentee the RCU
protected data will be visible. (remember when I asked if you checked
all of these?)

Obviously you can't hold the disassociate_srcu and call kref_put, so
maybe grabbing it in release_dev would work. I didn't look that
closely.

But really, don't make a kref do two kinds of things, it just doesn't
make any sense. You should split it into a proper memory ownership
tracking kref that always does kfree and a counter used to cause
complete().

The rest looked OK now..

> +                       /* The barriers built into wait_event_interruptible()
> +                        * and wake_up() make this ib_dev check RCU protected
> +                        */

No..

 The barriers built into wait_event_interruptible() and wake_up()
 guarentee this will see the null set without using RCU

> +	if (device->disassociate_ucontext) {
> +		/* We disassociate HW resources and immediately returning, not
> +		 * pending to active userspace clients. Upon returning ib_device
> +		 * may be freed internally and is not valid any more.
> +		 * uverbs_device is still available, when all clients close
> +		 * their files, the uverbs device ref count will be zero and its
> +		 * resources will be freed.
> +		 * Note: At that step no more files can be opened on that cdev
> +		 * as it was deleted, however active clients can still issue
> +		 * commands and close their open files.
> +		 */

Clean up the grammer..

We disassociate HW resources and immediately return. Userspace will
see a EIO errno for all future access. Upon returning, ib_device may be
freed internally and is not valid any more.  uverbs_device is still
available until all clients close their files, then the uverbs device
ref count will be zero and its resources will be freed.  Note: At this
point no more files can be opened since the cdev was deleted, however
active clients can still issue commands and close their open files.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
