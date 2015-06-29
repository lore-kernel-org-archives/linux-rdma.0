From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC] RDMA/core: add rdma_get_dma_mr()
Date: Mon, 29 Jun 2015 09:55:03 -0600
Message-ID: <20150629155503.GA2755@obsidianresearch.com>
References: <20150625212917.14869.66238.stgit@build.ogc.int>
 <55901703.3050001@mellanox.com>
 <003001d0b272$3367a230$9a36e690$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <003001d0b272$3367a230$9a36e690$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Haggai Eran' <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 29, 2015 at 08:47:55AM -0500, Steve Wise wrote:

> > On 26/06/2015 00:29, Steve Wise wrote:
> > > +enum rdma_mr_roles {
> > > +	RDMA_MRR_RECV			= 1,
> > > +	RDMA_MRR_SEND			= (1<<1),
> > > +	RDMA_MRR_READ_SOURCE		= (1<<2),
> > > +	RDMA_MRR_READ_SINK		= (1<<3),
> > 
> > Maybe it's just me, but it took me a second to figure out which was the
> > source and which was the sink in RDMA reads. Do you think calling them
> > initiator and responder/target would be better?
> 
> Not to me.  For an RDMA operation, the "initiator" is the app that
> issues the read request WR.  That app doesn't create what I call the
> READ_SOURCE MR.  Its peer application does.  So calling READ_SOURCE
> something like READ_INITIATOR doesn't make sense to me.  That's why
> I thought SOURCE and SINK were clearer.  Perhaps not...

I would call SOURCE the RESPONDER..

Initiator/Poster and Responder is closest to the language used in
other places in the API for READ.

> I have a new version I'll send out soon that will comment all of
> these in the enum declaration.  Perhaps that will make it clear.

I think once you have a comment with the table mapping to allowed
local/remote verbs then things will be fine with whatever names you
pick.

Honestly, the names that IBA picked were fine and descriptive too, the
only problem is that the iwarp hardware can't implement the IBA names
:(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
