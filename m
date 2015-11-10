From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for rdma_read
 access flags
Date: Tue, 10 Nov 2015 11:36:27 -0700
Message-ID: <20151110183627.GJ12667@obsidianresearch.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
 <1447156270.7089.3.camel@opteya.com>
 <5641E4C9.7000206@talpey.com>
 <5641E644.7080101@mellanox.com>
 <20151110130648.GA10682@infradead.org>
 <20151110134147.GA12814@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110134147.GA12814-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 05:41:47AM -0800, Christoph Hellwig wrote:
> FYI, this is the API I'd aim for (only SRP and no HW driver converted
> yet):

>  	n = ib_map_mr_sg(desc->mr, state->sg, state->sg_nents,
> -			 dev->mr_page_size);
> +			 dev->mr_page_size,
> +			 /*
> +			  * XXX: add a bool write argument to this function,
> +			  * so that we only need to open up the required
> +			  * permissions.
> +			  */
> +			 IB_MR_REMOTE | IB_MR_RDMA_READ |
> IB_MR_RDMA_WRITE);

I would call it IB_RDMA_LKEY and IB_RDMA_RKEY. We have other places in
the API where lkey/rkey is used and it makes a lot more sense to think
about a MR as being either a lkey or rkey usable MR - since this is
effectively what we are doing here with these ops.

IB_MR_RKEY | IB_MR_RDMA_READ == The resulting key can be used
in a wr.rdma.rkey field

IB_MR_LKEY | IB_MR_SEND == The key can be used in wr.sg_list[].lkey

etc

It is an error to use a IB_MR_LKEY in a rkey field, etc..

> +enum ib_mr_flags {
> +	/* scope: either remote or local */
> +	IB_MR_REMOTE,
> +	IB_MR_LOCAL,
> +
> +	/* direction: one or both can be ORed into the scope above */
> +	IB_MR_RDMA_READ		= (1 << 10),
> +	IB_MR_RDMA_WRITE	= (1 << 11)

Don't forget SEND too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
