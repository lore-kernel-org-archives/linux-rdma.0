From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V5 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Wed, 24 Jun 2015 11:57:38 -0600
Message-ID: <20150624175738.GC21033@obsidianresearch.com>
References: <1434984438-21733-1-git-send-email-yishaih@mellanox.com>
 <1434984438-21733-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434984438-21733-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 22, 2015 at 05:47:14PM +0300, Yishai Hadas wrote:
>  	fd_install(resp.async_fd, filp);
> @@ -386,6 +376,7 @@ ssize_t ib_uverbs_get_context(struct ib_uverbs_file *file,
>  	return in_len;
>  
>  err_file:
> +	ib_uverbs_free_async_event_file(file);
>  	fput(filp);

This looks really weird. 

> +void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
> +{
> +	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
> +	file->async_file = NULL;
> +}

So that put is supposed to pair with this get?

> +		uverbs_file->async_file = ev_file;
> +		kref_get(&uverbs_file->async_file->ref);

[..]

> +	fput(filp);
> +	uverbs_file->async_file = NULL;

But isn't it null?

Again again, WTF? async_file is a kref'd thing, if you copy or assign
to it you need to manipulate the kref, so the null assign should be
dropping the ref.

Whis looks good enough to remove ib_uverbs_free_async_event_file, if
the flip is created OK then the uverbs_file->async file can remain set
until the uverbs file is closed.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
