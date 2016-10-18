From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: building rdma-core from travis
Date: Tue, 18 Oct 2016 10:07:16 -0600
Message-ID: <20161018160716.GB24189@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB096A91@ORSMSX109.amr.corp.intel.com>
 <20161018050834.GF25013@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161018050834.GF25013-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2016 at 08:08:34AM +0300, Leon Romanovsky wrote:
> > > I can see that travis runs successfully against rdma-core.  Was there a
> > > magic setting used to work-around the travis version?
> >
> > It looks like rdma-core requires the 'trusty' build on travis...
> 
> Yes, you are right.
> "# We need at least cmake 2.12, this means we need to use trusty."
> http://marc.info/?l=linux-rdma&m=147587977913428&w=2

Right. rdma-core does not support precise, at all. Aside from cmake,
the original source packages had some non-functional 'compat' for such
an old glibc (from 2012!) that I stripped out as well.

I can't recommend that anybody working on a c-language project should
be using the precise images on travis for anything <shrug>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
