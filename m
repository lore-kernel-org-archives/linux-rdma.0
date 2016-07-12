From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Tue, 12 Jul 2016 13:23:45 -0600
Message-ID: <20160712192345.GC8206@obsidianresearch.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
 <1467293971-25688-5-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1467293971-25688-5-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 30, 2016 at 04:39:27PM +0300, Matan Barak wrote:
> From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The new ioctl infrastructure supports driver specific types.
> This is implemented by having a list of uverbs_uobject_type in the
> ib_device. Each element of this list corresponds to a specific type
> and specifies its free function, driver's type_id, etc.
> The order of elements dictates the order of process release.
> The whole type_list should be initialized before any ucontext was
> created.

Do we need to have a linked list? Can we use static const arrays like
so much other stuff in the kernel?


> +int ib_uverbs_uobject_type_add(struct list_head	*head,
> +			       void (*free)(struct uverbs_uobject_type *uobject_type,
> +					    struct ib_uobject *uobject,
> +					    struct ib_ucontext *ucontext),

Don't pass function pointers like this, create a proper 'ops' kind of
structure.

Why is this taking a list_head not a ib_device?

> +void ib_uverbs_uobject_type_remove(struct uverbs_uobject_type
> *uobject_type)

Why would a driver ever have to remove a type?

> +{
> +	/*
> +	 * Allocate a new object type for the vendor, this should be done when a
> +	 * vendor is initialized.

Please stop using the word 'vendor' and scrub it from your patches.

This is 'driver specific'

> +	/* List of object under uverbs_object_type */
> +	struct list_head	idr_list;
> +	struct uverbs_uobject_list *type;	/* ptr to ucontext type */
>  };

I'm unclear why we need a list in the driver and list in the
ucontext.. I would have thought they are almost the same.

What use is tracking the ubojects in a per-type list? Do we ever
iterate that way other than on global destruct?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
