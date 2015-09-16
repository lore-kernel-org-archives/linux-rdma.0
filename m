From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.3] IB/ipoib: add module option for auto-creating
 mcast groups
Date: Wed, 16 Sep 2015 15:17:24 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509161517110.24175@east.gentwo.org>
References: <980e8b0a82042d7e5801e02bf16fe72a0bde6759.1441934465.git.dledford@redhat.com> <alpine.DEB.2.11.1509110920540.16357@east.gentwo.org> <20150911182115.GA546@obsidianresearch.com> <55F32E7A.3020105@redhat.com> <alpine.DEB.2.11.1509141200020.4192@east.gentwo.org>
 <55F86255.9080508@redhat.com> <20150915191159.GB24173@obsidianresearch.com> <55F988F1.8000508@redhat.com> <alpine.DEB.2.11.1509161058540.22035@east.gentwo.org> <55F9981F.5010605@redhat.com> <alpine.DEB.2.11.1509161129080.22736@east.gentwo.org>
 <CAJ3xEMi2SEXWmmLmm2xb_X_BZJY2L3UM1UfsXjFaupHBbi=q8g@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi2SEXWmmLmm2xb_X_BZJY2L3UM1UfsXjFaupHBbi=q8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 16 Sep 2015, Or Gerlitz wrote:

> On Wed, Sep 16, 2015 at 7:31 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> > Another approach may be to tie the unsub from sendonly multicast joins to
> > the expiration of the layer 2 addresses in IPoIB. F.e. add code to
> >  __ipoib_reap_ah() to detect if the handle was used for a sendonly
> > multicast join. If so unsubscribe from the MC group. This will result in
> > behavior consistent with address resolution and caching on IPoIB.
>
> yep, Erez has the patches to do so.

Would you please share them?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
