From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core] Improve global COPYING files
Date: Fri, 23 Sep 2016 11:48:48 -0600
Message-ID: <20160923174848.GC13920@obsidianresearch.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160923080655.GM4088@leon.nu>
 <20160923152412.GB11269@obsidianresearch.com>
 <20160923171003.GR4088@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB08E66F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB08E66F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 23, 2016 at 05:23:29PM +0000, Hefty, Sean wrote:

> If this combined repo is intended to support the plumbing for the
> linux-rdma subsystem, then I think it must support code that is
> submitted under GPL only.

Hum, I don't think that follows.

My expectation in the kernel is that the entire RDMA subystem and
drivers follows the overall licensing model of the kernel and does not
require userspace to follow any specific license, and certainly does
not require userspace to follow the GPLv2.

> Much of the tradition code can remain dual-license, but new provider
> code, for example, should be submit-able under GPL.

I do not support that recommendation.

The FSF has made very clear their position on GPL licensing of plugins
(see https://www.gnu.org/licenses/gpl-faq.en.html), and allowing a
GPLv2 only plugin or library code would break our community's promise
to our customers - that the library core is usable in any application.

It would be a complicated discussion if someone proposed a GPLv2 only
provider.

A LGPLv2-only provider would be more acceptable, and I would encourage
anyone who wishes to have the protections of the GPLv2 in their
provider to go that route. I suspect it would still be controversial.

I would prefer to see us continue with the dual license approach, and
obviously all OFA member companies have agreed to do that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
