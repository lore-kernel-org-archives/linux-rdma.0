From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Fri, 27 Jan 2017 09:22:20 -0700
Message-ID: <20170127162220.GA31362@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
 <20170127010452.GA7826@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0E1609@ORSMSX109.amr.corp.intel.com>
 <41e74ed7-fd8d-89cf-2c79-b99a8d786fac@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <41e74ed7-fd8d-89cf-2c79-b99a8d786fac-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 27, 2017 at 09:32:51AM -0500, Doug Ledford wrote:
> On 1/26/2017 8:17 PM, Hefty, Sean wrote:
> >> - Ship libibverbs.rpm with the updated driver and matched libibverbs
> >>   This is pretty easy, I probably would recommend this.
> > 
> > This has issues if there are multiple providers present.  Maybe
> > that doesn't happen in non-testing environments.  I wonder if the
> > distros would agree with this approach.
> 
> I don't know how much I would rely on the belief that mixed environments
> don't happen outside of testing.

Yes, I've heard many complaints in production in this area.

As it stands today the changes to libibverbs in vendor trees are too
extensive, the only way to resolve them is to merge the vendors
patches into one source tree and build a custom release. I think
rdma-core will make that much simpler.

Making the ABI private or public doesn't really help things either
way, as far as I can tell. Remember the stable ABI is upstream, not
in a vendor tree, so don't expect a random vendor libibverbs to work
with any other providers, even today! They might link, but based on
what I've seen they will be subtly broken.

Ideally vendors will get their stuff upstream and a site could choose
to just use upstream rdma-core instead of a vendor tree.

I would still suggest vendors shipping libibverbs.rpm as their update
is and reasonable and easy approach for their simple users.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
