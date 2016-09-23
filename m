From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core] Improve global COPYING files
Date: Fri, 23 Sep 2016 17:23:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB08E66F@ORSMSX109.amr.corp.intel.com>
References: <20160923041340.GA11269@obsidianresearch.com>
 <20160923080655.GM4088@leon.nu>
 <20160923152412.GB11269@obsidianresearch.com> <20160923171003.GR4088@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160923171003.GR4088-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > As you know I've sent emails to various parties on licensing issues,
> > as those issues are corrected we can update the tree and the copying
> > summary.
> >
> > We've already had success correcting one mistake from Intel and
> > Chelsio, thank you very much to those companies.
> >
> > It is important we clearly document the current situation so our
> > downstreams can properly distribute this code.
> 
> I sure that this question will sound dumb for you, but can we unify all
> code under OFA's licenses (dual-license)? I don't feel comfortable with
> this multi-license situation.

If this combined repo is intended to support the plumbing for the linux-rdma subsystem, then I think it must support code that is submitted under GPL only.  Much of the tradition code can remain dual-license, but new provider code, for example, should be submit-able under GPL.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
