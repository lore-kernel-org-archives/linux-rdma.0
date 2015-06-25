From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 12:25:05 -0600
Message-ID: <20150625182505.GA15337@obsidianresearch.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150625153922.13272.41789.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 25, 2015 at 10:39:23AM -0500, Steve Wise wrote:
> +	/*
> +	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
> +	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
> +	 * any port is running IWARP, add REMOTE_WRITE.
> +	 */
> +	if (any_port_is_iwarp(device))

It would be nice to have a new-style cap test for this instead of open
coding iwarp. Similar to rdma_cap_read_multi_sge

I'm confused about the 'any_port_is_iwarp' stuff too, I thought if one
port was iwarp then all ports had to be iwarp?

Even if we move away from that, I would think that some caps must be
the same on all ports, and multi_sge, remote_write, etc would fit into
that limitation.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
