From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups
Date: Mon, 15 Apr 2013 00:58:22 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0158709F@CRSMSX102.amr.corp.intel.com>
References: <1364129012-12198-1-git-send-email-ogerlitz@mellanox.com>
	<1364129012-12198-2-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZKBns8kPH+ayzd1k--6K0NXFx=1Pez_bfSg9rQz-fvmHg@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A823736F36DCF9@ORSMSX101.amr.corp.intel.com>
 <CAJZOPZKt-R=Y_gxHidCi78u4xAB52tiT2MkQ5-5Yo7pR8po3iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKt-R=Y_gxHidCi78u4xAB52tiT2MkQ5-5Yo7pR8po3iA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Or Gerlitz
> Sent: Thursday, April 11, 2013 4:09 PM
> To: Hefty, Sean
> Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; Tzahi Oved
> Subject: Re: [PATCH V4 for-next 1/5] IB/core: Add RSS and TSS QP groups
> 
> On Thu, Apr 11, 2013 at 5:45 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> [...]
> >> but lets get there after hopefully agreeing what is RSS QP group.
> 
> > So far, this is what I think it is:
> > - a collection of related receive queues
> > - each queue is configured somewhat separately - i.e. sized, CQ, sge size,
> etc.
> > - receives are posted to the queues separately
> > - the queues are allocated together
> >
> > This is where it gets confusing.  They're allocated together, but
> > through separate API calls.
> > I'm not sure if they share states or not.  Can all of them but one go
> > into the error state > and still receive data?  Do packets get routed to
> whichever queue actually works, or do > packets sometimes get dropped,
> but sometimes don't, depending on some local rules > which have been
> programmed into the HCA?  Can the queues really be destroyed
> independently?
> 
> We only require (== implemented that) for the verbs level to mandate for
> the RSS parent not to be destroyed before ANY of the RSS childs is destroyed
> and be placed to action only after ALL RSS childs are created. The queues
> (RSS childs can be destroyed independently after the parent is destroyed,
> yes.
> 
> RSS child QPs are plain UD or RAW Packet QPs that only have consecutive
> QPNs which is common requirement of HW for configuring the RSS parent
> which in networking is called the RSS indirection or dispatching QP. You can
> send and receive on them.

How do you ensure that the QPN's are consecutive?

> 
> If an RSS child goes to the error state it will not receive data.

If you transition it back to RTS would it start working again?

Could you remove it and add a new one?  (I guess not because the new QPN would likely not be consecutive.)

> 
> Packets are routed to RSS childs only per the hash function output, not per
> the state of that child.

So if the QP chosen by the hash is in error state the packets get lost?  Above you said they would not receive data.

Ira

> 
> This design doesn't allow for an app to do DoS attack on the HW either if they
> try that out or just have a bug, but does require them to think out their code
> (design/review/test) - fair enough. RSS exists in almost any Ethernet NIC you
> take from the shelf, and works in the manner I explained here, e.g if one of
> the Ethernet RSS child queues isn't functional packets hashed to it will not be
> received
> 
> > Is it even necessary to treat the receive queues as being independent?
> What happens > if they're allocated, destroyed, and modified as a single
> entity?
> [...]
> 
> can you elaborate/explain the question a little more?
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
