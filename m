From: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Subject: Re: QoS settings not mapped correctly per pkey ?
Date: Thu, 3 Dec 2009 10:08:07 +0100
Message-ID: <20091203100807.37f259b2@frecb007965>
References: <4B0D0DB2.6080802@bull.net>
	<4B0D1F36.1090007@dev.mellanox.co.il>
	<4B0D38C7.3080505@bull.net>
	<4B0D410E.2010903@dev.mellanox.co.il>
	<4B0D49F0.6060400@bull.net>
	<4B0D5110.70606@dev.mellanox.co.il>
	<4B0E34EB.6020403@bull.net>
	<4B0E3B63.40705@dev.mellanox.co.il>
	<4B0E4105.5080107@bull.net>
	<4B0E50D6.8020401@dev.mellanox.co.il>
	<4B177058.9070909@dev.mellanox.co.il>
	<20091203091758.1975bf32@frecb007965>
	<4B177F10.1040908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B177F10.1040908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: Vincent Ficet <jean-vincent.ficet-6ktuUTfB/bM@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, BOURDE CELINE <Celine.Bourde-6ktuUTfB/bM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 03 Dec 2009 11:04:16 +0200
Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> sebastien dugue wrote:
> >   Hi Yevgeny,
> >=20
> > On Thu, 03 Dec 2009 10:01:28 +0200
> > Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> >=20
> >> Sebastien,
> >>
> >> I noticed that you found the problem in IPoIB child=20
> >> interfaces configuration. Glad that this worked out well.=20
> >>
> >> My question is about the note that you left in the issue:
> >>
> >>  " It looks like in 'datagram' mode, the SL weights
> >>    do not seem to be applied, or maybe this is an
> >>    artifact of IPoIB in 'datagram mode' "
> >>
> >> Have you checked that in this mode you do get the right
> >> SL for each child interface by shutting off the relevant
> >> SL (mapping it to VL15)?
> >=20
> >   Yes, SL to VL mapping is OK.
> >=20
> >> If yes, then what you're saying is that you see that
> >> interfaces use the right SL and VL, but you don't see
> >> any arbitration between VLs?
> >=20
> >   Right, whatever the weights I put in the vlarbs tables have absol=
utely
> > no effect when IPoIB is in datagram mode. I don't know if it's
> > an arbitration problem (don't think so) or an IPoIB problem.
> >=20
> >   Could be that due to the 2044 bytes MTU in datagram mode, iperf
> > spends much time not doing transfers and fails to provide enough
> > data to the interfaces. Don't know.
> >=20
> >   Once I switched to connected mode, with a 65520 bytes MTU, things
> > started to work OK with a much better overall combined bandwidth.
>=20
> OK, then "a much better overall combined bandwidth" is an
> answer here. VL arbitration kicks in only when you saturate
> the link. If you don't, there's no point doing arbitration,
> because HW is able so serve any packet that comes w/o the
> need to prioritize.

  Yep, that's the conclusion I came to.

  Might be interesting to find where the bottleneck is though, that
prevents saturating the link.

  S=C3=A9bastien.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
