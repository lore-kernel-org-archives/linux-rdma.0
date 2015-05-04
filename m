From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Mon, 4 May 2015 15:07:41 -0600
Message-ID: <20150504210741.GA20839@obsidianresearch.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
 <1430750492.2407.9.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
 <1430761111.2407.85.camel@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FCA2F1@ORSMSX109.amr.corp.intel.com>
 <1430768425.2407.143.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430768425.2407.143.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 04, 2015 at 03:40:25PM -0400, Doug Ledford wrote:

> So if we were to actually be forward thinking about this, then the
> link layer is the important bit you need to capture on a per port
> basis, not the transport technology.  We would have to modify lots
> of the stack to support per QP or per AH transport settings though.

We are going to have to do this, at least in the kernel side, the idea
that the port can imply the one and only address family of the QP is
certainly antiquated now. I think the roceev2 patches will require
this work.

As far as this patch series goes, I actually don't think the bits
matter one bit - the intent is to optimize the cap tests, so a one
cap test-one-bit method is fine. Don't add extra we don't need right
now.

As an optimization, be aware of some of the restrictions, it is
actually pretty expensive on some arch's to load large 32 or 64 bit
numbers, smaller numbers are better, single bit test is better.

If this is combined with my thought to use a #define for all the
common driver cases then we can trivially rework the bit-field to
future needs. No reason to over architect something here.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
