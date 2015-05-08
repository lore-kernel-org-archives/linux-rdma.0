From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] IB/core: Add Core Capability flags to ib_device
Date: Fri, 08 May 2015 16:30:51 -0400
Message-ID: <1431117051.2407.468.camel@redhat.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
	 <1430720099-32512-2-git-send-email-ira.weiny@intel.com>
	 <1430750492.2407.9.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCA17C@ORSMSX109.amr.corp.intel.com>
	 <HE1PR05MB1418E58A6EB92D92B78C76A0B1D10@HE1PR05MB1418.eurprd05.prod.outlook.com>
	 <1431111412.2407.463.camel@redhat.com>
	 <1828884A29C6694DAF28B7E6B8A82373A8FCD719@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-T7dLQCWDDShmgbKf/V+u"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FCD719-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-T7dLQCWDDShmgbKf/V+u
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-05-08 at 20:06 +0000, Hefty, Sean wrote:
> > This is what I have so far:
> >=20
> > On a per device basis: not much to be honest, node_type IB_CA/RNIC for
> > back compatibility and that's pretty much it
> >=20
> > On a per port basis: link layer (Ethernet, IB, or OPA).  Notice that I
> > didn't include the transport here.  Two of the above link layers
> > strictly imply their transport.  The third link layer could have
> > multiple transports.  Which brings me to my next level...
> >=20
> > On a per queue pair basis: if (link_layer =3D=3D Ethernet) iWARP/RoCE/U=
SNIC
> >                          if (qp_type =3D=3D RoCE && qp !=3D UD) RoCEv1/=
RoCEv2
> >=20
> > On a per ah basis: if (qp_type =3D=3D RoCE && qp =3D UD) RoCEv1/RoCEv2
> >=20
> > Michael's patch set was intended to give us a framework within which we
> > can start cleaning things up.  Once we get to cleaning things up, I
> > think the above is where we should target storing the relevant
> > information.
> >=20
> > Thoughts?
>=20
> I'm not following your intent here.
>=20
> The qp_type values are currently defined as RC, UC, UD, XRC, plus some
> weirdness like SMI, GSI.  Are you suggesting that we store the relevant
> information as part of the qp_type, or that we keep the qp_type as-is?

Well, you note I wrote qp !=3D UD, where as that's really the qp_type, so
the above was psuedo code at best.  I was necessarily suggesting where
in the qp data struct to store it, just that even though there isn't
hardware that does this (yet), there's no reason hardware couldn't be
designed to support both iWARP and RoCE and USNIC over the same Ethernet
link layer, and merging the SoftRoCE and SoftiWARP drivers would make a
proof of concept, and so we would *have* to store that information on a
per QP basis.

> =20=0D Once Michael's patches are integrated, do apps need anything else
> beyond the qp type as currently defined?

If you had a device that supported iWARP and RoCE on the same physical
link layer, then yes, the app would need a means of saying which
transport to use in addition to the type of QP to establish.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-T7dLQCWDDShmgbKf/V+u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVTRz7AAoJELgmozMOVy/dv2IP/ibcdG3h+hY+PThjNOeSpLPs
rZIswa0jpMLsHXS0x9QzhHpnxGldiaKZRHdhlAIEyUs+QdDF3PsZc5VD+LCBlCKD
Orp2/m17ajbLeuFDzqKAjixgJ5yMjKOMXZFjpd1ZlnWynFuNZ2MCOWfoQLOjPBwa
LnvyGPXUuGHzMrhuG0LvWiuRQMeazND6Tg85rQ105oiLg98LGfvNZmOnkhms49G+
/ArfVwDnnJ8DoCveLm2jrw0Rwox1SIlD0cd5jTcyOfA6pTOVRHmqqizyZd9ns4eC
TaIyO0/4y5Jml6mvRDS2/67lg/XCDByKSGSzQQEIrFPc8rTGitcfDgbZTbczAddv
iK2ZELGcTtMC61Hnfh14TSgM6dWD0jrAYdLtwW5aO6HAKWYUSHUNZNKa0hvKhh+O
lwkIWOuWNzbxKExYjgv+f60PNGBaRFLdz9XT1nPMzl6FubwosRKaajRsZ88NSKjF
5jyX0pmF2KmzNwEA6mbrlAiTlMiaA+/NY87dqUZpV1CJ+sJKHunbFfrFkC/KAUTT
pLqM2ufbfMdUmDGd5r+dqrD+qRlvbGsg7nf+fBUwhVn1lXUBVI7s9nApk66myDa0
rrcO6GSBu7tvtDI9jWL6n9UAXyInn8mO4wJ51iJsmtht5pzIsIv2dAZl1w2zARfb
0qburNV4uYh3d16G13T7
=Bp3/
-----END PGP SIGNATURE-----

--=-T7dLQCWDDShmgbKf/V+u--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
