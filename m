From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Mon, 25 May 2015 10:54:49 -0600
Message-ID: <20150525165449.GA4379@obsidianresearch.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
 <1431515438-24042-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1431515438-24042-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 13, 2015 at 02:10:36PM +0300, Yishai Hadas wrote:

> +	struct srcu_struct			disassociate_srcu;

There is no need for rcu for this, use a rw sem.

> @@ -1326,6 +1327,13 @@ ssize_t ib_uverbs_create_comp_channel(struct ib_uverbs_file *file,
>  		return -EFAULT;
>  	}
>  
> +	/* Taking ref count on uverbs_file to make sure that file won't be
> +	 * freed till that event file is closed. It will enable accessing the
> +	 * uverbs_device fields as part of closing the events file and making
> +	 * sure that uverbs device is available by that time as well.
> +	 * Note: similar is already done for the async event file.
> +	*/
> +	kref_get(&file->ref);

Is this a bug today? It doesn't look like it, but this stuff does look wrong.

Woulnd't this would make more sense for ib_uverbs_alloc_event_file to
unconditionally grab the kref and unconditionally release it on
release? 

The existing code for this looks broken, in ib_uverbs_get_context all
the error paths between ib_uverbs_alloc_event_file and the
kref_get(file->ref) are wrong - the will result in fput() which will
call ib_uverbs_event_close, which will try to do kref_put and
ib_unregister_event_handler - which are no longer paired.

[I recommend moving the kref_get and ib_register_event_handler into
 ib_uverbs_alloc_event_file, so the 'create' and 'destroy' code paths
 are clearly paired instead of being partially open coded in call
 sites]

Fix all this in a seperate patch to add the needed change in kref
semantics please.

> -	if (!try_module_get(dev->ib_dev->owner)) {
> -		ret = -ENODEV;
> +	mutex_lock(&dev->disassociate_mutex);
> +	if (dev->disassociated) {
> +		ret = -EIO;
>  		goto err;
>  	}
>  
> -	file = kmalloc(sizeof *file, GFP_KERNEL);
> +	/* In case IB device supports disassociate ucontext, there is no hard
> +	 * dependency between uverbs device and its low level device.
> +	 */
> +	module_dependent = !(dev->flags & UVERBS_FLAG_DISASSOCIATE);
> +
> +	if (module_dependent) {
> +		if (!try_module_get(dev->ib_dev->owner)) {
> +			ret = -ENODEV;
> +			goto err;

Again? Why I do I keep pointing this same basic thing to Mellanox
people:

 If you hold a X then you hold the ref to X as well.

So, if the core code is holding function pointers to module code, then
the core code holds a module ref. When the core code null's those
function pointers, then it can release the module ref.

This might work today like this (I'm not entirely sure), but it makes
no sense at all.

I'll look more closely in a few weeks once the rwsem change is done.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
