From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V4 3/5] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Thu, 11 Jun 2015 11:38:29 -0600
Message-ID: <20150611173829.GB14422@obsidianresearch.com>
References: <1434027414-711-1-git-send-email-yishaih@mellanox.com>
 <1434027414-711-4-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434027414-711-4-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 03:56:52PM +0300, Yishai Hadas wrote:
> Enables the uverbs_remove_one to succeed despite the fact that there are
> running IB applications working with the given ib device.  This functionality
> enables a HW device to be unbind/reset despite the fact that there are running
> user space applications using it.

This looks much saner now, thanks. I only looked briefly today.

> -	struct ib_device		       *ib_dev;
> +	struct ib_device	__rcu	       *ib_dev;

Did you run a static checker to confirm the rcu annoation?

> @@ -332,9 +336,15 @@ static ssize_t ib_uverbs_event_read(struct file *filp, char __user *buf,
>  			return -EAGAIN;
>  
>  		if (wait_event_interruptible(file->poll_wait,
> -					     !list_empty(&file->event_list)))
> +					     (!list_empty(&file->event_list) ||
> +					     !file->uverbs_file->device->ib_dev)))

And it warned about this? Any place else?

The barriers built into wait_event_interruptible() and wake_up() make
this OK. That is worth a comment to explain why it is OK RCU protected
data is not using RCU here.

>  
> @@ -397,8 +407,11 @@ static int ib_uverbs_event_close(struct inode *inode, struct file *filp)
>  {
>  	struct ib_uverbs_event_file *file = filp->private_data;
>  	struct ib_uverbs_event *entry, *tmp;
> +	int closed_already = 0;
>  
> +	mutex_lock(&file->uverbs_file->device->lists_mutex);
>  	spin_lock_irq(&file->lock);
> +	closed_already = file->is_closed;
>  	file->is_closed = 1;

It doesn't loook like is_closed can be changed or read while
lists_mutex is held, so why this ordering and closed_already?

> +	struct ib_device *ib_dev = uverbs_dev->ib_dev;
> +	uverbs_dev->ib_dev = NULL;

These are the write side accesses - and we rely on the driver to
ensure there is only one call to ib_uverbs_free_hw_resources? A
comment would be good, it is unusual to see a RCU write side without
an explicit lock.

> +	/* Pending running commands to terminate */
> +	synchronize_srcu(&uverbs_dev->disassociate_srcu);
> +	event.event = IB_EVENT_DEVICE_FATAL;
> +	event.element.port_num = 0;
> +	event.device = ib_dev;
                     ^^^^^^^^^

How does this lifetime work? It doesn't look like
ib_uverbs_event_handler touches event.device? Is this a nop?

> +		/* We must release the mutex before going ahead and calling
> +		 * disassociate_ucontext. disassociate_ucontext might end up
> +		 * indirectly calling uverbs_close, for example due to freeing
> +		 * the resources (e.g mmput).
> +		 */

Can you provide a call trace for this deadlock possibility?

> +	}
> +
> +	mutex_unlock(&uverbs_dev->lists_mutex);
> +
> +	mutex_lock(&uverbs_dev->lists_mutex);

???

> +	while (!list_empty(&uverbs_dev->uverbs_events_file_list)) {
> +		event_file = list_first_entry(&uverbs_dev->
> +					      uverbs_events_file_list,
> +					      struct ib_uverbs_event_file,
> +					      list);
> +		event_file->is_closed = 1;
> +
> +		list_del(&event_file->list);
> +		if (event_file->is_async)
> +			ib_unregister_event_handler(&event_file->uverbs_file->
> +						    event_handler);

Why do we need to do this in ib_uverbs_free_hw_resources ? How does
the event handler hold a ref on the ib_dev?

> +	if (uverbs_dev->flags & UVERBS_FLAG_DISASSOCIATE) {

I wonder if the flag is needed, isn't having a non-null
disassociate_ucontext function enough proof the driver supports this?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
