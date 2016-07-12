From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 3/8] RDMA/core: Refactor IDR to be per-device
Date: Tue, 12 Jul 2016 13:29:33 -0600
Message-ID: <20160712192933.GD8206@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-4-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467293971-25688-4-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 04:39:26PM +0300, Matan Barak wrote:
>  
> +static int ib_device_allocate_idrs(struct ib_device *device)
> +{
> +	spin_lock_init(&device->idr_lock);
> +	idr_init(&device->idr);
> +	return 0;
> +}
> +

> +	ret = ib_device_allocate_idrs(device);
> +	if (ret) {
> +		pr_warn("Couldn't allocate IDRs device %s with driver model\n",
> +			device->name);
> +		ib_cache_cleanup_one(device);
> +		goto out;

Eh? Can't happen, don't over design stuff like this. Return void from
ib_device_allocate_idrs

> +static struct ib_uobject *idr_read_uobj(int id, struct ib_ucontext *context,
> +					int nested)

What chance is there to get rid of 'nested' ? If you want to use a new
locking model, I'm wondering if we should trial it with uverbs???

> +struct ib_pd *idr_read_pd(int pd_handle, struct ib_ucontext *context)
> +{
> +	return idr_read_obj(pd_handle, context, 0);
> +}

All this stuff needs a type check. Something needs to confirm that
'pd_handle' is in fact a pd. This was being done before with the split
IDRs.

I'd also suggest that the uobj restructuring be completed a dedicated
series.

It looks like all approaches require this sort of stuff, and perhaps it could be
merged??

I didn't look at the locking in any of this stuff, maybe once you finish
it up.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
