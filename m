From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 10:21:03 -0600
Message-ID: <20150630162103.GA30149@obsidianresearch.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
 <20150629213618.4188.50574.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150629213618.4188.50574.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 29, 2015 at 04:36:18PM -0500, Steve Wise wrote:
> +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs)
> +{
> +	int access_flags = attrs;

No RDMA_MRR_SEND ?

> +	if (roles & RDMA_MRR_RECV)
> +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> +
> +	if (roles & RDMA_MRR_WRITE_DEST)
> +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;

Is IB_ACCESS_LOCAL_WRITE needed?

> +	if (roles & RDMA_MRR_READ_DEST) {
> +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> +		if (rdma_protocol_iwarp(pd->device,
> +					rdma_start_port(pd->device)))
> +			access_flags |= IB_ACCESS_REMOTE_WRITE;
> +	}

So on iWarp if I want to issue a RDMA_READ then I have to allow the
far side uncontrolled write access to the same memory? Is there
something else protecting it?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
