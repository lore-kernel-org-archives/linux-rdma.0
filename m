From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Mon, 29 Jun 2015 08:47:55 -0500
Message-ID: <003001d0b272$3367a230$9a36e690$@opengridcomputing.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int> <55901703.3050001@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55901703.3050001-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Haggai Eran' <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Haggai Eran
> Sent: Sunday, June 28, 2015 10:47 AM
> To: Steve Wise; jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
> Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
> 
> On 26/06/2015 00:29, Steve Wise wrote:
> > +enum rdma_mr_roles {
> > +	RDMA_MRR_RECV			= 1,
> > +	RDMA_MRR_SEND			= (1<<1),
> > +	RDMA_MRR_READ_SOURCE		= (1<<2),
> > +	RDMA_MRR_READ_SINK		= (1<<3),
> 
> Maybe it's just me, but it took me a second to figure out which was the
> source and which was the sink in RDMA reads. Do you think calling them
> initiator and responder/target would be better?

Not to me.  For an RDMA operation, the "initiator" is the app that issues the read request WR.  That app doesn't create what I call the READ_SOURCE MR.  Its peer application does.  So calling READ_SOURCE something like READ_INITIATOR doesn't make sense to me.   That's why I thought SOURCE and SINK were clearer.  Perhaps not...

I have a new version I'll send out soon that will comment all of these in the enum declaration.  Perhaps that will make it clear.


> 
> > +	RDMA_MRR_WRITE_SOURCE		= (1<<4),
> > +	RDMA_MRR_WRITE_SINK		= (1<<5),
> > +	RDMA_MRR_ATOMIC			= (1<<6),
> > +	RDMA_MRR_MW_BIND		= (1<<7),
> > +	RDMA_MRR_ZERO_BASED		= (1<<8),
> > +	RDMA_MRR_ACCESS_ON_DEMAND	= (1<<9),
> > +};
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
