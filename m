From: Kelly Burkhart <kelly.burkhart-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma_cm UD sendto without connect
Date: Thu, 3 Nov 2011 14:41:26 -0500
Message-ID: <CAND8VyCFZxQeeVz8AUacQAzJkqGcSpYBPbmiaPA+ZQOp1iiVGQ@mail.gmail.com>
References: <CAND8VyAYHTg3T2rMmPPMMjXbkN4dZJSDukXhQZFJnVYT2fW+1Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237316E8CD1B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E8CD1B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 3, 2011 at 10:44 AM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wro=
te:
>> Is it possible to send/recv datagrams with no previous connection
>> similar to UDP sendto/recvfrom? =A0UD examples I've seen are connect=
ion
>> oriented and listen/connect/accept, establishing a connection prior =
to
>> conversing.
>
> To send a datagram, you need the QP number, qkey, and addressing info=
rmation of the remote side. =A0The UD examples that use listen/connect =
are still connectionless, but require the use of those calls mainly to =
resolve the remote QP number.
>
> We may be able to add a sendto operation to the rdma_cm, but it would=
 need to resolve the QPN and ibv_ah under the API for the first send to=
 each destination.
>
>> It appears that in order to do what I want, I need an ibv_ah to put =
in
>> the send wr. =A0But how do I create one of these from an IP address/=
port
>> without doing an rdma_connect and waiting for
>> RDMA_CM_EVENT_ESTABLISHED?
>
> You still need to convert the IP address into an RDMA address (i.e. L=
ID) and discover the QPN.

Are there calls in rdma_cm that allow me to do this?  For the life of
me I can't figure out how, for instance, I would write an app that has
a single QP that recieves UD datagrams from anyone.  How do potential
clients find the QP number, qkey and ah without using listen/accept
which will create a brand new QP every time?

-K
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
