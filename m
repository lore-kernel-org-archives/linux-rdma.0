From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 12 breaks libibverbs ABI
Date: Thu, 26 Jan 2017 18:04:52 -0700
Message-ID: <20170127010452.GA7826@obsidianresearch.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0E15AD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 11:53:36PM +0000, Hefty, Sean wrote:
> > > There should not be any compat - it's just going to drag down
> > > development and everyone is free to submit their provider to rdma-
> > core,
> > > same as kernel drivers.
> > 
> > Agree, I have no desire to support out-of-tree providers.
> 
> What is the plan for handling live updates to a single vendor library?
>
> Is the intent that vendors must now (potentially) provide different
> versions of their libraries, based on which libibverbs release is
> deployed by the user?

Well, this has been the case for awhile, at least for certain
providers (eg mlx5 will not link to older libibverbs).

The patch to add IBVERBS_PRIVATE_xx certainly makes it every
provider's problem..

As I see it, anyone doing an update driver distribution will have to
QA it with a certain libibverbs, so I doubt there is much point in
making it too easy for a user to mix and match too widely??

So vendors have a few basic choices:
- Ship libibverbs.rpm with the updated driver and matched libibverbs
  This is pretty easy, I probably would recommend this.
- QA the driver with the libibverbs in the various targetted distro
  releases, as you suggested
- Ship their fix to the distro and have the distro push the update

It isn't really any different from the problem a vendor would face
getting the kernel driver updated..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
