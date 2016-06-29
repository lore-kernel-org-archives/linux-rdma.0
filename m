From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Wed, 29 Jun 2016 12:30:42 -0600
Message-ID: <20160629183042.GC17031@obsidianresearch.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
 <20160627181758.GD23540@obsidianresearch.com>
 <20160628050246.GB3584@leon.nu>
 <20160628162028.GA27518@obsidianresearch.com>
 <20160628170549.GE3584@leon.nu>
 <022001d1d170$fda2c3e0$f8e84ba0$@opengridcomputing.com>
 <20160628211441.GA5786@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0663DA@ORSMSX109.amr.corp.intel.com>
 <20160629051956.GG3584@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160629051956.GG3584-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 29, 2016 at 08:19:56AM +0300, Leon Romanovsky wrote:
> On Tue, Jun 28, 2016 at 09:26:38PM +0000, Hefty, Sean wrote:
> > > The fundamental question is if it is acceptable for libibverbs to ship
> > > a new core provider agnostic API (cq polling) that is optional
> > > depending on provider.
> > > 
> > > I say no, that is not acceptable.
> > 
> > I agree - there's no compelling argument that the new calls can't work over all providers.
> 
> I agree too, this is why code is provided and nothing stops from other provider to support it.

That isn't what I said, and it isn't what everyone is agreeing with.

I said an optinal API is not acceptable to ship.

That means 'nothing stops' is not enough - the patch author and
maintainer have the responsibility to ensure all providers work with
the API before shipping it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
