From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:26:08 -0600
Message-ID: <20150720222608.GA12005@obsidianresearch.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net>
 <20150720190311.10997.12636.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150720190311.10997.12636.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 20, 2015 at 03:03:11PM -0400, Chuck Lever wrote:
> +	iov->length = size;
> +	iov->lkey = ia->ri_have_dma_lkey ?
> +				ia->ri_dma_lkey : ia->ri_bind_mem->lkey;
> +	rb->rg_size = size;
> +	rb->rg_owner = NULL;
>  	return rb;

There is something odd looking about this..

ri_bind_mem is only setup in the RPCRDMA_ALLPHYSICAL and
RPCRDMA_MTHCAFMR cases.

RPCRDMA_FRMR doesn't set it up.

So this code in rpcrdma_alloc_regbuf is never called for the FRMR
case?

If yes, then, how is FRMR working? There is absolutely no reason to
use FRMR to register local send buffers, just use the global all
memory lkey...

If no, then that is an oops?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
