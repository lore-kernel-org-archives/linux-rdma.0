From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm-1.0.16
Date: Mon, 13 Aug 2012 18:19:38 +0000
Message-ID: <0000013921366b36-04885b8b-c34b-4c9c-99ab-f2719d29b40d-000000@email.amazonses.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A61E63@ORSMSX101.amr.corp.intel.com> <CAOzFzEgkqKYcP99sGC+SP-pgS2abt1wA9dtJ7x9O99kzO31xtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEgkqKYcP99sGC+SP-pgS2abt1wA9dtJ7x9O99kzO31xtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 13 Aug 2012, Joseph Glanville wrote:

> Hi Sean,
>
> On 14 July 2012 03:57, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > librdmacm release 1.0.16 is now available from
> >
> > www.openfabrics.org/downloads/rdmacm
> >
> > This release contains several bug fixes from 1.0.15, plus introduces the rsocket API and protocol.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Are there any plans to include SOCK_DGRAM support?

I am a bit confused here. Is this the librdmacm the RDMA connection
manager? If so then it already supports datagrams and multicast.

> I could see that being potentionally interesting along with mapping
> broadcast/multicast to IB physical layer multicast.

Such as implemented in IPoIB? Any ideas that would be better than that?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
