From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 11/11] IB: provide better access flags for fast
	registrations
Date: Mon, 23 Nov 2015 20:44:40 +0100
Message-ID: <20151123194440.GB17760@lst.de>
References: <1448214409-7729-1-git-send-email-hch@lst.de> <1448214409-7729-12-git-send-email-hch@lst.de> <20151123185829.GE32085@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151123185829.GE32085-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 23, 2015 at 11:58:29AM -0700, Jason Gunthorpe wrote:
> > +#define IB_REG_LKEY		(ib_reg_scope_t)0x0000
> > +#define IB_REG_RKEY		(ib_reg_scope_t)0x0001
> 
> Wrap in () just for convention?

Ok.

> Maybe
> 
> unsigned int acc = ib_scope_to_access(scope);
> if ((scope & (IB_REG_RKEY | IB_REG_OP_RDMA_READ)) == (IB_REG_RKEY | IB_REG_OP_RDMA_READ))
>    acc |= IB_ACCESS_LOCAL_WRITE;
> 
> return acc;
> 
> Makes it a bit clearer what the only difference is.

I can do that.

> Is this enough to purge the cap test related to this?

I thought we didn't even have a cap check for it yet?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
