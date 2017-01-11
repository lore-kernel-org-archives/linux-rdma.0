From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/7] IB/core: Refactor IDR to be per-device
Date: Wed, 11 Jan 2017 15:39:17 -0700
Message-ID: <20170111223917.GA31682@obsidianresearch.com>
References: <1484132033-3346-1-git-send-email-matanb@mellanox.com>
 <1484132033-3346-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1484132033-3346-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2017 at 12:53:47PM +0200, Matan Barak wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The current code creates an IDR per type. Since types are currently
> common for all vendors and known in advance, this was good enough.
> However, the proposed ioctl based infrastructure allows each vendor
> to declare only some of the common types and declare its own specific
> types.
> 
> Thus, we decided to implement IDR to be per device and refactor it to
> use a new file.

I'm still unclear why we want the idr to be global and not per
/dev/uverbs0 open fd.

__idr_get_uobj forces a strong association:

                if (uobj->context == context)

Why on earth should we have a shared IDR when the objects cannot
actually be shared?

Surely that just wastes memory and harms performance.

I know we have talked about this before, but I think there should be a
strong reason why we don't move this into struct ib_ucontext in this
patch.

> +static void ib_device_allocate_idrs(struct ib_device *device)
> +{
> +	spin_lock_init(&device->idr_lock);
> +	idr_init(&device->idr);
> +}
> +
> +static void ib_device_destroy_idrs(struct ib_device *device)
> +{
> +	idr_destroy(&device->idr);
> +}

Not sure why we need these wrappers..

> @@ -230,24 +228,24 @@ static void put_cq_read(struct ib_cq *cq)
>  	put_uobj_read(cq->uobject);
>  }
>  
> -static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
> +static void put_ah_read(struct ib_ah *ah)
>  {
> -	return idr_read_obj(&ib_uverbs_ah_idr, ah_handle, context, 0);
> +	put_uobj_read(ah->uobject);
>  }
>  
> -static void put_ah_read(struct ib_ah *ah)
> +static struct ib_ah *idr_read_ah(int ah_handle, struct ib_ucontext *context)
>  {
> -	put_uobj_read(ah->uobject);
> +	return idr_read_obj(ah_handle, context, 0);
>  }

These two functions got reordered, makes the diff ugly.

> +	struct idr		idr;
> +	/* Global lock in use to safely release device IDR */
> +	spinlock_t		idr_lock;

That comment doesn't make sense, has nothing to do with
release... 'spinlock protects idr'

Otherwise this patch looks fine to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
