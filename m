From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Mon, 5 Aug 2013 16:43:55 -0600
Message-ID: <20130805224355.GA16946@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
 <20130716144747.GA7304@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com>
 <CAL1RGDWKmecLXsqphwdP9XG=4Y=65Z_ACSdRBhEqVQb6Q4LrUg@mail.gmail.com>
 <51E6DB11.9050906@redhat.com>
 <CAL1RGDVuuQU-NZ2o+T0_kuxPMRadGPeqzO1J9iuW=DRuFMMYfQ@mail.gmail.com>
 <20130805190238.GA14356@obsidianresearch.com>
 <CAL1RGDWPHWzAWx7XXxGGCVQQ1xHU6QDVybrttnvoqUPrzqzvWA@mail.gmail.com>
 <20130805222250.GA4486@obsidianresearch.com>
 <CAL1RGDW5V_N62LSZa1YRG1JA1fOf+nbQwBG1xQ7yYiuF6z0fMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDW5V_N62LSZa1YRG1JA1fOf+nbQwBG1xQ7yYiuF6z0fMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 05, 2013 at 03:35:22PM -0700, Roland Dreier wrote:
> On Mon, Aug 5, 2013 at 3:22 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > Okay, but if you want to narrow things to just be Jeff's application
> > like that, then do we even need this to be part of verbs?
> >
> > IP path MTU should be discovered by a netlink routing query to lookup
> > the target IP(s), the device maximum should not really be used by
> > apps..
> 
> Jeff's case is not an IP transport.  

Oh, I'm confused then..

> Also seems a bit unfriendly to make apps that just want to use verbs
> to have to figure out which netdev to ask about.

Right, but we solved that by hiding that in the RDMA CM for IB cases,
presumably other cases using IP would need a similar shim.

But.. wait, if it isn't IP, then aren't there going to be other
changes required for a new address family? Will the device struct and
QP struct survive that unchanged? eg, can we roll the MTU change with
other required changes?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
