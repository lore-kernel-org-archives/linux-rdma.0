From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V2 3/5] RDMA/core: transport-independent access flags
Date: Tue, 30 Jun 2015 13:56:37 -0500
Message-ID: <004b01d0b366$7e42fda0$7ac8f8e0$@opengridcomputing.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213618.4188.50574.stgit@build.ogc.int> <20150630162103.GA30149@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630162103.GA30149-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
> Sent: Tuesday, June 30, 2015 11:21 AM
> To: Steve Wise
> Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org;
> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
> Subject: Re: [PATCH V2 3/5] RDMA/core: transport-independent access flags
> 
> On Mon, Jun 29, 2015 at 04:36:18PM -0500, Steve Wise wrote:
> > +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs)
> > +{
> > +	int access_flags = attrs;
> 
> No RDMA_MRR_SEND ?
>

Send need no explicit access flags.  There is no LOCAL_READ access flag.
 
> > +	if (roles & RDMA_MRR_RECV)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +
> > +	if (roles & RDMA_MRR_WRITE_DEST)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
> 
> Is IB_ACCESS_LOCAL_WRITE needed?
> 

Yes.  You must have LOCAL_WRITE if you set REMOTE_WRITE.

> > +	if (roles & RDMA_MRR_READ_DEST) {
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +		if (rdma_protocol_iwarp(pd->device,
> > +					rdma_start_port(pd->device)))
> > +			access_flags |= IB_ACCESS_REMOTE_WRITE;
> > +	}
> 
> So on iWarp if I want to issue a RDMA_READ then I have to allow the
> far side uncontrolled write access to the same memory? Is there
> something else protecting it?
>

Only the fact that the rkey of your MR setup for MRR_READ_DEST doesn't have to be advertised to the peer application.  So the peer
app doesn't know what the rkey is.   But the fact is that an MR with REMOTE_WRITE access flags can be used as the destination of
RDMA reads and RDMA writes for iWARP. 

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
