From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Further thoughts on uAPI
Date: Thu, 21 Apr 2016 17:03:47 +0300
Message-ID: <20160421140347.GI26951@leon.nu>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB044043@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB044043-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2016 at 01:35:53PM +0000, Hefty, Sean wrote:
> > The kernel common code side is pretty straightforward, just a bunch of
> > tables of function pointers, templates and idrs for each object_type.
>=20
> This is the part where the intent and implementation are not clear to me.

The implementation and expected behavior will be easily achieved by the
following pseudo code:

=2E. ioctl call
=2E... pre rdma core hook
---- rdma core code
---- post rdma core hook

Why do you need to mark commands as legacy?

Thanks.

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGN3CAAoJEORje4g2clinkyIQAK+moleZdnZhHER/hukiHqG+
Ul3fSNcrcX73YFN3SoIkD3ClXZgJ5h7w55vGYo40WnlfdG0OkvrhWR1rd4V3SiXo
5Adr/ZGga1NkhQSVrgcBrpvrwfh9r9MUKkGgLFdtC1znCRKAeda3jAndvpg6tp3Z
hdQWC8AXHJ4kwnXpq2LR0jgtvpWUZq6N9T0f8taKK88nGOKfg/gLUCzVn4+Aa94M
bmuwFYi6SB7TCkSXZ9dNqxhhKNstpJeJ0ESBg5BElNz2PqRlg/4W58Lk/xUhRM9L
RYVjcDA6DEx6WN4FPJrTbFeufQvyRbEp3Syjo6gaNlxgkS+wwipVhP5R1M8NWVC4
U7r4c6iBUhM2yfUf8mypd61aqP14F5y2E29Fb06w/EZwOr/bvQKHuyxyYjeBFxGo
dNjCsNYNooZxFU/J+8QNeZIx7X3NOt11XWqjrtS40VjwFEIkZ+pdZahbqpJ8B/Tb
yq57N6PlEs/30HQdh/Y4vkdq0S9GJ5RIjv1hKgi44gGp5L3T/zZAa22jc0d2g9Jq
13ZV0X55JBDYlruI7GNdHRM1BBJJq3FCxyLll8hnD7GzyiSkD575h+FOrEholm61
wHtQFLEpIrgC2FrMMDD5sWXQHEvv+6G5Us3g5yT6M9dlFXpzFVOS0WBKAqsTyO9L
9SNV7S1fDg74aPPw1HrS
=Cdk8
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
