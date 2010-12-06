From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: [ewg] IPoIB to Ethernet routing performance
Date: Mon, 6 Dec 2010 14:05:05 +0100
Message-ID: <20101206140505.20cfc9e2@frecb012350.frec.bull.fr>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>
	<00d701cb9533$71c5f2e0$5551d8a0$@com>
	<20101206124023.025c2f88@frecb012350.frec.bull.fr>
	<00f201cb953e$53f66a00$fbe33e00$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f201cb953e$53f66a00$fbe33e00$@com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Croucher <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'OF EWG' <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 6 Dec 2010 12:08:43 -0000
"Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org> wrote:

> Unfortunately, the 4036E only has two 10G Ethernet ports which will u=
ltimately limit the throughput.

  I'll need to look into this option.

>=20
> The Mellanox BridgeX looks a better hardware solution with 12x 10Ge p=
orts but when I tested this they could only provide vNIC functionality =
and would not commit to adding IPoIB gateway on their roadmap.

  Right, we did some evaluation on it and this was really a show stoppe=
r.

  Thanks,

  S=C3=A9bastien.

>=20
> Qlogic also offer the 12400 Gateway.  This has 6x 10ge ports.   Howev=
er, like the Mellanox, I understand they only provide host vNIC support=
=2E
>=20
> I'll leave it to representatives from Voltaire, Mellanox and Qlogic t=
o update us. Particularly on support for InfiniBand to Ethernet Gateway=
 for RoCEE.  This is needed so that RDMA sessions can be run between In=
finiBand and RoCEE connected hosts.  I don't believe this will work ove=
r any of the today's available products.
>=20
> Richard
>=20
> -----Original Message-----
> From: sebastien dugue [mailto:sebastien.dugue-6ktuUTfB/bM@public.gmane.org]=20
> Sent: 06 December 2010 11:40
> To: Richard Croucher
> Cc: 'OF EWG'; 'linux-rdma'
> Subject: Re: [ewg] IPoIB to Ethernet routing performance
>=20
> On Mon, 6 Dec 2010 10:49:58 -0000
> "Richard Croucher" <richard-jNDFPZUTrfRJpuwtbJ71GdBPR1lH4CV8@public.gmane.org> wrote:
>=20
> > You may be able to improve by doing some OS tuning.
>=20
>   Right, I tried a few things concerning the TCP/IP stack tuning but =
nothing
> really came out of it.
>=20
> >  All this data should stay in kernel mode but there are lots of bot=
tlenecks in
> > the TCP/IP stack that limit scalability.
>=20
>   That may be my problem in fact.
>=20
> >  The IPoIB code has not been optimized for this use case.
>=20
>   I don't think IPoIB to be the bottleneck. In this case as I managed=
 to feed
> 2 IPoIB streams between the client and the router yielding about 40 G=
bits/s bandwidth.
>=20
> >=20
> > You don't mention what Server, kernel and OFED distro you are runni=
ng.
>=20
>   Right, sorry. The router is one of our 4 sockets Nehalem-EX box wit=
h 2 IOHs which
> is running an OFED 1.5.2.
>=20
> >=20
> > The best performance is achieved using InfiniBand/Ethernet hardware=
 gateways.
> > Most of these provide virtual Ethernet NICs to InfiniBand hosts, bu=
t the Voltaire
> > 4036E does provide a  IPoIB to Ethernet gateway capability.  This i=
s FPGA based
> > so does provide much higher performance than you will achieve using=
 a standard server solution.
>=20
>   That may be a solution indeed. Are there any real world figures out=
 there
> concerning the 4036E performance?
>=20
>   Thanks Richard,
>=20
>   S=C3=A9bastien.
>=20
>=20
> >=20
> > -----Original Message-----
> > From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org [mailto:ewg-bounces@lists.o=
penfabrics.org] On Behalf Of sebastien dugue
> > Sent: 06 December 2010 10:25
> > To: OF EWG
> > Cc: linux-rdma
> > Subject: [ewg] IPoIB to Ethernet routing performance
> >=20
> >=20
> >   Hi,
> >=20
> >   I know this might be off topic, but somebody may have already run=
 into the same
> > problem before.
> >=20
> >   I'm trying to use a server as a router between an IB fabric and a=
n Ethernet network.
> >=20
> >   The router is fitted with one ConnectX2 QDR HCA and one dual port=
 Myricom 10G
> > Ethernet adapter.
> >=20
> >   I did some bandwidth measurements using iperf with the following =
setup:
> >=20
> >   +---------+               +---------+               +---------+
> >   |         |               |         |   10G Eth     |         |
> >   |         |    QDR IB     |         +---------------+         |
> >   | client  +---------------+  Router |   10G Eth     |  Server |
> >   |         |               |         +---------------+         |
> >   |         |               |         |               |         |
> >   +---------+               +---------+               +---------+
> >=20
> >  =20
> >   However, the routing performance is far from what I would have ex=
pected.
> >=20
> >   Here are some numbers:
> >=20
> >   - 1 IPoIB stream between client and router: 20 Gbits/sec
> >=20
> >     Looks OK.
> >=20
> >   - 2 Ethernet streams between router and server: 19.5 Gbits/sec
> >=20
> >     Looks OK.
> >=20
> >   - routing 1 IPoIB stream to 1 Ethernet stream from client to serv=
er: 9.8 Gbits/sec
> >=20
> >     We manage to saturate the Ethernet link, looks good so far.
> >=20
> >   - routing 2 IPoIB streams to 2 Ethernet streams from client to se=
rver: 9.3 Gbits/sec
> >=20
> >     Argh, even less that when routing a single stream. I would have=
 expected
> >     a bit more than this.
> >=20
> >=20
> >   Has anybody ever tried to do some routing between an IB fabric an=
d an Ethernet
> > network and achieved some sensible bandwidth figures?
> >=20
> >   Are there some known limitations in what I try to achieve?
> >=20
> >=20
> >   Thanks,
> >=20
> >   S=C3=A9bastien.
> >=20
> >=20
> >=20
> >=20
> > _______________________________________________
> > ewg mailing list
> > ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
> >=20
> > _______________________________________________
> > ewg mailing list
> > ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> > http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>=20
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
