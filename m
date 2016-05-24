From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Tue, 24 May 2016 16:07:20 -0600
Message-ID: <20160524220720.GF7950@obsidianresearch.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-9-git-send-email-leonro@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464100526-31730-9-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 05:35:26PM +0300, Leon Romanovsky wrote:

> +	ucontext->device = ib_dev;
> +	INIT_LIST_HEAD(&ucontext->pd_list);
> +	INIT_LIST_HEAD(&ucontext->mr_list);
> +	INIT_LIST_HEAD(&ucontext->mw_list);
> +	INIT_LIST_HEAD(&ucontext->cq_list);
> +	INIT_LIST_HEAD(&ucontext->qp_list);
> +	INIT_LIST_HEAD(&ucontext->srq_list);
> +	INIT_LIST_HEAD(&ucontext->ah_list);
> +	INIT_LIST_HEAD(&ucontext->xrcd_list);
> +	INIT_LIST_HEAD(&ucontext->rule_list);
[..]

Please don't cut and paste like this.

Considering your approach I'd suggest just go ahead and immediately
implement a compat wrapper for each replaced write() style call.

eg replace ib_uverbs_get_context with something that forms a
new-style-command and calls the netlink version directly.

This also then serves as the example on how to implement the user
space migration.

> +		nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_VENDOR,
> +					sizeof(vendor_len), &vendor_len);

Please don't use the word 'vendor' in any of this.

There is only common and driver-specific.

Maybe call this IBNL_RESPONSE_DRIVER_UDATA

> +	nla = ib_uverbs_nla_put(uresp, IBNL_RESPONSE_TYPE_RESP,
> +				sizeof(resp), &resp);

And this IBNL_RESPONSE_COMMON ?

> diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
> index f5dc276..10c2412 100644
> +++ b/drivers/infiniband/core/uverbs_main.c

> +static const struct nla_policy ibnl_create_device_policy[] = {

Why isn't this stuff in a _nl file?

> +enum ibnl_create_device {
> +	IBNL_CREATE_DEVICE_CORE = IBNL_VENDOR_ATTRS_MAX,
> +	IBNL_CREATE_DEVICE_MAX
> +};

Whats all this about? Looks very strange.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
