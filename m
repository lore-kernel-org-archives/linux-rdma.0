From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Fri, 10 Apr 2015 10:14:01 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504101011300.30374@gentwo.org>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com> <alpine.DEB.2.11.1504090955080.19714@gentwo.org> <5526c0f8.2116430a.28f7.ffffd059SMTPIN_ADDED_BROKEN@mx.google.com> <alpine.DEB.2.11.1504091329180.24028@gentwo.org>
 <5526e18b.a50c450a.4b9f.77beSMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5526e18b.a50c450a.4b9f.77beSMTPIN_ADDED_BROKEN-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Caitlin Bestler <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Cc: Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 9 Apr 2015, Caitlin Bestler wrote:

> > Infiniband is lossless and thus what "unreliable" means is also quite
> > foggy.
>
> InfiniBand is not lossless. It does a superb job of avoiding drops caused
> by congestion. But applications should not assume that all UD messages
> have been received, but should add their own checking. That is why the
> U stands for Unreliable.

Well applications can screw up yes but the fabric *IS* lossless.

> > > You are probably better off using RDMA ideas over UDP/UD, and doing the
> > > direct memory placement from your own code, instead.
> >
> > So send the memory transfer info via multicast datagram to the
> > endpoints and then run the transfer from the endpoint.
>
> Yes, possibly in a kermel module.

Why? You can simply do this already from userspace with verbs messaging
and RDMA tranfers.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
