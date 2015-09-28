From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Expire sendonly joins (was Re: [PATCH rdma-rc 0/2] Add
 mechanism for ipoib neigh state change notifications)
Date: Mon, 28 Sep 2015 10:51:53 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1509281046440.30710@east.gentwo.org>
References: <1442486283-9699-1-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.11.1509170940270.2052@east.gentwo.org> <CAJ3xEMg-h+J=cr2ddWvYUGU=MOBk4Aw-KtkeJutATH0Y17dnjg@mail.gmail.com> <alpine.DEB.2.20.1509241158420.21198@east.gentwo.org>
 <CAJ3xEMg2qQ3CXrfTrg=gUX2tQRuPnpxA-8PC98GzoF5iz=j5PQ@mail.gmail.com> <alpine.DEB.2.20.1509251140200.31792@east.gentwo.org> <CAJ3xEMj9kGaM6s+AqBQ_-ZTB_+cgDk3kefhq_O0V3PM120O9yQ@mail.gmail.com> <alpine.DEB.2.20.1509271136570.14486@east.gentwo.org>
 <5608282F.1020507@redhat.com> <alpine.DEB.2.20.1509272120090.18678@east.gentwo.org> <56095E6B.60509@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56095E6B.60509-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 28 Sep 2015, Doug Ledford wrote:

> > We would like to keep
> > irrelevant traffic off the fabric as much as possible. An a reception
> > event that requires traffic to be thrown out will cause jitter in the
> > processing of inbound traffic that we also would like to avoid.
>
> That may not be optimal for your app, but we also need to try and
> maintain proper emulation of typical IP/Ethernet behavior since this is
> IPoIB after all.  That's why the app isn't required to join the group
> before sending, and also why it should be able to expect that we will
> fall back to sending via broadcast if needed.

Ok this needs to work with the existing ethernet gateways and verified to
work with them.

> However, the following algorithm might be suitable here:
>
> On first packet:
>   create mcast group
>   queue packet to group
>   schedule join
>
> On subsequent packets:
>   find mcast group
>   check mcast state
>     if already joined, send immediately
>     if joining, queue packet to mcast queue
>     if join is deferred, send via bcast

Hmmm... If the multicast group does not exist in the SM then we could only
bcast to all routers instead? No host in the fabric could then be
listening the only listeners possible are outside the fabric.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
