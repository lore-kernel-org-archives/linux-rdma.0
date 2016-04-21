From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ANNOUNCE] Shared Topic Branch For ABI Changes
Date: Thu, 21 Apr 2016 14:01:02 -0600
Message-ID: <20160421200102.GB6258@obsidianresearch.com>
References: <20160420055221.GT6349@leon.nu>
 <20160420152924.GA25424@obsidianresearch.com>
 <20160421065847.GC12730@leon.nu>
 <20160421173815.GB5102@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB04435E@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB04435E-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 21, 2016 at 06:17:18PM +0000, Hefty, Sean wrote:
> > Doug was ambivalent, Steve was against. There was a concern the natual
> > release schedual of the parts was different, so why link them.
> > 
> > My counter was that isn't really important, the goal is is to reduce
> > developer time when working on this mess.
> > 
> > Since we are looking at changing *everything* developer time seems
> > more important right now.
> 
> FWIW, I moved the librdmacm and libibacm into a single guthub
> project.  Even if we don't share a single git tree, this enables
> multiple maintainers for the code.  I would really like to see
> libibcm dropped entirely, and think libibverbs and librdmacm should
> merge.

+1

> In the past I would have been in favor of more closely associating
> libibumad with libibverbs, but now that OPA uses IB-like management,
> I'm not so sure.  I think OPA management could be done outside of
> any verbs emulation.  Ira might know for sure.

IIRC OPA still uses /dev/umad. I suspect libmad/umad needs to grow new
structures and constants primarily.

I would call the combined repo 'rdma-plumbing' or something, intended
to cover the user space side for all the kernel interfaces.

I saw libfabric was having success with this model - is that accurate?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
