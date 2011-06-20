From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: [PATCH 14/14] SIWv2: Documentation: siw.txt
Date: Mon, 20 Jun 2011 17:49:49 +0200
Message-ID: <OFF76DD4EB.A145AB51-ONC12578B5.00568A28-C12578B5.0056F5A9@ch.ibm.com>
References: <BANLkTimggAAHtOrrUdh_1WLRztUgk-wJbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimggAAHtOrrUdh_1WLRztUgk-wJbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote on 06/18/2011 07:56:24 PM:

> On Thu, Jun 16, 2011 at 2:42 PM, Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
wrote:
> > ---
> > =A0Documentation/networking/siw.txt | =A0156
> ++++++++++++++++++++++++++++++++++++++
> > =A01 files changed, 156 insertions(+), 0 deletions(-)
> > =A0create mode 100644 Documentation/networking/siw.txt
> >
> > diff --git a/Documentation/networking/siw.txt
> b/Documentation/networking/siw.txt
> > new file mode 100644
> > index 0000000..805e21b
> > --- /dev/null
> > +++ b/Documentation/networking/siw.txt
> > @@ -0,0 +1,156 @@
> > +SoftiWARP: Software iWARP kernel driver module.
> > +
> > +General
> > +-------
> > +SoftiWARP (siw) implements the iWARP protocol suite (MPA/DDP/RDMAP=
,
> > +IETF-RFC 5044/5041/5040) completely in software as a Linux kernel
module.
> > +siw runs on top of TCP kernel sockets and exports the Linux kernel
ibverbs
> > +RDMA interface. siw interfaces with the iwcm connection manager.
> > +
> > +
> > +Transmit Path
> > +-------------
> > +If a send queue (SQ) work queue element gets posted, siw tries to =
send
> > +it directly out of the application context. If the SQ was non-empt=
y,
> > +SQ processing is done asynchronously by a kernel worker thread. Th=
is
> > +thread gets scheduled if the TCP socket signals new write space to
> > +be available. If during send operation the socket send space becom=
es
> > +exhausted, SQ processing is abandoned until new socket write space
> > +becomes available.
>
> It seems like some information is missing in the above:
> - That the siw kernel module creates an iWARP device for each Etherne=
t
> interface found but not for other network interfaces that support the
> family of IP protocols.
thats correct. thanks.

> - Whether or not such an iWARP device is created for Ethernet
> interfaces instantiated after the siw kernel module has been loaded.
Right. And ... I should probably go for a more dynamic device managemen=
t,
which allows to attach to interfaces instantiated later.

Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
