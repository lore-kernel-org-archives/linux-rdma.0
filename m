From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/2] IB/core: Add scatter end padding flags for
 WQ and QP
Date: Wed, 25 Oct 2017 13:53:11 -0600
Message-ID: <20171025195311.GD998@obsidianresearch.com>
References: <20171017151857.11934-1-leon@kernel.org>
 <20171017151857.11934-2-leon@kernel.org>
 <1508954339.3325.45.camel@redhat.com>
 <20171025190352.GW16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171025190352.GW16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 25, 2017 at 10:03:52PM +0300, Leon Romanovsky wrote:
> On Wed, Oct 25, 2017 at 01:58:59PM -0400, Doug Ledford wrote:
> > On Tue, 2017-10-17 at 18:18 +0300, Leon Romanovsky wrote:
> > > From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > There are root complexes that are able to optimize their
> > > performance when incoming data is multiple full cache lines.
> > >
> > > Scatter end padding is the device's ability to pad the ending of
> > > incoming packets (scatter)
> >
> > I hate this naming.  I'm sure people inside of Mellanox have gotten
> > used to it, but this feature really has no bearing on scatter/gather at
> > all.  This is merely final write padding.  You might have a
> > scatter/gather list, you might have a single buffer.  Either way, the
> > PCI root complex couldn't care less about scatter/gather or not, it's
> > all a byte stream to it.  I would be much happier with a name that
> > reflected what this really does.
> 
> Scatter has more broad meaning than "scatter/gather list". The name
> here came from statistical meaning of "scatter", I'll try to come into
> something more descriptive.

I don't like it either.. We usually call this 'alignment padding' in CS.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
