From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 1/5] IB/uverbs: Fix reference counting usage
 of event files
Date: Tue, 30 Jun 2015 11:04:42 -0600
Message-ID: <20150630170442.GA2819@obsidianresearch.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <1435659967-27173-2-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1435659967-27173-2-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 30, 2015 at 01:26:03PM +0300, Yishai Hadas wrote:

> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reviewed-By: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

>  err_file:
> +	ib_uverbs_free_async_event_file(file);
>  	fput(filp);

> +void ib_uverbs_free_async_event_file(struct ib_uverbs_file *file)
> +{
> +	kref_put(&file->async_file->ref, ib_uverbs_release_event_file);
> +	file->async_file = NULL;
> +}

Mm, I figured out why that looks so wonky - there is no locking on the
async_file assign. Other cases were relying on
ib_register_event_handler not succeeding for locking, this doesn't
have that luxury. The async_file usage looks really weird overall,
there may be something strange there. But - that seems like a job for
another day..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
