From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 13:32:09 -0500
Message-ID: <005801d0af75$3ec24d60$bc46e820$@opengridcomputing.com>
References: <20150625153754.13272.432.stgit@build.ogc.int> <20150625153922.13272.41789.stgit@build.ogc.int> <20150625182505.GA15337@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625182505.GA15337-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Thursday, June 25, 2015 1:25 PM
> To: Steve Wise
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
> 
> On Thu, Jun 25, 2015 at 10:39:23AM -0500, Steve Wise wrote:
> > +	/*
> > +	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
> > +	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
> > +	 * any port is running IWARP, add REMOTE_WRITE.
> > +	 */
> > +	if (any_port_is_iwarp(device))
> 
> It would be nice to have a new-style cap test for this instead of open
> coding iwarp. Similar to rdma_cap_read_multi_sge
> 

That would be ok with me.  Now for naming this new function:

rdma_cap_read_requires_remote_write_rights()

That's pretty long.  Any other ideas for naming this?


> I'm confused about the 'any_port_is_iwarp' stuff too, I thought if one
> port was iwarp then all ports had to be iwarp?
> 

Currently no device supports iwarp + any other protocol.

> Even if we move away from that, I would think that some caps must be
> the same on all ports, and multi_sge, remote_write, etc would fit into
> that limitation.
> 

I'm happy with making this a device-global capability.  If it becomes a per-port capability, then the code can change later. 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
