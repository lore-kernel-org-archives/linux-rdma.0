From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 11/11] IB: provide better access flags for fast
 registrations
Date: Mon, 23 Nov 2015 11:58:29 -0700
Message-ID: <20151123185829.GE32085@obsidianresearch.com>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-12-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448214409-7729-12-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 06:46:49PM +0100, Christoph Hellwig wrote:
> Instead of the confusing IB spec values provide a flags argument that
> describes:
> 
>   a) the operation we perform the memory registration for, and
>   b) if we want to access it for read or write purposes.
> 
> This helps to abstract out the IB vs iWarp differences as well.

This is so much better, thanks

> +#define IB_REG_LKEY		(ib_reg_scope_t)0x0000
> +#define IB_REG_RKEY		(ib_reg_scope_t)0x0001

Wrap in () just for convention?

> +static inline int ib_scope_to_access(ib_reg_scope_t scope)
> +{
> +	unsigned int acc = 0;
> +
> +	if (scope & IB_REG_RKEY) {
> +		WARN_ON(scope & IB_REG_OP_SEND);
> +
> +		if (scope & IB_REG_OP_RDMA_READ)
> +			acc |= IB_ACCESS_REMOTE_READ;
> +		if (scope & IB_REG_OP_RDMA_WRITE)
> +			acc |= IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE;
> +	} else {
> +		if (scope & IB_REG_OP_RDMA_READ)
> +			acc |= IB_ACCESS_LOCAL_WRITE;

> +	}
> +
> +	return acc;
> +}
> +
> +static inline int iwarp_scope_to_access(ib_reg_scope_t scope)
> +{

Maybe

unsigned int acc = ib_scope_to_access(scope);
if ((scope & (IB_REG_RKEY | IB_REG_OP_RDMA_READ)) == (IB_REG_RKEY | IB_REG_OP_RDMA_READ))
   acc |= IB_ACCESS_LOCAL_WRITE;

return acc;

Makes it a bit clearer what the only difference is.

Is this enough to purge the cap test related to this?

Jaason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
