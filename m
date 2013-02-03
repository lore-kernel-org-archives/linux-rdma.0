From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 25/62] infiniband/cxgb4: convert to idr_alloc()
Date: Sun, 03 Feb 2013 08:18:37 -0600
Message-ID: <510E71BD.1010909@opengridcomputing.com>
References: <1359854463-2538-1-git-send-email-tj@kernel.org> <1359854463-2538-26-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359854463-2538-26-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, skinsbursky-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/2/2013 7:20 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Is there a git tree somewhere that I can use to test these patches out?

>   drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 27 ++++++++++++++-------------
>   1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 9c1644f..7f862da 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -260,20 +260,21 @@ static inline int _insert_handle(struct c4iw_dev *rhp, struct idr *idr,
>   				 void *handle, u32 id, int lock)
>   {
>   	int ret;
> -	int newid;
>   
> -	do {
> -		if (!idr_pre_get(idr, lock ? GFP_KERNEL : GFP_ATOMIC))
> -			return -ENOMEM;
> -		if (lock)
> -			spin_lock_irq(&rhp->lock);
> -		ret = idr_get_new_above(idr, handle, id, &newid);
> -		BUG_ON(!ret && newid != id);
> -		if (lock)
> -			spin_unlock_irq(&rhp->lock);
> -	} while (ret == -EAGAIN);
> -
> -	return ret;
> +	if (lock) {
> +		idr_preload(GFP_KERNEL);
> +		spin_lock_irq(&rhp->lock);
> +	}

The idr_preload() needs to be above the 'if (lock)', no?

> +
> +	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
> +
> +	if (lock) {
> +		spin_unlock_irq(&rhp->lock);
> +		idr_preload_end();
> +	}

And idr_preload_end() should be after the 'if (lock)' block methinks...

> +
> +	BUG_ON(ret == -ENOSPC);
> +	return ret < 0 ? ret : 0;

What would cause ret >  0?

>   }
>   
>   static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
