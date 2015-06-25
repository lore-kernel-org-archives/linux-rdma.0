From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Thu, 25 Jun 2015 15:39:44 -0600
Message-ID: <20150625213944.GA27780@obsidianresearch.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150625212917.14869.66238.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 04:29:17PM -0500, Steve Wise wrote:

> - * ib_dma_mapping_error - check a DMA addr for error
> + * rdma_mr_roles - possible roles a MR will be used for
> + *
> + * This allows a transport independent RDMA application to
> + * create MRs that are usable for all the desired roles w/o
> + * having to understand which access rights are needed.
> + */
> +enum rdma_mr_roles {
> +	RDMA_MRR_RECV			= 1,
> +	RDMA_MRR_SEND			= (1<<1),
> +	RDMA_MRR_READ_SOURCE		= (1<<2),
> +	RDMA_MRR_READ_SINK		= (1<<3),
> +	RDMA_MRR_WRITE_SOURCE		= (1<<4),
> +	RDMA_MRR_WRITE_SINK		= (1<<5),
> +	RDMA_MRR_ATOMIC			= (1<<6),
> +	RDMA_MRR_MW_BIND		= (1<<7),
> +	RDMA_MRR_ZERO_BASED		= (1<<8),
> +	RDMA_MRR_ACCESS_ON_DEMAND	= (1<<9),

So we don't have this problem again, it would be best to explicitly
list exactly which ib_wc_opcode members what use a RKEY are matched to
which MMR flags

RDMA_MRR_RECV
  LOCAL: post to receive work queue
RDMA_MRR_READ_SOURCE
  LOCAL: post IB_WC_RDMA_READ to send work queue
RDMA_MRR_READ_SINK
  REMOTE: respond to IB_WC_RDMA_READ
[..]

Seems reasonable to me otherwise

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
