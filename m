From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V4 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Thu, 11 Jun 2015 11:08:27 -0600
Message-ID: <20150611170827.GA14422@obsidianresearch.com>
References: <1434027414-711-1-git-send-email-yishaih@mellanox.com>
 <1434027414-711-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434027414-711-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 03:56:50PM +0300, Yishai Hadas wrote:
>  
> -	file->async_file = filp->private_data;
> -
> -	INIT_IB_EVENT_HANDLER(&file->event_handler, file->device->ib_dev,
> -			      ib_uverbs_event_handler);
> -	ret = ib_register_event_handler(&file->event_handler);
> -	if (ret)
> -		goto err_file;
> -
>  	kref_get(&file->async_file->ref);

This kref_get should be placed next to the assignment:

> +	if (is_async) {
> +		uverbs_file->async_file = ev_file;

Here

Also, I'd say it should really be:

	if (is_async) {
	        BUG_ON(uverbs_file->async_file);
		uverbs_file->async_file = ev_file;
		kref_get(&uverbs_file->async_file->ref);

and can you prove the BUG_ON never hits?

It looks to me like a little more error unwind is necessary to
guarantee that. ie ib_uverbs_get_context uses ucontext to create that
invariant, but it sets ucontext last, so async file must be left null
if ib_uverbs_alloc_event_file fails.

Otherwise it looks OK to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
