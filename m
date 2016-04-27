From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state for
 multicast
Date: Wed, 27 Apr 2016 09:42:39 +0300
Message-ID: <20160427064239.GO7974@leon.nu>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWJEtCrVvH5hpatL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB045BD0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JWJEtCrVvH5hpatL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 26, 2016 at 08:57:08PM +0000, Hefty, Sean wrote:
> > > +* There are 4 types of join states:
> > > +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
> > > +*/
> > > +enum {
> > > +	FULLMEMBER_JOIN,
> > > +	NONMEMBER_JOIN,
> > > +	SENDONLY_NONMEBER_JOIN,
> > > +	SENDONLY_FULLMEMBER_JOIN,
> > > +	NUM_JOIN_MEMBERSHIP_TYPES =3D 4
>=20
> These seem better suited as flags -- fullmember (y/n), sendonly (y/n)=20

Thanks, excellent point.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--JWJEtCrVvH5hpatL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIF9fAAoJEORje4g2clinIgMP+wUMqQQF0PK23XyQn040EqWF
ebeNo5lUKRQkfvHRjWpEsolWA+VKOTBnHEJvMElowiz1D1Q/MjmKbIFZSdptnpt+
9wnF14L43mOxEXeViy0546aa7Tiavozv+34LpzPzA4Bv75CiPJw0jK2rS4VddysQ
swgAThE5ysiblL4IGLpEarz4/EcJEpecNJY+OLGXPwUXiareCCsBSJ/Poh+w5KPg
P+V9Ib3GRosZaXLsPGgQKWhK3ms5aGPGHnG1C2X1f+eIB9OEOGNOjJQKGHZ/kZee
Hm8W3eLmeULnG1+736cYg5z7FSAdesIMF9cXXOaizWqZIKBaZmH3d4bWiaQBoZKB
L+3W8YWksck0FwyECQM7w9aBy2+hjfJznScf4I8RN2CJHw/XUWNhzrZripMBHxP7
0ULMusSIbIeJhncWdOoowILfWMIQ4D3Dm0xzP5NmxoVT7vAlHra7InrD8gnZSaQt
u6pl6tDwMt+v1ojcoHbehzFIhOAGp5SzUg7lpNaJAtUO6AiwCjIEg6Avbz04RCYv
KNKOGZKR4YIWq1nFThZFRRqjBAuXOdBkZBr/X3uEUNoj67HpymdGvO5LA5NYXuBE
x2DPVRufwOVo2mboMGtkNPdgs+L4L3Fl6Bg1ABXItPQy55/sEHamgWd5g7xKn2Uz
V0cGZIiCEyB2hRr4CKZs
=IUqD
-----END PGP SIGNATURE-----

--JWJEtCrVvH5hpatL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
